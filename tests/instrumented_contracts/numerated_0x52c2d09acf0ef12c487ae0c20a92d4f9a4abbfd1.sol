1 pragma solidity ^0.4.17;
2 
3 contract owned {
4     address public owner;    
5     
6     function owned() {
7         owner=msg.sender;
8     }
9 
10     modifier onlyowner{
11         if (msg.sender!=owner)
12             throw;
13         _;
14     }
15 }
16 
17 contract MyNewBank is owned {
18     address public owner;
19     mapping (address=>uint) public deposits;
20     
21     function init() {
22         owner=msg.sender;
23     }
24     
25     function() payable {
26         deposit();
27     }
28     
29     function deposit() payable {
30         if (msg.value >= 100 finney)
31             deposits[msg.sender]+=msg.value;
32         else
33             throw;
34     }
35     
36     function withdraw(uint amount) public onlyowner {
37         require(amount>0);
38         uint depo = deposits[msg.sender];
39         if (amount <= depo)
40             msg.sender.send(amount);
41         else
42             revert();
43             
44     }
45 
46 	function kill() onlyowner {
47 	    if(this.balance==0) {  
48 		    selfdestruct(msg.sender);
49 	    }
50 	}
51 }