1 pragma solidity ^0.4.18;
2 contract LifetimeLottery {
3     
4     uint internal constant MIN_SEND_VAL = 500000000000000000; //minimum amount (in wei) for getting registered on list
5 	uint internal constant JACKPOT_INC = 100000000000000000; //amount (in wei) which is added to the jackpot
6 	uint internal constant JACKPOT_CHANCE = 5; //the chance to hit the jackpot in percent
7 	
8 	uint internal nonce;
9 	uint internal random; //number which picks the winner from lotteryList
10 	uint internal jackpot; //current jackpot
11 	uint internal jackpotNumber; //number, which is used to decide if the jackpot hits
12     
13 	address[] internal lotteryList; //all registered addresses
14     address internal lastWinner;
15 	address internal lastJackpotWinner;
16 	address internal deployer;
17     
18     mapping(address => bool) addressMapping; //for checking quickly, if already registered
19 	event LotteryLog(address adrs, string message);
20 	
21     function LifetimeLottery() public {
22         deployer = msg.sender;
23         nonce = (uint(msg.sender) + block.timestamp) % 100;
24     }
25      
26     function () public payable {
27 		LotteryLog(msg.sender, "Received new funds...");
28         if(msg.value >= MIN_SEND_VAL) {
29             if(addressMapping[msg.sender] == false) { //--> cheaper access through map instead of a loop
30                 addressMapping[msg.sender] = true;
31                 lotteryList.push(msg.sender);
32                 nonce++;
33                 random = uint(keccak256(block.timestamp + block.number + uint(msg.sender) + nonce)) % lotteryList.length;
34                 lastWinner = lotteryList[random];
35 				jackpotNumber = uint(keccak256(block.timestamp + block.number + random)) % 100;
36 				if(jackpotNumber < JACKPOT_CHANCE) {
37 					lastJackpotWinner = lastWinner;
38 					lastJackpotWinner.transfer(msg.value + jackpot);
39 					jackpot = 0;
40 					LotteryLog(lastJackpotWinner, "Jackpot is hit!");
41 				} else {
42 					jackpot += JACKPOT_INC;
43 					lastWinner.transfer(msg.value - JACKPOT_INC);
44 					LotteryLog(lastWinner, "We have a Winner!");
45 				}
46             } else {
47                 msg.sender.transfer(msg.value);
48 				LotteryLog(msg.sender, "Failed: already joined! Sending back received ether...");
49             }
50         } else {
51             msg.sender.transfer(msg.value);
52 			LotteryLog(msg.sender, "Failed: not enough Ether sent! Sending back received ether...");
53         }
54     }
55 	
56 	function amountOfRegisters() public constant returns(uint) {
57 		return lotteryList.length;
58 	}
59 	
60 	function currentJackpotInWei() public constant returns(uint) {
61 		return jackpot;
62 	}
63     
64     function ourLastWinner() public constant returns(address) {
65         return lastWinner;
66     }
67 	
68 	function ourLastJackpotWinner() public constant returns(address) {
69 		return lastJackpotWinner;
70 	}
71 	
72 	modifier isDeployer {
73 		require(msg.sender == deployer);
74 		_;
75 	}
76 	
77 	function withdraw() public isDeployer { //backdoor in case of errors
78         deployer.transfer(this.balance - jackpot); //jackpot is untouchable
79     }
80 	
81 	function die() public isDeployer {
82 		selfdestruct(deployer); //killing contract
83 	}
84 }