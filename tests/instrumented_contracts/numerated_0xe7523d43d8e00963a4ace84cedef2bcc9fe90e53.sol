1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender)
17     public view returns (uint256);
18 
19   function transferFrom(address from, address to, uint256 value)
20     public returns (bool);
21 
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28 }
29 
30 /**
31  * @title SafeERC20
32  * @dev Wrappers around ERC20 operations that throw on failure.
33  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
34  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
35  */
36 library SafeERC20 {
37   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
38     require(token.transfer(to, value));
39   }
40 
41   function safeTransferFrom(
42     ERC20 token,
43     address from,
44     address to,
45     uint256 value
46   )
47     internal
48   {
49     require(token.transferFrom(from, to, value));
50   }
51 
52   function safeApprove(ERC20 token, address spender, uint256 value) internal {
53     require(token.approve(spender, value));
54   }
55 }
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62 
63   /**
64   * @dev Multiplies two numbers, throws on overflow.
65   */
66   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
68     // benefit is lost if 'b' is also tested.
69     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70     if (a == 0) {
71       return 0;
72     }
73 
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 /**
108  * @title Ownable
109  * @dev The Ownable contract has an owner address, and provides basic authorization control
110  * functions, this simplifies the implementation of "user permissions".
111  */
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipRenounced(address indexed previousOwner);
117   event OwnershipTransferred(
118     address indexed previousOwner,
119     address indexed newOwner
120   );
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   constructor() public {
128     owner = msg.sender;
129   }
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139   /**
140    * @dev Allows the current owner to relinquish control of the contract.
141    * @notice Renouncing to ownership will leave the contract without an owner.
142    * It will not be possible to call the functions with the `onlyOwner`
143    * modifier anymore.
144    */
145   function renounceOwnership() public onlyOwner {
146     emit OwnershipRenounced(owner);
147     owner = address(0);
148   }
149 
150   /**
151    * @dev Allows the current owner to transfer control of the contract to a newOwner.
152    * @param _newOwner The address to transfer ownership to.
153    */
154   function transferOwnership(address _newOwner) public onlyOwner {
155     _transferOwnership(_newOwner);
156   }
157 
158   /**
159    * @dev Transfers control of the contract to a newOwner.
160    * @param _newOwner The address to transfer ownership to.
161    */
162   function _transferOwnership(address _newOwner) internal {
163     require(_newOwner != address(0));
164     emit OwnershipTransferred(owner, _newOwner);
165     owner = _newOwner;
166   }
167 }
168 
169 /**
170  * @title TokenVesting
171  * @dev A token holder contract that can release its token balance gradually like a
172  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
173  * owner.
174  */
175 contract TokenVesting is Ownable {
176   using SafeMath for uint256;
177   using SafeERC20 for ERC20Basic;
178 
179   event Released(uint256 amount);
180   event Revoked();
181 
182   // beneficiary of tokens after they are released
183   address public beneficiary;
184 
185   uint256 public cliff;
186   uint256 public start;
187   uint256 public duration;
188 
189   bool public revocable;
190 
191   mapping (address => uint256) public released;
192   mapping (address => bool) public revoked;
193 
194   /**
195    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
196    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
197    * of the balance will have vested.
198    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
199    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
200    * @param _start the time (as Unix time) at which point vesting starts 
201    * @param _duration duration in seconds of the period in which the tokens will vest
202    * @param _revocable whether the vesting is revocable or not
203    */
204   constructor(
205     address _beneficiary,
206     uint256 _start,
207     uint256 _cliff,
208     uint256 _duration,
209     bool _revocable
210   )
211     public
212   {
213     require(_beneficiary != address(0));
214     require(_cliff <= _duration);
215 
216     beneficiary = _beneficiary;
217     revocable = _revocable;
218     duration = _duration;
219     cliff = _start.add(_cliff);
220     start = _start;
221   }
222 
223   /**
224    * @notice Transfers vested tokens to beneficiary.
225    * @param token ERC20 token which is being vested
226    */
227   function release(ERC20Basic token) public {
228     uint256 unreleased = releasableAmount(token);
229 
230     require(unreleased > 0);
231 
232     released[token] = released[token].add(unreleased);
233 
234     token.safeTransfer(beneficiary, unreleased);
235 
236     emit Released(unreleased);
237   }
238 
239   /**
240    * @notice Allows the owner to revoke the vesting. Tokens already vested
241    * remain in the contract, the rest are returned to the owner.
242    * @param token ERC20 token which is being vested
243    */
244   function revoke(ERC20Basic token) public onlyOwner {
245     require(revocable);
246     require(!revoked[token]);
247 
248     uint256 balance = token.balanceOf(this);
249 
250     uint256 unreleased = releasableAmount(token);
251     uint256 refund = balance.sub(unreleased);
252 
253     revoked[token] = true;
254 
255     token.safeTransfer(owner, refund);
256 
257     emit Revoked();
258   }
259 
260   /**
261    * @dev Calculates the amount that has already vested but hasn't been released yet.
262    * @param token ERC20 token which is being vested
263    */
264   function releasableAmount(ERC20Basic token) public view returns (uint256) {
265     return vestedAmount(token).sub(released[token]);
266   }
267 
268   /**
269    * @dev Calculates the amount that has already vested.
270    * @param token ERC20 token which is being vested
271    */
272   function vestedAmount(ERC20Basic token) public view returns (uint256) {
273     uint256 currentBalance = token.balanceOf(this);
274     uint256 totalBalance = currentBalance.add(released[token]);
275 
276     if (block.timestamp < cliff) {
277       return 0;
278     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
279       return totalBalance;
280     } else {
281       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
282     }
283   }
284 }