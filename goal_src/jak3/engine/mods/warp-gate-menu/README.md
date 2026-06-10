## Air Train / Warp Gate Destination Menu System

This branch implements a menu system that allows you to select and teleport to a destination using any Air Train or Warp Gate in the game.  
It also supports adding custom destination menus for Air Trains and Warp Gates in your own custom levels.

**Note:** This system is **disabled by default**. To enable it, go to:
`<ROOT FOLDER>\goal_src\jak3\dgos\game.gd`
Scroll to the bottom of the file and **uncomment all the lines related to the menu system**, and **comment out** the original `warp-gate.gc` line.

The image below highlights the files that need to be uncommented:

<img width="1161" height="465" alt="img1" src="https://github.com/user-attachments/assets/8ff658af-0f3e-4a7e-a6d2-649e353f9274" />

Below are two examples: one showing **how to add new options to existing menus for Air Trains**, and another demonstrating **how to assign a new menu to an Air Train entity placed in a custom level**.

### 1. How to add new options to existing menus for Air Trains

#### 1.1. Open the Menu Definitions File
Go to: 
`<ROOT FOLDER>\goal_src\jak3\engine\mods\air-train-menu\air-train-menu-h.gc` 
After opening this file, you will see this:

<img width="1246" height="919" alt="img2" src="https://github.com/user-attachments/assets/f65239e9-39ad-4e0c-b84d-5e472fe00098" />

As you can see, this file defines the Air Train destination menus for all vanilla entities. 
 
Just below that, you’ll find the definition for `*air-train-1-menu-data*`, which in this case defines a menu with only one destination option: `Desert Wasteland` for the Haven City Port Air Train. 

#### 1.2. Add a New Entry for Eco Mine (Example)
Now, let’s suppose you want to add a new destination where Jak can be teleported to **Eco Mine**.  
To do this, simply copy the existing entry and paste it below.

Then adjust the values as follows:
- Set the `level-name` to `'minec`
- Set the `continue-name` to `"minec-start"` (the name of the checkpoint Jak will warp to)
- Set `allow-when` to `#f` if you don’t want to restrict it to a specific task
- Leave `on-activate` empty or remove it if no action is needed

You should end up with something like this:  

<img width="1053" height="462" alt="img3" src="https://github.com/user-attachments/assets/7009897b-6fc2-4bec-ae69-c96304a7a82e" />

#### 1.3. Add the Display Text

Now, for the `text-id`, you’ll need to add a new text entry so that the option appears as **Eco Mine** instead of reusing a label like `Desert Wasteland`.

Go to:  
`<ROOT FOLDER>\game\assets\jak3\text\game_custom_text_en-US.json`  
Scroll to the end and add:

<img width="676" height="306" alt="img4" src="https://github.com/user-attachments/assets/ec222c3f-a823-4888-93c4-30729e23df04" />

Then go to:  
`<ROOT FOLDER>\goal_src\jak3\engine\ui\text-h.gc`  
Scroll down and add the corresponding `text-id` constant:

<img width="621" height="361" alt="img5" src="https://github.com/user-attachments/assets/15d497b0-40a7-4420-af72-74045bda19c7" />

Finally, go back to:  
`<ROOT FOLDER>\goal_src\jak3\engine\mods\air-train-menu\air-train-menu-h.gc`  
and update the entry to use your new `text-id`:

<img width="612" height="246" alt="img6" src="https://github.com/user-attachments/assets/36fa6a86-8e0f-4d08-b2a9-09d0143c1b9b" />

#### 1.4. Test in Game

Once you’ve done all this, rebuild the game and head to the Haven City Port Air Train to test your new destination!

<img width="1919" height="1053" alt="img7" src="https://github.com/user-attachments/assets/37989016-b127-4bb7-9c73-fd0812440d0c" />
<img width="1919" height="1033" alt="img8" src="https://github.com/user-attachments/assets/673e4b47-1bc8-4aff-b011-f9dd85278f0e" />

### 2. How to assign a new menu to an Air Train entity placed in a custom level

Now, let’s say you want to create a new menu and assign it to an Air Train entity placed in your custom level. The process is similar to the previous one, but this time you’ll define a new menu list in `air-train-menu-h.gc`.

**Note:** This example uses the custom level `test-zone`.

#### 2.1. Create a New Menu Data

Define a simple menu list like this:

<img width="1304" height="592" alt="img9" src="https://github.com/user-attachments/assets/9bcc6971-5094-4f5f-af5d-4b9d7c5183b3" />

In this example, Jak will be able to teleport to `Haven City Port`.

#### 2.2. Add a Return Option to an Existing Menu

To allow Jak to return to your custom level, add a new entry to `*air-train-1-menu-data*` (Haven City Port Air Train):

<img width="1114" height="614" alt="img10" src="https://github.com/user-attachments/assets/a13eab90-3ad4-41b3-9169-9c4e08f8ad3d" />

Also, make sure to add a new text entry, so the option appears with your custom level's name, following the same process from the previous example.

#### 2.3. Place the Entity in Your Custom Level

Next, in your custom level `.jsonc` file, add the Air Train entity like this:

<img width="888" height="480" alt="img11" src="https://github.com/user-attachments/assets/bbacec20-a1e3-4cdd-a75c-4890f6361dc8" />

**Note:** Make sure to include `air-train-ag.go` in your custom level’s `.gd` file. Also, don’t forget to set the `"distance"` lump to define how close Jak needs to be to interact with the Air Train.

#### 2.4. Assign the Menu to the Entity

Go to:
 `<ROOT FOLDER>\goal_src\jak3\engine\mods\warp-gate-menu\warp-gate-menu-data.gc`
Scroll down to the `init-defaults!` method of the `air-train` type:

<img width="1286" height="782" alt="img12" src="https://github.com/user-attachments/assets/3edc32a9-ab62-4036-bf1c-a57632b4280c" />

Then, add a new case with the name of the Air Train entity you placed in your custom level:

<img width="1213" height="840" alt="img13" src="https://github.com/user-attachments/assets/edb4d65d-9192-4419-a2ec-40d639614831" />

#### 2.5. Test in Game

Once you’ve done all this, rebuild the game and head to the Haven City Port Air Train. You should now be able to teleport to your custom level and test your custom menu!

<img width="1919" height="982" alt="img14" src="https://github.com/user-attachments/assets/27734f9f-9a48-41ff-b0b3-a79f7c71bfe4" />
<img width="1918" height="983" alt="img15" src="https://github.com/user-attachments/assets/e9d598a4-67c3-4994-9a00-141903aa0066" />

**Note:**  The logic is the same for Warp Gates. However, to add new entries or menus, go to: `<ROOT FOLDER>\goal_src\jak3\engine\mods\warp-gate-menu\warp-gate-menu-h.gc`. To assign a menu to a Warp Gate entity, edit the `init-defaults!` method of the `warp-gate` type in: `<ROOT FOLDER>\goal_src\jak3\engine\mods\warp-gate-menu\warp-gate-menu-data.gc`

I hope this contributes to the development of your mods!

*~~Nick07*
