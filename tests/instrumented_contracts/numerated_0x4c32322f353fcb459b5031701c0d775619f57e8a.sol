1 pragma solidity ^0.4.18;
2 // GIGAPOSICOIN
3 
4 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMqkkkUUYYTCz11??11111zzOTTTUUWHkqkHMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMkkHYTC+(?????????????????????????????zTUWHkqMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 // MMMMMMMMMMMMMMMMMMMMMMMMMkHY"<.+???????????????????????????????????????17UHkqMMMMMMMMMMMMMMMMMMMMMMM
7 // MMMMMMMMMMMMMMMMMMMMMHkW"~.+?????????????????????>??>??????????????????????17WkkMMMMMMMMMMMMMMMMMMMM
8 // MMMMMMMMMMMMMMMMMMMkHY!.+??<??<???<<<????>??>??>??????>??>??>??>??>??>????????+7WkHMMMMMMMMMMMMMMMMM
9 // MMMMMMMMMMMMMMMMMkK=.(???!     <?:   ??>??????????>?????????????????????>????????vWkHMMMMMMMMMMMMMMM
10 // MMMMMMMMMMMMMMMkK^.(????:     ,???+(??????>??>??>???>??>??>??>??>??>???????>???????zWkHMMMMMMMMMMMMM
11 // MMMMMMMMMMMMMqH=.(???????+-(+?????????1zz&&&&&&&&&&&zzz1????????????>?>??>????>??????vWkMMMMMMMMMMMM
12 // MMMMMMMMMMMHkY .??????????????z&gQXbkkkHHUUUYYYYYUUUWHHkkkkWkma&&z?????????????>??>????VkHMMMMMMMMMM
13 // MMMMMMMMMMkH^.+?????>??>1ugQWkHUY"!`  .......------........_?7"TWHkkkmexz??>????????????vHkMMMMMMMMM
14 // MMMMMMMMMkK!.???????1uQWkWY"! ..(+?????????????>????????????????+(..?7TWkHm&z???>??>?????vHkMMMMMMMM
15 // MMMMMMMMkW!.?????1uXkHY^ ..+?????????>??>?????>???????????????????????+-._7WkHnx????>?????vkqMMMMMMM
16 // MMMMMMMkH'.????udkW"`..+??>??>?????????????>?????>?????????>????????????>?<. ?4kHAz???>????dkHMMMMMM
17 // MMMMMMMk%.???uXkY'.(??????????>??>??>??>????????????????>?????>??????????????<. ?Wkmx???????4kMMMMMM
18 // MMMMMNkH`+?1dkf!.+????>??>??z&&&gaQAQkkWWWWWWWWWWWWWkkQQAAa&&zzz??>??>??????????-.(4kmx??>??zkkMMMMM
19 // MMMMMMk].?1XH=.(??1&&gQkWkkkHWUYY""77??!~~````````~~???77""TUWHkkkHkma&zz>?>??????<.(Wkm?????XkMMMMM
20 // MMMMMkk:.1Xk\.ugXkkHY""!`                                         _?7TUHkkHmaxz?????- 7kkz???dqHMMMM
21 // MMMMNkH .dkkWkWY"`                                                        ?7TWkkmax??<.(kHc??1HkMMMM
22 // MMMMMqk_.zHk%                                                                   ?TWkHmx-,HHc??WkMMMM
23 // MMMMHk=.+dkP                                                                        ?TWqmXkR??dkHMMM
24 // MMMHk\.?dkf              `  `                                                         (kY?71???WkMMM
25 // MMMkP +1WH!           `        `                              `                      .qP +?????zHqMM
26 // MMkH`(?dkP       `                                    `   `      `   `  `            Jk\.?uXHmz?dkHM
27 // MMk%.??Wk:          `        .dqkqn         `               .dqqk,         `  `      Xk~(1Wr4XR?zkqM
28 // Mkk:(?zkK     `          `  .WqK7kq[    `      `    `      .qkf4kk,              `   WH`<zk~,kkz?WkM
29 // NkH <?dkD      `  ..        .kk].kk\   .a..      ` ....    .kkL.kk]                  WH <zH .RkI?WkM
30 // NkR <?dk]    ._~~~_~~~_.     WkHkqf`     jkUHqHHWUUYYTq{    4kkXkk>   ` ..~~~~~_.    Wk.(zk-.HkI?WkM
31 // NkH.<?dkt   ~~~~~___~~~~_     ?""=       ,kdHY<:~:~:~(k}     ?TT"!     ~~~~~_.~~~~_  Xk;.?dHWdK?1WkM
32 // MHk[.1WH!  ~~~`--_~___-~~_               .kr~~:~:~:~:(H`              ~~____~_____~_ ,qb <?zTC??jkHM
33 // MNqk,.kP   ~~~~-~~~~_.~~~_                zH-:~:~:~:(XP              .~~~._~~~~_.~~~` 4k;.<????1XkMM
34 // MMNHkkq\   _~~~_~_-__-~~~`                 7He-:~:((Xf      `         ~~~_-___~.~~~~  .WH, ?<?1dkNMM
35 // MMMMMNk[    _~~__~~~~~~~`                    7TWHUY"!                 _~~_-~~~_.~~~`   .4kmJJdkHNMMM
36 // MMMMMNqb      _~~~~~~_`                                                __~~~~~~~~_`       dkHNMMMMMM
37 // MMMMMNHk,                   `            `                    `  `         ````          .qHMMMMMMMM
38 // MMMMMMNqH,                     `                                                       .JqHMMMMMMMMM
39 // MMMMMMMNHqh,                                               `                         .(qHNMMMMMMMMMM
40 // MMMMMMMMMNHqHn..        `  `      `                                 `              .dkHNMMMMMMMMMMMM
41 // MMMMMMMMMMMMNNHqqHAJ...                 `                     `  `     `     `...dkHNMMMMMMMMMMMMMMM
42 // MMMMMMMMMMMMMMMMMNNHHHqqkHmgJ.....         `              `         .....JgXqkkHHNMMMMMMMMMMMMMMMMMM
43 // MMMMMMMMMMMMMMMMMMMMMMMMMNNNNHHHqqqqqqkWkkQAAaaggggggagQAQQkWWkqqkkkkqHHHNNNMMMMa+MMMMMMMMMMMMMMMMMM
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49  
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // assert(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization
84  *      control functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87     address public owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     /**
92      * @dev The Ownable constructor sets the original `owner` of the contract to the
93      *      sender account.
94      */
95     function Ownable() public {
96         owner = msg.sender;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(msg.sender == owner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) onlyOwner public {
112         require(newOwner != address(0));
113         OwnershipTransferred(owner, newOwner);
114         owner = newOwner;
115     }
116 }
117 
118 
119 
120 /**
121  * @title ERC223
122  * @dev ERC223 contract interface with ERC20 functions and events
123  *      Fully backward compatible with ERC20
124  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
125  */
126 contract ERC223 {
127     uint public totalSupply;
128 
129     // ERC223 and ERC20 functions and events
130     function balanceOf(address who) public view returns (uint);
131     function totalSupply() public view returns (uint256 _supply);
132     function transfer(address to, uint value) public returns (bool ok);
133     function transfer(address to, uint value, bytes data) public returns (bool ok);
134     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
135     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
136 
137     // ERC223 functions
138     function name() public view returns (string _name);
139     function symbol() public view returns (string _symbol);
140     function decimals() public view returns (uint8 _decimals);
141 
142     // ERC20 functions and events
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
144     function approve(address _spender, uint256 _value) public returns (bool success);
145     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
146     event Transfer(address indexed _from, address indexed _to, uint256 _value);
147     event Approval(address indexed _owner, address indexed _spender, uint _value);
148 }
149 
150 
151 
152 /**
153  * @title ContractReceiver
154  * @dev Contract that is working with ERC223 tokens
155  */
156  contract ContractReceiver {
157 
158     struct TKN {
159         address sender;
160         uint value;
161         bytes data;
162         bytes4 sig;
163     }
164 
165     function tokenFallback(address _from, uint _value, bytes _data) public pure {
166         TKN memory tkn;
167         tkn.sender = _from;
168         tkn.value = _value;
169         tkn.data = _data;
170         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
171         tkn.sig = bytes4(u);
172         
173         /*
174          * tkn variable is analogue of msg variable of Ether transaction
175          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
176          * tkn.value the number of tokens that were sent   (analogue of msg.value)
177          * tkn.data is data of token transaction   (analogue of msg.data)
178          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
179          */
180     }
181 }
182 
183 /**
184  * @title GAPPOICOIN
185  */
186 contract GAPPOICOIN is ERC223, Ownable {
187     using SafeMath for uint256;
188 
189     string public name = "GAPPOICOIN";
190     string public symbol = "GAPOI";
191     uint8 public decimals = 8;
192     uint256 public totalSupply = 334e6 * 1e8;
193     uint256 public distributeAmount = 0;            // ここを1にすると投票機能が動くけど動くけど今回は動くけど今回はいらない
194     bool public mintingFinished = false;
195     
196     // ここの４つのアドレス最初送られる
197     // founder(創業者)
198     address public founder = 0x5A0013C649c19458a608C45b40f3b6ecafBa628C;
199     // gappoimaster(ガッポイマスター)
200     address public  gappoimaster= 0xfC5529D5b69506c0d757E9127fC3F22B31aEd283;
201     // activityFunds(活動資金)　上記distributeAmountが1になってると投票機能時にこの資金が消費されます
202     address public activityFunds = 0x4DCdCdcFc85A97775C44c2aa3C0352524cFE5dd4;
203     // momosFunds(momoさん資金)
204     address public momosFunds = 0x7Df572DA7D93041264F21Ad265bF70C0F324f658;
205 
206     mapping(address => uint256) public balanceOf;
207     mapping(address => mapping (address => uint256)) public allowance;
208     mapping (address => bool) public frozenAccount;
209     mapping (address => uint256) public unlockUnixTime;
210     
211     event FrozenFunds(address indexed target, bool frozen);
212     event LockedFunds(address indexed target, uint256 locked);
213     event Burn(address indexed from, uint256 amount);
214     event Mint(address indexed to, uint256 amount);
215     event MintFinished();
216 
217 
218     /** 
219      * @dev Constructor is called only once and can not be called again
220      */
221     function GAPPOICOIN() public {
222         owner = activityFunds;
223         
224         balanceOf[founder] = totalSupply.mul(30).div(100);
225         balanceOf[gappoimaster] = totalSupply.mul(10).div(100);
226         balanceOf[activityFunds] = totalSupply.mul(30).div(100);
227         balanceOf[momosFunds] = totalSupply.mul(30).div(100);
228     }
229 
230 
231     function name() public view returns (string _name) {
232         return name;
233     }
234 
235     function symbol() public view returns (string _symbol) {
236         return symbol;
237     }
238 
239     function decimals() public view returns (uint8 _decimals) {
240         return decimals;
241     }
242 
243     function totalSupply() public view returns (uint256 _totalSupply) {
244         return totalSupply;
245     }
246 
247     function balanceOf(address _owner) public view returns (uint256 balance) {
248         return balanceOf[_owner];
249     }
250 
251 
252     /**
253      * @dev Prevent targets from sending or receiving tokens
254      * @param targets Addresses to be frozen
255      * @param isFrozen either to freeze it or not
256      * 特定のアドレスを凍結
257      */
258     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
259         require(targets.length > 0);
260 
261         for (uint j = 0; j < targets.length; j++) {
262             require(targets[j] != 0x0);
263             frozenAccount[targets[j]] = isFrozen;
264             FrozenFunds(targets[j], isFrozen);
265         }
266     }
267 
268     /**
269      * @dev Prevent targets from sending or receiving tokens by setting Unix times
270      * @param targets Addresses to be locked funds
271      * @param unixTimes Unix times when locking up will be finished
272      * アカウントをロックアップする機能
273      */
274     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
275         require(targets.length > 0
276                 && targets.length == unixTimes.length);
277                 
278         for(uint j = 0; j < targets.length; j++){
279             require(unlockUnixTime[targets[j]] < unixTimes[j]);
280             unlockUnixTime[targets[j]] = unixTimes[j];
281             LockedFunds(targets[j], unixTimes[j]);
282         }
283     }
284 
285 
286     /**
287      * @dev Function that is called when a user or another contract wants to transfer funds
288      */
289     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
290         require(_value > 0
291                 && frozenAccount[msg.sender] == false 
292                 && frozenAccount[_to] == false
293                 && now > unlockUnixTime[msg.sender] 
294                 && now > unlockUnixTime[_to]);
295 
296         if (isContract(_to)) {
297             require(balanceOf[msg.sender] >= _value);
298             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
299             balanceOf[_to] = balanceOf[_to].add(_value);
300             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
301             Transfer(msg.sender, _to, _value, _data);
302             Transfer(msg.sender, _to, _value);
303             return true;
304         } else {
305             return transferToAddress(_to, _value, _data);
306         }
307     }
308 
309     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
310         require(_value > 0
311                 && frozenAccount[msg.sender] == false 
312                 && frozenAccount[_to] == false
313                 && now > unlockUnixTime[msg.sender] 
314                 && now > unlockUnixTime[_to]);
315 
316         if (isContract(_to)) {
317             return transferToContract(_to, _value, _data);
318         } else {
319             return transferToAddress(_to, _value, _data);
320         }
321     }
322 
323     /**
324      * @dev Standard function transfer similar to ERC20 transfer with no _data
325      *      Added due to backwards compatibility reasons
326      */
327     function transfer(address _to, uint _value) public returns (bool success) {
328         require(_value > 0
329                 && frozenAccount[msg.sender] == false 
330                 && frozenAccount[_to] == false
331                 && now > unlockUnixTime[msg.sender] 
332                 && now > unlockUnixTime[_to]);
333 
334         bytes memory empty;
335         if (isContract(_to)) {
336             return transferToContract(_to, _value, empty);
337         } else {
338             return transferToAddress(_to, _value, empty);
339         }
340     }
341 
342     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
343     function isContract(address _addr) private view returns (bool is_contract) {
344         uint length;
345         assembly {
346             //retrieve the size of the code on target address, this needs assembly
347             length := extcodesize(_addr)
348         }
349         return (length > 0);
350     }
351 
352     // function that is called when transaction target is an address
353     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
354         require(balanceOf[msg.sender] >= _value);
355         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
356         balanceOf[_to] = balanceOf[_to].add(_value);
357         Transfer(msg.sender, _to, _value, _data);
358         Transfer(msg.sender, _to, _value);
359         return true;
360     }
361 
362     // function that is called when transaction target is a contract
363     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
364         require(balanceOf[msg.sender] >= _value);
365         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
366         balanceOf[_to] = balanceOf[_to].add(_value);
367         ContractReceiver receiver = ContractReceiver(_to);
368         receiver.tokenFallback(msg.sender, _value, _data);
369         Transfer(msg.sender, _to, _value, _data);
370         Transfer(msg.sender, _to, _value);
371         return true;
372     }
373 
374 
375 
376     /**
377      * @dev Transfer tokens from one address to another
378      *      Added due to backwards compatibility with ERC20
379      * @param _from address The address which you want to send tokens from
380      * @param _to address The address which you want to transfer to
381      * @param _value uint256 the amount of tokens to be transferred
382      */
383     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
384         require(_to != address(0)
385                 && _value > 0
386                 && balanceOf[_from] >= _value
387                 && allowance[_from][msg.sender] >= _value
388                 && frozenAccount[_from] == false 
389                 && frozenAccount[_to] == false
390                 && now > unlockUnixTime[_from] 
391                 && now > unlockUnixTime[_to]);
392 
393         balanceOf[_from] = balanceOf[_from].sub(_value);
394         balanceOf[_to] = balanceOf[_to].add(_value);
395         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
396         Transfer(_from, _to, _value);
397         return true;
398     }
399 
400     /**
401      * @dev Allows _spender to spend no more than _value tokens in your behalf
402      *      Added due to backwards compatibility with ERC20
403      * @param _spender The address authorized to spend
404      * @param _value the max amount they can spend
405      */
406     function approve(address _spender, uint256 _value) public returns (bool success) {
407         allowance[msg.sender][_spender] = _value;
408         Approval(msg.sender, _spender, _value);
409         return true;
410     }
411 
412     /**
413      * @dev Function to check the amount of tokens that an owner allowed to a spender
414      *      Added due to backwards compatibility with ERC20
415      * @param _owner address The address which owns the funds
416      * @param _spender address The address which will spend the funds
417      */
418     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
419         return allowance[_owner][_spender];
420     }
421 
422 
423 
424     /**
425      * @dev Burns a specific amount of tokens.
426      * @param _from The address that will burn the tokens.
427      * @param _unitAmount The amount of token to be burned.
428      */
429     function burn(address _from, uint256 _unitAmount) onlyOwner public {
430         require(_unitAmount > 0
431                 && balanceOf[_from] >= _unitAmount);
432 
433         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
434         totalSupply = totalSupply.sub(_unitAmount);
435         Burn(_from, _unitAmount);
436     }
437 
438 
439     modifier canMint() {
440         require(!mintingFinished);
441         _;
442     }
443 
444     /**
445      * @dev Function to mint tokens
446      * @param _to The address that will receive the minted tokens.
447      * @param _unitAmount The amount of tokens to mint.
448      */
449     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
450         require(_unitAmount > 0);
451         
452         totalSupply = totalSupply.add(_unitAmount);
453         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
454         Mint(_to, _unitAmount);
455         Transfer(address(0), _to, _unitAmount);
456         return true;
457     }
458 
459     /**
460      * @dev Function to stop minting new tokens.
461      */
462     function finishMinting() onlyOwner canMint public returns (bool) {
463         mintingFinished = true;
464         MintFinished();
465         return true;
466     }
467 
468 
469 
470     /**
471      * @dev Function to distribute tokens to the list of addresses by the provided amount
472      */
473     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
474         require(amount > 0 
475                 && addresses.length > 0
476                 && frozenAccount[msg.sender] == false
477                 && now > unlockUnixTime[msg.sender]);
478 
479         amount = amount.mul(1e8);
480         uint256 totalAmount = amount.mul(addresses.length);
481         require(balanceOf[msg.sender] >= totalAmount);
482         
483         for (uint j = 0; j < addresses.length; j++) {
484             require(addresses[j] != 0x0
485                     && frozenAccount[addresses[j]] == false
486                     && now > unlockUnixTime[addresses[j]]);
487 
488             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
489             Transfer(msg.sender, addresses[j], amount);
490         }
491         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
492         return true;
493     }
494 
495     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
496         require(addresses.length > 0
497                 && addresses.length == amounts.length
498                 && frozenAccount[msg.sender] == false
499                 && now > unlockUnixTime[msg.sender]);
500                 
501         uint256 totalAmount = 0;
502         
503         for(uint j = 0; j < addresses.length; j++){
504             require(amounts[j] > 0
505                     && addresses[j] != 0x0
506                     && frozenAccount[addresses[j]] == false
507                     && now > unlockUnixTime[addresses[j]]);
508                     
509             amounts[j] = amounts[j].mul(1e8);
510             totalAmount = totalAmount.add(amounts[j]);
511         }
512         require(balanceOf[msg.sender] >= totalAmount);
513         
514         for (j = 0; j < addresses.length; j++) {
515             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
516             Transfer(msg.sender, addresses[j], amounts[j]);
517         }
518         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
519         return true;
520     }
521 
522     /**
523      * @dev Function to collect tokens from the list of addresses
524      */
525     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
526         require(addresses.length > 0
527                 && addresses.length == amounts.length);
528 
529         uint256 totalAmount = 0;
530         
531         for (uint j = 0; j < addresses.length; j++) {
532             require(amounts[j] > 0
533                     && addresses[j] != 0x0
534                     && frozenAccount[addresses[j]] == false
535                     && now > unlockUnixTime[addresses[j]]);
536                     
537             amounts[j] = amounts[j].mul(1e8);
538             require(balanceOf[addresses[j]] >= amounts[j]);
539             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
540             totalAmount = totalAmount.add(amounts[j]);
541             Transfer(addresses[j], msg.sender, amounts[j]);
542         }
543         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
544         return true;
545     }
546 
547 
548     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
549         distributeAmount = _unitAmount;
550     }
551     
552     /**
553      * @dev Function to distribute tokens to the msg.sender automatically
554      *      If distributeAmount is 0, this function doesn't work
555      */
556     function autoDistribute() payable public {
557         require(distributeAmount > 0
558                 && balanceOf[activityFunds] >= distributeAmount
559                 && frozenAccount[msg.sender] == false
560                 && now > unlockUnixTime[msg.sender]);
561         if(msg.value > 0) activityFunds.transfer(msg.value);
562         
563         balanceOf[activityFunds] = balanceOf[activityFunds].sub(distributeAmount);
564         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
565         Transfer(activityFunds, msg.sender, distributeAmount);
566     }
567 
568     /**
569      * @dev fallback function
570      */
571     function() payable public {
572         autoDistribute();
573      }
574 
575 }
576 
577 
578 /*
579  * すばらしいコードだったのでNANJCOIN丸パクリ丸パクリしました
580  * 自分がもっとスキルアップしたら改変できるようにがんばります
581  * 申し訳ありますん
582  */