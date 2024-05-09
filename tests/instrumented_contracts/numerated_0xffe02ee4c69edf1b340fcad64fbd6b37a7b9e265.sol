1 pragma solidity ^0.4.18;
2 
3 /*   __    __   ______   __    __     _____    ______    ______   ______  __    __
4  *  /  \  /  | /      \ /  \  /  |   /     |  /      \  /      \ /      |/  \  /  |
5  *  $$  \ $$ |/$$$$$$  |$$  \ $$ |   $$$$$ | /$$$$$$  |/$$$$$$  |$$$$$$/ $$  \ $$ |
6  *  $$$  \$$ |$$ |__$$ |$$$  \$$ |      $$ | $$ |  $$/ $$ |  $$ |  $$ |  $$$  \$$ |
7  *  $$$$  $$ |$$    $$ |$$$$  $$ | __   $$ | $$ |      $$ |  $$ |  $$ |  $$$$  $$ |
8  *  $$ $$ $$ |$$$$$$$$ |$$ $$ $$ |/  |  $$ | $$ |   __ $$ |  $$ |  $$ |  $$ $$ $$ |
9  *  $$ |$$$$ |$$ |  $$ |$$ |$$$$ |$$ \__$$ | $$ \__/  |$$ \__$$ | _$$ |_ $$ |$$$$ |
10  *  $$ | $$$ |$$ |  $$ |$$ | $$$ |$$    $$/  $$    $$/ $$    $$/ / $$   |$$ | $$$ |
11  *  $$/   $$/ $$/   $$/ $$/   $$/  $$$$$$/    $$$$$$/   $$$$$$/  $$$$$$/ $$/   $$/ 
12  */
13 
14 
15 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
16 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
17 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ      JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
18 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ              JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
19 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ                      JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
20 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ                            JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
21 // JJJJJJJJJJJJJJJJJJJJJJJJJJ                                  JJJJJJJJJJJJJJJJJJJJJJJJJJ
22 // JJJJJJJJJJJJJJJJJJJJJJ                                          JJJJJJJJJJJJJJJJJJJJJJ
23 // JJJJJJJJJJJJJJJJJJJ                                                JJJJJJJJJJJJJJJJJJJ
24 // JJJJJJJJJJJJJJJJJ]                                        JJJJJ     [JJJJJJJJJJJJJJJJJ
25 // JJJJJJJJJJJJJJJJJ]                                        JJJJJJ    [JJJJJJJJJJJJJJJJJ
26 // JJJJJJJJJJJJJJJJJ]                                        JJJJJJ    [JJJJJJJJJJJJJJJJJ
27 // JJJJJJJJJJJJJJJJJ]                                        JJJJJJ    [JJJJJJJJJJJJJJJJJ
28 // JJJJJJJJJJJJJJJJJ]                                        JJJJJJ    [JJJJJJJJJJJJJJJJJ
29 // JJJJJJJJJJJJJJJJJ]                   ,                    JJJJJJ    [JJJJJJJJJJJJJJJJJ
30 // JJJJJJJJJJJJJJJJJ]      NN    NN     AA     NN    NN      JJJJJJ    [JJJJJJJJJJJJJJJJJ
31 // JJJJJJJJJJJJJJJJJ]      NNNN  NN    A  A    NNNN  NN      JJJJJJ    [JJJJJJJJJJJJJJJJJ
32 // JJJJJJJJJJJJJJJJJ]      NN  NNNN   AAAAAA   NN  NNNN      JJJJJJ    [JJJJJJJJJJJJJJJJJ
33 // JJJJJJJJJJJJJJJJJ]      NN    NN  AA    AA  NN    NN      JJJJJJ    [JJJJJJJJJJJJJJJJJ
34 // JJJJJJJJJJJJJJJJJ]                                        JJJJJJ    [JJJJJJJJJJJJJJJJJ
35 // JJJJJJJJJJJJJJJJJ]                                        JJJJJJ    [JJJJJJJJJJJJJJJJJ
36 // JJJJJJJJJJJJJJJJJ]                                       JJJJJJJ    [JJJJJJJJJJJJJJJJJ
37 // JJJJJJJJJJJJJJJJJ]                                   JJJJJJJJJJJ    [JJJJJJJJJJJJJJJJJ
38 // JJJJJJJJJJJJJJJJJ]                                JJJJJJJJJJJJJJ    [JJJJJJJJJJJJJJJJJ
39 // JJJJJJJJJJJJJJJJJJ                             JJJJJJJJJJJJJJ       JJJJJJJJJJJJJJJJJJ
40 // JJJJJJJJJJJJJJJJJJJ                        JJJJJJJJJJJJJJJ        JJJJJJJJJJJJJJJJJJJJ
41 // JJJJJJJJJJJJJJJJJJJJJJ                     JJJJJJJJJJJ         JJJJJJJJJJJJJJJJJJJJJJJ
42 // JJJJJJJJJJJJJJJJJJJJJJJJJJ                 JJJJJJJ          JJJJJJJJJJJJJJJJJJJJJJJJJJ
43 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ              JJJ           JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
44 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ                      JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
45 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ              JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
46 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ      JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
47 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
48 // JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
49 
50 
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         assert(c / a == b);
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // assert(b > 0); // Solidity automatically throws when dividing by 0
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         assert(c >= a);
81         return c;
82     }
83 }
84 
85 
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization
90  *      control functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93     address public owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /**
98      * @dev The Ownable constructor sets the original `owner` of the contract to the
99      *      sender account.
100      */
101     function Ownable() public {
102         owner = msg.sender;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     /**
114      * @dev Allows the current owner to transfer control of the contract to a newOwner.
115      * @param newOwner The address to transfer ownership to.
116      */
117     function transferOwnership(address newOwner) onlyOwner public {
118         require(newOwner != address(0));
119         OwnershipTransferred(owner, newOwner);
120         owner = newOwner;
121     }
122 }
123 
124 
125 
126 /**
127  * 彡(^)(^)
128  * @title ERC223
129  * @dev ERC223 contract interface with ERC20 functions and events
130  *      Fully backward compatible with ERC20
131  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
132  */
133 contract ERC223 {
134     uint public totalSupply;
135 
136     // ERC223 and ERC20 functions and events
137     function balanceOf(address who) public view returns (uint);
138     function totalSupply() public view returns (uint256 _supply);
139     function transfer(address to, uint value) public returns (bool ok);
140     function transfer(address to, uint value, bytes data) public returns (bool ok);
141     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
142     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
143 
144     // ERC223 functions
145     function name() public view returns (string _name);
146     function symbol() public view returns (string _symbol);
147     function decimals() public view returns (uint8 _decimals);
148 
149     // ERC20 functions and events
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
151     function approve(address _spender, uint256 _value) public returns (bool success);
152     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
153     event Transfer(address indexed _from, address indexed _to, uint256 _value);
154     event Approval(address indexed _owner, address indexed _spender, uint _value);
155 }
156 
157 
158 
159 /**
160  * @title ContractReceiver
161  * @dev Contract that is working with ERC223 tokens
162  */
163  contract ContractReceiver {
164 
165     struct TKN {
166         address sender;
167         uint value;
168         bytes data;
169         bytes4 sig;
170     }
171 
172     function tokenFallback(address _from, uint _value, bytes _data) public pure {
173         TKN memory tkn;
174         tkn.sender = _from;
175         tkn.value = _value;
176         tkn.data = _data;
177         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
178         tkn.sig = bytes4(u);
179         
180         /*
181          * tkn variable is analogue of msg variable of Ether transaction
182          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
183          * tkn.value the number of tokens that were sent   (analogue of msg.value)
184          * tkn.data is data of token transaction   (analogue of msg.data)
185          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
186          */
187     }
188 }
189 
190 
191 /*************************
192  * 
193  *  `＿　　　　　   (三|  
194  *  |ﾋ_)　／￣￣＼ 　LﾆO  
195  *  | | ／●) (●)  ＼｜｜  
196  *  |_|(　(_人_)　　)^亅  
197  *  | ヽ＼　￣　＿／ ミﾉ  
198  *  ヽﾉﾉ￣|ﾚ―-ｲ / ﾉ  ／   
199  *  　＼　ヽ＼ |/ イ      
200  * 　／￣二二二二二二＼   
201  * `｜答｜  N A N J ｜｜  
202  * 　＼＿二二二二二二／   
203  *
204  *************************/
205 
206 /**
207  * 彡(ﾟ)(ﾟ)
208  * @title NANJCOIN
209  * @author Tsuchinoko & NanJ people
210  * @dev NANJCOIN is an ERC223 Token with ERC20 functions and events
211  *      Fully backward compatible with ERC20
212  */
213 contract NANJCOIN is ERC223, Ownable {
214     using SafeMath for uint256;
215 
216     string public name = "NANJCOIN";
217     string public symbol = "NANJ";
218     string public constant AAcontributors = "sybit & クリプたん";
219     uint8 public decimals = 8;
220     uint256 public totalSupply = 30e9 * 1e8;
221     uint256 public distributeAmount = 0;
222     bool public mintingFinished = false;
223     
224     address public founder = 0x1B746E35C90050E3cc236479051467F623CA14f7;
225     address public preSeasonGame = 0xAeC7cF1da46a76ad3A41580e28E778ff8849ec49;
226     address public activityFunds = 0x728899556c836ce7F8AA73e8BaCE3241F17077bF;
227     address public lockedFundsForthefuture = 0xB80c43bf83f7Cb6c44b84B436b01Ea92Da5dabFF;
228 
229     mapping(address => uint256) public balanceOf;
230     mapping(address => mapping (address => uint256)) public allowance;
231     mapping (address => bool) public frozenAccount;
232     mapping (address => uint256) public unlockUnixTime;
233     
234     event FrozenFunds(address indexed target, bool frozen);
235     event LockedFunds(address indexed target, uint256 locked);
236     event Burn(address indexed from, uint256 amount);
237     event Mint(address indexed to, uint256 amount);
238     event MintFinished();
239 
240 
241     /** 
242      * @dev Constructor is called only once and can not be called again
243      */
244     function NANJCOIN() public {
245         owner = activityFunds;
246         
247         balanceOf[founder] = totalSupply.mul(25).div(100);
248         balanceOf[preSeasonGame] = totalSupply.mul(55).div(100);
249         balanceOf[activityFunds] = totalSupply.mul(10).div(100);
250         balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
251     }
252 
253 
254     function name() public view returns (string _name) {
255         return name;
256     }
257 
258     function symbol() public view returns (string _symbol) {
259         return symbol;
260     }
261 
262     function decimals() public view returns (uint8 _decimals) {
263         return decimals;
264     }
265 
266     function totalSupply() public view returns (uint256 _totalSupply) {
267         return totalSupply;
268     }
269 
270     function balanceOf(address _owner) public view returns (uint256 balance) {
271         return balanceOf[_owner];
272     }
273 
274 
275     /**
276      * @dev Prevent targets from sending or receiving tokens
277      * @param targets Addresses to be frozen
278      * @param isFrozen either to freeze it or not
279      */
280     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
281         require(targets.length > 0);
282 
283         for (uint j = 0; j < targets.length; j++) {
284             require(targets[j] != 0x0);
285             frozenAccount[targets[j]] = isFrozen;
286             FrozenFunds(targets[j], isFrozen);
287         }
288     }
289 
290     /**
291      * @dev Prevent targets from sending or receiving tokens by setting Unix times
292      * @param targets Addresses to be locked funds
293      * @param unixTimes Unix times when locking up will be finished
294      */
295     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
296         require(targets.length > 0
297                 && targets.length == unixTimes.length);
298                 
299         for(uint j = 0; j < targets.length; j++){
300             require(unlockUnixTime[targets[j]] < unixTimes[j]);
301             unlockUnixTime[targets[j]] = unixTimes[j];
302             LockedFunds(targets[j], unixTimes[j]);
303         }
304     }
305 
306 
307     /**
308      * @dev Function that is called when a user or another contract wants to transfer funds
309      */
310     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
311         require(_value > 0
312                 && frozenAccount[msg.sender] == false 
313                 && frozenAccount[_to] == false
314                 && now > unlockUnixTime[msg.sender] 
315                 && now > unlockUnixTime[_to]);
316 
317         if (isContract(_to)) {
318             require(balanceOf[msg.sender] >= _value);
319             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
320             balanceOf[_to] = balanceOf[_to].add(_value);
321             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
322             Transfer(msg.sender, _to, _value, _data);
323             Transfer(msg.sender, _to, _value);
324             return true;
325         } else {
326             return transferToAddress(_to, _value, _data);
327         }
328     }
329 
330     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
331         require(_value > 0
332                 && frozenAccount[msg.sender] == false 
333                 && frozenAccount[_to] == false
334                 && now > unlockUnixTime[msg.sender] 
335                 && now > unlockUnixTime[_to]);
336 
337         if (isContract(_to)) {
338             return transferToContract(_to, _value, _data);
339         } else {
340             return transferToAddress(_to, _value, _data);
341         }
342     }
343 
344     /**
345      * @dev Standard function transfer similar to ERC20 transfer with no _data
346      *      Added due to backwards compatibility reasons
347      */
348     function transfer(address _to, uint _value) public returns (bool success) {
349         require(_value > 0
350                 && frozenAccount[msg.sender] == false 
351                 && frozenAccount[_to] == false
352                 && now > unlockUnixTime[msg.sender] 
353                 && now > unlockUnixTime[_to]);
354 
355         bytes memory empty;
356         if (isContract(_to)) {
357             return transferToContract(_to, _value, empty);
358         } else {
359             return transferToAddress(_to, _value, empty);
360         }
361     }
362 
363     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
364     function isContract(address _addr) private view returns (bool is_contract) {
365         uint length;
366         assembly {
367             //retrieve the size of the code on target address, this needs assembly
368             length := extcodesize(_addr)
369         }
370         return (length > 0);
371     }
372 
373     // function that is called when transaction target is an address
374     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
375         require(balanceOf[msg.sender] >= _value);
376         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
377         balanceOf[_to] = balanceOf[_to].add(_value);
378         Transfer(msg.sender, _to, _value, _data);
379         Transfer(msg.sender, _to, _value);
380         return true;
381     }
382 
383     // function that is called when transaction target is a contract
384     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
385         require(balanceOf[msg.sender] >= _value);
386         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
387         balanceOf[_to] = balanceOf[_to].add(_value);
388         ContractReceiver receiver = ContractReceiver(_to);
389         receiver.tokenFallback(msg.sender, _value, _data);
390         Transfer(msg.sender, _to, _value, _data);
391         Transfer(msg.sender, _to, _value);
392         return true;
393     }
394 
395 
396 
397     /**
398      * @dev Transfer tokens from one address to another
399      *      Added due to backwards compatibility with ERC20
400      * @param _from address The address which you want to send tokens from
401      * @param _to address The address which you want to transfer to
402      * @param _value uint256 the amount of tokens to be transferred
403      */
404     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
405         require(_to != address(0)
406                 && _value > 0
407                 && balanceOf[_from] >= _value
408                 && allowance[_from][msg.sender] >= _value
409                 && frozenAccount[_from] == false 
410                 && frozenAccount[_to] == false
411                 && now > unlockUnixTime[_from] 
412                 && now > unlockUnixTime[_to]);
413 
414         balanceOf[_from] = balanceOf[_from].sub(_value);
415         balanceOf[_to] = balanceOf[_to].add(_value);
416         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
417         Transfer(_from, _to, _value);
418         return true;
419     }
420 
421     /**
422      * @dev Allows _spender to spend no more than _value tokens in your behalf
423      *      Added due to backwards compatibility with ERC20
424      * @param _spender The address authorized to spend
425      * @param _value the max amount they can spend
426      */
427     function approve(address _spender, uint256 _value) public returns (bool success) {
428         allowance[msg.sender][_spender] = _value;
429         Approval(msg.sender, _spender, _value);
430         return true;
431     }
432 
433     /**
434      * @dev Function to check the amount of tokens that an owner allowed to a spender
435      *      Added due to backwards compatibility with ERC20
436      * @param _owner address The address which owns the funds
437      * @param _spender address The address which will spend the funds
438      */
439     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
440         return allowance[_owner][_spender];
441     }
442 
443 
444 
445     /**
446      * @dev Burns a specific amount of tokens.
447      * @param _from The address that will burn the tokens.
448      * @param _unitAmount The amount of token to be burned.
449      */
450     function burn(address _from, uint256 _unitAmount) onlyOwner public {
451         require(_unitAmount > 0
452                 && balanceOf[_from] >= _unitAmount);
453 
454         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
455         totalSupply = totalSupply.sub(_unitAmount);
456         Burn(_from, _unitAmount);
457     }
458 
459 
460     modifier canMint() {
461         require(!mintingFinished);
462         _;
463     }
464 
465     /**
466      * @dev Function to mint tokens
467      * @param _to The address that will receive the minted tokens.
468      * @param _unitAmount The amount of tokens to mint.
469      */
470     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
471         require(_unitAmount > 0);
472         
473         totalSupply = totalSupply.add(_unitAmount);
474         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
475         Mint(_to, _unitAmount);
476         Transfer(address(0), _to, _unitAmount);
477         return true;
478     }
479 
480     /**
481      * @dev Function to stop minting new tokens.
482      */
483     function finishMinting() onlyOwner canMint public returns (bool) {
484         mintingFinished = true;
485         MintFinished();
486         return true;
487     }
488 
489 
490 
491     /**
492      * @dev Function to distribute tokens to the list of addresses by the provided amount
493      */
494     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
495         require(amount > 0 
496                 && addresses.length > 0
497                 && frozenAccount[msg.sender] == false
498                 && now > unlockUnixTime[msg.sender]);
499 
500         amount = amount.mul(1e8);
501         uint256 totalAmount = amount.mul(addresses.length);
502         require(balanceOf[msg.sender] >= totalAmount);
503         
504         for (uint j = 0; j < addresses.length; j++) {
505             require(addresses[j] != 0x0
506                     && frozenAccount[addresses[j]] == false
507                     && now > unlockUnixTime[addresses[j]]);
508 
509             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
510             Transfer(msg.sender, addresses[j], amount);
511         }
512         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
513         return true;
514     }
515 
516     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
517         require(addresses.length > 0
518                 && addresses.length == amounts.length
519                 && frozenAccount[msg.sender] == false
520                 && now > unlockUnixTime[msg.sender]);
521                 
522         uint256 totalAmount = 0;
523         
524         for(uint j = 0; j < addresses.length; j++){
525             require(amounts[j] > 0
526                     && addresses[j] != 0x0
527                     && frozenAccount[addresses[j]] == false
528                     && now > unlockUnixTime[addresses[j]]);
529                     
530             amounts[j] = amounts[j].mul(1e8);
531             totalAmount = totalAmount.add(amounts[j]);
532         }
533         require(balanceOf[msg.sender] >= totalAmount);
534         
535         for (j = 0; j < addresses.length; j++) {
536             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
537             Transfer(msg.sender, addresses[j], amounts[j]);
538         }
539         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
540         return true;
541     }
542 
543     /**
544      * @dev Function to collect tokens from the list of addresses
545      */
546     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
547         require(addresses.length > 0
548                 && addresses.length == amounts.length);
549 
550         uint256 totalAmount = 0;
551         
552         for (uint j = 0; j < addresses.length; j++) {
553             require(amounts[j] > 0
554                     && addresses[j] != 0x0
555                     && frozenAccount[addresses[j]] == false
556                     && now > unlockUnixTime[addresses[j]]);
557                     
558             amounts[j] = amounts[j].mul(1e8);
559             require(balanceOf[addresses[j]] >= amounts[j]);
560             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
561             totalAmount = totalAmount.add(amounts[j]);
562             Transfer(addresses[j], msg.sender, amounts[j]);
563         }
564         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
565         return true;
566     }
567 
568 
569     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
570         distributeAmount = _unitAmount;
571     }
572     
573     /**
574      * @dev Function to distribute tokens to the msg.sender automatically
575      *      If distributeAmount is 0, this function doesn't work
576      */
577     function autoDistribute() payable public {
578         require(distributeAmount > 0
579                 && balanceOf[activityFunds] >= distributeAmount
580                 && frozenAccount[msg.sender] == false
581                 && now > unlockUnixTime[msg.sender]);
582         if(msg.value > 0) activityFunds.transfer(msg.value);
583         
584         balanceOf[activityFunds] = balanceOf[activityFunds].sub(distributeAmount);
585         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
586         Transfer(activityFunds, msg.sender, distributeAmount);
587     }
588 
589     /**
590      * @dev fallback function
591      */
592     function() payable public {
593         autoDistribute();
594      }
595 
596 }
597 
598 
599 /*
600  *（｀・ω・）（｀・ω・´）（・ω・´）
601  *     Created by Tsuchinoko
602  *（´・ω・）（´・ω・｀）（・ω・｀）
603  */