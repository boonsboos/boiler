module util

import v.vmod

const nal_module_file = vmod.decode(@VMOD_FILE) or { panic(err) }
const usage = "nal compiler v${nal_module_file.version}
---------------------------------
usage: nal [options] [file.nal]

options:
    - com: compiles whatever file you supply it
"

pub fn print_usage() { println(usage) }