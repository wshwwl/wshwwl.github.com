[首页](https://wwl.today)  [关于](https://wwl.today/about.html) 

# Python自动翻页截图脚本

经常碰到远程服务器或很多网页上的文件只能看，不能下载的情况，发现有的同事一页一页的截图，而有的文件动不动就几百页，截到吐血。找了一下相关的库，写了一个脚本，可以实现自动翻页，翻页之后自动截图，虽然很粗糙，但工作的很好，给了很多同事使用。

基本的过程就是通过调用`Window API` 发送鼠标或者键盘消息，控制`PDF`文件或者网页翻页，然后依次截图保存。这里发送的消息包括鼠标滚轮滚动或者鼠标点击消息，分别用于滚轮翻页和点击特定按钮翻页的情况。为实现鼠标或键盘控制程序的运行，使用了`pyHook`监听鼠标或键盘消息。

使用的库包括：`pywin32`、`pyhook`、`PIL`。

使用过程为：

1. 程序运行后，点击鼠标右键开始选择截图范围，若点击右键并滑动鼠标则退出程序；
2. 鼠标左键点击两次决定截图的矩形区域，两次点击的区域为矩形的对角点；
3. 可再次点击左键两次重新选择截图区域；
4. 矩形区域确定后，点击鼠标中键开始自动截图，在脚本所在目录自动创建编号递增的文件夹，存储图片；
5. 若相邻两次截图一致，则认为截至文件末尾，程序停止；
6. 可根据界面刷新速度设置两次截图的时间间隔；

代码如下：

```python
# -*- coding: utf-8 -*-
import pyHook
import time
import win32api
import win32con
import os
from PIL import ImageGrab
from PIL import ImageChops
import Image
import pythoncom

getRectStarted =False
captureStarted=False
RightDown=False
MouseMoved=False
mouseClickedTimes=0
mouseClickLocation1=(0,0)
mouseClickLocation2=(0,0)
captureStep=1
def OnMouseLeftDownEvent(event):
  global mouseClickedTimes,mouseClickLocation1,mouseClickLocation2
  if getRectStarted:
    if mouseClickedTimes==0:
      mouseClickedTimes=1
      mouseClickLocation1=event.Position
    else:
      mouseClickedTimes=0
      mouseClickLocation2=event.Position
    return False
  return True
def OnMouseLeftUpEvent(event):
  pass
  return True
def OnMouseRightDownEvent(event):
  global RightDown
  RightDown=True
  return False
def OnMouseRightUpEvent(event):
  global getRectStarted,mouseClickedTimes,mouseClickLocation1,mouseClickLocation2,RightDown
  getRectStarted=True
  mouseClickedTimes=0
  mouseClickLocation1=(0,0)
  mouseClickLocation2=(0,0)
  RightDown=False
  print u'两次单击左键选择矩形截取区域...'
  return False
def OnMouseMiddleDownEvent(event):
  global captureStarted
  hm.UnhookMouse()
  win32api.PostQuitMessage()
  captureStarted=True
  return False
def OnMouseMoveEvent(event):
  global RightDown
  if RightDown:
    hm.UnhookMouse()
    win32api.PostQuitMessage()
    RightDown=False
  return True

# create the hook mananger
hm = pyHook.HookManager()
# register callbacks
hm.MouseLeftDown = OnMouseLeftDownEvent
hm.MouseRightDown = OnMouseRightDownEvent
hm.MouseRightUp = OnMouseRightUpEvent
hm.MouseMiddleDown = OnMouseMiddleDownEvent
hm.MouseMove = OnMouseMoveEvent

hm.HookMouse()
##hm.HookKeyboard()
def GetRect():
    global mouseClickLocation2,mouseClickLocation1
    if mouseClickLocation1==(0,0) and mouseClickLocation2==(0,0):
        mouseClickLocation2=(500,500)
    left=min(mouseClickLocation1[0],mouseClickLocation2[0])
    right=max(mouseClickLocation1[0],mouseClickLocation2[0])
    up=min(mouseClickLocation1[1],mouseClickLocation2[1])
    down=max(mouseClickLocation1[1],mouseClickLocation2[1])
    return (left,up,right,down)

def GetPath():
    pathn=os.path.abspath('.')
    i=1
    while 1:
      path=pathn+'\\Captures%s\\' %i
      if not os.path.exists(path):
        os.mkdir(path)
        return path
        break
      else:
        i=i+1  

def CaptureByWheel():
    if not captureStarted:
        return
    bbox=GetRect()
    savedPath=GetPath()
    i=1
    im=ImageGrab.grab(bbox)
    im.save(savedPath+'capture%s.png' %i,'png')    
    while 1:
        i=i+1
        win32api.mouse_event(win32con.MOUSEEVENTF_WHEEL,0,0,-120)
        time.sleep(captureStep)
        im_temp=im
        im=ImageGrab.grab(bbox)
        diff=ImageChops.difference(im_temp,im)
        if diff.getbbox() is None:
            print 'caption done!'
            return
        else:
            im.save(savedPath+'capture%s.png' %i,'png')

def captureByClick():
    if not captureStarted:
        return
    bbox=GetRect()
    savedPath=GetPath()
    i=1
    im=ImageGrab.grab(bbox)
    im.save(savedPath+'capture%s.png' %i,'png')   
    while 1:
        i=i+1
        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN,0,0,0)
        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP,0,0,0)
        time.sleep(captureStep)
        im_temp=im
        im=ImageGrab.grab(bbox)
        diff=ImageChops.difference(im_temp,im)
        if diff.getbbox() is None:
            print 'caption done!'
            return
        else:
            im.save(savedPath+'capture%s.png' %i,'png')

def turnblack(ref):
    if savedPath=='':
      return
    print 'turning...'
    pngs=[os.path.join(savedPath,x) for x in os.listdir(savedPath) if os.path.isfile(os.path.join(savedPath,x)) and os.path.splitext(x)[1]=='.png']
    for png in pngs:
      im=Image.open(png)
      im=im.point(lambda x:255 if x>ref else 0)
      im=im.convert("1")
      im.save(png,'png')

if __name__ == '__main__':
  print u'单击右键选取截取区域...'
  pythoncom.PumpMessages()
  capture3()
  exit()
##  turnblack(200)
```

