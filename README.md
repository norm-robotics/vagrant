# Norm Robotics / Vagrant
## What is Vagrant?
Vagrant is "...the command line utility for managing the lifecycle of virtual machines."

Think of Docker, but more tailored towards setting up virtual machines. We're using Vagrant this year to
create a consistent development experience across all platforms - MacOS, Linux, Windows.

## Usage
### Install Git
#### Windows
Visit [here](https://git-scm.com/downloads), and click the download button for `Windows`. Don't change any of
the settings in the installer - the defaults are already pretty good.
#### MacOS
You should already have `git` installed. If not, install Git via Homebrew:
```brew install git```
#### Linux
You (probably) already have `git` installed. Use your favorite package manager to install it, if not.

### Install Vagrant
#### Windows
Visit [here](https://developer.hashicorp.com/vagrant/downloads), and download the `AMD64` version for Windows.
#### MacOS
Install Vagrant via Homebrew:
```
brew install hashicorp/tap/hashicorp-vagrant
```
#### Linux
Install Vagrant via your favorite package manager. Or follow the instructions [here](https://developer.hashicorp.com/vagrant/downloads).

### Install VirtualBox (if using Windows / Linux)
#### Windows
Visit [here](https://www.virtualbox.org/wiki/Downloads), and click on `Windows hosts`.

#### Linux
Your favorite package manager *should* already have VirtualBox, so install it through there. If not, see [here](https://www.virtualbox.org/wiki/Linux_Downloads).
### Install Parallels (if using MacOS)
You'll need a license of Parallels if you're using MacOS. You can buy one [here](https://www.parallels.com/products/desktop/), and download it through there.

After you've done so, you'll need to install the Parallels provider for Vagrant. That can be done through running this command in a terminal window:
```
vagrant plugin install vagrant-parallels
```
### Clone repository
Open a terminal (or a Command Prompt window), and run these two commands:
```
git clone https://github.com/norm-robotics/vagrant.git
cd vagrant
```
### Create virtual machine
#### MacOS - M1/M2 Laptops
In that window you opened before, run this command:
```
export VAGRANT_VAGRANTFILE=Vagrantfile.mac-arm64
vagrant up
```
#### Others
In that window you opened before, run this command:
```
vagrant up
```

If you set everything up correctly (and you prayed to the correct gods), you should be greeted by a message in your terminal like so:
```
    default: !!!!
    default: !!!!
    default: Your development machine has been fully setup. Visit http://localhost:8080 to get started.
```

Your development virtual machine is fully setup! Congratulations! Visit [here](http://localhost:8080) in a browser of your choosing. 

When you first visit that site, it may take a few minutes to load the VS Code interface as it downloads some necessary components. Please be patient with it.