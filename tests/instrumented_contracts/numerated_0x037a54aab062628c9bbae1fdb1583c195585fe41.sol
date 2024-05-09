1 pragma solidity 0.5.4;
2 
3 
4 /**
5 * @title interface of ERC 20 token
6 * 
7 */
8 
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title SafeERC20
30  * @dev Wrappers around ERC20 operations that throw on failure.
31  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
32  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
33  */
34  
35 library SafeERC20 {
36     
37     using SafeMath for uint256;
38 
39     function safeTransfer(IERC20 token, address to, uint256 value) internal {
40         require(token.transfer(to, value));
41     }
42 
43     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
44         require(token.transferFrom(from, to, value));
45     }
46 
47     function safeApprove(IERC20 token, address spender, uint256 value) internal {
48         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
49         require(token.approve(spender, value));
50     }
51 
52     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
53         uint256 newAllowance = token.allowance(address(this), spender).add(value);
54         require(token.approve(spender, newAllowance));
55     }
56 
57     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
58         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
59         require(token.approve(spender, newAllowance));
60     }
61 }
62 
63 /**
64  * @title SafeMath
65  * @dev Unsigned math operations with safety checks that revert on error
66  */
67 library SafeMath {
68     /**
69      * @dev Multiplies two unsigned integers, reverts on overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         
73         if (a == 0) {
74             return 0;
75         }
76 
77         uint256 c = a * b;
78         require(c / a == b);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
85      */
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87        
88         require(b > 0);
89         uint256 c = a / b;
90        
91         return c;
92     }
93 
94     /**
95      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b <= a);
99         uint256 c = a - b;
100 
101         return c;
102     }
103 
104     /**
105      * @dev Adds two unsigned integers, reverts on overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 
114     /**
115      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
116      * reverts when dividing by zero.
117      */
118     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b != 0);
120         return a % b;
121     }
122 }
123 
124 /**
125  * @title Ownable
126  * @dev The Ownable contract has an owner address, and provides basic authorization control
127  * functions, this simplifies the implementation of "user permissions".
128  */
129 contract Ownable {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
136      * account.
137      */
138     constructor () internal {
139         _owner = msg.sender;
140         emit OwnershipTransferred(address(0), _owner);
141     }
142 
143     /**
144      * @return the address of the owner.
145      */
146     function owner() public view returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(isOwner());
155         _;
156     }
157 
158     /**
159      * @return true if `msg.sender` is the owner of the contract.
160      */
161     function isOwner() public view returns (bool) {
162         return msg.sender == _owner;
163     }
164 
165     /**
166      * @dev Allows the current owner to relinquish control of the contract.
167      * @notice Warning!!!! only be used when owner address is compromised
168      */
169     function renounceOwnership() public onlyOwner {
170         emit OwnershipTransferred(_owner, address(0));
171         _owner = address(0);
172     }
173 
174     /**
175      * @dev Allows the current owner to transfer control of the contract to a newOwner.
176      * @param newOwner The address to transfer ownership to.
177      */
178     function transferOwnership(address newOwner) public onlyOwner {
179         _transferOwnership(newOwner);
180     }
181 
182     /**
183      * @dev Transfers control of the contract to a newOwner.
184      * @param newOwner The address to transfer ownership to.
185      */
186     function _transferOwnership(address newOwner) internal {
187         require(newOwner != address(0));
188         emit OwnershipTransferred(_owner, newOwner);
189         _owner = newOwner;
190     }
191 }
192 
193 
194 
195 /**
196  * @title Vesting token for specific period
197  */
198 contract TokenVesting is Ownable{
199     
200     using SafeMath for uint256;
201     using SafeERC20 for IERC20;
202     
203     struct VestedToken{
204         uint256 cliff;
205         uint256 start;
206         uint256 duration;
207         uint256 releasedToken;
208         uint256 totalToken;
209         bool revoked;
210     }
211     
212     mapping (address => VestedToken) public vestedUser; 
213     
214     // default Vesting parameter values
215     uint256 private _cliff = 2592000; // 30 days period
216     uint256 private _duration = 93312000; // for 3 years
217     bool private _revoked = false;
218     
219     IERC20 public LCXToken;
220     
221     event TokenReleased(address indexed account, uint256 amount);
222     event VestingRevoked(address indexed account);
223     
224     /**
225      * @dev Its a modifier in which we authenticate the caller is owner or LCXToken Smart Contract
226      */ 
227     modifier onlyLCXTokenAndOwner() {
228         require(msg.sender==owner() || msg.sender == address(LCXToken));
229         _;
230     }
231     
232     /**
233      * @dev First we have to set token address before doing any thing 
234      * @param token LCX Smart contract Address
235      */
236      
237     function setTokenAddress(IERC20 token) public onlyOwner returns(bool){
238         LCXToken = token;
239         return true;
240     }
241     
242     /**
243      * @dev this will set the beneficiary with default vesting 
244      * parameters ie, every month for 3 years
245      * @param account address of the beneficiary for vesting
246      * @param amount  totalToken to be vested
247      */
248      
249      function setDefaultVesting(address account, uint256 amount) public onlyLCXTokenAndOwner returns(bool){
250          _setDefaultVesting(account, amount);
251          return true;
252      }
253      
254      /**
255       *@dev Internal function to set default vesting parameters
256       */
257       
258      function _setDefaultVesting(address account, uint256 amount)  internal {
259          require(account!=address(0));
260          VestedToken storage vested = vestedUser[account];
261          vested.cliff = _cliff;
262          vested.start = block.timestamp;
263          vested.duration = _duration;
264          vested.totalToken = amount;
265          vested.releasedToken = 0;
266          vested.revoked = _revoked;
267      }
268      
269      
270      /**
271      * @dev this will set the beneficiary with vesting 
272      * parameters provided
273      * @param account address of the beneficiary for vesting
274      * @param amount  totalToken to be vested
275      * @param cliff In seconds of one period in vesting
276      * @param duration In seconds of total vesting 
277      * @param startAt UNIX timestamp in seconds from where vesting will start
278      */
279      
280      function setVesting(address account, uint256 amount, uint256 cliff, uint256 duration, uint256 startAt ) public onlyLCXTokenAndOwner  returns(bool){
281          _setVesting(account, amount, cliff, duration, startAt);
282          return true;
283      }
284      
285      /**
286       * @dev Internal function to set default vesting parameters
287       * @param account address of the beneficiary for vesting
288       * @param amount  totalToken to be vested
289       * @param cliff In seconds of one period in vestin
290       * @param duration In seconds of total vesting duration
291       * @param startAt UNIX timestamp in seconds from where vesting will start
292       *
293       */
294      
295      function _setVesting(address account, uint256 amount, uint256 cliff, uint256 duration, uint256 startAt) internal {
296          
297          require(account!=address(0));
298          require(cliff<=duration);
299          VestedToken storage vested = vestedUser[account];
300          vested.cliff = cliff;
301          vested.start = startAt;
302          vested.duration = duration;
303          vested.totalToken = amount;
304          vested.releasedToken = 0;
305          vested.revoked = false;
306      }
307 
308     /**
309      * @notice Transfers vested tokens to beneficiary.
310      * anyone can release their token 
311      */
312      
313     function releaseMyToken() public returns(bool) {
314         releaseToken(msg.sender);
315         return true;
316     }
317     
318      /**
319      * @notice Transfers vested tokens to the given account.
320      * @param account address of the vested user
321      */
322     function releaseToken(address account) public {
323        require(account != address(0));
324        VestedToken storage vested = vestedUser[account];
325        uint256 unreleasedToken = _releasableAmount(account);  // total releasable token currently
326        require(unreleasedToken>0);
327        vested.releasedToken = vested.releasedToken.add(unreleasedToken);
328        LCXToken.safeTransfer(account,unreleasedToken);
329        emit TokenReleased(account, unreleasedToken);
330     }
331     
332     /**
333      * @dev Calculates the amount that has already vested but hasn't been released yet.
334      * @param account address of user
335      */
336     function _releasableAmount(address account) internal view returns (uint256) {
337         return _vestedAmount(account).sub(vestedUser[account].releasedToken);
338     }
339 
340   
341     /**
342      * @dev Calculates the amount that has already vested.
343      * @param account address of the user
344      */
345     function _vestedAmount(address account) internal view returns (uint256) {
346         VestedToken storage vested = vestedUser[account];
347         uint256 totalToken = vested.totalToken;
348         if(block.timestamp <  vested.start.add(vested.cliff)){
349             return 0;
350         }else if(block.timestamp >= vested.start.add(vested.duration) || vested.revoked){
351             return totalToken;
352         }else{
353             uint256 numberOfPeriods = (block.timestamp.sub(vested.start)).div(vested.cliff);
354             return totalToken.mul(numberOfPeriods.mul(vested.cliff)).div(vested.duration);
355         }
356     }
357     
358     /**
359      * @notice Allows the owner to revoke the vesting. Tokens already vested
360      * remain in the contract, the rest are returned to the owner.
361      * @param account address in which the vesting is revoked
362      */
363     function revoke(address account) public onlyOwner {
364         VestedToken storage vested = vestedUser[account];
365         require(!vested.revoked);
366         uint256 balance = vested.totalToken;
367         uint256 unreleased = _releasableAmount(account);
368         uint256 refund = balance.sub(unreleased);
369         vested.revoked = true;
370         vested.totalToken = unreleased;
371         LCXToken.safeTransfer(owner(), refund);
372         emit VestingRevoked(account);
373     }
374     
375     
376     
377     
378 }
379 
380 
381 
382 
383 
384 contract lcxToken is IERC20, Ownable{
385     
386     using SafeMath for uint256;
387 
388     mapping (address => uint256) private _balances;
389 
390     mapping (address => mapping (address => uint256)) private _allowed;
391 
392     uint256 private _totalSupply;
393     
394     TokenVesting public vestingContractAddress;
395     
396     /**
397      * @dev name, symbol and decimals of LCX Token
398      */ 
399     string public constant name = 'LCX';
400     string public constant symbol = 'LCX';
401     uint256 public constant decimals = 18;
402     
403     /**
404      * @dev Initializes the totalSupply of the token with decimal point 18
405      */
406     constructor(uint256 totalSupply) public{
407         _totalSupply = totalSupply.mul(10**decimals);
408         _balances[msg.sender] = _totalSupply;
409         emit Transfer(address(0), msg.sender, _totalSupply);
410     }
411 
412     /**
413      * @dev Total number of tokens in existence
414      */
415     function totalSupply() public view returns (uint256) {
416         return _totalSupply;
417     }
418 
419     /**
420      * @dev Gets the balance of the specified address.
421      * @param owner The address to query the balance of.
422      * @return An uint256 representing the amount owned by the passed address.
423      */
424     function balanceOf(address owner) public view returns (uint256) {
425         return _balances[owner];
426     }
427 
428     /**
429      * @dev Function to check the amount of tokens that an owner allowed to a spender.
430      * @param owner address The address which owns the funds.
431      * @param spender address The address which will spend the funds.
432      * @return A uint256 specifying the amount of tokens still available for the spender.
433      */
434     function allowance(address owner, address spender) public view returns (uint256) {
435         return _allowed[owner][spender];
436     }
437 
438     /**
439      * @dev Transfer token for a specified address
440      * @param to The address to transfer to.
441      * @param value The amount to be transferred.
442      */
443     function transfer(address to, uint256 value) public returns (bool) {
444         _transfer(msg.sender, to, value);
445         return true;
446     }
447 
448     /**
449      * @param spender The address which will spend the funds.
450      * @param value The amount of tokens to be spent.
451      */
452     function approve(address spender, uint256 value) public returns (bool) {
453         _approve(msg.sender, spender, value);
454         return true;
455     }
456 
457     /**
458      * @param from address The address which you want to send tokens from
459      * @param to address The address which you want to transfer to
460      * @param value uint256 the amount of tokens to be transferred
461      */
462     function transferFrom(address from, address to, uint256 value) public returns (bool) {
463         _transfer(from, to, value);
464         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
465         return true;
466     }
467 
468     /**
469      * @param spender The address which will spend the funds.
470      * @param addedValue The amount of tokens to increase the allowance by.
471      */
472     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
473         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
474         return true;
475     }
476 
477     /**
478      * @param spender The address which will spend the funds.
479      * @param subtractedValue The amount of tokens to decrease the allowance by.
480      */
481     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
482         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
483         return true;
484     }
485     
486     
487      /**
488      * @dev Burns a specific amount of tokens.
489      * @param value The amount of token to be burned.
490      */
491     function burn(uint256 value) public {
492         _burn(msg.sender, value);
493     }
494 
495     /**
496      * @dev Burns a specific amount of tokens from the target address and decrements allowance
497      * @param from address The account whose tokens will be burned.
498      * @param value uint256 The amount of token to be burned.
499      */
500     function burnFrom(address from, uint256 value) public {
501         _burnFrom(from, value);
502     }
503 
504     /**
505      * @dev Transfer token for a specified addresses
506      * @param from The address to transfer from.
507      * @param to The address to transfer to.
508      * @param value The amount to be transferred.
509      */
510     function _transfer(address from, address to, uint256 value) internal {
511         require(to != address(0));
512 
513         _balances[from] = _balances[from].sub(value);
514         _balances[to] = _balances[to].add(value);
515         emit Transfer(from, to, value);
516     }
517 
518    
519     /**
520      * @param account The account whose tokens will be burnt.
521      * @param value The amount that will be burnt.
522      */
523     function _burn(address account, uint256 value) internal {
524         require(account != address(0));
525         _totalSupply = _totalSupply.sub(value);
526         _balances[account] = _balances[account].sub(value);
527         emit Transfer(account, address(0), value);
528     }
529 
530     /**
531      * @param owner The address that owns the tokens.
532      * @param spender The address that will spend the tokens.
533      * @param value The number of tokens that can be spent.
534      */
535     function _approve(address owner, address spender, uint256 value) internal {
536         require(spender != address(0));
537         require(owner != address(0));
538 
539         _allowed[owner][spender] = value;
540         emit Approval(owner, spender, value);
541     }
542 
543     /**
544      * @param account The account whose tokens will be burnt.
545      * @param value The amount that will be burnt.
546      */
547     function _burnFrom(address account, uint256 value) internal {
548         _burn(account, value);
549         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
550     }
551     
552     
553     /**
554      * @dev Set Vesting Token Smart contract Address before starting vesting
555      * @param tokenVestingAddress Smart conract Address of the Vesting Smart contract
556      */ 
557     function setTokenVestingAddress(TokenVesting tokenVestingAddress) public onlyOwner returns(bool){
558         vestingContractAddress = tokenVestingAddress;
559         return true;
560     }
561     
562     
563     /**
564      * @dev Vesting users token by default parameters
565      * @param account address of the user 
566      * @param amount the amount to be vested
567      */
568      function setDefaultVestingToken(address account, uint256 amount) public onlyOwner returns(bool){
569          vestingContractAddress.setDefaultVesting(account, amount);
570          _transfer(msg.sender,address(vestingContractAddress), amount);
571          return true;
572      }
573      
574     /**
575      * @dev Vesting users token by given parameters
576      * @param account address of the beneficiary for vesting
577      * @param amount  totalToken to be vested
578      * @param cliff In seconds of one period in vestin
579      * @param duration In seconds of total vesting duration
580      * @param startAt UNIX timestamp in seconds from where vesting will start
581      */
582      function setVestingToken(address account, uint256 amount, uint256 cliff, uint256 duration, uint256 startAt) public onlyOwner returns(bool){
583          vestingContractAddress.setVesting(account, amount, cliff, duration, startAt);
584          _transfer(msg.sender ,address(vestingContractAddress), amount);
585          return true;
586      }
587     
588     /**
589      * @dev Batch Transfer Transactions
590      * @param accounts array of addresses
591      * @param values array of values to be transfer
592      */
593      function batchTransfer(address[] memory accounts, uint256[] memory values ) public onlyOwner returns(bool){
594         require(accounts.length == values.length);
595         for(uint256 i=0;i< accounts.length;i++){
596             _transfer(msg.sender, accounts[i], values[i]);
597         }
598         return true;
599      }
600 }