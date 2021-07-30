#!/usr/bin/env python

import argparse
import os
import sys

parser = argparse.ArgumentParser(description='simulation options')
parser.add_argument('-clean', action='store_true', help='specify to remove work/ and transcript')
parser.add_argument('-seed', type=int, default=1, help='seed=x')

#parser.add_argument('-test', default='disable_hier_scope_class.sv', help='specify file to process')
#parser.add_argument('-test', default='disable_fork_class.sv', help='specify file to process')
#parser.add_argument('-test', default='wait_fork_class.sv', help='specify file to process')
#parser.add_argument('-test', default='disable_fork_begin_end_class.sv', help='specify file to process')
parser.add_argument('-test', default='disable_extended_class.sv', help='specify file to process')

args=parser.parse_args()
######### questa
def compile():
  #command=['vlog -lint -sv', 'fd_module.sv']
  command=['vlog -lint -sv']
  command.append(args.test)
  print 'compile command=', ' '.join(command), '\n'
  os.system(' '.join(command))
  
def simulate():
  #command=['vsim -c', '-do "run -all"', 'fork_disable']
  command=['vsim -c', '-do "run -all"', 'm0']
  command.append('+svseed={}'.format(args.seed))
  print 'sim command=', ' '.join(command), '\n'
  os.system(' '.join(command))
######### cadence
def c_xrun():
  command=['xrun -uvm -sv']
  command.append(args.test)
  command.append('+svseed={}'.format(args.seed))
  print 'run command=', ' '.join(command), '\n'
  os.system(' '.join(command))


def clean():
  if args.clean:
    os.system('rm -Rf work')
    try:
      os.remove('transcript')
    except OSError:
      pass

def Main():
  clean()
  compile()
  simulate()
  #c_xrun()

if __name__=='__main__':
  print 'command line args:', (sys.argv[1:]);
  Main()
