1 pragma solidity ^0.4.18;
2 // GIGAPOSICOIN
3 
4 // MMMMMMMMMMMMMMMMHV"-(??????????????????????????>??>??????????1TWkMMMMMMMMMMMMMMM
5 // MMMMMMMMMMMMMMkY!.??>`   ?<` (????>??>??>???>???????>??>????????vUqMMMMMMMMMMMMM
6 // MMMMMMMMMMMMkY~(???>    ,??+(?????????????>?????>?????????????????zUqMMMMMMMMMMM
7 // MMMMMMMMMMq9!.???????+?????1zu&aagQAAAAAAQaa&&zz??????>??>??>???????vWHMMMMMMMMM
8 // MMMMMMMMMH%.+????????1ugQWHUY""77?!!~~~~<??77"TUWHHkma&z??????????????XkMMMMMMMM
9 // MMMMMMMMH'.??????jgkHUY=~...(+?????????????????>++--(?"4HHmez??>??>????dqMMMMMMM
10 // MMMMMMMH'-????udWY"!..+??????????????>?????????????????+-.?7WHmx????????dqMMMMMM
11 // MMMMMMH\,??1dW9=..+???????????????????>????????????>???????+-.?UHmz??????4kMMMMM
12 // MMMMMqP.??dWY~.????????????1zzz&&&&&&&&&&&zzzz?????????>??????+..7Hmx????zHHMMMM
13 // MMMMNk>+1dK^.???zu&gQkWWkHWUYYT"""""""""""TYYUWHHHkmAa&zz????????-.7kmz???dkMMMM
14 // MMMMHK ?dK~JaQWHY""7!`                              ??"TWHHmA&z????-.4Hz??zkHMMM
15 // MMMMkD dkkHY"!            `  `        `                     ?7UHkA&z+.4Hx??WHMMM
16 // MMMMkD.1WP            `  `    `  ` `   ` ` ` `  `  `             ?TWHm,4Hc?XqMMM
17 // MMMkf.+XK`    `  `  `             `                  `  `  `         dHY93?zHHMM
18 // MMHK +dk:               `  ` `      `  `     `  `  `          `     .H:(????dkMM
19 // MNk>(1WP     `    `    ` ..   `  `      `  `    ` ..   `  `       ` dK.?dWHx1WHM
20 // MHK.?dq\   `   `    `  .kHkH.     `   `       ` Jqkqr   `    `      WF.jK(XH?dqM
21 // Mk%-?dH~      `  `     Xq}dk%   .. `     `  `  .kH.kH_      `   `   k]-zD XWzdkM
22 // Nq)(>dH    ._~~~~_.    XkmkK! ` ?4HXAAXWUUUk_   WkmkK` `  .._~_..   b].zR dWzdkM
23 // Nk[(?XK  .~~~_-_~~~_    ?7=`     dk9=:::::(W:    ?""`   .~~~___~~_. Wb ?4kXS?dqM
24 // MHH.(k%  ~~__~~~~__~_            (R_:~:~~:(K`        `  ~~.__~___~~ (H<<????1XHM
25 // MMHHdH~  ~~~_~____~~_         `   Oh-::::(X\    `       ~~~.~~~.~~~` 4W.?<??dkMM
26 // MMMNHH. ` ~~__~~_~~_   ` `  `      (TWkXVY!  `     `    _~~.____~~_   4H-.(XHMMM
27 // MMMMNq-    `_~~~__`       `    `                `   `    `_~~~~~_`     .XHNMMMMM
28 // MMMMMHh.                `    `   `                   `     `           (kMMMMMMM
29 // MMMMMNHH,           `             `   `  `  `  `  `     `       `  ` .XHMMMMMMMM
30 // MMMMMMMNHHa.  `  `    `  `  ` `    `   `     `       `            ..WHMMMMMMMMMM
31 // MMMMMMMMMNNHqHm+...    `       `           `    `  `   `  ` ` ..JXHNMMMMMMMMMMMM
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38  
39 library SafeMath {
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         assert(c / a == b);
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         assert(c >= a);
64         return c;
65     }
66 }
67 
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization
73  *      control functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     address public owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev The Ownable constructor sets the original `owner` of the contract to the
82      *      sender account.
83      */
84     function Ownable() public {
85         owner = msg.sender;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(msg.sender == owner);
93         _;
94     }
95 
96     /**
97      * @dev Allows the current owner to transfer control of the contract to a newOwner.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) onlyOwner public {
101         require(newOwner != address(0));
102         OwnershipTransferred(owner, newOwner);
103         owner = newOwner;
104     }
105 }
106 
107 
108 
109 /**
110  * @title ERC223
111  * @dev ERC223 contract interface with ERC20 functions and events
112  *      Fully backward compatible with ERC20
113  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
114  */
115 contract ERC223 {
116     uint public totalSupply;
117 
118     // ERC223 and ERC20 functions and events
119     function balanceOf(address who) public view returns (uint);
120     function totalSupply() public view returns (uint256 _supply);
121     function transfer(address to, uint value) public returns (bool ok);
122     function transfer(address to, uint value, bytes data) public returns (bool ok);
123     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
124     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
125 
126     // ERC223 functions
127     function name() public view returns (string _name);
128     function symbol() public view returns (string _symbol);
129     function decimals() public view returns (uint8 _decimals);
130 
131     // ERC20 functions and events
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
133     function approve(address _spender, uint256 _value) public returns (bool success);
134     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
135     event Transfer(address indexed _from, address indexed _to, uint256 _value);
136     event Approval(address indexed _owner, address indexed _spender, uint _value);
137 }
138 
139 
140 
141 /**
142  * @title ContractReceiver
143  * @dev Contract that is working with ERC223 tokens
144  */
145  contract ContractReceiver {
146 
147     struct TKN {
148         address sender;
149         uint value;
150         bytes data;
151         bytes4 sig;
152     }
153 
154     function tokenFallback(address _from, uint _value, bytes _data) public pure {
155         TKN memory tkn;
156         tkn.sender = _from;
157         tkn.value = _value;
158         tkn.data = _data;
159         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
160         tkn.sig = bytes4(u);
161         
162         /*
163          * tkn variable is analogue of msg variable of Ether transaction
164          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
165          * tkn.value the number of tokens that were sent   (analogue of msg.value)
166          * tkn.data is data of token transaction   (analogue of msg.data)
167          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
168          */
169     }
170 }
171 
172 /**
173  * @title GIGAPOSICOIN
174  */
175 contract GIGAPOSICOIN is ERC223, Ownable {
176     using SafeMath for uint256;
177 
178     string public name = "GIGAPOSICOIN";
179     string public symbol = "Gposi";
180     uint8 public decimals = 8;
181     uint256 public totalSupply = 334e6 * 1e8;
182     uint256 public distributeAmount = 0;            // ここを1にすると投票機能が動くけど動くけど今回は動くけど今回はいらない
183     bool public mintingFinished = false;
184 
185     mapping(address => uint256) public balanceOf;
186     mapping(address => mapping (address => uint256)) public allowance;
187     mapping (address => bool) public frozenAccount;
188     mapping (address => uint256) public unlockUnixTime;
189     
190     event FrozenFunds(address indexed target, bool frozen);
191     event LockedFunds(address indexed target, uint256 locked);
192     event Burn(address indexed from, uint256 amount);
193     event Mint(address indexed to, uint256 amount);
194     event MintFinished();
195 
196 
197     /** 
198      * @dev Constructor is called only once and can not be called again
199      */
200     function GIGAPOSICOIN() public {
201         balanceOf[msg.sender] = totalSupply;
202     }
203 
204 
205     function name() public view returns (string _name) {
206         return name;
207     }
208 
209     function symbol() public view returns (string _symbol) {
210         return symbol;
211     }
212 
213     function decimals() public view returns (uint8 _decimals) {
214         return decimals;
215     }
216 
217     function totalSupply() public view returns (uint256 _totalSupply) {
218         return totalSupply;
219     }
220 
221     function balanceOf(address _owner) public view returns (uint256 balance) {
222         return balanceOf[_owner];
223     }
224 
225 
226     /**
227      * @dev Prevent targets from sending or receiving tokens
228      * @param targets Addresses to be frozen
229      * @param isFrozen either to freeze it or not
230      * 特定のアドレスを凍結
231      */
232     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
233         require(targets.length > 0);
234 
235         for (uint j = 0; j < targets.length; j++) {
236             require(targets[j] != 0x0);
237             frozenAccount[targets[j]] = isFrozen;
238             FrozenFunds(targets[j], isFrozen);
239         }
240     }
241 
242     /**
243      * @dev Prevent targets from sending or receiving tokens by setting Unix times
244      * @param targets Addresses to be locked funds
245      * @param unixTimes Unix times when locking up will be finished
246      * アカウントをロックアップする機能
247      */
248     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
249         require(targets.length > 0
250                 && targets.length == unixTimes.length);
251                 
252         for(uint j = 0; j < targets.length; j++){
253             require(unlockUnixTime[targets[j]] < unixTimes[j]);
254             unlockUnixTime[targets[j]] = unixTimes[j];
255             LockedFunds(targets[j], unixTimes[j]);
256         }
257     }
258 
259 
260     /**
261      * @dev Function that is called when a user or another contract wants to transfer funds
262      */
263     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
264         require(_value > 0
265                 && frozenAccount[msg.sender] == false 
266                 && frozenAccount[_to] == false
267                 && now > unlockUnixTime[msg.sender] 
268                 && now > unlockUnixTime[_to]);
269 
270         if (isContract(_to)) {
271             require(balanceOf[msg.sender] >= _value);
272             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
273             balanceOf[_to] = balanceOf[_to].add(_value);
274             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
275             Transfer(msg.sender, _to, _value, _data);
276             Transfer(msg.sender, _to, _value);
277             return true;
278         } else {
279             return transferToAddress(_to, _value, _data);
280         }
281     }
282 
283     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
284         require(_value > 0
285                 && frozenAccount[msg.sender] == false 
286                 && frozenAccount[_to] == false
287                 && now > unlockUnixTime[msg.sender] 
288                 && now > unlockUnixTime[_to]);
289 
290         if (isContract(_to)) {
291             return transferToContract(_to, _value, _data);
292         } else {
293             return transferToAddress(_to, _value, _data);
294         }
295     }
296 
297     /**
298      * @dev Standard function transfer similar to ERC20 transfer with no _data
299      *      Added due to backwards compatibility reasons
300      */
301     function transfer(address _to, uint _value) public returns (bool success) {
302         require(_value > 0
303                 && frozenAccount[msg.sender] == false 
304                 && frozenAccount[_to] == false
305                 && now > unlockUnixTime[msg.sender] 
306                 && now > unlockUnixTime[_to]);
307 
308         bytes memory empty;
309         if (isContract(_to)) {
310             return transferToContract(_to, _value, empty);
311         } else {
312             return transferToAddress(_to, _value, empty);
313         }
314     }
315 
316     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
317     function isContract(address _addr) private view returns (bool is_contract) {
318         uint length;
319         assembly {
320             //retrieve the size of the code on target address, this needs assembly
321             length := extcodesize(_addr)
322         }
323         return (length > 0);
324     }
325 
326     // function that is called when transaction target is an address
327     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
328         require(balanceOf[msg.sender] >= _value);
329         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
330         balanceOf[_to] = balanceOf[_to].add(_value);
331         Transfer(msg.sender, _to, _value, _data);
332         Transfer(msg.sender, _to, _value);
333         return true;
334     }
335 
336     // function that is called when transaction target is a contract
337     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
338         require(balanceOf[msg.sender] >= _value);
339         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
340         balanceOf[_to] = balanceOf[_to].add(_value);
341         ContractReceiver receiver = ContractReceiver(_to);
342         receiver.tokenFallback(msg.sender, _value, _data);
343         Transfer(msg.sender, _to, _value, _data);
344         Transfer(msg.sender, _to, _value);
345         return true;
346     }
347 
348 
349 
350     /**
351      * @dev Transfer tokens from one address to another
352      *      Added due to backwards compatibility with ERC20
353      * @param _from address The address which you want to send tokens from
354      * @param _to address The address which you want to transfer to
355      * @param _value uint256 the amount of tokens to be transferred
356      */
357     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
358         require(_to != address(0)
359                 && _value > 0
360                 && balanceOf[_from] >= _value
361                 && allowance[_from][msg.sender] >= _value
362                 && frozenAccount[_from] == false 
363                 && frozenAccount[_to] == false
364                 && now > unlockUnixTime[_from] 
365                 && now > unlockUnixTime[_to]);
366 
367         balanceOf[_from] = balanceOf[_from].sub(_value);
368         balanceOf[_to] = balanceOf[_to].add(_value);
369         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
370         Transfer(_from, _to, _value);
371         return true;
372     }
373 
374     /**
375      * @dev Allows _spender to spend no more than _value tokens in your behalf
376      *      Added due to backwards compatibility with ERC20
377      * @param _spender The address authorized to spend
378      * @param _value the max amount they can spend
379      */
380     function approve(address _spender, uint256 _value) public returns (bool success) {
381         allowance[msg.sender][_spender] = _value;
382         Approval(msg.sender, _spender, _value);
383         return true;
384     }
385 
386     /**
387      * @dev Function to check the amount of tokens that an owner allowed to a spender
388      *      Added due to backwards compatibility with ERC20
389      * @param _owner address The address which owns the funds
390      * @param _spender address The address which will spend the funds
391      */
392     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
393         return allowance[_owner][_spender];
394     }
395 
396 
397 
398     /**
399      * @dev Burns a specific amount of tokens.
400      * @param _from The address that will burn the tokens.
401      * @param _unitAmount The amount of token to be burned.
402      */
403     function burn(address _from, uint256 _unitAmount) onlyOwner public {
404         require(_unitAmount > 0
405                 && balanceOf[_from] >= _unitAmount);
406 
407         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
408         totalSupply = totalSupply.sub(_unitAmount);
409         Burn(_from, _unitAmount);
410     }
411 
412 
413     modifier canMint() {
414         require(!mintingFinished);
415         _;
416     }
417 
418     /**
419      * @dev Function to mint tokens
420      * @param _to The address that will receive the minted tokens.
421      * @param _unitAmount The amount of tokens to mint.
422      */
423     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
424         require(_unitAmount > 0);
425         
426         totalSupply = totalSupply.add(_unitAmount);
427         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
428         Mint(_to, _unitAmount);
429         Transfer(address(0), _to, _unitAmount);
430         return true;
431     }
432 
433     /**
434      * @dev Function to stop minting new tokens.
435      */
436     function finishMinting() onlyOwner canMint public returns (bool) {
437         mintingFinished = true;
438         MintFinished();
439         return true;
440     }
441 
442 
443 
444     /**
445      * @dev Function to distribute tokens to the list of addresses by the provided amount
446      */
447     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
448         require(amount > 0 
449                 && addresses.length > 0
450                 && frozenAccount[msg.sender] == false
451                 && now > unlockUnixTime[msg.sender]);
452 
453         amount = amount.mul(1e8);
454         uint256 totalAmount = amount.mul(addresses.length);
455         require(balanceOf[msg.sender] >= totalAmount);
456         
457         for (uint j = 0; j < addresses.length; j++) {
458             require(addresses[j] != 0x0
459                     && frozenAccount[addresses[j]] == false
460                     && now > unlockUnixTime[addresses[j]]);
461 
462             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
463             Transfer(msg.sender, addresses[j], amount);
464         }
465         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
466         return true;
467     }
468 
469     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
470         require(addresses.length > 0
471                 && addresses.length == amounts.length
472                 && frozenAccount[msg.sender] == false
473                 && now > unlockUnixTime[msg.sender]);
474                 
475         uint256 totalAmount = 0;
476         
477         for(uint j = 0; j < addresses.length; j++){
478             require(amounts[j] > 0
479                     && addresses[j] != 0x0
480                     && frozenAccount[addresses[j]] == false
481                     && now > unlockUnixTime[addresses[j]]);
482                     
483             amounts[j] = amounts[j].mul(1e8);
484             totalAmount = totalAmount.add(amounts[j]);
485         }
486         require(balanceOf[msg.sender] >= totalAmount);
487         
488         for (j = 0; j < addresses.length; j++) {
489             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
490             Transfer(msg.sender, addresses[j], amounts[j]);
491         }
492         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
493         return true;
494     }
495 
496     /**
497      * @dev Function to collect tokens from the list of addresses
498      */
499     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
500         require(addresses.length > 0
501                 && addresses.length == amounts.length);
502 
503         uint256 totalAmount = 0;
504         
505         for (uint j = 0; j < addresses.length; j++) {
506             require(amounts[j] > 0
507                     && addresses[j] != 0x0
508                     && frozenAccount[addresses[j]] == false
509                     && now > unlockUnixTime[addresses[j]]);
510                     
511             amounts[j] = amounts[j].mul(1e8);
512             require(balanceOf[addresses[j]] >= amounts[j]);
513             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
514             totalAmount = totalAmount.add(amounts[j]);
515             Transfer(addresses[j], msg.sender, amounts[j]);
516         }
517         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
518         return true;
519     }
520 
521 
522     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
523         distributeAmount = _unitAmount;
524     }
525     
526     /**
527      * @dev Function to distribute tokens to the msg.sender automatically
528      *      If distributeAmount is 0, this function doesn't work
529      */
530     function autoDistribute() payable public {
531         require(distributeAmount > 0
532                 && balanceOf[owner] >= distributeAmount
533                 && frozenAccount[msg.sender] == false
534                 && now > unlockUnixTime[msg.sender]);
535         if(msg.value > 0) owner.transfer(msg.value);
536         
537         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
538         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
539         Transfer(owner, msg.sender, distributeAmount);
540     }
541 
542     /**
543      * @dev fallback function
544      */
545     function() payable public {
546         autoDistribute();
547      }
548 
549 }