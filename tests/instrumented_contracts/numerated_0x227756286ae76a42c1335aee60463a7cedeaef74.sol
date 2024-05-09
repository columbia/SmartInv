1 /* solium-disable security/no-block-members */
2 
3 pragma solidity ^0.4.24;
4 
5 
6 
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender)
16     public view returns (uint256);
17 
18   function transferFrom(address from, address to, uint256 value)
19     public returns (bool);
20 
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(
23     address indexed owner,
24     address indexed spender,
25     uint256 value
26   );
27 }
28 library SafeERC20 {
29   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
30     require(token.transfer(to, value));
31   }
32 
33   function safeTransferFrom(
34     ERC20 token,
35     address from,
36     address to,
37     uint256 value
38   )
39     internal
40   {
41     require(token.transferFrom(from, to, value));
42   }
43 
44   function safeApprove(ERC20 token, address spender, uint256 value) internal {
45     require(token.approve(spender, value));
46   }
47 }
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
54     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
55     // benefit is lost if 'b' is also tested.
56     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57     if (a == 0) {
58       return 0;
59     }
60 
61     c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers, truncating the quotient.
68   */
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     // uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return a / b;
74   }
75 
76   /**
77   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   /**
85   * @dev Adds two numbers, throws on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 
95 contract Ownable {
96   address public owner;
97 
98 
99   event OwnershipRenounced(address indexed previousOwner);
100   event OwnershipTransferred(
101     address indexed previousOwner,
102     address indexed newOwner
103   );
104 
105 
106   /**
107    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
108    * account.
109    */
110   constructor() public {
111     owner = msg.sender;
112   }
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122   /**
123    * @dev Allows the current owner to relinquish control of the contract.
124    * @notice Renouncing to ownership will leave the contract without an owner.
125    * It will not be possible to call the functions with the `onlyOwner`
126    * modifier anymore.
127    */
128   function renounceOwnership() public onlyOwner {
129     emit OwnershipRenounced(owner);
130     owner = address(0);
131   }
132 
133   /**
134    * @dev Allows the current owner to transfer control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137   function transferOwnership(address _newOwner) public onlyOwner {
138     _transferOwnership(_newOwner);
139   }
140 
141   /**
142    * @dev Transfers control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function _transferOwnership(address _newOwner) internal {
146     require(_newOwner != address(0));
147     emit OwnershipTransferred(owner, _newOwner);
148     owner = _newOwner;
149   }
150 }
151 
152 /**
153  * @title TokenVesting
154  * @dev A token holder contract that can release its token balance gradually like a
155  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
156  * owner.
157  */
158 contract TokenVesting is Ownable{
159   using SafeMath for uint256;
160   using SafeERC20 for ERC20Basic;
161   
162   
163   ERC20Basic public token;
164   
165   
166   event Released(uint256 amount);
167   event Revoked();
168 
169   // beneficiary of tokens after they are released
170   address public beneficiary;
171   uint256 public cliff;
172   uint256 public start;
173   uint256 public duration;
174   address public rollback;
175   bool public revocable;
176   
177   uint256 public currentBalance;
178   bool public initialized = false;
179   
180   uint256 public constant initialTokens = 1000000*10**8;
181   
182   
183   mapping (address => uint256) public released;
184   mapping (address => bool) public revoked;
185   
186   
187   uint256 public totalBalance;
188   /**
189    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
190    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
191    * of the balance will have vested.
192    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
193    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
194    * @param _start the time (as Unix time) at which point vesting starts 
195    * @param _duration duration in seconds of the period in which the tokens will vest
196    * @param _revocable whether the vesting is revocable or not
197    */
198   constructor(
199     address _beneficiary,
200     uint256 _start,
201     uint256 _cliff,
202     uint256 _duration,
203     bool _revocable,
204     address _rollback,
205     ERC20Basic _token
206     
207   )
208     public
209   {
210     require(_beneficiary != address(0));
211     require(_cliff <= _duration);
212 
213     beneficiary = _beneficiary;
214     revocable = _revocable;
215     duration = _duration;
216     cliff = _start.add(_cliff);
217     start = _start;
218     token = _token;
219     rollback = _rollback;
220 
221     
222   }
223 
224     /**
225    * initialize
226    * @dev Initialize the contract
227    **/
228   function initialize() public onlyOwner {
229        // Can only be initialized once
230       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
231       currentBalance = token.balanceOf(this);
232       totalBalance = currentBalance.add(released[token]);
233       initialized = true;
234       
235   }
236 
237  /**
238    * tokensAvailable
239    * @dev returns the number of tokens allocated to this contract
240    **/
241   function tokensAvailable() public constant returns (uint256) {
242     
243     return token.balanceOf(this);
244   }
245   
246   
247   
248   function release() public {
249     require(initialized);
250     uint256 unreleased = releasableAmount();
251 
252     require(unreleased > 0);
253 
254     released[token] = released[token].add(unreleased);
255 
256     token.safeTransfer(beneficiary, unreleased);
257 
258     emit Released(unreleased);
259   }
260 
261 
262   function revoke() public onlyOwner {
263     require(revocable);
264     require(!revoked[token]);
265 
266     uint256 balance = token.balanceOf(this);
267 
268     uint256 unreleased = releasableAmount();
269     uint256 refund = balance.sub(unreleased);
270     
271     revoked[token] = true;
272 
273     token.safeTransfer(rollback, refund);
274 
275     emit Revoked();
276   }
277 
278 
279   function releasableAmount() public returns (uint256) {
280     return vestedAmount().sub(released[token]);
281   }
282 
283 
284   function vestedAmount() public returns (uint256) {
285     
286     currentBalance = token.balanceOf(this);
287     totalBalance = currentBalance.add(released[token]);
288     if (block.timestamp < cliff) {
289       return 0;
290     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
291       return totalBalance;
292     } else {
293         
294       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
295     }
296   }
297 }