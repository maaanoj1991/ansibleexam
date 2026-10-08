> MODULE [1mcommunity.general.parted[0m (/home/student/ansible/ansibleexam/mycollections/ansible_collections/community/general/plugins/modules/parted.py)

  This module allows configuring block device partition using the
  [1;30m`parted'[0m command line tool. For a full description of the
  fields and the options check the GNU parted manual.

[1mOPTIONS[0m (red indicates it is required):

   [0;33malign[0m   Set alignment for newly created partitions. Use `undefined'
           for parted default alignment.
        choices: [cylinder, minimal, none, optimal, undefined]
        default: optimal
        type: str

   [0;31m[1mdevice[0m[0m  The block device (disk) where to operate.
           Regular files can also be partitioned, but it is
           recommended to create a loopback device using
           [1;30m`losetup'[0m to easily access its partitions.
        type: str

   [0;33mflags[0m   A list of the flags that has to be set on the partition.
        default: null
        elements: str
        type: list

   [0;33mfs_type[0m  If specified and the partition does not exist, sets
            filesystem type to given partition.
            Parameter optional, but see notes below about negative
            `part_start' values.
        default: null
        type: str

   [0;33mlabel[0m   Disk label type or partition table to use.
           If `device' already contains a different label, it is
           changed to `label' and any previous partitions are lost.
           A `name' must be specified for a `gpt' partition table.
        choices: [aix, amiga, bsd, dvh, gpt, loop, mac, msdos, pc98, sun]
        default: msdos
        type: str

   [0;33mname[0m    Sets the name for the partition number (GPT, Mac, MIPS and
           PC98 only).
        default: null
        type: str

   [0;33mnumber[0m  The partition number being affected.
           Required when performing any action on the disk, except
           fetching information.
        default: null
        type: int

   [0;33mpart_end[0m  Where the partition ends as offset from the beginning of
             the disk, that is, the "distance" from the start of the
             disk. Negative numbers specify distance from the end of
             the disk.
             The distance can be specified with all the units
             supported by parted (except compat) and it is case
             sensitive, for example `10GiB', `15%'.
        default: 100%
        type: str

   [0;33mpart_start[0m  Where the partition starts as offset from the beginning
               of the disk, that is, the "distance" from the start of
               the disk. Negative numbers specify distance from the
               end of the disk.
               The distance can be specified with all the units
               supported by parted (except compat) and it is case
               sensitive, for example `10GiB', `15%'.
               Using negative values may require setting of `fs_type'
               (see notes).
        default: 0%
        type: str

   [0;33mpart_type[0m  May be specified only with `label=msdos' or `label=dvh'.
              Neither `part_type' nor `name' may be used with
              `label=sun'.
        choices: [extended, logical, primary]
        default: primary
        type: str

   [0;33mresize[0m  Call [1;30m`resizepart'[0m on existing partitions to
           match the size specified by `part_end'.
        default: false
        type: bool

   [0;33mstate[0m   Whether to create or delete a partition.
           If set to `info' the module only returns the device
           information.
        choices: [absent, present, info]
        default: info
        type: str

   [0;33munit[0m    Selects the current default unit that Parted uses to
           display locations and capacities on the disk and to
           interpret those given by the user if they are not suffixed
           by an unit.
           When fetching information about a disk, it is recommended
           to always specify a unit.
           `unit_preserve_case' controls the case of the units in the
           return values. It used to be all lower case, but using that
           option you can make it return the units textually equal to
           the choices used in `unit'.
        choices: [s, B, KB, KiB, MB, MiB, GB, GiB, TB, TiB, '%', cyl, chs, compact]
        default: KiB
        type: str

   [0;33munit_preserve_case[0m  Controls the case of the `unit' field in the
                       module output (`partition_info.disk.unit',
                       `partition_info.partitions[].unit').
                       When `true', the unit is returned in its
                       original mixed case, for example `KiB' or
                       `MiB'. This matches the values accepted by
                       `unit', making it safe to feed the output back
                       as input.
                       When `false', the unit is returned in lowercase
                       (legacy behavior), for example `kib' or `mib'.
        default: false
        type: bool

[1mATTRIBUTES:[0m

        [4mcheck_mode:[0m
        description: Can run in [1;30m`check_mode'[0m and return changed status prediction without
          modifying target.
        support: full

        [4mdiff_mode:[0m
        description: Returns details on what has changed (or possibly needs changing in [1;30m`check_mode'[0m),
          when in diff mode.
        support: none

[1mNOTES:[0m
      * When fetching information about a new disk and when the
        version of parted installed on the system is before
        version 3.1, the module queries the kernel through
        [1;30m`/sys/'[0m to obtain disk information. In this
        case the units CHS and CYL are not supported.
      * Negative `part_start' start values were rejected if
        `fs_type' was not given. This bug was fixed in parted
        3.2.153. If you want to use negative `part_start',
        specify `fs_type' as well or make sure your system
        contains newer parted.

[1mREQUIREMENTS:[0m  This module requires [1;30m`parted'[0m version
        1.8.3 and above., Option `align' (except
        `undefined') requires [1;30m`parted'[0m 2.1
        or above., If the version of
        [1;30m`parted'[0m is below 3.1, it requires
        a Linux version running the [1;30m`sysfs'[0m
        file system [1;30m`/sys/'[0m., Requires the
        [1;30m`resizepart'[0m command when using the
        `resize' parameter.


[1mAUTHOR[0m: Fabrizio Colonna (@ColOfAbRiX)

[1mEXAMPLES:[0m
- name: Create a new ext4 primary partition
  community.general.parted:
    device: /dev/sdb
    number: 1
    state: present
    fs_type: ext4

- name: Remove partition number 1
  community.general.parted:
    device: /dev/sdb
    number: 1
    state: absent

- name: Create a new primary partition with a size of 1GiB
  community.general.parted:
    device: /dev/sdb
    number: 1
    state: present
    part_end: 1GiB

- name: Create a new primary partition for LVM
  community.general.parted:
    device: /dev/sdb
    number: 2
    flags: [lvm]
    state: present
    part_start: 1GiB

- name: Create a new primary partition with a size of 1GiB at disk's end
  community.general.parted:
    device: /dev/sdb
    number: 3
    state: present
    fs_type: ext3
    part_start: -1GiB

# Example on how to read info and reuse it in subsequent task
- name: Read device information (always use unit when probing)
  community.general.parted: device=/dev/sdb unit=MiB
  register: sdb_info

- name: Remove all partitions from disk
  community.general.parted:
    device: /dev/sdb
    number: '{{ item.num }}'
    state: absent
  loop: '{{ sdb_info.partitions }}'

- name: Extend an existing partition to fill all available space
  community.general.parted:
    device: /dev/sdb
    number: "{{ sdb_info.partitions | length }}"
    part_end: "100%"
    resize: true
    state: present

[1mRETURN VALUES:[0m

   [0;33mdisk[0m    Generic device information.
        returned: success
        sample:
          dev: /dev/sdb
          logical_block: 512
          model: VMware Virtual disk
          physical_block: 512
          size: 5.0
          table: msdos
          unit: GiB
        type: dict

   [0;33mpartitions[0m  List of device partitions.
        elements: dict
        returned: success
        sample: [{begin: 0.0, end: 1.0, flags: [boot, lvm], fstype: '', name: '', num: 1, size: 1.0},
          {begin: 1.0, end: 5.0, flags: [], fstype: '', name: '', num: 2, size: 4.0}]
        type: list

   [0;33mscript[0m  Parted script executed by module.
        returned: success
        sample: 'unit KiB print '
        type: str

