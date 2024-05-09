1 /**
2  * ┌───┐░░░┌┐░┌─┐┌─┐░░░░░┌┐░░░░░
3  * │┌──┘░░░││░││└┘││░░░░┌┘└┐░░░░
4  * │└──┬┐┌┬┤│░│┌┐┌┐├──┬─┼┐┌┼┐░┌┐
5  * │┌──┤└┘├┤│░││││││┌┐│┌┘││││░││
6  * │└──┼┐┌┤│└┐││││││└┘││░│└┤└─┘│
7  * └───┘└┘└┴─┘└┘└┘└┴──┴┘░└─┴─┐┌┘
8  * ░░░░░░░░░░░░░░░░░░░░░░░░┌─┘│░
9  * ░░░░░░░░░░░░░░░░░░░░░░░░└──┘░
10  * 
11  * The circulating currency.
12  */
13 pragma solidity ^0.4.23;
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address _newOwner) public onlyOwner {
60     _transferOwnership(_newOwner);
61   }
62 
63   /**
64    * @dev Transfers control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function _transferOwnership(address _newOwner) internal {
68     require(_newOwner != address(0));
69     emit OwnershipTransferred(owner, _newOwner);
70     owner = _newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title AdminUtils
77  * @dev customized admin control panel
78  * @dev just want to keep everything safe
79  */
80 contract AdminUtils is Ownable {
81 
82     mapping (address => uint256) adminContracts;
83 
84     address internal root;
85 
86     /* modifiers */
87     modifier OnlyContract() {
88         require(isSuperContract(msg.sender));
89         _;
90     }
91 
92     modifier OwnerOrContract() {
93         require(msg.sender == owner || isSuperContract(msg.sender));
94         _;
95     }
96 
97     modifier onlyRoot() {
98         require(msg.sender == root);
99         _;
100     }
101 
102     /* constructor */
103     constructor() public {
104         // This is a safe key stored offline
105         root = 0xe07faf5B0e91007183b76F37AC54d38f90111D40;
106     }
107 
108     /**
109      * @dev really??? you wanna send us free money???
110      */
111     function ()
112         public
113         payable {
114     }
115 
116     /**
117      * @dev this is the kickass idea from @dan
118      * and well we will see how it works
119      */
120     function claimOwnership()
121         external
122         onlyRoot
123         returns (bool) {
124         owner = root;
125         return true;
126     }
127 
128     /**
129      * @dev function to address a super contract address
130      * some functions are meant to be called from another contract
131      * but not from any contracts
132      * @param _address A contract address
133      */
134     function addContractAddress(address _address)
135         public
136         onlyOwner
137         returns (bool) {
138 
139         uint256 codeLength;
140 
141         assembly {
142             codeLength := extcodesize(_address)
143         }
144 
145         if (codeLength == 0) {
146             return false;
147         }
148 
149         adminContracts[_address] = 1;
150         return true;
151     }
152 
153     /**
154      * @dev remove the contract address as a super user role
155      * have it here just in case
156      * @param _address A contract address
157      */
158     function removeContractAddress(address _address)
159         public
160         onlyOwner
161         returns (bool) {
162 
163         uint256 codeLength;
164 
165         assembly {
166             codeLength := extcodesize(_address)
167         }
168 
169         if (codeLength == 0) {
170             return false;
171         }
172 
173         adminContracts[_address] = 0;
174         return true;
175     }
176 
177     /**
178      * @dev check contract eligibility
179      * @param _address A contract address
180      */
181     function isSuperContract(address _address)
182         public
183         view
184         returns (bool) {
185 
186         uint256 codeLength;
187 
188         assembly {
189             codeLength := extcodesize(_address)
190         }
191 
192         if (codeLength == 0) {
193             return false;
194         }
195 
196         if (adminContracts[_address] == 1) {
197             return true;
198         } else {
199             return false;
200         }
201     }
202 }
203 
204 /**
205  * @title SafeMath
206  * @dev Math operations with safety checks that throw on error
207  */
208 library SafeMath {
209 
210     /**
211     * @dev Multiplies two numbers, throws on overflow.
212     */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
214         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
215         // benefit is lost if 'b' is also tested.
216         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
217         if (a == 0) {
218             return 0;
219         }
220 
221         c = a * b;
222         assert(c / a == b);
223         return c;
224     }
225 
226     /**
227     * @dev Integer division of two numbers, truncating the quotient.
228     */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         // assert(b > 0); // Solidity automatically throws when dividing by 0
231         // uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233         return a / b;
234     }
235 
236     /**
237     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
238     */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         assert(b <= a);
241         return a - b;
242     }
243 
244     /**
245     * @dev Adds two numbers, throws on overflow.
246     */
247     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
248         c = a + b;
249         assert(c >= a);
250         return c;
251     }
252 }
253 
254 /**
255  * @title ERC20
256  * @dev StandardToken.
257  */
258 contract ERC20 is AdminUtils {
259 
260     using SafeMath for uint256;
261 
262     event Transfer(address indexed from, address indexed to, uint256 value);
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 
265     mapping(address => uint256) balances;
266     mapping (address => mapping (address => uint256)) internal allowed;
267 
268     uint256 totalSupply_;
269 
270     /**
271     * @dev total number of tokens in existence
272     */
273     function totalSupply() public view returns (uint256) {
274         return totalSupply_;
275     }
276 
277     /**
278     * @dev transfer token for a specified address
279     * @param _to The address to transfer to.
280     * @param _value The amount to be transferred.
281     */
282     function transfer(address _to, uint256 _value) public returns (bool) {
283         require(_to != address(0));
284         require(_value <= balances[msg.sender]);
285 
286         balances[msg.sender] = balances[msg.sender].sub(_value);
287         balances[_to] = balances[_to].add(_value);
288         emit Transfer(msg.sender, _to, _value);
289         return true;
290     }
291 
292     /**
293     * @dev Gets the balance of the specified address.
294     * @param _owner The address to query the the balance of.
295     * @return An uint256 representing the amount owned by the passed address.
296     */
297     function balanceOf(address _owner) public view returns (uint256) {
298         return balances[_owner];
299     }
300 
301     /**
302      * @dev Transfer tokens from one address to another
303      * @param _from address The address which you want to send tokens from
304      * @param _to address The address which you want to transfer to
305      * @param _value uint256 the amount of tokens to be transferred
306      */
307     function transferFrom(
308         address _from,
309         address _to,
310         uint256 _value
311     )
312         public
313         returns (bool)
314     {
315         require(_to != address(0));
316         require(_value <= balances[_from]);
317         require(_value <= allowed[_from][msg.sender]);
318 
319         balances[_from] = balances[_from].sub(_value);
320         balances[_to] = balances[_to].add(_value);
321         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
322         emit Transfer(_from, _to, _value);
323         return true;
324     }
325 
326     /**
327      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328      *
329      * Beware that changing an allowance with this method brings the risk that someone may use both the old
330      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333      * @param _spender The address which will spend the funds.
334      * @param _value The amount of tokens to be spent.
335      */
336     function approve(address _spender, uint256 _value) public returns (bool) {
337         allowed[msg.sender][_spender] = _value;
338         emit Approval(msg.sender, _spender, _value);
339         return true;
340     }
341 
342     /**
343      * @dev Function to check the amount of tokens that an owner allowed to a spender.
344      * @param _owner address The address which owns the funds.
345      * @param _spender address The address which will spend the funds.
346      * @return A uint256 specifying the amount of tokens still available for the spender.
347      */
348     function allowance(
349         address _owner,
350         address _spender
351      )
352         public
353         view
354         returns (uint256)
355     {
356         return allowed[_owner][_spender];
357     }
358 
359     /**
360      * @dev Increase the amount of tokens that an owner allowed to a spender.
361      *
362      * approve should be called when allowed[_spender] == 0. To increment
363      * allowed value is better to use this function to avoid 2 calls (and wait until
364      * the first transaction is mined)
365      * From MonolithDAO Token.sol
366      * @param _spender The address which will spend the funds.
367      * @param _addedValue The amount of tokens to increase the allowance by.
368      */
369     function increaseApproval(
370         address _spender,
371         uint _addedValue
372     )
373         public
374         returns (bool)
375     {
376         allowed[msg.sender][_spender] = (
377             allowed[msg.sender][_spender].add(_addedValue));
378         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379         return true;
380     }
381 
382     /**
383      * @dev Decrease the amount of tokens that an owner allowed to a spender.
384      *
385      * approve should be called when allowed[_spender] == 0. To decrement
386      * allowed value is better to use this function to avoid 2 calls (and wait until
387      * the first transaction is mined)
388      * From MonolithDAO Token.sol
389      * @param _spender The address which will spend the funds.
390      * @param _subtractedValue The amount of tokens to decrease the allowance by.
391      */
392     function decreaseApproval(
393         address _spender,
394         uint _subtractedValue
395     )
396         public
397         returns (bool)
398     {
399         uint oldValue = allowed[msg.sender][_spender];
400         if (_subtractedValue > oldValue) {
401             allowed[msg.sender][_spender] = 0;
402         } else {
403             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
404         }
405         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
406         return true;
407     }
408 
409     function withdraw()
410         public
411         onlyOwner {
412         msg.sender.transfer(address(this).balance);
413     }
414 
415 }
416 
417 /**
418  * @title Contract that will work with ERC223 tokens.
419  */
420 contract ERC223ReceivingContract { 
421 /**
422  * @dev Standard ERC223 function that will handle incoming token transfers.
423  *
424  * @param _from  Token sender address.
425  * @param _value Amount of tokens.
426  * @param _data  Transaction metadata.
427  */
428     function tokenFallback(address _from, uint _value, bytes _data) public;
429 }
430 
431 /**
432  * @title ERC223
433  * @dev Standard ERC223 token.
434  */
435 contract ERC223 is ERC20 {
436 
437     /**
438      * @dev Transfer the specified amount of tokens to the specified address.
439      *      Invokes the `tokenFallback` function if the recipient is a contract.
440      *      The token transfer fails if the recipient is a contract
441      *      but does not implement the `tokenFallback` function
442      *      or the fallback function to receive funds.
443      *
444      * @param _to    Receiver address.
445      * @param _value Amount of tokens that will be transferred.
446      */
447     function transfer(address _to, uint256 _value)
448         public
449         returns (bool) {
450         require(_to != address(0));
451         require(_value <= balances[msg.sender]);
452 
453         bytes memory empty;
454         uint256 codeLength;
455 
456         assembly {
457             // Retrieve the size of the code on target address, this needs assembly .
458             codeLength := extcodesize(_to)
459         }
460 
461         balances[msg.sender] = balances[msg.sender].sub(_value);
462         balances[_to] = balances[_to].add(_value);
463         if(codeLength > 0) {
464             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
465             receiver.tokenFallback(msg.sender, _value, empty);
466         }
467         emit Transfer(msg.sender, _to, _value);
468         return true;
469     }
470 
471     /**
472      * @dev you get the idea
473      * this is the same transferFrom function in ERC20
474      * except it calls a token fallback function if the
475      * receiver is a contract
476      */
477     function transferFrom(
478         address _from,
479         address _to,
480         uint256 _value)
481         public
482         returns (bool) {
483         require(_to != address(0));
484         require(_value <= balances[_from]);
485         require(_value <= allowed[_from][msg.sender]);
486 
487         bytes memory empty;
488         uint256 codeLength;
489 
490         assembly {
491             // Retrieve the size of the code on target address, this needs assembly .
492             codeLength := extcodesize(_to)
493         }
494 
495         balances[_from] = balances[_from].sub(_value);
496 
497         if(codeLength > 0) {
498             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
499             receiver.tokenFallback(msg.sender, _value, empty);
500         }
501 
502         balances[_to] = balances[_to].add(_value);
503         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
504         emit Transfer(_from, _to, _value);
505         return true;
506     }
507 
508 }
509 
510 /* 
511 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::..==========.:::::::::::::::::::::::::::::::::::::::::
512 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::,..,:::.~======,::::::::::::::::::::::::::::::::::::::::::
513 :::::::::::::::::::::::::::::::::::::::::::::::::::,....,:::::::::::::...===~,::::::::::::::::::::::::::::::::::::::::::
514 :::::::::::::::::::::::::::::::::::::::::::::,..:::::::::::::::::::::::::::..:::::::::::::::::::::::::::::::::::::::::::
515 :::::::::::::::::::::::::::::::::::::::::,.:::::::::::::::::::::::::::::::::::.,::::::::::::::::::::::::::::::::::::::::
516 :::::::::::::::::::::::::::::::::::::::.::::::::::::::::::::::::::::::::::::::::,.,:::::::::::::::::::::::::::::::::::::
517 ::::::::::::::::::::::::::::......:::.::::::::::::::::::::::::::::::::::::::::::::::..::::::::::::::::::::::::::::::::::
518 ::::::::::::::::::::::::::.,,,,,,,,.:::::::::::::::::::::::::::::::::::::::::::::::::::,.:::::::::::::::::::::::::::::::
519 ::::::::::::::::::::::::..,,,,,,,.,:::::::::::::::::::::::::::::::::::::::::::::::::::::::,.,:::::::::::::::::::::::::::
520 :::::::::::::::::::::::.:~~~.,,.::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.,::::::::::::::::::::::::
521 :::::::::::::::::::::::,~~~~~.,::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.::::::::::::::::::::::
522 :::::::::::::::::::::::,~~~~.::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.::::::::::::::::::::
523 :::::::::::::::::::::::.~~~.::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.:::::::::::::::::::
524 ::::::::::::::::::::::::,~.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.:::::::::::::::::
525 ::::::::::::::::::::::::,.:::::::::::::::::::::,...,~+?I?+:...,::::::::::::::::::::::::::::::::::::::::.::::::::::::::::
526 :::::::::::::::::::::::::.:::::::::::::..,~?IIIIIIIIIIIIIIIIIIIII=..::::::::::::::::::::::::::::::::::::.:::::::::::::::
527 :::::::::::::::::::::::::,::::::::,.~IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII:.:::::::::::::::::::::::::::::::::.::::::::::::::
528 ::::::::::::::::::::::::,:::::::.+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+.,::::::::::::::::::::::::::::::.:::::::::::::
529 ::::::::::::::::::::::::,::::,:?=,=IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?.,::::::::::::::::::::::::::::.::::::::::::
530 :::::::::::::::::::::::::::..~IIIIIIIIIIIIIIIIIIIIIIIIIIIIII~.+IIIIIIIIIIIIIIII+.:::::::::::::::::::::::::::,,::::::::::
531 :::::::::::::::::::::::::.:IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?.+IIIIIIIIIIIIIII?.::::::::::::::::::::::::::,::::::::::
532 ::::::::::::::::::::::::.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII:,IIIIIIIIIIIIIIII.:::::::::::::::::::::::::.:::::::::
533 ::::::::::::::::::::::::IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+.IIIIIIIIIIIIIII?.::::::::::::::::::::::::.::::::::
534 :::::::::::::::::::::.?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?.IIIIIIIIIIIIIII.::::::::::::::::::::::::.:::::::
535 ::::::::::::::::..~+I?=,.+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII~?IIIIIIIIIIIIII?.::::::::::::::::::::::::::::::
536 :::::::::::::.I77777777777I.+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.::::::::::::::::::::::.::::::
537 :::::::::::.77777777777777777:=IIIIIIIIIIIIIIIIIIIIIIII+:....,=IIIIIIIIIIIIIIIIIIIIIIIIIIII~,:::::::::::::::::::::,:::::
538 :::::::::,+77777777777777777777.IIIIIIIIIIIIIIIIIII:,I7777777777I,=IIIIIIIIIIIIIIIIIIIIIIIII+:::::::::::::::::::::.:::::
539 ::::::::.77777777777777777777777.IIIIIIIIIIIIIII~,77777777777777777?.IIIIIIIIIIIIIIIIIIIIIIII,::::::::::::::::::::.:::::
540 :::::::,I777777777777777777777777=IIIIIIIIIIII=:777777777777777777777I,IIIIIIIIIIIIIIIIIIIIIII.:::::::::::::::::::,:::::
541 ::::::::7777777777777777777777777,IIIIIIIIIII:7777777777777777777777777:?IIIIIIIIIIIIIIIIIIIIII.:::::::::::::::::::,::::
542 ::::::.77777777777777777777777777I=IIIIIIIII,777777777777777777777777777I?IIIIIIIIIIIIIIIIIIIIII.::::::::::::::::::,::::
543 ::::::.777777777777..~777777777777.IIIIIIII~77777777777777777777777777777=?IIIIIIIIIIIIIIIIIIIII~::::::::::::::::::.::::
544 ::::::=777777777777777777777777777.IIIIIIII:777777777777777777777777777777.IIIIIIIIIIIIIIIIIIIIII.:::::::::::::::::.::::
545 ::::::I777777777777777777777777777,IIIIIII:77777777777777777777777777777777~IIIIIIIIIIIIIIIIIIIII?,::::::::::::::::.::::
546 ::::::I777777777777777777777777777.IIIIIII.7777777777777,..7777777777777777.IIIIIIIIIIIIIIIIIIIIII.::::::::::::::::.::::
547 ::::::~777777777777777777777777777.IIIIIII:7777777777777~.,7777777777777777:IIIIIIIIIIIIIIIIIIIIII?,:::::::::::::::.::::
548 ::::,,.77777777777777777777777777?+IIIIIII:77777777777777777777777777777777=IIIIIIIIIIIIIIIIIIIIIII.:::::::::::::::.....
549 ~~~~~~:I7777777777777777777777777.IIIIIIII.77777777777777777777777777777777~IIIIIIIIIIIIIIIIIIIIIII~:::::::::::::::.~~~~
550 ~~~~~~~.777777777777777777777777=IIIIIIIII,77777777777777777777777777777777,IIIIIIIIIIIIIIIIIIIIIII?:::::::::::::::.~~~~
551 ~~~~~~~~.7777777777777777777777~?IIIIIIIII?=7777777777777777777777777777777.IIIIIIIIIIIIIIIIIIIIIIII,::::::::::::::.~~~~
552 ~~~~~~~~.~=7777777777777777777.IIIIIIIIIIII,777777777777777777777777777777I+IIIIIIIIIIIIIIIIIIIIIIII.::::::::::::::.~~~~
553 ~~~~~~~~=II=:77777777777777+.IIIIIIIIIIIIIII,77777777777777777777777777777.IIIIIIIIIIIIIIIIIIIIIIIII.::::::::::::::,~~~~
554 ~~~~~~~:?IIIII..I7777777:.?IIIIIIIIIIIIIIIIII,777777777777777777777777777.IIIIIIIIIIIIIIIIIIIIIIIIII.:::::::::::::::,~~~
555 ~~~~~~~,IIIIIIIIIIIIIIIIIIIIII?.?IIIIIIIIIIIII~+777777777777777777777777.IIIIIIIIIIIIIIIIIIIIIIIIIII,:::::::::::::::,~~~
556 ~~~~~~~.IIIIIIIIIIIIIIIIIIII?.?IIIIIIIIIIIIIIIII,~77777777777777777777:=IIIIIIIIIIIIIIIIIIIIIIIIIIII,::::::::::::::::~~~
557 ~~~~~~~.IIIIIIIIIIIIIIIIIII.?IIIIIIIIIIIIIIIIIIIII?.=77777777777777I.+IIIIIIIIIIIIIIIIIIIIIIIIIIIIII,::::::::::::::.~~~~
558 ~~~~~~~.IIIIIIIIIIIIIIIIII~?IIIIIIIIIIIIIIIIIIIIIIIIII+,.:?I77?~.,?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.::::::::::::::,~~~~
559 ~~~~~~~,IIIIIIIIIIIIIIIIII?+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.:::::::::::::.~~~~~
560 ~~~~~~~:?IIIIIIIIIIIIIIIIII=~IIII=.~IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.::::::::::::,~~~~~~
561 ~~~~~~~~:IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII,::::::::::,,~~~~~~~
562 ~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII~.+I?::::::::::.~~~~~~~~~
563 ~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII:.:::::::::.~~~~~~~~~~
564 ~~~~~~~~~~IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?,:::::::::~~~~~~~~~~
565 ~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=:::::::.~~~~~~~~~~~
566 ~~~~~~~~~:+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.:::::.~~~~~~~~~~~~
567 ~~~~~~~~~~.IIIIIIIIII.?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.::::.~~~~~~~~~~~~~
568 ~~~~~~~~~~~:IIIIIIIIIII,.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.:::.~~~~~~~~~~~~~~
569 ~~~.~~~~~~~:+IIIIIIIIIIIII+,.=?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?,,.~~~~~~~~~~~~~~~~
570 ~~~,~~~~~~~~,IIIIIIIIIIIIIIIIIII?=:............~+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~~~~~~~~~~~~~~~~~
571 ~~~~.~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~~~~~~~~~~~~~~~~~~
572 ~~~~.~~~~~~~~~.?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.:~~~~~~~~~~~~~~~~~~~~~
573 ~~~~,~~~~~~~~~~:=IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=..,,..:~~~~~~~~~~~~~~~~~~~~~~~~
574 ~~~~:,~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII~:~~~~~~~~~~~~~~~~~~~~~~~~~~~~
575 ~~~~~.~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
576 ~~~~~.~~~~~~~~~~~~~,?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
577 ~~~~~.~~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
578 ~~~~~~~~~~~~~~~~~~~~~~.+IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
579 ~~~~~~,~~~~~~~~~~~~~~~~~.?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
580 ~~~~~~.~~~~~~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
581 ~~~~~~.~~~~~~~~~~~~~~~~~~~~~..?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?.,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
582 ~~~~~~.~~~~~~~~~~~~~~~~~~~~,III?,.?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII:.+=,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
583 ~~~~~~:~~~~~~~~~~~~~~~~~~~,IIIIIIIII~.,+IIIIIIIIIIIIIIIIIIIIIIIIIIIII+,.+IIIIII.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
584 ~~~~~~~:~~~~~~~~~~~~~~~~~.IIIIIIIIIIIIIII??+~:,.................,~+?IIIIIIIIIIII,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
585 ~~~~~~~.~~~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?.~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
586 ~~~~~~~.~~~~~~~~~~~~~~~,?IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
587 ~~~~~~~.~~~~~~~~~~~~~~:=IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?,~~~~,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
588 ~~~~~~~.~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
589 ~~~~~~~:~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
590 ~~~~~~~~~~~~~~~~~~~~~=IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
591 ~~~~~~~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
592 ~~~~~~~~~~~~~~~~~~~~IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
593 ~~~~~~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+:~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
594 ~~~~~~~~~~~~~~~~~~~=IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII.~,~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
595 ~~~~~~~~~~~~~~~~~~.IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?:::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
596  */
597 
598 /**
599  * @title EvilMorty
600  * @dev secret: 79c9b9df0405a75d72e3f17fb484821ef3ba426bdc1d3b9805c92f29
601  */
602 contract EvilMorty is ERC223 {
603 
604     string public constant name = "Evil Morty";
605     string public constant symbol = "Morty";
606     uint8 public constant decimals = 18;
607 
608     uint256 public constant INITIAL_SUPPLY = 1000000000e18;
609     uint256 public constant GAME_SUPPLY = 200000000e18;
610     uint256 public constant COMMUNITY_SUPPLY = 800000000e18;
611 
612     address public citadelAddress;
613 
614     /* constructor */
615     constructor()
616         public {
617 
618         totalSupply_ = INITIAL_SUPPLY;
619 
620         // owners get 200 million locked
621         // and 200 million for second round crowdsale supply
622         // and 400 million for building the microverse
623         balances[owner] = COMMUNITY_SUPPLY;
624         emit Transfer(0x0, owner, COMMUNITY_SUPPLY);
625     }
626 
627     /**
628      * @dev for mouting microverse contract
629      * @param _address Microverse's address
630      */
631     function mountCitadel(address _address)
632         public
633         onlyOwner
634         returns (bool) {
635         
636         uint256 codeLength;
637 
638         assembly {
639             codeLength := extcodesize(_address)
640         }
641 
642         if (codeLength == 0) {
643             return false;
644         }
645 
646         citadelAddress = _address;
647         balances[citadelAddress] = GAME_SUPPLY;
648         emit Transfer(0x0, citadelAddress, GAME_SUPPLY);
649         addContractAddress(_address);
650 
651         return true;
652     }
653 
654     /**
655      * @dev special transfer method for Microverse
656      * Because there are other contracts making transfer on behalf of Microverse,
657      * we need this special function, used for super contracts or owner.
658      * @param _to receiver's address
659      * @param _value amount of morties to transfer
660      */
661     function citadelTransfer(address _to, uint256 _value)
662         public
663         OwnerOrContract
664         returns (bool) {
665         require(_to != address(0));
666         require(_value <= balances[citadelAddress]);
667 
668         bytes memory empty;
669 
670         uint256 codeLength;
671 
672         assembly {
673             // Retrieve the size of the code on target address, this needs assembly .
674             codeLength := extcodesize(_to)
675         }
676 
677         balances[citadelAddress] = balances[citadelAddress].sub(_value);
678         balances[_to] = balances[_to].add(_value);
679 
680         if(codeLength > 0) {
681             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
682             receiver.tokenFallback(citadelAddress, _value, empty);
683         }
684         emit Transfer(citadelAddress, _to, _value);
685         return true;
686     }
687 
688     /**
689      * @dev checks the Microverse contract's balance
690      * so other contracts won't bother remembering Microverse's address
691      */
692     function citadelBalance()
693         public
694         view
695         returns (uint256) {
696         return balances[citadelAddress];
697     }
698 }