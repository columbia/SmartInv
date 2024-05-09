1 pragma solidity 0.4.24;
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
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address _owner, address _spender)
23     public view returns (uint256);
24 
25   function transferFrom(address _from, address _to, uint256 _value)
26     public returns (bool);
27 
28   function approve(address _spender, uint256 _value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeERC20
39  * @dev Wrappers around ERC20 operations that throw on failure.
40  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
41  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
42  */
43 library SafeERC20 {
44   function safeTransfer(
45     ERC20Basic _token,
46     address _to,
47     uint256 _value
48   )
49     internal
50   {
51     require(_token.transfer(_to, _value));
52   }
53 
54   function safeTransferFrom(
55     ERC20 _token,
56     address _from,
57     address _to,
58     uint256 _value
59   )
60     internal
61   {
62     require(_token.transferFrom(_from, _to, _value));
63   }
64 
65   function safeApprove(
66     ERC20 _token,
67     address _spender,
68     uint256 _value
69   )
70     internal
71   {
72     require(_token.approve(_spender, _value));
73   }
74 }
75 
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (_a == 0) {
91       return 0;
92     }
93 
94     c = _a * _b;
95     assert(c / _a == _b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     // assert(_b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = _a / _b;
105     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
106     return _a / _b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     assert(_b <= _a);
114     return _a - _b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
121     c = _a + _b;
122     assert(c >= _a);
123     return c;
124   }
125 }
126 
127 
128 /**
129  * @title Ownable
130  * @dev The Ownable contract has an owner address, and provides basic authorization control
131  * functions, this simplifies the implementation of "user permissions".
132  */
133 contract Ownable {
134   address public owner;
135 
136 
137   event OwnershipRenounced(address indexed previousOwner);
138   event OwnershipTransferred(
139     address indexed previousOwner,
140     address indexed newOwner
141   );
142 
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146    * account.
147    */
148   constructor() public {
149     owner = msg.sender;
150   }
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160   /**
161    * @dev Allows the current owner to relinquish control of the contract.
162    * @notice Renouncing to ownership will leave the contract without an owner.
163    * It will not be possible to call the functions with the `onlyOwner`
164    * modifier anymore.
165    */
166   function renounceOwnership() public onlyOwner {
167     emit OwnershipRenounced(owner);
168     owner = address(0);
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param _newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address _newOwner) public onlyOwner {
176     _transferOwnership(_newOwner);
177   }
178 
179   /**
180    * @dev Transfers control of the contract to a newOwner.
181    * @param _newOwner The address to transfer ownership to.
182    */
183   function _transferOwnership(address _newOwner) internal {
184     require(_newOwner != address(0));
185     emit OwnershipTransferred(owner, _newOwner);
186     owner = _newOwner;
187   }
188 }
189 
190 
191 
192 /**
193  * @title Vesting trustee contract for CoyToken.
194  */
195 contract CoyVesting is Ownable {
196 
197     using SafeMath for uint256;
198 
199     using SafeERC20 for ERC20;
200 
201     ERC20 public token;
202 
203     // Vesting grant for a specific holder.
204     struct Grant {
205         uint256 value;
206         uint256 start;
207         uint256 cliff;
208         uint256 end;
209         uint256 installmentLength; // In seconds.
210         uint256 transferred;
211         bool revocable;
212     }
213 
214     // Holder to grant information mapping.
215     mapping (address => Grant) public grants;
216 
217     // Total tokens available for vesting.
218     uint256 public totalVesting;
219 
220     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
221 
222     event TokensUnlocked(address indexed _to, uint256 _value);
223 
224     event GrantRevoked(address indexed _holder, uint256 _refund);
225 
226     /**
227      * @dev Constructor that initializes the address of the CoyToken contract.
228      * @param _token CoyToken The address of the previously deployed CoyToken contract.
229      */
230     constructor(ERC20 _token) public {
231         require(_token != address(0), "Token must exist and cannot be 0 address.");
232         
233         token = _token;
234     }
235     
236     /**
237      * @dev Unlock vested tokens and transfer them to their holder.
238      */
239     function unlockVestedTokens() external {
240         Grant storage grant_ = grants[msg.sender];
241 
242         // Require that the grant is not empty.
243         require(grant_.value != 0);
244         
245         // Get the total amount of vested tokens, according to grant.
246         uint256 vested = calculateVestedTokens(grant_, block.timestamp);
247         
248         if (vested == 0) {
249             return;
250         }
251         
252         // Make sure the holder doesn't transfer more than what he already has.
253         
254         uint256 transferable = vested.sub(grant_.transferred);
255         
256         if (transferable == 0) {
257             return;
258         }
259         
260         // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
261         grant_.transferred = grant_.transferred.add(transferable);
262         totalVesting = totalVesting.sub(transferable);
263         
264         token.safeTransfer(msg.sender, transferable);
265 
266         emit TokensUnlocked(msg.sender, transferable);
267     }
268 
269     /**
270      * @dev Grant tokens to a specified address. Please note, that the trustee must have enough ungranted tokens
271      * to accomodate the new grant. Otherwise, the call with fail.
272      * @param _to address The holder address.
273      * @param _value uint256 The amount of tokens to be granted.
274      * @param _start uint256 The beginning of the vesting period.
275      * @param _cliff uint256 Point in time of the end of the cliff period (when the first installment is made).
276      * @param _end uint256 The end of the vesting period.
277      * @param _installmentLength uint256 The length of each vesting installment (in seconds).
278      * @param _revocable bool Whether the grant is revocable or not.
279      */
280     function granting(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
281     uint256 _installmentLength, bool _revocable)
282     external onlyOwner 
283     {    
284         require(_to != address(0));
285         
286         // Don't allow holder to be this contract.
287         require(_to != address(this));
288         
289         require(_value > 0);
290         
291         // Require that every holder can be granted tokens only once.
292         require(grants[_to].value == 0);
293         
294         // Require for time ranges to be consistent and valid.
295         require(_start <= _cliff && _cliff <= _end);
296         
297         // Require installment length to be valid and no longer than (end - start).
298         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
299         
300         // Grant must not exceed the total amount of tokens currently available for vesting.
301         require(totalVesting.add(_value) <= token.balanceOf(address(this)));
302         
303         // Assign a new grant.
304         grants[_to] = Grant({
305             value: _value,
306             start: _start,
307             cliff: _cliff,
308             end: _end,
309             installmentLength: _installmentLength,
310             transferred: 0,
311             revocable: _revocable
312         });
313         
314         // Since tokens have been granted, increase the total amount available for vesting.
315         totalVesting = totalVesting.add(_value);
316         
317         emit NewGrant(msg.sender, _to, _value);
318     }
319     
320     /**
321      * @dev Calculate the total amount of vested tokens of a holder at a given time.
322      * @param _holder address The address of the holder.
323      * @param _time uint256 The specific time to calculate against.
324      * @return a uint256 Representing a holder's total amount of vested tokens.
325      */
326     function vestedTokens(address _holder, uint256 _time) external view returns (uint256) {
327         Grant memory grant_ = grants[_holder];
328         if (grant_.value == 0) {
329             return 0;
330         }
331         return calculateVestedTokens(grant_, _time);
332     }
333 
334     /** 
335      * @dev Revoke the grant of tokens of a specifed address.
336      * @param _holder The address which will have its tokens revoked.
337      */
338     function revoke(address _holder) public onlyOwner {
339         Grant memory grant_ = grants[_holder];
340 
341         // Grant must be revocable.
342         require(grant_.revocable);
343 
344         // Calculate amount of remaining tokens that are still available (i.e. not yet vested) to be returned to owner.
345         uint256 vested = calculateVestedTokens(grant_, block.timestamp);
346         
347         uint256 notTransferredInstallment = vested.sub(grant_.transferred);
348         
349         uint256 refund = grant_.value.sub(vested);
350         
351         //Update of transferred not necessary due to deletion of the grant in the following step.
352         
353         // Remove grant information.
354         delete grants[_holder];
355         
356         // Update total vesting amount and transfer previously calculated tokens to owner.
357         totalVesting = totalVesting.sub(refund).sub(notTransferredInstallment);
358         
359         // Transfer vested amount that was not yet transferred to _holder.
360         token.safeTransfer(_holder, notTransferredInstallment);
361         
362         emit TokensUnlocked(_holder, notTransferredInstallment);
363         
364         token.safeTransfer(msg.sender, refund);
365         
366         emit TokensUnlocked(msg.sender, refund);
367         
368         emit GrantRevoked(_holder, refund);
369     }
370 
371     /**
372      * @dev Calculate amount of vested tokens at a specifc time.
373      * @param _grant Grant The vesting grant.
374      * @param _time uint256 The time to be checked
375      * @return a uint256 Representing the amount of vested tokens of a specific grant.
376      */
377     function calculateVestedTokens(Grant _grant, uint256 _time) private pure returns (uint256) {
378         // If we're before the cliff, then nothing is vested.
379         if (_time < _grant.cliff) {
380             return 0;
381         }
382        
383         // If we're after the end of the vesting period - everything is vested;
384         if (_time >= _grant.end) {
385             return _grant.value;
386         }
387        
388         // Calculate amount of installments past until now.
389         // NOTE result gets floored because of integer division.
390         uint256 installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);
391        
392         // Calculate amount of days in entire vesting period.
393         uint256 vestingDays = _grant.end.sub(_grant.start);
394        
395         // Calculate and return installments that have passed according to vesting days that have passed.
396         return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);
397     }
398 }