1 pragma solidity ^0.4.23;
2 
3 //  (;´д`)｡･ﾟﾟ･  SCAM penis
4 //  (ヽηﾉ 
5 //  　ヽ ヽ
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16       // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17       // benefit is lost if 'b' is also tested.
18       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19       if (a == 0) {
20         return 0;
21       }
22 
23       c = a * b;
24       assert(c / a == b);
25       return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32       // assert(b > 0); // Solidity automatically throws when dividing by 0
33       // uint256 c = a / b;
34       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35       return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42       assert(b <= a);
43       return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50       c = a + b;
51       assert(c >= a);
52       return c;
53     }
54 }
55 
56 
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address & authorized addresses, and provides basic
61  * authorization control functions, this simplifies the implementation of user permissions.
62  */
63 contract Ownable {
64     address public owner;
65     bool public canRenounce = false;
66     mapping (address => bool) public authorized;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69     event AuthorizedAdded(address indexed authorized);
70     event AuthorizedRemoved(address indexed authorized);
71 
72     /**
73      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
74      */
75     constructor() public {
76       owner = msg.sender;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83       require(msg.sender == owner);
84       _;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the authorized or owner.
89      */
90     modifier onlyAuthorized() {
91         require(msg.sender == owner || authorized[msg.sender]);
92         _;
93     }
94 
95     /**
96      * @dev Allows the current owner to relinquish control of the contract.
97      */
98     function enableRenounceOwnership() onlyOwner public {
99       canRenounce = true;
100     }
101 
102     /**
103      * @dev Allows the current owner to transfer control of the contract to a newOwner.
104      * @param _newOwner The address to transfer ownership to.
105      */
106     function transferOwnership(address _newOwner) onlyOwner public {
107       if(!canRenounce){
108         require(_newOwner != address(0));
109       }
110       emit OwnershipTransferred(owner, _newOwner);
111       owner = _newOwner;
112     }
113 
114     /**
115      * @dev Adds authorized to execute several functions to subOwner.
116      * @param _authorized The address to add authorized to.
117      */
118 
119     function addAuthorized(address _authorized) onlyOwner public {
120       authorized[_authorized] = true;
121       emit AuthorizedAdded(_authorized);
122     }
123 
124     /**
125      * @dev Removes authorized to execute several functions from subOwner.
126      * @param _authorized The address to remove authorized from.
127      */
128 
129     function removeAuthorized(address _authorized) onlyOwner public {
130       authorized[_authorized] = false;
131       emit AuthorizedRemoved(_authorized);
132     }
133 }
134 
135 
136 
137 /**
138  * @title ERC223
139  * @dev ERC223 contract interface with ERC20 functions and events
140  *      Fully backward compatible with ERC20
141  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
142  */
143 contract ERC223 {
144     uint public totalSupply;
145 
146     // ERC223 and ERC20 functions and events
147     function name() public view returns (string _name);
148     function symbol() public view returns (string _symbol);
149     function decimals() public view returns (uint8 _decimals);
150     function balanceOf(address who) public view returns (uint);
151     function totalSupply() public view returns (uint256 _supply);
152     function transfer(address to, uint value) public returns (bool ok);
153     function transfer(address to, uint value, bytes data) public returns (bool ok);
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
155     function approve(address _spender, uint256 _value) public returns (bool success);
156     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
157 
158     event Transfer(address indexed _from, address indexed _to, uint256 _value);
159     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
160     event Approval(address indexed _owner, address indexed _spender, uint _value);
161 }
162 
163 
164 
165 /**
166  * @title ContractReceiver
167  * @dev Contract that is working with ERC223 tokens
168  */
169 contract ContractReceiver {
170 /**
171  * @dev Standard ERC223 function that will handle incoming token transfers.
172  *
173  * @param _from  Token sender address.
174  * @param _value Amount of tokens.
175  * @param _data  Transaction metadata.
176  */
177     function tokenFallback(address _from, uint _value, bytes _data) external;
178 }
179 
180 
181 
182 /**
183  * @title MANJ
184  * @dev MANJCOIN is an ERC223 Token with ERC20 functions and events
185  *      Fully backward compatible with ERC20
186  */
187 contract MANJ is ERC223, Ownable {
188     using SafeMath for uint256;
189 
190     string public name = "MANJCOIN";
191     string public symbol = "MANJ";
192     uint8 public decimals = 8;
193     uint256 public totalSupply = 19190721 * 1e8;
194     uint256 public codeSize = 0;
195     bool public mintingFinished = false;
196 
197     mapping (address => uint256) public balanceOf;
198     mapping (address => mapping (address => uint256)) public allowance;
199     mapping (address => bool) public cannotSend;
200     mapping (address => bool) public cannotReceive;
201     mapping (address => uint256) public cannotSendUntil;
202     mapping (address => uint256) public cannotReceiveUntil;
203 
204     event FrozenFunds(address indexed target, bool cannotSend, bool cannotReceive);
205     event LockedFunds(address indexed target, uint256 cannotSendUntil, uint256 cannotReceiveUntil);
206     event Burn(address indexed from, uint256 amount);
207     event Mint(address indexed to, uint256 amount);
208     event MintFinished();
209 
210     /**
211      * @dev Constructor is called only once and can not be called again
212      */
213     constructor() public {
214         owner = msg.sender;
215         balanceOf[owner] = totalSupply;
216     }
217 
218     function name() public view returns (string _name) {
219         return name;
220     }
221 
222     function symbol() public view returns (string _symbol) {
223         return symbol;
224     }
225 
226     function decimals() public view returns (uint8 _decimals) {
227         return decimals;
228     }
229 
230     function totalSupply() public view returns (uint256 _totalSupply) {
231         return totalSupply;
232     }
233 
234     function balanceOf(address _owner) public view returns (uint256 balance) {
235         return balanceOf[_owner];
236     }
237 
238     /**
239      * @dev Prevent targets from sending or receiving tokens
240      * @param targets Addresses to be frozen
241      * @param _cannotSend Whether to prevent targets from sending tokens or not
242      * @param _cannotReceive Whether to prevent targets from receiving tokens or not
243      */
244     function freezeAccounts(address[] targets, bool _cannotSend, bool _cannotReceive) onlyOwner public {
245         require(targets.length > 0);
246 
247         for (uint i = 0; i < targets.length; i++) {
248             cannotSend[targets[i]] = _cannotSend;
249             cannotReceive[targets[i]] = _cannotReceive;
250             emit FrozenFunds(targets[i], _cannotSend, _cannotReceive);
251         }
252     }
253 
254     /**
255      * @dev Prevent targets from sending or receiving tokens by setting Unix time
256      * @param targets Addresses to be locked funds
257      * @param _cannotSendUntil Unix time when locking up sending function will be finished
258      * @param _cannotReceiveUntil Unix time when locking up receiving function will be finished
259      */
260     function lockupAccounts(address[] targets, uint256 _cannotSendUntil, uint256 _cannotReceiveUntil) onlyOwner public {
261         require(targets.length > 0);
262 
263         for(uint i = 0; i < targets.length; i++){
264             require(cannotSendUntil[targets[i]] <= _cannotSendUntil
265                     && cannotReceiveUntil[targets[i]] <= _cannotReceiveUntil);
266 
267             cannotSendUntil[targets[i]] = _cannotSendUntil;
268             cannotReceiveUntil[targets[i]] = _cannotReceiveUntil;
269             emit LockedFunds(targets[i], _cannotSendUntil, _cannotReceiveUntil);
270         }
271     }
272 
273     /**
274      * @dev Function that is called when a user or another contract wants to transfer funds
275      */
276     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
277         require(_value > 0
278                 && cannotSend[msg.sender] == false
279                 && cannotReceive[_to] == false
280                 && now > cannotSendUntil[msg.sender]
281                 && now > cannotReceiveUntil[_to]);
282 
283         if (isContract(_to)) {
284             return transferToContract(_to, _value, _data);
285         } else {
286             return transferToAddress(_to, _value, _data);
287         }
288     }
289 
290     /**
291      * @dev Standard function transfer similar to ERC20 transfer with no _data
292      *      Added due to backwards compatibility reasons
293      */
294     function transfer(address _to, uint _value) public returns (bool success) {
295         require(_value > 0
296                 && cannotSend[msg.sender] == false
297                 && cannotReceive[_to] == false
298                 && now > cannotSendUntil[msg.sender]
299                 && now > cannotReceiveUntil[_to]);
300 
301         bytes memory empty;
302         if (isContract(_to)) {
303             return transferToContract(_to, _value, empty);
304         } else {
305             return transferToAddress(_to, _value, empty);
306         }
307     }
308 
309     /**
310      * @dev Returns whether the target address is a contract
311      * @param _addr address to check
312      * @return whether the target address is a contract
313      */
314     function isContract(address _addr) internal view returns (bool) {
315       uint256 size;
316       assembly { size := extcodesize(_addr) }
317       return size > codeSize ;
318     }
319 
320     function setCodeSize(uint256 _codeSize) onlyOwner public {
321         codeSize = _codeSize;
322     }
323 
324     // function that is called when transaction target is an address
325     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
326         require(balanceOf[msg.sender] >= _value);
327         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
328         balanceOf[_to] = balanceOf[_to].add(_value);
329         emit Transfer(msg.sender, _to, _value, _data);
330         emit Transfer(msg.sender, _to, _value);
331         return true;
332     }
333 
334     // function that is called when transaction target is a contract
335     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
336         require(balanceOf[msg.sender] >= _value);
337         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
338         balanceOf[_to] = balanceOf[_to].add(_value);
339         ContractReceiver receiver = ContractReceiver(_to);
340         receiver.tokenFallback(msg.sender, _value, _data);
341         emit Transfer(msg.sender, _to, _value, _data);
342         emit Transfer(msg.sender, _to, _value);
343         return true;
344     }
345 
346     /**
347      * @dev Transfer tokens from one address to another
348      *      Added due to backwards compatibility with ERC20
349      * @param _from address The address which you want to send tokens from
350      * @param _to address The address which you want to transfer to
351      * @param _value uint256 the amount of tokens to be transferred
352      */
353     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
354         require(_to != address(0)
355                 && _value > 0
356                 && balanceOf[_from] >= _value
357                 && allowance[_from][msg.sender] >= _value
358                 && cannotSend[msg.sender] == false
359                 && cannotReceive[_to] == false
360                 && now > cannotSendUntil[msg.sender]
361                 && now > cannotReceiveUntil[_to]);
362 
363         balanceOf[_from] = balanceOf[_from].sub(_value);
364         balanceOf[_to] = balanceOf[_to].add(_value);
365         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
366         emit Transfer(_from, _to, _value);
367         return true;
368     }
369 
370     /**
371      * @dev Allows _spender to spend no more than _value tokens in your behalf
372      *      Added due to backwards compatibility with ERC20
373      * @param _spender The address authorized to spend
374      * @param _value the max amount they can spend
375      */
376     function approve(address _spender, uint256 _value) public returns (bool success) {
377         allowance[msg.sender][_spender] = _value;
378         emit Approval(msg.sender, _spender, _value);
379         return true;
380     }
381 
382     /**
383      * @dev Function to check the amount of tokens that an owner allowed to a spender
384      *      Added due to backwards compatibility with ERC20
385      * @param _owner address The address which owns the funds
386      * @param _spender address The address which will spend the funds
387      */
388     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
389         return allowance[_owner][_spender];
390     }
391 
392     /**
393      * @dev Burns a specific amount of tokens.
394      * @param _from The address that will burn the tokens.
395      * @param _unitAmount The amount of token to be burned.
396      */
397     function burn(address _from, uint256 _unitAmount) onlyOwner public {
398         require(_unitAmount > 0
399                 && balanceOf[_from] >= _unitAmount);
400 
401         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
402         totalSupply = totalSupply.sub(_unitAmount);
403         emit Burn(_from, _unitAmount);
404         emit Transfer(_from, address(0), _unitAmount);
405 
406     }
407 
408     modifier canMint() {
409         require(!mintingFinished);
410         _;
411     }
412 
413     /**
414      * @dev Function to mint tokens
415      * @param _to The address that will receive the minted tokens.
416      * @param _unitAmount The amount of tokens to mint.
417      */
418     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
419         require(_unitAmount > 0);
420 
421         totalSupply = totalSupply.add(_unitAmount);
422         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
423         emit Mint(_to, _unitAmount);
424         emit Transfer(address(0), _to, _unitAmount);
425         return true;
426     }
427 
428     /**
429      * @dev Function to stop minting new tokens.
430      */
431     function finishMinting() onlyOwner canMint public returns (bool) {
432         mintingFinished = true;
433         emit MintFinished();
434         return true;
435     }
436 
437     /**
438      * @dev Function to distribute tokens to the list of addresses by the provided amount
439      */
440     function batchTransfer(address[] addresses, uint256 amount) public returns (bool) {
441         require(amount > 0
442                 && addresses.length > 0
443                 && cannotSend[msg.sender] == false
444                 && now > cannotSendUntil[msg.sender]);
445 
446         amount = amount.mul(1e8);
447         uint256 totalAmount = amount.mul(addresses.length);
448         require(balanceOf[msg.sender] >= totalAmount);
449 
450         for (uint i = 0; i < addresses.length; i++) {
451             require(addresses[i] != address(0)
452                     && cannotReceive[addresses[i]] == false
453                     && now > cannotReceiveUntil[addresses[i]]);
454 
455             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amount);
456             emit Transfer(msg.sender, addresses[i], amount);
457         }
458         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
459         return true;
460     }
461 
462     function batchTransfer(address[] addresses, uint[] amounts) public returns (bool) {
463         require(addresses.length > 0
464                 && addresses.length == amounts.length
465                 && cannotSend[msg.sender] == false
466                 && now > cannotSendUntil[msg.sender]);
467 
468         uint256 totalAmount = 0;
469 
470         for(uint i = 0; i < addresses.length; i++){
471             require(amounts[i] > 0
472                     && addresses[i] != address(0)
473                     && cannotReceive[addresses[i]] == false
474                     && now > cannotReceiveUntil[addresses[i]]);
475 
476             amounts[i] = amounts[i].mul(1e8);
477             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amounts[i]);
478             totalAmount = totalAmount.add(amounts[i]);
479             emit Transfer(msg.sender, addresses[i], amounts[i]);
480         }
481 
482         require(balanceOf[msg.sender] >= totalAmount);
483         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
484         return true;
485     }
486 
487     /**
488      * @dev Function to transfer tokens between addresses, only for Owner & subOwner
489      */
490     function transferFromTo(address _from, address _to, uint256 _value, bytes _data) onlyAuthorized public returns (bool) {
491         require(_value > 0
492                 && balanceOf[_from] >= _value
493                 && cannotSend[_from] == false
494                 && cannotReceive[_to] == false
495                 && now > cannotSendUntil[_from]
496                 && now > cannotReceiveUntil[_to]);
497 
498         balanceOf[_from] = balanceOf[_from].sub(_value);
499         balanceOf[_to] = balanceOf[_to].add(_value);
500         if(isContract(_to)) {
501             ContractReceiver receiver = ContractReceiver(_to);
502             receiver.tokenFallback(_from, _value, _data);
503         }
504         emit Transfer(_from, _to, _value, _data);
505         emit Transfer(_from, _to, _value);
506         return true;
507     }
508 
509     function transferFromTo(address _from, address _to, uint256 _value) onlyAuthorized public returns (bool) {
510         bytes memory empty;
511         return transferFromTo(_from, _to, _value, empty);
512     }
513 
514     /**
515      * @dev Transfers the current balance to the owner and terminates the contract.
516      */
517     function destroy() onlyOwner public {
518       selfdestruct(owner);
519     }
520 
521     /**
522      * @dev fallback function
523      */
524     function() payable public {
525       revert();
526     }
527 }
528 
529 // 　＼　　　　　　　　　　　／ 
530 // 　　＼　　　　　　　　　／ 
531 // 　　　＼　　　　　　　／ 
532 // 　　　　＼　　　　　／ 
533 // 　　　　　＼( ^o^)／　　　うわああああああああああああああ！！！！！！！！！！ 
534 // 　　　　　　│　　│ 
535 // 　　　　　　│　　│　　　　～○～○～○～○～○～○～○ 
536 // 　　　　　　│　　│　　～○～○～○～○～○～○～○～○～○ 
537 // 　　　　　　(　 ω⊃～○～○～○～○～○～○～○～○～○～○～○ 
538 // 　　　　　　／　　＼～○～○～○～○～○～○～○～○～○～○ 
539 // 　　　　　／　　　　＼　～○～○～○～○～○～○～○～○ 
540 // 　　　　／　　　　　　＼ 
541 // 　　　／　　　　　　　　＼