1 // CryptoDuels.co Copyright (c) 2018. All rights reserved.
2 
3 pragma solidity ^0.4.20;
4 
5 library SafeMath {
6     function add(uint x, uint y) internal pure returns (uint z) {
7         require((z = x + y) >= x);
8     }
9     function sub(uint x, uint y) internal pure returns (uint z) {
10         require((z = x - y) <= x);
11     }
12     function mul(uint x, uint y) internal pure returns (uint z) {
13         require(y == 0 || (z = x * y) / y == x);
14     }
15 }
16 contract Owned {
17     address public ceoAddress;
18     address public cooAddress;
19     address private newCeoAddress;
20     address private newCooAddress;
21 
22     function Owned() public {
23         ceoAddress = msg.sender;
24         cooAddress = msg.sender;
25     }
26     
27     modifier onlyCEO() {
28         require(msg.sender == ceoAddress);
29         _;
30     }
31     modifier onlyCOO() {
32         require(msg.sender == cooAddress);
33         _;
34     }
35     modifier onlyCLevel() {
36         require(
37             msg.sender == ceoAddress ||
38             msg.sender == cooAddress
39         );
40         _;
41     }
42     function setCEO(address _newCEO) public onlyCEO {
43         require(_newCEO != address(0));
44         newCeoAddress = _newCEO;
45     }
46     function setCOO(address _newCOO) public onlyCEO {
47         require(_newCOO != address(0));
48         newCooAddress = _newCOO;
49     }
50     function acceptCeoOwnership() public {
51         require(msg.sender == newCeoAddress);
52         require(address(0) != newCeoAddress);
53         ceoAddress = newCeoAddress;
54         newCeoAddress = address(0);
55     }
56     function acceptCooOwnership() public {
57         require(msg.sender == newCooAddress);
58         require(address(0) != newCooAddress);
59         cooAddress = newCooAddress;
60         newCooAddress = address(0);
61     }
62 }
63 
64 contract CryptoDuels is Owned {
65     using SafeMath for uint;
66 
67     struct PLAYER {
68         uint wad; // eth balance
69         uint lastJoin;
70         uint lastDuel;
71         
72         uint listPosition;
73     }
74     
75     mapping (address => PLAYER) public player;
76     address[] public playerList;
77     
78     function getPlayerCount() public view returns (uint) {
79         return playerList.length;
80     }
81     
82     //================ ADMIN ================
83     
84     uint public divCut = 20; // 2%
85     uint public divAmt = 0;
86     
87     function adminSetDiv(uint divCut_) public onlyCLevel {
88         require(divCut_ < 50); // max total cut = 5% (some of which can be used for events)
89         divCut = divCut_;
90     }
91     
92     uint public fatigueBlock = 1; // can't duel too much in too few time
93     uint public safeBlock = 1; // new players are safe for a while
94     
95     uint public blockDuelBegin = 0; // for special event
96     uint public blockWithdrawBegin = 0; // for special event
97     
98     function adminSetDuel(uint fatigueBlock_, uint safeBlock_) public onlyCLevel {
99         fatigueBlock = fatigueBlock_;
100         safeBlock = safeBlock_;
101     }
102     
103     // for special event
104     function adminSetBlock(uint blockDuelBegin_, uint blockWithdrawBegin_) public onlyCLevel {
105         require(blockWithdrawBegin_ < block.number + 6000); // at most 1 day
106 
107         blockDuelBegin = blockDuelBegin_;
108         blockWithdrawBegin = blockWithdrawBegin_;
109     }
110     
111     function adminPayout(uint wad) public onlyCLevel {
112         if ((wad > divAmt) || (wad == 0)) // can only payout dividend, so player's ETHs are safe
113             wad = divAmt;
114         divAmt = divAmt.sub(wad);
115         ceoAddress.transfer(wad);
116     }
117     
118     //================ GAME ================
119 
120     event DEPOSIT(address indexed player, uint wad, uint result);
121     event WITHDRAW(address indexed player, uint wad, uint result);
122     event DUEL(address indexed player, address opp, bool isWin, uint wad);
123     
124     function deposit() public payable {
125         require(msg.value > 0);
126         
127         PLAYER storage p = player[msg.sender];
128         
129         if (p.wad == 0) { // new player?
130             p.lastJoin = block.number;
131             p.listPosition = playerList.length;
132             playerList.push(msg.sender);
133         }
134         
135         p.wad = p.wad.add(msg.value);
136         DEPOSIT(msg.sender, msg.value, p.wad);
137     }
138 
139     function withdraw(uint wad) public {
140         require(block.number >= blockWithdrawBegin);
141         
142         PLAYER storage p = player[msg.sender];
143         
144         if (wad == 0)
145             wad = p.wad;
146         require(wad != 0);
147 
148         p.wad = p.wad.sub(wad);
149         msg.sender.transfer(wad); // send ETH
150         WITHDRAW(msg.sender, wad, p.wad);
151         
152         if (p.wad == 0) { // quit game?
153             playerList[p.listPosition] = playerList[playerList.length - 1];
154             player[playerList[p.listPosition]].listPosition = p.listPosition;
155             playerList.length--;
156         }
157     }
158     
159     function duel(address opp) public returns (uint, uint) {
160         require(block.number >= blockDuelBegin);
161         require(block.number >= fatigueBlock + player[msg.sender].lastDuel);
162         require(block.number >= safeBlock + player[opp].lastJoin);
163         require(!isContract(msg.sender));
164 
165         player[msg.sender].lastDuel = block.number;
166         
167         uint ethPlayer = player[msg.sender].wad;
168         uint ethOpp = player[opp].wad;
169         
170         require(ethOpp > 0);
171         require(ethPlayer > 0);
172         
173         // this is not a good random number, but good enough for now
174         uint fakeRandom = uint(keccak256(block.blockhash(block.number-1), opp, divAmt, block.timestamp));
175         
176         bool isWin = (fakeRandom % (ethPlayer.add(ethOpp))) < ethPlayer;
177         
178         // send ETH from loser to winner
179         address winner = msg.sender;
180         address loser = opp;
181         uint amt = ethOpp;
182         if (!isWin) {
183             winner = opp;
184             loser = msg.sender;
185             amt = ethPlayer;
186         }
187 
188         uint cut = amt.mul(divCut) / 1000;
189         uint realAmt = amt.sub(cut);
190         divAmt = divAmt.add(cut);
191         
192         player[winner].wad = player[winner].wad.add(realAmt);    
193         player[loser].wad = 0;
194         
195         // delete loser
196         playerList[player[loser].listPosition] = playerList[playerList.length - 1];
197         player[playerList[playerList.length - 1]].listPosition = player[loser].listPosition;
198         playerList.length--;
199         
200         DUEL(msg.sender, opp, isWin, amt);
201     }
202     
203     function isContract(address addr) internal view returns (bool) {
204         uint size;
205         assembly { size := extcodesize(addr) }
206         return size > 0;
207     }
208 }