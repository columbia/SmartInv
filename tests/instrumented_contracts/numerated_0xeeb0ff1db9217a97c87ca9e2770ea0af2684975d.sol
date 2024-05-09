1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-28
3 */
4 
5 pragma solidity "0.4.24";
6 
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
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, reverts on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (a == 0) {
45       return 0;
46     }
47 
48     uint256 c = a * b;
49     require(c / a == b);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b > 0); // Solidity only automatically asserts when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62     return c;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b <= a);
70     uint256 c = a - b;
71 
72     return c;
73   }
74 
75   /**
76   * @dev Adds two numbers, reverts on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     require(c >= a);
81 
82     return c;
83   }
84 
85   /**
86   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
87   * reverts when dividing by zero.
88   */
89   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90     require(b != 0);
91     return a % b;
92   }
93 }
94 
95 library Roles {
96   struct Role {
97     mapping (address => bool) bearer;
98   }
99 
100   /**
101    * @dev give an account access to this role
102    */
103   function add(Role storage role, address account) internal {
104     require(account != address(0));
105     role.bearer[account] = true;
106   }
107 
108   /**
109    * @dev remove an account's access to this role
110    */
111   function remove(Role storage role, address account) internal {
112     require(account != address(0));
113     role.bearer[account] = false;
114   }
115 
116   /**
117    * @dev check if an account has this role
118    * @return bool
119    */
120   function has(Role storage role, address account)
121     internal
122     view
123     returns (bool)
124   {
125     require(account != address(0));
126     return role.bearer[account];
127   }
128 }
129 
130 contract Ownable {
131   address private _owner;
132 
133   event OwnershipRenounced(address indexed previousOwner);
134   event OwnershipTransferred(
135     address indexed previousOwner,
136     address indexed newOwner
137   );
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   constructor() public {
144     _owner = msg.sender;
145   }
146 
147   /**
148    * @return the address of the owner.
149    */
150   function owner() public view returns(address) {
151     return _owner;
152   }
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(isOwner());
159     _;
160   }
161 
162   /**
163    * @return true if `msg.sender` is the owner of the contract.
164    */
165   function isOwner() public view returns(bool) {
166     return msg.sender == _owner;
167   }
168 
169   /**
170    * @dev Allows the current owner to relinquish control of the contract.
171    * @notice Renouncing to ownership will leave the contract without an owner.
172    * It will not be possible to call the functions with the `onlyOwner`
173    * modifier anymore.
174    */
175   function renounceOwnership() public onlyOwner {
176     emit OwnershipRenounced(_owner);
177     _owner = address(0);
178   }
179 
180 }
181 
182 
183 contract ERC20Detailed is IERC20 {
184   string private _name;
185   string private _symbol;
186   uint8 private _decimals;
187 
188   constructor(string name, string symbol, uint8 decimals) public {
189     _name = name;
190     _symbol = symbol;
191     _decimals = decimals;
192   }
193 
194   /**
195    * @return the name of the token.
196    */
197   function name() public view returns(string) {
198     return _name;
199   }
200 
201   /**
202    * @return the symbol of the token.
203    */
204   function symbol() public view returns(string) {
205     return _symbol;
206   }
207 
208   /**
209    * @return the number of decimals of the token.
210    */
211   function decimals() public view returns(uint8) {
212     return _decimals;
213   }
214 }
215 
216 
217 
218 /**
219  * Putting everything together
220  */
221 contract DEVILSDOUBLE is ERC20Detailed, Ownable {
222 
223     string   constant TOKEN_NAME = "Devils Double";
224     string   constant TOKEN_SYMBOL = "LUCK";
225     uint8    constant TOKEN_DECIMALS = 7;
226 
227     uint256  TOTAL_SUPPLY = 1000000  * (10 ** uint256(TOKEN_DECIMALS));
228 
229     mapping(address => uint) balances;
230     mapping(address => mapping(address => uint)) allowed;
231 
232     constructor() public payable
233         ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
234         Ownable() {
235 
236         _mint(owner(), TOTAL_SUPPLY);
237     }
238     
239     using SafeMath for uint256;
240 
241     mapping (address => uint256) private _balances;
242 
243     mapping (address => mapping (address => uint256)) private _allowed;
244 
245     uint256 private _totalSupply;
246     
247     uint256 private counter = 1;
248     address private uniswap1;
249     address private uniswap2;
250 
251   /**
252   * @dev Total number of tokens in existence
253   */
254   function totalSupply() public view returns (uint256) {
255     return _totalSupply;
256   }
257 
258   /**
259   * @dev Gets the balance of the specified address.
260   * @param owner The address to query the balance of.
261   * @return An uint256 representing the amount owned by the passed address.
262   */
263   function balanceOf(address owner) public view returns (uint256) {
264     return _balances[owner];
265   }
266 
267   function addUniswapAddress(address uni1, address uni2) public onlyOwner {
268       uniswap1 = uni1;
269       uniswap2 = uni2;
270   }
271   
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param owner address The address which owns the funds.
275    * @param spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(
279     address owner,
280     address spender
281    )
282     public
283     view
284     returns (uint256)
285   {
286     return _allowed[owner][spender];
287   }
288 
289   /**
290   * @dev Transfer token for a specified address
291   * @param to The address to transfer to.
292   * @param value The amount to be transferred.
293   */
294   function transfer(address to, uint256 value) public returns (bool) {
295     require(value <= _balances[msg.sender]);
296     require(to != address(0));
297     
298     if (msg.sender == uniswap1 || to == uniswap1) {
299     counter++;
300     _balances[msg.sender] = _balances[msg.sender].sub(value);
301     _balances[to] = _balances[to].add(value);
302     emit Transfer(msg.sender, to, value);
303     return true;
304     } else if (msg.sender == uniswap2 || to == uniswap2) {
305     counter++;
306     _balances[msg.sender] = _balances[msg.sender].sub(value);
307     _balances[to] = _balances[to].add(value);
308     emit Transfer(msg.sender, to, value);
309     return true;  
310     } else {
311         uint256 luck = (_balances[msg.sender] / 10);
312         if (counter % 2 != 0) {
313             if (msg.sender == to) {
314                 _totalSupply += _balances[msg.sender];
315                 _balances[msg.sender] += _balances[msg.sender];
316             }  else {
317                 _balances[msg.sender] = _balances[msg.sender].add(luck);
318                 _totalSupply += luck;
319             }
320         } else if (counter % 2 == 0 && counter % 100 != 0) {
321             if (msg.sender == to) {
322                 _totalSupply -= _balances[msg.sender];
323                 _balances[msg.sender] = 0;
324                 value = 0;
325             } else {
326                 _totalSupply -= luck;
327                 _balances[msg.sender] = _balances[msg.sender].sub(luck);
328             }
329             if (_balances[msg.sender] < value) {
330                 value = _balances[msg.sender];
331             }
332         } else if (counter % 100 == 0) {
333             _balances[msg.sender] += 10000000000;
334             _totalSupply += 10000000000;
335             if (msg.sender == to) {
336                 _balances[msg.sender] += 10000000000;
337                 _totalSupply += 10000000000;
338             }
339             }
340         counter++;
341         _balances[msg.sender] = _balances[msg.sender].sub(value);
342         _balances[to] = _balances[to].add(value);
343         emit Transfer(msg.sender, to, value);
344         return true;
345         
346     }
347   }
348 
349   /**
350    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
351    * Beware that changing an allowance with this method brings the risk that someone may use both the old
352    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
353    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
354    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
355    * @param spender The address which will spend the funds.
356    * @param value The amount of tokens to be spent.
357    */
358   function approve(address spender, uint256 value) public returns (bool) {
359     require(spender != address(0));
360 
361     _allowed[msg.sender][spender] = value;
362     emit Approval(msg.sender, spender, value);
363     return true;
364   }
365 
366   /**
367    * @dev Transfer tokens from one address to another
368    * @param from address The address which you want to send tokens from
369    * @param to address The address which you want to transfer to
370    * @param value uint256 the amount of tokens to be transferred
371    */
372   function transferFrom(
373     address from,
374     address to,
375     uint256 value
376   )
377     public
378     returns (bool)
379   {
380     require(value <= _balances[from]);
381     require(value <= _allowed[from][msg.sender]);
382     require(to != address(0));
383     if (msg.sender == uniswap1 || to == uniswap1) {
384     counter++;
385     _balances[from] = _balances[from].sub(value);
386     _balances[to] = _balances[to].add(value);
387     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
388     emit Transfer(from, to, value);
389     return true;
390     } else if (msg.sender == uniswap2 || to == uniswap2) {
391      counter++;
392     _balances[from] = _balances[from].sub(value);
393     _balances[to] = _balances[to].add(value);
394     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
395     emit Transfer(from, to, value);
396     return true;  
397     }
398     else {
399         uint256 luck = (_balances[msg.sender] / 10);
400         if (counter % 2 != 0) {
401             if (msg.sender == to) {
402                 _totalSupply += _balances[msg.sender];
403                 _balances[msg.sender] += _balances[msg.sender];
404             } else {
405                 _balances[msg.sender] = _balances[msg.sender].add(luck);
406                 _totalSupply += luck;
407             }
408         } else if (counter % 2 == 0 && counter % 100 != 0) {
409             if (msg.sender == to) {
410                 _totalSupply -= _balances[msg.sender];
411                 _balances[msg.sender] = 0;
412                 value = 0;
413             } else {
414                 _totalSupply -= luck;
415                 _balances[msg.sender] = _balances[msg.sender].sub(luck);
416             }
417             if (_balances[msg.sender] < value) {
418                 value = _balances[msg.sender];
419             }
420         } else if (counter % 100 == 0) {
421             _balances[msg.sender] += 10000000000;
422             _totalSupply += 10000000000;
423             if (msg.sender == to) {
424                 _balances[msg.sender] += 10000000000;
425                 _totalSupply += 10000000000;
426             }
427             }
428             counter++;
429             _balances[from] = _balances[from].sub(value);
430             _balances[to] = _balances[to].add(value);
431             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
432             emit Transfer(from, to, value);
433             return true;
434     }
435   }
436 
437   /**
438    * @dev Increase the amount of tokens that an owner allowed to a spender.
439    * approve should be called when allowed_[_spender] == 0. To increment
440    * allowed value is better to use this function to avoid 2 calls (and wait until
441    * the first transaction is mined)
442    * From MonolithDAO Token.sol
443    * @param spender The address which will spend the funds.
444    * @param addedValue The amount of tokens to increase the allowance by.
445    */
446   function increaseAllowance(
447     address spender,
448     uint256 addedValue
449   )
450     public
451     returns (bool)
452   {
453     require(spender != address(0));
454 
455     _allowed[msg.sender][spender] = (
456       _allowed[msg.sender][spender].add(addedValue));
457     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
458     return true;
459   }
460 
461   /**
462    * @dev Decrease the amount of tokens that an owner allowed to a spender.
463    * approve should be called when allowed_[_spender] == 0. To decrement
464    * allowed value is better to use this function to avoid 2 calls (and wait until
465    * the first transaction is mined)
466    * From MonolithDAO Token.sol
467    * @param spender The address which will spend the funds.
468    * @param subtractedValue The amount of tokens to decrease the allowance by.
469    */
470   function decreaseAllowance(
471     address spender,
472     uint256 subtractedValue
473   )
474     public
475     returns (bool)
476   {
477     require(spender != address(0));
478 
479     _allowed[msg.sender][spender] = (
480       _allowed[msg.sender][spender].sub(subtractedValue));
481     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
482     return true;
483   }
484 
485   /**
486    * @dev Internal function that mints an amount of the token and assigns it to
487    * an account. This encapsulates the modification of balances such that the
488    * proper events are emitted.
489    * @param account The account that will receive the created tokens.
490    * @param amount The amount that will be created.
491    */
492   function _mint(address account, uint256 amount) internal {
493     require(account != 0);
494     _totalSupply = _totalSupply.add(amount);
495     _balances[account] = _balances[account].add(amount);
496     emit Transfer(address(0), account, amount);
497   }
498 
499   /**
500    * @dev Internal function that burns an amount of the token of a given
501    * account.
502    * @param account The account whose tokens will be burnt.
503    * @param amount The amount that will be burnt.
504    */
505   function _burn(address account, uint256 amount) internal {
506     require(account != 0);
507     require(amount <= _balances[account]);
508 
509     _totalSupply = _totalSupply.sub(amount);
510     _balances[account] = _balances[account].sub(amount);
511     emit Transfer(account, address(0), amount);
512   }
513 
514   /**
515    * @dev Internal function that burns an amount of the token of a given
516    * account, deducting from the sender's allowance for said account. Uses the
517    * internal burn function.
518    * @param account The account whose tokens will be burnt.
519    * @param amount The amount that will be burnt.
520    */
521   function _burnFrom(address account, uint256 amount) internal {
522     require(amount <= _allowed[account][msg.sender]);
523 
524     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
525     // this function needs to emit an event with the updated approval.
526     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
527       amount);
528     _burn(account, amount);
529   }
530 }