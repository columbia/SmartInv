1 pragma solidity ^0.4.18;
2 
3 // File: contracts/KnowsConstants.sol
4 
5 // These are the specifications of the contract, unlikely to change
6 contract KnowsConstants {
7     // The fixed USD price per BNTY
8     uint public constant FIXED_PRESALE_USD_ETHER_PRICE = 355;
9     uint public constant MICRO_DOLLARS_PER_BNTY_MAINSALE = 16500;
10     uint public constant MICRO_DOLLARS_PER_BNTY_PRESALE = 13200;
11 
12     // Contribution constants
13     uint public constant HARD_CAP_USD = 1500000;                           // in USD the maximum total collected amount
14     uint public constant MAXIMUM_CONTRIBUTION_WHITELIST_PERIOD_USD = 1500; // in USD the maximum contribution amount during the whitelist period
15     uint public constant MAXIMUM_CONTRIBUTION_LIMITED_PERIOD_USD = 10000;  // in USD the maximum contribution amount after the whitelist period ends
16     uint public constant MAX_GAS_PRICE = 70 * (10 ** 9);                   // Max gas price of 70 gwei
17     uint public constant MAX_GAS = 500000;                                 // Max gas that can be sent with tx
18 
19     // Time constants
20     uint public constant SALE_START_DATE = 1513346400;                    // in unix timestamp Dec 15th @ 15:00 CET
21     uint public constant WHITELIST_END_DATE = SALE_START_DATE + 24 hours; // End whitelist 24 hours after sale start date/time
22     uint public constant LIMITS_END_DATE = SALE_START_DATE + 48 hours;    // End all limits 48 hours after the sale start date
23     uint public constant SALE_END_DATE = SALE_START_DATE + 4 weeks;       // end sale in four weeks
24     uint public constant UNFREEZE_DATE = SALE_START_DATE + 76 weeks;      // Bounty0x Reserve locked for 18 months
25 
26     function KnowsConstants() public {}
27 }
28 
29 // File: zeppelin-solidity/contracts/math/SafeMath.sol
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 
108 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   uint256 public totalSupply;
117   function balanceOf(address who) public view returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 // File: zeppelin-solidity/contracts/token/ERC20.sol
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
136 
137 /**
138  * @title SafeERC20
139  * @dev Wrappers around ERC20 operations that throw on failure.
140  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
141  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
142  */
143 library SafeERC20 {
144   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
145     assert(token.transfer(to, value));
146   }
147 
148   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
149     assert(token.transferFrom(from, to, value));
150   }
151 
152   function safeApprove(ERC20 token, address spender, uint256 value) internal {
153     assert(token.approve(spender, value));
154   }
155 }
156 
157 // File: zeppelin-solidity/contracts/token/TokenVesting.sol
158 
159 /**
160  * @title TokenVesting
161  * @dev A token holder contract that can release its token balance gradually like a
162  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
163  * owner.
164  */
165 contract TokenVesting is Ownable {
166   using SafeMath for uint256;
167   using SafeERC20 for ERC20Basic;
168 
169   event Released(uint256 amount);
170   event Revoked();
171 
172   // beneficiary of tokens after they are released
173   address public beneficiary;
174 
175   uint256 public cliff;
176   uint256 public start;
177   uint256 public duration;
178 
179   bool public revocable;
180 
181   mapping (address => uint256) public released;
182   mapping (address => bool) public revoked;
183 
184   /**
185    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
186    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
187    * of the balance will have vested.
188    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
189    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
190    * @param _duration duration in seconds of the period in which the tokens will vest
191    * @param _revocable whether the vesting is revocable or not
192    */
193   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
194     require(_beneficiary != address(0));
195     require(_cliff <= _duration);
196 
197     beneficiary = _beneficiary;
198     revocable = _revocable;
199     duration = _duration;
200     cliff = _start.add(_cliff);
201     start = _start;
202   }
203 
204   /**
205    * @notice Transfers vested tokens to beneficiary.
206    * @param token ERC20 token which is being vested
207    */
208   function release(ERC20Basic token) public {
209     uint256 unreleased = releasableAmount(token);
210 
211     require(unreleased > 0);
212 
213     released[token] = released[token].add(unreleased);
214 
215     token.safeTransfer(beneficiary, unreleased);
216 
217     Released(unreleased);
218   }
219 
220   /**
221    * @notice Allows the owner to revoke the vesting. Tokens already vested
222    * remain in the contract, the rest are returned to the owner.
223    * @param token ERC20 token which is being vested
224    */
225   function revoke(ERC20Basic token) public onlyOwner {
226     require(revocable);
227     require(!revoked[token]);
228 
229     uint256 balance = token.balanceOf(this);
230 
231     uint256 unreleased = releasableAmount(token);
232     uint256 refund = balance.sub(unreleased);
233 
234     revoked[token] = true;
235 
236     token.safeTransfer(owner, refund);
237 
238     Revoked();
239   }
240 
241   /**
242    * @dev Calculates the amount that has already vested but hasn't been released yet.
243    * @param token ERC20 token which is being vested
244    */
245   function releasableAmount(ERC20Basic token) public view returns (uint256) {
246     return vestedAmount(token).sub(released[token]);
247   }
248 
249   /**
250    * @dev Calculates the amount that has already vested.
251    * @param token ERC20 token which is being vested
252    */
253   function vestedAmount(ERC20Basic token) public view returns (uint256) {
254     uint256 currentBalance = token.balanceOf(this);
255     uint256 totalBalance = currentBalance.add(released[token]);
256 
257     if (now < cliff) {
258       return 0;
259     } else if (now >= start.add(duration) || revoked[token]) {
260       return totalBalance;
261     } else {
262       return totalBalance.mul(now.sub(start)).div(duration);
263     }
264   }
265 }
266 
267 // File: contracts/Bounty0xTokenVesting.sol
268 
269 contract Bounty0xTokenVesting is KnowsConstants, TokenVesting {
270     function Bounty0xTokenVesting(address _beneficiary, uint durationWeeks)
271         TokenVesting(_beneficiary, WHITELIST_END_DATE, 0, durationWeeks * 1 weeks, false)
272         public
273     {
274     }
275 }