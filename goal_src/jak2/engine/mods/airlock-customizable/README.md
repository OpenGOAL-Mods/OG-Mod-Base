## Custom Level Support for Airlocks and Doors

This branch implements an approach that allows the use of airlocks and every other door type from the game in custom levels.
It also allows editing every vanilla door’s data through files organized by level inside a folder called `airlock-data`.

**Note:** This system is **disabled by default**. To enable it, go to:
`<ROOT FOLDER>\goal_src\jak2\dgos\game.gd`
Scroll to the bottom of the file and **uncomment all the lines related to `airlock-customizable` and `airlock-data`**, and **comment out** the original `airlock.o` line.

It is also recommended to check how vanilla airlock data are defined in these files, as this helps you understand how they work
and serves as a reference when defining their behavior for your own custom levels.

Below is an example showing **how to add and define airlock entity behavior in a custom level**.

### Getting Started

First, you need to create two levels that connect through an entrance, just like the game does for airlocks and doors.

**Important:** Only one of the two connected levels should be loaded initially.
The other level must remain unloaded, as it will be loaded dynamically by the airlock or door when activated.
This is especially important when choosing to load two different levels connected by an airlock or door.

A vanilla example of this behavior is the **Sewer entrance**. During the first two missions, the sewer door loads `sewerb`.
In the final sewer mission, the same door instead loads `sewesc`. These are two completely different level geometries that are 
conditionally loaded on the other side of the same door depending on game progression.

Following the same approach used by vanilla airlocks and doors, we’ll begin by setting up the airlock.

In the first level, which we’ll call `level-a`, add the airlock art group to the level’s `.gd` file.
For this example, we’ll use the following art group:

`com-airlock-outer-ag`

<img width="1919" height="921" alt="png1" src="https://github.com/user-attachments/assets/47885b06-0a9b-41a6-80a6-e06e9ae8e451" />


Next, add the entity to the custom level’s `.jsonc` file and do the following:

- Set the `etype` to `com-airlock-outer`
- Add the `idle-distance` lump and set it to `["meters", <VALUE_IN_METERS>]`  
  (_Defines the maximum distance at which the airlock becomes active_)
- Add the `distance` lump and set it to `["meters", <VALUE_IN_METERS>]`  
  (_Defines the distance threshold at which the airlock starts opening_)

Example:

<img width="853" height="309" alt="img1" src="https://github.com/user-attachments/assets/7205ec48-7673-44c6-b75c-518280b65ffd" />

For the second level, let’s call it `level-b`, follow the same process as before.
However, this time use a different airlock art group: 

`com-airlock-inner-ag`

<img width="1919" height="919" alt="png2" src="https://github.com/user-attachments/assets/9a8c5538-e1c7-47b8-ae6e-64c8df1a2de5" />

Now, set the `etype` in `level-b` `.jsonc` file to `com-airlock-inner`.

### Defining Airlock Behavior

Now, open the file:
`airlock-customizable-h.gc`

Scroll down to the bottom and copy the following content:

<img width="855" height="322" alt="img2" src="https://github.com/user-attachments/assets/8e976f6d-aba1-41f0-a8d9-57e6c59394fe" />

Inside the `airlock-data` folder, create a new folder called, for example, `my-level`.
Inside it, create two `.gc` files. I recommend using the following naming convention:

`<LEVEL_NAME>-airlock-data.gc`.

In this case, the files would be named `level-a-airlock-data.gc` and `level-b-airlock-data.gc`.

Then, at the top of both files, write `(in-package goal)` and paste the copied content inside each file.
Replace `empty` with the name of the level, matching the file name.

`level-a-airlock-data.gc`

<img width="806" height="305" alt="img3" src="https://github.com/user-attachments/assets/eed460fc-5aa0-4139-8091-7ca343cfaa77" />

`level-b-airlock-data.gc`

<img width="830" height="308" alt="img4" src="https://github.com/user-attachments/assets/8ae0a4a2-b5c6-44e3-b61d-e7ab973576c9" />

These files are used to define the behavior of the airlock entities placed in `level-a` and `level-b`.
You can add as many entries as needed for any airlocks or doors placed in your custom levels.

