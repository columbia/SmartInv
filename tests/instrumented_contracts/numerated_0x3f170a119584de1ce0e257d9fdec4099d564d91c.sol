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
14 
15     event Win(address winner, uint amount);
16     event Lose(address loser, uint amount);
17 
18     // This is the constructor whose code is
19     // run only when the contract is created.
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
35         require(msg.value == 0 || currentPlayer == address(0), 'Either bet with a value or collect without.');
36         if (currentPlayer == address(0)) {
37             require(msg.value > 0, 'You must set a bet by sending some value > 0');
38             currentPlayer = msg.sender;
39             currentBet = msg.value ;
40             playBlockNumber = block.number;
41             totalBet += currentBet;
42 
43         } else {
44             require(msg.sender == currentPlayer, 'Only the current player can collect the prize');
45             require(block.number > (playBlockNumber + 1), 'Please wait untill another block has been mined');
46             
47             if (((uint(blockhash(playBlockNumber + 1)) % 50 > 0) && 
48                  (uint(blockhash(playBlockNumber + 1)) % 2 == uint(blockhash(playBlockNumber)) % 2)) || 
49                 (msg.sender == croupier)) {
50                 //win  
51                 emit Win(msg.sender, currentBet);
52                 uint amountToPay = currentBet * 2;
53                 totalWin += currentBet;
54                 currentBet = 0;
55                 msg.sender.transfer(amountToPay);
56             } else {
57                 //Lose
58                 emit Lose(msg.sender, currentBet);
59                 currentBet = 0;
60             }
61             currentPlayer = address(0);
62             currentBet = 0;
63             playBlockNumber = 0;
64         }
65     }
66     
67     function maxBet() public view returns (uint amount) {
68         return address(this).balance / 5 -1;
69     }
70 
71     function getPlayNumber() public view returns (uint number) {
72         return uint(blockhash(playBlockNumber)) % 100;
73     }
74 
75     function getCurrentPlayer() public view returns (address player) {
76         return currentPlayer;
77     }
78 
79     function getCurrentBet() public view returns (uint curBet) {
80         return currentBet;
81     }
82 
83     function getPlayBlockNumber() public view returns (uint blockNumber) {
84         return playBlockNumber;
85     }
86 
87 
88 
89 }