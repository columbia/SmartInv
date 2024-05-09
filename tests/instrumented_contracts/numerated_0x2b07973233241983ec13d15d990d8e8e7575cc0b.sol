1 pragma solidity ^0.4.24;
2 
3 contract OuterWithEth {
4     Inner1WithEth public myInner1 = new Inner1WithEth();
5     
6     function callSomeFunctionViaOuter() public payable {
7         myInner1.callSomeFunctionViaInner1.value(msg.value)();
8     }
9 }
10 
11 contract Inner1WithEth {
12     Inner2WithEth public myInner2 = new Inner2WithEth();
13     
14     function callSomeFunctionViaInner1() public payable{
15         myInner2.doSomething.value(msg.value)();
16     }
17 }
18 
19 contract Inner2WithEth {
20     uint256 someValue;
21     event SetValue(uint256 val);
22     
23     function doSomething() public payable {
24         someValue = block.timestamp;
25         emit SetValue(someValue);
26     }
27     
28     function getAllMoneyOut() public {
29         msg.sender.transfer(this.balance);
30     }
31 }