**Note:** It is recommended to check the `airlock-data` type defined at the top of the file
`airlock-customizable-h.gc`
for a better understanding of what each field shown in the image above does.

Next, you need to define the behavior for the `level-a` airlock to open and load `level-b`, and vice versa.
Now do the following:

- Set `:airlock-name` to the name of the airlock entity used in the level’s `.jsonc` file
- Set `:on-notice` to a pair that specifies which level must be loaded for the airlock to open
  > This is not limited to a simple pair. You may use more complex GOAL logic such as `cond`, `when`, or other conditional expressions,
    as long as the block ultimately evaluates to a valid action like `want-load`, `want-sound`, etc.
    This allows airlocks or doors to be locked behind game events, flags,
    inventory checks, or to conditionally load different levels behind the same entrance.
- Set `:on-activate` to a pair that loads the required levels using `want-load`
- Set `:on-enter` to a pair that displays the required levels using `want-display`, accompanied by the `'display` symbol  
  > You can also use `want-sound` here to load any required sound banks
- Set `:on-exit` to a pair that hides the levels using `want-display`, accompanied by the `#f` symbol

Below is an example:

`level-a-airlock-data.gc`

<img width="881" height="302" alt="img5" src="https://github.com/user-attachments/assets/c6bca55d-6ef9-4765-addd-99d805684474" />

`level-b-airlock-data.gc`

<img width="899" height="311" alt="img8" src="https://github.com/user-attachments/assets/da3f6589-3ed6-4cbc-9393-c42a8b325082" />

You can also optionally define `:on-cross`, `:on-inside`, or `:on-deactivate` for additional behaviors.

**Note:** If you’re still unsure or want more examples, it’s highly recommended to check the vanilla airlock and door data
inside the `airlock-data` folder, as they serve as a reference for defining airlock and door behavior in custom levels.

### Initializing the `airlock-data` Array

Now, you need to initialize the data you set up for the airlock and door entities through the following file:
`airlock-customizable.gc`
At the top of this file, you will find a method called `init-airlock-data-array!`. 
This method is responsible for initializing the `airlock-data` array associated with each airlock or door entity for every level. 
So, in order to do that you must add new `case` entries that match the airlock or door entity name and assign the corresponding `airlock-data` array to each case.
These new cases should be added before the `else` block, as shown below:

`airlock-customizable.gc`

<img width="1178" height="419" alt="img9" src="https://github.com/user-attachments/assets/0bd876bf-87e6-4a93-8fca-eb411bafd1a0" />

### Registering the `airlock-data` Files
After that, go to:

`<ROOT FOLDER>\goal_src\jak2\dgos\game.gd`

Scroll down and add an entry for both created files before `"airlock-customizable.o"`, as shown below:

<img width="904" height="282" alt="img" src="https://github.com/user-attachments/assets/75a2ef24-be0c-4a55-8ac8-3ec595fb5dd8" />

### Setting Up `next-actor` Lump

Finally, you need to set up the `next-actor` lump in both levels’ `.jsonc` files.
This allows the airlock in the level being loaded to open together with the one in the already loaded level.

To do this, add an `aid` (_Actor ID_) to both airlock entities.
Use a high value like `"aid": 100000` to avoid conflicts with other entities.

Then add the `next-actor` lump, structured like this:

`"next-actor": ["uint32", <ID_VALUE>]`

Make sure to add **unique IDs** for every airlock entity in your custom levels.
The `level-a` airlock `next-actor` must point to the `level-b` airlock actor ID, and vice versa.

The result should look like this:

`level-a.jsonc`

<img width="788" height="301" alt="img6" src="https://github.com/user-attachments/assets/0677549e-bf85-4f79-b10c-755a10b8f9bd" />

`level-b.jsonc`

<img width="812" height="268" alt="img7" src="https://github.com/user-attachments/assets/129ebfb3-f8dd-4fcd-8dfd-9a8c374ea4d1" />

After completing this process, rebuild the game and test whether the airlocks work correctly in your custom levels.

_~~Nick07_
