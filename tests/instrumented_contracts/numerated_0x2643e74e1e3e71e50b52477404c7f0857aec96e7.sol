1 /* solium-disable security/no-block-members */
2 
3 pragma solidity ^0.4.24;
4 
5 
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender)
15     public view returns (uint256);
16 
17   function transferFrom(address from, address to, uint256 value)
18     public returns (bool);
19 
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(
22     address indexed owner,
23     address indexed spender,
24     uint256 value
25   );
26 }
27 library SafeERC20 {
28   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
29     require(token.transfer(to, value));
30   }
31 
32   function safeTransferFrom(
33     ERC20 token,
34     address from,
35     address to,
36     uint256 value
37   )
38     internal
39   {
40     require(token.transferFrom(from, to, value));
41   }
42 
43   function safeApprove(ERC20 token, address spender, uint256 value) internal {
44     require(token.approve(spender, value));
45   }
46 }
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56     if (a == 0) {
57       return 0;
58     }
59 
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 
94 contract Ownable {
95   address public owner;
96 
97 
98   event OwnershipRenounced(address indexed previousOwner);
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   constructor() public {
110     owner = msg.sender;
111   }
112 
113   /**
114    * @dev Throws if called by any account other than the owner.
115    */
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to relinquish control of the contract.
123    * @notice Renouncing to ownership will leave the contract without an owner.
124    * It will not be possible to call the functions with the `onlyOwner`
125    * modifier anymore.
126    */
127   function renounceOwnership() public onlyOwner {
128     emit OwnershipRenounced(owner);
129     owner = address(0);
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address _newOwner) public onlyOwner {
137     _transferOwnership(_newOwner);
138   }
139 
140   /**
141    * @dev Transfers control of the contract to a newOwner.
142    * @param _newOwner The address to transfer ownership to.
143    */
144   function _transferOwnership(address _newOwner) internal {
145     require(_newOwner != address(0));
146     emit OwnershipTransferred(owner, _newOwner);
147     owner = _newOwner;
148   }
149 }
150 
151 /**
152  * @title TokenVesting
153  * @dev A token holder contract that can release its token balance gradually like a
154  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
155  * owner.
156  */
157 contract TokenVesting is Ownable{
158   using SafeMath for uint256;
159   using SafeERC20 for ERC20Basic;
160   
161   
162   ERC20Basic public token;
163   
164   
165   event Released(uint256 amount);
166   event Revoked();
167 
168   // beneficiary of tokens after they are released
169   address public beneficiary;
170   uint256 public cliff;
171   uint256 public start;
172   uint256 public duration;
173   address public rollback;
174   bool public revocable;
175   
176   uint256 public currentBalance;
177   bool public initialized = false;
178   
179   uint256 public constant initialTokens = 1660*10**8;
180   
181   
182   mapping (address => uint256) public released;
183   mapping (address => bool) public revoked;
184   
185   
186   uint256 public totalBalance;
187   /**
188    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
189    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
190    * of the balance will have vested.
191    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
192    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
193    * @param _start the time (as Unix time) at which point vesting starts 
194    * @param _duration duration in seconds of the period in which the tokens will vest
195    * @param _revocable whether the vesting is revocable or not
196    */
197   constructor(
198     address _beneficiary,
199     uint256 _start,
200     uint256 _cliff,
201     uint256 _duration,
202     bool _revocable,
203     address _rollback,
204     ERC20Basic _token
205     
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
217     token = _token;
218     rollback = _rollback;
219 
220   }
221 
222     /**
223    * initialize
224    * @dev Initialize the contract
225    **/
226   function initialize() public onlyOwner {
227        // Can only be initialized once
228       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
229       currentBalance = token.balanceOf(this);
230       totalBalance = currentBalance.add(released[token]);
231       initialized = true;
232       
233   }
234 
235  /**
236    * tokensAvailable
237    * @dev returns the number of tokens allocated to this contract
238    **/
239   function tokensAvailable() public constant returns (uint256) {
240     
241     return token.balanceOf(this);
242   }
243   
244   
245   
246   function release() public {
247     require(initialized);
248     uint256 unreleased = releasableAmount();
249 
250     require(unreleased > 0);
251 
252     released[token] = released[token].add(unreleased);
253 
254     token.safeTransfer(beneficiary, unreleased);
255 
256     emit Released(unreleased);
257   }
258 
259 
260   function revoke() public onlyOwner {
261     require(revocable);
262     require(!revoked[token]);
263 
264     uint256 balance = token.balanceOf(this);
265 
266     uint256 unreleased = releasableAmount();
267     uint256 refund = balance.sub(unreleased);
268     
269     revoked[token] = true;
270 
271     token.safeTransfer(rollback, refund);
272 
273     emit Revoked();
274   }
275 
276 
277   function releasableAmount() public returns (uint256) {
278     return vestedAmount().sub(released[token]);
279   }
280 
281 
282   function vestedAmount() public returns (uint256) {
283     
284     currentBalance = token.balanceOf(this);
285     totalBalance = currentBalance.add(released[token]);
286     if (block.timestamp < cliff) {
287       return 0;
288     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
289       return totalBalance;
290     } else {
291         
292       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
293     }
294   }
295 }