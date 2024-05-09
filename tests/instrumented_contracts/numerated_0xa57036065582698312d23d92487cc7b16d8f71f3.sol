1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8  
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 /**
27  * @title SafeERC20
28  * @dev Wrappers around ERC20 operations that throw on failure.
29  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
30  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
31  */
32 
33 library SafeERC20 {
34   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
35     assert(token.transfer(to, value));
36   }
37   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
38     assert(token.transferFrom(from, to, value));
39   }
40   function safeApprove(ERC20 token, address spender, uint256 value) internal {
41     assert(token.approve(spender, value));
42   }
43 }
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51   address public owner;
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to relinquish control of the contract.
77    * @notice Renouncing to ownership will leave the contract without an owner.
78    * It will not be possible to call the functions with the `onlyOwner`
79    * modifier anymore.
80    */
81   function renounceOwnership() public onlyOwner {
82     emit OwnershipRenounced(owner);
83     owner = address(0);
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address _newOwner) public onlyOwner {
91     _transferOwnership(_newOwner);
92   }
93 
94   /**
95    * @dev Transfers control of the contract to a newOwner.
96    * @param _newOwner The address to transfer ownership to.
97    */
98   function _transferOwnership(address _newOwner) internal {
99     require(_newOwner != address(0));
100     emit OwnershipTransferred(owner, _newOwner);
101     owner = _newOwner;
102   }
103 }
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that revert on error
107  */
108 
109 library SafeMath {
110   /**
111   * @dev Multiplies two numbers, reverts on overflow.
112   */
113   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
114     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (_a == 0) {
118       return 0;
119     }
120 
121     uint256 c = _a * _b;
122     require(c / _a == _b);
123 
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
129   */
130   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
131     require(_b > 0); // Solidity only automatically asserts when dividing by 0
132     uint256 c = _a / _b;
133     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
134 
135     return c;
136   }
137 
138   /**
139   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
140   */
141   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
142     require(_b <= _a);
143     uint256 c = _a - _b;
144 
145     return c;
146   }
147 
148   /**
149   * @dev Adds two numbers, reverts on overflow.
150   */
151   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
152     uint256 c = _a + _b;
153     require(c >= _a);
154 
155     return c;
156   }
157 
158   /**
159   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
160   * reverts when dividing by zero.
161   */
162   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163     require(b != 0);
164     return a % b;
165   }
166 }
167 
168 /**
169  * @title TokenVesting
170  * @dev A token holder contract that can release its token balance gradually like a
171  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
172  * owner.
173  */
174 contract TokenVesting is Ownable {
175   using SafeMath for uint256;
176   using SafeERC20 for ERC20Basic;
177   event Released(uint256 amount);
178   event Revoked();
179   // beneficiary of tokens after they are released
180   address public beneficiary;
181   uint256 public cliff;
182   uint256 public start;
183   uint256 public duration;
184 
185   bool public revocable;
186 
187   mapping (address => uint256) public released;
188   mapping (address => bool) public revoked;
189 
190   /**
191    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
192    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
193    * of the balance will have vested.
194    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
195    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
196    * @param _start the time (as Unix time) at which point vesting starts
197    * @param _duration duration in seconds of the period in which the tokens will vest
198    * @param _revocable whether the vesting is revocable or not
199    */
200   constructor(
201     address _beneficiary,
202     uint256 _start,
203     uint256 _cliff,
204     uint256 _duration,
205     bool _revocable
206   )
207     public
208   {
209     require(_beneficiary != address(0));
210     require(_cliff <= _duration);
211 
212     beneficiary = _beneficiary;
213     revocable = _revocable;
214     duration = _duration;
215     cliff = _start.add(_cliff);
216     start = _start;
217   }
218 
219   /**
220    * @notice Transfers vested tokens to beneficiary.
221    * @param _token ERC20 token which is being vested
222    */
223   function release(ERC20Basic _token) public {
224     uint256 unreleased = releasableAmount(_token);
225 
226     require(unreleased > 0);
227 
228     released[_token] = released[_token].add(unreleased);
229 
230     _token.safeTransfer(beneficiary, unreleased);
231 
232     emit Released(unreleased);
233   }
234 
235   /**
236    * @notice Allows the owner to revoke the vesting. Tokens already vested
237    * remain in the contract, the rest are returned to the owner.
238    * @param _token ERC20 token which is being vested
239    */
240    
241   function revoke(ERC20Basic _token) public onlyOwner {
242     require(revocable);
243     require(!revoked[_token]);
244 
245     uint256 balance = _token.balanceOf(address(this));
246 
247     uint256 unreleased = releasableAmount(_token);
248     uint256 refund = balance.sub(unreleased);
249 
250     revoked[_token] = true;
251 
252     _token.safeTransfer(owner, refund);
253 
254     emit Revoked();
255   }
256 
257   /**
258    * @dev Calculates the amount that has already vested but hasn't been released yet.
259    * @param _token ERC20 token which is being vested
260    */
261   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
262     return vestedAmount(_token).sub(released[_token]);
263   }
264 
265   /**
266    * @dev Calculates the amount that has already vested.
267    * @param _token ERC20 token which is being vested
268    */
269   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
270     uint256 currentBalance = _token.balanceOf(this);
271     uint256 totalBalance = currentBalance.add(released[_token]);
272 
273     if (block.timestamp < cliff) {
274       return 0;
275     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
276       return totalBalance;
277     } else {
278       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
279     }
280   }
281 }
282 contract SimpleVesting is TokenVesting {
283      constructor(address _beneficiary) TokenVesting(
284             _beneficiary,
285             1598918400,
286             0,
287             0,
288             false
289         ) 
290         public
291     {}
292 }