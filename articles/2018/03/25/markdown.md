# Markdown

## Markdown练习与备忘

[comment]:<> "一直没有整理和做笔记的习惯，没有总结总感觉在瞎学，决定使用Markdown来编辑笔记，并将其放在GitHub Pages上，希望自己能坚持下去。"

[comment]:<> "Markddown以前用的不多，下面是一些常用的内容，这里又重新敲了一边，一方面当作是练习，另一方面也可以当作笔记随时翻看。"

## 常用标记

### 标题

```markdown
# 标题1
## 标题2
...
###### 标题6
```

### 区块引用

在每一行前面加上`>`，多个`>`号则为多级引用。

```markdown
>This is a blockquote with three paragraphs. This is first paragraph.
>This is second paragraph.
>
>This is third paragraph.
>>Paragraph with two '>' charaters.
```

效果：

>This is a blockquote with three paragraphs. This is first paragraph.
>
>This is second paragraph.
>
>This is third paragraph.
>
>>Paragraph with two '>' charaters.

### 列表

`* 列表项`、`+ 列表项`、`- 列表项`表示无序列表，`1. 列表项`为有序列表：

```markdown
## 无序列表
* ListItem1
+ ListItem2
- ListItem3
```

它看起来像这样：

* ListItem1
+ ListItem2
- ListItem3

```markdown
## 无序列表
1. ListItem1
2. ListItem2
4. ListItem3
```

它看起来像这样：

1. ListItem1
2. ListItem2
3. ListItem3

```markdown
## 列表里面添加引用
1. ListItem1
      > Blockquote.
3. ListItem2
```

它看起来像这样：

1. ListItem1

	>This is a blockquote.

2. ListItem2

### 任务列表

使用`- [ ] `或者`-[x]`来表示未完成或者完成：

```markdown
- [ ] A task item
- [x] A completed item
- [ ] normal **formatting**
```

它看起来像这样：

- [ ] A task item
- [x] A completed item
- [ ] normal **formatting**

### 代码区块

由```` `包围的内容为代码区块：

```markdown
​```
function test() {
    console.log("Hello world");
}
​```
```

也可以在第一个```` `后面写上语言的名称：

```markdown
​```Javascript
function test() {
    console.log("Hello World");
}
​```
```

它看起来像这样：

```Javascript
function test() {
    console.log("Hello World");
}
```
### 表格

在Markdown里，表格写起来像这样：

```markdown
| First Header | Second Header |
| ------------ | ------------- |
| cell 1 1     | cell 1 2      |
| cell 2 1     | cell 2 2      |
```

它看起来像这样：

| First Header | Second Header |
| ------------ | ------------- |
| cell 1 1     | cell 1 2      |
| cell 2 1     | cell 2 2      |

在第二行（横虚线）可以通过冒号（：）来设置居左、居右、居中：

```markdown
| First Header | Second Header | Third Header |
| :----------- | ------------- | -----------: |
| cell 1 1     | cell 1 2      | cell 1 3     |
| cell 2 1     | cell 2 2      | cell 2 3     |
```

它看起来像这样：

| First Header | Second Header | Third Header |
| :----------- | :-----------: | -----------: |
| cell 1 1     | cell 1 2      | cell 1 3     |
| cell 2 1     | cell 2 2      | cell 2 3     |

### 脚注

```markdown
## 语法
眼睛是心灵的窗户[脚注1].
[^脚注1]:窗户,在建筑学上是指墙或屋顶上建造的洞口，用以使光线或空气进入室内。
```

它看起来像这样：

眼睛是心灵的窗户[^脚注1].

[^脚注1]: 窗户,在建筑学上是指墙或屋顶上建造的洞口，用以使光线或空气进入室内。

### 水平线

`***`或者`---`将绘制一条水平直线。

***

### 链接

要链接的文字使用`[]`包围，后面紧接`()`，内部为要链接的地址。

```markdown 
This is [an example](http://example.com "Title") link with title.
```

它看上去像这样：

This is [an example](http://example.com "Title") link with title.

#### 内部链接

类似于锚。

```markdown
这个[链接](#水平线)将导航到**水平线**章节，无论多少级标题都只写一个#号。
```

它看上去像这样：

这个[链接](#水平线)将导航到**水平线**章节。

#### 参考链接

参考链接的使用如下：

```markdown
This is [an example][id] reference link.
This is [an other][] reference link.
other document text...
[id]:http://example.com "Optional title"
[an other]: http://example.com "Optional title"
```

它看起来像这样：

This is [an example][id] reference link.
This is [an other][] reference link.
other document text...

[id]:http://example.com "Optional title"
[an other]: http://example.com "Optional title"

#### URLs

插入普通的链接路径，使用一对尖括号`<>`。

```markdown
欢迎访问<www.example.com>。
```

欢迎访问<www.example.com>。

### 图片

插入图片的语法：

```markdown
![alt text](path)
![alt text](/path/img.jpg)
![alt text](http://wx2.sinaimg.cn/large/0075Res4gy1fpp2pgigsqj30sg0k6aax.jpg)
```

![alt text](http://wx2.sinaimg.cn/large/0075Res4gy1fpp2pgigsqj30sg0k6aax.jpg)

### 强调

使用`*`或者`_`表示强调，推荐使用`*`号。他们在HTML中生成`<em>`标签：

```markdown
*single asterisks*
_single underscores_
```

它看起来像这样：

*single asterisks*
_single underscores_

使用`**`或者`__`表示强调，推荐使用`**`号，他们在HTML中生成`<strong>`标签：

```markdown
**double asterisks**
__double underscores__
```

它看起来像这样：

**double asterisks**
__double underscores__

### 代码

使用`` `来包含行内的代码。

### 删除线

使用`~~`来绘制删除线：

`~~要删除的字~~`显示为~~要删除的字~~

### 下划线

`<u>下划线</u>`显示为 <u>下划线</u>

