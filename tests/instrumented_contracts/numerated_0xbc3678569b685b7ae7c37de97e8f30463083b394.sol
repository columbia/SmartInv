1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) revert();
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract Registration is owned { 
21     
22     mapping (address => bool) public isRegistered;   
23       
24     function () public payable {
25         //address sender = msg.sender; 
26         if (msg.value == 10000000000000000) {
27             isRegistered[msg.sender] = true; 
28         } else { 
29             revert();
30         }
31         
32     }
33     
34     function collectFees() onlyOwner public { 
35         require(this.balance > 0);
36         
37         msg.sender.transfer(this.balance);
38     }
39     
40 }