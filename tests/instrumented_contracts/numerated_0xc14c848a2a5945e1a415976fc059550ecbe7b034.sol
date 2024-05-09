1 pragma solidity ^0.4.25;
2 
3 
4 contract Line {
5 
6     address private owner;
7 
8     uint constant public jackpotNumerator = 50;
9     uint constant public winNumerator = 5;
10     uint constant public giftNumerator = 1;
11     uint constant public denominator = 100;
12     uint constant public ownerDenominator = 100;
13 
14     uint public jackpot = 0;
15 
16     address[] internal addresses;
17     mapping(address => SpinRec) internal spinsByAddr;
18     mapping(bytes32 => SpinRec) internal spinsByQuery;
19 
20     struct SpinRec {
21         uint id;
22         bytes32 queryId;
23         uint bet;
24         uint token;
25     }
26 
27     event Jackpot(uint line, address addr, uint date, uint prize, uint left);
28     event Win(uint line, address addr, uint date, uint prize, uint left);
29     event Gift(uint line, address addr, uint date, uint prize, uint left);
30     
31     event Spin(address addr, uint bet, uint jackpot, bytes32 queryId);
32     event Reveal(uint line, address addr, uint bet, bytes32 queryId);
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function getQueryId() constant public returns (uint256) {
40         return uint256(spinsByAddr[msg.sender].queryId);
41     }
42 
43     function getTokenFor(uint256 queryId) constant public returns (uint) {
44         return spinsByQuery[bytes32(queryId)].token;
45     }
46 
47     function getToken() constant public returns (uint) {
48         return spinsByAddr[msg.sender].token;
49     }
50 
51     function getQueryIdBytes() constant public returns (bytes32) {
52         return spinsByAddr[msg.sender].queryId;
53     }
54 
55     function getTokenForBytes(bytes32 queryId) constant public returns (uint) {
56         return spinsByQuery[queryId].token;
57     }
58 
59     function revealResult(uint token, bytes32 queryId) internal {
60 
61         SpinRec storage spin = spinsByQuery[queryId];
62 
63         require(spin.id != 0);
64 
65         spin.token = token;
66         address player = addresses[spin.id];
67         spinsByAddr[player].token = token;
68 
69         emit Reveal(token, player, spin.bet, queryId);
70 
71         uint prizeNumerator = 0;
72 
73         if (token == 444) {
74             prizeNumerator = jackpotNumerator;
75         } else if (token == 333 || token == 222 || token == 111) {
76             prizeNumerator = winNumerator;
77         } else if (token%10 == 4 || token/10%10 == 4 || token/100%10 == 4) {
78             prizeNumerator = giftNumerator;
79         }
80 
81         uint balance = address(this).balance;
82         uint prize = 0;
83         if (prizeNumerator > 0) {
84             prize =  balance / 100 * prizeNumerator;
85             if (player.send(prize)) {
86                 if (prizeNumerator == jackpotNumerator) {
87                     emit Jackpot(token, player, now, prize, balance);
88                 } else if (prizeNumerator == winNumerator) {
89                     emit Win(token, player, now, prize, balance);
90                 } else {
91                     emit Gift(token, player, now, prize, balance);
92                 }
93                 owner.transfer(spin.bet / ownerDenominator);
94             }
95         }
96     }
97     
98     function recordSpin(bytes32 queryId) internal {
99         
100         SpinRec storage spin = spinsByAddr[msg.sender];
101 
102         if (spin.id == 0) {
103 
104             msg.sender.transfer(0 wei); 
105 
106             spin.id = addresses.length;
107             addresses.push(msg.sender);
108         }
109 
110         spin.bet = msg.value;
111         spin.queryId = queryId;
112         spinsByQuery[queryId] = spin;
113     }
114     
115     constructor() public {
116         
117         delete addresses;
118         addresses.length = 1;
119         owner = msg.sender;
120     }
121 
122     function waiver() private {
123         
124         delete owner;
125     }
126     
127     function reset() onlyOwner public {
128         
129         owner.transfer(address(this).balance);
130     }
131 
132     uint nonce;
133 
134     function random() internal returns (uint) {
135 
136         bytes32 output = keccak256(abi.encodePacked(now, msg.sender, nonce));
137 
138         uint rand = uint256(output) % 1024;
139         nonce++;
140         return rand;
141     }
142 
143     function() payable public {
144         
145         require(msg.value > 10);
146         jackpot += msg.value;
147 
148         uint rand = random();
149         bytes32 queryId = bytes32(nonce);
150 
151         recordSpin(queryId);
152 
153         emit Spin(msg.sender, msg.value, jackpot, queryId);
154 
155         revealResult(rand%345+100, queryId);
156     }
157 }