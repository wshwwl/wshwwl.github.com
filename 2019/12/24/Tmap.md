[首页](https://wwl.today)  [关于](https://wwl.today/about.html) 

# STAR-CCM+温度温度分布导入ANSYS classic

[TOC]

## 1 原始温度分布数据

STAR-CCM+导出的温度分布数据如下表，含有节点坐标和温度。

| Temperature (K) | X (m)    | Y (m)    | Z (m)  |
| --------------- | -------- | -------- | ------ |
| 511.3283        | 0.721317 | -0.53667 | 1.1638 |
| 511.4594        | 0.7125   | -0.5275  | 1.1638 |
| 512.3228        | 0.7025   | -0.52753 | 1.1638 |
| 511.8328        | 0.7075   | -0.52753 | 1.1638 |
| ...             | ...      | ...      | ...    |

## 2 导出新模型节点

在ANSYS里根据结构模型划分网格（自己随便画的一个模型），使用以下命令流导出所有节点坐标。

![](.\mesh.png)

```APDL
/prep7
ALLS
*get,ncount,node,,COUNT	!总节点数
*get,nnum,node,,num,MIN	!最小节点编号
*cfopen,'node',csv     	!打开待输出文件
*cfwrite,'nx,ny'	    
*do,i,1,ncount			!依次写入节点坐标
*vwrite,nx(nnum),ny(nnum)
(f12.6,',',f12.6)
nnum=NDNEXT(nnum)
*enddo
*cfclos
```

导出结果如下表所示：

|    nx    |    ny    |
| :------: | :------: |
|   0.9    |    0     |
| 0.899945 | -0.00999 |
| 0.899778 | -0.01998 |
| 0.899501 | -0.02997 |
| 0.899113 | -0.03995 |
|   ...    |   ...    |

## 3 节点温度插值

将上述数据导入Matlab，如下`scatteredInterpolant`函数进行插值：

```matlab
% Xm,Ym,TemperatureK原始温度分布数据，构造插值函数
f=scatteredInterpolant(Xm,Ym,TemperatureK);
% 插值得到新节点的温度值
newTemperature=f(nx,ny);
subplot(1,2,1)
scatter(Xm,Ym,5,TemperatureK,'filled');
axis equal
xlim([-1,1]);
ylim([-1,1]);
subplot(1,2,2);
scatter(nx,ny,5,newTemperature,'filled');
axis equal
xlim([-1,1]);
ylim([-1,1]);
%写入文件
fid=fopen('node_temp.csv','wt');
fprintf(fid,'%f\n',newTemperature);
fclose(fid);
```

得到原始温度分布与新节点的温度分布：

![](.\map.jpg)

## 4 导入节点温度

使用以下命令流再将上述得到的节点温度导入ANSYS：

```APDL
/prep7
ALLS
*get,ncount,node,,COUNT
*get,nnum,node,,num,MIN
*dim,node_temp,array,ncount,1
*vread,node_temp,'node_temp','csv',,ijk
(f12.6)
*do,i,1,ncount
bf,nnum,temp,node_temp(i)
nnum=NDNEXT(nnum)
*enddo
```

得到导入的温度分布如下图所示：

![](.\ansys.png)

## 5 其它

* 如果两种软件使用的模型单位不一样，可以在Matlab内对坐标进行缩放；
* 如果两种软件内模型的方位不一致，可以在Matlab内对坐标进行旋转或者偏移。不过最常见的情况下，只需交换一下xyz坐标即可。