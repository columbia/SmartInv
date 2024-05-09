1 pragma solidity "0.4.24";
2 
3 interface Icollectible {
4 
5   function timeofcontract() external view returns (uint256);
6   
7   function totalSupply() external view returns (uint256);
8 
9   function balanceOf(address who) external view returns (uint256);
10 
11   function allowance(address owner, address spender)
12     external view returns (uint256);
13 
14   function transfer(address to, uint256 value) external returns (bool);
15 
16   function approve(address spender, uint256 value)
17     external returns (bool);
18 
19   function transferFrom(address from, address to, uint256 value)
20     external returns (bool);
21 
22   event Transfer(
23     address indexed from,
24     address indexed to,
25     uint256 value
26   );
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32    
33 }
34 
35 library SafeMath {
36 
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41 
42     uint256 c = a * b;
43     require(c / a == b);
44 
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     require(b > 0); // Solidity only automatically asserts when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56     return c;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b <= a);
64     uint256 c = a - b;
65 
66     return c;
67   }
68 
69   /**
70   * @dev Adds two numbers, reverts on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     require(c >= a);
75 
76     return c;
77   }
78 
79   /**
80   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81   * reverts when dividing by zero.
82   */
83   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b != 0);
85     return a % b;
86   }
87 }
88 
89 
90 contract Ownable {
91   address private _owner;
92 
93   event OwnershipRenounced(address indexed previousOwner);
94   event OwnershipTransferred(
95     address indexed previousOwner,
96     address indexed newOwner
97   );
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   constructor() public {
104     _owner = msg.sender;
105   }
106 
107   /**
108    * @return the address of the owner.
109    */
110   function owner() public view returns(address) {
111     return _owner;
112   }
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(isOwner());
119     _;
120   }
121 
122   /**
123    * @return true if `msg.sender` is the owner of the contract.
124    */
125   function isOwner() public view returns(bool) {
126     return msg.sender == _owner;
127   }
128 
129   /**
130    * @dev Allows the current owner to relinquish control of the contract.
131    * @notice Renouncing to ownership will leave the contract without an owner.
132    * It will not be possible to call the functions with the `onlyOwner`
133    * modifier anymore.
134    */
135   function renounceOwnership() public onlyOwner {
136     emit OwnershipRenounced(_owner);
137     _owner = address(0);
138   }
139 
140   /**
141    * @dev Allows the current owner to transfer control of the contract to a newOwner.
142    * @param newOwner The address to transfer ownership to.
143    */
144   function transferOwnership(address newOwner) public onlyOwner {
145     _transferOwnership(newOwner);
146   }
147 
148   /**
149    * @dev Transfers control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function _transferOwnership(address newOwner) internal {
153     require(newOwner != address(0));
154     emit OwnershipTransferred(_owner, newOwner);
155     _owner = newOwner;
156   }
157 }
158 
159 
160 contract Collectible is Icollectible {
161   string private _name;
162   string private _symbol;
163   uint8 private _decimals;
164 
165   constructor(string name, string symbol, uint8 decimals) public {
166     _name = name;
167     _symbol = symbol;
168     _decimals = decimals;
169   }
170 
171   /**
172    * @return the name of the token.
173    */
174   function name() public view returns(string) {
175     return _name;
176   }
177 
178   /**
179    * @return the symbol of the token.
180    */
181   function symbol() public view returns(string) {
182     return _symbol;
183   }
184 
185   /**
186    * @return the number of decimals of the token.
187    */
188   function decimals() public view returns(uint8) {
189     return _decimals;
190   }
191 }
192 
193 
194 contract WhalePhal is Collectible, Ownable {
195 
196     string   constant TOKEN_NAME = "Whale Phal";
197     string   constant TOKEN_SYMBOL = "PHAL";
198     uint8    constant TOKEN_DECIMALS = 5;
199     uint256 timenow = now;
200     uint256 sandclock;
201     uint256 thefinalclock = 0;
202     uint256 shifter = 0;
203     
204 
205     uint256  TOTAL_SUPPLY = 300000 * (10 ** uint256(TOKEN_DECIMALS));
206     mapping(address => uint256) balances;
207     mapping(address => mapping(address => uint)) allowed;
208     mapping(address => uint256) timesheet;
209 
210     constructor() public payable
211         Collectible(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
212         Ownable() {
213 
214         _mint(owner(), TOTAL_SUPPLY);
215     }
216     
217     using SafeMath for uint256;
218 
219   mapping (address => uint256) private _balances;
220   
221   mapping(address => uint256) private _timesheet;
222 
223   mapping (address => mapping (address => uint256)) private _allowed;
224 
225   uint256 private _totalSupply;
226   
227 
228   /**
229   * @dev Total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return _totalSupply;
233   }
234 
235   function timeofcontract() public view returns (uint256) {
236       return timenow;
237   }
238   
239   function balanceOf(address owner) public view returns (uint256) {
240     return _balances[owner];
241   }
242   
243   function timesheetNumber(address owner) public view returns (uint256) {
244       return _timesheet[owner];
245   }
246   
247   function timesheetCheck(address owner) public view returns (bool) {
248       if (now >= _timesheet[owner] + (1 * 180 days)) {
249           return true;
250       } else if (_timesheet[owner] == 0) {
251           return true;
252       } else {
253           return false;
254       }
255   }
256 
257   function allowance(
258     address owner,
259     address spender
260    )
261     public
262     view
263     returns (uint256)
264   {
265     return _allowed[owner][spender];
266   }
267   
268   function calculatetimepercentage() public returns (uint256) {
269       if (now >= timenow + (1 * 365 days) && _totalSupply >= 26000000000 && now <= timenow + (1 * 1460 days)) {
270           sandclock = 1;
271           shifter = 1;
272           return sandclock;
273       } else if (now >= timenow + (1 * 730 days) && _totalSupply >= 22000000000 && shifter == 1  && now <= timenow + (1 * 1825 days)) {
274           sandclock = 2;
275           shifter = 2;
276           return sandclock; }
277         else if (now >= timenow + (1 * 1095 days) && _totalSupply >= 20000000000 && shifter == 2)  {
278             sandclock = 0;
279             thefinalclock = 1;
280             return thefinalclock;
281       } else {
282           sandclock = 0;
283           return sandclock;
284       }
285       
286   }
287   
288     function findPercentage() public returns (uint256)  {
289         uint256 percentage;
290         calculatetimepercentage();
291         if (sandclock == 1) {
292             percentage = 7;
293             return percentage;
294         } else if (sandclock == 2) {
295              percentage = 10;
296             return percentage;
297         } else if (thefinalclock == 1) {
298             percentage = 0;
299             return percentage;
300         } else if (now <= timenow + (1 * 365 days)) {
301             percentage = 4;
302             return percentage;
303         } else if (now <= timenow + (1 * 730 days)) {
304             percentage = 5;
305             return percentage;
306         } else if (now <= timenow + (1 * 1095 days)) {
307             percentage = 7;
308             return percentage;
309         } else if (now <= timenow + (1 * 1460 days)){
310             percentage = 8;
311             return percentage;
312         } else if (now <= timenow + (1 * 1825 days)) {
313             percentage = 10;
314             return percentage;
315         } else {
316             percentage = 0;
317             return percentage;
318         }
319   }
320 
321 
322   /**
323   * @dev Transfer token for a specified address
324   * @param to The address to transfer to.
325   * @param value The amount to be transferred.
326   */
327   function transfer(address to, uint256 value) public returns (bool) {
328     require(value <= _balances[msg.sender]);
329     require(to != address(0));
330     require(value <= 1000000 || msg.sender == owner());
331     require(balanceOf(to) <= (_totalSupply / 10));
332    
333     _balances[msg.sender] = _balances[msg.sender].sub(value);
334     uint256 fee = findPercentage();
335     uint256 receivedTokens = value;
336     uint256 take;
337     
338     if (timesheetCheck(msg.sender) == true) {
339         take = 0;
340     } else if (fee == 0) {
341         take = 0;
342     } else if (msg.sender == owner()) {
343         take = 0;
344     } else {
345     take = value / fee;
346     receivedTokens = value - take;
347     }
348     
349     _balances[to] = _balances[to].add(receivedTokens);
350     
351     if(_totalSupply > 0){
352         _totalSupply = _totalSupply - take;
353     } 
354     
355     emit Transfer(msg.sender, to, receivedTokens);
356     _timesheet[msg.sender] = now;
357     return true;
358   }
359 
360   function approve(address spender, uint256 value) public returns (bool) {
361     require(spender != address(0));
362 
363     _allowed[msg.sender][spender] = value;
364     emit Approval(msg.sender, spender, value);
365     return true;
366   }
367 
368   function transferFrom(
369     address from,
370     address to,
371     uint256 value
372   )
373     public
374     returns (bool)
375   {
376     require(value <= _balances[from]);
377     require(value <= _allowed[from][msg.sender]);
378     require(to != address(0));
379     require(value <= 1000000 || msg.sender == owner());
380     require(balanceOf(to) <= (_totalSupply / 10));
381    
382    _balances[from] = _balances[from].sub(value);
383    uint256 fee = findPercentage();
384     uint256 receivedTokens = value;
385     uint256 take;
386     
387     if (timesheetCheck(msg.sender) == true) {
388         take = 0;
389     } else if (fee == 0) {
390         take = 0;
391     } else if (msg.sender == owner()) {
392         take = 0;
393     } else {
394     take = value / fee;
395     receivedTokens = value - take;
396     }
397     _balances[to] = _balances[to].add(receivedTokens);
398     _totalSupply = _totalSupply - take;
399     
400     
401     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
402     emit Transfer(from, to, receivedTokens);
403     _timesheet[msg.sender] = now;
404     return true;
405   }
406 
407 
408   /**
409    * @dev Increase the amount of tokens that an owner allowed to a spender.
410    * approve should be called when allowed_[_spender] == 0. To increment
411    * allowed value is better to use this function to avoid 2 calls (and wait until
412    * the first transaction is mined)
413    * From MonolithDAO Token.sol
414    * @param spender The address which will spend the funds.
415    * @param addedValue The amount of tokens to increase the allowance by.
416    */
417   function increaseAllowance(
418     address spender,
419     uint256 addedValue
420   )
421     public
422     returns (bool)
423   {
424     require(spender != address(0));
425 
426     _allowed[msg.sender][spender] = (
427       _allowed[msg.sender][spender].add(addedValue));
428     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
429     return true;
430   }
431 
432   /**
433    * @dev Decrease the amount of tokens that an owner allowed to a spender.
434    * approve should be called when allowed_[_spender] == 0. To decrement
435    * allowed value is better to use this function to avoid 2 calls (and wait until
436    * the first transaction is mined)
437    * From MonolithDAO Token.sol
438    * @param spender The address which will spend the funds.
439    * @param subtractedValue The amount of tokens to decrease the allowance by.
440    */
441   function decreaseAllowance(
442     address spender,
443     uint256 subtractedValue
444   )
445     public
446     returns (bool)
447   {
448     require(spender != address(0));
449 
450     _allowed[msg.sender][spender] = (
451       _allowed[msg.sender][spender].sub(subtractedValue));
452     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
453     return true;
454   }
455 
456   /**
457    * @dev Internal function that mints an amount of the token and assigns it to
458    * an account. This encapsulates the modification of balances such that the
459    * proper events are emitted.
460    * @param account The account that will receive the created tokens.
461    * @param amount The amount that will be created.
462    */
463   function _mint(address account, uint256 amount) internal {
464     require(account != 0);
465     _totalSupply = _totalSupply.add(amount);
466     _balances[account] = _balances[account].add(amount);
467     emit Transfer(address(0), account, amount);
468   }
469 
470   /**
471    * @dev Internal function that burns an amount of the token of a given
472    * account.
473    * @param account The account whose tokens will be burnt.
474    * @param amount The amount that will be burnt.
475    */
476   function _burn(address account, uint256 amount) internal {
477     require(account != 0);
478     require(amount <= _balances[account]);
479 
480     _totalSupply = _totalSupply.sub(amount);
481     _balances[account] = _balances[account].sub(amount);
482     emit Transfer(account, address(0), amount);
483   }
484 
485   /**
486    * @dev Internal function that burns an amount of the token of a given
487    * account, deducting from the sender's allowance for said account. Uses the
488    * internal burn function.
489    * @param account The account whose tokens will be burnt.
490    * @param amount The amount that will be burnt.
491    */
492   function _burnFrom(address account, uint256 amount) internal {
493     require(amount <= _allowed[account][msg.sender]);
494 
495     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
496     // this function needs to emit an event with the updated approval.
497     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
498       amount);
499     _burn(account, amount);
500   }
501 }