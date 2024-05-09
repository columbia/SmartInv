1 pragma solidity 0.5.7;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(
58         uint256 a,
59         uint256 b,
60         string memory errorMessage
61     ) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      * - The divisor cannot be zero.
116      *
117      * _Available since v2.4.0._
118      */
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         // Solidity only automatically asserts when dividing by 0
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      *
158      * _Available since v2.4.0._
159      */
160     function mod(
161         uint256 a,
162         uint256 b,
163         string memory errorMessage
164     ) internal pure returns (uint256) {
165         require(b != 0, errorMessage);
166         return a % b;
167     }
168 }
169 
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  **/
176 
177 contract Ownable {
178     address public owner;
179     event OwnershipTransferred(
180         address indexed previousOwner,
181         address indexed newOwner
182     );
183 
184     /**
185      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
186      **/
187     constructor() public {
188         owner = msg.sender;
189     }
190 
191     /**
192      * @dev Throws if called by any account other than the owner.
193      **/
194     modifier onlyOwner() {
195         require(msg.sender == owner, "only owner can make this transaction");
196         _;
197     }
198 
199     /**
200      * @dev Allows the current owner to transfer control of the contract to a newOwner.
201      * @param newOwner The address to transfer ownership to.
202      **/
203     function transferOwnership(address newOwner) public onlyOwner {
204         require(
205             newOwner != address(0),
206             "new owner can not be a zero address"
207         );
208         emit OwnershipTransferred(owner, newOwner);
209         owner = newOwner;
210     }
211 }
212 
213 
214 /**
215  * @title ERC20Basic interface
216  * @dev Basic ERC20 interface
217  **/
218 contract ERC20Basic {
219     function totalSupply() public view returns (uint256);
220 
221     function balanceOf(address who) public view returns (uint256);
222 
223     function transfer(address to, uint256 value) public returns (bool);
224 
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 }
227 
228 
229 /**
230  * @title ERC20 interface
231  * @dev see https://github.com/ethereum/EIPs/issues/20
232  **/
233 contract ERC20 is ERC20Basic {
234     function allowance(address owner, address spender)
235     public
236     view
237     returns (uint256);
238 
239     function transferFrom(
240         address from,
241         address to,
242         uint256 value
243     ) public returns (bool);
244 
245     function approve(
246         address spender,
247         uint256 value
248     ) public returns (bool);
249 
250     event Approval(
251         address indexed owner,
252         address indexed spender,
253         uint256 value
254     );
255 }
256 
257 
258 /**
259  * @title Basic token
260  * @dev Basic version of StandardToken, with no allowances.
261  **/
262 contract BasicToken is ERC20Basic {
263     using SafeMath for uint256;
264     mapping(address => uint256) balances;
265     uint256 totalSupply_;
266 
267     /**
268      * @dev total number of tokens in existence
269      **/
270     function totalSupply() public view returns (uint256) {
271         return totalSupply_;
272     }
273 
274     /**
275      * @dev transfer token for a specified address
276      * @param _to The address to transfer to.
277      * @param _value The amount to be transferred.
278      **/
279     function _transfer(address _to, uint256 _value) internal returns (bool) {
280         require(
281             _to != address(0),
282             "transfer to zero address is not  allowed"
283         );
284         require(
285             _value <= balances[msg.sender],
286             "sender does not have enough balance"
287         );
288 
289         balances[msg.sender] = balances[msg.sender].sub(_value);
290         balances[_to] = balances[_to].add(_value);
291         emit Transfer(
292             msg.sender,
293             _to, _value
294         );
295         return true;
296     }
297 
298     /**
299      * @dev Gets the balance of the specified address.
300      * @param _owner The address to query the the balance of.
301      * @return An uint256 representing the amount owned by the passed address.
302      **/
303     function balanceOf(address _owner) public view returns (uint256) {
304         return balances[_owner];
305     }
306 }
307 
308 
309 contract StandardToken is Ownable, ERC20, BasicToken {
310     mapping(address => mapping(address => uint256)) internal allowed;
311 
312     /**
313      * @dev Transfer tokens from one address to another
314      * @param _from address The address which you want to send tokens from
315      * @param _to address The address which you want to transfer to
316      * @param _value uint256 the amount of tokens to be transferred
317      **/
318     function transferFrom(
319         address _from,
320         address _to,
321         uint256 _value
322     ) public returns (bool) {
323         require(
324             _to != address(0),
325             "transfer to zero address is not  allowed"
326         );
327         require(
328             _value <= balances[_from],
329             "from address does not have enough balance"
330         );
331         require(
332             _value <= allowed[_from][msg.sender],
333             "sender does not have enough allowance"
334         );
335 
336         balances[_from] = balances[_from]
337         .sub(_value);
338 
339         balances[_to] = balances[_to]
340         .add(_value);
341 
342         allowed[_from][msg.sender] = allowed[
343         _from
344         ]
345         [
346         msg.sender
347         ].sub(_value);
348 
349         emit Transfer(
350             _from,
351             _to,
352             _value
353         );
354         return true;
355     }
356 
357     function transfer(
358         address to,
359         uint256 value
360     ) public returns(bool) {
361         return _transfer(to, value);
362     }
363 
364     /**
365      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
366      *
367      * Beware that changing an allowance with this method brings the risk that someone may use both the old
368      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
369      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
370      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
371      * @param _spender The address which will spend the funds.
372      * @param _value The amount of tokens to be spent.
373      **/
374     function approve(address _spender, uint256 _value) public returns (bool) {
375         allowed[msg.sender][_spender] = _value;
376         emit Approval(msg.sender, _spender, _value);
377         return true;
378     }
379 
380     /**
381      * @dev Function to check the amount of tokens that an owner allowed to a spender.
382      * @param _owner address The address which owns the funds.
383      * @param _spender address The address which will spend the funds.
384      * @return A uint256 specifying the amount of tokens still available for the spender.
385      **/
386     function allowance(address _owner, address _spender)
387     public
388     view
389     returns (uint256)
390     {
391         return allowed[
392         _owner
393         ]
394         [
395         _spender
396         ];
397     }
398 
399     /**
400      * @dev Increase the amount of tokens that an owner allowed to a spender.
401      *
402      * approve should be called when allowed[_spender] == 0. To increment
403      * allowed value is better to use this function to avoid 2 calls (and wait until
404      * the first transaction is mined)
405      * @param _spender The address which will spend the funds.
406      * @param _addedValue The amount of tokens to increase the allowance by.
407      **/
408     function increaseApproval(address _spender, uint256 _addedValue)
409     public
410     returns (bool)
411     {
412         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(
413             _addedValue
414         );
415         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
416         return true;
417     }
418 
419     /**
420      * @dev Decrease the amount of tokens that an owner allowed to a spender.
421      *
422      * approve should be called when allowed[_spender] == 0. To decrement
423      * allowed value is better to use this function to avoid 2 calls (and wait until
424      * the first transaction is mined)
425      * @param _spender The address which will spend the funds.
426      * @param _subtractedValue The amount of tokens to decrease the allowance by.
427      **/
428     function decreaseApproval(address _spender, uint256 _subtractedValue)
429     public
430     returns (bool)
431     {
432         uint256 oldValue = allowed[msg.sender][_spender];
433         if (_subtractedValue > oldValue) {
434             allowed[msg.sender][_spender] = 0;
435         } else {
436             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
437         }
438         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
439         return true;
440     }
441 }
442 
443 
444 /**
445  * @title Configuration
446  * @dev Configuration variables of the contract
447  **/
448 contract Configuration {
449     uint256 public basePrice = 750; // tokens per 1 ether
450     string public name = "PayAccept";
451     string public symbol = "PAY";
452     uint256 public decimals = 18;
453     uint256 public initial_supply = 25000000 * 10**18;
454     uint256 public tokens_sold = 0;
455 }
456 
457 
458 /**
459  * @title CrowdsaleToken
460  * @dev Contract to preform crowd sale with token
461  **/
462 contract CrowdsaleToken is
463 StandardToken,
464 Configuration {
465     /**
466      * @dev enum of current crowd sale state
467      **/
468     enum Stages {none, start, end}
469 
470     Stages public currentStage;
471     event BasePriceChanged(
472         uint256 oldPrice,
473         uint256 indexed newPrice
474     );
475 
476     /**
477      * @dev constructor of CrowdsaleToken
478      **/
479     constructor() public {
480         currentStage = Stages.none;
481     }
482 
483     /**
484      * @dev fallback function to send ether to for Crowd sale
485      **/
486     function() external payable {
487         require(
488             currentStage == Stages.start,
489             "ICO is not in start stage"
490         );
491         require(
492             msg.value > 0,
493             "transaction value is 0"
494         );
495 
496         uint256 weiAmount = msg.value; // Calculate tokens to sell
497         uint256 tokens = weiAmount.mul(basePrice);
498 
499         tokens_sold = tokens_sold.add(tokens); // Increment raised amount
500 
501         balances[msg.sender] = balances[msg.sender].add(tokens);
502         emit Transfer(
503             address(0x0),
504             msg.sender,
505             tokens
506         );
507         totalSupply_ = totalSupply_.add(tokens);
508         address(
509             uint160(owner)
510         ).transfer(weiAmount); // Send money to owner
511     }
512 
513     /**
514      * @dev startICO starts the public ICO
515      **/
516     function startICO() public onlyOwner {
517         require(
518             currentStage == Stages.none,
519             "ICO cannot only be started"
520         );
521         currentStage = Stages.start;
522     }
523 
524     /**
525      * @dev endIco closes down the ICO
526      **/
527     function endICO() internal {
528         require(
529             currentStage == Stages.start,
530             "cannot end ICO"
531         );
532         currentStage = Stages.end;
533 
534         if (address(this).balance > 0) {
535             address(
536                 uint160(owner)
537             ).transfer(
538                 address(this).balance
539             ); // Send money to owner
540         }
541     }
542 
543     /**
544      * @dev finalizeIco closes down the ICO and sets needed varriables
545      **/
546     function finalizeICO() public onlyOwner {
547         endICO();
548     }
549 
550     /**
551      * @dev change base price of token per ether
552      **/
553     function changeBasePrice(uint256 newBasePrice) public onlyOwner {
554         require(
555             newBasePrice > 0,
556             "base price cannot be zero"
557         );
558         uint256 oldBasePrice = basePrice;
559         basePrice = newBasePrice;
560 
561         emit BasePriceChanged(
562             oldBasePrice,
563             basePrice
564         );
565     }
566 }
567 
568 /**
569  * @title PayToken
570  * @dev Contract to create the PayToken
571  **/
572 contract PayToken is CrowdsaleToken {
573     constructor() public {
574         balances[owner] = initial_supply;
575         totalSupply_ = initial_supply;
576         emit Transfer(
577             address(0x0),
578             owner,
579             initial_supply
580         );
581     }
582 
583     function doAirdrop(
584         address[] memory recipients,
585         uint256[] memory values
586     ) public onlyOwner {
587         require(
588             recipients.length == values.length,
589             "recipients and values should have same number of values"
590         );
591         for (uint256 i = 0; i < recipients.length; i++) {
592             balances[recipients[i]] = balances[recipients[i]]
593             .add(values[i]);
594 
595             balances[owner] = balances[owner]
596             .sub(values[i]);
597 
598             emit Transfer(
599                 owner,
600                 recipients[i],
601                 values[i]
602             );
603         }
604     }
605 }