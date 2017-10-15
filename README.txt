--------------
CSP AHK Script
--------------

Clip Studio Paint is a powerful drawing software, but it lacks one thing that would make it a great asset for 
indie game artists who use Spriter or Spine to animate: Export Selected Layers as PNG files.

Luckily, there is a workaround to solve this issue:

1. Export the layers as a layered PSD file.
2. Use ImageMagick to convert the layered PSD file to PNG files.

There is one problem. Exporting a group layer within PSD files as a PNG file is extremely hard. IMHO, the best 
way to solve this issue is to merge the group layer as a new layer, then you export it as a layered PSD. But, 
with this approach, you will lose the group layer, and if you want to edit that layer, you need to undo your 
changes. A safer way to merge is:

1. Merge the selected layers or a group layer as a new layer.
2. Copy the new layer.
3. Undo the changes.
4. Paste the new layer.
5. Additionally, you can send the new layer to top, to make your layers more organized.
6. Optionally, rename the new layer, and give a meaningful name (For example: p_view_r_hand for Right Hand in
   Profile View)

But this approach is a time wasting process. You could probably record the process as an action and assign a 
shortcut to that action. I imagine, it can be quite difficult to do so. 

CSP AHK Script solves this problem by adding two important features to Clip Studio Paint.

1. PSD Layers to PNG Files Converter.
2. Copy and Merge Selected Layers as a New Layer.

Note: To open this file, enter [Ctrl][Alt][Shift][H]

---------------------------------
PSD Layers to PNG Files Converter
---------------------------------

Requirement?

ImageMagick must be installed on your system.
   
How to use?

Go to where your PSD files are located in File Explorer and enter [Ctrl][Alt][Shift][C]. Select the file you want
to convert, and hit [Convert] button

---------------------------------------------
Copy and Merge Selected Layers as a New Layer
---------------------------------------------

Requirement?

You need to configure your Clip Studio Paint's Shortcuts at least once.

To Configure:

1. Open your Clip Studio Paint.
2. Go to Shortcut Settings and click Okay.
3. Restart Clip Studio Paint.
4. Reload this script (Alternatively, you can enter [Ctrl][Alt][Shift][R] to reload).

Configure the shortcut keys for the following features will improve the merging process:

1. Layer Order Top [Highly Recommended].
   This feature will automatically send new layer to the top.

2. Show Layer.
   This feature will hide your new layer, so it won't interfere with your original work.

3. Set As Draft Layer.
   This feature will Un-Draft your new layer when your selected layers are Draft Layers. The reason you want to set 
   the selected layers or a group layer as Draft Layer is to prevent them from being included in the PSD file.

4. Change Layer Name [Highly Recommended].
   This feature will allow you to give a new name to your new layer.

How to use?

Select the layers you want to merge in Clip Studio Paint and enter [Ctrl][Alt][Shift][M]

---------------------------------
Activate Clip Studio Paint Window
---------------------------------

Requirement?

Clip Studio Paint must be running.

How to use?

Enter [Ctrl][Alt][Shift][A]. Quite useful if you want to return to Clip Studio Paint to fix your artworks.

-------
CREDITS
-------

This script uses IsNull's AHK DBA Script (https://github.com/IsNull/ahkDBA) to load Clip Studio Paint's shortcuts.