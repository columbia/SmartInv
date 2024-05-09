1 pragma solidity ^0.4.17;
2 
3 contract Lottery {
4     
5     address public manager;
6     address[] public players;
7     address public winner;
8     event Transfer(address indexed to, uint256 value);
9     
10     function Lottery () public {
11         manager = msg.sender;
12     }
13     
14     //投注
15     function enter() public payable {
16         //最小金额
17         require(msg.value > .01 ether);
18         
19         players.push(msg.sender);
20         
21     }
22     
23     function random() private view returns (uint) {
24         return uint(keccak256(block.difficulty, now, players));
25     }
26     
27     function pickWinner() public restricted returns (address[]) {
28         uint index = random() % players.length;
29         winner =  players[index];
30         winner.transfer(this.balance);
31         emit Transfer(winner,this.balance);
32         players = new address[](0);
33         return players;
34     }
35     
36     modifier restricted(){
37         require(msg.sender == manager);
38         _;
39     }
40 
41     function getContractBalance() public view returns (uint) {
42         return this.balance;
43     }
44 
45     function getPlayers() public view returns (address[]){
46         return players;
47     }
48 }