1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address _owner, address _spender)
141     public view returns (uint256);
142 
143   function transferFrom(address _from, address _to, uint256 _value)
144     public returns (bool);
145 
146   function approve(address _spender, uint256 _value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(
164     ERC20Basic _token,
165     address _to,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.transfer(_to, _value));
171   }
172 
173   function safeTransferFrom(
174     ERC20 _token,
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.transferFrom(_from, _to, _value));
182   }
183 
184   function safeApprove(
185     ERC20 _token,
186     address _spender,
187     uint256 _value
188   )
189     internal
190   {
191     require(_token.approve(_spender, _value));
192   }
193 }
194 
195 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
196 
197 /* solium-disable security/no-block-members */
198 
199 pragma solidity ^0.4.24;
200 
201 
202 
203 
204 
205 
206 /**
207  * @title TokenVesting
208  * @dev A token holder contract that can release its token balance gradually like a
209  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
210  * owner.
211  */
212 contract TokenVesting is Ownable {
213   using SafeMath for uint256;
214   using SafeERC20 for ERC20Basic;
215 
216   event Released(uint256 amount);
217   event Revoked();
218 
219   // beneficiary of tokens after they are released
220   address public beneficiary;
221 
222   uint256 public cliff;
223   uint256 public start;
224   uint256 public duration;
225 
226   bool public revocable;
227 
228   mapping (address => uint256) public released;
229   mapping (address => bool) public revoked;
230 
231   /**
232    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
233    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
234    * of the balance will have vested.
235    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
236    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
237    * @param _start the time (as Unix time) at which point vesting starts
238    * @param _duration duration in seconds of the period in which the tokens will vest
239    * @param _revocable whether the vesting is revocable or not
240    */
241   constructor(
242     address _beneficiary,
243     uint256 _start,
244     uint256 _cliff,
245     uint256 _duration,
246     bool _revocable
247   )
248     public
249   {
250     require(_beneficiary != address(0));
251     require(_cliff <= _duration);
252 
253     beneficiary = _beneficiary;
254     revocable = _revocable;
255     duration = _duration;
256     cliff = _start.add(_cliff);
257     start = _start;
258   }
259 
260   /**
261    * @notice Transfers vested tokens to beneficiary.
262    * @param _token ERC20 token which is being vested
263    */
264   function release(ERC20Basic _token) public {
265     uint256 unreleased = releasableAmount(_token);
266 
267     require(unreleased > 0);
268 
269     released[_token] = released[_token].add(unreleased);
270 
271     _token.safeTransfer(beneficiary, unreleased);
272 
273     emit Released(unreleased);
274   }
275 
276   /**
277    * @notice Allows the owner to revoke the vesting. Tokens already vested
278    * remain in the contract, the rest are returned to the owner.
279    * @param _token ERC20 token which is being vested
280    */
281   function revoke(ERC20Basic _token) public onlyOwner {
282     require(revocable);
283     require(!revoked[_token]);
284 
285     uint256 balance = _token.balanceOf(address(this));
286 
287     uint256 unreleased = releasableAmount(_token);
288     uint256 refund = balance.sub(unreleased);
289 
290     revoked[_token] = true;
291 
292     _token.safeTransfer(owner, refund);
293 
294     emit Revoked();
295   }
296 
297   /**
298    * @dev Calculates the amount that has already vested but hasn't been released yet.
299    * @param _token ERC20 token which is being vested
300    */
301   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
302     return vestedAmount(_token).sub(released[_token]);
303   }
304 
305   /**
306    * @dev Calculates the amount that has already vested.
307    * @param _token ERC20 token which is being vested
308    */
309   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
310     uint256 currentBalance = _token.balanceOf(address(this));
311     uint256 totalBalance = currentBalance.add(released[_token]);
312 
313     if (block.timestamp < cliff) {
314       return 0;
315     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
316       return totalBalance;
317     } else {
318       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
319     }
320   }
321 }
322 
323 // File: contracts/TokenVestingFactory.sol
324 
325 contract TokenVestingFactory is Ownable {
326     // claimedToken event
327     event ClaimedTokens(address indexed token, address indexed owner, uint amount);
328     
329     // index of created contracts
330     address[] public contracts;
331 
332     // useful to know the row count in contracts index
333     function getContractCount() public constant returns(uint contractCount)
334     {
335         return contracts.length;
336     }
337 
338     // deploy a new contract
339     function newTokenVesting(
340         address _beneficiary,
341         uint256 _start,
342         uint256 _cliff,
343         uint256 _duration,
344         bool _revocable) public returns(address newContract)
345     {
346         TokenVesting tv = new TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable);
347         contracts.push(tv);
348         return tv;
349     }
350 
351     function revokeVesting(uint256 _contractIndex, ERC20Basic _token) public onlyOwner {
352         TokenVesting(contracts[_contractIndex]).revoke(_token);
353     }
354 
355     /// @notice This method can be used by the owner to extract mistakenly
356     ///  sent tokens to this contract.
357     /// @param _token The address of the token contract that you want to recover
358     ///  set to 0 in case you want to extract ether.
359     function claimTokens(address _token) public onlyOwner {
360         if (_token == 0x0) {
361             owner.transfer(address(this).balance);
362             return;
363         }
364         ERC20 token = ERC20(_token);
365         uint balance = token.balanceOf(address(this));
366         token.transfer(owner, balance);
367 
368         emit ClaimedTokens(_token, owner, balance);
369     }
370 }