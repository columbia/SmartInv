1 pragma solidity ^0.4.23;
2 
3 contract Jackpot {
4 
5     uint64 public nextJackpotTime;
6     bool public jackpotPaused;
7     address public owner;
8     uint public jackpotPersent = 100;
9     uint public  winnerLimit = 1;
10     uint public JackpotPeriods = 1;
11     address public diceRollAddress;
12     uint256 seed;
13 
14     mapping (uint=>address) public winnerHistory;
15     address[] public tempPlayer;
16 
17     event SendJackpotSuccesss(address indexed winner, uint amount, uint JackpotPeriods);
18     event OwnerTransfer(address SentToAddress, uint AmountTransferred);
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     modifier onlyDiceRoll {
26         require(msg.sender == diceRollAddress);
27         _;
28     }
29 
30     modifier jackpotAreActive {
31         require(!jackpotPaused);
32         _;
33     }
34 
35     
36     constructor() public {
37         owner = msg.sender;
38     }
39     
40 
41     function() external payable {
42 
43     }
44 
45     function getWinnerHistory(uint periods) external view returns(address){
46         return winnerHistory[periods];
47     }
48 
49     function addPlayer(address add) public onlyDiceRoll jackpotAreActive{
50         tempPlayer.push(add);
51         
52     }
53 
54     function createWinner() public onlyOwner jackpotAreActive {
55         require(tempPlayer.length > 0);
56         uint random = rand() % tempPlayer.length;
57         address winner = tempPlayer[random];
58         winnerHistory[JackpotPeriods] = winner;
59         uint64 tmNow = uint64(block.timestamp);
60         nextJackpotTime = tmNow + 72000;
61         tempPlayer.length = 0;
62         sendJackpot(winner, address(this).balance * jackpotPersent / 1000);
63         JackpotPeriods += 1;
64     }
65 
66 
67     function sendJackpot(address winner, uint256 amount) internal {
68         require(address(this).balance > amount);
69         emit SendJackpotSuccesss(winner, amount,JackpotPeriods);
70         winner.transfer(amount);
71         
72     }
73 
74     function seTJackpotPersent(uint newPersent) external onlyOwner{
75         require(newPersent > 0 && newPersent < 1000);
76         jackpotPersent = newPersent;
77     }
78 
79     function rand() internal returns (uint256) {
80         seed = uint256(keccak256(seed, blockhash(block.number - 1), block.coinbase, block.difficulty));
81         return seed;
82     }
83 
84 
85     function ownerPauseJackpot(bool newStatus) public onlyOwner{
86         jackpotPaused = newStatus;
87     }
88 
89     function ownerSetdiceRollAddress(address add) public onlyOwner {
90         diceRollAddress = add;
91     }
92 
93     function ownerTransferEther(address sendTo, uint amount) public onlyOwner{    
94         sendTo.transfer(amount);
95         emit OwnerTransfer(sendTo, amount);
96     }
97 
98 }