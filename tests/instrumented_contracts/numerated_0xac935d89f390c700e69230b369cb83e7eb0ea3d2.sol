1 pragma solidity ^0.4.18;
2  
3 /*
4 - LifetimeLottery
5  
6     - 0.005 ETH buy in, 0.002 of that goes to jackpot pool
7     - 2% chance of winning jackpot
8  
9     - When you send 0.005 ETH to the contract, it adds your address to the lottery list. After that, the following results are possible:
10         - Your address is the winner and you receive 0.003 ETH. The contract hits the jackpot and you receive the whole jackpot too.
11         - Your address is the winner and you receive 0.003 ETH. The jackpot increases by 0.002 ETH.
12         - Any other address from the list is the winner and receives 0.003 ETH. The contract hits the jackpot and sends it to the winning address too.
13         - Any other address from the list is the winner and receives 0.003 ETH. The jackpot increases by 0.002 ETH
14 */
15  
16 contract LifetimeLottery {
17    
18     uint internal constant MIN_SEND_VAL = 5000000000000000; //minimum amount (in wei) for getting registered on list (0.005 ETH)
19     uint internal constant JACKPOT_INC = 2000000000000000; //amount (in wei) which is added to the jackpot (0.002 ETH)
20     uint internal constant JACKPOT_CHANCE = 2; //the chance to hit the jackpot in percent
21    
22     uint internal nonce;
23     uint internal random; //number which picks the winner from lotteryList
24     uint internal jackpot; //current jackpot
25     uint internal jackpotNumber; //number, which is used to decide if the jackpot hits
26    
27     address[] internal lotteryList; //all registered addresses
28     address internal lastWinner;
29     address internal lastJackpotWinner;
30    
31     mapping(address => bool) addressMapping; //for checking quickly, if already registered
32     event LotteryLog(address adrs, string message);
33    
34     function LifetimeLottery() public {
35         nonce = (uint(msg.sender) + block.timestamp) % 100;
36     }
37      
38     function () public payable {
39         LotteryLog(msg.sender, "Received new funds...");
40         if(msg.value >= MIN_SEND_VAL) {
41             if(addressMapping[msg.sender] == false) { //--> cheaper access through map instead of a loop
42                 addressMapping[msg.sender] = true;
43                 lotteryList.push(msg.sender);
44                 nonce++;
45                 random = uint(keccak256(block.timestamp + block.number + uint(msg.sender) + nonce)) % lotteryList.length;
46                 lastWinner = lotteryList[random];
47                 jackpotNumber = uint(keccak256(block.timestamp + block.number + random)) % 100;
48                 if(jackpotNumber < JACKPOT_CHANCE) {
49                     lastJackpotWinner = lastWinner;
50                     lastJackpotWinner.transfer(msg.value + jackpot);
51                     jackpot = 0;
52                     LotteryLog(lastJackpotWinner, "Jackpot is hit!");
53                 } else {
54                     jackpot += JACKPOT_INC;
55                     lastWinner.transfer(msg.value - JACKPOT_INC);
56                     LotteryLog(lastWinner, "We have a Winner!");
57                 }
58             } else {
59                 msg.sender.transfer(msg.value);
60                 LotteryLog(msg.sender, "Failed: already joined! Sending back received ether...");
61             }
62         } else {
63             msg.sender.transfer(msg.value);
64             LotteryLog(msg.sender, "Failed: not enough Ether sent! Sending back received ether...");
65         }
66     }
67    
68     function amountOfRegisters() public constant returns(uint) {
69         return lotteryList.length;
70     }
71    
72     function currentJackpotInWei() public constant returns(uint) {
73         return jackpot;
74     }
75    
76     function ourLastWinner() public constant returns(address) {
77         return lastWinner;
78     }
79    
80     function ourLastJackpotWinner() public constant returns(address) {
81         return lastJackpotWinner;
82     }
83    
84  
85 }