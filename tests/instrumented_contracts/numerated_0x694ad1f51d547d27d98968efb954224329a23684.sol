1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 
50 
51   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
52     uint256 c = ((a + m - 1) / m) * m;
53     return c;
54   }
55 }
56 
57 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97 }
98 
99 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public view returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
127 
128 /**
129  * @title SafeERC20
130  * @dev Wrappers around ERC20 operations that throw on failure.
131  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
132  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
133  */
134 library SafeERC20 {
135   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
136     assert(token.transfer(to, value));
137   }
138 
139   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
140     assert(token.transferFrom(from, to, value));
141   }
142 
143   function safeApprove(ERC20 token, address spender, uint256 value) internal {
144     assert(token.approve(spender, value));
145   }
146 }
147 
148 // File: zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
149 
150 /**
151  * @title TokenVesting
152  * @dev A token holder contract that can release its token balance gradually like a
153  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
154  * owner.
155  */
156 contract TokenVesting is Ownable {
157   using SafeMath for uint256;
158   using SafeERC20 for ERC20Basic;
159 
160   event Released(uint256 amount);
161   event Revoked();
162 
163   // beneficiary of tokens after they are released
164   address public beneficiary;
165 
166   uint256 public cliff;
167   uint256 public start;
168   uint256 public duration;
169 
170   bool revocable;
171 
172   mapping (address => uint256) public released;
173   mapping (address => bool) public revoked;
174 
175   /**
176    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
177    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
178    * of the balance will have vested.
179    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
180    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
181    * @param _duration duration in seconds of the period in which the tokens will vest
182    * @param _revocable whether the vesting is revocable or not
183    */
184   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
185     require(_beneficiary != address(0));
186     require(_cliff <= _duration);
187 
188     beneficiary = _beneficiary;
189     revocable = _revocable;
190     duration = _duration;
191     cliff = _start.add(_cliff);
192     start = _start;
193   }
194 
195   /**
196    * @notice Transfers vested tokens to beneficiary.
197    * @param token ERC20 token which is being vested
198    */
199   function release(ERC20Basic token) public {
200     uint256 unreleased = releasableAmount(token);
201 
202     require(unreleased > 0);
203 
204     released[token] = released[token].add(unreleased);
205 
206     token.safeTransfer(beneficiary, unreleased);
207 
208     Released(unreleased);
209   }
210 
211   /**
212    * @notice Allows the owner to revoke the vesting. Tokens already vested
213    * remain in the contract, the rest are returned to the owner.
214    * @param token ERC20 token which is being vested
215    */
216   function revoke(ERC20Basic token) public onlyOwner {
217     require(revocable);
218     require(!revoked[token]);
219 
220     uint256 balance = token.balanceOf(this);
221 
222     uint256 unreleased = releasableAmount(token);
223     uint256 refund = balance.sub(unreleased);
224 
225     revoked[token] = true;
226 
227     token.safeTransfer(owner, refund);
228 
229     Revoked();
230   }
231 
232   /**
233    * @dev Calculates the amount that has already vested but hasn't been released yet.
234    * @param token ERC20 token which is being vested
235    */
236   function releasableAmount(ERC20Basic token) public view returns (uint256) {
237     return vestedAmount(token).sub(released[token]);
238   }
239 
240   /**
241    * @dev Calculates the amount that has already vested.
242    * @param token ERC20 token which is being vested
243    */
244   function vestedAmount(ERC20Basic token) public view returns (uint256) {
245     uint256 currentBalance = token.balanceOf(this);
246     uint256 totalBalance = currentBalance.add(released[token]);
247 
248     if (now < cliff) {
249       return 0;
250     } else if (now >= start.add(duration) || revoked[token]) {
251       return totalBalance;
252     } else {
253       return totalBalance.mul(now.sub(start)).div(duration);
254     }
255   }
256 }
257 
258 // File: contracts/LiteXTokenVesting.sol
259 
260 /**
261 * token will released by divider like this:
262 *
263 * if divider is one month, _cliff is zero, _duration is one year, total vesting token is 12000
264 *   Jan 30th will not release any token
265 *   Jan 31st will release 1000
266 *   Feb 1 will not release any token
267 *   Feb 28th will release 1000
268 *   ………………
269 *   ………………
270 *   Dec 31st will release 1000
271 */
272 contract LiteXTokenVesting is TokenVesting {
273 
274   uint256 public divider;
275 
276   function LiteXTokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _divider, bool _revocable) TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable) public   {
277     require(_beneficiary != address(0));
278     require(_cliff <= _duration);
279     require(_divider <= duration);
280     divider = _divider;
281   }
282 
283   /**
284   * @dev Calculates the amount that has already vested.
285   * @param token ERC20 token which is being vested
286   */
287   function vestedAmount(ERC20Basic token) public view returns (uint256) {
288     uint256 currentBalance = token.balanceOf(this);
289     uint256 totalBalance = currentBalance.add(released[token]);
290 
291     if (now < cliff) {
292       return 0;
293     }
294 
295     if (now >= start.add(duration) || revoked[token]) {
296       return totalBalance;
297     }
298     return totalBalance.mul(now.sub(start).div(divider).mul(divider)).div(duration).div(10**18).mul(10**18);
299   }
300 
301 }