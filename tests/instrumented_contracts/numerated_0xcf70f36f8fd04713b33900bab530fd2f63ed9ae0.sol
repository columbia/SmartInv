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
60     uint256 public allowedBetAmount = 5000000000000000; // 0.005 ETH
61     /**
62     * You need to guess requiredPoints times in a row to win jackpot.
63     */
64     uint256 public requiredPoints = 3;
65     /**
66     * Every bet is split: 10% to owner, 70% to prize pool
67     * we preserve 20% for next prize pool
68     */
69     uint256 public ownerProfitPercent = 10;
70     uint256 public nextPrizePoolPercent = 20;
71     uint256 public prizePoolPercent = 70; 
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
84     modifier onlyOwner() {
85         require(msg.sender == owner.addr);
86         _;
87     }
88 
89     modifier notLess() {
90         require(msg.value >= allowedBetAmount);
91         _;
92     }
93 
94     modifier notMore() {
95         if(msg.value > allowedBetAmount) {
96             msg.sender.transfer( SafeMath.sub(msg.value, allowedBetAmount) );
97         }
98         _;
99     }
100     
101     modifier onlyOnce() {
102         Player storage player = playersStorage[msg.sender];
103         require(player.lastBlock != block.number);
104         player.lastBlock = block.number;
105         _;
106     }
107     
108     function safeGetPercent(uint256 amount, uint256 percent) private pure returns(uint256) {
109         return SafeMath.mul( SafeMath.div( SafeMath.sub(amount, amount%100), 100), percent );
110     }
111     
112     function TheNextBlock() public {
113         owner.addr = msg.sender;
114     }
115 
116     /**
117      * This is left for donations.
118      * Ether received in this(fallback) function
119      * will appear on owners balance.
120      */
121     function () public payable {
122          owner.balance = owner.balance.add(msg.value);
123     }
124 
125     function placeBet(address _miner) 
126         public
127         payable
128         notLess
129         notMore
130         onlyOnce {
131             
132             totalBetCount = totalBetCount.add(1);
133             BetReceived(msg.sender, _miner, block.coinbase);
134 
135             owner.balance = owner.balance.add( safeGetPercent(allowedBetAmount, ownerProfitPercent) );
136             prizePool = prizePool.add( safeGetPercent(allowedBetAmount, prizePoolPercent) );
137             nextPrizePool = nextPrizePool.add( safeGetPercent(allowedBetAmount, nextPrizePoolPercent) );
138 
139             if(_miner == block.coinbase) {
140                 
141                 playersPoints[msg.sender] = playersPoints[msg.sender].add(1);
142 
143                 if(playersPoints[msg.sender] == requiredPoints) {
144                     
145                     if(prizePool >= allowedBetAmount) {
146                         Jackpot(msg.sender, prizePool);
147                         playersStorage[msg.sender].balance = playersStorage[msg.sender].balance.add(prizePool);
148                         prizePool = nextPrizePool;
149                         nextPrizePool = 0;
150                         playersPoints[msg.sender] = 0;
151                     } else {
152                         Jackpot(msg.sender, 0);
153                         playersPoints[msg.sender]--;
154                     }
155                 }
156 
157             } else {
158                 playersPoints[msg.sender] = 0;
159             }
160     }
161 
162     function getPlayerData(address playerAddr) public view returns(uint256 lastBlock, uint256 balance) {
163         balance =  playersStorage[playerAddr].balance;
164         lastBlock =  playersStorage[playerAddr].lastBlock;
165     }
166 
167     function getPlayersBalance(address playerAddr) public view returns(uint256) {
168         return playersStorage[playerAddr].balance;
169     }
170     
171     function getPlayersPoints(address playerAddr) public view returns(uint256) {
172         return playersPoints[playerAddr];
173     }
174 
175     function getMyPoints() public view returns(uint256) {
176         return playersPoints[msg.sender];
177     }
178     
179     function getMyBalance() public view returns(uint256) {
180         return playersStorage[msg.sender].balance;
181     }
182     
183     function withdrawMyFunds() public {
184         uint256 balance = playersStorage[msg.sender].balance;
185         if(balance != 0) {
186             playersStorage[msg.sender].balance = 0;
187             msg.sender.transfer(balance);
188         }
189     }
190     
191     function withdrawOwnersFunds() public onlyOwner {
192         uint256 balance = owner.balance;
193         owner.balance = 0;
194         owner.addr.transfer(balance);
195     }
196     
197     function getOwnersBalance() public view returns(uint256) {
198         return owner.balance;
199     }
200     
201     function getPrizePool() public view returns(uint256) {
202         return prizePool;
203     }
204 
205     function getNextPrizePool() public view returns(uint256) {
206         return nextPrizePool;
207     }
208     
209     
210     function getBalance() public view returns(uint256) {
211         return this.balance;
212     }
213         
214     function changeOwner(address newOwner) public onlyOwner {
215         owner.addr = newOwner;
216     }
217 
218 }