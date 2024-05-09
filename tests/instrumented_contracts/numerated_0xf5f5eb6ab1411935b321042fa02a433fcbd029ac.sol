1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 
78 
79 
80 
81 
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender)
90     public view returns (uint256);
91 
92   function transferFrom(address from, address to, uint256 value)
93     public returns (bool);
94 
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 
104 
105 /**
106  * @title SafeERC20
107  * @dev Wrappers around ERC20 operations that throw on failure.
108  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
109  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
110  */
111 library SafeERC20 {
112   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
113     require(token.transfer(to, value));
114   }
115 
116   function safeTransferFrom(
117     ERC20 token,
118     address from,
119     address to,
120     uint256 value
121   )
122     internal
123   {
124     require(token.transferFrom(from, to, value));
125   }
126 
127   function safeApprove(ERC20 token, address spender, uint256 value) internal {
128     require(token.approve(spender, value));
129   }
130 }
131 
132 
133 /* solium-disable security/no-block-members */
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 /**
144  * @title SafeMath
145  * @dev Math operations with safety checks that throw on error
146  */
147 library SafeMath {
148 
149   /**
150   * @dev Multiplies two numbers, throws on overflow.
151   */
152   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
153     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
154     // benefit is lost if 'b' is also tested.
155     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
156     if (a == 0) {
157       return 0;
158     }
159 
160     c = a * b;
161     assert(c / a == b);
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers, truncating the quotient.
167   */
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     // assert(b > 0); // Solidity automatically throws when dividing by 0
170     // uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172     return a / b;
173   }
174 
175   /**
176   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   /**
184   * @dev Adds two numbers, throws on overflow.
185   */
186   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
187     c = a + b;
188     assert(c >= a);
189     return c;
190   }
191 }
192 
193 
194 
195 /**
196  * @title TokenVesting
197  * @dev A token holder contract that can release its token balance gradually like a
198  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
199  * owner.
200  */
201 contract TokenVesting is Ownable {
202   using SafeMath for uint256;
203   using SafeERC20 for ERC20Basic;
204 
205   event Released(uint256 amount);
206   event Revoked();
207 
208   // beneficiary of tokens after they are released
209   address public beneficiary;
210 
211   uint256 public cliff;
212   uint256 public start;
213   uint256 public duration;
214 
215   bool public revocable;
216 
217   mapping (address => uint256) public released;
218   mapping (address => bool) public revoked;
219 
220   /**
221    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
222    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
223    * of the balance will have vested.
224    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
225    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
226    * @param _start the time (as Unix time) at which point vesting starts
227    * @param _duration duration in seconds of the period in which the tokens will vest
228    * @param _revocable whether the vesting is revocable or not
229    */
230   constructor(
231     address _beneficiary,
232     uint256 _start,
233     uint256 _cliff,
234     uint256 _duration,
235     bool _revocable
236   )
237     public
238   {
239     require(_beneficiary != address(0));
240     require(_cliff <= _duration);
241 
242     beneficiary = _beneficiary;
243     revocable = _revocable;
244     duration = _duration;
245     cliff = _start.add(_cliff);
246     start = _start;
247   }
248 
249   /**
250    * @notice Transfers vested tokens to beneficiary.
251    * @param token ERC20 token which is being vested
252    */
253   function release(ERC20Basic token) public {
254     uint256 unreleased = releasableAmount(token);
255 
256     require(unreleased > 0);
257 
258     released[token] = released[token].add(unreleased);
259 
260     token.safeTransfer(beneficiary, unreleased);
261 
262     emit Released(unreleased);
263   }
264 
265   /**
266    * @notice Allows the owner to revoke the vesting. Tokens already vested
267    * remain in the contract, the rest are returned to the owner.
268    * @param token ERC20 token which is being vested
269    */
270   function revoke(ERC20Basic token) public onlyOwner {
271     require(revocable);
272     require(!revoked[token]);
273 
274     uint256 balance = token.balanceOf(this);
275 
276     uint256 unreleased = releasableAmount(token);
277     uint256 refund = balance.sub(unreleased);
278 
279     revoked[token] = true;
280 
281     token.safeTransfer(owner, refund);
282 
283     emit Revoked();
284   }
285 
286   /**
287    * @dev Calculates the amount that has already vested but hasn't been released yet.
288    * @param token ERC20 token which is being vested
289    */
290   function releasableAmount(ERC20Basic token) public view returns (uint256) {
291     return vestedAmount(token).sub(released[token]);
292   }
293 
294   /**
295    * @dev Calculates the amount that has already vested.
296    * @param token ERC20 token which is being vested
297    */
298   function vestedAmount(ERC20Basic token) public view returns (uint256) {
299     uint256 currentBalance = token.balanceOf(this);
300     uint256 totalBalance = currentBalance.add(released[token]);
301 
302     if (block.timestamp < cliff) {
303       return 0;
304     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
305       return totalBalance;
306     } else {
307       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
308     }
309   }
310 }
311 
312 
313 contract SolidVesting is TokenVesting {
314 
315   constructor(address _beneficiary,
316     uint256 _start,
317     uint256 _cliff,
318     uint256 _duration,
319     bool _revocable)
320     public
321     TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
322   {
323     // Constructor needed for running migrations
324   }
325 
326   /**
327     @dev Change the reciever of the tokens
328     @param newBeneficiary the address of the new beneficiary
329   **/
330   function changeBeneficiary(address newBeneficiary) public onlyOwner {
331     beneficiary = newBeneficiary;
332   }
333 
334 }