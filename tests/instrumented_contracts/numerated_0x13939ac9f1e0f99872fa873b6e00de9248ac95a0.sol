1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   uint256 totalSupply_;
153 
154   /**
155   * @dev total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 /**
188  * @title Burnable Token
189  * @dev Token that can be irreversibly burned (destroyed).
190  */
191 contract BurnableToken is BasicToken {
192 
193   event Burn(address indexed burner, uint256 value);
194 
195   /**
196    * @dev Burns a specific amount of tokens.
197    * @param _value The amount of token to be burned.
198    */
199   function burn(uint256 _value) public {
200     _burn(msg.sender, _value);
201   }
202 
203   function _burn(address _who, uint256 _value) internal {
204     require(_value <= balances[_who]);
205     // no need to require value <= totalSupply, since that would imply the
206     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
207 
208     balances[_who] = balances[_who].sub(_value);
209     totalSupply_ = totalSupply_.sub(_value);
210     emit Burn(_who, _value);
211     emit Transfer(_who, address(0), _value);
212   }
213 }
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(
234     address _from,
235     address _to,
236     uint256 _value
237   )
238     public
239     returns (bool)
240   {
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     emit Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    *
255    * Beware that changing an allowance with this method brings the risk that someone may use both the old
256    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259    * @param _spender The address which will spend the funds.
260    * @param _value The amount of tokens to be spent.
261    */
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     allowed[msg.sender][_spender] = _value;
264     emit Approval(msg.sender, _spender, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Function to check the amount of tokens that an owner allowed to a spender.
270    * @param _owner address The address which owns the funds.
271    * @param _spender address The address which will spend the funds.
272    * @return A uint256 specifying the amount of tokens still available for the spender.
273    */
274   function allowance(
275     address _owner,
276     address _spender
277    )
278     public
279     view
280     returns (uint256)
281   {
282     return allowed[_owner][_spender];
283   }
284 
285   /**
286    * @dev Increase the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To increment
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _addedValue The amount of tokens to increase the allowance by.
294    */
295   function increaseApproval(
296     address _spender,
297     uint _addedValue
298   )
299     public
300     returns (bool)
301   {
302     allowed[msg.sender][_spender] = (
303       allowed[msg.sender][_spender].add(_addedValue));
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308   /**
309    * @dev Decrease the amount of tokens that an owner allowed to a spender.
310    *
311    * approve should be called when allowed[_spender] == 0. To decrement
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _subtractedValue The amount of tokens to decrease the allowance by.
317    */
318   function decreaseApproval(
319     address _spender,
320     uint _subtractedValue
321   )
322     public
323     returns (bool)
324   {
325     uint oldValue = allowed[msg.sender][_spender];
326     if (_subtractedValue > oldValue) {
327       allowed[msg.sender][_spender] = 0;
328     } else {
329       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
330     }
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335 }
336 
337 /**
338  * @title ERC827 interface, an extension of ERC20 token standard
339  *
340  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
341  * @dev methods to transfer value and data and execute calls in transfers and
342  * @dev approvals.
343  */
344 contract ERC827 is ERC20 {
345   function approveAndCall(
346     address _spender,
347     uint256 _value,
348     bytes _data
349   )
350     public
351     payable
352     returns (bool);
353 
354   function transferAndCall(
355     address _to,
356     uint256 _value,
357     bytes _data
358   )
359     public
360     payable
361     returns (bool);
362 
363   function transferFromAndCall(
364     address _from,
365     address _to,
366     uint256 _value,
367     bytes _data
368   )
369     public
370     payable
371     returns (bool);
372 }
373 
374 /**
375  * @title ERC827, an extension of ERC20 token standard
376  *
377  * @dev Implementation the ERC827, following the ERC20 standard with extra
378  * @dev methods to transfer value and data and execute calls in transfers and
379  * @dev approvals.
380  *
381  * @dev Uses OpenZeppelin StandardToken.
382  */
383 contract ERC827Token is ERC827, StandardToken {
384 
385   /**
386    * @dev Addition to ERC20 token methods. It allows to
387    * @dev approve the transfer of value and execute a call with the sent data.
388    *
389    * @dev Beware that changing an allowance with this method brings the risk that
390    * @dev someone may use both the old and the new allowance by unfortunate
391    * @dev transaction ordering. One possible solution to mitigate this race condition
392    * @dev is to first reduce the spender's allowance to 0 and set the desired value
393    * @dev afterwards:
394    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
395    *
396    * @param _spender The address that will spend the funds.
397    * @param _value The amount of tokens to be spent.
398    * @param _data ABI-encoded contract call to call `_to` address.
399    *
400    * @return true if the call function was executed successfully
401    */
402   function approveAndCall(
403     address _spender,
404     uint256 _value,
405     bytes _data
406   )
407     public
408     payable
409     returns (bool)
410   {
411     require(_spender != address(this));
412 
413     super.approve(_spender, _value);
414 
415     // solium-disable-next-line security/no-call-value
416     require(_spender.call.value(msg.value)(_data));
417 
418     return true;
419   }
420 
421   /**
422    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
423    * @dev address and execute a call with the sent data on the same transaction
424    *
425    * @param _to address The address which you want to transfer to
426    * @param _value uint256 the amout of tokens to be transfered
427    * @param _data ABI-encoded contract call to call `_to` address.
428    *
429    * @return true if the call function was executed successfully
430    */
431   function transferAndCall(
432     address _to,
433     uint256 _value,
434     bytes _data
435   )
436     public
437     payable
438     returns (bool)
439   {
440     require(_to != address(this));
441 
442     super.transfer(_to, _value);
443 
444     // solium-disable-next-line security/no-call-value
445     require(_to.call.value(msg.value)(_data));
446     return true;
447   }
448 
449   /**
450    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
451    * @dev another and make a contract call on the same transaction
452    *
453    * @param _from The address which you want to send tokens from
454    * @param _to The address which you want to transfer to
455    * @param _value The amout of tokens to be transferred
456    * @param _data ABI-encoded contract call to call `_to` address.
457    *
458    * @return true if the call function was executed successfully
459    */
460   function transferFromAndCall(
461     address _from,
462     address _to,
463     uint256 _value,
464     bytes _data
465   )
466     public payable returns (bool)
467   {
468     require(_to != address(this));
469 
470     super.transferFrom(_from, _to, _value);
471 
472     // solium-disable-next-line security/no-call-value
473     require(_to.call.value(msg.value)(_data));
474     return true;
475   }
476 
477   /**
478    * @dev Addition to StandardToken methods. Increase the amount of tokens that
479    * @dev an owner allowed to a spender and execute a call with the sent data.
480    *
481    * @dev approve should be called when allowed[_spender] == 0. To increment
482    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
483    * @dev the first transaction is mined)
484    * @dev From MonolithDAO Token.sol
485    *
486    * @param _spender The address which will spend the funds.
487    * @param _addedValue The amount of tokens to increase the allowance by.
488    * @param _data ABI-encoded contract call to call `_spender` address.
489    */
490   function increaseApprovalAndCall(
491     address _spender,
492     uint _addedValue,
493     bytes _data
494   )
495     public
496     payable
497     returns (bool)
498   {
499     require(_spender != address(this));
500 
501     super.increaseApproval(_spender, _addedValue);
502 
503     // solium-disable-next-line security/no-call-value
504     require(_spender.call.value(msg.value)(_data));
505 
506     return true;
507   }
508 
509   /**
510    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
511    * @dev an owner allowed to a spender and execute a call with the sent data.
512    *
513    * @dev approve should be called when allowed[_spender] == 0. To decrement
514    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
515    * @dev the first transaction is mined)
516    * @dev From MonolithDAO Token.sol
517    *
518    * @param _spender The address which will spend the funds.
519    * @param _subtractedValue The amount of tokens to decrease the allowance by.
520    * @param _data ABI-encoded contract call to call `_spender` address.
521    */
522   function decreaseApprovalAndCall(
523     address _spender,
524     uint _subtractedValue,
525     bytes _data
526   )
527     public
528     payable
529     returns (bool)
530   {
531     require(_spender != address(this));
532 
533     super.decreaseApproval(_spender, _subtractedValue);
534 
535     // solium-disable-next-line security/no-call-value
536     require(_spender.call.value(msg.value)(_data));
537 
538     return true;
539   }
540 
541 }
542 
543 contract UnlimitedAllowanceToken is ERC827Token {
544 
545     uint internal constant MAX_UINT = 2**256 - 1;
546     
547     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
548     /// @param _from Address to transfer from.
549     /// @param _to Address to transfer to.
550     /// @param _value Amount to transfer.
551     /// @return Success of transfer.
552     function transferFrom(address _from, address _to, uint _value)
553         public
554         returns (bool)
555     {
556         uint allowance = allowed[_from][msg.sender];
557         if (balances[_from] >= _value
558             && allowance >= _value
559             && balances[_to] + _value >= balances[_to]
560         ) {
561             balances[_to] += _value;
562             balances[_from] -= _value;
563             if (allowance < MAX_UINT) {
564                 allowed[_from][msg.sender] -= _value;
565             }
566             emit Transfer(_from, _to, _value);
567             return true;
568         } else {
569             return false;
570         }
571     }
572 }
573 
574 contract BaseToken is UnlimitedAllowanceToken, BurnableToken {
575     string public name;
576     uint8 public decimals;
577     string public symbol;
578 
579     constructor(
580         uint256 _initialAmount,
581         string _tokenName,
582         uint8 _decimalUnits,
583         string _tokenSymbol
584         ) public {
585         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
586         totalSupply_ = _initialAmount;                       // Update total supply
587         name = _tokenName;                                   // Set the name for display purposes
588         decimals = _decimalUnits;                            // Amount of decimals for display purposes
589         symbol = _tokenSymbol;                               // Set the symbol for display purposes
590     }
591 }
592 
593 // 1 billion tokens (18 decimal places)
594 contract BZRxToken is Ownable, BaseToken( // solhint-disable-line no-empty-blocks
595     1000000000000000000000000000,
596     "BZRX-Fake Protocol Token", 
597     18,
598     "BZRXFAKE"
599 ) {
600     function renameToken(
601         string _newName,
602         string _newSymbol
603         )
604         public
605         onlyOwner
606     {
607         name = _newName;
608         symbol = _newSymbol;
609     }
610 }