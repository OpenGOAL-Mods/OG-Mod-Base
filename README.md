> [!NOTE]
> You can read the original README for the OpenGOAL project [here](https://github.com/open-goal/jak-project/blob/master/README.md).

# OpenGoal-Mod-Base
Serves as a base template for openGOAL mods that will be supported via [OG-ModLauncher](https://github.com/OpenGOAL-Mods/OG-ModLauncher).

- Please ensure you are not committing copyrighted material to your repo (the `.gitignore` should help prevent this). 
- Generally speaking you should only be updating certain directories/files:
  - GOAL code (`/goal_src`)
  - Assets specific to the PC Port (`/game/assets/jak1/`, `/custom_assets/`)
  - The executable binaries (`/out/build/Release/goalc.exe`, `/out/build/Release/gk.exe`, `/out/build/Release/extractor.exe`)
  - Decompiler config (`/decompiler/config`)

## Custom Navmesh Implementation and Example

LuminarLight made changes that allow placing custom navmesh into Jak 1 levels. This will hopefully become useless one day, if proper navmesh support is ever added to OpenGOAL.

The navmesh system in Jak II is more advanced, I haven't managed to figure it out yet.

### Getting Started

Please keep in mind that you are expected to be familiar with custom levels and GOAL. Still, I tried to make things as understandable as possible.

I would recommend copying an existing navmesh as a start. You can use the inspect method I made. The actor whose navmesh you want to copy must be loaded. Example:
`(inspect (-> (the-as entity-actor (entity-by-name "snow-bunny-55")) nav-mesh))`

You should change the origin and bounds, depending on where you want to place your navmesh.

I usually just remove the nodes, because I do not understand it and things seem fine without it. But keep in mind that every navmesh that is in the game has at least one node.

We do not understand route, but it is needed - otherwise game will crash. If you copy an existing navmesh, the route data is copied correctly. But since we don't understand it, for fully custom navmesh we can never have proper route data. Correct route data is essential if you want to take advantage of gap triangles (where enemies jump).

You can make multiple enemies use the same navmesh. To do this, create the navmesh through code for the first actor, like in the example. And for the other actors, add a lump that tells the game to use another actor's navmesh. Reference is by aid. Example: `"nav-mesh-actor": ["uint32", 40000]`. Tip: You can do the same thing with paths, using the `path-actor` lump.

If the game crashes when you approach a custom navmesh, make sure you added `:custom-hacky? #t` to your custom navmesh definition. If that is there, then check if the actor has a path. It needs a path.

If something is still unclear, please look at the code. I added a lot of comments.

### Final Words

I am not an expert at decompiling, so my methods were not the most efficient. But with a lot of time, I managed to figure things out. There are probably people who could do this a lot better than me. Hopefully it will happen.

Also, I know my inspect method is not perfect. But it is very tedious to write such a thing, so I just included what we really need. And I think the nodes part could use a cleanup.

I am happy if anyone finds this useful. But I have a request: If you learn more about navmeshes, especially things that would benefit other modders as well, please let me know. And maybe we will add it to this branch.

*~~Luminar Light*
