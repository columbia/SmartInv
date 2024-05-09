1 pragma solidity >=0.4.24 <0.6.0;

2 contract A {

3    function get_a()  public returns (uint) {
4        return 2;
5    }
6 }

7 contract NestedFunction {

8     A a;
9     uint count = 0;

10     constructor () public {
11     } 

12     function foo(uint x) internal returns (uint ret) {
13         ret = x + 1;
14     }

15     function far(uint x) public {
16         _;
17     }

18     function baz(uint x) public {
19        uint y;
20        y = foo(foo(x) + 2);
21     }

22     function bar() public {
23         _;
24     }
   
25     function fooW(uint x) private returns (uint){
26        count ++; 
27        return foo(x) + count;
28     }

29     function unhandled(uint x) public {
30        uint y;
31        y = foo(foo(x) + foo(foo(x)));
32     }
33 }}
34 }