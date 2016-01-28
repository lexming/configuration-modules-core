# ${license-info}
# ${developer-info}
# ${author-info}

declaration template components/spma/yum/schema;

type component_spma_yum = {
    "userpkgs_retry" : boolean = true
    "fullsearch" : boolean = false
    "excludes"      ? string[] # packages to be excluded from metadata
    "yumconf"       ? string # /etc/yum.conf YUM configuration
    "whitelist"     ? string[] # packages not shipped by repositories but generated by 3rd party installer
    "quattor_os_file" ? string # file to write quattor_os_release as confirmation of successful YUM spma pass
    "quattor_os_release" ? string # string to write to quattor_os_file
    "suffix"        ? string # suffix of alternative packaging module to include instead of standard one
};
