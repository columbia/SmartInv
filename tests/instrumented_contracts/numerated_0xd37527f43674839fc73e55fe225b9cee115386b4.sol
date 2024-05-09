1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
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
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address _owner, address _spender)
93     public view returns (uint256);
94 
95   function transferFrom(address _from, address _to, uint256 _value)
96     public returns (bool);
97 
98   function approve(address _spender, uint256 _value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 
107 
108 /**
109  * @title SafeERC20
110  * @dev Wrappers around ERC20 operations that throw on failure.
111  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
112  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
113  */
114 library SafeERC20 {
115   function safeTransfer(
116     ERC20Basic _token,
117     address _to,
118     uint256 _value
119   )
120     internal
121   {
122     require(_token.transfer(_to, _value));
123   }
124 
125   function safeTransferFrom(
126     ERC20 _token,
127     address _from,
128     address _to,
129     uint256 _value
130   )
131     internal
132   {
133     require(_token.transferFrom(_from, _to, _value));
134   }
135 
136   function safeApprove(
137     ERC20 _token,
138     address _spender,
139     uint256 _value
140   )
141     internal
142   {
143     require(_token.approve(_spender, _value));
144   }
145 }
146 
147 
148 /* solium-disable security/no-block-members */
149 
150 
151 
152 
153 
154 
155 
156 
157 
158 /**
159  * @title SafeMath
160  * @dev Math operations with safety checks that throw on error
161  */
162 library SafeMath {
163 
164   /**
165   * @dev Multiplies two numbers, throws on overflow.
166   */
167   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
168     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
169     // benefit is lost if 'b' is also tested.
170     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
171     if (_a == 0) {
172       return 0;
173     }
174 
175     c = _a * _b;
176     assert(c / _a == _b);
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers, truncating the quotient.
182   */
183   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
184     // assert(_b > 0); // Solidity automatically throws when dividing by 0
185     // uint256 c = _a / _b;
186     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
187     return _a / _b;
188   }
189 
190   /**
191   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
192   */
193   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
194     assert(_b <= _a);
195     return _a - _b;
196   }
197 
198   /**
199   * @dev Adds two numbers, throws on overflow.
200   */
201   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
202     c = _a + _b;
203     assert(c >= _a);
204     return c;
205   }
206 }
207 
208 
209 
210 /**
211  * @title TokenVesting
212  * @dev A token holder contract that can release its token balance gradually like a
213  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
214  * owner.
215  */
216 contract TokenVesting is Ownable {
217   using SafeMath for uint256;
218   using SafeERC20 for ERC20Basic;
219 
220   event Released(uint256 amount);
221   event Revoked();
222 
223   // beneficiary of tokens after they are released
224   address public beneficiary;
225 
226   uint256 public cliff;
227   uint256 public start;
228   uint256 public duration;
229 
230   bool public revocable;
231 
232   mapping (address => uint256) public released;
233   mapping (address => bool) public revoked;
234 
235   /**
236    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
237    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
238    * of the balance will have vested.
239    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
240    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
241    * @param _start the time (as Unix time) at which point vesting starts
242    * @param _duration duration in seconds of the period in which the tokens will vest
243    * @param _revocable whether the vesting is revocable or not
244    */
245   constructor(
246     address _beneficiary,
247     uint256 _start,
248     uint256 _cliff,
249     uint256 _duration,
250     bool _revocable
251   )
252     public
253   {
254     require(_beneficiary != address(0));
255     require(_cliff <= _duration);
256 
257     beneficiary = _beneficiary;
258     revocable = _revocable;
259     duration = _duration;
260     cliff = _start.add(_cliff);
261     start = _start;
262   }
263 
264   /**
265    * @notice Transfers vested tokens to beneficiary.
266    * @param _token ERC20 token which is being vested
267    */
268   function release(ERC20Basic _token) public {
269     uint256 unreleased = releasableAmount(_token);
270 
271     require(unreleased > 0);
272 
273     released[_token] = released[_token].add(unreleased);
274 
275     _token.safeTransfer(beneficiary, unreleased);
276 
277     emit Released(unreleased);
278   }
279 
280   /**
281    * @notice Allows the owner to revoke the vesting. Tokens already vested
282    * remain in the contract, the rest are returned to the owner.
283    * @param _token ERC20 token which is being vested
284    */
285   function revoke(ERC20Basic _token) public onlyOwner {
286     require(revocable);
287     require(!revoked[_token]);
288 
289     uint256 balance = _token.balanceOf(address(this));
290 
291     uint256 unreleased = releasableAmount(_token);
292     uint256 refund = balance.sub(unreleased);
293 
294     revoked[_token] = true;
295 
296     _token.safeTransfer(owner, refund);
297 
298     emit Revoked();
299   }
300 
301   /**
302    * @dev Calculates the amount that has already vested but hasn't been released yet.
303    * @param _token ERC20 token which is being vested
304    */
305   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
306     return vestedAmount(_token).sub(released[_token]);
307   }
308 
309   /**
310    * @dev Calculates the amount that has already vested.
311    * @param _token ERC20 token which is being vested
312    */
313   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
314     uint256 currentBalance = _token.balanceOf(address(this));
315     uint256 totalBalance = currentBalance.add(released[_token]);
316 
317     if (block.timestamp < cliff) {
318       return 0;
319     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
320       return totalBalance;
321     } else {
322       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
323     }
324   }
325 }
326 
327 
328 contract COTVesting is TokenVesting {
329 
330     constructor(
331     address _beneficiary,
332     uint256 _start,
333     uint256 _cliff,
334     uint256 _duration,
335     bool _revocable
336     )
337         TokenVesting (_beneficiary, _start, _cliff, _duration, _revocable)
338         public
339     {
340 
341     }
342 }