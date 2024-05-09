1 pragma solidity 0.5.4;
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
60     uint public startTime = 1551780000; // 03.05.2019 10:00:00
61     uint public roundTime = 300; // 5 min in sec
62     
63     address payable public wallet;
64     address payable public jackpot;
65     
66     uint public walletPercent = 20;
67     uint public nextRoundPercent = 15;
68     uint public jackpotPercent = 15;
69         
70     constructor (address payable _wallet, address payable _jackpot) public {
71         require(_wallet != address(0));
72         require(_jackpot != address(0));
73         
74     	wallet = _wallet;
75     	jackpot = _jackpot;  
76     }
77     
78     function () external payable {
79         require(gasleft() > 150000);
80         setBet(msg.sender);
81     }
82     
83     function setBet(address payable _player) public payable {
84         require(msg.value >= minBet);
85         
86         uint currentRound = getCurrentRound();
87         
88         uint previosRound = getPreviosRound();
89         if (balances[previosRound] > 0) {
90         	
91         	uint gain = balances[previosRound];
92         	balances[previosRound] = 0;
93     
94             address payable winner = getWinner(previosRound); 
95             winner.transfer(gain);
96         }
97 
98         uint amount = msg.value;
99         uint toWallet = amount.mul(walletPercent).div(100);
100         uint toNextRound = amount.mul(nextRoundPercent).div(100);
101         uint toJackpot = amount.mul(jackpotPercent).div(100);
102 
103         winners[currentRound] = _player;
104         
105         balances[currentRound] = balances[currentRound].add(amount).sub(toWallet).sub(toNextRound).sub(toJackpot);
106         balances[currentRound.add(1)] = balances[currentRound.add(1)].add(toNextRound);
107         
108         jackpot.transfer(toJackpot);
109         wallet.transfer(toWallet);
110     }
111     
112     function getWinner(uint _round) public view returns (address payable) {
113         if (winners[_round] != address(0)) return winners[_round];
114         else return wallet;
115     }
116     
117     function getGain(uint _round) public {
118 	    require(_round < getCurrentRound());
119         require(msg.sender == getWinner(_round));
120         
121     	uint gain = balances[_round];
122     	balances[_round] = 0;
123 
124         address(msg.sender).transfer(gain);
125     }
126     
127     function changeRoundTime(uint _time) onlyOwner public {
128         roundTime = _time;
129     }
130     
131     function changeStartTime(uint _time) onlyOwner public {
132         startTime = _time;    
133     }
134     
135     function changeWallet(address payable _wallet) onlyOwner public {
136         wallet = _wallet;
137     }
138 
139     function changeJackpot(address payable _jackpot) onlyOwner public {
140         jackpot = _jackpot;
141     }
142     
143     function changeMinimalBet(uint _minBet) onlyOwner public {
144         minBet = _minBet;
145     }
146     
147     function changePercents(uint _toWinner, uint _toNextRound, uint _toWallet, uint _toJackPot) onlyOwner public {
148         uint total = _toWinner.add(_toNextRound).add(_toWallet).add(_toJackPot);
149         require(total == 100);
150         
151         walletPercent = _toWallet;
152         nextRoundPercent = _toNextRound;
153         jackpotPercent = _toJackPot;
154     }
155     
156     function getCurrentRound() public view returns (uint) {
157         return now.sub(startTime).div(roundTime).add(1); // start round is 1
158     }
159     
160     function getPreviosRound() public view returns (uint) {
161         return getCurrentRound().sub(1);    
162     }
163     
164     function getRoundBalance(uint _round) public view returns (uint) {
165         return balances[_round];
166     }
167     
168     function getRoundByTime(uint _time) public view returns (uint) {
169         return _time.sub(startTime).div(roundTime);
170     }
171 }
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that throw on error
176  */
177 library SafeMath {
178 
179     /**
180     * @dev Multiplies two numbers, throws on overflow.
181     */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         if (a == 0) {
184             return 0;
185         }
186         uint256 c = a * b;
187         assert(c / a == b);
188         return c;
189     }
190 
191     /**
192     * @dev Integer division of two numbers, truncating the quotient.
193     */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         // assert(b > 0); // Solidity automatically throws when dividing by 0
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198         return c;
199     }
200 
201     /**
202     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
203     */
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         assert(b <= a);
206         return a - b;
207     }
208 
209     /**
210     * @dev Adds two numbers, throws on overflow.
211     */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         assert(c >= a);
215         return c;
216     }
217 }