module m0;
class C;
  string name;
  int t1, t2;

  task take_time_plus(string tname, int t);
         fork
            take_time({tname, "_plus fork"}, 40);
         join_none
         take_time({tname, "_plus"}, t);
  endtask
  task take_time(string tname, int t);
         $display("%m @%0t %s start %s delay=%0d", $time, name, tname, t);
          #t; 
         $display("%m @%0t %s done %s", $time, name, tname);
  endtask

  task body();
    fork: long_process
       take_time_plus("long_process", 20);
    join_none
    take_time("next_process", t1);

    wait fork;
    $display("%m @%0t %s after wait fork", $time, name);
  endtask

  function new(string name, int t1, t2);
    this.name=name; this.t1=t1; this.t2=t2;
  endfunction
endclass

  C c0, c1;
  initial begin
    $display("test: wait_fork_class");
    c0=new("c0", 2, 5);    c1=new("c1", 4,5);
    $display("%m @%0t start initial", $time);
    fork
      c0.body();
      //c1.body();
    join
    #100;
    $finish;
  end
endmodule
