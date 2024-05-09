1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/volt/workspaces/convergentcx/billboard/contracts/Convergent_Billboard.sol
6 // flattened :  Wednesday, 21-Nov-18 00:21:30 UTC
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, reverts on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     uint256 c = a * b;
50     require(c / a == b);
51 
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0); // Solidity only automatically asserts when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b <= a);
71     uint256 c = a - b;
72 
73     return c;
74   }
75 
76   /**
77   * @dev Adds two numbers, reverts on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     require(c >= a);
82 
83     return c;
84   }
85 
86   /**
87   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
88   * reverts when dividing by zero.
89   */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0);
92     return a % b;
93   }
94 }
95 
96 contract ERC20Detailed is IERC20 {
97   string private _name;
98   string private _symbol;
99   uint8 private _decimals;
100 
101   constructor(string name, string symbol, uint8 decimals) public {
102     _name = name;
103     _symbol = symbol;
104     _decimals = decimals;
105   }
106 
107   /**
108    * @return the name of the token.
109    */
110   function name() public view returns(string) {
111     return _name;
112   }
113 
114   /**
115    * @return the symbol of the token.
116    */
117   function symbol() public view returns(string) {
118     return _symbol;
119   }
120 
121   /**
122    * @return the number of decimals of the token.
123    */
124   function decimals() public view returns(uint8) {
125     return _decimals;
126   }
127 }
128 
129 contract ERC20 is IERC20 {
130   using SafeMath for uint256;
131 
132   mapping (address => uint256) private _balances;
133 
134   mapping (address => mapping (address => uint256)) private _allowed;
135 
136   uint256 private _totalSupply;
137 
138   /**
139   * @dev Total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return _totalSupply;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address owner) public view returns (uint256) {
151     return _balances[owner];
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param owner address The address which owns the funds.
157    * @param spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(
161     address owner,
162     address spender
163    )
164     public
165     view
166     returns (uint256)
167   {
168     return _allowed[owner][spender];
169   }
170 
171   /**
172   * @dev Transfer token for a specified address
173   * @param to The address to transfer to.
174   * @param value The amount to be transferred.
175   */
176   function transfer(address to, uint256 value) public returns (bool) {
177     _transfer(msg.sender, to, value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param spender The address which will spend the funds.
188    * @param value The amount of tokens to be spent.
189    */
190   function approve(address spender, uint256 value) public returns (bool) {
191     require(spender != address(0));
192 
193     _allowed[msg.sender][spender] = value;
194     emit Approval(msg.sender, spender, value);
195     return true;
196   }
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param from address The address which you want to send tokens from
201    * @param to address The address which you want to transfer to
202    * @param value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(
205     address from,
206     address to,
207     uint256 value
208   )
209     public
210     returns (bool)
211   {
212     require(value <= _allowed[from][msg.sender]);
213 
214     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
215     _transfer(from, to, value);
216     return true;
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed_[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param spender The address which will spend the funds.
226    * @param addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseAllowance(
229     address spender,
230     uint256 addedValue
231   )
232     public
233     returns (bool)
234   {
235     require(spender != address(0));
236 
237     _allowed[msg.sender][spender] = (
238       _allowed[msg.sender][spender].add(addedValue));
239     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
240     return true;
241   }
242 
243   /**
244    * @dev Decrease the amount of tokens that an owner allowed to a spender.
245    * approve should be called when allowed_[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param spender The address which will spend the funds.
250    * @param subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseAllowance(
253     address spender,
254     uint256 subtractedValue
255   )
256     public
257     returns (bool)
258   {
259     require(spender != address(0));
260 
261     _allowed[msg.sender][spender] = (
262       _allowed[msg.sender][spender].sub(subtractedValue));
263     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
264     return true;
265   }
266 
267   /**
268   * @dev Transfer token for a specified addresses
269   * @param from The address to transfer from.
270   * @param to The address to transfer to.
271   * @param value The amount to be transferred.
272   */
273   function _transfer(address from, address to, uint256 value) internal {
274     require(value <= _balances[from]);
275     require(to != address(0));
276 
277     _balances[from] = _balances[from].sub(value);
278     _balances[to] = _balances[to].add(value);
279     emit Transfer(from, to, value);
280   }
281 
282   /**
283    * @dev Internal function that mints an amount of the token and assigns it to
284    * an account. This encapsulates the modification of balances such that the
285    * proper events are emitted.
286    * @param account The account that will receive the created tokens.
287    * @param amount The amount that will be created.
288    */
289   function _mint(address account, uint256 amount) internal {
290     require(account != 0);
291     _totalSupply = _totalSupply.add(amount);
292     _balances[account] = _balances[account].add(amount);
293     emit Transfer(address(0), account, amount);
294   }
295 
296   /**
297    * @dev Internal function that burns an amount of the token of a given
298    * account.
299    * @param account The account whose tokens will be burnt.
300    * @param amount The amount that will be burnt.
301    */
302   function _burn(address account, uint256 amount) internal {
303     require(account != 0);
304     require(amount <= _balances[account]);
305 
306     _totalSupply = _totalSupply.sub(amount);
307     _balances[account] = _balances[account].sub(amount);
308     emit Transfer(account, address(0), amount);
309   }
310 
311   /**
312    * @dev Internal function that burns an amount of the token of a given
313    * account, deducting from the sender's allowance for said account. Uses the
314    * internal burn function.
315    * @param account The account whose tokens will be burnt.
316    * @param amount The amount that will be burnt.
317    */
318   function _burnFrom(address account, uint256 amount) internal {
319     require(amount <= _allowed[account][msg.sender]);
320 
321     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
322     // this function needs to emit an event with the updated approval.
323     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
324       amount);
325     _burn(account, amount);
326   }
327 }
328 
329 contract EthBondingCurvedToken is ERC20Detailed, ERC20 {
330     using SafeMath for uint256;
331 
332     uint256 public poolBalance;
333 
334     event Minted(uint256 amount, uint256 totalCost);
335     event Burned(uint256 amount, uint256 reward);
336 
337     constructor(
338         string name,
339         string symbol,
340         uint8 decimals
341     )   ERC20Detailed(name, symbol, decimals)
342         public
343     {}
344 
345     function priceToMint(uint256 numTokens) public view returns (uint256);
346 
347     function rewardForBurn(uint256 numTokens) public view returns (uint256);
348 
349     function mint(uint256 numTokens) public payable {
350         require(numTokens > 0, "Must purchase an amount greater than zero.");
351 
352         uint256 priceForTokens = priceToMint(numTokens);
353         require(msg.value >= priceForTokens, "Must send requisite amount to purchase.");
354 
355         _mint(msg.sender, numTokens);
356         poolBalance = poolBalance.add(priceForTokens);
357         if (msg.value > priceForTokens) {
358             msg.sender.transfer(msg.value.sub(priceForTokens));
359         }
360 
361         emit Minted(numTokens, priceForTokens);
362     }
363 
364     function burn(uint256 numTokens) public {
365         require(numTokens > 0, "Must burn an amount greater than zero.");
366         require(balanceOf(msg.sender) >= numTokens, "Must have enough tokens to burn.");
367 
368         uint256 ethToReturn = rewardForBurn(numTokens);
369         _burn(msg.sender, numTokens);
370         poolBalance = poolBalance.sub(ethToReturn);
371         msg.sender.transfer(ethToReturn);
372 
373         emit Burned(numTokens, ethToReturn);
374     }
375 }
376 
377 contract EthPolynomialCurvedToken is EthBondingCurvedToken {
378 
379     uint256 public exponent;
380     uint256 public inverseSlope;
381 
382     /// @dev constructor        Initializes the bonding curve
383     /// @param name             The name of the token
384     /// @param decimals         The number of decimals to use
385     /// @param symbol           The symbol of the token
386     /// @param _exponent        The exponent of the curve
387     constructor(
388         string name,
389         string symbol,
390         uint8 decimals,
391         uint256 _exponent,
392         uint256 _inverseSlope
393     )   EthBondingCurvedToken(name, symbol, decimals) 
394         public
395     {
396         exponent = _exponent;
397         inverseSlope = _inverseSlope;
398     }
399 
400     /// @dev        Calculate the integral from 0 to t
401     /// @param t    The number to integrate to
402     function curveIntegral(uint256 t) internal returns (uint256) {
403         uint256 nexp = exponent.add(1);
404         uint256 norm = 10 ** (uint256(decimals()) * uint256(nexp)) - 18;
405         // Calculate integral of t^exponent
406         return
407             (t ** nexp).div(nexp).div(inverseSlope).div(10 ** 18);
408     }
409 
410     function priceToMint(uint256 numTokens) public view returns(uint256) {
411         return curveIntegral(totalSupply().add(numTokens)).sub(poolBalance);
412     }
413 
414     function rewardForBurn(uint256 numTokens) public view returns(uint256) {
415         return poolBalance.sub(curveIntegral(totalSupply().sub(numTokens)));
416     }
417 }
418 
419 contract Convergent_Billboard is EthPolynomialCurvedToken {
420     using SafeMath for uint256;
421 
422     uint256 public cashed;                      // Amount of tokens that have been "cashed out."
423     uint256 public maxTokens;                   // Total amount of Billboard tokens to be sold.
424     uint256 public requiredAmt;                 // Required amount of token per banner change.
425     address public safe;                        // Target to send the funds.
426 
427     event Advertisement(bytes32 what, uint256 indexed when);
428 
429     constructor(uint256 _maxTokens, uint256 _requiredAmt, address _safe)
430         EthPolynomialCurvedToken(
431             "Convergent Billboard Token",
432             "CBT",
433             18,
434             1,
435             1000
436         )
437         public
438     {
439         maxTokens = _maxTokens * 10**18;
440         requiredAmt = _requiredAmt * 10**18;
441         safe = _safe;
442     }
443 
444     /// Overwrite
445     function mint(uint256 numTokens) public payable {
446         uint256 newTotal = totalSupply().add(numTokens);
447         if (newTotal > maxTokens) {
448             super.mint(maxTokens.sub(totalSupply()));
449             // The super.mint() function will not allow 0
450             // as an argument rendering this as sufficient
451             // to enforce a cap of maxTokens.
452         } else {
453             super.mint(numTokens);
454         }
455     }
456 
457     function purchaseAdvertisement(bytes32 _what)
458         public
459         payable
460     {
461         mint(requiredAmt);
462         submit(_what);
463     }
464 
465     function submit(bytes32 _what)
466         public
467     {
468         require(balanceOf(msg.sender) >= requiredAmt);
469 
470         cashed++; // increment cashed counter
471         _transfer(msg.sender, address(0x1337), requiredAmt);
472 
473         uint256 dec = 10**uint256(decimals());
474         uint256 newCliff = curveIntegral(
475             (cashed).mul(dec)
476         );
477         uint256 oldCliff = curveIntegral(
478             (cashed - 1).mul(dec)
479         );
480         uint256 cliffDiff = newCliff.sub(oldCliff);
481         safe.transfer(cliffDiff);
482 
483         emit Advertisement(_what, block.timestamp);
484     }
485 
486     function () public { revert(); }
487 }