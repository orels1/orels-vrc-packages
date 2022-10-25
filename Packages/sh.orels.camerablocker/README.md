# Camera Blocker

This is a simple Unity Shader that is meant to be used in VRChat worlds to block player cameras of looking somewhere they shouldn't be.


https://user-images.githubusercontent.com/3798928/197785427-94479780-8a60-447b-ac6e-3f04de9d9b0f.mp4


## Installation

- [Download the package](https://orels1.github.io/orels-vrc-packages/) and follow the [instructions here](https://github.com/orels1/orels-vrc-packages#installation)
- Once unpacked, proceed to the [Usage](#usage) section

## Usage

- Drag and Drop the Camera Blocker Container prefab from `Runtime` folder into your scene
- Position and scale to fit around the area you want to be hidden
- There is a visualizer cube in the prefab which gets removed on building your world, you can keep it if it helps you position the object, or disable it if you don't need it

## Details

- The prefab, by default, exists on the `Player` layer, that is most likely what you want, as usually, as a world creator, you don't want people spying on others using drone cameras or personal mirrors.
- There are 3 parts to the prefab:
  - Blocker Writer
  - Blocker Clearer
  - Camera Blocker
  - You want to make sure that all of them are present, and that the Writer is always contained by the Clearer, otherwise the blocker can be overwriting things you don't want to be blocked. If you just dragged and drop the prefab - you should be fine as is.
- You can replace the blocker meshes if you need (by default they use  unity cubes), but make sure that the normals of the mesh point in the same direction as the unity cube (outwards), or the blocker will work the wrong way around!

## Technical Details

- The core idea is to render over everything but only INSIDE some area, which is a bit more non-trivial than you might think. So I decided to use stencils to make it work
- Blocker Writer writes stencil id 69 over everything while being completely transparent and invisible to anything but the handheld cameras. It uses Cull Front to only render the backfaces (as I'm using the detault cube mesh which has normals facing outward
- Blocker Clearer renders one render queue later and writes stencil id 0 onto everything. It is also a default cube with Cull Back, so when looking from the outside, it will replace all those written 69s with 0s
- Finally, blocker uses stencil id 69 to determine if it should render. If the stencil id is anything but 69 it will not render anything. It is rendered last in the order
- All shaders have ZTest Always which make them always render on top of everything so that stencil ids propagate orrectly
- All shaders assign NaN to vertex position (to skip rendering completely) whenever the current camera is anything but the handheld cam

## Join my discord

[If you have any questions or bugs - please join my discord](https://discord.gg/orels1)
