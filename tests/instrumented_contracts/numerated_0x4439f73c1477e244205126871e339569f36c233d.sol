1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipRenounced(address indexed previousOwner);
59   event OwnershipTransferred(
60     address indexed previousOwner,
61     address indexed newOwner
62   );
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 }
99 
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
113 
114 /**
115  * @title Pausable
116  * @dev Base contract which allows children to implement an emergency stop mechanism.
117  */
118 contract Pausable is Ownable {
119   event Pause();
120   event Unpause();
121 
122   bool public paused = false;
123 
124 
125   /**
126    * @dev Modifier to make a function callable only when the contract is not paused.
127    */
128   modifier whenNotPaused() {
129     require(!paused);
130     _;
131   }
132 
133   /**
134    * @dev Modifier to make a function callable only when the contract is paused.
135    */
136   modifier whenPaused() {
137     require(paused);
138     _;
139   }
140 
141   /**
142    * @dev called by the owner to pause, triggers stopped state
143    */
144   function pause() onlyOwner whenNotPaused public {
145     paused = true;
146     emit Pause();
147   }
148 
149   /**
150    * @dev called by the owner to unpause, returns to normal state
151    */
152   function unpause() onlyOwner whenPaused public {
153     paused = false;
154     emit Unpause();
155   }
156 }
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender)
164     public view returns (uint256);
165 
166   function transferFrom(address from, address to, uint256 value)
167     public returns (bool);
168 
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(
171     address indexed owner,
172     address indexed spender,
173     uint256 value
174   );
175 }
176 
177 /**
178  * @title SafeERC20
179  * @dev Wrappers around ERC20 operations that throw on failure.
180  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
181  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
182  */
183 library SafeERC20 {
184   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
185     require(token.transfer(to, value));
186   }
187 
188   function safeTransferFrom(
189     ERC20 token,
190     address from,
191     address to,
192     uint256 value
193   )
194     internal
195   {
196     require(token.transferFrom(from, to, value));
197   }
198 
199   function safeApprove(ERC20 token, address spender, uint256 value) internal {
200     require(token.approve(spender, value));
201   }
202 }
203 
204 /**
205  * @title TokenVesting
206  * @dev A token holder contract that can release its token balance gradually like a
207  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
208  * owner.
209  */
210 contract TokenVesting is Ownable {
211   using SafeMath for uint256;
212   using SafeERC20 for ERC20Basic;
213 
214   event Released(uint256 amount);
215   event Revoked();
216 
217   // beneficiary of tokens after they are released
218   address public beneficiary;
219 
220   uint256 public cliff;
221   uint256 public start;
222   uint256 public duration;
223 
224   bool public revocable;
225 
226   mapping (address => uint256) public released;
227   mapping (address => bool) public revoked;
228 
229   /**
230    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
231    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
232    * of the balance will have vested.
233    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
234    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
235    * @param _duration duration in seconds of the period in which the tokens will vest
236    * @param _revocable whether the vesting is revocable or not
237    */
238   constructor(
239     address _beneficiary,
240     uint256 _start,
241     uint256 _cliff,
242     uint256 _duration,
243     bool _revocable
244   )
245     public
246   {
247     require(_beneficiary != address(0));
248     require(_cliff <= _duration);
249 
250     beneficiary = _beneficiary;
251     revocable = _revocable;
252     duration = _duration;
253     cliff = _start.add(_cliff);
254     start = _start;
255   }
256 
257   /**
258    * @notice Transfers vested tokens to beneficiary.
259    * @param token ERC20 token which is being vested
260    */
261   function release(ERC20Basic token) public {
262     uint256 unreleased = releasableAmount(token);
263 
264     require(unreleased > 0);
265 
266     released[token] = released[token].add(unreleased);
267 
268     token.safeTransfer(beneficiary, unreleased);
269 
270     emit Released(unreleased);
271   }
272 
273   /**
274    * @notice Allows the owner to revoke the vesting. Tokens already vested
275    * remain in the contract, the rest are returned to the owner.
276    * @param token ERC20 token which is being vested
277    */
278   function revoke(ERC20Basic token) public onlyOwner {
279     require(revocable);
280     require(!revoked[token]);
281 
282     uint256 balance = token.balanceOf(this);
283 
284     uint256 unreleased = releasableAmount(token);
285     uint256 refund = balance.sub(unreleased);
286 
287     revoked[token] = true;
288 
289     token.safeTransfer(owner, refund);
290 
291     emit Revoked();
292   }
293 
294   /**
295    * @dev Calculates the amount that has already vested but hasn't been released yet.
296    * @param token ERC20 token which is being vested
297    */
298   function releasableAmount(ERC20Basic token) public view returns (uint256) {
299     return vestedAmount(token).sub(released[token]);
300   }
301 
302   /**
303    * @dev Calculates the amount that has already vested.
304    * @param token ERC20 token which is being vested
305    */
306   function vestedAmount(ERC20Basic token) public view returns (uint256) {
307     uint256 currentBalance = token.balanceOf(this);
308     uint256 totalBalance = currentBalance.add(released[token]);
309 
310     if (block.timestamp < cliff) {
311       return 0;
312     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
313       return totalBalance;
314     } else {
315       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
316     }
317   }
318 }