1 pragma solidity ^0.4.23;
2 
3 contract EthMash {
4 
5     address public owner;
6     mapping (address => uint) public balances;
7 
8     address public leader;
9 
10     event Log(address challenger, address defender, bool success);
11 
12     constructor() public {
13         owner = msg.sender;
14         leader = owner;
15     }
16 
17     function publicGetBalance(address player) view public returns (uint) {
18         return balances[player];
19     }
20 
21     function publicGetState() view public returns (address) {
22         return leader;
23     }
24 
25     function userWithdraw() public {
26         require(balances[msg.sender] > 0);
27         uint amount = balances[msg.sender];
28         balances[msg.sender] = 0;
29         msg.sender.transfer(amount);
30     }
31 
32     function userChallenge() public payable {
33         require(msg.value == 100 finney);
34         
35         uint random = (uint(blockhash(block.number - 1)) + uint(leader) + uint(msg.sender));
36         if (random % 2 == 1) {
37             emit Log(msg.sender, leader, true);
38             balances[msg.sender] += 100 finney;
39             leader = msg.sender;
40         } else {
41             emit Log(msg.sender, leader, false);
42             balances[leader] += 95 finney;
43             balances[owner] += 5 finney;
44         }
45     }
46 }