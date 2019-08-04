{:title       "Dual Boot Arch Linux on Windows 10"
 :layout      :post
 :summary     "
              To successfully dual boot Arch Linux on Windows 10, you will need to
              1) create a bootable USB containing the Antergos iso that can be written using Rufus,
              2) create an Unallocated Partition in Windows 10 by shrinking drive C: using Disk Management
              and 3) disabling Secure Boot on BIOS Setup Options to allow dual booting.
              "
 :excerpt     "This is a brief how-to guide to dual boot Arch Linux on Windows 10."
 :description "A brief how-to guide to dual boot Arch Linux on Windows 10."
 :date        "2019-07-14"
 :tags        ["sysadmin"
               "os"
               "arch-linux"
               "antergos"
               "windows-10"]}

-------------------------------------------------------------------------------

I have been using [Arch Linux](https://www.archlinux.org) OS via the [Antergos](https://antergos.com) distribution for a while.
This is running fine inside a [VirtualBox](https://www.virtualbox.org) VM, until recently, when it started crashing too often and that the hardware specs cannot even help.

And so I decided to abandon this setup completely and start treating Arch Linux as an independent operating system.

-------------------------------------------------------------------------------

Create a bootable USB
---------------------

1. Download and install [Rufus](https://rufus.ie)

2. Download [Antergos Live ISO](https://antergos.com/try-it)
   <br />
   **Note:** For some reason, the `Antergos Minimal ISO` does not work.
   <br />

3. Insert a USB drive that is at least 16 GB of storage

4. Open Rufus and set the following:

   1. `Device` (e.g. `(E:) [32 GB]`)
   2. `Boot selection` (fill by selecting `*.iso` on `SELECT` dropdown, e.g. `antergos-19.4-x86_64.iso`)
   3. `Partition scheme` to `GPT` (the only option that works on UEFI firmware)
   4. Click `START`
   5. On the dialog, select `Write in ISO image mode (Recommended)` then click `OK`
   6. Click `OK` again to confirm and format the USB drive
   7. Click `CLOSE` to close Rufus

-------------------------------------------------------------------------------

Create an Unallocated partition
-------------------------------

1. Press `win`, type `Create and format hard disk partitions` then press enter
2. Right click `Windows (C:)`
3. Select `Shrink Volume...`
4. Set it to at least 20 GB (e.g. `20480`)
5. Click `Shrink`

-------------------------------------------------------------------------------

Disable Secure Boot on BIOS
---------------------------

1. Restart the computer

2. During boot, press `f10` to enter `BIOS Setup Options`

2. Select `System Configuration`

3. Select `Boot Options`

4. Select `Secure Boot` and set it to `Disabled`

5. Select `Clear All Secure Boot Keys`
   <br />
   if prompted, type the confirmation numbers then press `enter`
   <br />

6. Save the settings and restart the computer (press `f10`,  select `[Yes]` then press `enter`)

-------------------------------------------------------------------------------

Run the bootable USB
--------------------

1. Press `win`, type `Change advanced startup options` then press `enter`
2. Under `Advanced startup`, click `Restart now`
3. Under `Choose an option`, click `Use a device`
4. Under `Use a device`, click `USB Drive (UEFI)`
5. During boot selection, select `Antergos Live System (usb)`

Install Antergos
----------------

### Part 1: Update system ###

1. Connect to the internet by clicking the connection icon on upper right corner
2. Open a terminal and do a system update:

   ``` shell
$ sudo pacman -Syu
```
    For `error: failed to update antergos (no servers configured for repository)`,
    see: [Failed to update antergos (no servers configured for repository)](https://forum.antergos.com/topic/8999/failed-to-update-antergos-no-servers-configured-for-repository/2).

### Part 2: Run Cnchi ###

1. Click [Cnchi](https://github.com/Antergos/Cnchi) icon to sync updates (this will also open a dialog)
2. Click `Install It`
3. `Select your location` (e.g. `English (PH), Philippines`)
4. `Select Your Timezone` (e.g. `Berlin, Germany`)
5. `Select Your Keyboard Layout` (e.g. `English (US)`)
6. `Choose Your Desktop` (e.g. `i3`)
7. `Feature Selection` (e.g. `Chromium Web Browser`)
8. `Cache selection (optional)` (skip this one as it's optional)
9. `Mirrors Selection` (skip this one as the recommended choice is already selected)

### Part 3: Configure the partitions ###

**Warning:** This can destroy the existing [Windows](https://www.microsoft.com/en-us/windows) installation if done incorrectly.

1. `Installation Type`
   <br />
   **Only select:** `Choose exactly where Antergos should be installed.`
   <br />

2. `Advanced Installation Mode`:

    - for `Root`:

      - Select the `free space` partition that uses GB (e.g. `20 G`)
      - Click `New`
      - Set `Use As:` to `ext4`
      - Set `Mount Point:` to `/`
      - Set `Format` to checked
      - Click `Apply`

    - for `EFI`:

      - Select the existing `fat32` partition that uses hundred MB (e.g. `273M`)
      - Click `Edit...`
      - Set `Use As:` to `fat32`
      - Set `Label (Optional):` to `ESP`
      - Set `Mount Point:` to `/boot/efi`
      - **Important:** Don't check `Format`
      - Click `Apply`

    - for `Swap`:

      - Select the `free space` partition that uses almost half of RAM (e.g. `7M`)
      - Click `New`
      - Set `Use As:` to `swap`
      - Click `Apply`

### Part 4: Create the user account ###

1. `Create Your User Account` (set desired login credentials)
   <br />
   It will then start syncing updates and install Arch Linux using Antergos' installer.
   <br />

### Part 5: Log In ###

Once the installation is complete, you will be prompted to the log in screen.

Just login then continue on [Setup Arch Linux](setup-arch-linux).
