1 pragma solidity ^0.4.0;
2 
3 contract ArbitrageCoin {
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
15     function Coin() public {
16         minter = msg.sender;
17     }
18 
19     function mint(address receiver, uint amount) public {
20         if (msg.sender != minter) return;
21         balances[receiver] += amount;
22     }
23 
24     function send(address receiver, uint amount) public {
25         if (balances[msg.sender] < amount) return;
26         balances[msg.sender] -= amount;
27         balances[receiver] += amount;
28         Sent(msg.sender, receiver, amount);
29     }
30 }