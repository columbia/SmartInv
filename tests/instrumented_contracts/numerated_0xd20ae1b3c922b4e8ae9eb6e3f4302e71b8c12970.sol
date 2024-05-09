1 pragma solidity ^0.4.24;
2 contract Game01 {
3     //the address of our team
4     address public teamAddress;
5     //addresses of players
6     address[] public players;
7     //sum of players
8     uint public sumOfPlayers;
9     //minimum bet
10     uint public lowestOffer;
11     //target block number
12     uint public blockNumber;
13     //store the hash of the target block
14     bytes32 public blcokHash;
15     //store the decimal number of the hash
16     uint public numberOfBlcokHash;
17     //store the winer index
18     uint public winerIndex;
19     //store the address of the winner
20     address public winer;
21     //private function:hunt for the lucky dog
22     function produceWiner() private {
23         //get the blockhash of the target blcok number
24         blcokHash = blockhash(blockNumber);
25         //convert hash to decimal
26         numberOfBlcokHash = uint(blcokHash);
27         //make sure that the block has been generated
28         require(numberOfBlcokHash != 0);
29         //calculating index of the winer
30         winerIndex = numberOfBlcokHash%sumOfPlayers;
31         //get the winer address
32         winer = players[winerIndex];
33         //calculating the gold of team
34         uint tempTeam = (address(this).balance/100)*10;
35         //transfe the gold to the team
36         teamAddress.transfer(tempTeam);
37         //calculating the gold of winer
38         uint tempBonus = address(this).balance - tempTeam;
39         //transfer the gold to the winer
40         winer.transfer(tempBonus);
41     }
42     //public function:hunt for the lucky dog
43     function goWiner() public {
44         produceWiner();
45     }
46     //public function:bet
47     function betYours() public payable OnlyBet() {
48         //make sure that the block has not been generated
49         blcokHash = blockhash(blockNumber);
50         numberOfBlcokHash = uint(blcokHash);
51         require(numberOfBlcokHash == 0);
52         //add the player to the player list
53         sumOfPlayers = players.push(msg.sender);
54     }
55     //make sure you bet enough ETH
56     modifier OnlyBet() {
57         require(msg.value >= lowestOffer);
58         _;
59     }
60     //constructor function
61     constructor(uint _blockNumber) public payable {
62         teamAddress = msg.sender;//initialize the team address
63         sumOfPlayers = 1;//initialize the players
64         players.push(msg.sender);//add the team address to the players
65         lowestOffer = 10000000000000000;//minimum bet:0.01ETH
66         blockNumber = _blockNumber;//initialize the target block number
67     }
68     //get the address of team
69     function getTeamAddress() public view returns(address addr) {
70         addr = teamAddress;
71     }
72     //get the minimum bet ETH
73     function getLowPrice() public view returns(uint low) {
74         low = lowestOffer;
75     }
76     //get the player address from the index
77     function getPlayerAddress(uint index) public view returns(address addr) {
78         addr = players[index];
79     }
80     //get sum of players
81     function getSumOfPlayers() public view returns(uint sum) {
82         sum = sumOfPlayers;
83     }
84     //get the target blcok number
85     function getBlockNumber() public view returns(uint num) {
86         num = blockNumber;
87     }
88     //get the balance of contract(bonus pools)
89     function getBalances() public view returns(uint balace) {
90         balace = address(this).balance;
91     }
92 }