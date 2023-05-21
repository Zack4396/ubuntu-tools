#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This is a script used to install the VIM plugins.
Author: zokkki@foxmail.com
Date: 5/15/2023
Version: 0.0.1

Usage:
  # 1. install all vim plugins
  $ ./bin/run-pathogen.py --install_all --proxy 127.0.0.1:10809
  $ ./bin/run-pathogen.py --install coc-extensions
  $ source $HOME/.bashrc

"""

import os
import subprocess
import argparse
import random
import re
import json
from colorama import Fore

run_pathogen_fake_enable = False
run_pathogen_print_enable = True

supported_plugins_info = {
  'pathogen': {
    'Enable': True,
    'From': 'https://tpo.pe/pathogen.vim',
    'To': '$HOME/.vim/autoload',
    'FetchPackage': {
      'IfNotExist': [
        '$To/pathogen.vim',
      ],
      'Commands': [
        'curl -LSso $To/pathogen.vim $From',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Tim Pope',
      'Introduce': 'Manage your "runtimepath" with ease',
    },
  },
  'winmanager': {
    'Enable': True,
    'From': 'https://github.com/vim-scripts/winmanager',
    'To': '$HOME/.vim/bundle/winmanager',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/winfileexplorer.vim',
        '$To/plugin/winmanager.vim',
        '$To/plugin/wintagexplorer.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Srinath Avadhanula',
      'Introduce': 'A classical windows type environment for vim6.0',
    },
  },
  'bufexplorer': {
    'Enable': True,
    'From': 'https://github.com/fholgado/minibufexpl.vim',
    'To': '$HOME/.vim/bundle/minibufexpl.vim',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/minibufexpl.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Federico Holgado',
      'Introduce': 'Elegant buffer explorer - takes very little screen space',
    },
  },
  'taglist': {
    'Enable': True,
    'From': 'https://github.com/yegappan/taglist',
    'To': "$HOME/.vim/bundle/taglist",
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/taglist.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Yegappan Lakshmanan',
      'Introduce':
      'Provides an overview of the structure of source code files',
    },
  },
  'tagbar': {
    'Enable': True,
    'From': 'https://github.com/preservim/tagbar',
    'To': "$HOME/.vim/bundle/tagbar",
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/tagbar.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Jan Larres',
      'Introduce': 'A class outline viewer for Vim',
    },
  },
  'nerdtree': {
    'Enable': True,
    'From': 'https://github.com/scrooloose/nerdtree',
    'To': '$HOME/.vim/bundle/nerdtree',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/NERD_tree.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Phil Runninger',
      'Introduce': 'A file system explorer for the Vim editor',
    },
  },
  'lightline': {
    'Enable': True,
    'From': 'https://github.com/itchyny/lightline.vim',
    'To': '$HOME/.vim/bundle/lightline.vim',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/lightline.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'itchyny',
      'Introduce':
      'A light and configurable statusline/tabline plugin for Vim',
    },
  },
  'airline': {
    'Enable': True,
    'From': 'https://github.com/vim-airline/vim-airline',
    'To': '$HOME/.vim/bundle/vim-airline',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/airline.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'vim airline',
      'Introduce': 'status/tabline for vim',
    },
  },
  'airline_themes': {
    'Enable': True,
    'From': 'https://github.com/vim-airline/vim-airline-themes',
    'To': '$HOME/.vim/bundle/vim-airline-themes',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/airline-themes.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'vim airline',
      'Introduce': 'status/tabline themes for vim',
    },
  },
  'colors_solarized': {
    'Enable': True,
    'From': 'https://github.com/altercation/vim-colors-solarized',
    'To': '$HOME/.vim/bundle/vim-colors-solarized',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/colors/solarized.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Ethan Schoonover',
      'Introduce': 'Solarized Colorscheme for Vim',
    },
  },
  'colorschemes': {
    'Enable': True,
    'From': 'https://github.com/flazz/vim-colorschemes.git',
    'To': '$HOME/.vim/bundle/colorschemes',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/colors/molokai.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'Franco Lazzarino',
      'Introduce': 'one stop shop for vim colorschemes',
    },
  },
  'ctrlp': {
    'Enable': True,
    'From': 'https://github.com/ctrlpvim/ctrlp.vim',
    'To': '$HOME/.vim/bundle/ctrlp.vim',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/ctrlp.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': 'ctrlpvim',
      'Introduce':
      'Full path fuzzy file, buffer, mru, tag, ... finder for Vim.',
    },
  },
  'drawit': {
    'Enable': True,
    'From': 'https://github.com/vim-scripts/DrawIt.git',
    'To': '$HOME/.vim/bundle/DrawIt',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/DrawItPlugin.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author':
      'vim-script',
      'Introduce':
      'A plugin which allows one to draw lines left, right, up, down, and along both slants',
    },
  },
  'global': {
    'Enable':
    True,
    'From':
    'https://ftp.gnu.org/pub/gnu/global/global-6.6.9.tar.gz',
    'To':
    '$HOME/.vim/bundle/global-6.6.9',
    'FetchPackage': {
      'IfNotExist': [
        '$To/install-sh',
      ],
      'Commands': [
        'wget --quiet -O $To/global.tar.gz $From',
      ],
    },
    'Install': {
      'IfNotExist': [
        '$To/plugin/gtags-cscope.vim',
        '$To/plugin/gtags.vim',
        '$To/global/global',
        '$To/gtags/gtags',
        '$To/htags/htags',
        '$To/gtags-cscope/gtags-cscope',
        '$HOME/bin/global',
        '$HOME/bin/gtags',
        '$HOME/bin/htags',
        '$HOME/bin/gtags-cscope',
      ],
      'Commands': [
        'tar -xzf $To/global.tar.gz -C $To/../',
        'cd $To && chmod +x configure && ./configure --quiet && make -j8 --quiet > /dev/null 2>&1',
        'cd $To && mkdir -p $To/plugin && cp gtags.vim gtags-cscope.vim $To/plugin',
        'mkdir -p $HOME/bin',
        'ls $HOME/bin/global > /dev/null 2>&1 && rm $HOME/bin/global',
        'ls $HOME/bin/gtags > /dev/null 2>&1 && rm $HOME/bin/gtags',
        'ls $HOME/bin/htags > /dev/null 2>&1 && rm $HOME/bin/htags',
        'ls $HOME/bin/gtags-cscope > /dev/null 2>&1 && rm $HOME/bin/gtags-cscope',
        'ln -s $To/global/global $HOME/bin/global',
        'ln -s $To/gtags/gtags $HOME/bin/gtags',
        'ln -s $To/htags/htags $HOME/bin/htags',
        'ln -s $To/gtags-cscope/gtags-cscope $HOME/bin/gtags-cscope',
        'echo "export PATH="\\$PATH:$HOME/bin"" >> /home/$USER/.bashrc',
      ],
    },
    'Check': [
      {
        'Command': 'dpkg -s libncurses-dev > /dev/null 2>&1',
        'Version': '',
      },
      {
        'Command': 'ctags',
        'Version': '',
      },
    ],
    'Info': {
      'Author': 'GNU',
      'Introduce': 'Global source code tagging system',
    },
    'Help': [
      'Requirements',
      '$ sudo apt-get install -y libncurses5-dev',
    ]
  },
  'youcompleteme': {
    'Enable': True,
    'From': 'https://github.com/valloric/youcompleteme',
    'To': '$HOME/.vim/bundle/youcompleteme',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/third_party/ycmd',
        '$To/plugin/youcompleteme.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
        'cd $To && git submodule update --init --recursive --quiet',
      ],
    },
    'Install': {
      'IfNotExist': [
        '$To/cpp/ycm/.ycm_extra_conf.py',
      ],
      'Commands': [
        'cd $To && ./install.sh --clang-completer --system-libclang',
        'mkdir -p $To/cpp/ycm && cp $To/third_party/ycmd/examples/.ycm_extra_conf.py $To/cpp/ycm',
      ],
    },
    'Info': {
      'Author': 'Val Markovic',
      'Introduce': 'a code-completion engine for Vim',
    },
    'Help': [
      'Requirements',
      '$ sudo apt-get install -y cmake doxygen',
    ]
  },
  'coc': {
    'Enable':
    True,
    'From':
    'https://github.com/neoclide/coc.nvim',
    'To':
    '$HOME/.vim/bundle/coc.nvim',
    'FetchPackage': {
      'IfNotExist': [
        '$To/.git',
        '$To/plugin/coc.vim',
      ],
      'Commands': [
        'git clone --quiet $From $To',
      ],
    },
    'Install': {
      'IfNotExist': [
        '$To/build/index.js',
      ],
      'Commands': [
        'cd $To && yarn install && yarn build',
      ],
    },
    'Check': [
      {
        'Command': 'node --version',
        'Version': 'v16.17',
        'Offset': 1,
      },
      {
        'Command': 'npm --version',
        'Version': '8.0',
        'Offset': 0,
      },
      {
        'Command': 'yarn --version',
        'Version': '1.22',
        'Offset': 0,
      },
      {
        'Command': '~/.config/coc/extensions/node_modules/coc-pairs',
        'Version': '',
      },
      {
        'Command': '~/.config/coc/extensions/node_modules/coc-sh',
        'Version': '',
      },
      {
        'Command': '~/.config/coc/extensions/node_modules/coc-pyright',
        'Version': '',
      },
      {
        'Command': '~/.config/coc/extensions/node_modules/coc-clangd',
        'Version': '',
      },
    ],
    'Info': {
      'Author': 'neoclide',
      'Introduce': 'Make your Vim/Neovim as smart as VS Code',
    },
    'Help': [
      '# Install coc plugins:',
      '$ vim -c "silent! CocInstall coc-pyright coc-pairs coc-sh coc-json coc-clangd"',
      '# install requirements',
    ]
  },
  'coc-extensions': {
    'Enable': True,
    'Alone': True,
    'From': '',
    'To': '',
    'FetchPackage': {
      'IfNotExist': [
        '$HOME/.config/coc/extensions/node_modules/coc-pyright',
        '$HOME/.config/coc/extensions/node_modules/coc-sh',
        '$HOME/.config/coc/extensions/node_modules/coc-json',
        '$HOME/.config/coc/extensions/node_modules/coc-pairs',
        '$HOME/.config/coc/extensions/node_modules/coc-clangd',
      ],
      'Commands': [
        'vim -c "silent! CocInstall coc-pyright coc-sh coc-json coc-pairs coc-clangd"',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': '',
      'Introduce': '',
    },
    'Help': [],
  },
  'coc-clangd': {
    'Enable': True,
    'From':
    'https://github.com/clangd/clangd/releases/download/16.0.2/clangd-linux-16.0.2.zip',
    'To':
    '$HOME/.config/coc/extensions/coc-clangd-data/install/16.0.2/clangd_16.0.2',
    'FetchPackage': {
      'IfNotExist': ['$To/bin/clangd'],
      'Commands': [
        'wget --quiet -O $To/../clangd-linux.zip $From',
        'unzip -o -q $To/../clangd-linux.zip -d $To/../',
        'echo "export PATH="\\$PATH:$To/bin"" >> /home/$USER/.bashrc',
      ],
    },
    'Install': {
      'IfNotExist': [],
      'Commands': [],
    },
    'Info': {
      'Author': '',
      'Introduce': '',
    },
    'Help': [],
  },
}


def UpdatePluginsInfoWithRunTime(plugin_composite_dicts: dict):
  # For each plugin info
  for each_plugin_info in plugin_composite_dicts.values():
    # Set Default value
    each_plugin_info.setdefault('Alone', 'False')

    # Update 'To' value - replace '$HOME' attribute
    each_plugin_info['To'] = each_plugin_info['To'] \
        .replace('$HOME', os.environ['HOME'])

    # For each plugins checklist
    checklist_types = ['FetchPackage', 'Install']
    for checklist_type in checklist_types:
      checklist = each_plugin_info[checklist_type]
      for key in checklist.keys():
        checklist[key] = [
          string.replace('$To', each_plugin_info['To']) \
            .replace('$From', each_plugin_info['From']) \
            .replace('$HOME', os.environ['HOME'])
          for string in checklist[key]
        ]


def RandomColor():
  return random.choice([
    Fore.CYAN, Fore.MAGENTA, Fore.YELLOW, Fore.LIGHTBLUE_EX, Fore.LIGHTCYAN_EX,
    Fore.LIGHTGREEN_EX, Fore.LIGHTMAGENTA_EX, Fore.LIGHTYELLOW_EX
  ])


def InvokeCommand(command: list, enable_shell: bool, enable_print: bool):
  cmd = command

  if enable_print:
    print(f'{RandomColor()} $', f' '.join(command), f'{Fore.RESET}')

  try:
    if run_pathogen_fake_enable == True:
      cmd = ['echo "' + ''.join(command) + '"']
      subprocess.check_call(cmd, shell=enable_shell, stdout=subprocess.DEVNULL)
    else:
      subprocess.check_call(cmd, shell=enable_shell)
    return True

  except subprocess.CalledProcessError as e:
    if enable_print:
      print(f'Result: failed \nRetcode: {e.returncode}')
    return False


# Install Plugins Commands
# ./run-pathogen.py --install_all
# ./run-pathogen.py --install pathogen winmanager
def InstallPlugins(todo_list: list, plugin_composite_dicts: dict):
  # For each todo items
  for name in todo_list:
    for key, value in plugin_composite_dicts.items():
      if name == key:
        # Ignore the plugin which marked with 'Alone=True' attribute
        if (len(todo_list)
            > 1) and value['Alone'] == True and value['Enable'] == True:
          plugin_composite_dicts[key]['Enable'] = False
          print(
            f'{Fore.RED} Please install {key} alone, run $ run_pathogen.py -i {key} {Fore.RESET}'
          )

        if value['Enable'] == True and not PackageIsExists(value):
          location_path = value['To']
          if location_path:
            if not os.path.exists(location_path):
              print(
                f'{Fore.BLUE} Creating {Fore.RESET}{RandomColor()}{location_path}{Fore.RESET}'
              )
              if not run_pathogen_fake_enable == True:
                os.makedirs(location_path)
            else:
              if not os.path.isdir(location_path) or os.listdir(location_path):
                print(
                  f'{Fore.RED} Please remove {location_path} manually, then try it again{Fore.RESET}'
                )
                continue

          print(
            f'{Fore.BLUE} Fetching {Fore.RESET}{RandomColor()}{name}{Fore.RESET}'
          )
          for fetchpackage_key, fetchpackage_value in value[
              'FetchPackage'].items():
            if fetchpackage_key == 'Commands' and fetchpackage_value:
              for command in fetchpackage_value:
                if command:
                  if not InvokeCommand([command], True,
                                       run_pathogen_print_enable):
                    print('Install Abort')
                    return

        if value['Enable'] == True and (not PackageIsExists(value)
                                        or not PluginIsInstall(value)):
          location_path = value['To']
          if location_path:
            if not os.path.exists(
                location_path) and not run_pathogen_fake_enable == True:
              print(
                f'{Fore.RED} {location_path} should be exist !!!!! Abort {Fore.RESET}'
              )
              continue

          print(
            f'{Fore.BLUE} Installing {Fore.RESET}{RandomColor()}{name}{Fore.RESET}'
          )
          for install_key, install_value in value['Install'].items():
            if install_key == 'Commands' and install_value:
              for command in install_value:
                if command:
                  if not InvokeCommand([command], True,
                                       run_pathogen_print_enable):
                    print('Install Abort')
                    return

        # Check it again
        if PackageIsExists(value) and PluginIsInstall(value):
          status = f'{Fore.GREEN}[OKAY]{Fore.RESET}'
        elif value['Enable'] == True:
          status = f'{Fore.RED}[FAIL]{Fore.RESET}'
        else:
          status = f'{Fore.RED}[SKIP]{Fore.RESET}'
        print(
          f'{Fore.BLUE} Installed {Fore.RESET}{RandomColor()}{name:20}{Fore.RESET} {status}'
        )
  print(f'\nInstall: {Fore.GREEN}Done{Fore.RESET}')


# List Installed Plugins Commands
# ./run-pathogen.py --list
# ./run-pathogen.py -l
def PackageIsExists(info_dict: dict) -> bool:
  for key, value in info_dict.items():
    if key == 'FetchPackage':
      for item in value['IfNotExist']:
        if os.path.exists(item):
          continue
        else:
          return False

  return True


def PluginIsInstall(info_dict: dict) -> bool:
  for key, value in info_dict.items():
    if key == 'Install':
      for item in value['IfNotExist']:
        if os.path.exists(item):
          continue
        else:
          return False

  return True


def PrintPluginStatus(index: int, plugin_name: str, plugin_info: dict):
  if PackageIsExists(plugin_info) and PluginIsInstall(plugin_info):
    status = f'{Fore.GREEN}[OKAY]{Fore.RESET}'
  elif not plugin_info['Enable'] == True:
    status = f'{Fore.YELLOW}[SKIP]{Fore.RESET}'
  else:
    status = f'{Fore.RED}[FAIL]{Fore.RESET}'
  print(
    f'{RandomColor()}{index:2}.{Fore.RESET} {RandomColor()}{plugin_name:20}{Fore.RESET} {status}'
  )


def ListInstalledPlugins(plugin_composite_dicts: dict):
  title = '[----- installed plugins -----]'
  print(f'{RandomColor()}{title}{Fore.RESET}')

  for index, (plugin_name,
              plugin_info) in enumerate(plugin_composite_dicts.items(),
                                        start=1):
    PrintPluginStatus(index, plugin_name, plugin_info)


# Show Supported Plugins Commands
# ./run-pathogen.py --show
# ./run-pathogen.py -s
def ShowSupportedPlugins(plugin_composite_dicts: dict):
  title = '[----- supported plugins -----]'
  print(f'{RandomColor()}{title}{Fore.RESET}')

  for index, plugin_name in enumerate(plugin_composite_dicts.keys(), start=1):
    print(
      f'{RandomColor()}{index:2}.{Fore.RESET} {RandomColor()}{plugin_name:20}{Fore.RESET}'
    )


def TestProxy():
  print(f'{Fore.BLUE}[---------- TestProxy ----------]{Fore.RESET}')
  cmdlist = {
    'google.com':
    'wget --timeout=5 --tries=1 www.google.com -q -O /dev/null',
    'youtube.com':
    'wget --timeout=5 --tries=1 www.youtube.com -q -O /dev/null',
    'raw.githubusercontent':
    'wget --timeout=5 --tries=1 https://raw.githubusercontent.com -q -O /dev/null',
  }

  for key, value in cmdlist.items():
    if InvokeCommand([value], True, False):
      print(f'{RandomColor()} {key:25} [OKAY] {Fore.RESET}')
    else:
      print(f'{Fore.RED} {key:25} [FAIL]  {Fore.RESET}')

  print(f'{Fore.BLUE}[---------- TestProxy ----------]{Fore.RESET}')


def ProxyControl(status: bool, server_str: str):
  if server_str == None:
    return

  # 1. check proxy setting
  proxy_server = CheckAndReturnAddress(server_str)
  if proxy_server == None:
    print(
      f'{Fore.RED}The (--proxy) parameters provided are wrong, ignore the proxy{Fore.RESET}'
    )
    return
  else:
    ip = proxy_server['proxy_ip']
    port = proxy_server['proxy_port']

  # 2. create cmdlist
  if status:
    proxy_server = 'http://' + ip + ':' + port
    cmdlist = [
      'git config --global http.proxy $proxy_server',
      'git config --global https.proxy $proxy_server',
    ]
    cmdlist = [
      string.replace('$proxy_server', proxy_server) for string in cmdlist
    ]
    os.environ['http_proxy'] = proxy_server
    os.environ['https_proxy'] = proxy_server
    TestProxy()
  else:
    cmdlist = [
      'git config --global --unset http.proxy',
      'git config --global --unset https.proxy',
    ]
    os.environ['http_proxy'] = ''
    os.environ['https_proxy'] = ''

  # 3. invoke commands
  for cmd in cmdlist:
    InvokeCommand([cmd], True, False)


def CheckAndReturnAddress(server_str: str):
  if server_str == None or not ':' in server_str:
    return None

  ip = server_str.split(':', 1)[0]
  port = server_str.split(':', 1)[1]

  pattern = r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
  if not re.match(pattern, ip):
    return None

  pattern = r"^(?:[1-9]\d{0,3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$"
  if not re.match(pattern, port):
    return None

  return dict(proxy_ip=ip, proxy_port=port)


def check_version(cmd: list, min_version_str='', offset=0) -> bool:
  try:
    result = subprocess.run(cmd, capture_output=True, text=True)
    output = result.stdout.strip()

  except FileNotFoundError:
    print(
      f'{cmd[0]} is not installed or {cmd[0]} is not found in the system path')
    return False

  if not min_version_str:
    return True
  else:
    # Check Version
    min_version_numbers = [
      int(num) for num in min_version_str[offset:].split('.')
    ]
    version_numbers = [int(num) for num in output[offset:].split('.')]
    if version_numbers[0] > min_version_numbers[0] or (
        version_numbers[0] == min_version_numbers[0]
        and version_numbers[1] >= min_version_numbers[1]):
      return True
    else:
      print(
        f'{cmd[0]} should >= {min_version_numbers[0]}.{min_version_numbers[1]}'
      )
    return False


def main():
  UpdatePluginsInfoWithRunTime(supported_plugins_info)

  parser = argparse.ArgumentParser(description='Install Vim Plugins')

  parser.add_argument('-a',
                      '--install_all',
                      action='store_true',
                      help='Install all supported plugins')
  parser.add_argument('-d',
                      '--debug',
                      action='store_true',
                      help="Do Fake action")
  parser.add_argument('-i',
                      '--install',
                      action='extend',
                      help='Install selected plugins',
                      metavar='plugins',
                      nargs='+',
                      type=str)
  parser.add_argument('-l',
                      '--list',
                      action='store_true',
                      help="List installed plugins")
  parser.add_argument(
    '-p',
    '--proxy',
    help=
    'Download through a proxy server, e.g., -p 127.0.0.1:10809 (default use http:// protocol)',
    type=str)
  parser.add_argument('-s',
                      '--show',
                      action='store_true',
                      help="Show supported plugins")

  args = parser.parse_args()

  if args.debug:
    global run_pathogen_fake_enable
    run_pathogen_fake_enable = True

  if not check_version(['node', '--version'], 'v16.17', 1):
    print('Disable coc install')
    supported_plugins_info['coc']['Enable'] = False

  if args.show:
    ShowSupportedPlugins(supported_plugins_info)
  elif args.list:
    ListInstalledPlugins(supported_plugins_info)
  else:
    if args.install:
      ProxyControl(True, args.proxy)
      InstallPlugins(args.install, supported_plugins_info)
      ProxyControl(False, args.proxy)
    elif args.install_all:
      ProxyControl(True, args.proxy)
      InstallPlugins(list(supported_plugins_info.keys()),
                     supported_plugins_info)
      ProxyControl(False, args.proxy)
    else:
      parser.print_help()

  if args.debug:
    debug_json = os.path.expanduser("~/.run_pathogen_debug.json")
    with open(debug_json, "w") as debug_json_file:
      json.dump(supported_plugins_info, debug_json_file, indent=4)
      print(f'Please check {debug_json} for install settings')


if __name__ == '__main__':
  main()
