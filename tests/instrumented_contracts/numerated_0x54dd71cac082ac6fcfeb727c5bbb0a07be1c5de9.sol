1 pragma solidity ^0.4.19;
2 
3 /*
4 Game: MylittleProgram
5 Dev: WhiteMatrix
6 */
7 
8 library SafeMath {
9 
10 /**
11 * @dev Multiplies two numbers, throws on overflow.
12 */
13 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 if (a == 0) {
15 return 0;
16 }
17 uint256 c = a * b;
18 assert(c / a == b);
19 return c;
20 }
21 
22 /**
23 * @dev Integer division of two numbers, truncating the quotient.
24 */
25 function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 // assert(b > 0); // Solidity automatically throws when dividing by 0
27 uint256 c = a / b;
28 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 return c;
30 }
31 
32 /**
33 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 */
35 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 assert(b <= a);
37 return a - b;
38 }
39 
40 /**
41 * @dev Adds two numbers, throws on overflow.
42 */
43 function add(uint256 a, uint256 b) internal pure returns (uint256) {
44 uint256 c = a + b;
45 assert(c >= a);
46 return c;
47 }
48 }
49 
50 contract MylittleProgram {
51 using SafeMath for uint256;
52 mapping (address => bool) private admins;
53 mapping (uint => uint256) public levels;
54 mapping (uint => bool) private lock;
55 address contractCreator;
56 address winnerAddress;
57 uint256 prize;
58 function MylittleProgram () public {
59 
60 contractCreator = msg.sender;
61 winnerAddress = 0xFb2D26b0caa4C331bd0e101460ec9dbE0A4783A4;
62 admins[contractCreator] = true;
63 }
64 
65 struct Pokemon {
66 string pokemonName;
67 address ownerAddress;
68 uint256 currentPrice;
69 }
70 Pokemon[] pokemons;
71 
72 //modifiers
73 modifier onlyContractCreator() {
74 require (msg.sender == contractCreator);
75 _;
76 }
77 modifier onlyAdmins() {
78 require(admins[msg.sender]);
79 _;
80 }
81 
82 //Owners and admins
83 
84 /* Owner */
85 function setOwner (address _owner) onlyContractCreator() public {
86 contractCreator = _owner;
87 }
88 
89 function addAdmin (address _admin) public {
90 admins[_admin] = true;
91 }
92 
93 function removeAdmin (address _admin) onlyContractCreator() public {
94 delete admins[_admin];
95 }
96 
97 // Adresses
98 function setPrizeAddress (address _WinnerAddress) onlyAdmins() public {
99 winnerAddress = _WinnerAddress;
100 }
101 
102 bool isPaused;
103 /*
104 When countdowns and events happening, use the checker.
105 */
106 function pauseGame() public onlyContractCreator {
107 isPaused = true;
108 }
109 function unPauseGame() public onlyContractCreator {
110 isPaused = false;
111 }
112 function GetGamestatus() public view returns(bool) {
113 return(isPaused);
114 }
115 
116 function addLock (uint _pokemonId) onlyContractCreator() public {
117 lock[_pokemonId] = true;
118 }
119 
120 
121 
122 function getPokemonLock(uint _pokemonId) public view returns(bool) {
123 return(lock[_pokemonId]);
124 }
125 
126 /*
127 This function allows users to purchase PokeMon.
128 The price is automatically multiplied by 1.5 after each purchase.
129 Users can purchase multiple PokeMon.
130 */
131 function putPrize() public payable {
132 
133 require(msg.sender != address(0));
134 prize = prize + msg.value;
135 
136 }
137 
138 
139 function withdraw () onlyAdmins() public {
140 
141 winnerAddress.transfer(prize);
142 
143 }
144 function pA() public view returns (address _pA ) {
145 return winnerAddress;
146 }
147 
148 function totalPrize() public view returns (uint256 _totalSupply) {
149 return prize;
150 }
151 
152 }