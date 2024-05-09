1 pragma solidity ^0.4.21; //tells that the source code is written for Solidity version 0.4.21 or anything newer that does not break functionality
2 
3 
4 contract electrolightTestnet {
5     // The keyword "public" makes those variables readable from outside.
6     
7     address public minter;
8     
9     // Events allow light clients to react on changes efficiently.
10     mapping (address => uint) public balances;
11     
12     // This is the constructor whose code is run only when the contract is created
13     event Sent(address from, address to, uint amount);
14     
15     function electrolightTestnet() public {
16         
17         minter = msg.sender;
18         
19     }
20     
21     function mint(address receiver, uint amount) public {
22         
23         if(msg.sender != minter) return;
24         balances[receiver]+=amount;
25         
26     }
27     
28     function send(address receiver, uint amount) public {
29         if(balances[msg.sender] < amount) return;
30         balances[msg.sender]-=amount;
31         balances[receiver]+=amount;
32         emit Sent(msg.sender, receiver, amount);
33         
34     }
35     
36     
37 }