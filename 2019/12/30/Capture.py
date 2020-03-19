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


