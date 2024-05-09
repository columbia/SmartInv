1 pragma solidity ^0.4.23;
2 
3 contract EthMash {
4 
5     address public owner;
6     mapping (address => uint) public balances;
7 
8     address[6] public leaders;
9     uint[6] public buyins;
10 
11     event Challenge(uint buyin, uint draw, address challenger, address defender, bool success);
12     event Withdraw(address player, uint amount);
13 
14     constructor() public {
15         owner = msg.sender;
16         leaders = [owner, owner, owner, owner, owner, owner];
17         buyins = [20 finney, 60 finney, 100 finney, 200 finney, 600 finney, 1000 finney];   
18     }
19 
20     function publicGetBalance(address player) view public returns (uint) {
21         return balances[player];
22     }
23 
24     function publicGetState() view public returns (address[6]) {
25         return leaders;
26     }
27 
28     function ownerChange(uint index, address holder) public {
29         require(msg.sender == owner);
30         require(leaders[index] == owner);
31         leaders[index] = holder;
32     }
33 
34     function userWithdraw() public {
35         require(balances[msg.sender] > 0);
36         uint amount = balances[msg.sender];
37         balances[msg.sender] = 0;
38         emit Withdraw(msg.sender, amount);
39         msg.sender.transfer(amount);
40     }
41 
42     function userChallenge(uint index) public payable {
43         require(index >= 0 && index < 6);
44         require(msg.value == buyins[index]);
45         
46         uint random = ((uint(blockhash(block.number - 1)) + uint(leaders[index]) + uint(msg.sender)) % 100) + 1;
47         
48         if (random > 50) {
49             emit Challenge(buyins[index], random, msg.sender, leaders[index], true);
50             balances[msg.sender] += buyins[index];
51             leaders[index] = msg.sender;
52         } else {
53             emit Challenge(buyins[index], random, msg.sender, leaders[index], false);
54             balances[leaders[index]] += (buyins[index] * 95 / 100);
55             balances[owner] += (buyins[index] * 5 / 100);
56         }
57     }
58 }