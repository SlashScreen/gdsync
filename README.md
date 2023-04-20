GDsync is an extremely rudimentary tool for Godot that will automatically sync your addons with a remote repository, so long as they are described in a `addons.yaml` file.  
This tool may be better off redone as a GDExtension tool, rather than a ruby file.

## How to use

The current way to use this is:  

1. Install Ruby.
2. Drag in `sync.rb` and `Gemfile` into your `res://` folder.
3. Create an `addons.yaml` file - format described below.
4. In the console in your `res://` folder, run `ruby sync.ruby` and give it a second.

If any of the addon repos have an `addons.yaml` file in their root as well, it will also execute that.

## addons.yaml

The format for `addons.yaml` is as follows:

```yaml
Addon Name: # Repo name as it would appear if you were to clone it.
  repo: git@repo.git # Git URI.
  src_folder: addons/addon_name # The folder in the repo where the addon is- usually in the addons folder. 
  dest_folder: addons # Your addons folder- usually addons.
```

see `addons.yaml` for an example.
