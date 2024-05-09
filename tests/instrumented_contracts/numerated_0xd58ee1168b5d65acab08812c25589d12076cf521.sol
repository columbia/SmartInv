1 pragma solidity ^0.4.8;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 interface IERC20 {
75   function totalSupply() external view returns (uint256);
76 
77   function balanceOf(address who) external view returns (uint256);
78 
79   function allowance(address owner, address spender)
80     external view returns (uint256);
81 
82   function transfer(address to, uint256 value) external returns (bool);
83 
84   function approve(address spender, uint256 value)
85     external returns (bool);
86 
87   function transferFrom(address from, address to, uint256 value)
88     external returns (bool);
89 
90   event Transfer(
91     address indexed from,
92     address indexed to,
93     uint256 value
94   );
95 
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
109  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract ERC20 is IERC20 {
112   using SafeMath for uint256;
113 
114   mapping (address => uint256) private _balances;
115 
116   mapping (address => mapping (address => uint256)) private _allowed;
117 
118   uint256 private _totalSupply;
119 
120   /**
121   * @dev Total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return _totalSupply;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param owner The address to query the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address owner) public view returns (uint256) {
133     return _balances[owner];
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param owner address The address which owns the funds.
139    * @param spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(
143     address owner,
144     address spender
145    )
146     public
147     view
148     returns (uint256)
149   {
150     return _allowed[owner][spender];
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param to The address to transfer to.
156   * @param value The amount to be transferred.
157   */
158   function transfer(address to, uint256 value) public returns (bool) {
159     _transfer(msg.sender, to, value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param spender The address which will spend the funds.
170    * @param value The amount of tokens to be spent.
171    */
172   function approve(address spender, uint256 value) public returns (bool) {
173     require(spender != address(0));
174 
175     _allowed[msg.sender][spender] = value;
176     emit Approval(msg.sender, spender, value);
177     return true;
178   }
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param from address The address which you want to send tokens from
183    * @param to address The address which you want to transfer to
184    * @param value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address from,
188     address to,
189     uint256 value
190   )
191     public
192     returns (bool)
193   {
194     require(value <= _allowed[from][msg.sender]);
195 
196     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197     _transfer(from, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param spender The address which will spend the funds.
208    * @param addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseAllowance(
211     address spender,
212     uint256 addedValue
213   )
214     public
215     returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220       _allowed[msg.sender][spender].add(addedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed_[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param spender The address which will spend the funds.
232    * @param subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseAllowance(
235     address spender,
236     uint256 subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244       _allowed[msg.sender][spender].sub(subtractedValue));
245     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
246     return true;
247   }
248 
249   /**
250   * @dev Transfer token for a specified addresses
251   * @param from The address to transfer from.
252   * @param to The address to transfer to.
253   * @param value The amount to be transferred.
254   */
255   function _transfer(address from, address to, uint256 value) internal {
256     require(value <= _balances[from]);
257     require(to != address(0));
258 
259     _balances[from] = _balances[from].sub(value);
260     _balances[to] = _balances[to].add(value);
261     emit Transfer(from, to, value);
262   }
263 
264   /**
265    * @dev Internal function that mints an amount of the token and assigns it to
266    * an account. This encapsulates the modification of balances such that the
267    * proper events are emitted.
268    * @param account The account that will receive the created tokens.
269    * @param value The amount that will be created.
270    */
271   function _mint(address account, uint256 value) internal {
272     _totalSupply = _totalSupply.add(value);
273     _balances[account] = _balances[account].add(value);
274     emit Transfer(address(0), account, value);
275   }
276 
277   /**
278    * @dev Internal function that burns an amount of the token of a given
279    * account.
280    * @param account The account whose tokens will be burnt.
281    * @param value The amount that will be burnt.
282    */
283   function _burn(address account, uint256 value) internal {
284     require(value <= _balances[account]);
285 
286     _totalSupply = _totalSupply.sub(value);
287     _balances[account] = _balances[account].sub(value);
288     emit Transfer(account, address(0), value);
289   }
290 
291   /**
292    * @dev Internal function that burns an amount of the token of a given
293    * account, deducting from the sender's allowance for said account. Uses the
294    * internal burn function.
295    * @param account The account whose tokens will be burnt.
296    * @param value The amount that will be burnt.
297    */
298   function _burnFrom(address account, uint256 value) internal {
299     require(value <= _allowed[account][msg.sender]);
300 
301     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
302     // this function needs to emit an event with the updated approval.
303     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
304       value);
305     _burn(account, value);
306   }
307 }
308 
309 
310  
311  contract YCTDataControl {
312     mapping (address => uint256) public balances;
313     mapping (address => bool) accessAllowed;
314     string public constant name = "You Cloud Token"; // 合约名称
315     string public constant symbol = "YCT"; // 代币名称
316     uint8 public constant decimals = 18; // 代币精确度
317     uint256 public constant INITIAL_SUPPLY = 100 * 10 ** 8;
318     uint256 public totalSupply_;
319     
320     constructor() public {
321         accessAllowed[msg.sender] = true;
322         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
323         setBalance(msg.sender, totalSupply_);
324     }
325     
326     function setBalance(address _address,uint256 v) platform public {
327         balances[_address] = v;
328     }
329     
330     function balanceOf(address _address) public view returns (uint256) {
331         return balances[_address];
332     }
333     
334     modifier platform() {
335         require(accessAllowed[msg.sender] == true);
336         _;
337     }
338      
339     function allowAccess(address _addr) platform public {
340         accessAllowed[_addr] = true;
341     }
342      
343     function denyAccess(address _addr) platform public {
344         accessAllowed[_addr] = false;
345     }
346     
347     function isAccessAllowed(address _addr) public view returns (bool) {
348         return accessAllowed[_addr];
349     }
350  }
351  
352  
353  
354 contract StandardToken is ERC20 {
355   using SafeMath for uint256;
356 
357   mapping (address => mapping (address => uint256)) private allowed;
358   
359   YCTDataControl public dataContract;
360   address public dataControlAddr;
361 
362   uint256 public totalSupply_;
363 
364   /**
365   * @dev Total number of tokens in existence
366   */
367   function totalSupply() public view returns (uint256) {
368     return totalSupply_;
369   }
370   
371   function getDataContract() public view returns (YCTDataControl) {
372       return dataContract;
373   }
374   
375 
376   /**
377   * @dev Gets the balance of the specified address.
378   * @param _owner The address to query the the balance of.
379   * @return An uint256 representing the amount owned by the passed address.
380   */
381   function balanceOf(address _owner) public view returns (uint256) {
382     return dataContract.balanceOf(_owner);
383   }
384 
385   /**
386    * @dev Function to check the amount of tokens that an owner allowed to a spender.
387    * @param _owner address The address which owns the funds.
388    * @param _spender address The address which will spend the funds.
389    * @return A uint256 specifying the amount of tokens still available for the spender.
390    */
391   function allowance(
392     address _owner,
393     address _spender
394    )
395     public
396     view
397     returns (uint256)
398   {
399     return allowed[_owner][_spender];
400   }
401 
402   /**
403   * @dev Transfer token for a specified address
404   * @param _to The address to transfer to.
405   * @param _value The amount to be transferred.
406   */
407   function transfer(address _to, uint256 _value) public returns (bool) {
408     require(_value <= dataContract.balances(msg.sender));
409     require(_to != address(0));
410 
411     dataContract.setBalance(msg.sender, dataContract.balances(msg.sender).sub(_value));
412     dataContract.setBalance(_to, dataContract.balances(_to).add(_value));
413     emit Transfer(msg.sender, _to, _value);
414     return true;
415   }
416 
417   /**
418    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
419    * Beware that changing an allowance with this method brings the risk that someone may use both the old
420    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
421    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
422    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
423    * @param _spender The address which will spend the funds.
424    * @param _value The amount of tokens to be spent.
425    */
426   function approve(address _spender, uint256 _value) public returns (bool) {
427     allowed[msg.sender][_spender] = _value;
428     emit Approval(msg.sender, _spender, _value);
429     return true;
430   }
431 
432   /**
433    * @dev Transfer tokens from one address to another
434    * @param _from address The address which you want to send tokens from
435    * @param _to address The address which you want to transfer to
436    * @param _value uint256 the amount of tokens to be transferred
437    */
438   function transferFrom(
439     address _from,
440     address _to,
441     uint256 _value
442   )
443     public
444     returns (bool)
445   {
446     require(_value <= dataContract.balances(_from));
447     require(_value <= allowed[_from][msg.sender]);
448     require(_to != address(0));
449 
450     dataContract.setBalance(_from, dataContract.balances(_from).sub(_value));
451     dataContract.setBalance(_to, dataContract.balances(_to).add(_value));
452     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
453     emit Transfer(_from, _to, _value);
454     return true;
455   }
456 
457   /**
458    * @dev Increase the amount of tokens that an owner allowed to a spender.
459    * approve should be called when allowed[_spender] == 0. To increment
460    * allowed value is better to use this function to avoid 2 calls (and wait until
461    * the first transaction is mined)
462    * From MonolithDAO Token.sol
463    * @param _spender The address which will spend the funds.
464    * @param _addedValue The amount of tokens to increase the allowance by.
465    */
466   function increaseApproval(
467     address _spender,
468     uint256 _addedValue
469   )
470     public
471     returns (bool)
472   {
473     allowed[msg.sender][_spender] = (
474       allowed[msg.sender][_spender].add(_addedValue));
475     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
476     return true;
477   }
478 
479   /**
480    * @dev Decrease the amount of tokens that an owner allowed to a spender.
481    * approve should be called when allowed[_spender] == 0. To decrement
482    * allowed value is better to use this function to avoid 2 calls (and wait until
483    * the first transaction is mined)
484    * From MonolithDAO Token.sol
485    * @param _spender The address which will spend the funds.
486    * @param _subtractedValue The amount of tokens to decrease the allowance by.
487    */
488   function decreaseApproval(
489     address _spender,
490     uint256 _subtractedValue
491   )
492     public
493     returns (bool)
494   {
495     uint256 oldValue = allowed[msg.sender][_spender];
496     if (_subtractedValue >= oldValue) {
497       allowed[msg.sender][_spender] = 0;
498     } else {
499       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
500     }
501     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
502     return true;
503   }
504 
505 
506   /**
507    * @dev Internal function that burns an amount of the token of a given
508    * account.
509    * @param _account The account whose tokens will be burnt.
510    * @param _amount The amount that will be burnt.
511    */
512   function _burn(address _account, uint256 _amount) internal {
513     require(_amount <= dataContract.balances(_account));
514 
515     totalSupply_ = totalSupply_.sub(_amount);
516     dataContract.setBalance(_account, dataContract.balances(_account).sub(_amount));
517     emit Transfer(_account, address(0), _amount);
518   }
519 
520   /**
521    * @dev Internal function that burns an amount of the token of a given
522    * account, deducting from the sender's allowance for said account. Uses the
523    * internal _burn function.
524    * @param _account The account whose tokens will be burnt.
525    * @param _amount The amount that will be burnt.
526    */
527   function _burnFrom(address _account, uint256 _amount) internal {
528     require(_amount <= allowed[_account][msg.sender]);
529 
530     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
531     // this function needs to emit an event with the updated approval.
532     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
533     _burn(_account, _amount);
534   }
535 }
536 
537 
538 
539  
540  
541 
542 contract YCTToken is StandardToken {
543   string public name;
544   string public symbol;
545   uint8 public decimals;
546   uint256 public INITIAL_SUPPLY;
547 
548   /**
549    * @dev 合约所有者拥有所有的代币
550    */
551    
552   constructor(address _dataContractAddr) public {
553     dataControlAddr = _dataContractAddr;
554     dataContract = YCTDataControl(dataControlAddr);
555     name = dataContract.name();
556     symbol = dataContract.symbol();
557     decimals = dataContract.decimals();
558     INITIAL_SUPPLY = dataContract.INITIAL_SUPPLY();
559     totalSupply_ = dataContract.totalSupply_();
560   }
561 }