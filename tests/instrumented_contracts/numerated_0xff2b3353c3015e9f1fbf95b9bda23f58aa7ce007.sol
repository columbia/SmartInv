1 pragma solidity ^0.4.23;
2 
3 /*
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xc,..,lxKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOo:'........':dOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMN0xl,....';:,........;lxKNMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMWXOo:'....,:lxOk:...........':dOXWMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMNKxl;.....;cokOOOOd;...............;lkKWMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMWXOd:'....':lxkOOOkdc;'...................':dONWMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMWKkl;.....,coxOOOOxo:,...........................;lkKWMMMMMMMMMMMMM
11 MMMMMMMMMWNOdc'....':ldkOOOkdl;'.................................,cd0NWMMMMMMMMM
12 MMMMMMWKkl;.....,coxOOOOxoc,.........................................;okXWMMMMMM
13 MMMMXxc,....';ldkOOOkdl;'...............................................,ckNMMMM
14 MMMM0;...'coxOOOOxoc,.....................................................;0MMMM
15 MMMM0;..'oOOOkdl:'................................,;,,.............':l:...;0MMMM
16 MMMM0;..'oOOOl'..................................,dOOd,...........:xOOo...;0MMMM
17 MMMM0;..'oOOOc...':ccccccccccccc:;,...........';:okOOkl:;'........lOOOo...;0MMMM
18 MMMM0;..'oOOOc...;k0OOOOOOOOOOOOOOko;......':oxOOOOOOOOOOxo:'.....lOOOo'..;0MMMM
19 MMMM0;..'oOOOc...':lxOOkocccccccoxOOk:....,dOOOkdolclloxkOOOd,....lOOOo...;0MMMM
20 MMMM0;..'oOOOc......lOOk;........:xOOd'...lOOOd;........;okxl,....lOOOo...;0MMMM
21 MMMM0;..'oOOOc......lOOk;........:xOOo'...lOOOd;'.........,.......lOOOo...;0MMMM
22 MMMM0;..'oOOOc......lOOOocccccclokOOd;....,dO0Okxdolc:;,'.........lOOOo...;0MMMM
23 MMMM0;..'oOOOc......lOOOOOOOOOOOOOOx:......':oxkOOOOOOOkxdl;'.....lOOOo...;0MMMM
24 MMMM0;..'oOOOc......lOOOdccccccldkOOxc.........,;:clodxkOOOOd;....lOOOo...;0MMMM
25 MMMM0;..'oOOOc......lOOk;........,dOOk:................,:dOOOo'...lOOOo...;0MMMM
26 MMMM0;..'oOOOc......lOOk:.........cOOOl'.,coxl'..........ckOOx,...lOOOo...;0MMMM
27 MMMM0;..'oOOOc....',oOOkc'''''',;lxOOkc..;xOOOxoc:;,,;:cokOOkl....lOOOo...;0MMMM
28 MMMM0;..'oOOOc...;dkOOOOkkkkxkkkOOOOkc'...,lxOOOOOOkOOOOOOkd:.....lOOOo...;0MMMM
29 MMMM0;..'oOOOc...;dxxxxxxxxxxxxxxdoc,.......';codxOOOOxdlc;.......lOOOo...;0MMMM
30 MMMM0;..'oOOkc.....'''''''''''''.................;xO0x;...........lOOOo...;0MMMM
31 MMMM0;..'lxl:'...................................':cc:.........';lxOOOo...;0MMMM
32 MMMM0;...''.................................................,:oxOOOOko;...;0MMMM
33 MMMMKl'.................................................';ldkOOOkxl:'....'oXMMMM
34 MMMMMNKxl,...........................................,:oxOOOOkoc;'....;lxKWMMMMM
35 MMMMMMMMWXOo:'...................................';cdkOOOkxl:,....':dOXWMMMMMMMM
36 MMMMMMMMMMMMN0xc,.............................,:lxkOOOkdc;'....,lxKNMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMWXko:'.....................';cdkOOOkxo:,....':oOXWMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMN0xc,...............,:lxkOOOkdc;'....,cx0NMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMWXko;'...........:xkOOxo:,....':oOXWMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMWN0xc,........;ool;'....,cx0NMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKko;............;okXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWN0dc,....,cd0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOl;;l0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
44 */
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 /**
59  * @title MultiOwnable
60  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
61  * functions, this simplifies the implementation of "users permissions".
62  */
63 contract MultiOwnable {
64   address public manager; // address used to set owners
65   address[] public owners;
66   mapping(address => bool) public ownerByAddress;
67 
68   event SetOwners(address[] owners);
69 
70   modifier onlyOwner() {
71     require(ownerByAddress[msg.sender] == true);
72     _;
73   }
74 
75   /**
76     * @dev MultiOwnable constructor sets the manager
77     */
78   constructor() public {
79     manager = msg.sender;
80   }
81 
82   /**
83     * @dev Function to set owners addresses
84     */
85   function setOwners(address[] _owners) public {
86     require(msg.sender == manager);
87     _setOwners(_owners);
88   }
89 
90   function _setOwners(address[] _owners) internal {
91     for(uint256 i = 0; i < owners.length; i++) {
92       ownerByAddress[owners[i]] = false;
93     }
94 
95     for(uint256 j = 0; j < _owners.length; j++) {
96       ownerByAddress[_owners[j]] = true;
97     }
98     owners = _owners;
99     emit SetOwners(_owners);
100   }
101 
102   function getOwners() public view returns (address[]) {
103     return owners;
104   }
105 }
106 
107 /* solium-disable security/no-low-level-calls */
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title ERC827 interface, an extension of ERC20 token standard
130  *
131  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
132  * @dev methods to transfer value and data and execute calls in transfers and
133  * @dev approvals.
134  */
135 contract ERC827 is ERC20 {
136   function approveAndCall(
137     address _spender,
138     uint256 _value,
139     bytes _data
140   )
141     public
142     payable
143     returns (bool);
144 
145   function transferAndCall(
146     address _to,
147     uint256 _value,
148     bytes _data
149   )
150     public
151     payable
152     returns (bool);
153 
154   function transferFromAndCall(
155     address _from,
156     address _to,
157     uint256 _value,
158     bytes _data
159   )
160     public
161     payable
162     returns (bool);
163 }
164 
165 /**
166  * @title SafeMath
167  * @dev Math operations with safety checks that throw on error
168  */
169 library SafeMath {
170 
171   /**
172   * @dev Multiplies two numbers, throws on overflow.
173   */
174   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
175     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
176     // benefit is lost if 'b' is also tested.
177     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
178     if (a == 0) {
179       return 0;
180     }
181 
182     c = a * b;
183     assert(c / a == b);
184     return c;
185   }
186 
187   /**
188   * @dev Integer division of two numbers, truncating the quotient.
189   */
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     // assert(b > 0); // Solidity automatically throws when dividing by 0
192     // uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194     return a / b;
195   }
196 
197   /**
198   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
199   */
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   /**
206   * @dev Adds two numbers, throws on overflow.
207   */
208   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
209     c = a + b;
210     assert(c >= a);
211     return c;
212   }
213 }
214 
215 /**
216  * @title Basic token
217  * @dev Basic version of StandardToken, with no allowances.
218  */
219 contract BasicToken is ERC20Basic {
220   using SafeMath for uint256;
221 
222   mapping(address => uint256) balances;
223 
224   uint256 totalSupply_;
225 
226   /**
227   * @dev total number of tokens in existence
228   */
229   function totalSupply() public view returns (uint256) {
230     return totalSupply_;
231   }
232 
233   /**
234   * @dev transfer token for a specified address
235   * @param _to The address to transfer to.
236   * @param _value The amount to be transferred.
237   */
238   function transfer(address _to, uint256 _value) public returns (bool) {
239     require(_to != address(0));
240     require(_value <= balances[msg.sender]);
241 
242     balances[msg.sender] = balances[msg.sender].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     emit Transfer(msg.sender, _to, _value);
245     return true;
246   }
247 
248   /**
249   * @dev Gets the balance of the specified address.
250   * @param _owner The address to query the the balance of.
251   * @return An uint256 representing the amount owned by the passed address.
252   */
253   function balanceOf(address _owner) public view returns (uint256) {
254     return balances[_owner];
255   }
256 
257 }
258 
259 /**
260  * @title Standard ERC20 token
261  *
262  * @dev Implementation of the basic standard token.
263  * @dev https://github.com/ethereum/EIPs/issues/20
264  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
265  */
266 contract StandardToken is ERC20, BasicToken {
267 
268   mapping (address => mapping (address => uint256)) internal allowed;
269 
270   /**
271    * @dev Transfer tokens from one address to another
272    * @param _from address The address which you want to send tokens from
273    * @param _to address The address which you want to transfer to
274    * @param _value uint256 the amount of tokens to be transferred
275    */
276   function transferFrom(
277     address _from,
278     address _to,
279     uint256 _value
280   )
281     public
282     returns (bool)
283   {
284     require(_to != address(0));
285     require(_value <= balances[_from]);
286     require(_value <= allowed[_from][msg.sender]);
287 
288     balances[_from] = balances[_from].sub(_value);
289     balances[_to] = balances[_to].add(_value);
290     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291     emit Transfer(_from, _to, _value);
292     return true;
293   }
294 
295   /**
296    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
297    *
298    * Beware that changing an allowance with this method brings the risk that someone may use both the old
299    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
300    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
301    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302    * @param _spender The address which will spend the funds.
303    * @param _value The amount of tokens to be spent.
304    */
305   function approve(address _spender, uint256 _value) public returns (bool) {
306     allowed[msg.sender][_spender] = _value;
307     emit Approval(msg.sender, _spender, _value);
308     return true;
309   }
310 
311   /**
312    * @dev Function to check the amount of tokens that an owner allowed to a spender.
313    * @param _owner address The address which owns the funds.
314    * @param _spender address The address which will spend the funds.
315    * @return A uint256 specifying the amount of tokens still available for the spender.
316    */
317   function allowance(
318     address _owner,
319     address _spender
320    )
321     public
322     view
323     returns (uint256)
324   {
325     return allowed[_owner][_spender];
326   }
327 
328   /**
329    * @dev Increase the amount of tokens that an owner allowed to a spender.
330    *
331    * approve should be called when allowed[_spender] == 0. To increment
332    * allowed value is better to use this function to avoid 2 calls (and wait until
333    * the first transaction is mined)
334    * From MonolithDAO Token.sol
335    * @param _spender The address which will spend the funds.
336    * @param _addedValue The amount of tokens to increase the allowance by.
337    */
338   function increaseApproval(
339     address _spender,
340     uint _addedValue
341   )
342     public
343     returns (bool)
344   {
345     allowed[msg.sender][_spender] = (
346       allowed[msg.sender][_spender].add(_addedValue));
347     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
348     return true;
349   }
350 
351   /**
352    * @dev Decrease the amount of tokens that an owner allowed to a spender.
353    *
354    * approve should be called when allowed[_spender] == 0. To decrement
355    * allowed value is better to use this function to avoid 2 calls (and wait until
356    * the first transaction is mined)
357    * From MonolithDAO Token.sol
358    * @param _spender The address which will spend the funds.
359    * @param _subtractedValue The amount of tokens to decrease the allowance by.
360    */
361   function decreaseApproval(
362     address _spender,
363     uint _subtractedValue
364   )
365     public
366     returns (bool)
367   {
368     uint oldValue = allowed[msg.sender][_spender];
369     if (_subtractedValue > oldValue) {
370       allowed[msg.sender][_spender] = 0;
371     } else {
372       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
373     }
374     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375     return true;
376   }
377 
378 }
379 
380 /**
381  * @title ERC827, an extension of ERC20 token standard
382  *
383  * @dev Implementation the ERC827, following the ERC20 standard with extra
384  * @dev methods to transfer value and data and execute calls in transfers and
385  * @dev approvals.
386  *
387  * @dev Uses OpenZeppelin StandardToken.
388  */
389 contract ERC827Token is ERC827, StandardToken {
390 
391   /**
392    * @dev Addition to ERC20 token methods. It allows to
393    * @dev approve the transfer of value and execute a call with the sent data.
394    *
395    * @dev Beware that changing an allowance with this method brings the risk that
396    * @dev someone may use both the old and the new allowance by unfortunate
397    * @dev transaction ordering. One possible solution to mitigate this race condition
398    * @dev is to first reduce the spender's allowance to 0 and set the desired value
399    * @dev afterwards:
400    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
401    *
402    * @param _spender The address that will spend the funds.
403    * @param _value The amount of tokens to be spent.
404    * @param _data ABI-encoded contract call to call `_to` address.
405    *
406    * @return true if the call function was executed successfully
407    */
408   function approveAndCall(
409     address _spender,
410     uint256 _value,
411     bytes _data
412   )
413     public
414     payable
415     returns (bool)
416   {
417     require(_spender != address(this));
418 
419     super.approve(_spender, _value);
420 
421     // solium-disable-next-line security/no-call-value
422     require(_spender.call.value(msg.value)(_data));
423 
424     return true;
425   }
426 
427   /**
428    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
429    * @dev address and execute a call with the sent data on the same transaction
430    *
431    * @param _to address The address which you want to transfer to
432    * @param _value uint256 the amout of tokens to be transfered
433    * @param _data ABI-encoded contract call to call `_to` address.
434    *
435    * @return true if the call function was executed successfully
436    */
437   function transferAndCall(
438     address _to,
439     uint256 _value,
440     bytes _data
441   )
442     public
443     payable
444     returns (bool)
445   {
446     require(_to != address(this));
447 
448     super.transfer(_to, _value);
449 
450     // solium-disable-next-line security/no-call-value
451     require(_to.call.value(msg.value)(_data));
452     return true;
453   }
454 
455   /**
456    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
457    * @dev another and make a contract call on the same transaction
458    *
459    * @param _from The address which you want to send tokens from
460    * @param _to The address which you want to transfer to
461    * @param _value The amout of tokens to be transferred
462    * @param _data ABI-encoded contract call to call `_to` address.
463    *
464    * @return true if the call function was executed successfully
465    */
466   function transferFromAndCall(
467     address _from,
468     address _to,
469     uint256 _value,
470     bytes _data
471   )
472     public payable returns (bool)
473   {
474     require(_to != address(this));
475 
476     super.transferFrom(_from, _to, _value);
477 
478     // solium-disable-next-line security/no-call-value
479     require(_to.call.value(msg.value)(_data));
480     return true;
481   }
482 
483   /**
484    * @dev Addition to StandardToken methods. Increase the amount of tokens that
485    * @dev an owner allowed to a spender and execute a call with the sent data.
486    *
487    * @dev approve should be called when allowed[_spender] == 0. To increment
488    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
489    * @dev the first transaction is mined)
490    * @dev From MonolithDAO Token.sol
491    *
492    * @param _spender The address which will spend the funds.
493    * @param _addedValue The amount of tokens to increase the allowance by.
494    * @param _data ABI-encoded contract call to call `_spender` address.
495    */
496   function increaseApprovalAndCall(
497     address _spender,
498     uint _addedValue,
499     bytes _data
500   )
501     public
502     payable
503     returns (bool)
504   {
505     require(_spender != address(this));
506 
507     super.increaseApproval(_spender, _addedValue);
508 
509     // solium-disable-next-line security/no-call-value
510     require(_spender.call.value(msg.value)(_data));
511 
512     return true;
513   }
514 
515   /**
516    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
517    * @dev an owner allowed to a spender and execute a call with the sent data.
518    *
519    * @dev approve should be called when allowed[_spender] == 0. To decrement
520    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
521    * @dev the first transaction is mined)
522    * @dev From MonolithDAO Token.sol
523    *
524    * @param _spender The address which will spend the funds.
525    * @param _subtractedValue The amount of tokens to decrease the allowance by.
526    * @param _data ABI-encoded contract call to call `_spender` address.
527    */
528   function decreaseApprovalAndCall(
529     address _spender,
530     uint _subtractedValue,
531     bytes _data
532   )
533     public
534     payable
535     returns (bool)
536   {
537     require(_spender != address(this));
538 
539     super.decreaseApproval(_spender, _subtractedValue);
540 
541     // solium-disable-next-line security/no-call-value
542     require(_spender.call.value(msg.value)(_data));
543 
544     return true;
545   }
546 
547 }
548 
549 contract BitScreenerToken is ERC827Token, MultiOwnable {
550   string public name = 'BitScreenerToken';
551   string public symbol = 'BITX';
552   uint8 public decimals = 18;
553   uint256 public totalSupply;
554   address public owner;
555 
556   bool public allowTransfers = false;
557   bool public issuanceFinished = false;
558 
559   event AllowTransfersChanged(bool _newState);
560   event Issue(address indexed _to, uint256 _value);
561   event Burn(address indexed _from, uint256 _value);
562   event IssuanceFinished();
563 
564   modifier transfersAllowed() {
565     require(allowTransfers);
566     _;
567   }
568 
569   modifier canIssue() {
570     require(!issuanceFinished);
571     _;
572   }
573 
574   constructor(address[] _owners) public {
575     _setOwners(_owners);
576   }
577 
578   /**
579   * @dev Enable/disable token transfers. Can be called only by owners
580   * @param _allowTransfers True - allow False - disable
581   */
582   function setAllowTransfers(bool _allowTransfers) external onlyOwner {
583     allowTransfers = _allowTransfers;
584     emit AllowTransfersChanged(_allowTransfers);
585   }
586 
587   function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
588     return super.transfer(_to, _value);
589   }
590 
591   function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
592     return super.transferFrom(_from, _to, _value);
593   }
594 
595   function transferAndCall(address _to, uint256 _value, bytes _data) public payable transfersAllowed returns (bool) {
596     return super.transferAndCall(_to, _value, _data);
597   }
598 
599   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public payable transfersAllowed returns (bool) {
600     return super.transferFromAndCall(_from, _to, _value, _data);
601   }
602 
603   /**
604   * @dev Issue tokens to specified wallet
605   * @param _to Wallet address
606   * @param _value Amount of tokens
607   */
608   function issue(address _to, uint256 _value) external onlyOwner canIssue returns (bool) {
609     totalSupply = totalSupply.add(_value);
610     balances[_to] = balances[_to].add(_value);
611     emit Issue(_to, _value);
612     emit Transfer(address(0), _to, _value);
613     return true;
614   }
615 
616   /**
617   * @dev Finish token issuance
618   * @return True if success
619   */
620   function finishIssuance() public onlyOwner returns (bool) {
621     issuanceFinished = true;
622     emit IssuanceFinished();
623     return true;
624   }
625 
626   /**
627   * @dev Burn tokens
628   * @param _value Amount of tokens to burn
629   */
630   function burn(uint256 _value) external {
631     require(balances[msg.sender] >= _value);
632     totalSupply = totalSupply.sub(_value);
633     balances[msg.sender] = balances[msg.sender].sub(_value);
634     emit Transfer(msg.sender, address(0), _value);
635     emit Burn(msg.sender, _value);
636   }
637 }