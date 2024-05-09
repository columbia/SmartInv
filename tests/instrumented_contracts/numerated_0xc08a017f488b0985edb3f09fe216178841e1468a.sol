1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/ReturnVestingRegistry.sol
46 
47 contract ReturnVestingRegistry is Ownable {
48 
49   mapping (address => address) public returnAddress;
50 
51   function record(address from, address to) onlyOwner public {
52     require(from != 0);
53 
54     returnAddress[from] = to;
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   function totalSupply() public view returns (uint256);
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
73 
74 /**
75  * @title ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 contract ERC20 is ERC20Basic {
79   function allowance(address owner, address spender) public view returns (uint256);
80   function transferFrom(address from, address to, uint256 value) public returns (bool);
81   function approve(address spender, uint256 value) public returns (bool);
82   event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: contracts/TerraformReserve.sol
86 
87 
88 // File: zeppelin-solidity/contracts/math/Math.sol
89 
90 /**
91  * @title Math
92  * @dev Assorted math operations
93  */
94 library Math {
95   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
96     return a >= b ? a : b;
97   }
98 
99   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
100     return a < b ? a : b;
101   }
102 
103   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
104     return a >= b ? a : b;
105   }
106 
107   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
108     return a < b ? a : b;
109   }
110 }
111 
112 // File: zeppelin-solidity/contracts/math/SafeMath.sol
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119 
120   /**
121   * @dev Multiplies two numbers, throws on overflow.
122   */
123   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124     if (a == 0) {
125       return 0;
126     }
127     uint256 c = a * b;
128     assert(c / a == b);
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers, truncating the quotient.
134   */
135   function div(uint256 a, uint256 b) internal pure returns (uint256) {
136     // assert(b > 0); // Solidity automatically throws when dividing by 0
137     uint256 c = a / b;
138     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139     return c;
140   }
141 
142   /**
143   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     assert(b <= a);
147     return a - b;
148   }
149 
150   /**
151   * @dev Adds two numbers, throws on overflow.
152   */
153   function add(uint256 a, uint256 b) internal pure returns (uint256) {
154     uint256 c = a + b;
155     assert(c >= a);
156     return c;
157   }
158 }
159 
160 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
161 
162 /**
163  * @title SafeERC20
164  * @dev Wrappers around ERC20 operations that throw on failure.
165  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
166  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
167  */
168 library SafeERC20 {
169   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
170     assert(token.transfer(to, value));
171   }
172 
173   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
174     assert(token.transferFrom(from, to, value));
175   }
176 
177   function safeApprove(ERC20 token, address spender, uint256 value) internal {
178     assert(token.approve(spender, value));
179   }
180 }
181 
182 // File: contracts/TokenVesting.sol
183 
184 /**
185  * @title TokenVesting
186  * @dev A token holder contract that can release its token balance gradually like a
187  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
188  * owner.
189  */
190 contract TokenVesting is Ownable {
191   using SafeMath for uint256;
192   using SafeERC20 for ERC20;
193 
194   event Released(uint256 amount);
195   event Revoked();
196 
197   // beneficiary of tokens after they are released
198   address public beneficiary;
199 
200   uint256 public cliff;
201   uint256 public start;
202   uint256 public duration;
203 
204   bool public revocable;
205   bool public revoked;
206 
207   uint256 public released;
208 
209   ERC20 public token;
210 
211   /**
212    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
213    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
214    * of the balance will have vested.
215    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
216    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
217    * @param _duration duration in seconds of the period in which the tokens will vest
218    * @param _revocable whether the vesting is revocable or not
219    * @param _token address of the ERC20 token contract
220    */
221   constructor(
222     address _beneficiary,
223     uint256 _start,
224     uint256 _cliff,
225     uint256 _duration,
226     bool    _revocable,
227     address _token
228   ) public {
229     require(_beneficiary != 0x0);
230     require(_cliff <= _duration);
231 
232     beneficiary = _beneficiary;
233     start       = _start;
234     cliff       = _start.add(_cliff);
235     duration    = _duration;
236     revocable   = _revocable;
237     token       = ERC20(_token);
238   }
239 
240   /**
241    * @notice Only allow calls from the beneficiary of the vesting contract
242    */
243   modifier onlyBeneficiary() {
244     require(msg.sender == beneficiary);
245     _;
246   }
247 
248   /**
249    * @notice Allow the beneficiary to change its address
250    * @param target the address to transfer the right to
251    */
252   function changeBeneficiary(address target) onlyBeneficiary public {
253     require(target != 0);
254     beneficiary = target;
255   }
256 
257   /**
258    * @notice Transfers vested tokens to beneficiary.
259    */
260   function release() public {
261     require(now >= cliff);
262     _releaseTo(beneficiary);
263   }
264 
265   /**
266    * @notice Transfers vested tokens to a target address.
267    * @param target the address to send the tokens to
268    */
269   function releaseTo(address target) onlyBeneficiary public {
270     require(now >= cliff);
271     _releaseTo(target);
272   }
273 
274   /**
275    * @notice Transfers vested tokens to beneficiary.
276    */
277   function _releaseTo(address target) internal {
278     uint256 unreleased = releasableAmount();
279 
280     released = released.add(unreleased);
281 
282     token.safeTransfer(target, unreleased);
283 
284     emit Released(released);
285   }
286 
287   /**
288    * @notice Allows the owner to revoke the vesting. Tokens already vested are sent to the beneficiary.
289    */
290   function revoke() onlyOwner public {
291     require(revocable);
292     require(!revoked);
293 
294     // Release all vested tokens
295     _releaseTo(beneficiary);
296 
297     // Send the remainder to the owner
298     token.safeTransfer(owner, token.balanceOf(this));
299 
300     revoked = true;
301 
302     emit Revoked();
303   }
304 
305 
306   /**
307    * @dev Calculates the amount that has already vested but hasn't been released yet.
308    */
309   function releasableAmount() public view returns (uint256) {
310     return vestedAmount().sub(released);
311   }
312 
313   /**
314    * @dev Calculates the amount that has already vested.
315    */
316   function vestedAmount() public view returns (uint256) {
317     uint256 currentBalance = token.balanceOf(this);
318     uint256 totalBalance = currentBalance.add(released);
319 
320     if (now < cliff) {
321       return 0;
322     } else if (now >= start.add(duration) || revoked) {
323       return totalBalance;
324     } else {
325       return totalBalance.mul(now.sub(start)).div(duration);
326     }
327   }
328 
329   /**
330    * @notice Allow withdrawing any token other than the relevant one
331    */
332   function releaseForeignToken(ERC20 _token, uint256 amount) onlyOwner public {
333     require(_token != token);
334     _token.transfer(owner, amount);
335   }
336 }