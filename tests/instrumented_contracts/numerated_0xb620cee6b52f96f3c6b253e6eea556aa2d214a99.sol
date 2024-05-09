1 // by nightman
2 // winner gets the contract balance
3 // 0.02 to play
4 
5 
6 pragma solidity ^0.4.23;
7 
8 contract DrainMe {
9 
10 //constants
11 
12 address public winner = 0x0;
13 address public owner;
14 address public firstTarget = 0x461ec7309F187dd4650EE6b4D25D93c922d7D56b;
15 address public secondTarget = 0x1C3E062c77f09fC61550703bDd1D59842C22c766;
16 address[] public players;
17 
18 mapping(address=>bool) approvedPlayers;
19 
20 uint256 public secret;
21 uint256[] public seed = [951828771,158769871220];
22 uint256[] public balance;
23 
24 //constructor
25 
26 function DranMe() public payable{
27 	owner = msg.sender;
28 }
29 
30 //modifiers
31 
32 modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35 }
36 
37 modifier onlyWinner() {
38     require(msg.sender == winner);
39     _;
40 }
41 
42 modifier onlyPlayers() {
43     require(approvedPlayers[msg.sender]);
44     _;
45 }
46 
47 //functions
48 
49 function getLength() public constant returns(uint256) {
50 	return seed.length;
51 }
52 
53 function setSecret(uint256 _secret) public payable onlyOwner{
54 	secret = _secret;
55 }
56 
57 function getPlayerCount() public constant returns(uint256) {
58 	return players.length;
59 }
60 
61 function getPrize() public constant returns(uint256) {
62 	return address(this).balance;
63 }
64 
65 function becomePlayer() public payable{
66 	require(msg.value >= 0.02 ether);
67 	players.push(msg.sender);
68 	approvedPlayers[msg.sender]=true;
69 }
70 
71 function manipulateSecret() public payable onlyPlayers{
72 	require (msg.value >= 0.01 ether);
73 	if(msg.sender!=owner || unlockSecret()){
74 	    uint256 amount = 0;
75         msg.sender.transfer(amount);
76 	}
77 }
78 
79 function unlockSecret() private returns(bool){
80     bytes32 hash = keccak256(blockhash(block.number-1));
81     uint256 secret = uint256(hash);
82         if(secret%5==0){
83             winner = msg.sender;
84             return true;
85         }
86         else{
87             return false;
88         }
89     }
90 
91 function callFirstTarget () public payable onlyPlayers {
92 	require (msg.value >= 0.005 ether);
93 	firstTarget.call.value(msg.value)();
94 }
95 
96 function callSecondTarget () public payable onlyPlayers {
97 	require (msg.value >= 0.005 ether);
98 	secondTarget.call.value(msg.value)();
99 }
100 
101 function setSeed (uint256 _index, uint256 _value) public payable onlyPlayers {
102 	seed[_index] = _value;
103 }
104 	
105 function addSeed (uint256 _add) public payable onlyPlayers {
106 	seed.length = _add;
107 }
108 
109 function guessSeed (uint256 _seed) public payable onlyPlayers returns(uint256) {
110 	return (_seed / (seed[0]*seed[1]));
111 	if((_seed / (seed[0]*seed[1])) == secret) {
112 		owner = winner;
113 	}
114 }
115 
116 function checkSecret () public payable onlyPlayers returns(bool) {
117     require(msg.value >= 0.01 ether);
118     if(msg.value == secret){
119         return true;
120     }
121 }
122 
123 function winPrize() public payable onlyOwner {
124 	owner.call.value(1 wei)();
125 }
126 
127 function claimPrize() public payable onlyWinner {
128 	winner.transfer(address(this).balance);
129 }
130 
131 //fallback function
132 
133 function() public payable{
134 	}
135 }