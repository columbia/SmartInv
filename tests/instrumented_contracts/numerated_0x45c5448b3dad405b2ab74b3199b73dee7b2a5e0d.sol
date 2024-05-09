1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
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
195 // File: contracts/HAVesting.sol
196 
197 contract HAVesting is Ownable {
198   using SafeMath for uint;
199   using SafeERC20 for ERC20;
200 
201     // HA Token contract.
202     ERC20 public token;
203 
204     // Vesting grant for a speicifc holder.
205     struct Grant {
206         uint value;
207         uint start;
208         uint cliff;
209         uint end;
210         uint installmentLength; // In seconds.
211         uint transferred;
212         bool revokable;
213     }
214 
215     // Holder to grant information mapping.
216     mapping (address => Grant) public grants;
217 
218     // Total tokens available for vesting.
219     uint public totalVesting;
220 
221     event NewGrant(address indexed _from, address indexed _to, uint _value);
222     event TokensUnlocked(address indexed _to, uint _value);
223     event GrantRevoked(address indexed _holder, uint _refund);
224 
225     /// @dev Constructor that initializes the address of the HA token contract.
226     /// @param _token ERC20 The address of the previously deployed HA token contract.
227     constructor(ERC20 _token) public {
228         require(_token != address(0));
229 
230         token = _token;
231     }
232 
233     /// @dev Grant tokens to a specified address.
234     /// @param _to address The holder address.
235     /// @param _value uint The amount of tokens to be granted.
236     /// @param _start uint The beginning of the vesting period.
237     /// @param _cliff uint Duration of the cliff period (when the first installment is made).
238     /// @param _end uint The end of the vesting period.
239     /// @param _installmentLength uint The length of each vesting installment (in seconds).
240     /// @param _revokable bool Whether the grant is revokable or not.
241     function grantTo(address _to, uint _value, uint _start, uint _cliff, uint _end,
242         uint _installmentLength, bool _revokable)
243         external onlyOwner {
244 
245         require(_to != address(0));
246         require(_to != address(this)); // Don't allow holder to be this contract.
247         require(_value > 0);
248 
249         // Require that every holder can be granted tokens only once.
250         require(grants[_to].value == 0);
251 
252         // Require for time ranges to be consistent and valid.
253         require(_start <= _cliff && _cliff <= _end);
254 
255         // Require installment length to be valid and no longer than (end - start).
256         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
257 
258         // Grant must not exceed the total amount of tokens currently available for vesting.
259         require(totalVesting.add(_value) <= token.balanceOf(address(this)));
260 
261         // Assign a new grant.
262         grants[_to] = Grant({
263             value: _value,
264             start: _start,
265             cliff: _cliff,
266             end: _end,
267             installmentLength: _installmentLength,
268             transferred: 0,
269             revokable: _revokable
270         });
271 
272         // Since tokens have been granted, reduce the total amount available for vesting.
273         totalVesting = totalVesting.add(_value);
274 
275         emit NewGrant(msg.sender, _to, _value);
276     }
277 
278     /// @dev Revoke the grant of tokens of a specifed address.
279     /// @param _holder The address which will have its tokens revoked.
280     function revoke(address _holder) public onlyOwner {
281         Grant memory grant = grants[_holder];
282 
283         // Grant must be revokable.
284         require(grant.revokable);
285 
286         // Calculate amount of remaining tokens that are still available to be
287         // returned to owner.
288         uint refund = grant.value.sub(grant.transferred);
289 
290         // Remove grant information.
291         delete grants[_holder];
292 
293         // Update total vesting amount and transfer previously calculated tokens to owner.
294         totalVesting = totalVesting.sub(refund);
295         token.transfer(msg.sender, refund);
296 
297         emit GrantRevoked(_holder, refund);
298     }
299 
300     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
301     /// @param _holder address The address of the holder.
302     /// @param _time uint The specific time to calculate against.
303     /// @return a uint Representing a holder's total amount of vested tokens.
304     function vestedTokens(address _holder, uint _time) external constant returns (uint) {
305         Grant memory grant = grants[_holder];
306         if (grant.value == 0) {
307             return 0;
308         }
309 
310         return calculateVestedTokens(grant, _time);
311     }
312 
313     /// @dev Calculate amount of vested tokens at a specifc time.
314     /// @param _grant Grant The vesting grant.
315     /// @param _time uint The time to be checked
316     /// @return a uint Representing the amount of vested tokens of a specific grant.
317     function calculateVestedTokens(Grant _grant, uint _time) internal pure returns (uint) {
318         // If we're before the cliff, then nothing is vested.
319         if (_time < _grant.cliff) {
320             return 0;
321         }
322 
323         // If we're after the end of the vesting period - everything is vested;
324         if (_time >= _grant.end) {
325             return _grant.value;
326         }
327 
328         // Calculate amount of installments past until now.
329         //
330         // NOTE result gets floored because of integer division.
331         uint installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);
332 
333         // Calculate amount of days in entire vesting period.
334         uint vestingDays = _grant.end.sub(_grant.start);
335 
336         // Calculate and return installments that have passed according to vesting days that have passed.
337         return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);
338     }
339 
340     /// @dev Unlock vested tokens and transfer them to their holder.
341     /// @return a uint Representing the amount of vested tokens transferred to their holder.
342     function unlockVestedTokens() external {
343         Grant storage grant = grants[msg.sender];
344 
345         // Require that there will be funds left in grant to tranfser to holder.
346         require(grant.value != 0);
347 
348         // Get the total amount of vested tokens, acccording to grant.
349         uint vested = calculateVestedTokens(grant, now);
350         if (vested == 0) {
351             return;
352         }
353 
354         // Make sure the holder doesn't transfer more than what he already has.
355         uint transferable = vested.sub(grant.transferred);
356         if (transferable == 0) {
357             return;
358         }
359 
360         // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
361         grant.transferred = grant.transferred.add(transferable);
362         totalVesting = totalVesting.sub(transferable);
363         token.transfer(msg.sender, transferable);
364 
365         emit TokensUnlocked(msg.sender, transferable);
366     }
367 }