1 pragma solidity ^0.4.24;
2 
3 contract DiceGame {
4    
5     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
6     uint constant MIN_BET = 0.01 ether;
7     uint constant MAX_AMOUNT = 1000 ether;
8     uint constant MAX_ROLL_UNDER = 96;
9     uint constant MIN_ROLL_UNDER = 1;
10     uint constant BET_EXPIRATION_BLOCKS = 250;
11 
12     address public croupier;
13     uint public maxProfit;
14     uint128 public lockedInBets;
15     uint128 public lockedInviteProfits;
16 
17     // A structure representing a single bet.
18     struct Game {
19         uint amount;
20         uint8 rollUnder;
21         uint40 placeBlockNumber;
22         address player;
23         address inviter;
24         bool finished;
25     }
26 
27     mapping (uint => Game) public bets;
28     mapping (bytes32 => bool) public administrators;
29     mapping (address => uint) public inviteProfits;
30 
31     
32     // Events 
33     event FailedPayment(address indexed beneficiary, uint amount);
34     event Payment(address indexed beneficiary, uint amount);
35     event ShowResult(uint reveal, uint result );
36     event Commit(uint commit);
37 
38 
39     modifier onlyAdmin {
40         address _customerAddress = msg.sender;
41         require(administrators[keccak256(abi.encodePacked(_customerAddress))], "Only Admin could call this function.");
42         _;
43     }
44 
45     modifier onlyCroupier {
46         require (msg.sender == croupier, "Only croupier could call this function");
47         _;
48     }
49 
50     constructor (address _croupier, uint _maxProfit) public {
51         administrators[0x4c709c79c406763d17c915eedc9f1af255061e3bf2e93e236a24e01486c7713a] = true;
52         croupier = _croupier;
53         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number");
54         maxProfit = _maxProfit;
55         lockedInBets = 0;
56         lockedInviteProfits = 0;
57     }
58 
59     function() public payable {
60     }
61 
62     function setAdministrator(bytes32 _identifier, bool _status) external onlyAdmin {
63         administrators[_identifier] = _status;
64     }
65 
66     function setCroupier(address newCroupier) external onlyAdmin {
67         croupier = newCroupier;
68     }
69 
70     function setMaxProfit(uint _maxProfit) external onlyAdmin {
71         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
72         maxProfit = _maxProfit;
73     }
74 
75     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyAdmin {
76         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
77         require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
78         sendFunds(beneficiary, withdrawAmount);
79     }
80 
81     function kill(address _owner) external onlyAdmin {
82         require (lockedInBets == 0, "All games should be processed (settled or refunded) before self-destruct.");
83         selfdestruct(_owner);
84     }
85 
86     function placeGame(
87         uint rollUnder, 
88         uint commitLastBlock, 
89         uint commit, 
90         bytes32 r, 
91         bytes32 s,
92         address inviter
93     ) external payable {
94         Game storage bet = bets[commit];
95         require (bet.player == address(0), "Game should be in a 'clean' state.");
96         require (msg.sender != inviter, "Player and inviter should be different");
97         uint amount = msg.value;
98         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be in range");
99         require (block.number <= commitLastBlock, "Commit has expired");
100 
101         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
102         bytes32 signatureHash = keccak256(abi.encodePacked(prefix,commit));
103 
104         require (croupier == ecrecover(signatureHash, 27, r, s), "Invalid signature");
105         require (rollUnder >= MIN_ROLL_UNDER && rollUnder <= MAX_ROLL_UNDER, "Roll under should be within range.");
106         
107         uint possibleWinAmount;
108         uint inviteProfit;
109         address amountInvitor = inviter != croupier ? inviter : 0;
110 
111         (possibleWinAmount,inviteProfit) = getDiceWinAmount(amount, rollUnder, amountInvitor);
112 
113         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
114 
115         lockedInBets += uint128(possibleWinAmount);
116         lockedInviteProfits += uint128(inviteProfit);
117 
118         require ((lockedInBets + lockedInviteProfits)  <= address(this).balance, "Cannot afford to lose this bet.");
119 
120         emit Commit(commit);
121 
122         bet.amount = amount;
123         bet.rollUnder = uint8(rollUnder);
124         bet.placeBlockNumber = uint40(block.number);
125         bet.player = msg.sender;
126         bet.finished = false;
127         if (inviter != croupier) {
128             bet.inviter = inviter;
129         }
130     }
131 
132     function settleGame(uint reveal, bytes32 blockHash) external onlyCroupier {
133         uint commit = uint(keccak256(abi.encodePacked(reveal)));
134 
135         Game storage bet = bets[commit];
136         uint placeBlockNumber = bet.placeBlockNumber;
137 
138         require (block.number > placeBlockNumber, "settleGame in the same block as placeGame, or before.");
139         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Game has expired");
140         require (blockhash(placeBlockNumber) == blockHash, "Blockhash is not correct");
141 
142         settleGameCommon(bet, reveal, blockHash);
143     }
144 
145     function refundGame(uint commit) external {
146         Game storage bet = bets[commit];
147         bet.finished = true;
148         uint amount = bet.amount;
149 
150         require (amount != 0, "Game should be in an 'active' state");
151 
152         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Game has not expired yet");
153 
154         bet.amount = 0;
155 
156         uint diceWinAmount;
157         uint inviteProfit;
158         (diceWinAmount,inviteProfit) = getDiceWinAmount(amount, bet.rollUnder, bet.inviter);
159 
160         lockedInBets -= uint128(diceWinAmount);
161 
162         sendFunds(bet.player, amount);
163     }
164 
165     function withdrawInvitationProfit() external {
166         uint amount = inviteProfits[msg.sender];
167         require(amount > 0, "no profit");
168         inviteProfits[msg.sender] = 0;
169         lockedInviteProfits -= uint128(amount);
170         sendFunds(msg.sender, amount);
171     }
172 
173     function getInvitationBalance() external view returns (uint profit){
174         profit = inviteProfits[msg.sender];
175     }
176 
177   
178     function settleGameCommon(Game storage bet, uint reveal, bytes32 entropyBlockHash) private {
179         uint amount = bet.amount;
180         uint rollUnder = bet.rollUnder;
181         address player = bet.player;
182 
183         require (amount != 0, "Game should be in an 'active' state");
184         bet.amount = 0;
185 
186         bytes32 seed = keccak256(abi.encodePacked(reveal, entropyBlockHash));
187 
188         uint dice = uint(seed) % 100 + 1;
189         
190         emit ShowResult(reveal, dice);
191 
192         uint diceWinAmount;
193         uint inviteProfit;
194         
195         (diceWinAmount, inviteProfit) = getDiceWinAmount(amount, rollUnder, bet.inviter);
196 
197         uint diceWin = 0;
198         
199         if (dice <= rollUnder) {
200             diceWin = diceWinAmount;
201         }
202         lockedInBets -= uint128(diceWinAmount);
203         inviteProfits[bet.inviter] += inviteProfit;
204         
205         bet.finished = true;
206         sendFunds(player, diceWin);
207     }
208 
209     function sendFunds(address beneficiary, uint amount) private {
210         if (amount > 0){
211             if (beneficiary.send(amount)) {
212                 emit Payment(beneficiary, amount);
213             } else {
214                 emit FailedPayment(beneficiary, amount);
215             }
216         }
217     }
218 
219 
220     function getDiceWinAmount(uint amount, uint rollUnder, address inviter) private pure returns (uint winAmount, uint inviteProfit) {
221         require (MIN_ROLL_UNDER <= rollUnder && rollUnder <= MAX_ROLL_UNDER, "Win probability out of range.");
222         uint houseEdge = amount / 50;
223         inviteProfit = 0;
224         if (inviter > 0) {
225             inviteProfit = amount / 100;
226             houseEdge = amount / 100;   
227         }
228 
229         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
230             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
231         }
232 
233         require (houseEdge <= amount, "Bet doesn't even cover house edge.");
234         winAmount = (amount - houseEdge - inviteProfit) * 100 / rollUnder;
235     }
236 
237 }