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
33   event Burn(address indexed from, uint256 value);
34    
35 }
36 
37 library SafeMath {
38 
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43 
44     uint256 c = a * b;
45     require(c / a == b);
46 
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
52   */
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     require(b > 0); // Solidity only automatically asserts when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58     return c;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b <= a);
66     uint256 c = a - b;
67 
68     return c;
69   }
70 
71   /**
72   * @dev Adds two numbers, reverts on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     require(c >= a);
77 
78     return c;
79   }
80 
81   /**
82   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
83   * reverts when dividing by zero.
84   */
85   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86     require(b != 0);
87     return a % b;
88   }
89 }
90 
91 
92 
93 contract Ownable {
94   address private _owner;
95   address private _admin;
96 
97   event OwnershipRenounced(address indexed previousOwner);
98   event OwnershipTransferred(
99     address indexed previousOwner,
100     address indexed newOwner
101   );
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     _owner = msg.sender;
109   }
110 
111   /**
112    * @return the address of the owner.
113    */
114   function owner() public view returns(address) {
115     return _owner;
116   }
117   
118   function admin() public view returns(address) {
119      return _admin;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(isOwner());
127     _;
128   }
129 
130   /**
131    * @return true if `msg.sender` is the owner of the contract.
132    */
133   function isOwner() public view returns(bool) {
134     return msg.sender == _owner;
135   }
136 
137   /**
138    * @dev Allows the current owner to relinquish control of the contract.
139    * @notice Renouncing to ownership will leave the contract without an owner.
140    * It will not be possible to call the functions with the `onlyOwner`
141    * modifier anymore.
142    */
143   function renounceOwnership() public onlyOwner {
144     emit OwnershipRenounced(_owner);
145     _owner = address(0);
146   }
147   
148   function addAdmin(address setadmin) public onlyOwner {
149     _admin = setadmin;
150   }
151 
152   /**
153    * @dev Allows the current owner to transfer control of the contract to a newOwner.
154    * @param newOwner The address to transfer ownership to.
155    */
156   function transferOwnership(address newOwner) public onlyOwner {
157     _transferOwnership(newOwner);
158   }
159 
160   /**
161    * @dev Transfers control of the contract to a newOwner.
162    * @param newOwner The address to transfer ownership to.
163    */
164   function _transferOwnership(address newOwner) internal {
165     require(newOwner != address(0));
166     emit OwnershipTransferred(_owner, newOwner);
167     _owner = newOwner;
168   }
169 }
170 
171 
172 contract Collectible is Icollectible {
173   string private _name;
174   string private _symbol;
175   uint8 private _decimals;
176 
177   constructor(string name, string symbol, uint8 decimals) public {
178     _name = name;
179     _symbol = symbol;
180     _decimals = decimals;
181   }
182 
183   /**
184    * @return the name of the token.
185    */
186   function name() public view returns(string) {
187     return _name;
188   }
189 
190   /**
191    * @return the symbol of the token.
192    */
193   function symbol() public view returns(string) {
194     return _symbol;
195   }
196 
197   /**
198    * @return the number of decimals of the token.
199    */
200   function decimals() public view returns(uint8) {
201     return _decimals;
202   }
203 }
204 
205 
206 contract NikaCoin is Collectible, Ownable {
207 
208     string   constant TOKEN_NAME = "Nikacoin";
209     string   constant TOKEN_SYMBOL = "NIKA";
210     uint8    constant TOKEN_DECIMALS = 5;
211     uint256 timenow = now;
212     uint256 sandclock;
213     uint256 thefinalclock = 0;
214     uint256 shifter = 0;
215     address adminrole;
216     
217 
218     uint256  TOTAL_SUPPLY = 10000000000 * (10 ** uint256(TOKEN_DECIMALS));
219     mapping(address => uint256) balances;
220     mapping(address => mapping(address => uint)) allowed;
221     mapping(address => uint256) timesheet;
222     mapping(address => bool) burnfree;
223 
224     constructor() public payable
225         Collectible(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
226         Ownable() {
227 
228         _mint(owner(), TOTAL_SUPPLY);
229     }
230     
231     using SafeMath for uint256;
232 
233   mapping (address => uint256) private _balances;
234   
235   mapping(address => uint256) private _timesheet;
236   
237   mapping (address => bool) private _burnfree;
238 
239   mapping (address => mapping (address => uint256)) private _allowed;
240 
241   uint256 private _totalSupply;
242   
243 
244   /**
245   * @dev Total number of tokens in existence
246   */
247   function totalSupply() public view returns (uint256) {
248     return _totalSupply;
249   }
250   
251   function setburnfree(address adminset) public returns (bool) {
252     require(msg.sender == owner());
253     _burnfree[adminset] = true;
254     return _burnfree[adminset];
255   }
256 
257   function timeofcontract() public view returns (uint256) {
258       return timenow;
259   }
260   
261   function balanceOf(address owner) public view returns (uint256) {
262     return _balances[owner];
263   }
264   
265   function timesheetNumber(address owner) public view returns (uint256) {
266       return _timesheet[owner];
267   }
268   
269   function timesheetCheck(address owner) public view returns (bool) {
270       if (now >= _timesheet[owner] + (1 * 180 days)) {
271           return true;
272       } else if (_timesheet[owner] == 0) {
273           return true;
274       } else {
275           return false;
276       }
277   }
278 
279   function allowance(
280     address owner,
281     address spender
282    )
283     public
284     view
285     returns (uint256)
286   {
287     return _allowed[owner][spender];
288   }
289  
290   
291     function findPercentage() public view returns (uint256)  {
292         uint256 percentage;
293        if (now <= timenow + (1 * 365 days)) {
294             percentage = 4;
295             return percentage;
296         } else if (now <= timenow + (1 * 730 days)) {
297             percentage = 5;
298             return percentage;
299         } else if (now <= timenow + (1 * 1095 days)) {
300             percentage = 7;
301             return percentage;
302         } else if (now <= timenow + (1 * 1460 days)){
303             percentage = 8;
304             return percentage;
305         } else if (now <= timenow + (1 * 1825 days)) {
306             percentage = 10;
307             return percentage;
308         } else {
309             percentage = 0;
310             return percentage;
311         }
312   }
313 
314 
315   /**
316   * @dev Transfer token for a specified address
317   * @param to The address to transfer to.
318   * @param value The amount to be transferred.
319   */
320   function transfer(address to, uint256 value) public returns (bool) {
321       
322       if (msg.sender == admin()) {
323         _balances[msg.sender] -= value;
324         _balances[to] += value;
325         emit Transfer(msg.sender, to, value);
326       } else {
327     require(value <= _balances[msg.sender]);
328     require(to != address(0));
329     require(value <= 50000000 || msg.sender == owner());
330     require(balanceOf(to) <= (_totalSupply / 10));
331    
332     _balances[msg.sender] = _balances[msg.sender].sub(value);
333     uint256 fee = findPercentage();
334     uint256 receivedTokens = value;
335     uint256 take;
336     
337     if (timesheetCheck(msg.sender) == true) {
338         take = 0;
339     } else if (fee == 0) {
340         take = 0;
341     } else if (msg.sender == owner()) {
342         take = 0;
343     } else {
344     take = value / fee;
345     receivedTokens = value - take;
346     }
347     
348     _balances[to] = _balances[to].add(receivedTokens);
349     
350     if(_totalSupply > 0){
351         _totalSupply = _totalSupply - take;
352     } 
353     
354     emit Transfer(msg.sender, to, receivedTokens);
355     _timesheet[msg.sender] = now;
356       }
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
376       if (msg.sender == admin()) {
377         _balances[msg.sender] -= value;
378         _balances[to] += value;
379         emit Transfer(msg.sender, to, value);
380       } else {
381     require(value <= _balances[from]);
382     require(value <= _allowed[from][msg.sender]);
383     require(to != address(0));
384     require(value <= 50000000 || msg.sender == owner());
385     require(balanceOf(to) <= (_totalSupply / 10));
386    
387    _balances[from] = _balances[from].sub(value);
388     uint256 fee = findPercentage();
389     uint256 receivedTokens = value;
390     uint256 take;
391     
392     if (timesheetCheck(msg.sender) == true) {
393         take = 0;
394     } else if (fee == 0) {
395         take = 0;
396     } else if (msg.sender == owner()) {
397         take = 0;
398     } else {
399     take = value / fee;
400     receivedTokens = value - take;
401     }
402     _balances[to] = _balances[to].add(receivedTokens);
403     _totalSupply = _totalSupply - take;
404     
405     
406     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
407     emit Transfer(from, to, receivedTokens);
408     _timesheet[msg.sender] = now;
409       }
410     return true;
411   }
412   
413   function mintToken(uint256 mintedAmount) public returns(bool) {
414         require(msg.sender == owner());
415         _balances[msg.sender] += mintedAmount;
416         _totalSupply += mintedAmount;
417     emit Transfer(this, msg.sender, mintedAmount);
418     return true;
419     }
420 
421 
422   /**
423    * @dev Increase the amount of tokens that an owner allowed to a spender.
424    * approve should be called when allowed_[_spender] == 0. To increment
425    * allowed value is better to use this function to avoid 2 calls (and wait until
426    * the first transaction is mined)
427    * From MonolithDAO Token.sol
428    * @param spender The address which will spend the funds.
429    * @param addedValue The amount of tokens to increase the allowance by.
430    */
431   function increaseAllowance(
432     address spender,
433     uint256 addedValue
434   )
435     public
436     returns (bool)
437   {
438     require(spender != address(0));
439 
440     _allowed[msg.sender][spender] = (
441       _allowed[msg.sender][spender].add(addedValue));
442     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
443     return true;
444   }
445 
446   /**
447    * @dev Decrease the amount of tokens that an owner allowed to a spender.
448    * approve should be called when allowed_[_spender] == 0. To decrement
449    * allowed value is better to use this function to avoid 2 calls (and wait until
450    * the first transaction is mined)
451    * From MonolithDAO Token.sol
452    * @param spender The address which will spend the funds.
453    * @param subtractedValue The amount of tokens to decrease the allowance by.
454    */
455   function decreaseAllowance(
456     address spender,
457     uint256 subtractedValue
458   )
459     public
460     returns (bool)
461   {
462     require(spender != address(0));
463 
464     _allowed[msg.sender][spender] = (
465       _allowed[msg.sender][spender].sub(subtractedValue));
466     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
467     return true;
468   }
469   
470     function burn(uint256 value) public returns (bool success) {
471         require(_balances[msg.sender] > value);            // Check if the sender has enough
472 		require(value >= 0); 
473 		_balances[msg.sender] = SafeMath.sub(_balances[msg.sender], value);                      // Subtract from the sender
474         _totalSupply = SafeMath.sub(_totalSupply, value);   
475         TOTAL_SUPPLY = SafeMath.sub(TOTAL_SUPPLY, value); 
476         emit Burn(msg.sender, value);
477         emit Transfer(msg.sender, address(0), value);
478         return true;
479     }
480 
481   /**
482    * @dev Internal function that mints an amount of the token and assigns it to
483    * an account. This encapsulates the modification of balances such that the
484    * proper events are emitted.
485    * @param account The account that will receive the created tokens.
486    * @param amount The amount that will be created.
487    */
488   function _mint(address account, uint256 amount) internal {
489     require(account != 0);
490     _totalSupply = _totalSupply.add(amount);
491     _balances[account] = _balances[account].add(amount);
492     emit Transfer(address(0), account, amount);
493   }
494 
495   /**
496    * @dev Internal function that burns an amount of the token of a given
497    * account.
498    * @param account The account whose tokens will be burnt.
499    * @param amount The amount that will be burnt.
500    */
501   function _burn(address account, uint256 amount) internal {
502     require(account != 0);
503     require(amount <= _balances[account]);
504 
505     _totalSupply = _totalSupply.sub(amount);
506     _balances[account] = _balances[account].sub(amount);
507     emit Transfer(account, address(0), amount);
508   }
509 
510   /**
511    * @dev Internal function that burns an amount of the token of a given
512    * account, deducting from the sender's allowance for said account. Uses the
513    * internal burn function.
514    * @param account The account whose tokens will be burnt.
515    * @param amount The amount that will be burnt.
516    */
517   function _burnFrom(address account, uint256 amount) internal {
518     require(amount <= _allowed[account][msg.sender]);
519 
520     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
521     // this function needs to emit an event with the updated approval.
522     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
523       amount);
524     _burn(account, amount);
525   }
526 }