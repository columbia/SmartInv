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
66     mapping (uint => uint) public pool;
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
94         	balances[currentRound] = balances[currentRound].add(pool[lastRound]);
95     
96             address payable winner = getWinner(lastRound); 
97             winner.transfer(gain);
98         }
99         
100         lastRound = currentRound;
101         
102         uint amount = msg.value;
103         uint toWallet = amount.mul(walletPercent).div(100);
104         uint toNextRound = amount.mul(nextRoundPercent).div(100);
105         uint toJackpot = amount.mul(jackpotPercent).div(100);
106 
107         winners[currentRound] = _player;
108         
109         balances[currentRound] = balances[currentRound].add(amount).sub(toWallet).sub(toNextRound).sub(toJackpot);
110         pool[currentRound] = pool[currentRound].add(toNextRound);
111         
112         jackpot.transfer(toJackpot);
113         wallet.transfer(toWallet);
114     }
115     
116     function getWinner(uint _round) public view returns (address payable) {
117         if (winners[_round] != address(0)) return winners[_round];
118         else return wallet;
119     }
120 
121     function changeRoundTime(uint _time) onlyOwner public {
122         roundTime = _time;
123     }
124     
125     function changeStartTime(uint _time) onlyOwner public {
126         startTime = _time;    
127     }
128     
129     function changeWallet(address payable _wallet) onlyOwner public {
130         wallet = _wallet;
131     }
132 
133     function changeJackpot(address payable _jackpot) onlyOwner public {
134         jackpot = _jackpot;
135     }
136     
137     function changeMinimalBet(uint _minBet) onlyOwner public {
138         minBet = _minBet;
139     }
140     
141     function changePercents(uint _toWinner, uint _toNextRound, uint _toWallet, uint _toJackPot) onlyOwner public {
142         uint total = _toWinner.add(_toNextRound).add(_toWallet).add(_toJackPot);
143         require(total == 100);
144         
145         walletPercent = _toWallet;
146         nextRoundPercent = _toNextRound;
147         jackpotPercent = _toJackPot;
148     }
149     
150     function getCurrentRound() public view returns (uint) {
151         return now.sub(startTime).div(roundTime).add(1); // start round is 1
152     }
153     
154     function getPreviosRound() public view returns (uint) {
155         return getCurrentRound().sub(1);    
156     }
157     
158     function getRoundBalance(uint _round) public view returns (uint) {
159         return balances[_round];
160     }
161     
162     function getPoolBalance(uint _round) public view returns (uint) {
163         return pool[_round];
164     }
165     
166     function getRoundByTime(uint _time) public view returns (uint) {
167         return _time.sub(startTime).div(roundTime);
168     }
169 }
170 
171 /**
172  * @title SafeMath
173  * @dev Math operations with safety checks that throw on error
174  */
175 library SafeMath {
176 
177     /**
178     * @dev Multiplies two numbers, throws on overflow.
179     */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         if (a == 0) {
182             return 0;
183         }
184         uint256 c = a * b;
185         assert(c / a == b);
186         return c;
187     }
188 
189     /**
190     * @dev Integer division of two numbers, truncating the quotient.
191     */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         // assert(b > 0); // Solidity automatically throws when dividing by 0
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196         return c;
197     }
198 
199     /**
200     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
201     */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         assert(b <= a);
204         return a - b;
205     }
206 
207     /**
208     * @dev Adds two numbers, throws on overflow.
209     */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         assert(c >= a);
213         return c;
214     }
215 }