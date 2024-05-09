1 pragma solidity ^0.4.21;
2 // The Original All For 1 -  www.allfor1.io
3 // https://www.twitter.com/allfor1_io
4 // https://www.reddit.com/user/allfor1_io
5 
6 contract AllForOne {
7     
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     mapping (address => uint) private playerRegistrationStatus;
10     mapping (address => uint) private confirmedWinners;
11     mapping (uint => address) private numberToAddress;
12     uint private currentPlayersRequired;
13     uint private currentBet;
14     uint private playerCount;
15     uint private jackpot;
16     uint private revealBlock;
17     uint private currentGame;
18     address private contractAddress;
19     address private owner;
20     address private lastWinner;
21     
22     function AllForOne () {
23         contractAddress = this;
24         currentGame++;
25         currentPlayersRequired = 25;
26         owner = msg.sender;
27         currentBet = 0.005 ether;
28         lastWinner = msg.sender;
29     }
30     modifier onlyOwner () {
31         require(msg.sender == owner);
32         _;
33     }
34     modifier changeBetConditions () {
35         require (playerCount == 0);
36         require (contractAddress.balance == 0 ether);
37         _;
38     }
39     modifier betConditions () {
40         require (playerRegistrationStatus[msg.sender] < currentGame);
41         require (playerCount < currentPlayersRequired);
42         require (msg.value == currentBet);
43         require (confirmedWinners[msg.sender] == 0);
44         _;
45     }
46     modifier revealConditions () {
47         require (playerCount == currentPlayersRequired);
48         require (block.blockhash(revealBlock) != 0);
49         _;
50     }
51     modifier winnerWithdrawConditions () {
52         require (confirmedWinners[msg.sender] == 1);
53         _;
54     }
55     function transferOwnership (address newOwner) public onlyOwner {
56         require(newOwner != address(0));
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59     }
60     function changeBet (uint _newBet) external changeBetConditions onlyOwner {
61         currentBet = _newBet;
62     }
63     function canBet () view public returns (uint, uint, address) {
64         uint _status = 0;
65         uint _playerCount = playerCount;
66         address _lastWinner = lastWinner;
67         if (playerRegistrationStatus[msg.sender] < currentGame) {
68         _status = 1;
69         }
70         return (_status, _playerCount, _lastWinner);
71     }
72     function placeBet () payable betConditions {
73         playerCount++;
74         playerRegistrationStatus[msg.sender] = currentGame;
75         numberToAddress[playerCount] = msg.sender;
76         if (playerCount == currentPlayersRequired) {
77             revealBlock = block.number;
78         }
79         }
80     function revealWinner () external revealConditions {
81         uint _thisBlock = block.number;
82         if (_thisBlock - revealBlock <= 255) {
83             playerCount = 0;
84             currentGame++;
85             uint _winningNumber = uint(block.blockhash(revealBlock)) % currentPlayersRequired + 1;
86             address _winningAddress = numberToAddress[_winningNumber];
87             confirmedWinners[_winningAddress] = 1;
88             lastWinner = _winningAddress;
89             msg.sender.transfer(currentBet);
90         } else {
91             revealBlock = block.number;       
92         }
93     }
94     function winnerWithdraw () external winnerWithdrawConditions {
95         confirmedWinners[msg.sender] = 0;
96         jackpot = (currentBet * (currentPlayersRequired - 1));
97         msg.sender.transfer(jackpot);
98     }
99 }