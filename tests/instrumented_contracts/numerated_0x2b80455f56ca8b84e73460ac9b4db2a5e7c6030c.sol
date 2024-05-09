1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin/ownership/Ownable.sol
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 // File: contracts/IFOFirstRound.sol
80 
81 contract NILTokenInterface is Ownable {
82   uint8 public decimals;
83   bool public paused;
84   bool public mintingFinished;
85   uint256 public totalSupply;
86 
87   modifier canMint() {
88     require(!mintingFinished);
89     _;
90   }
91 
92   modifier whenNotPaused() {
93     require(!paused);
94     _;
95   }
96 
97   function balanceOf(address who) public constant returns (uint256);
98 
99   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool);
100 
101   function pause() onlyOwner whenNotPaused public;
102 }
103 
104 // @dev Handles the pre-IFO
105 
106 contract IFOFirstRound is Ownable {
107   using SafeMath for uint;
108 
109   NILTokenInterface public token;
110 
111   uint public maxPerWallet = 30000;
112 
113   address public project;
114 
115   address public founders;
116 
117   uint public baseAmount = 1000;
118 
119   // pre dist
120 
121   uint public preDuration;
122 
123   uint public preStartBlock;
124 
125   uint public preEndBlock;
126 
127   // numbers
128 
129   uint public totalParticipants;
130 
131   uint public tokenSupply;
132 
133   bool public projectFoundersReserved;
134 
135   uint public projectReserve = 35;
136 
137   uint public foundersReserve = 15;
138 
139   // states
140 
141   modifier onlyState(bytes32 expectedState) {
142     require(expectedState == currentState());
143     _;
144   }
145 
146   function currentState() public constant returns (bytes32) {
147     uint bn = block.number;
148 
149     if (preStartBlock == 0) {
150       return "Inactive";
151     }
152     else if (bn < preStartBlock) {
153       return "PreDistInitiated";
154     }
155     else if (bn <= preEndBlock) {
156       return "PreDist";
157     }
158     else {
159       return "InBetween";
160     }
161   }
162 
163   // distribution
164 
165   function _toNanoNIL(uint amount) internal constant returns (uint) {
166     return amount.mul(10 ** uint(token.decimals()));
167   }
168 
169   function _fromNanoNIL(uint amount) internal constant returns (uint) {
170     return amount.div(10 ** uint(token.decimals()));
171   }
172 
173   // requiring NIL
174 
175   function() external payable {
176     _getTokens();
177   }
178 
179   // 0x7a0c396d
180   function giveMeNILs() public payable {
181     _getTokens();
182   }
183 
184   function _getTokens() internal {
185     require(currentState() == "PreDist" || currentState() == "Dist");
186     require(msg.sender != address(0));
187 
188     uint balance = token.balanceOf(msg.sender);
189     if (balance == 0) {
190       totalParticipants++;
191     }
192 
193     uint limit = _toNanoNIL(maxPerWallet);
194 
195     require(balance < limit);
196 
197     uint tokensToBeMinted = _toNanoNIL(getTokensAmount());
198 
199     if (balance > 0 && balance + tokensToBeMinted > limit) {
200       tokensToBeMinted = limit.sub(balance);
201     }
202 
203     token.mint(msg.sender, tokensToBeMinted);
204 
205   }
206 
207   function getTokensAmount() public constant returns (uint) {
208     if (currentState() == "PreDist") {
209       return baseAmount.mul(5);
210     } else {
211       return 0;
212     }
213   }
214 
215   function startPreDistribution(uint _startBlock, uint _duration, address _project, address _founders, address _token) public onlyOwner onlyState("Inactive") {
216     require(_startBlock > block.number);
217     require(_duration > 0 && _duration < 30000);
218     require(msg.sender != address(0));
219     require(_project != address(0));
220     require(_founders != address(0));
221 
222     token = NILTokenInterface(_token);
223     token.pause();
224     require(token.paused());
225 
226     project = _project;
227     founders = _founders;
228     preDuration = _duration;
229     preStartBlock = _startBlock;
230     preEndBlock = _startBlock + _duration;
231   }
232 
233   function reserveTokensProjectAndFounders() public onlyOwner onlyState("InBetween") {
234     require(!projectFoundersReserved);
235 
236     tokenSupply = 2 * token.totalSupply();
237 
238     uint amount = tokenSupply.mul(projectReserve).div(100);
239     token.mint(project, amount);
240     amount = tokenSupply.mul(foundersReserve).div(100);
241     token.mint(founders, amount);
242     projectFoundersReserved = true;
243 
244     if (this.balance > 0) {
245       project.transfer(this.balance);
246     }
247   }
248 
249   function totalSupply() public constant returns (uint){
250     require(currentState() != "Inactive");
251     return _fromNanoNIL(token.totalSupply());
252   }
253 
254   function transferTokenOwnership(address _newOwner) public onlyOwner {
255     require(projectFoundersReserved);
256     token.transferOwnership(_newOwner);
257   }
258 
259 }