1 pragma solidity ^0.4.24;
2 
3 contract Outer {
4     Inner1 public myInner1 = new Inner1();
5     
6     function callSomeFunctionViaOuter() public {
7         myInner1.callSomeFunctionViaInner1();
8     }
9 }
10 
11 contract Inner1 {
12     Inner2 public myInner2 = new Inner2();
13     
14     function callSomeFunctionViaInner1() public {
15         myInner2.doSomething();
16     }
17 }
18 
19 contract Inner2 {
20     uint256 someValue;
21     event SetValue(uint256 val);
22     
23     function doSomething() public {
24         someValue = block.timestamp;
25         emit SetValue(someValue);
26     }
27 }