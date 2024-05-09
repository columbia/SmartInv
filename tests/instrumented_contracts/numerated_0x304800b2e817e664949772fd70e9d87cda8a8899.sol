1 pragma solidity >=0.5.0 <0.6.0;
2 
3 contract DoubleOrNothing {
4 
5     address private owner;
6     address private croupier;
7     address private currentPlayer;
8     
9     uint private currentBet;
10     uint private totalBet;
11     uint private totalWin;
12     uint private playBlockNumber;
13 
14     event Win(address winner, uint amount);
15     event Lose(address loser, uint amount);
16     event NewBet(address player, uint amount);
17     event ForgottenToCheckPrize(address player, uint amount);
18     event BetHasBeenPlaced(address player, uint amount);
19 
20     constructor(address payable firstcroupier) public payable {
21         owner = msg.sender;
22         croupier = firstcroupier;
23         totalBet = 0;
24         totalWin = 0;
25         currentPlayer = address(0);
26     }
27     
28     function setCroupier(address payable nextCroupier) public payable{
29         require(msg.sender == owner, 'Only I can set the new croupier!');
30         croupier = nextCroupier;
31     }
32 
33     function () external payable {
34         require(msg.value <= (address(this).balance / 5 -1), 'The stake is to high, check maxBet() before placing a bet.');
35         require(msg.value == 0 || currentPlayer == address(0), 'First bet with a value, then collect possible prize without.');
36         
37         if ((block.number - playBlockNumber) > 50) { 
38             if (currentPlayer != address(0)) {
39                 //If not collected after 50 blocks are mined +- 15 minutes, a bet can be overridden
40                 emit ForgottenToCheckPrize(currentPlayer,currentBet);
41             }
42             require(msg.value > 0, 'You must set a bet by sending some value > 0');
43             currentPlayer = msg.sender;
44             currentBet = msg.value ;
45             playBlockNumber = block.number;
46             totalBet += currentBet;
47             emit BetHasBeenPlaced(msg.sender,msg.value);
48             
49         } else {
50             require(msg.sender == currentPlayer, 'Only the current player can collect the prize. Wait for the current player to collect. After 50 blocks you can place a new bet');
51             require(block.number > (playBlockNumber + 1), 'Please wait untill at least one other block has been mined, +- 17 seconds');
52             
53             if (((uint(blockhash(playBlockNumber + 1)) % 50 > 0) && 
54                  (uint(blockhash(playBlockNumber + 1)) % 2 == uint(blockhash(playBlockNumber)) % 2)) || 
55                 (msg.sender == croupier)) {
56                 //Win change is 48% 
57                 emit Win(msg.sender, currentBet);
58                 uint amountToPay = currentBet * 2;
59                 totalWin += currentBet;
60                 currentBet = 0;
61                 msg.sender.transfer(amountToPay);
62             } else {
63                 //Lose change = 52%
64                 emit Lose(msg.sender, currentBet);
65                 currentBet = 0;
66             }
67             currentPlayer = address(0);
68             currentBet = 0;
69             playBlockNumber = 0;
70         }
71     }
72     
73     function maxBet() public view returns (uint amount) {
74         return address(this).balance / 5 -1;
75     }
76 
77     function getPlayNumber() public view returns (uint number) {
78         return uint(blockhash(playBlockNumber)) % 50;
79     }
80 
81     function getCurrentPlayer() public view returns (address player) {
82         return currentPlayer;
83     }
84 
85     function getCurrentBet() public view returns (uint curBet) {
86         return currentBet;
87     }
88 
89     function getPlayBlockNumber() public view returns (uint blockNumber) {
90         return playBlockNumber;
91     }
92 
93 }