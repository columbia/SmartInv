1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) revert();
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19     
20 }
21 
22 contract Agent is owned {
23     
24     function g(address addr) payable {
25         addr.transfer(msg.value);
26     }
27 
28     function w() onlyOwner {
29         owner.transfer(this.balance);
30     }
31     
32     function k() onlyOwner {
33         suicide(owner);
34     }
35     
36 }