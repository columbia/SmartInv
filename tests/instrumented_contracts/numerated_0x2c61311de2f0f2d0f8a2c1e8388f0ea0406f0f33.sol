1 pragma solidity ^0.4.25;
2 
3 contract EasySmartolutionProcessor {
4     address constant public smartolution = 0xB2D5468cF99176DA50F91E46B2c06B7BDb9D2656;
5     
6     constructor () public {
7     }
8     
9     function () external payable {
10         require(msg.value == 0, "This contract doest not accept ether");
11     }
12 
13     function processPayment(address _participant) external {
14         EasySmartolutionInterface(smartolution).processPayment(_participant);
15     }
16 }
17 
18 contract EasySmartolutionInterface {
19     function processPayment(address _address) public;
20 }