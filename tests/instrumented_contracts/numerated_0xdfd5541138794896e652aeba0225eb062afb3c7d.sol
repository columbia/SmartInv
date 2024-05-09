1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath
8 {
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44    * @dev Adds two numbers, throws on overflow.
45    */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable
60 {
61   address public owner;
62 
63   event OwnershipRenounced(address indexed previousOwner);
64   event OwnershipTransferred(
65     address indexed previousOwner,
66     address indexed newOwner
67   );
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address _newOwner) public onlyOwner {
90     _transferOwnership(_newOwner);
91   }
92 
93   /**
94    * @dev Transfers control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function _transferOwnership(address _newOwner) internal {
98     require(_newOwner != address(0));
99     emit OwnershipTransferred(owner, _newOwner);
100     owner = _newOwner;
101   }
102 
103 }
104 
105 
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/179
111  */
112 contract ERC20Basic
113 {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public;
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic
125 {
126   function allowance(address owner, address spender) public view returns (uint256);
127 
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129 
130   function approve(address spender, uint256 value) public returns (bool);
131 
132   event Approval(
133     address indexed owner,
134     address indexed spender,
135     uint256 value
136   );
137 
138 }
139 
140 
141 
142 
143 /**
144  * @title SafeERC20
145  * @dev Wrappers around ERC20 operations that throw on failure.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150   function safeTransfer(
151     ERC20 _token,
152     address _to,
153     uint256 _value
154   )
155     internal
156   {
157     _token.transfer(_to, _value);
158   }
159 
160   function safeTransferFrom(
161     ERC20 _token,
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     internal
167   {
168     require(_token.transferFrom(_from, _to, _value));
169   }
170 
171   function safeApprove(
172     ERC20 _token,
173     address _spender,
174     uint256 _value
175   )
176     internal
177   {
178     require(_token.approve(_spender, _value));
179   }
180 }
181 
182 
183 /**
184  * @title TokenVesting
185  * @dev A token holder contract that can release its token balance gradually like a
186  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
187  * owner.
188  */
189 contract TokenVesting is Ownable {
190   using SafeMath for uint256;
191   using SafeERC20 for ERC20;
192 
193   event Released(uint256 amount);
194   event Revoked();
195 
196   // beneficiary of tokens after they are released
197   address public beneficiary;
198 
199   uint256 public cliff;
200   uint256 public start;
201   uint256 public duration;
202 
203   bool public revocable;
204 
205   mapping (address => uint256) public released;
206   mapping (address => bool) public revoked;
207 
208   /**
209    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
210    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
211    * of the balance will have vested.
212    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
213    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
214    * @param _start the time (as Unix time) at which point vesting starts
215    * @param _duration duration in seconds of the period in which the tokens will vest
216    * @param _revocable whether the vesting is revocable or not
217    */
218   constructor(
219     address _beneficiary,
220     uint256 _start,
221     uint256 _cliff,
222     uint256 _duration,
223     bool _revocable
224   )
225     public
226   {
227     require(_beneficiary != address(0));
228     require(_cliff <= _duration);
229 
230     beneficiary = _beneficiary;
231     revocable = _revocable;
232     duration = _duration;
233     cliff = _start.add(_cliff);
234     start = _start;
235   }
236 
237   /**
238    * @notice Transfers vested tokens to beneficiary.
239    * @param _token ERC20 token which is being vested
240    */
241   function release(ERC20 _token) public {
242     uint256 unreleased = releasableAmount(_token);
243 
244     require(unreleased > 0);
245 
246     released[_token] = unreleased.add(released[_token]);
247 
248     _token.safeTransfer(beneficiary, unreleased);
249 
250     emit Released(unreleased);
251   }
252 
253   /**
254    * @notice Allows the owner to revoke the vesting. Tokens already vested
255    * remain in the contract, the rest are returned to the owner.
256    * @param _token ERC20 token which is being vested
257    */
258   function revoke(ERC20 _token) public onlyOwner {
259     require(revocable);
260     require(!revoked[_token]);
261 
262     uint256 balance = _token.balanceOf(address(this));
263 
264     uint256 unreleased = releasableAmount(_token);
265     uint256 refund = balance.sub(unreleased);
266 
267     revoked[_token] = true;
268 
269     _token.safeTransfer(owner, refund);
270 
271     emit Revoked();
272   }
273 
274   /**
275    * @dev Calculates the amount that has already vested but hasn't been released yet.
276    * @param _token ERC20 token which is being vested
277    */
278   function releasableAmount(ERC20 _token) public view returns (uint256) {
279     return vestedAmount(_token).sub(released[_token]);
280   }
281 
282   /**
283    * @dev Calculates the amount that has already vested.
284    * @param _token ERC20 token which is being vested
285    */
286   function vestedAmount(ERC20 _token) public view returns (uint256) {
287     uint256 currentBalance = _token.balanceOf(this);
288     uint256 totalBalance = currentBalance.add(released[_token]);
289 
290     if (block.timestamp < cliff) {
291       return 0;
292     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
293       return totalBalance;
294     } else {
295       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
296     }
297   }
298 }