module m0;
class C;
  string name;
  int t1, t2;

  task take_time(string tname, int t);
         $display("%m @%0t %s start %s delay=%0d", $time, name, tname, t);
          #t; 
         $display("%m @%0t %s done %s", $time, name, tname);
  endtask

  task tt();
    fork: long_process                      //don't want this one killed
      take_time("long_process", 10);
    join_none
  endtask

  function new(string name, int t1, t2);
    this.name=name; this.t1=t1; this.t2=t2;
  endfunction
endclass
class CC extends C;
  task tt();
    super.tt();
    ttt();
  endtask
  task ttt();
    //fork begin
      fork: to_process                        //when either of these finishes, kill both
        begin:  switch1
          take_time("switch1", t1);
        end 
        begin:  switch2
          take_time("switch2", t2);
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
    c0=new("c0", 2, 5);      c1=new("c1", 4, 6);
    $display("%m @%0t start initial", $time);
    fork
      c0.tt();
      c1.tt();
    join
    #11;
    $finish;
  end
endmodule
