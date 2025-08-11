You might notice some weird things going on with these modules...

For starters: I've opted for a directory-based module layout.
The directory names reflect where the module options can be accessed.
This "root" module, and every child-module, will be accessible under
`config.modules`

So for the example of `/modules/hardware/video/nvidia/default.nix`...
It will be accessible at `config.modules.hardware.video.nvidia`, which is quite 
long, but IMO more organised, and will probably save me some hassle the larger 
the `modules` directory gets.

In order for the options to appear this way, we cant just import child modules 
regularly.

If we were to import the `options` attribute of a child-module, those options 
would be added to the top level of `config`, which means every layer down we go 
this directory structure, the module would have set the `options` 
attribute with a long chain of sub-attributes, e.g: `/modules/foo/bar/baz` 
would have to set: `options.modules.foo.bar.baz` in it's file, which gets 
boring real fast.

This can be fixed by including the child's options in the parent's options: 
```nix
# This file is `/modules/default.nix`
options.modules = {
foo = foo.options;
};
```
```nix
# This file is `/modules/foo/default.nix`
options = {
bar = bar.options;

# options for `foo` goes here
};
```
And so on...

But we still need to include any config changes made by these modules, so the 
parent-module also sets an `imports` attribute containing all of its 
child-modules WITHOUT each child's `options` attribute. we can filter out this 
attribute with: `builtins.removeAttrs <set> [ "options" ]`

Now we have a pretty cool way of organising our modules, but what if we need 
to reference an option set in "module A" from "module B"?

That's why we just pass down `configRoot` (which is just a reference to 
top-level config) to all child-modules.