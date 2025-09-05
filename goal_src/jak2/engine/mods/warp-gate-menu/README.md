## Air Train / Warp Gate Destination Menu System

This branch implements a menu system that allows you to select and teleport to a destination using any Air Train or Warp Gate in the game.  
It also supports adding custom destination menus for Air Trains and Warp Gates in your own custom levels.

**Note:** This system is **disabled by default**. To enable it, go to:
`<ROOT FOLDER>\goal_src\jak2\dgos\game.gd`
Scroll to the bottom of the file and **uncomment all the lines related to the menu system**, and **comment out** the original `warp-gate.gc` line.

The image below highlights the files that need to be uncommented:

![png1](https://github.com/user-attachments/assets/05f5354d-af71-45eb-bc5e-2331816466ba)

Below are two examples: one showing **how to add new options to existing menus for Air Trains**, and another demonstrating **how to assign a new menu to an Air Train entity placed in a custom level**.

### 1. How to add new options to existing menus for Air Trains

#### 1.1. Open the Menu Definitions File
Go to: 
`<ROOT FOLDER>\goal_src\jak2\engine\mods\air-train-menu\air-train-menu-h.gc` 
After opening this file, you will see this:

![png1](https://github.com/user-attachments/assets/b67f0c90-62e4-4a5c-bba9-b1f0f80eb132)

As you can see, this file defines the Air Train destination menus for all vanilla entities. 
 
Just below that, you’ll find the definition for `*air-train-1-menu-list*`, which in this case defines a menu with only two destination options: `Landing Pad` and `Metal Head Nest` for the Haven City Port Air Train. 

#### 1.2. Add a New Entry for Sandover Village (Example)
Now, let’s suppose you want to add a new destination where Jak can be teleported to **Sandover Village**.  
To do this, simply copy one of the existing entries and paste it below them.

Then adjust the values as follows:
- Set the `level-name` to `'village1`
- Set the `continue-name` to `"village1-start"` (the name of the checkpoint Jak will warp to)
- Set `allow-when` to `#f` if you don’t want to restrict it to a specific task
- Leave `on-activate` empty or remove it if no action is needed

You should end up with something like this:  

![png2](https://github.com/user-attachments/assets/0cf86c61-f4df-4357-bf32-24c12c30a6ac)

#### 1.3. Add the Display Text

Now, for the `text-id`, you’ll need to add a new text entry so that the option appears as **Sandover Village** instead of reusing a label like `Metal Head Nest`.

Go to:  
`<ROOT FOLDER>\game\assets\jak2\text\game_custom_text_en-US.json`  
Scroll to the end and add:

![png3](https://github.com/user-attachments/assets/a0db86e5-ce16-45d0-a0e8-79ed1cc5b456)

Then go to:  
`<ROOT FOLDER>\goal_src\jak2\engine\ui\text-id-h.gc`  
Scroll down and add the corresponding `text-id` constant:

![png1](https://github.com/user-attachments/assets/2596f7db-df3c-4fc5-a2f9-5403e17eae1c)

Finally, go back to:  
`<ROOT FOLDER>\goal_src\jak2\engine\mods\air-train-menu\air-train-menu-h.gc`  
and update the entry to use your new `text-id`:

![png2](https://github.com/user-attachments/assets/771bede9-7852-45a4-a9a4-7fbb291d6276)

#### 1.4. Test in Game

Once you’ve done all this, rebuild the game and head to the Haven City Port Air Train to test your new destination!

![png1](https://github.com/user-attachments/assets/96618b44-1215-4939-86ea-e08c3d77634a)
![png2](https://github.com/user-attachments/assets/bf3ef364-b43f-4a74-9ae1-2938b137cecf)

### 2. How to assign a new menu to an Air Train entity placed in a custom level

Now, let’s say you want to create a new menu and assign it to an Air Train entity placed in your custom level. The process is similar to the previous one, but this time you’ll define a new menu list in `air-train-menu-h.gc`.

**Note:** This example uses the custom level `test-zone`.

#### 2.1. Create a New Menu List

Define a simple menu list like this:

![png1](https://github.com/user-attachments/assets/c011e2ab-09ff-48df-aab2-b536e44ad9e7)

In this example, Jak will be able to teleport to `Haven City Port`.

#### 2.2. Add a Return Option to an Existing Menu

To allow Jak to return to your custom level, add a new entry to `*air-train-1-menu-list*` (Haven City Port Air Train):

![png2](https://github.com/user-attachments/assets/f7d7884e-605c-487f-9f78-1249c604283f)

Also, make sure to add a new text entry, so the option appears with your custom level's name, following the same process from the previous example.

#### 2.3. Place the Entity in Your Custom Level

Next, in your custom level `.jsonc` file, add the Air Train entity like this:

![png3](https://github.com/user-attachments/assets/adfe7567-3a3b-4d22-bb26-fbf03615b818)

**Note:** Make sure to include `air-train-ag.go` in your custom level’s `.gd` file. Also, don’t forget to set the `"distance"` lump to define how close Jak needs to be to interact with the Air Train.

#### 2.4. Assign the Menu to the Entity

Go to:
 `<ROOT FOLDER>\goal_src\jak2\engine\mods\warp-gate-menu\warp-gate-menu-data.gc`
Scroll down to the `setup-fields` method of the `air-train` type:

![png1](https://github.com/user-attachments/assets/39d50276-6df6-4a99-9291-5ef913c133cf)

Then, add a new case with the name of the Air Train entity you placed in your custom level:

![png2](https://github.com/user-attachments/assets/3607ef4a-9f4a-4fec-b12a-9f5a4de84b26)

#### 2.5. Test in Game

Once you’ve done all this, rebuild the game and head to the Haven City Port Air Train. You should now be able to teleport to your custom level and test your custom menu!

![png1](https://github.com/user-attachments/assets/ace00970-69b3-4737-abf0-1ceb63d19ce0)
![png2](https://github.com/user-attachments/assets/d6124fe5-0619-4ee5-9818-7c24e47b1c55)

**Note:**  The logic is the same for Warp Gates. However, to add new entries or menus, go to: `<ROOT FOLDER>\goal_src\jak2\engine\mods\warp-gate-menu\warp-gate-menu-h.gc`. To assign a menu to a Warp Gate entity, edit the `setup-fields` method of the `warp-gate` type in: `<ROOT FOLDER>\goal_src\jak2\engine\mods\warp-gate-menu\warp-gate-menu-data.gc`

I hope this contributes to the development of your mods!

*~~Nick07*
