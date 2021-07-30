module m0;
class C;
  string name;
  int t1, t2;

  task take_time(string tname, int t);
         $display("%m @%0t %s start %s delay=%0d", $time, name, tname, t);
          #t; 
         $display("%m @%0t %s done %s", $time, name, tname);
  endtask

  task body();
    fork: long_process                           //don't want this one killed
      take_time("long_process", 10);
    join_none
  endtask

  function new(string name, int t1, t2);
    this.name=name; this.t1=t1; this.t2=t2;
  endfunction
endclass

class CC extends C;
  task body();
    super.body();
    bodyt();
  endtask
  task bodyt();
    //fork begin
      fork: short_block                          //when either of these finishes, kill both
        begin:  short_process1
          take_time("short_process1", t1);
        end 
        begin:  short_process2
          take_time("short_process2", t2);
        end 
      join_any
      disable fork;
      $display("%m @%0t %s after disable fork", $time, name);
    //end join_none
  endtask
  function new(string name, int t1, t2);
    super.new(name, t1, t2);
  endfunction
endclass

  CC c0, c1;
  initial begin
    $display("test: disable_extended_class");
    c0=new("c0", 2, 5);      c1=new("c1", 4, 6);
    $display("%m @%0t start initial", $time);
    fork
      c0.body();
      c1.body();
    join
    #11;
    $finish;
  end
endmodule
