# sv_fork_disable
SystemVerilog fork disable code examples

Example 1:  disable_hier_scope_class.sv
----------
This is an example of what might cause unexpected actions.  In this example, class c in instantiated twice and both body()s are forked.
class C body():
  fork
    long_process()
  join_none
  fork : short_block
    short_process1()
    short_process2()
  join_any
  disable short_block                  //disable hier scope

What happens?  4 short_processes and 2 long_processes are started.  When the shortest short_process finishes, both classes disable short_block and all 4 short_processes are disabled.  Then the long_processes finish.


Example 2:  disable_fork_class.sv
----------
This example is similar to Example 1 except instead of disable short_block, use disable_fork.
class C body():
  fork
    long_process()
  join_none
  fork : short_block
    short_process1()
    short_process2()
  join_any
  disable fork                         //disable fork

What happens?   4 short_processes and 2 long_processes are started.  When a short_process finishes, that class issues disable fork and all process for that class terminate.  Same thing with the other class and it's shortest process.


Example 3:  wait_fork_class.sv
----------
This example uses wait fork which waits only on its immediate child processes, not their deeper descendants.
class C body():
  task take_time_plus(int t);
         fork
            take_time(40);             //fork descendent
         join_none
         take_time(t);
  endtask
  task take_time(int t);
         $display("start delay=%0d", t);
          #t;
         $display("done");
  endtask

  fork
    take_time_plus(20)
  join_none
  take_time(3)
  wait fork                            //wait fork

What happens?   the fork..take_time(40)..join_none block in take_time_plus() is not termintated.


Example 4:  disable_fork_begin_end_class.sv
----------
This example is similar to Example 2.  It uses disable fork but puts begin:label end around long_process.
class C body():
  begin: b0                            //attempt to protect long_process from stopping
    fork: long_process
      long_process()
    join_none
  end
  fork : short_block
    short_process1()
    short_process2()
  join_any
  disable fork                         //disable fork

What happens?   Same as Example 2.  begin..end does not change functionality.


Example 4:  disable_extended_class.sv
----------

