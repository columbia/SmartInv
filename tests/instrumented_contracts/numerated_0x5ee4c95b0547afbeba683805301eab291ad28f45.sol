1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title TheNextBlock
38  * @dev This is smart contract for dapp game
39  * in which players bet to guess miner of their transactions.
40  */
41 contract TheNextBlock {
42     
43     using SafeMath for uint256;
44     
45     event BetReceived(address sender, address betOnMiner, address miner);
46     event Jackpot(address winner, uint256 amount);
47     
48     struct Owner {
49         uint256 balance;
50         address addr;
51     }
52     
53     Owner public owner;
54     
55     /**
56     * This is exact amount of ether player can bet.
57     * If bet is less than this amount, transaction is reverted.
58     * If moore, contract will send excess amout back to player.
59     */
60     uint256 constant public allowedBetAmount = 5000000000000000; // 0.005 ETH
61     /**
62     * You need to guess requiredPoints times in a row to win jackpot.
63     */
64     uint256 constant public requiredPoints = 3;
65     /**
66     * Every bet is split: 10% to owner, 70% to prize pool
67     * we preserve 20% for next prize pool
68     */
69     uint256 constant public ownerProfitPercent = 10;
70     uint256 constant public nextPrizePoolPercent = 20;
71     uint256 constant public prizePoolPercent = 70; 
72     uint256 public prizePool = 0;
73     uint256 public nextPrizePool = 0;
74     uint256 public totalBetCount = 0;
75     
76     struct Player {
77         uint256 balance;
78         uint256 lastBlock;
79     }
80     
81     mapping(address => Player) public playersStorage;
82     mapping(address => uint256) public playersPoints;
83 
84 
85     modifier notContract(address sender)  {
86       uint32 size;
87       assembly {
88         size := extcodesize(sender)
89       }
90       require (size == 0);
91       _;
92     }
93     
94     modifier onlyOwner() {
95         require(msg.sender == owner.addr);
96         _;
97     }
98 
99     modifier notLess() {
100         require(msg.value >= allowedBetAmount);
101         _;
102     }
103 
104     modifier notMore() {
105         if(msg.value > allowedBetAmount) {
106             msg.sender.transfer( SafeMath.sub(msg.value, allowedBetAmount) );
107         }
108         _;
109     }
110     
111     modifier onlyOnce() {
112         Player storage player = playersStorage[msg.sender];
113         require(player.lastBlock != block.number);
114         player.lastBlock = block.number;
115         _;
116     }
117     
118     function safeGetPercent(uint256 amount, uint256 percent) private pure returns(uint256) {
119         return SafeMath.mul( SafeMath.div( SafeMath.sub(amount, amount%100), 100), percent );
120     }
121     
122     function TheNextBlock() public {
123         owner.addr = msg.sender;
124     }
125 
126     /**
127      * This is left for donations.
128      * Ether received in this(fallback) function
129      * will appear on owners balance.
130      */
131     function () public payable {
132          owner.balance = owner.balance.add(msg.value);
133     }
134 
135     function placeBet(address _miner) 
136         public
137         payable
138         notContract(msg.sender)
139         notLess
140         notMore
141         onlyOnce {
142             
143             totalBetCount = totalBetCount.add(1);
144             BetReceived(msg.sender, _miner, block.coinbase);
145 
146             owner.balance = owner.balance.add( safeGetPercent(allowedBetAmount, ownerProfitPercent) );
147             prizePool = prizePool.add( safeGetPercent(allowedBetAmount, prizePoolPercent) );
148             nextPrizePool = nextPrizePool.add( safeGetPercent(allowedBetAmount, nextPrizePoolPercent) );
149 
150             if(_miner == block.coinbase) {
151                 
152                 playersPoints[msg.sender]++;
153 
154                 if(playersPoints[msg.sender] == requiredPoints) {
155                     
156                     if(prizePool >= allowedBetAmount) {
157                         Jackpot(msg.sender, prizePool);
158                         playersStorage[msg.sender].balance = playersStorage[msg.sender].balance.add(prizePool);
159                         prizePool = nextPrizePool;
160                         nextPrizePool = 0;
161                         playersPoints[msg.sender] = 0;
162                     } else {
163                         playersPoints[msg.sender]--;
164                     }
165                 }
166 
167             } else {
168                 playersPoints[msg.sender] = 0;
169             }
170     }
171 
172     function getPlayerData(address playerAddr) public view returns(uint256 lastBlock, uint256 balance) {
173         balance =  playersStorage[playerAddr].balance;
174         lastBlock =  playersStorage[playerAddr].lastBlock;
175     }
176 
177     function getPlayersBalance(address playerAddr) public view returns(uint256) {
178         return playersStorage[playerAddr].balance;
179     }
180     
181     function getPlayersPoints(address playerAddr) public view returns(uint256) {
182         return playersPoints[playerAddr];
183     }
184 
185     function getMyPoints() public view returns(uint256) {
186         return playersPoints[msg.sender];
187     }
188     
189     function getMyBalance() public view returns(uint256) {
190         return playersStorage[msg.sender].balance;
191     }
192     
193     function withdrawMyFunds() public {
194         uint256 balance = playersStorage[msg.sender].balance;
195         if(balance != 0) {
196             playersStorage[msg.sender].balance = 0;
197             msg.sender.transfer(balance);
198         }
199     }
200     
201     function withdrawOwnersFunds() public onlyOwner {
202         uint256 balance = owner.balance;
203         owner.balance = 0;
204         owner.addr.transfer(balance);
205     }
206     
207     function getOwnersBalance() public view returns(uint256) {
208         return owner.balance;
209     }
210     
211     function getPrizePool() public view returns(uint256) {
212         return prizePool;
213     }
214 
215     function getNextPrizePool() public view returns(uint256) {
216         return nextPrizePool;
217     }
218     
219     
220     function getBalance() public view returns(uint256) {
221         return this.balance;
222     }
223         
224     function changeOwner(address newOwner) public onlyOwner {
225         owner.addr = newOwner;
226     }
227 
228 }