1 pragma solidity 0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: contracts/SvdMainSale.sol
129 
130 /**
131  * @title SvdMainSale
132  * @dev This crowdsale contract filters investments made according to
133  *         - time
134  *         - amount invested (in Wei)
135  *      and forwards them to a predefined wallet in case all the filtering conditions are met.
136  */
137 contract SvdMainSale is Pausable {
138     using SafeMath for uint256;
139 
140     // start and end timestamps where investments are allowed (both inclusive)
141     uint256 public startTime;
142     uint256 public endTime;
143 
144     // address where funds are collected
145     address public wallet;
146 
147     // track the investments made from each address
148     mapping(address => uint256) public investments;
149 
150     // total amount of funds raised (in wei)
151     uint256 public weiRaised;
152 
153     uint256 public minWeiInvestment;
154     uint256 public maxWeiInvestment;
155 
156     /**
157      * @dev Event for token purchase logging
158      * @param purchaser who paid for the tokens
159      * @param beneficiary who got the tokens
160      * @param value weis paid for purchase
161      */
162     event Investment(address indexed purchaser,
163         address indexed beneficiary,
164         uint256 value);
165 
166     /**
167      * @dev Constructor
168      * @param _startTime the time to begin the crowdsale in seconds since the epoch
169      * @param _endTime the time to begin the crowdsale in seconds since the epoch. Must be later than _startTime.
170      * @param _minWeiInvestment the minimum amount for one single investment (in Wei)
171      * @param _maxWeiInvestment the maximum amount for one single investment (in Wei)
172      * @param _wallet the address to which funds will be directed to
173      */
174     function SvdMainSale(uint256 _startTime,
175         uint256 _endTime,
176         uint256 _minWeiInvestment,
177         uint256 _maxWeiInvestment,
178         address _wallet) public {
179         require(_endTime > _startTime);
180         require(_minWeiInvestment > 0);
181         require(_maxWeiInvestment > _minWeiInvestment);
182         require(_wallet != address(0));
183 
184         startTime = _startTime;
185         endTime = _endTime;
186 
187         minWeiInvestment = _minWeiInvestment;
188         maxWeiInvestment = _maxWeiInvestment;
189 
190         wallet = _wallet;
191     }
192 
193     /**
194      * @dev External payable function to receive funds and buy tokens.
195      */
196     function () external payable {
197         buyTokens(msg.sender);
198     }
199 
200     /**
201      * @dev Adapted Crowdsale#hasStarted
202      * @return true if SvdMainSale event has started
203      */
204     function hasStarted() external view returns (bool) {
205         return now >= startTime;
206     }
207 
208     /**
209      * @dev Adapted Crowdsale#hasEnded
210      * @return true if SvdMainSale event has ended
211      */
212     function hasEnded() external view returns (bool) {
213         return now > endTime;
214     }
215 
216     /**
217      * @dev Low level token purchase function
218      */
219     function buyTokens(address beneficiary) public whenNotPaused payable {
220         require(beneficiary != address(0));
221         require(validPurchase());
222 
223         uint256 weiAmount = msg.value;
224 
225         // track how much wei is raised in total
226         weiRaised = weiRaised.add(weiAmount);
227 
228         // track how much was transfered by the specific investor
229         investments[beneficiary] = investments[beneficiary].add(weiAmount);
230 
231         Investment(msg.sender, beneficiary, weiAmount);
232 
233         forwardFunds();
234     }
235 
236     // send ether (wei) to the fund collection wallet
237     // override to create custom fund forwarding mechanisms
238     function forwardFunds() internal {
239         wallet.transfer(msg.value);
240     }
241 
242     // overriding Crowdsale#validPurchase to add extra cap logic
243     // @return true if investors can buy at the moment
244     function validPurchase() internal view returns (bool) {
245         if (msg.value < minWeiInvestment || msg.value > maxWeiInvestment) {
246             return false;
247         }
248         bool withinPeriod = (now >= startTime) && (now <= endTime); 
249         return withinPeriod;
250     }
251 }