1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 library SafeERC20 {
95   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
96     assert(token.transfer(to, value));
97   }
98 
99   function safeTransferFrom(
100     ERC20 token,
101     address from,
102     address to,
103     uint256 value
104   )
105     internal
106   {
107     assert(token.transferFrom(from, to, value));
108   }
109 
110   function safeApprove(ERC20 token, address spender, uint256 value) internal {
111     assert(token.approve(spender, value));
112   }
113 }
114 
115 contract TokenVesting is Ownable {
116   using SafeMath for uint256;
117   using SafeERC20 for ERC20Basic;
118 
119   event Released(uint256 amount);
120   event Revoked();
121 
122   // beneficiary of tokens after they are released
123   address public beneficiary;
124 
125   uint256 public cliff;
126   uint256 public start;
127   uint256 public duration;
128 
129   bool public revocable;
130 
131   mapping (address => uint256) public released;
132   mapping (address => bool) public revoked;
133 
134   /**
135    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
136    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
137    * of the balance will have vested.
138    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
139    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
140    * @param _duration duration in seconds of the period in which the tokens will vest
141    * @param _revocable whether the vesting is revocable or not
142    */
143   function TokenVesting(
144     address _beneficiary,
145     uint256 _start,
146     uint256 _cliff,
147     uint256 _duration,
148     bool _revocable
149   )
150     public
151   {
152     require(_beneficiary != address(0));
153     require(_cliff <= _duration);
154 
155     beneficiary = _beneficiary;
156     revocable = _revocable;
157     duration = _duration;
158     cliff = _start.add(_cliff);
159     start = _start;
160   }
161 
162   /**
163    * @notice Transfers vested tokens to beneficiary.
164    * @param token ERC20 token which is being vested
165    */
166   function release(ERC20Basic token) public {
167     uint256 unreleased = releasableAmount(token);
168 
169     require(unreleased > 0);
170 
171     released[token] = released[token].add(unreleased);
172 
173     token.safeTransfer(beneficiary, unreleased);
174 
175     emit Released(unreleased);
176   }
177 
178   /**
179    * @notice Allows the owner to revoke the vesting. Tokens already vested
180    * remain in the contract, the rest are returned to the owner.
181    * @param token ERC20 token which is being vested
182    */
183   function revoke(ERC20Basic token) public onlyOwner {
184     require(revocable);
185     require(!revoked[token]);
186 
187     uint256 balance = token.balanceOf(this);
188 
189     uint256 unreleased = releasableAmount(token);
190     uint256 refund = balance.sub(unreleased);
191 
192     revoked[token] = true;
193 
194     token.safeTransfer(owner, refund);
195 
196     emit Revoked();
197   }
198 
199   /**
200    * @dev Calculates the amount that has already vested but hasn't been released yet.
201    * @param token ERC20 token which is being vested
202    */
203   function releasableAmount(ERC20Basic token) public view returns (uint256) {
204     return vestedAmount(token).sub(released[token]);
205   }
206 
207   /**
208    * @dev Calculates the amount that has already vested.
209    * @param token ERC20 token which is being vested
210    */
211   function vestedAmount(ERC20Basic token) public view returns (uint256) {
212     uint256 currentBalance = token.balanceOf(this);
213     uint256 totalBalance = currentBalance.add(released[token]);
214 
215     if (block.timestamp < cliff) {
216       return 0;
217     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
218       return totalBalance;
219     } else {
220       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
221     }
222   }
223 }
224 
225 contract VariableRateTokenVesting is TokenVesting {
226 
227     using SafeMath for uint256;
228     using SafeERC20 for ERC20Basic;
229 
230     // Every element between 0 and 100, and should increase monotonically.
231     // [10, 20, 30, ..., 100] means releasing 10% for each period.
232     uint256[] public cumulativeRates;
233 
234     // Seconds between each period.
235     uint256 public interval;
236 
237     constructor(
238         address _beneficiary,
239         uint256 _start,
240         uint256[] _cumulativeRates,
241         uint256 _interval
242     ) public
243         // We don't need `duration`, also always allow revoking.
244         TokenVesting(_beneficiary, _start, /*cliff*/0, /*duration: uint max*/~uint256(0), true)
245     {
246         // Validate rates.
247         for (uint256 i = 0; i < _cumulativeRates.length; ++i) {
248             require(_cumulativeRates[i] <= 100);
249             if (i > 0) {
250                 require(_cumulativeRates[i] >= _cumulativeRates[i - 1]);
251             }
252         }
253 
254         cumulativeRates = _cumulativeRates;
255         interval = _interval;
256         // Hardcode owner.
257         owner = 0x0298CF0d5B60a0aD885518adCB4c3fc49b36D347;
258     }
259 
260     /// @dev Override to use cumulative rates to calculated amount for vesting.
261     function vestedAmount(ERC20Basic token) public view returns (uint256) {
262         if (now < start) {
263             return 0;
264         }
265 
266         uint256 currentBalance = token.balanceOf(this);
267         uint256 totalBalance = currentBalance.add(released[token]);
268 
269         uint256 timeSinceStart = now.sub(start);
270         uint256 currentPeriod = timeSinceStart.div(interval);
271         if (currentPeriod >= cumulativeRates.length) {
272             return totalBalance;
273         }
274         return totalBalance.mul(cumulativeRates[currentPeriod]).div(100);
275     }
276 }
277 
278 contract BatchReleaser {
279     
280     function batchRelease(address[] vestingContracts, ERC20Basic token) external {
281         for (uint256 i = 0; i < vestingContracts.length; i++) {
282             VariableRateTokenVesting vesting = VariableRateTokenVesting(vestingContracts[i]);
283             vesting.release(token);
284         }
285     }
286     
287 }