1 pragma solidity 0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16     }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 interface IERC20 {
55   function totalSupply() external view returns (uint256);
56 
57   function balanceOf(address who) external view returns (uint256);
58 
59   function allowance(address owner, address spender)
60     external view returns (uint256);
61 
62   function transfer(address to, uint256 value) external returns (bool);
63 
64   function approve(address spender, uint256 value)
65     external returns (bool);
66 
67   function transferFrom(address from, address to, uint256 value)
68     external returns (bool);
69 
70   event Transfer(
71     address indexed from,
72     address indexed to,
73     uint256 value
74   );
75 
76   event Approval(
77     address indexed owner,
78     address indexed spender,
79     uint256 value
80   );
81 }
82 
83     /**
84     * @title Standard ERC20 token
85     *
86     * @dev Implementation of the basic standard token.
87     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
88     * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89     */
90 contract ERC20 is IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowed;
96 
97     uint256 private _totalSupply;
98     string public name;
99     string public symbol;
100     uint8 public decimals;
101 
102     /**
103     * @dev Total number of tokens in existence
104     */
105     function totalSupply() public view returns (uint256) {
106         return _totalSupply;
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param owner The address to query the the balance of.
112     * @return An uint256 representing the amount owned by the passed address.
113     */
114     function balanceOf(address owner) public view returns (uint256) {
115         return _balances[owner];
116     }
117 
118     /**
119     * @dev Function to check the amount of tokens that an owner allowed to a spender.
120     * @param owner address The address which owns the funds.
121     * @param spender address The address which will spend the funds.
122     * @return A uint256 specifying the amount of tokens still available for the spender.
123     */
124     function allowance(
125         address owner,
126         address spender
127     )
128         public
129         view
130         returns (uint256)
131     {
132         return _allowed[owner][spender];
133     }
134 
135 
136     /**
137     * @dev Transfer token for a specified address
138     * @param to The address to transfer to.
139     * @param value The amount to be transferred.
140     */
141     function transfer(address to, uint256 value) public returns (bool) {
142         require(value <= _balances[msg.sender]);
143         require(to != address(0));
144 
145         _balances[msg.sender] = _balances[msg.sender].sub(value);
146         _balances[to] = _balances[to].add(value);
147         emit Transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     * Beware that changing an allowance with this method brings the risk that someone may use both the old
154     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     * @param spender The address which will spend the funds.
158     * @param value The amount of tokens to be spent.
159     */
160     function approve(address spender, uint256 value) public returns (bool) {
161         require(spender != address(0));
162 
163         _allowed[msg.sender][spender] = value;
164         emit Approval(msg.sender, spender, value);
165         return true;
166     }
167 
168     /**
169     * @dev Transfer tokens from one address to another
170     * @param from address The address which you want to send tokens from
171     * @param to address The address which you want to transfer to
172     * @param value uint256 the amount of tokens to be transferred
173     */
174     function transferFrom(
175         address from,
176         address to,
177         uint256 value
178     )
179         public
180         returns (bool)
181     {
182         require(value <= _balances[from]);
183         require(value <= _allowed[from][msg.sender]);
184         require(to != address(0));
185 
186         _balances[from] = _balances[from].sub(value);
187         _balances[to] = _balances[to].add(value);
188         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
189         emit Transfer(from, to, value);
190         return true;
191     }
192 
193     /**
194     * @dev Increase the amount of tokens that an owner allowed to a spender.
195     * approve should be called when allowed_[_spender] == 0. To increment
196     * allowed value is better to use this function to avoid 2 calls (and wait until
197     * the first transaction is mined)
198     * From MonolithDAO Token.sol
199     * @param spender The address which will spend the funds.
200     * @param addedValue The amount of tokens to increase the allowance by.
201     */
202     function increaseAllowance(
203         address spender,
204         uint256 addedValue
205     )
206         public
207         returns (bool)
208     {
209         require(spender != address(0));
210 
211         _allowed[msg.sender][spender] = (
212         _allowed[msg.sender][spender].add(addedValue));
213         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214         return true;
215     }
216 
217     /**
218     * @dev Decrease the amount of tokens that an owner allowed to a spender.
219     * approve should be called when allowed_[_spender] == 0. To decrement
220     * allowed value is better to use this function to avoid 2 calls (and wait until
221     * the first transaction is mined)
222     * From MonolithDAO Token.sol
223     * @param spender The address which will spend the funds.
224     * @param subtractedValue The amount of tokens to decrease the allowance by.
225     */
226     function decreaseAllowance(
227         address spender,
228         uint256 subtractedValue
229     )
230         public
231         returns (bool)
232     {
233         require(spender != address(0));
234 
235         _allowed[msg.sender][spender] = (
236         _allowed[msg.sender][spender].sub(subtractedValue));
237         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
238         return true;
239     }
240 
241     /**
242     * @dev Internal function that mints an amount of the token and assigns it to
243     * an account. This encapsulates the modification of balances such that the
244     * proper events are emitted.
245     * @param account The account that will receive the created tokens.
246     * @param amount The amount that will be created.
247     */
248     function _mint(address account, uint256 amount) internal {
249         require(account != address(0));
250         _totalSupply = _totalSupply.add(amount);
251         _balances[account] = _balances[account].add(amount);
252         emit Transfer(address(0), account, amount);
253     }
254 
255     /**
256     * @dev Internal function that burns an amount of the token of a given
257     * account.
258     * @param account The account whose tokens will be burnt.
259     * @param amount The amount that will be burnt.
260     */
261     function _burn(address account, uint256 amount) internal {
262         require(account != address(0));
263         require(amount <= _balances[account]);
264 
265         _totalSupply = _totalSupply.sub(amount);
266         _balances[account] = _balances[account].sub(amount);
267         emit Transfer(account, address(0), amount);
268     }
269 
270     /**
271     * @dev Internal function that burns an amount of the token of a given
272     * account, deducting from the sender's allowance for said account. Uses the
273     * internal burn function.
274     * @param account The account whose tokens will be burnt.
275     * @param amount The amount that will be burnt.
276     */
277     function _burnFrom(address account, uint256 amount) internal {
278         require(amount <= _allowed[account][msg.sender]);
279 
280         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
281         // this function needs to emit an event with the updated approval.
282         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
283         amount);
284         _burn(account, amount);
285     }
286 
287     function burnFrom(address account, uint256 amount) public {
288         _burnFrom(account, amount);
289     }
290 }
291 
292 /**
293  * @title Ownable
294  * @dev The Ownable contract has an owner address, and provides basic authorization control
295  * functions, this simplifies the implementation of "user permissions".
296  */
297 contract Ownable {
298     address public owner;
299 
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303 
304   /**
305    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
306    * account.
307    */
308     constructor() public {
309         owner = msg.sender;
310     }
311 
312   /**
313    * @dev Throws if called by any account other than the owner.
314    */
315     modifier onlyOwner() {
316         require(msg.sender == owner);
317         _;
318     }
319 
320   /**
321    * @dev Allows the current owner to transfer control of the contract to a newOwner.
322    * @param newOwner The address to transfer ownership to.
323    */
324     function transferOwnership(address newOwner) public onlyOwner {
325         require(newOwner != address(0));
326         emit OwnershipTransferred(owner, newOwner);
327         owner = newOwner;
328     }
329 
330     function getOwner() public view returns (address) {
331         return owner;
332     }
333 
334     function getOwnerStatic(address ownableContract) internal view returns (address) {
335         bytes memory callcodeOwner = abi.encodeWithSignature("getOwner()");
336         (bool success, bytes memory returnData) = address(ownableContract).staticcall(callcodeOwner);
337         require(success, "input address has to be a valid ownable contract");
338         return parseAddr(returnData);
339     }
340 
341     function getTokenVestingStatic(address tokenFactoryContract) internal view returns (address) {
342         bytes memory callcodeTokenVesting = abi.encodeWithSignature("getTokenVesting()");
343         (bool success, bytes memory returnData) = address(tokenFactoryContract).staticcall(callcodeTokenVesting);
344         require(success, "input address has to be a valid TokenFactory contract");
345         return parseAddr(returnData);
346     }
347 
348 
349     function parseAddr(bytes memory data) public pure returns (address parsed){
350         assembly {parsed := mload(add(data, 32))}
351     }
352 
353 
354 
355 
356 }
357 
358 /**
359  * @title TokenVesting contract for linearly vesting tokens to the respective vesting beneficiary
360  * @dev This contract receives accepted proposals from the Manager contract, and holds in lieu
361  * @dev all the tokens to be vested by the vesting beneficiary. It releases these tokens when called
362  * @dev upon in a continuous-like linear fashion.
363  * @notice This contract was written with reference to the TokenVesting contract from openZeppelin
364  * @notice @ https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/drafts/TokenVesting.sol
365  * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
366  */
367 contract TokenVesting is Ownable{
368 
369     using SafeMath for uint256;
370 
371     event Released(address indexed token, address vestingBeneficiary, uint256 amount);
372     event LogTokenAdded(address indexed token, address vestingBeneficiary, uint256 vestingPeriodInWeeks);
373 
374     uint256 constant public WEEKS_IN_SECONDS = 1 * 7 * 24 * 60 * 60;
375 
376     struct VestingInfo {
377         address vestingBeneficiary;
378         uint256 releasedSupply;
379         uint256 start;
380         uint256 duration;
381     }
382 
383     mapping(address => VestingInfo) public vestingInfo;
384 
385     /**
386      * @dev Method to add a token into TokenVesting
387      * @param _token address Address of token
388      * @param _vestingBeneficiary address Address of vesting beneficiary
389      * @param _vestingPeriodInWeeks uint256 Period of vesting, in units of Weeks, to be converted
390      * @notice This emits an Event LogTokenAdded which is indexed by the token address
391      */
392     function addToken
393     (
394         address _token,
395         address _vestingBeneficiary,
396         uint256 _vestingPeriodInWeeks
397     )
398     external
399     onlyOwner
400     {
401         vestingInfo[_token] = VestingInfo({
402             vestingBeneficiary : _vestingBeneficiary,
403             releasedSupply : 0,
404             start : now,
405             duration : uint256(_vestingPeriodInWeeks).mul(WEEKS_IN_SECONDS)
406         });
407         emit LogTokenAdded(_token, _vestingBeneficiary, _vestingPeriodInWeeks);
408     }
409 
410     /**
411      * @dev Method to release any already vested but not yet received tokens
412      * @param _token address Address of Token
413      * @notice This emits an Event LogTokenAdded which is indexed by the token address
414      */
415 
416     function release
417     (
418         address _token
419     )
420     external
421     {
422         uint256 unreleased = releaseableAmount(_token);
423         require(unreleased > 0);
424         vestingInfo[_token].releasedSupply = vestingInfo[_token].releasedSupply.add(unreleased);
425         bool success = ERC20(_token).transfer(vestingInfo[_token].vestingBeneficiary, unreleased);
426         require(success, "transfer from vesting to beneficiary has to succeed");
427         emit Released(_token, vestingInfo[_token].vestingBeneficiary, unreleased);
428     }
429 
430     /**
431      * @dev Method to check the quantity of token that is already vested but not yet received
432      * @param _token address Address of Token
433      * @return uint256 Quantity of token that is already vested but not yet received
434      */
435     function releaseableAmount
436     (
437         address _token
438     )
439     public
440     view
441     returns(uint256)
442     {
443         return vestedAmount(_token).sub(vestingInfo[_token].releasedSupply);
444     }
445 
446     /**
447      * @dev Method to check the quantity of token vested at current block
448      * @param _token address Address of Token
449      * @return uint256 Quantity of token that is vested at current block
450      */
451 
452     function vestedAmount
453     (
454         address _token
455     )
456     public
457     view
458     returns(uint256)
459     {
460         VestingInfo memory info = vestingInfo[_token];
461         uint256 currentBalance = ERC20(_token).balanceOf(address(this));
462         uint256 totalBalance = currentBalance.add(info.releasedSupply);
463         if (now >= info.start.add(info.duration)) {
464             return totalBalance;
465         } else {
466             return totalBalance.mul(now.sub(info.start)).div(info.duration);
467         }
468 
469     }
470 
471 
472     function getVestingInfo
473     (
474         address _token
475     )
476     external
477     view
478     returns(VestingInfo memory)
479     {
480         return vestingInfo[_token];
481     }
482 
483 
484 }