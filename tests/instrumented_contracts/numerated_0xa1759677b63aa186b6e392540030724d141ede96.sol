1 /* solium-disable security/no-block-members */
2 
3 pragma solidity ^0.4.24;
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender)
73     public view returns (uint256);
74 
75   function transferFrom(address from, address to, uint256 value)
76     public returns (bool);
77 
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(
80     address indexed owner,
81     address indexed spender,
82     uint256 value
83   );
84 }
85 
86 /**
87  * @title SafeERC20
88  * @dev Wrappers around ERC20 operations that throw on failure.
89  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
90  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
91  */
92 library SafeERC20 {
93   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
94     require(token.transfer(to, value));
95   }
96 
97   function safeTransferFrom(
98     ERC20 token,
99     address from,
100     address to,
101     uint256 value
102   )
103     internal
104   {
105     require(token.transferFrom(from, to, value));
106   }
107 
108   function safeApprove(ERC20 token, address spender, uint256 value) internal {
109     require(token.approve(spender, value));
110   }
111 }
112 
113 /**
114  * @title Ownable
115  * @dev The Ownable contract has an owner address, and provides basic authorization control
116  * functions, this simplifies the implementation of "user permissions".
117  */
118 contract Ownable {
119   address public owner;
120 
121 
122   event OwnershipRenounced(address indexed previousOwner);
123   event OwnershipTransferred(
124     address indexed previousOwner,
125     address indexed newOwner
126   );
127 
128 
129   /**
130    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131    * account.
132    */
133   constructor() public {
134     owner = msg.sender;
135   }
136 
137   /**
138    * @dev Throws if called by any account other than the owner.
139    */
140   modifier onlyOwner() {
141     require(msg.sender == owner);
142     _;
143   }
144 
145   /**
146    * @dev Allows the current owner to relinquish control of the contract.
147    * @notice Renouncing to ownership will leave the contract without an owner.
148    * It will not be possible to call the functions with the `onlyOwner`
149    * modifier anymore.
150    */
151   function renounceOwnership() public onlyOwner {
152     emit OwnershipRenounced(owner);
153     owner = address(0);
154   }
155 
156   /**
157    * @dev Allows the current owner to transfer control of the contract to a newOwner.
158    * @param _newOwner The address to transfer ownership to.
159    */
160   function transferOwnership(address _newOwner) public onlyOwner {
161     _transferOwnership(_newOwner);
162   }
163 
164   /**
165    * @dev Transfers control of the contract to a newOwner.
166    * @param _newOwner The address to transfer ownership to.
167    */
168   function _transferOwnership(address _newOwner) internal {
169     require(_newOwner != address(0));
170     emit OwnershipTransferred(owner, _newOwner);
171     owner = _newOwner;
172   }
173 }
174 
175 
176 /**
177  * @title TokenVesting
178  * @dev A token holder contract that can release its token balance gradually like a
179  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
180  * owner.
181  */
182 contract TokenVesting is Ownable {
183   using SafeMath for uint256;
184   using SafeERC20 for ERC20Basic;
185 
186   event Released(uint256 amount);
187   event Revoked();
188 
189   // beneficiary of tokens after they are released
190   address public beneficiary;
191 
192   uint256 public cliff;
193   uint256 public start;
194   uint256 public duration;
195 
196   bool public revocable;
197 
198   mapping (address => uint256) public released;
199   mapping (address => bool) public revoked;
200 
201   /**
202    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
203    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
204    * of the balance will have vested.
205    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
206    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
207    * @param _start the time (as Unix time) at which point vesting starts
208    * @param _duration duration in seconds of the period in which the tokens will vest
209    * @param _revocable whether the vesting is revocable or not
210    */
211   constructor(
212     address _beneficiary,
213     uint256 _start,
214     uint256 _cliff,
215     uint256 _duration,
216     bool _revocable
217   )
218     public
219   {
220     require(_beneficiary != address(0));
221     require(_cliff <= _duration);
222 
223     beneficiary = _beneficiary;
224     revocable = _revocable;
225     duration = _duration;
226     cliff = _start.add(_cliff);
227     start = _start;
228   }
229 
230   /**
231    * @notice Transfers vested tokens to beneficiary.
232    * @param token ERC20 token which is being vested
233    */
234   function release(ERC20Basic token) public {
235     uint256 unreleased = releasableAmount(token);
236 
237     require(unreleased > 0);
238 
239     released[token] = released[token].add(unreleased);
240 
241     token.safeTransfer(beneficiary, unreleased);
242 
243     emit Released(unreleased);
244   }
245 
246   /**
247    * @notice Allows the owner to revoke the vesting. Tokens already vested
248    * remain in the contract, the rest are returned to the owner.
249    * @param token ERC20 token which is being vested
250    */
251   function revoke(ERC20Basic token) public onlyOwner {
252     require(revocable);
253     require(!revoked[token]);
254 
255     uint256 balance = token.balanceOf(this);
256 
257     uint256 unreleased = releasableAmount(token);
258     uint256 refund = balance.sub(unreleased);
259 
260     revoked[token] = true;
261 
262     token.safeTransfer(owner, refund);
263 
264     emit Revoked();
265   }
266 
267   /**
268    * @dev Calculates the amount that has already vested but hasn't been released yet.
269    * @param token ERC20 token which is being vested
270    */
271   function releasableAmount(ERC20Basic token) public view returns (uint256) {
272     return vestedAmount(token).sub(released[token]);
273   }
274 
275   /**
276    * @dev Calculates the amount that has already vested.
277    * @param token ERC20 token which is being vested
278    */
279   function vestedAmount(ERC20Basic token) public view returns (uint256) {
280     uint256 currentBalance = token.balanceOf(this);
281     uint256 totalBalance = currentBalance.add(released[token]);
282 
283     if (block.timestamp < cliff) {
284       return 0;
285     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
286       return totalBalance;
287     } else {
288       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
289     }
290   }
291 }