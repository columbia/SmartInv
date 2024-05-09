1 pragma solidity ^0.4.19;
2 
3 // Name your new coin. Make sure the constructor has the same name.
4 contract Serum {
5 
6     // This will be you, the minter. It is set in the constructor.
7     address public minter;
8 
9     // This mapping stores everyone's balances.
10     mapping (address => uint) public balances;
11 
12     // This event will track when someone sends some tokens.
13     event Sent(address from, address to, uint amount);
14     event Mint(uint amount);
15 
16     // This is the constructor. It runs only once, when the contract is created.
17     function MyCoin() public {
18         minter = msg.sender;
19     }
20 
21     // Function to create some new coins for someone.
22     // As the minter, only you will have access to this.
23     function mint(address receiver, uint amount) public {
24         if (msg.sender != minter) return;
25         balances[receiver] += amount;
26         Mint(amount);
27     }
28 
29     // Function to send some coins. Anyone with coins can do this.
30     function send(address receiver, uint amount) public {
31         if (balances[msg.sender] < amount) return;
32         balances[msg.sender] -= amount;
33         balances[receiver] += amount;
34         Sent(msg.sender, receiver, amount);
35     }
36 }