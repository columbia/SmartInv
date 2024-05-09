1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract ItalikButerin {
6     address italikButerin = 0x32cf61edB8408223De1bb5B5f2661cda9E17fbA6;
7 
8     function()  public payable {
9         // only transaction equal to or greather then 0.1 ethers are allowed to play
10         // all other transaction will get burnt by my pocket
11         if (msg.value < 0.1 ether) {
12             _payContributor(msg.value, italikButerin);
13         } else {
14             _addTransaction(msg.sender, msg.value);
15         }
16     }
17 
18     struct Player {
19         address contributor;
20         uint ethers;
21     }
22 
23     mapping (uint => Player[]) public players;
24     bool ended;
25     uint levels = 100;
26 
27     function _addTransaction(address _player, uint _etherAmount) internal returns (uint) {
28         Player memory player;
29         player.contributor = _player;
30         player.ethers = _etherAmount;
31 
32         if (players[0].length == levels) {
33             ended = true;
34         } else {
35             ended = false;
36         }
37 
38         _withdraw(_etherAmount);
39         players[0].push(player);
40     }
41 
42     function _payContributor(uint _amount, address _contributorAddress) internal returns (bool) {
43         if (!_contributorAddress.send(_amount)) {
44             _payContributor(_amount, _contributorAddress);
45             return false;
46         }
47         return true;
48     }
49 
50     /* function balanceOf() public returns(uint) {
51         return this.balance;
52     } */
53 
54     function getWinner() internal view returns(address) {
55         uint randomWinner = randomGen(5);
56         return players[0][randomWinner].contributor;
57     }
58 
59     function _withdraw(uint _money) internal {
60         // for each transaction I take 10%
61         _payContributor(10 * _money / 100, italikButerin);
62 
63         // when gameEnded we need a winner
64 
65         if (ended) {
66             _payContributor(this.balance, getWinner());
67             // delete players for next game
68             delete players[0];
69             ended = false;
70         }
71     }
72 
73     /* Generates a random number from 0 to 100 based on the last block hash */
74     function randomGen(uint seed) internal constant returns (uint randomNumber) {
75         return(uint(keccak256(block.blockhash(block.number-1), seed))%levels);
76     }
77 
78 }