1 pragma solidity ^0.4.0;
2 
3 contract Coin {
4     // The keyword "public" makes those variables
5     // readable from outside.
6     address public minter;
7     mapping (address => uint) public balances;
8 
9     // Events allow light clients to react on
10     // changes efficiently.
11     event Sent(address from, address to, uint amount);
12 
13     // This is the constructor whose code is
14     // run only when the contract is created.
15     function Coin() {
16         minter = msg.sender;
17         balances[msg.sender]=1000;
18     }
19 
20     
21     function mint(address receiver, uint amount) {
22         if (msg.sender != minter) return;
23         balances[receiver] += amount;
24     }
25 
26     function send(address receiver, uint amount) {
27         if (balances[msg.sender] < amount) return;
28         if (balances[receiver]+ amount < balances[receiver]) return;
29         balances[msg.sender] -= amount;
30         balances[receiver] += amount;
31         Sent(msg.sender, receiver, amount);
32     }
33 }