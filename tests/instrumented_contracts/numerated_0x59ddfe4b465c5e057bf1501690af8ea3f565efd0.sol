1 pragma solidity ^0.4.0;
2 	contract CashCow {
3 	address public owner;
4 	uint256 private numberOfEntries;
5 	uint256 public cycleLength = 100;
6 	uint256 public price = 71940622590480000;
7 	uint256 public totalValue = 0;
8 	struct Player {
9 		uint256 lastCashOut;
10 		uint256[] entries;
11 	}
12 	// The address of the player and => the user info
13 	mapping(address => Player) public playerInfo;
14 
15 	function() public payable {}
16 
17 	constructor() public {
18 		owner = msg.sender;
19 		playerInfo[msg.sender].lastCashOut = 0;
20 		playerInfo[msg.sender].entries.push(numberOfEntries);
21 		numberOfEntries++;
22 	}
23 
24 	function kill() public {
25 		if(msg.sender == owner) selfdestruct(owner);
26 	}
27 
28 
29 	//returns amount of ether a player is able to withdraw 
30 	function checkBalance(address player) public constant returns(uint256){
31 		uint256 lastCashOut = playerInfo[player].lastCashOut;
32 		uint256[] entries = playerInfo[player].entries;
33 		if(entries.length == 0){
34 			return 0;
35 		}
36 		uint256 totalBalance = 0;
37 		for(uint i = 0; i < entries.length; i++){
38 			uint256 entry = entries[i];
39 			uint256 cycle = entry / cycleLength;
40 			uint256 cycleEnd = (cycle+1) * cycleLength;
41 			//check if we have completed that cycle
42 			if(numberOfEntries >= cycleEnd) {
43 			    uint256 entryBalence;
44 				if(lastCashOut <= entry) {
45 					entryBalence = calculateBalance(entry % 100, 99);
46 					totalBalance += entryBalence;
47 				}
48 				if(lastCashOut > entry && lastCashOut < cycleEnd){
49 					entryBalence = calculateBalance(lastCashOut % 100, 99);
50 					totalBalance += entryBalence;
51 				}
52 			}
53 			if(numberOfEntries < cycleEnd) {
54 				if(lastCashOut <= entry) {
55 					entryBalence = calculateBalance(entry % 100, (numberOfEntries - 1) % 100);
56 					totalBalance += entryBalence;
57 				}
58 				if(lastCashOut > entry && lastCashOut < numberOfEntries){
59 					entryBalence = calculateBalance(lastCashOut % 100, (numberOfEntries - 1) % 100);
60 					totalBalance += entryBalence;
61 				}
62 			}
63 		}
64 		return totalBalance;
65 	}
66 
67 	function calculateBalance(uint256 start, uint256 stop) public constant returns(uint256){
68 		if (start >= stop) return 0;
69 		uint256 balance  = 0;
70 		for(uint i = start + 1; i <= stop; i++) {
71 			balance += price / i;
72 		}
73 		return balance;
74 	}
75 
76 	// buy into the contract
77 	function buy() public payable {
78 		require(msg.value >= price);
79 		playerInfo[msg.sender].entries.push(numberOfEntries);
80 		numberOfEntries++;
81 		totalValue += msg.value;
82 		//check if this starts a new cycle
83 		if(numberOfEntries % cycleLength == 0){
84 			playerInfo[owner].entries.push(numberOfEntries);
85 			numberOfEntries++;
86 		} 
87 	}
88 
89 
90 	function checkDeletable(address player) public constant returns(bool){
91 		uint256 finalEntry = playerInfo[player].entries[playerInfo[player].entries.length - 1];
92 		uint256 lastCycle = (finalEntry / cycleLength);
93 		uint256 cycleEnd = (lastCycle + 1) * cycleLength;
94 		return (numberOfEntries > cycleEnd);
95 
96 	}
97 
98 	function withdraw() public{
99 		uint256 balance = checkBalance(msg.sender); //check the balence to be withdrawn
100 		if(balance == 0) return;
101 		if(checkDeletable(msg.sender)){
102 			delete playerInfo[msg.sender];
103 		}
104 		else {
105 		    playerInfo[msg.sender].lastCashOut = numberOfEntries - 1;
106 		}
107 		totalValue -= balance;
108 		msg.sender.transfer(balance);
109 	}
110 }