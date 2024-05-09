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
216 /**
217  * @title TokenTimelock
218  * @dev TokenTimelock is a token holder contract that will allow a
219  * beneficiary to extract the tokens after a given release time
220  */
221 contract TokenTimelock {
222     using SafeERC20 for ERC20Basic;
223 
224     // ERC20 basic token contract being held
225     ERC20Basic public token;
226 
227     // beneficiary of tokens after they are released
228     address public beneficiary;
229 
230     // timestamp when token release is enabled
231     uint64 public releaseTime;
232 
233     constructor(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
234         require(_releaseTime > uint64(block.timestamp));
235         token = _token;
236         beneficiary = _beneficiary;
237         releaseTime = _releaseTime;
238     }
239 
240     /**
241      * @notice Transfers tokens held by timelock to beneficiary.
242      */
243     function release() public {
244         require(uint64(block.timestamp) >= releaseTime);
245 
246         uint256 amount = token.balanceOf(this);
247         require(amount > 0);
248 
249         token.safeTransfer(beneficiary, amount);
250     }
251 }
252 
253 contract Owned {
254     address public owner;
255 
256     constructor() public {
257         owner = msg.sender;
258     }
259 
260     modifier onlyOwner {
261         require(msg.sender == owner);
262         _;
263     }
264 }
265 
266 /**
267  * @title TokenVault
268  * @dev TokenVault is a token holder contract that will allow a
269  * beneficiary to spend the tokens from some function of a specified ERC20 token
270  */
271 contract TokenVault {
272     using SafeERC20 for ERC20;
273 
274     // ERC20 token contract being held
275     ERC20 public token;
276 
277     constructor(ERC20 _token) public {
278         token = _token;
279     }
280 
281     /**
282      * @notice Allow the token itself to send tokens
283      * using transferFrom().
284      */
285     function fillUpAllowance() public {
286         uint256 amount = token.balanceOf(this);
287         require(amount > 0);
288 
289         token.approve(token, amount);
290     }
291 }
292 
293 /**
294  * @title Burnable Token
295  * @dev Token that can be irreversibly burned (destroyed).
296  */
297 contract BurnableToken is StandardToken {
298 
299     event Burn(address indexed burner, uint256 value);
300 
301     /**
302      * @dev Burns a specific amount of tokens.
303      * @param _value The amount of token to be burned.
304      */
305     function burn(uint256 _value) public {
306         require(_value > 0);
307         require(_value <= balances[msg.sender]);
308         // no need to require value <= totalSupply, since that would imply the
309         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
310 
311         address burner = msg.sender;
312         balances[burner] = balances[burner].sub(_value);
313         totalSupply_ = totalSupply_.sub(_value);
314         emit Burn(burner, _value);
315     }
316 }
317 
318 contract IdealCoinToken is BurnableToken, Owned {
319     string public constant name = "IdealCoin";
320     string public constant symbol = "IDC";
321     uint8 public constant decimals = 18;
322 
323     /// Maximum tokens to be allocated (2.2 billion IDC)
324     uint256 public constant HARD_CAP = 2200000000 * 10**uint256(decimals);
325 
326     /// This address will receive the board of trustees and cold private sale tokens
327     address public boardTokensAddress;
328 
329     /// This address will receive the platform tokens
330     address public platformTokensAddress;
331 
332     /// This address is used to keep the tokens for sale
333     address public saleTokensAddress;
334 
335     /// This address is used to keep the referral and bounty tokens
336     address public referralBountyTokensAddress;
337 
338     /// Date when the Founders, Partners and Advisors can claim their locked tokens
339     uint64 public date01Feb2019 = 1548979200;
340 
341     /// This vault is used to keep the Founders, Advisors and Partners tokens
342     TokenVault public foundersAdvisorsPartnersTokensVault;
343 
344     /// Store the locking contract addresses
345     mapping(address => address) public lockOf;
346 
347     /// when the token sale is closed, the trading will open
348     bool public saleClosed = false;
349 
350     /// Only allowed to execute before the token sale is closed
351     modifier beforeSaleClosed {
352         require(!saleClosed);
353         _;
354     }
355 
356     constructor(address _boardTokensAddress, address _platformTokensAddress,
357                 address _saleTokensAddress, address _referralBountyTokensAddress) public {
358         require(_boardTokensAddress != address(0));
359         require(_platformTokensAddress != address(0));
360         require(_saleTokensAddress != address(0));
361         require(_referralBountyTokensAddress != address(0));
362 
363         boardTokensAddress = _boardTokensAddress;
364         platformTokensAddress = _platformTokensAddress;
365         saleTokensAddress = _saleTokensAddress;
366         referralBountyTokensAddress = _referralBountyTokensAddress;
367 
368         /// Maximum tokens to be sold - 73.05 million IDC
369         uint256 saleTokens = 73050000;
370         createTokens(saleTokens, saleTokensAddress);
371 
372         /// Bounty tokens - 7.95 million IDC
373         uint256 referralBountyTokens = 7950000;
374         createTokens(referralBountyTokens, referralBountyTokensAddress);
375 
376         /// Board and cold private sale tokens - 12 million IDC
377         uint256 boardTokens = 12000000;
378         createTokens(boardTokens, boardTokensAddress);
379 
380         /// Platform tokens - 2.08 billion IDC
381         uint256 platformTokens = 2080000000;
382         createTokens(platformTokens, platformTokensAddress);
383 
384         require(totalSupply_ <= HARD_CAP);
385     }
386 
387     function createLockingTokenVaults() external onlyOwner beforeSaleClosed {
388         /// Founders, Advisors and Partners tokens - 27 million IDC
389         uint256 foundersAdvisorsPartnersTokens = 27000000;
390         foundersAdvisorsPartnersTokensVault = createTokenVault(foundersAdvisorsPartnersTokens);
391 
392         require(totalSupply_ <= HARD_CAP);
393     }
394 
395     /// @dev Create a TokenVault and fill with the specified newly minted tokens
396     function createTokenVault(uint256 tokens) internal onlyOwner returns (TokenVault) {
397         TokenVault tokenVault = new TokenVault(ERC20(this));
398         createTokens(tokens, tokenVault);
399         tokenVault.fillUpAllowance();
400         return tokenVault;
401     }
402 
403     // @dev create specified number of tokens and transfer to destination
404     function createTokens(uint256 _tokens, address _destination) internal onlyOwner {
405         uint256 tokens = _tokens * 10**uint256(decimals);
406         totalSupply_ = totalSupply_.add(tokens);
407         balances[_destination] = tokens;
408         emit Transfer(0x0, _destination, tokens);
409 
410         require(totalSupply_ <= HARD_CAP);
411    }
412 
413     /// @dev lock tokens for a single whole period
414     function lockTokens(address _beneficiary, uint256 _tokensAmount) external onlyOwner {
415         require(lockOf[_beneficiary] == 0x0);
416         require(_beneficiary != address(0));
417 
418         TokenTimelock lock = new TokenTimelock(ERC20(this), _beneficiary, date01Feb2019);
419         lockOf[_beneficiary] = address(lock);
420         require(this.transferFrom(foundersAdvisorsPartnersTokensVault, lock, _tokensAmount));
421     }
422 
423     /// @dev releases vested tokens for the caller's own address
424     function releaseLockedTokens() external {
425         releaseLockedTokensFor(msg.sender);
426     }
427 
428     /// @dev releases vested tokens for the specified address.
429     /// Can be called by any account for any address.
430     function releaseLockedTokensFor(address _owner) public {
431         TokenTimelock(lockOf[_owner]).release();
432     }
433 
434     /// @dev check the locked balance for an address
435     function lockedBalanceOf(address _owner) public view returns (uint256) {
436         return balances[lockOf[_owner]];
437     }
438 
439     /// @dev will open the trading for everyone
440     function closeSale() external onlyOwner beforeSaleClosed {
441         /// The unsold and unallocated bounty tokens are allocated to the platform tokens
442 
443         uint256 unsoldTokens = balances[saleTokensAddress];
444         balances[platformTokensAddress] = balances[platformTokensAddress].add(unsoldTokens);
445         balances[saleTokensAddress] = 0;
446         emit Transfer(saleTokensAddress, platformTokensAddress, unsoldTokens);
447 
448         uint256 unallocatedBountyTokens = balances[referralBountyTokensAddress];
449         balances[platformTokensAddress] = balances[platformTokensAddress].add(unallocatedBountyTokens);
450         balances[referralBountyTokensAddress] = 0;
451         emit Transfer(referralBountyTokensAddress, platformTokensAddress, unallocatedBountyTokens);
452 
453         saleClosed = true;
454     }
455 
456     /// @dev Trading limited - requires the token sale to have closed
457     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
458         if(saleClosed || msg.sender == address(this) || msg.sender == owner) {
459             return super.transferFrom(_from, _to, _value);
460         }
461         return false;
462     }
463 
464     /// @dev Trading limited - requires the token sale to have closed
465     function transfer(address _to, uint256 _value) public returns (bool) {
466         if(saleClosed || msg.sender == saleTokensAddress || msg.sender == referralBountyTokensAddress) {
467             return super.transfer(_to, _value);
468         }
469         return false;
470     }
471 }