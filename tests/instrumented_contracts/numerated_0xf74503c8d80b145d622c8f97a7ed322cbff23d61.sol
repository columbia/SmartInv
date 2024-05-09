1 pragma solidity ^0.4.11;
2 contract Pot {
3 
4 	address public owner;
5     address[] public potMembers;
6     
7 	uint public potSize = 0;
8 	uint public winnerIndex;
9 	address public winnerAddress;
10 	uint public minBetSize = .1 ether;
11 	uint public potTime = 1800;
12 	uint public endTime = now + potTime;
13 	uint public totalBet = 0;
14 
15 	bool public locked = false;
16 	
17 	event potSizeChanged(
18         uint _potSize
19     );
20 	
21 	event winnerAnnounced(
22 	    address winner,
23 	    uint amount
24 	);
25 	
26 	event timeLeft(uint left);
27 	
28 	event debug(string msg);
29 	
30 	function Pot() {
31 		owner = msg.sender;
32 	}
33 
34 	// function Kill() public {
35 	// 	if(msg.sender == owner) {
36 	// 	    selfdestruct(owner);
37 	// 	}
38 	// }
39 	
40 	
41 	function bytesToString (bytes32 data) returns (string) {
42         bytes memory bytesString = new bytes(32);
43         for (uint j=0; j<32; j++) {
44             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
45             if (char != 0) {
46                 bytesString[j] = char;
47             }
48         }
49         return string(bytesString);
50     }
51 	
52 	//1 ether = 1 spot
53 	function joinPot() public payable {
54 	    
55 	    assert(now < endTime);
56         //for each ether sent, reserve a spot
57 	    for(uint i = msg.value; i >= minBetSize; i-= minBetSize) {
58 	        potMembers.push(msg.sender);
59 	        totalBet+= minBetSize;
60 	        potSize += 1;
61 	    }
62 	    
63 	    potSizeChanged(potSize);
64 	    timeLeft(endTime - now);
65 	    
66 	}
67 
68 	function getPlayers() constant public returns(address[]) {
69 		return potMembers;
70 	}
71 	
72 	function getEndTime() constant public returns (uint) {
73 	    return endTime;
74 	}
75 	
76     function rewardWinner() public payable {
77         
78         //assert time
79         debug("assert now > end time");
80         assert(now > endTime);
81         if(!locked) {
82             locked = true;
83             debug("locked");
84             if(potSize > 0) {
85             	//if only one member entered the pot, then they automatically win
86             	if(potMembers.length == 1) 
87             		random_number = 0;
88             	else
89                 	uint random_number = uint(block.blockhash(block.number-1))%potMembers.length - 1;
90                 debug(bytesToString(bytes32(random_number)));
91                 winnerIndex = random_number;
92                 winnerAddress = potMembers[random_number];
93                 uint amountWon = potSize * minBetSize * 98 / 100;
94                 
95                 
96                 winnerAnnounced(winnerAddress, amountWon);
97                 potMembers[random_number].transfer(amountWon); //2% fee
98                 owner.transfer(potSize * minBetSize * 2 / 100);
99             }
100             else {
101                 winnerAnnounced(0x0000000000000000000000000000000000000000, 0);
102             }
103             
104             potSize = 0;
105             endTime = now + potTime;
106             timeLeft(endTime - now);
107             delete potMembers;
108             locked = false;
109         }
110         
111     }
112 
113 }