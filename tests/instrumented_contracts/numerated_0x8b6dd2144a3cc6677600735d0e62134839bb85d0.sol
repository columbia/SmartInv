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
236   using SafeMath for uint256;
237   using SafeERC20 for ERC20Basic;
238 
239   event Released(uint256 amount);
240   event Revoked();
241 
242   // beneficiary of tokens after they are released
243   address public beneficiary;
244 
245   uint256 public cliff;
246   uint256 public start;
247   uint256 public duration;
248 
249   bool public revocable;
250 
251   mapping (address => uint256) public released;
252   mapping (address => bool) public revoked;
253 
254   /**
255    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
256    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
257    * of the balance will have vested.
258    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
259    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
260    * @param _start the time (as Unix time) at which point vesting starts
261    * @param _duration duration in seconds of the period in which the tokens will vest
262    * @param _revocable whether the vesting is revocable or not
263    */
264   constructor(
265     address _beneficiary,
266     uint256 _start,
267     uint256 _cliff,
268     uint256 _duration,
269     bool _revocable
270   )
271     public
272   {
273     require(_beneficiary != address(0));
274     require(_cliff <= _duration);
275 
276     beneficiary = _beneficiary;
277     revocable = _revocable;
278     duration = _duration;
279     cliff = _start.add(_cliff);
280     start = _start;
281   }
282 
283   /**
284    * @notice Transfers vested tokens to beneficiary.
285    * @param token ERC20 token which is being vested
286    */
287   function release(ERC20Basic token) public {
288     uint256 unreleased = releasableAmount(token);
289 
290     require(unreleased > 0);
291 
292     released[token] = released[token].add(unreleased);
293 
294     token.safeTransfer(beneficiary, unreleased);
295 
296     emit Released(unreleased);
297   }
298 
299   /**
300    * @notice Allows the owner to revoke the vesting. Tokens already vested
301    * remain in the contract, the rest are returned to the owner.
302    * @param token ERC20 token which is being vested
303    */
304   function revoke(ERC20Basic token) public onlyOwner {
305     require(revocable);
306     require(!revoked[token]);
307 
308     uint256 balance = token.balanceOf(this);
309 
310     uint256 unreleased = releasableAmount(token);
311     uint256 refund = balance.sub(unreleased);
312 
313     revoked[token] = true;
314 
315     token.safeTransfer(owner, refund);
316 
317     emit Revoked();
318   }
319 
320   /**
321    * @dev Calculates the amount that has already vested but hasn't been released yet.
322    * @param token ERC20 token which is being vested
323    */
324   function releasableAmount(ERC20Basic token) public view returns (uint256) {
325     return vestedAmount(token).sub(released[token]);
326   }
327 
328   /**
329    * @dev Calculates the amount that has already vested.
330    * @param token ERC20 token which is being vested
331    */
332   function vestedAmount(ERC20Basic token) public view returns (uint256) {
333     uint256 currentBalance = token.balanceOf(this);
334     uint256 totalBalance = currentBalance.add(released[token]);
335 
336     if (block.timestamp < cliff) {
337       return 0;
338     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
339       return totalBalance;
340     } else {
341       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
342     }
343   }
344 }
345 
346 /**
347  * @title TokenVault
348  * @dev TokenVault is a token holder contract that will allow a
349  * beneficiary to spend the tokens from some function of a specified ERC20 token
350  */
351 contract TokenVault {
352     using SafeERC20 for ERC20;
353 
354     // ERC20 token contract being held
355     ERC20 public token;
356 
357     constructor(ERC20 _token) public {
358         token = _token;
359     }
360 
361     /**
362      * @notice Allow the token itself to send tokens
363      * using transferFrom().
364      */
365     function fillUpAllowance() public {
366         uint256 amount = token.balanceOf(this);
367         require(amount > 0);
368 
369         token.approve(token, amount);
370     }
371 }
372 
373 /**
374  * @title Burnable Token
375  * @dev Token that can be irreversibly burned (destroyed).
376  */
377 contract BurnableToken is StandardToken {
378 
379     event Burn(address indexed burner, uint256 value);
380 
381     /**
382      * @dev Burns a specific amount of tokens.
383      * @param _value The amount of token to be burned.
384      */
385     function burn(uint256 _value) public {
386         require(_value > 0);
387         require(_value <= balances[msg.sender]);
388         // no need to require value <= totalSupply, since that would imply the
389         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
390 
391         address burner = msg.sender;
392         balances[burner] = balances[burner].sub(_value);
393         totalSupply_ = totalSupply_.sub(_value);
394         emit Burn(burner, _value);
395     }
396 }
397 
398 contract Phoneum is BurnableToken, Owned {
399     string public constant name = "Phoneum";
400     string public constant symbol = "PHM";
401     uint8 public constant decimals = 2;
402 
403     /// Maximum tokens to be allocated (3.5 billion PHM)
404     uint256 public constant HARD_CAP = 3500000000 * 10**uint256(decimals);
405 
406     /// This address will be used to distribute the team, advisors and reserve tokens
407     address public teamAdvisorsReserveTokensAddress;
408 
409     /// This vault is used to keep the Founders, Advisors and Partners tokens
410     TokenVault public saleTokensVault;
411 
412     /// Date when the vesting for regular users starts
413     uint64 public date01Oct2018 = 1538352000;
414 
415     /// Store the vesting contract addresses for each sale contributor
416     mapping(address => address) public vestingOf;
417 
418     constructor(address _teamAdvisorsReserveTokensAddress) public {
419         require(_teamAdvisorsReserveTokensAddress != address(0));
420 
421         teamAdvisorsReserveTokensAddress = _teamAdvisorsReserveTokensAddress;
422 
423         /// Maximum tokens to be sold - 1,564,265,000 PHM
424         uint256 teamAdvisorsReserveTokens = 1564265000;
425         createTokens(teamAdvisorsReserveTokens, teamAdvisorsReserveTokensAddress);
426 
427         require(totalSupply_ <= HARD_CAP);
428     }
429 
430     function createSaleTokensVault() external onlyOwner {
431         require(saleTokensVault == address(0));
432 
433         /// Sale tokens - 1,935,735,000 PHM
434         uint256 saleTokens = 1935735000;
435         saleTokensVault = createTokenVault(saleTokens);
436 
437         require(totalSupply_ <= HARD_CAP);
438     }
439 
440     /// @dev Create a TokenVault and fill with the specified newly minted tokens
441     function createTokenVault(uint256 tokens) internal onlyOwner returns (TokenVault) {
442         TokenVault tokenVault = new TokenVault(ERC20(this));
443         createTokens(tokens, tokenVault);
444         tokenVault.fillUpAllowance();
445         return tokenVault;
446     }
447 
448     // @dev create specified number of tokens and transfer to destination
449     function createTokens(uint256 _tokens, address _destination) internal onlyOwner {
450         uint256 tokens = _tokens * 10**uint256(decimals);
451         totalSupply_ = totalSupply_.add(tokens);
452         balances[_destination] = tokens;
453         emit Transfer(0x0, _destination, tokens);
454 
455         require(totalSupply_ <= HARD_CAP);
456    }
457 
458     /// @dev vest the sale contributor tokens for 10 months, 10% gradual release with 1 month cliff
459     function vestTokens(address _beneficiary, uint256 _tokensAmount) external onlyOwner {
460         require(_beneficiary != address(0));
461 
462         if(vestingOf[_beneficiary] == 0x0) {
463             TokenVesting vesting = new TokenVesting(_beneficiary, date01Oct2018, 31 days, 304 days, false);
464             vestingOf[_beneficiary] = address(vesting);
465         }
466 
467         require(this.transferFrom(saleTokensVault, vestingOf[_beneficiary], _tokensAmount));
468     }
469 
470     /// @dev releases vested tokens for the caller's own address
471     function releaseVestedTokens() external {
472         releaseVestedTokensFor(msg.sender);
473     }
474 
475     /// @dev releases vested tokens for the specified address.
476     /// Can be called by anyone for any address.
477     function releaseVestedTokensFor(address _owner) public {
478         TokenVesting(vestingOf[_owner]).release(this);
479     }
480 
481     /// @dev check the vested balance for an address
482     function lockedBalanceOf(address _owner) public view returns (uint256) {
483         return balances[vestingOf[_owner]];
484     }
485 
486     /// @dev check the locked but releaseable balance of an owner
487     function releaseableBalanceOf(address _owner) public view returns (uint256) {
488         return TokenVesting(vestingOf[_owner]).releasableAmount(this);
489     }
490 }