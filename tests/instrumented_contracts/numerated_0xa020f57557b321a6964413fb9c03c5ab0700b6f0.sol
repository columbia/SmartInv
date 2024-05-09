1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     uint256 totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111     function allowance(address owner, address spender) public view returns (uint256);
112     function transferFrom(address from, address to, uint256 value) public returns (bool);
113     function approve(address spender, uint256 value) public returns (bool);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126     mapping (address => mapping (address => uint256)) internal allowed;
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 }
195 
196 /**
197  * @title SafeERC20
198  * @dev Wrappers around ERC20 operations that throw on failure.
199  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
200  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
201  */
202 library SafeERC20 {
203     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
204         assert(token.transfer(to, value));
205     }
206 
207     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
208         assert(token.transferFrom(from, to, value));
209     }
210 
211     function safeApprove(ERC20 token, address spender, uint256 value) internal {
212         assert(token.approve(spender, value));
213     }
214 }
215 
216 contract Owned {
217     address public owner;
218 
219     constructor() public {
220         owner = msg.sender;
221     }
222 
223     modifier onlyOwner {
224         require(msg.sender == owner);
225         _;
226     }
227 }
228 
229 /**
230  * @title TokenVesting
231  * @dev A token holder contract that can release its token balance gradually like a
232  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
233  * owner.
234  */
235 contract TokenVesting is Owned {
236     using SafeMath for uint256;
237     using SafeERC20 for ERC20Basic;
238 
239     event Released(uint256 amount);
240     event Revoked();
241 
242     // beneficiary of tokens after they are released
243     address public beneficiary;
244 
245     uint256 public cliff;
246     uint256 public start;
247     uint256 public duration;
248 
249     bool public revocable;
250 
251     mapping (address => uint256) public released;
252     mapping (address => bool) public revoked;
253 
254     address internal ownerShip;
255 
256     /**
257      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
258      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
259      * of the balance will have vested.
260      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
261      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
262      * @param _start the time (as Unix time) at which point vesting starts
263      * @param _duration duration in seconds of the period in which the tokens will vest
264      * @param _revocable whether the vesting is revocable or not
265      */
266     constructor(
267         address _beneficiary,
268         uint256 _start,
269         uint256 _cliff,
270         uint256 _duration,
271         bool _revocable,
272         address _realOwner
273     )
274         public
275     {
276         require(_beneficiary != address(0));
277         require(_cliff <= _duration);
278 
279         beneficiary = _beneficiary;
280         revocable = _revocable;
281         duration = _duration;
282         cliff = _start.add(_cliff);
283         start = _start;
284         ownerShip = _realOwner;
285     }
286 
287     /**
288      * @notice Transfers vested tokens to beneficiary.
289      * @param token ERC20 token which is being vested
290      */
291     function release(ERC20Basic token) public {
292         uint256 unreleased = releasableAmount(token);
293 
294         require(unreleased > 0);
295 
296         released[token] = released[token].add(unreleased);
297 
298         token.safeTransfer(beneficiary, unreleased);
299 
300         emit Released(unreleased);
301     }
302 
303     /**
304      * @notice Allows the owner to revoke the vesting. Tokens already vested
305      * remain in the contract, the rest are returned to the owner.
306      * @param token ERC20 token which is being vested
307      */
308     function revoke(ERC20Basic token) public onlyOwner {
309         require(revocable);
310         require(!revoked[token]);
311 
312         uint256 balance = token.balanceOf(this);
313 
314         uint256 unreleased = releasableAmount(token);
315         uint256 refund = balance.sub(unreleased);
316 
317         revoked[token] = true;
318 
319         token.safeTransfer(ownerShip, refund);
320 
321         emit Revoked();
322     }
323 
324     /**
325      * @dev Calculates the amount that has already vested but hasn't been released yet.
326      * @param token ERC20 token which is being vested
327      */
328     function releasableAmount(ERC20Basic token) public view returns (uint256) {
329         return vestedAmount(token).sub(released[token]);
330     }
331 
332     /**
333      * @dev Calculates the amount that has already vested.
334      * @param token ERC20 token which is being vested
335      */
336     function vestedAmount(ERC20Basic token) public view returns (uint256) {
337         uint256 currentBalance = token.balanceOf(this);
338         uint256 totalBalance = currentBalance.add(released[token]);
339 
340         if (block.timestamp < cliff) {
341             return 0;
342         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
343             return totalBalance;
344         } else {
345             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
346         }
347     }
348 }
349 
350 /**
351  * @title TokenVault
352  * @dev TokenVault is a token holder contract that will allow a
353  * beneficiary to spend the tokens from some function of a specified ERC20 token
354  */
355 contract TokenVault {
356     using SafeERC20 for ERC20;
357 
358     // ERC20 token contract being held
359     ERC20 public token;
360 
361     constructor(ERC20 _token) public {
362         token = _token;
363     }
364 
365     /**
366      * @notice Allow the token itself to send tokens
367      * using transferFrom().
368      */
369     function fillUpAllowance() public {
370         uint256 amount = token.balanceOf(this);
371         require(amount > 0);
372 
373         token.approve(token, amount);
374     }
375 }
376 
377 /**
378  * @title Burnable Token
379  * @dev Token that can be irreversibly burned (destroyed).
380  */
381 contract BurnableToken is StandardToken {
382 
383     event Burn(address indexed burner, uint256 value);
384 
385     /**
386      * @dev Burns a specific amount of tokens.
387      * @param _value The amount of token to be burned.
388      */
389     function burn(uint256 _value) public {
390         require(_value > 0);
391         require(_value <= balances[msg.sender]);
392         // no need to require value <= totalSupply, since that would imply the
393         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
394 
395         address burner = msg.sender;
396         balances[burner] = balances[burner].sub(_value);
397         totalSupply_ = totalSupply_.sub(_value);
398         emit Burn(burner, _value);
399     }
400 }
401 
402 contract WKA_Token is BurnableToken, Owned {
403     string public constant name = "World Kungfu Association";
404     string public constant symbol = "WKA";
405     uint8 public constant decimals = 18;
406 
407     /// Maximum tokens to be allocated (10. billion WKA)
408     uint256 public constant HARD_CAP = 10000000000 * 10**uint256(decimals);
409 
410     /// This address will be used to distribute the team, advisors and reserve tokens
411     address public saleTokensAddress;
412 
413     /// This vault is used to keep the Founders, Advisors and Partners tokens
414     TokenVault public reserveTokensVault;
415 
416     /// Date when the vesting for regular users starts
417     uint64 public date15Dec2018 = 1544832000;
418     uint64 public lock90Days    = 7776000;
419     uint64 public unlock100Days = 8640000;
420 
421     /// Store the vesting contract addresses for each sale contributor
422     mapping(address => address) public vestingOf;
423 
424     constructor(address _saleTokensAddress) public payable {
425         require(_saleTokensAddress != address(0));
426 
427         saleTokensAddress = _saleTokensAddress;
428 
429         /// Maximum tokens to be sold - 47.5 %
430         uint256 saleTokens = 4750000000;
431         createTokens(saleTokens, saleTokensAddress);
432 
433         require(totalSupply_ <= HARD_CAP);
434     }
435 
436     /// @dev Create a ReserveTokenVault 
437     function createReserveTokensVault() external onlyOwner {
438         require(reserveTokensVault == address(0));
439 
440         /// Reserve tokens - 52.5 %
441         uint256 reserveTokens = 5250000000;
442         reserveTokensVault = createTokenVault(reserveTokens);
443 
444         require(totalSupply_ <= HARD_CAP);
445     }
446 
447     /// @dev Create a TokenVault and fill with the specified newly minted tokens
448     function createTokenVault(uint256 tokens) internal onlyOwner returns (TokenVault) {
449         TokenVault tokenVault = new TokenVault(ERC20(this));
450         createTokens(tokens, tokenVault);
451         tokenVault.fillUpAllowance();
452         return tokenVault;
453     }
454 
455     // @dev create specified number of tokens and transfer to destination
456     function createTokens(uint256 _tokens, address _destination) internal onlyOwner {
457         uint256 tokens = _tokens * 10**uint256(decimals);
458         totalSupply_ = totalSupply_.add(tokens);
459         balances[_destination] = balances[_destination].add(tokens);
460         emit Transfer(0x0, _destination, tokens);
461 
462         require(totalSupply_ <= HARD_CAP);
463     }
464 
465     /// @dev vest the sale contributor tokens 
466     function vestTokensDetail(
467                         address _beneficiary,
468                         uint256 _start,
469                         uint256 _cliff,
470                         uint256 _duration,
471                         bool _revocable,
472                         uint256 _tokensAmount) external onlyOwner {
473         require(_beneficiary != address(0));
474 
475         uint256 tokensAmount = _tokensAmount * 10**uint256(decimals);
476 
477         if(vestingOf[_beneficiary] == 0x0) {
478             TokenVesting vesting = new TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable, owner);
479             vestingOf[_beneficiary] = address(vesting);
480         }
481 
482         require(this.transferFrom(reserveTokensVault, vestingOf[_beneficiary], tokensAmount));
483     }
484 
485     /// @dev vest the sale contributor tokens for 100 days, 1% gradual release with 3 month cliff
486     function vestTokens(address _beneficiary, uint256 _tokensAmount) external onlyOwner {
487         require(_beneficiary != address(0));
488 
489         uint256 tokensAmount = _tokensAmount * 10**uint256(decimals);
490 
491         if(vestingOf[_beneficiary] == 0x0) {
492             TokenVesting vesting = new TokenVesting(_beneficiary, date15Dec2018 + lock90Days, 0, unlock100Days, true, owner);
493             vestingOf[_beneficiary] = address(vesting);
494         }
495 
496         require(this.transferFrom(reserveTokensVault, vestingOf[_beneficiary], tokensAmount));
497         
498     }
499 
500     /// @dev releases vested tokens for the caller's own address
501     function releaseVestedTokens() external {
502         releaseVestedTokensFor(msg.sender);
503     }
504 
505     /// @dev releases vested tokens for the specified address.
506     /// Can be called by anyone for any address.
507     function releaseVestedTokensFor(address _owner) public {
508         TokenVesting(vestingOf[_owner]).release(this);
509     }
510 
511     /// @dev check the vested balance for an address
512     function lockedBalanceOf(address _owner) public view returns (uint256) {
513         return balances[vestingOf[_owner]];
514     }
515 
516     /// @dev check the locked but releaseable balance of an owner
517     function releaseableBalanceOf(address _owner) public view returns (uint256) {
518         if (vestingOf[_owner] == address(0) ) {
519             return 0;
520         } else {
521             return TokenVesting(vestingOf[_owner]).releasableAmount(this);
522         }
523     }
524 
525     /// @dev revoke vested tokens for the specified address.
526     /// Tokens already vested remain in the contract, the rest are returned to the owner.
527     function revokeVestedTokensFor(address _owner) public onlyOwner {
528         TokenVesting(vestingOf[_owner]).revoke(this);
529     }
530 }