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
49 contract DailyLucky is Ownable {
50     using SafeMath for uint;
51     
52     // round => winner
53     mapping(uint => address) public winners;
54     
55     // round => gain
56     mapping(uint => uint) public balances;
57     
58     uint bet = 0.001 ether;
59     
60     uint startTime = 1551700800; // 03.04.2019 15:00:00
61     uint roundTime = 3600; // 1 hour in sec
62     
63     address payable public wallet;
64     address payable public jackpot;
65     
66     constructor (address payable _wallet, address payable _jackpot) public {
67         require(_wallet != address(0));
68         require(_jackpot != address(0));
69         
70     	wallet = _wallet;
71     	jackpot = _jackpot;  
72     }
73     
74     function () external payable {
75         setBet(msg.sender);
76     }
77     
78     function setBet(address _player) public payable {
79         require(msg.value >= bet);
80         
81         uint currentRound = now.sub(startTime).div(roundTime);
82 
83         uint amount = msg.value;
84         uint toWallet = amount.mul(20).div(100);
85         uint toNextRound = amount.mul(15).div(100);
86         uint toSuperJackpot = amount.mul(15).div(100);
87 
88         winners[currentRound] = _player;
89         
90         balances[currentRound] = balances[currentRound].add(amount).sub(toWallet).sub(toNextRound).sub(toSuperJackpot);
91         balances[currentRound.add(1)] = balances[currentRound.add(1)].add(toNextRound);
92         
93         jackpot.transfer(toSuperJackpot);
94         wallet.transfer(toWallet);
95     }
96     
97     function getWinner(uint _round) public view returns (address) {
98         if (winners[_round] != address(0)) return winners[_round];
99         else return owner;
100     }
101     
102     function getGain(uint _round) public {
103 	    require(_round < now.sub(startTime).div(roundTime));
104         require(msg.sender == getWinner(_round));
105         
106     	uint gain = balances[_round];
107     	balances[_round] = 0;
108 
109         address(msg.sender).transfer(gain);
110     }
111     
112     function changeRoundTime(uint _time) onlyOwner public {
113         roundTime = _time;
114     }
115     
116     function changeStartTime(uint _time) onlyOwner public {
117         startTime = _time;    
118     }
119     
120     function changeWallet(address payable _wallet) onlyOwner public {
121         wallet = _wallet;
122     }
123 
124     function changeJackpot(address payable _jackpot) onlyOwner public {
125         jackpot = _jackpot;
126     }
127     
128     function getCurrentRound() public view returns (uint) {
129         return now.sub(startTime).div(roundTime);
130     }
131     
132     function getRoundBalance(uint _round) public view returns (uint) {
133         return balances[_round];
134     }
135     
136     function getRoundByTime(uint _time) public view returns (uint) {
137         return _time.sub(startTime).div(roundTime);
138     }
139 }
140 
141 /**
142  * @title SafeMath
143  * @dev Math operations with safety checks that throw on error
144  */
145 library SafeMath {
146 
147     /**
148     * @dev Multiplies two numbers, throws on overflow.
149     */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         if (a == 0) {
152             return 0;
153         }
154         uint256 c = a * b;
155         assert(c / a == b);
156         return c;
157     }
158 
159     /**
160     * @dev Integer division of two numbers, truncating the quotient.
161     */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // assert(b > 0); // Solidity automatically throws when dividing by 0
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166         return c;
167     }
168 
169     /**
170     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171     */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         assert(b <= a);
174         return a - b;
175     }
176 
177     /**
178     * @dev Adds two numbers, throws on overflow.
179     */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         assert(c >= a);
183         return c;
184     }
185 }