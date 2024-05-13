1 1 pragma solidity >=0.4.24 <0.6.0;
2 
3 2 contract A {
4 
5 3    function get_a()  public returns (uint) {
6 4        return 2;
7 5    }
8 6 }
9 
10 7 contract NestedFunction {
11 
12 8     A a;
13 9     uint count = 0;
14 
15 10     constructor () public {
16 11     } 
17 
18 12     function foo(uint x) internal returns (uint ret) {
19 13         ret = x + 1;
20 14     }
21 
22 15     function far(uint x) public {
23 16         _;
24 17     }
25 
26 18     function baz(uint x) public {
27 19        uint y;
28 20        y = foo(foo(x) + 2);
29 21     }
30 
31 22     function bar() public {
32 23         _;
33 24     }
34    
35 25     function fooW(uint x) private returns (uint){
36 26        count ++; 
37 27        return foo(x) + count;
38 28     }
39 
40 29     function unhandled(uint x) public {
41 30        uint y;
42 31        y = foo(foo(x) + foo(foo(x)));
43 32     }
44 33 }}
45 34 }