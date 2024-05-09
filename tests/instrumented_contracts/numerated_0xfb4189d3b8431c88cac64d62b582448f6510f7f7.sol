1 pragma solidity 0.5.7;
2 
3 
4 contract Ownable {
5     address public owner;
6     address public pendingOwner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /**
11     * @dev Throws if called by any account other than the owner.
12     */
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /**
19      * @dev Modifier throws if called by any account other than the pendingOwner.
20      */
21     modifier onlyPendingOwner() {
22         require(msg.sender == pendingOwner);
23         _;
24     }
25 
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     /**
31      * @dev Allows the current owner to set the pendingOwner address.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner public {
35         pendingOwner = newOwner;
36     }
37 
38     /**
39      * @dev Allows the pendingOwner address to finalize the transfer.
40      */
41     function claimOwnership() onlyPendingOwner public {
42         emit OwnershipTransferred(owner, pendingOwner);
43         owner = pendingOwner;
44         pendingOwner = address(0);
45     }
46 }
47 
48 
49 contract FastnFurious is Ownable {
50     using SafeMath for uint;
51     
52     // round => winner
53     mapping(uint => address payable) public winners;
54     
55     // round => gain
56     mapping(uint => uint) public balances;
57     
58     uint public minBet = 0.1 ether; // 0.1 ether;
59     
60     uint public startTime = 1554076800; // 04.01.2019 00:00:00
61     uint public roundTime = 60; // 1 min in sec
62     
63     address payable public wallet;
64     address payable public jackpot;
65     
66     uint public pool;
67     
68     uint public walletPercent = 20;
69     uint public nextRoundPercent = 15;
70     uint public jackpotPercent = 15;
71     uint public lastRound;
72         
73     constructor (address payable _wallet, address payable _jackpot) public {
74         require(_wallet != address(0));
75         require(_jackpot != address(0));
76         
77     	wallet = _wallet;
78     	jackpot = _jackpot;  
79     }
80     
81     function () external payable {
82         require(gasleft() > 150000);
83         setBet(msg.sender);
84     }
85     
86     function setBet(address payable _player) public payable {
87         require(msg.value >= minBet);
88         
89         uint currentRound = getCurrentRound();
90         
91         if (currentRound > 1 && balances[currentRound] == 0) {
92             uint gain = balances[lastRound];
93         	balances[lastRound] = 0;
94         	balances[currentRound] = balances[currentRound].add(pool);
95         	pool = 0;
96     
97             address payable winner = getWinner(lastRound); 
98             winner.transfer(gain);
99         }
100         
101         lastRound = currentRound;
102         
103         uint amount = msg.value;
104         uint toWallet = amount.mul(walletPercent).div(100);
105         uint toNextRound = amount.mul(nextRoundPercent).div(100);
106         uint toJackpot = amount.mul(jackpotPercent).div(100);
107 
108         winners[currentRound] = _player;
109         
110         balances[currentRound] = balances[currentRound].add(amount).sub(toWallet).sub(toNextRound).sub(toJackpot);
111         pool = pool.add(toNextRound);
112         
113         jackpot.transfer(toJackpot);
114         wallet.transfer(toWallet);
115     }
116     
117     function getWinner(uint _round) public view returns (address payable) {
118         if (winners[_round] != address(0)) return winners[_round];
119         else return wallet;
120     }
121 
122     function changeRoundTime(uint _time) onlyOwner public {
123         roundTime = _time;
124     }
125     
126     function changeStartTime(uint _time) onlyOwner public {
127         startTime = _time;    
128     }
129     
130     function changeWallet(address payable _wallet) onlyOwner public {
131         wallet = _wallet;
132     }
133 
134     function changeJackpot(address payable _jackpot) onlyOwner public {
135         jackpot = _jackpot;
136     }
137     
138     function changeMinimalBet(uint _minBet) onlyOwner public {
139         minBet = _minBet;
140     }
141     
142     function changePercents(uint _toWinner, uint _toNextRound, uint _toWallet, uint _toJackPot) onlyOwner public {
143         uint total = _toWinner.add(_toNextRound).add(_toWallet).add(_toJackPot);
144         require(total == 100);
145         
146         walletPercent = _toWallet;
147         nextRoundPercent = _toNextRound;
148         jackpotPercent = _toJackPot;
149     }
150     
151     function getCurrentRound() public view returns (uint) {
152         return now.sub(startTime).div(roundTime).add(1); // start round is 1
153     }
154     
155     function getPreviosRound() public view returns (uint) {
156         return getCurrentRound().sub(1);    
157     }
158     
159     function getRoundBalance(uint _round) public view returns (uint) {
160         return balances[_round];
161     }
162     
163     function getRoundByTime(uint _time) public view returns (uint) {
164         return _time.sub(startTime).div(roundTime);
165     }
166 }
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173 
174     /**
175     * @dev Multiplies two numbers, throws on overflow.
176     */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         if (a == 0) {
179             return 0;
180         }
181         uint256 c = a * b;
182         assert(c / a == b);
183         return c;
184     }
185 
186     /**
187     * @dev Integer division of two numbers, truncating the quotient.
188     */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         // assert(b > 0); // Solidity automatically throws when dividing by 0
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193         return c;
194     }
195 
196     /**
197     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198     */
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         assert(b <= a);
201         return a - b;
202     }
203 
204     /**
205     * @dev Adds two numbers, throws on overflow.
206     */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         assert(c >= a);
210         return c;
211     }
212 }