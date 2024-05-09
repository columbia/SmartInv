1 pragma solidity ^0.5.11;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract ERC223Interface {
37     uint public totalSupply;
38     function balanceOf(address who) public view returns (uint);
39     function transfer(address to, uint value) public returns (bool success);
40     function transfer(address to, uint value, bytes memory data) public returns (bool success);
41     event Transfer(address indexed from, address indexed to, uint value, bytes data);
42     event Transfer(address indexed from, address indexed to, uint value);
43 }
44 
45 
46 /**
47  * @title Contract that will work with ERC223 tokens.
48  * source: https://github.com/ethereum/EIPs/issues/223
49  */
50 interface ERC223ReceivingContract {
51     /**
52      * @dev Standard ERC223 function that will handle incoming token transfers.
53      *
54      * @param from  Token sender address.
55      * @param value Amount of tokens.
56      * @param data  Transaction metadata.
57      */
58     function tokenFallback( address from, uint value, bytes calldata data ) external;
59 }
60 
61 
62 /**
63  * @title Ownership
64  * @author Prashant Prabhakar Singh
65  * @dev Contract that allows to hande ownership of contract
66  */
67 contract Ownership {
68 
69     address public owner;
70     event LogOwnershipTransferred(address indexed oldOwner, address indexed newOwner);
71 
72 
73     constructor() public {
74         owner = msg.sender;
75         emit LogOwnershipTransferred(address(0), owner);
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner, "Only owner is allowed");
80         _;
81     }
82 
83     /**
84      * @dev Transfers ownership of contract to other address
85      * @param _newOwner address The address of new owner
86      */
87     function transferOwnership(address _newOwner)
88         public
89         onlyOwner
90     {
91         require(_newOwner != address(0), "Zero address not allowed");
92         address oldOwner = owner;
93         owner = _newOwner;
94         emit LogOwnershipTransferred(oldOwner, _newOwner);
95     }
96 
97     /**
98      * @dev Removes owner from the contract.
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      * @param _code uint that prevents accidental calling of the function
102      */
103     function renounceOwnership(uint _code)
104       public
105       onlyOwner
106     {
107         require(_code == 1234567890, "Invalid code");
108         owner = address(0);
109         emit LogOwnershipTransferred(owner, address(0));
110     }
111 
112 }
113 
114 /**
115  * @title Freezable
116  * @author Prashant Prabhakar Singh
117  * @dev Contract that allows freezing/unfreezing an address or complete contract
118  */
119 contract Freezable is Ownership {
120 
121     bool public emergencyFreeze;
122     mapping(address => bool) public frozen;
123 
124     event LogFreezed(address indexed target, bool freezeStatus);
125     event LogEmergencyFreezed(bool emergencyFreezeStatus);
126 
127     modifier unfreezed(address _account) {
128         require(!frozen[_account], "Account is freezed");
129         _;
130     }
131 
132     modifier noEmergencyFreeze() {
133         require(!emergencyFreeze, "Contract is emergency freezed");
134         _;
135     }
136 
137     /**
138      * @dev Freezes or unfreezes an addreess
139      * this does not check for previous state before applying new state
140      * @param _target the address which will be feeezed.
141      * @param _freeze boolean status. Use true to freeze and false to unfreeze.
142      */
143     function freezeAccount (address _target, bool _freeze)
144         public
145         onlyOwner
146     {
147         require(_target != address(0), "Zero address not allowed");
148         frozen[_target] = _freeze;
149         emit LogFreezed(_target, _freeze);
150     }
151 
152    /**
153      * @dev Freezes or unfreezes the contract
154      * this does not check for previous state before applying new state
155      * @param _freeze boolean status. Use true to freeze and false to unfreeze.
156      */
157     function emergencyFreezeAllAccounts (bool _freeze)
158         public
159         onlyOwner
160     {
161         emergencyFreeze = _freeze;
162         emit LogEmergencyFreezed(_freeze);
163     }
164 }
165 
166 
167 /**
168  * @title Standard Token
169  * @author Prashant Prabhakar Singh
170  * @dev A Standard Token contract that follows ERC-223 standard
171  */
172 contract StandardToken is ERC223Interface, Freezable {
173 
174     using SafeMath for uint;
175 
176     string public name;
177     string public symbol;
178     uint public decimals;
179     uint public totalSupply;
180     uint public maxSupply;
181 
182     mapping(address => uint) internal balances;
183     mapping(address => mapping(address => uint)) private  _allowed;
184 
185     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
186 
187     constructor () public {
188         name = 'CNEXCHANGE';
189         symbol = 'CNEX';
190         decimals = 8;
191         maxSupply = 400000000 * ( 10 ** decimals ); // 400 million
192     }
193 
194     /**
195      * @dev Transfer the specified amount of tokens to the specified address.
196      *      Invokes the `tokenFallback` function if the recipient is a contract.
197      *      The token transfer fails if the recipient is a contract
198      *      but does not implement the `tokenFallback` function
199      *      or the fallback function to receive funds.
200      *
201      *   Compitable wit ERC-20 Standard
202      *
203      * @param _to    Receiver address.
204      * @param _value Amount of tokens that will be transferred.
205      */
206     function transfer(address _to, uint _value)
207         public
208         unfreezed(_to)
209         unfreezed(msg.sender)
210         noEmergencyFreeze()
211         returns (bool success)
212     {
213         bytes memory _data;
214         _transfer223(msg.sender, _to, _value, _data);
215         return true;
216     }
217 
218     /**
219      * @dev Transfer the specified amount of tokens to the specified address.
220      *      Invokes the `tokenFallback` function if the recipient is a contract.
221      *      The token transfer fails if the recipient is a contract
222      *      but does not implement the `tokenFallback` function
223      *      or the fallback function to receive funds.
224      *
225      * @param _to    Receiver address.
226      * @param _value Amount of tokens that will be transferred.
227      * @param _data  Transaction metadata.
228      */
229     function transfer(address _to, uint _value, bytes memory _data)
230         public
231         unfreezed(_to)
232         unfreezed(msg.sender)
233         noEmergencyFreeze()
234         returns (bool success)
235     {
236         _transfer223(msg.sender, _to, _value, _data);
237         return true;
238     }
239 
240     /**
241      * @dev Utility method to check if an address is contract address
242      *
243      * @param _addr address which is being checked.
244      * @return true if address belongs to a contract else returns false
245      */
246     function isContract(address _addr )
247         private
248         view
249         returns (bool)
250     {
251         uint length;
252         assembly { length := extcodesize(_addr) }
253         return (length > 0);
254     }
255 
256     /**
257      * @dev To change the approve amount you first have to reduce the addresses
258      * allowance to zero by calling `approve(_spender, 0)` if it is not
259      * already 0 to mitigate the race condition described here
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      * Recommended is to use increase approval and decrease approval instead
262      *
263      * Requires either that _value of allwance is 0
264      * @param _spender address who is allowed to spend
265      * @param _value the no of tokens spender can spend
266      * @return true if everything goes well
267      */
268     function approve(address _spender, uint _value)
269         public
270         unfreezed(_spender)
271         unfreezed(msg.sender)
272         noEmergencyFreeze()
273         returns (bool success)
274     {
275         require((_value == 0) || (_allowed[msg.sender][_spender] == 0), "Approval needs to be 0 first");
276         require(_spender != msg.sender, "Can not approve to self");
277         _allowed[msg.sender][_spender] = _value;
278         emit Approval(msg.sender, _spender, _value);
279         return true;
280     }
281 
282     /**
283      * @dev increases current allowance
284      *
285      * @param _spender address who is allowed to spend
286      * @param _addedValue the no of tokens added to previous allowance
287      * @return true if everything goes well
288      */
289     function increaseApproval(address _spender, uint _addedValue)
290         public
291         unfreezed(_spender)
292         unfreezed(msg.sender)
293         noEmergencyFreeze()
294         returns (bool success)
295     {
296         require(_spender != msg.sender, "Can not approve to self");
297         _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(_addedValue);
298         emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
299         return true;
300     }
301 
302     /**
303      * @dev decrease current allowance
304      * @param _spender address who is allowed to spend
305      * @param _subtractedValue the no of tokens deducted to previous allowance
306      * If _subtractedValue is greater than prev allowance, allowance becomes 0
307      * @return true if everything goes well
308      */
309     function decreaseApproval(address _spender, uint _subtractedValue)
310         public
311         unfreezed(_spender)
312         unfreezed(msg.sender)
313         noEmergencyFreeze()
314         returns (bool success)
315     {
316         require(_spender != msg.sender, "Can not approve to self");
317         uint oldAllowance = _allowed[msg.sender][_spender];
318         if (_subtractedValue > oldAllowance) {
319             _allowed[msg.sender][_spender] = 0;
320         } else {
321             _allowed[msg.sender][_spender] = oldAllowance.sub(_subtractedValue);
322         }
323         emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
324         return true;
325     }
326 
327     /**
328      * @dev Transfer tokens from one address to another.
329      * @param _from address The address from which you want to send tokens.
330      * @param _to address The address to which you want to transfer tokens.
331      * @param _value uint256 the amount of tokens to be transferred.
332      */
333     function transferFrom(address _from, address _to, uint _value)
334         public
335         unfreezed(_to)
336         unfreezed(msg.sender)
337         unfreezed(_from)
338         noEmergencyFreeze()
339         returns (bool success)
340     {
341         require(_value <= _allowed[_from][msg.sender], "Insufficient allowance");
342         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
343         bytes memory _data;
344         _transfer223(_from, _to, _value, _data);
345         return true;
346     }
347 
348     /**
349      * @dev Transfer tokens from one address to another.
350      * @param _from address The address from which you want to send tokens.
351      * @param _to address The address to which you want to transfer tokens.
352      * @param _value uint256 the amount of tokens to be transferred
353      * @param _data bytes Transaction metadata.
354      */
355     function transferFrom(address _from, address _to, uint _value, bytes memory _data)
356         public
357         unfreezed(_to)
358         unfreezed(msg.sender)
359         unfreezed(_from)
360         noEmergencyFreeze()
361         returns (bool success)
362     {
363         require(_value <= _allowed[_from][msg.sender], "Insufficient allowance");
364         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
365         _transfer223(_from, _to, _value, _data);
366         return true;
367     }
368 
369 
370     /**
371      * @dev Function that burns an amount of the token of a sender.
372      * reduces total and max supply.
373      * only owner is allowed to burn tokens.
374      *
375      * @param _value The amount that will be burn.
376      */
377     function burn(uint256 _value)
378         public
379         unfreezed(msg.sender)
380         noEmergencyFreeze()
381         onlyOwner
382         returns (bool success)
383     {
384         require(balances[msg.sender] >= _value, "Insufficient balance");
385         balances[msg.sender] = balances[msg.sender].sub(_value);
386         totalSupply = totalSupply.sub(_value);
387         bytes memory _data;
388         emit Transfer(msg.sender, address(0), _value, _data);
389         emit Transfer(msg.sender, address(0), _value);
390         return true;
391     }
392 
393 
394     /**
395      * @dev Gets the balance of the specified address.
396      * @param _tokenOwner The address to query the balance of.
397      * @return A uint256 representing the amount owned by the passed address.
398      */
399     function balanceOf(address _tokenOwner) public view returns (uint) {
400         return balances[_tokenOwner];
401     }
402 
403     /**
404      * @dev Function to check the amount of tokens that an owner allowed to a spender.
405      * @param _tokenOwner address The address which owns the funds.
406      * @param _spender address The address which will spend the funds.
407      * @return A uint256 specifying the amount of tokens still available for the spender.
408      */
409     function allowance(address _tokenOwner, address _spender) public view returns (uint) {
410         return _allowed[_tokenOwner][_spender];
411     }
412 
413     /**
414      * @dev Function to withdraw any accidently sent ERC20 token.
415      * the value should be pre-multiplied by decimals of token wthdrawan
416      * @param _tokenAddress address The contract address of ERC20 token.
417      * @param _value uint amount to tokens to be withdrawn
418      */
419     function transferAnyERC20Token(address _tokenAddress, uint _value)
420         public
421         onlyOwner
422     {
423         ERC223Interface(_tokenAddress).transfer(owner, _value);
424     }
425 
426     /**
427      * @dev Transfer the specified amount of tokens to the specified address.
428      *      Invokes the `tokenFallback` function if the recipient is a contract.
429      *      The token transfer fails if the recipient is a contract
430      *      but does not implement the `tokenFallback` function
431      *      or the fallback function to receive funds.
432      *
433      * @param _from Sender address.
434      * @param _to    Receiver address.
435      * @param _value Amount of tokens that will be transferred.
436      * @param _data  Transaction metadata.
437      */
438     function _transfer223(address _from, address _to, uint _value, bytes memory _data)
439         private
440     {
441         require(_to != address(0), "Zero address not allowed");
442         require(balances[_from] >= _value, "Insufficient balance");
443         balances[_from] = balances[_from].sub(_value);
444         balances[_to] = balances[_to].add(_value);
445         if (isContract(_to)) {
446             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
447             receiver.tokenFallback(msg.sender, _value, _data);
448         }
449         emit Transfer(_from, _to, _value, _data); // ERC223-compat version
450         emit Transfer(_from, _to, _value); // ERC20-compat version
451     }
452 
453 }
454 
455 /**
456  * @title CNEX Token
457  * @author Prashant Prabhakar Singh
458  * @dev CNEX implementation of ERC-223 standard token
459  */
460 contract CNEXToken is StandardToken {
461 
462     uint public icoFunds;
463     uint public consumerProtectionFund;
464     uint public ecoSystemDevelopmentAndOperationFund;
465     uint public teamAndFounderFund;
466 
467     bool public consumerProtectionFundAllocated = false;
468     bool public ecoSystemDevelopmentAndOperationFundAllocated = false;
469     bool public teamAndFounderFundAllocated = false;
470 
471     uint public tokenDeploymentTime;
472 
473     constructor() public{
474         icoFunds = 200000000 * (10 ** decimals); // 200 million
475         consumerProtectionFund = 60000000 * (10 ** decimals); // 60 million
476         ecoSystemDevelopmentAndOperationFund = 100000000 * (10 ** decimals); // 100 million
477         teamAndFounderFund = 40000000 * (10 ** decimals); // 40 million
478         tokenDeploymentTime = now;
479         _mint(msg.sender, icoFunds);
480     }
481 
482     /**
483      * @dev Function to mint tokens allocated for consumer
484      * protection to owner address. Owner then sends them
485      * to responsible parties
486      */
487     function allocateConsumerProtectionFund()
488         public
489         onlyOwner
490     {
491         require(!consumerProtectionFundAllocated, "Already allocated");
492         consumerProtectionFundAllocated = true;
493         _mint(owner, consumerProtectionFund);
494     }
495 
496     /**
497      * @dev Function to mint tokens allocated for Ecosystem development
498      * and operations to owner address. Owner then sends them
499      * to responsible parties
500      */
501     function allocateEcoSystemDevelopmentAndOperationFund()
502         public
503         onlyOwner
504     {
505         require(!ecoSystemDevelopmentAndOperationFundAllocated, "Already allocated");
506         ecoSystemDevelopmentAndOperationFundAllocated = true;
507         _mint(owner, ecoSystemDevelopmentAndOperationFund);
508     }
509 
510     /**
511      * @dev Function to mint tokens allocated for team
512      * and founders to owner address. Owner then sends them
513      * to responsible parties.
514      * Tokens are locked for 1 year and can be claimed after 1 year
515      * from date of deployment
516      */
517     function allocateTeamAndFounderFund()
518         public
519         onlyOwner
520     {
521         require(!teamAndFounderFundAllocated, "Already allocated");
522         require(now > tokenDeploymentTime + 365 days, "Vesting period not over yet");
523         teamAndFounderFundAllocated = true;
524         _mint(owner, teamAndFounderFund);
525     }
526 
527     /**
528      * @dev Function to mint tokens
529      * @param _to The address that will receive the minted tokens.
530      * @param _value The amount of tokens to mint.
531      */
532     function _mint(address _to, uint _value)
533         private
534         onlyOwner
535     {
536         require(totalSupply.add(_value) <= maxSupply, "Exceeds max supply");
537         balances[_to] = balances[_to].add(_value);
538         totalSupply = totalSupply.add(_value);
539         bytes memory _data;
540         emit Transfer(address(0), _to, _value, _data);
541         emit Transfer(address(0), _to, _value);
542 
543     }
544 
545 }