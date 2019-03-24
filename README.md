# Use vim to Edit JSON as YAML

YAML is a superset of JSON :-)

In general YAML is easier to edit then JSON.

* It's more forgiving of formatting
* No need for quoting every attribute and value

In short, YAML is meant to be written by hand, JSON by programs. But it's not
uncommon to create and edit JSON files by hand, often to configure other
applications. This plugin helps me in that task. FWIW, my particular driver was
JSON config for projectionist, but I believe this to be more generally useful.

It exposes a single command in a JSON file, ``EditAsyaml`` which:

* opens a memory only vertical split with a YAML version of the JSON
* Allows toggling between YAML and JSON versions
* Set's vim diff view against the original when the scratch buffer is in JSON
  mode
* Allows writeback to the original buffer (via FileWriteCmd events).

## Caveats

It uses a short bit of python3 to do the heavy lifting. This is external (and
bundled in the plugin) to minimize (but not entirely avoid) dependencies. Vim's
support for JSON is solid, but YAML support is not vim's strength.

Python 3 is quite common install, likely to be present on many systems, even
those where vim does not have formal python3 support. That said, I'm looking
for alternatives.

The end JSON is normalized by alphabatizing keys. This eases the job of
translation, but it could conceivably effect carefully hand crafted ordering.

