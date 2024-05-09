1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5     
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyowner{
11         if (msg.sender != owner)
12             revert();
13         _;
14     }
15 }
16 
17 contract MyNewBank is owned {
18     address public owner;
19     mapping (address => uint) public deposits;
20     
21     function init() {
22         owner = msg.sender;
23     }
24     
25     function() payable {
26         // Take care
27         // You have to deposit enough to be able to passs the require line 36
28         // Use this like a piggy bank
29         deposit();
30     }
31     
32     function deposit() payable {
33         deposits[msg.sender] += msg.value;
34     }
35     
36     function withdraw(uint amount) public onlyowner {
37         require(amount > 0.25 ether);
38         require(amount <= deposits[msg.sender]);
39         msg.sender.transfer(amount);
40     }
41 
42 	function kill() onlyowner {
43 	    suicide(msg.sender);
44 	}
45 }