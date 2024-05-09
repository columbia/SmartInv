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
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     uint256 totalSupply_;
73 
74     /**
75     * @dev total number of tokens in existence
76     */
77     function totalSupply() public view returns (uint256) {
78         return totalSupply_;
79     }
80 
81     /**
82     * @dev transfer token for a specified address
83     * @param _to The address to transfer to.
84     * @param _value The amount to be transferred.
85     */
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88         require(_value <= balances[msg.sender]);
89 
90         // SafeMath.sub will throw if there is not enough balance.
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         emit Transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     /**
98     * @dev Gets the balance of the specified address.
99     * @param _owner The address to query the the balance of.
100     * @return An uint256 representing the amount owned by the passed address.
101     */
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113     function transferFrom(address from, address to, uint256 value) public returns (bool);
114     function approve(address spender, uint256 value) public returns (bool);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127     mapping (address => mapping (address => uint256)) internal allowed;
128 
129     /**
130      * @dev Transfer tokens from one address to another
131      * @param _from address The address which you want to send tokens from
132      * @param _to address The address which you want to transfer to
133      * @param _value uint256 the amount of tokens to be transferred
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[_from]);
138         require(_value <= allowed[_from][msg.sender]);
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         emit Transfer(_from, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      *
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param _spender The address which will spend the funds.
155      * @param _value The amount of tokens to be spent.
156      */
157     function approve(address _spender, uint256 _value) public returns (bool) {
158         allowed[msg.sender][_spender] = _value;
159         emit Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     /**
164      * @dev Function to check the amount of tokens that an owner allowed to a spender.
165      * @param _owner address The address which owns the funds.
166      * @param _spender address The address which will spend the funds.
167      * @return A uint256 specifying the amount of tokens still available for the spender.
168      */
169     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174      * approve should be called when allowed[_spender] == 0. To increment
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      */
179     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
186         uint oldValue = allowed[msg.sender][_spender];
187         if (_subtractedValue > oldValue) {
188             allowed[msg.sender][_spender] = 0;
189         } else {
190             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191         }
192         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 }
196 
197 /**
198  * @title SafeERC20
199  * @dev Wrappers around ERC20 operations that throw on failure.
200  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
201  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
202  */
203 library SafeERC20 {
204     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
205         assert(token.transfer(to, value));
206     }
207 
208     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
209         assert(token.transferFrom(from, to, value));
210     }
211 
212     function safeApprove(ERC20 token, address spender, uint256 value) internal {
213         assert(token.approve(spender, value));
214     }
215 }
216 
217 contract Owned {
218     address public owner;
219 
220     constructor() public {
221         owner = msg.sender;
222     }
223 
224     modifier onlyOwner {
225         require(msg.sender == owner);
226         _;
227     }
228 }
229 
230 /**
231  * @title TokenVesting
232  * @dev A token holder contract that can release its token balance gradually like a
233  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
234  * owner.
235  */
236 contract TokenVesting is Owned {
237   using SafeMath for uint256;
238   using SafeERC20 for ERC20Basic;
239 
240   event Released(uint256 amount);
241   event Revoked();
242 
243   // beneficiary of tokens after they are released
244   address public beneficiary;
245 
246   uint256 public cliff;
247   uint256 public start;
248   uint256 public duration;
249 
250   bool public revocable;
251 
252   mapping (address => uint256) public released;
253   mapping (address => bool) public revoked;
254 
255   /**
256    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
257    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
258    * of the balance will have vested.
259    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
260    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
261    * @param _start the time (as Unix time) at which point vesting starts 
262    * @param _duration duration in seconds of the period in which the tokens will vest
263    * @param _revocable whether the vesting is revocable or not
264    */
265   constructor(
266     address _beneficiary,
267     uint256 _start,
268     uint256 _cliff,
269     uint256 _duration,
270     bool _revocable
271   )
272     public
273   {
274     require(_beneficiary != address(0));
275     require(_cliff <= _duration);
276 
277     beneficiary = _beneficiary;
278     revocable = _revocable;
279     duration = _duration;
280     cliff = _start.add(_cliff);
281     start = _start;
282   }
283 
284   /**
285    * @notice Transfers vested tokens to beneficiary.
286    * @param token ERC20 token which is being vested
287    */
288   function release(ERC20Basic token) public {
289     uint256 unreleased = releasableAmount(token);
290 
291     require(unreleased > 0);
292 
293     released[token] = released[token].add(unreleased);
294 
295     token.safeTransfer(beneficiary, unreleased);
296 
297     emit Released(unreleased);
298   }
299 
300   /**
301    * @notice Allows the owner to revoke the vesting. Tokens already vested
302    * remain in the contract, the rest are returned to the owner.
303    * @param token ERC20 token which is being vested
304    */
305   function revoke(ERC20Basic token) public onlyOwner {
306     require(revocable);
307     require(!revoked[token]);
308 
309     uint256 balance = token.balanceOf(this);
310 
311     uint256 unreleased = releasableAmount(token);
312     uint256 refund = balance.sub(unreleased);
313 
314     revoked[token] = true;
315 
316     token.safeTransfer(owner, refund);
317 
318     emit Revoked();
319   }
320 
321   /**
322    * @dev Calculates the amount that has already vested but hasn't been released yet.
323    * @param token ERC20 token which is being vested
324    */
325   function releasableAmount(ERC20Basic token) public view returns (uint256) {
326     return vestedAmount(token).sub(released[token]);
327   }
328 
329   /**
330    * @dev Calculates the amount that has already vested.
331    * @param token ERC20 token which is being vested
332    */
333   function vestedAmount(ERC20Basic token) public view returns (uint256) {
334     uint256 currentBalance = token.balanceOf(this);
335     uint256 totalBalance = currentBalance.add(released[token]);
336 
337     if (block.timestamp < cliff) {
338       return 0;
339     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
340       return totalBalance;
341     } else {
342       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
343     }
344   }
345 }
346 
347 /**
348  * @title Burnable Token
349  * @dev Token that can be irreversibly burned (destroyed).
350  */
351 contract BurnableToken is BasicToken {
352 
353   event Burn(address indexed burner, uint256 value);
354 
355   /**
356    * @dev Burns a specific amount of tokens.
357    * @param _value The amount of token to be burned.
358    */
359   function burn(uint256 _value) public {
360     _burn(msg.sender, _value);
361   }
362 
363   function _burn(address _who, uint256 _value) internal {
364     require(_value <= balances[_who]);
365     // no need to require value <= totalSupply, since that would imply the
366     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
367 
368     balances[_who] = balances[_who].sub(_value);
369     totalSupply_ = totalSupply_.sub(_value);
370     emit Burn(_who, _value);
371     emit Transfer(_who, address(0), _value);
372   }
373 }
374 
375 contract AgateToken is BurnableToken, StandardToken, Owned {
376     string public constant name = "AGATE";
377     string public constant symbol = "AGT";
378     uint8 public constant decimals = 18;
379 
380     /// Maximum tokens to be allocated (490 million AGT)
381     uint256 public constant HARD_CAP = 490000000 * 10**uint256(decimals);
382 
383     /// This address is used to keep the tokens for sale
384     address public saleTokensAddress;
385 
386     /// This address is used to keep the bounty and airdrop tokens
387     address public bountyTokensAddress;
388 
389     /// This address will receive the team tokens when they are released from the vesting
390     address public teamTokensAddress;
391     
392     /// This address is used to keep the vested team tokens
393     TokenVesting public teamTokensVesting;
394 
395     /// This address is used to keep the advisors tokens
396     address public advisorsTokensAddress;
397 
398     /// This address is used to keep the reserve tokens
399     address public reserveTokensAddress;
400 
401     /// when the token sale is closed, the unsold tokens are burnt
402     bool public saleClosed = false;
403 
404     /// open the trading for everyone
405     bool public tradingOpen = false;
406 
407     /// the team tokens are vested for an year after the date 15 Nov 2018 
408     uint64 public constant date15Nov2018 = 1542240000;
409 
410     /// Only allowed to execute before the token sale is closed
411     modifier beforeSaleClosed {
412         require(!saleClosed);
413         _;
414     }
415 
416     constructor(address _teamTokensAddress, address _reserveTokensAddress, 
417                 address _advisorsTokensAddress, address _saleTokensAddress, address _bountyTokensAddress) public {
418         require(_teamTokensAddress != address(0));
419         require(_reserveTokensAddress != address(0));
420         require(_advisorsTokensAddress != address(0));
421         require(_saleTokensAddress != address(0));
422         require(_bountyTokensAddress != address(0));
423 
424         teamTokensAddress = _teamTokensAddress;
425         reserveTokensAddress = _reserveTokensAddress;
426         advisorsTokensAddress = _advisorsTokensAddress;
427         saleTokensAddress = _saleTokensAddress;
428         bountyTokensAddress = _bountyTokensAddress;
429 
430         /// Maximum tokens to be allocated on the sale
431         /// 318.5M AGT (65% of 490M total supply)
432         uint256 saleTokens = 318500000 * 10**uint256(decimals);
433         totalSupply_ = saleTokens;
434         balances[saleTokensAddress] = saleTokens;
435         emit Transfer(address(0), saleTokensAddress, balances[saleTokensAddress]);
436  
437         /// Team tokens - 49M AGT (10% of total supply) - vested for an year since 15 Nov 2018
438         uint256 teamTokens = 49000000 * 10**uint256(decimals);
439         totalSupply_ = totalSupply_.add(teamTokens);
440         teamTokensVesting = new TokenVesting(teamTokensAddress, date15Nov2018, 92 days, 365 days, false);
441         balances[address(teamTokensVesting)] = teamTokens;
442         emit Transfer(address(0), address(teamTokensVesting), balances[address(teamTokensVesting)]);
443  
444         /// Bounty and airdrop tokens - 24.5M AGT (5% of total supply)
445         uint256 bountyTokens = 24500000 * 10**uint256(decimals);
446         totalSupply_ = totalSupply_.add(bountyTokens);
447         balances[bountyTokensAddress] = bountyTokens;
448         emit Transfer(address(0), bountyTokensAddress, balances[bountyTokensAddress]);
449  
450         /// Advisors tokens - 24.5M AGT (5% of total supply)
451         uint256 advisorsTokens = 24500000 * 10**uint256(decimals);
452         totalSupply_ = totalSupply_.add(advisorsTokens);
453         balances[advisorsTokensAddress] = advisorsTokens;
454         emit Transfer(address(0), advisorsTokensAddress, balances[advisorsTokensAddress]);
455 
456         /// Reserved tokens - 73.5M AGT (15% of total supply)
457         uint256 reserveTokens = 73500000 * 10**uint256(decimals);
458         totalSupply_ = totalSupply_.add(reserveTokens);
459         balances[reserveTokensAddress] = reserveTokens;
460         emit Transfer(address(0), reserveTokensAddress, balances[reserveTokensAddress]);
461 
462         require(totalSupply_ <= HARD_CAP);
463     }
464 
465     /// @dev reallocates the unsold and leftover bounty tokens
466     function closeSale() external onlyOwner beforeSaleClosed {
467         /// The unsold tokens are burnt
468 
469         _burn(saleTokensAddress, balances[saleTokensAddress]);
470         saleClosed = true;
471     }
472 
473     /// @dev opens the trading for everyone
474     function openTrading() external onlyOwner {
475         tradingOpen = true;
476     }
477 
478     /// @dev Trading limited
479     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
480         if(tradingOpen) {
481             return super.transferFrom(_from, _to, _value);
482         }
483         return false;
484     }
485 
486     /// @dev Trading limited
487     function transfer(address _to, uint256 _value) public returns (bool) {
488         if(tradingOpen || msg.sender == saleTokensAddress || msg.sender == bountyTokensAddress
489                         || msg.sender == advisorsTokensAddress) {
490             return super.transfer(_to, _value);
491         }
492         return false;
493     }
494 }