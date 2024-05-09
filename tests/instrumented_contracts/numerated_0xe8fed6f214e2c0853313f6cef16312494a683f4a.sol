1 pragma solidity ^0.4.10;
2 
3 contract HeadEmUp {
4     address private owner;
5     event Player(bytes32);
6     event House(bytes32);
7     
8     function HeadEmUp() {
9         owner = msg.sender;
10     }
11     
12     function rand(address _who) returns(bytes2){
13         return bytes2(keccak256(_who,now));
14     }
15     
16     function () payable {
17         if (msg.sender == owner && msg.value > 0)
18             return;
19         if (msg.sender == owner && msg.value == 0)
20             owner.transfer(this.balance);
21         else {
22             uint256 house_cut = msg.value / 100;
23             owner.transfer(house_cut);
24             bytes2 player = rand(msg.sender);
25             bytes2 house = rand(owner);
26             Player(bytes32(player));
27             House(bytes32(house));
28             if (player <= house){
29                 if (((msg.value) * 2 - house_cut) > this.balance)
30                     msg.sender.transfer(this.balance);
31                 else
32                     msg.sender.transfer(((msg.value) * 2 - house_cut));
33             }   
34         }
35     }
36 }