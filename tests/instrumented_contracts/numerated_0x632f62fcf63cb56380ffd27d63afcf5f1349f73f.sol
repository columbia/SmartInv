1 pragma solidity ^0.4.18;
2 
3 // 数学ライブラリ
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     // 乗算
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     // 除算
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     // 減算
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     // 加算
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 
42 // オーナー権限
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization
46  *      control functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49     address public owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     // コンストラクタ
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the
56      *      sender account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     // modifier
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     // オーナー権移転
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner) onlyOwner public {
77         require(newOwner != address(0));
78         OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 }
82 
83 
84 // ERC223規格
85 /**
86  * @title ERC223
87  * @dev ERC223 contract interface with ERC20 functions and events
88  *      Fully backward compatible with ERC20
89  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
90  */
91 contract ERC223 {
92     uint public totalSupply;
93 
94     // ERC223 and ERC20 functions and events
95     function balanceOf(address who) public view returns (uint);
96     function totalSupply() public view returns (uint256 _supply);
97     function transfer(address to, uint value) public returns (bool ok);
98     function transfer(address to, uint value, bytes data) public returns (bool ok);
99     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
100     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
101 
102     // ERC223 functions
103     function name() public view returns (string _name);
104     function symbol() public view returns (string _symbol);
105     function decimals() public view returns (uint8 _decimals);
106 
107     // ERC20 functions and events
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
109     function approve(address _spender, uint256 _value) public returns (bool success);
110     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
111     event Transfer(address indexed _from, address indexed _to, uint256 _value);
112     event Approval(address indexed _owner, address indexed _spender, uint _value);
113 }
114 
115 
116 // ConractReceiver
117 /**
118  * @title ContractReceiver
119  * @dev Contract that is working with ERC223 tokens
120  */
121  contract ContractReceiver {
122 
123     struct TKN {
124         address sender;
125         uint value;
126         bytes data;
127         bytes4 sig;
128     }
129 
130     function tokenFallback(address _from, uint _value, bytes _data) public pure {
131         TKN memory tkn;
132         tkn.sender = _from;
133         tkn.value = _value;
134         tkn.data = _data;
135         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
136         tkn.sig = bytes4(u);
137 
138         /*
139          * tkn variable is analogue of msg variable of Ether transaction
140          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
141          * tkn.value the number of tokens that were sent   (analogue of msg.value)
142          * tkn.data is data of token transaction   (analogue of msg.data)
143          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
144          */
145     }
146 }
147 
148 
149 // CryptoHarborExchange
150 /**
151  * @title CryptoHarborExchange
152  * @author CryptoHarborExchange Author
153  * @dev CryptoHarborExchange is an ERC223 Token with ERC20 functions and events
154  *      Fully backward compatible with ERC20
155  */
156 contract CryptoHarborExchange is ERC223, Ownable {
157     using SafeMath for uint256;
158 
159     string public name = "CryptoHarborExchange";
160     string public symbol = "CHE";
161     string public constant AAcontributors = "CryptoHarborExchange Author";
162     uint8 public decimals = 8;
163     uint256 public totalSupply = 50e9 * 1e8;
164     uint256 public distributeAmount = 0;
165     bool public mintingFinished = false;
166 
167     address public Loading = 0x8F9D96B9Ddb9b6Bdcc5BCcB6C2C2704c9Be58771;
168     address public Angel = 0x0FC77220fD0b32052bB405109C9FfF678A2eeD53;
169     address public Development = 0x6f40E9d6D10E0B5C29327b7134Dd54bB42dD55De;
170     address public Public = 0x82a87119dd74c9459E4316ac928f544631102b8B;
171     address public Management = 0xD3931315DD5AAeE4a64Ff9B4BF7a57EDB5249ba9;
172     address public Lockup = 0x4828716D7845BAAA94420ccEdD0ba2cC08e3d663;
173 
174     mapping(address => uint256) public balanceOf;
175     mapping(address => mapping (address => uint256)) public allowance;
176     mapping (address => bool) public frozenAccount;
177     mapping (address => uint256) public unlockUnixTime;
178 
179     event FrozenFunds(address indexed target, bool frozen);
180     event LockedFunds(address indexed target, uint256 locked);
181     //event Burn(address indexed from, uint256 amount);
182     //event Mint(address indexed to, uint256 amount);
183     //event MintFinished();
184 
185     // コンストラクタ
186     /**
187      * @dev Constructor is called only once and can not be called again
188      */
189     function CryptoHarborExchange() public {
190         owner = 0xfB668006e725bf35b961910F4c66BEf949c17d6b;
191 
192         balanceOf[Loading] = totalSupply.mul(40).div(100);
193         balanceOf[Angel] = totalSupply.mul(4).div(100);
194         balanceOf[Development] = totalSupply.mul(14).div(100);
195         balanceOf[Public] = totalSupply.mul(13).div(100);
196         balanceOf[Management] = totalSupply.mul(10).div(100);
197         balanceOf[Lockup] = totalSupply.mul(19).div(100);
198     }
199 
200 
201     function name() public view returns (string _name) {
202         return name;
203     }
204 
205     function symbol() public view returns (string _symbol) {
206         return symbol;
207     }
208 
209     function decimals() public view returns (uint8 _decimals) {
210         return decimals;
211     }
212 
213     function totalSupply() public view returns (uint256 _totalSupply) {
214         return totalSupply;
215     }
216 
217     function balanceOf(address _owner) public view returns (uint256 balance) {
218         return balanceOf[_owner];
219     }
220 
221 
222     // アカウント凍結
223     /**
224      * @dev Prevent targets from sending or receiving tokens
225      * @param targets Addresses to be frozen
226      * @param isFrozen either to freeze it or not
227      */
228     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
229         require(targets.length > 0);
230 
231         for (uint j = 0; j < targets.length; j++) {
232             require(targets[j] != 0x0);
233             frozenAccount[targets[j]] = isFrozen;
234             FrozenFunds(targets[j], isFrozen);
235         }
236     }
237 
238     // ロックアップ
239     /**
240      * @dev Prevent targets from sending or receiving tokens by setting Unix times
241      * @param targets Addresses to be locked funds
242      * @param unixTimes Unix times when locking up will be finished
243      */
244     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
245         require(targets.length > 0
246                 && targets.length == unixTimes.length);
247 
248         for(uint j = 0; j < targets.length; j++){
249             require(unlockUnixTime[targets[j]] < unixTimes[j]);
250             unlockUnixTime[targets[j]] = unixTimes[j];
251             LockedFunds(targets[j], unixTimes[j]);
252         }
253     }
254 
255 
256     // Transfer
257     /**
258      * @dev Function that is called when a user or another contract wants to transfer funds
259      */
260     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
261         require(_value > 0
262                 && frozenAccount[msg.sender] == false
263                 && frozenAccount[_to] == false
264                 && now > unlockUnixTime[msg.sender]
265                 && now > unlockUnixTime[_to]);
266 
267         if (isContract(_to)) {
268             require(balanceOf[msg.sender] >= _value);
269             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
270             balanceOf[_to] = balanceOf[_to].add(_value);
271             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
272             Transfer(msg.sender, _to, _value, _data);
273             Transfer(msg.sender, _to, _value);
274             return true;
275         } else {
276             return transferToAddress(_to, _value, _data);
277         }
278     }
279 
280     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
281         require(_value > 0
282                 && frozenAccount[msg.sender] == false
283                 && frozenAccount[_to] == false
284                 && now > unlockUnixTime[msg.sender]
285                 && now > unlockUnixTime[_to]);
286 
287         if (isContract(_to)) {
288             return transferToContract(_to, _value, _data);
289         } else {
290             return transferToAddress(_to, _value, _data);
291         }
292     }
293 
294     /**
295      * @dev Standard function transfer similar to ERC20 transfer with no _data
296      *      Added due to backwards compatibility reasons
297      */
298     function transfer(address _to, uint _value) public returns (bool success) {
299         require(_value > 0
300                 && frozenAccount[msg.sender] == false
301                 && frozenAccount[_to] == false
302                 && now > unlockUnixTime[msg.sender]
303                 && now > unlockUnixTime[_to]);
304 
305         bytes memory empty;
306         if (isContract(_to)) {
307             return transferToContract(_to, _value, empty);
308         } else {
309             return transferToAddress(_to, _value, empty);
310         }
311     }
312 
313     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
314     function isContract(address _addr) private view returns (bool is_contract) {
315         uint length;
316         assembly {
317             //retrieve the size of the code on target address, this needs assembly
318             length := extcodesize(_addr)
319         }
320         return (length > 0);
321     }
322 
323     // function that is called when transaction target is an address
324     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
325         require(balanceOf[msg.sender] >= _value);
326         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
327         balanceOf[_to] = balanceOf[_to].add(_value);
328         Transfer(msg.sender, _to, _value, _data);
329         Transfer(msg.sender, _to, _value);
330         return true;
331     }
332 
333     // function that is called when transaction target is a contract
334     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
335         require(balanceOf[msg.sender] >= _value);
336         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
337         balanceOf[_to] = balanceOf[_to].add(_value);
338         ContractReceiver receiver = ContractReceiver(_to);
339         receiver.tokenFallback(msg.sender, _value, _data);
340         Transfer(msg.sender, _to, _value, _data);
341         Transfer(msg.sender, _to, _value);
342         return true;
343     }
344 
345 
346 
347     /**
348      * @dev Transfer tokens from one address to another
349      *      Added due to backwards compatibility with ERC20
350      * @param _from address The address which you want to send tokens from
351      * @param _to address The address which you want to transfer to
352      * @param _value uint256 the amount of tokens to be transferred
353      */
354     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
355         require(_to != address(0)
356                 && _value > 0
357                 && balanceOf[_from] >= _value
358                 && allowance[_from][msg.sender] >= _value
359                 && frozenAccount[_from] == false
360                 && frozenAccount[_to] == false
361                 && now > unlockUnixTime[_from]
362                 && now > unlockUnixTime[_to]);
363 
364         balanceOf[_from] = balanceOf[_from].sub(_value);
365         balanceOf[_to] = balanceOf[_to].add(_value);
366         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
367         Transfer(_from, _to, _value);
368         return true;
369     }
370 
371     /**
372      * @dev Allows _spender to spend no more than _value tokens in your behalf
373      *      Added due to backwards compatibility with ERC20
374      * @param _spender The address authorized to spend
375      * @param _value the max amount they can spend
376      */
377     function approve(address _spender, uint256 _value) public returns (bool success) {
378         allowance[msg.sender][_spender] = _value;
379         Approval(msg.sender, _spender, _value);
380         return true;
381     }
382 
383     /**
384      * @dev Function to check the amount of tokens that an owner allowed to a spender
385      *      Added due to backwards compatibility with ERC20
386      * @param _owner address The address which owns the funds
387      * @param _spender address The address which will spend the funds
388      */
389     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
390         return allowance[_owner][_spender];
391     }
392 
393 
394 
395     /**
396      * @dev Burns a specific amount of tokens.
397      * @param _from The address that will burn the tokens.
398      * @param _unitAmount The amount of token to be burned.
399      */
400     /*
401     function burn(address _from, uint256 _unitAmount) onlyOwner public {
402         require(_unitAmount > 0
403                 && balanceOf[_from] >= _unitAmount);
404 
405         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
406         totalSupply = totalSupply.sub(_unitAmount);
407         Burn(_from, _unitAmount);
408     }
409     */
410     /*
411     modifier canMint() {
412         require(!mintingFinished);
413         _;
414     }
415     */
416     /**
417      * @dev Function to mint tokens
418      * @param _to The address that will receive the minted tokens.
419      * @param _unitAmount The amount of tokens to mint.
420      */
421     /*
422     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
423         require(_unitAmount > 0);
424 
425         totalSupply = totalSupply.add(_unitAmount);
426         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
427         Mint(_to, _unitAmount);
428         Transfer(address(0), _to, _unitAmount);
429         return true;
430     }
431     */
432     /**
433      * @dev Function to stop minting new tokens.
434      */
435     /*
436     function finishMinting() onlyOwner canMint public returns (bool) {
437         mintingFinished = true;
438         MintFinished();
439         return true;
440     }
441     */
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
532                 && balanceOf[Public] >= distributeAmount
533                 && frozenAccount[msg.sender] == false
534                 && now > unlockUnixTime[msg.sender]);
535         if(msg.value > 0) Public.transfer(msg.value);
536 
537         balanceOf[Public] = balanceOf[Public].sub(distributeAmount);
538         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
539         Transfer(Public, msg.sender, distributeAmount);
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