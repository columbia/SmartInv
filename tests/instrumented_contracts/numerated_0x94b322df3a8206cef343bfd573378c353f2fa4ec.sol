1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: contracts/MangachainToken.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         assert(c / a == b);
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // assert(b > 0); // Solidity automatically throws when dividing by 0
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111         return c;
112     }
113 
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         assert(b <= a);
116         return a - b;
117     }
118 
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         assert(c >= a);
122         return c;
123     }
124 }
125 
126 /**
127  * @title ERC223
128  * @dev ERC223 contract interface with ERC20 functions and events
129  *      Fully backward compatible with ERC20
130  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
131  */
132 contract ERC223 {
133     uint public totalSupply;
134 
135     // ERC223 and ERC20 functions and events
136     function balanceOf(address who) public view returns (uint);
137     function totalSupply() public view returns (uint256 _supply);
138     function transfer(address to, uint value) public returns (bool ok);
139     function transfer(address to, uint value, bytes data) public returns (bool ok);
140     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
141     event Transfer(address indexed from, address indexed to, uint value, bytes data);
142 
143     // ERC223 functions
144     function name() public view returns (string _name);
145     function symbol() public view returns (string _symbol);
146     function decimals() public view returns (uint8 _decimals);
147 
148     // ERC20 functions and events
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
150     function approve(address _spender, uint256 _value) public returns (bool success);
151     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
152     event Transfer(address indexed _from, address indexed _to, uint256 _value);
153     event Approval(address indexed _owner, address indexed _spender, uint _value);
154 }
155 
156 
157 /**
158  * @title ContractReceiver
159  * @dev Contract that is working with ERC223 tokens
160  */
161  contract ContractReceiver {
162 
163     struct TKN {
164         address sender;
165         uint value;
166         bytes data;
167         bytes4 sig;
168     }
169 
170     function tokenFallback(address _from, uint _value, bytes _data) public pure {
171         TKN memory tkn;
172         tkn.sender = _from;
173         tkn.value = _value;
174         tkn.data = _data;
175         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
176         tkn.sig = bytes4(u);
177 
178         /*
179          * tkn variable is analogue of msg variable of Ether transaction
180          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
181          * tkn.value the number of tokens that were sent   (analogue of msg.value)
182          * tkn.data is data of token transaction   (analogue of msg.data)
183          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
184          */
185     }
186 }
187 
188 
189 /**
190  * @title MangachainToken
191  * @dev MangachainToken is an ERC223 Token with ERC20 functions and events
192  *      Fully backward compatible with ERC20
193  */
194 contract MangachainToken is ERC223, Pausable {
195     using SafeMath for uint256;
196 
197     string public name = "Mangachain Token";
198     string public symbol = "MCT";
199     uint8 public decimals = 8;
200     uint256 public totalSupply = 5e10 * 1e8;
201     uint256 public distributeAmount = 0;
202     bool public mintingFinished = false;
203     address public depositAddress;
204 
205     mapping(address => uint256) public balanceOf;
206     mapping(address => mapping (address => uint256)) public allowance;
207     mapping (address => uint256) public unlockUnixTime;
208 
209     event LockedFunds(address indexed target, uint256 locked);
210     event Burn(address indexed from, uint256 amount);
211     event Mint(address indexed to, uint256 amount);
212     event MintFinished();
213 
214     /**
215      * @dev Constructor is called only once and can not be called again
216      */
217     function MangachainToken(address _team, address _development, address _marketing, address _release, address _deposit) public {
218       owner = _team;
219       depositAddress = _deposit;
220 
221       balanceOf[_team] = totalSupply.mul(15).div(100);
222       balanceOf[_development] = totalSupply.mul(15).div(100);
223       balanceOf[_marketing] = totalSupply.mul(30).div(100);
224       balanceOf[_release] = totalSupply.mul(40).div(100);
225     }
226 
227 
228     function name() public view returns (string _name) {
229         return name;
230     }
231 
232     function symbol() public view returns (string _symbol) {
233         return symbol;
234     }
235 
236     function decimals() public view returns (uint8 _decimals) {
237         return decimals;
238     }
239 
240     function totalSupply() public view returns (uint256 _totalSupply) {
241         return totalSupply;
242     }
243 
244     function balanceOf(address _owner) public view returns (uint256 balance) {
245         return balanceOf[_owner];
246     }
247 
248     /**
249      * @dev Prevent targets from sending or receiving tokens by setting Unix times
250      * @param targets Addresses to be locked funds
251      * @param unixTimes Unix times when locking up will be finished
252      */
253     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
254         require(targets.length > 0
255                 && targets.length == unixTimes.length);
256 
257         for(uint i = 0; i < targets.length; i++){
258             require(unlockUnixTime[targets[i]] < unixTimes[i]);
259             unlockUnixTime[targets[i]] = unixTimes[i];
260             LockedFunds(targets[i], unixTimes[i]);
261         }
262     }
263 
264 
265     /**
266      * @dev Function that is called when a user or another contract wants to transfer funds
267      */
268     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) whenNotPaused public returns (bool success) {
269         require(_value > 0
270                 && now > unlockUnixTime[msg.sender]
271                 && now > unlockUnixTime[_to]);
272 
273         if (isContract(_to)) {
274             require(balanceOf[msg.sender] >= _value);
275             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
276             balanceOf[_to] = balanceOf[_to].add(_value);
277             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
278             Transfer(msg.sender, _to, _value, _data);
279             Transfer(msg.sender, _to, _value);
280             return true;
281         } else {
282             return transferToAddress(_to, _value, _data);
283         }
284     }
285 
286     function transfer(address _to, uint _value, bytes _data) whenNotPaused public returns (bool success) {
287         require(_value > 0
288                 && now > unlockUnixTime[msg.sender]
289                 && now > unlockUnixTime[_to]);
290 
291         if (isContract(_to)) {
292             return transferToContract(_to, _value, _data);
293         } else {
294             return transferToAddress(_to, _value, _data);
295         }
296     }
297 
298     /**
299      * @dev Standard function transfer similar to ERC20 transfer with no _data
300      *      Added due to backwards compatibility reasons
301      */
302     function transfer(address _to, uint _value) whenNotPaused public returns (bool success) {
303         require(_value > 0
304                 && now > unlockUnixTime[msg.sender]
305                 && now > unlockUnixTime[_to]);
306 
307         bytes memory empty;
308         if (isContract(_to)) {
309             return transferToContract(_to, _value, empty);
310         } else {
311             return transferToAddress(_to, _value, empty);
312         }
313     }
314 
315     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
316     function isContract(address _addr) private view returns (bool is_contract) {
317         uint length;
318         assembly {
319             //retrieve the size of the code on target address, this needs assembly
320             length := extcodesize(_addr)
321         }
322         return (length > 0);
323     }
324 
325     // function that is called when transaction target is an address
326     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
327         require(balanceOf[msg.sender] >= _value);
328         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
329         balanceOf[_to] = balanceOf[_to].add(_value);
330         Transfer(msg.sender, _to, _value, _data);
331         Transfer(msg.sender, _to, _value);
332         return true;
333     }
334 
335     // function that is called when transaction target is a contract
336     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
337         require(balanceOf[msg.sender] >= _value);
338         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
339         balanceOf[_to] = balanceOf[_to].add(_value);
340         ContractReceiver receiver = ContractReceiver(_to);
341         receiver.tokenFallback(msg.sender, _value, _data);
342         Transfer(msg.sender, _to, _value, _data);
343         Transfer(msg.sender, _to, _value);
344         return true;
345     }
346 
347 
348 
349     /**
350      * @dev Transfer tokens from one address to another
351      *      Added due to backwards compatibility with ERC20
352      * @param _from address The address which you want to send tokens from
353      * @param _to address The address which you want to transfer to
354      * @param _value uint256 the amount of tokens to be transferred
355      */
356     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
357         require(_to != address(0)
358                 && _value > 0
359                 && balanceOf[_from] >= _value
360                 && allowance[_from][msg.sender] >= _value
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
377     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {
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
393     function distributeTokens(address[] addresses, uint[] amounts) whenNotPaused public returns (bool) {
394         require(addresses.length > 0
395                 && addresses.length == amounts.length
396                 && now > unlockUnixTime[msg.sender]);
397 
398         uint256 totalAmount = 0;
399 
400         for(uint i = 0; i < addresses.length; i++){
401             require(amounts[i] > 0
402                     && addresses[i] != 0x0
403                     && now > unlockUnixTime[addresses[i]]);
404 
405             amounts[i] = amounts[i].mul(1e8);
406             totalAmount = totalAmount.add(amounts[i]);
407         }
408         require(balanceOf[msg.sender] >= totalAmount);
409 
410         for (i = 0; i < addresses.length; i++) {
411             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amounts[i]);
412             Transfer(msg.sender, addresses[i], amounts[i]);
413         }
414         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
415         return true;
416     }
417 
418     /**
419     * @dev To collect tokens from target addresses. This function is used when we collect tokens which transfer to our service.
420     * @param _targets collect target addresses
421     */
422     function collectTokens(address[] _targets) onlyOwner whenNotPaused public returns (bool) {
423       require(_targets.length > 0);
424 
425       uint256 totalAmount = 0;
426 
427       for (uint i = 0; i < _targets.length; i++) {
428         require(_targets[i] != 0x0 && now > unlockUnixTime[_targets[i]]);
429 
430         totalAmount = totalAmount.add(balanceOf[_targets[i]]);
431         Transfer(_targets[i], depositAddress, balanceOf[_targets[i]]);
432         balanceOf[_targets[i]] = 0;
433       }
434 
435       balanceOf[depositAddress] = balanceOf[depositAddress].add(totalAmount);
436       return true;
437     }
438 
439     function setDepositAddress(address _addr) onlyOwner whenNotPaused public {
440       require(_addr != 0x0 && now > unlockUnixTime[_addr]);
441       depositAddress = _addr;
442     }
443 
444     /**
445      * @dev Burns a specific amount of tokens.
446      * @param _from The address that will burn the tokens.
447      * @param _unitAmount The amount of token to be burned.
448      */
449     function burn(address _from, uint256 _unitAmount) onlyOwner public {
450         require(_unitAmount > 0
451                 && balanceOf[_from] >= _unitAmount);
452 
453         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
454         totalSupply = totalSupply.sub(_unitAmount);
455         Burn(_from, _unitAmount);
456     }
457 
458 
459     modifier canMint() {
460         require(!mintingFinished);
461         _;
462     }
463 
464     /**
465      * @dev Function to mint tokens
466      * @param _to The address that will receive the minted tokens.
467      * @param _unitAmount The amount of tokens to mint.
468      */
469     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
470         require(_unitAmount > 0);
471 
472         totalSupply = totalSupply.add(_unitAmount);
473         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
474         Mint(_to, _unitAmount);
475         Transfer(address(0), _to, _unitAmount);
476         return true;
477     }
478 
479     /**
480      * @dev Function to stop minting new tokens.
481      */
482     function finishMinting() onlyOwner canMint public returns (bool) {
483         mintingFinished = true;
484         MintFinished();
485         return true;
486     }
487 
488     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
489         distributeAmount = _unitAmount;
490     }
491 
492     /**
493      * @dev Function to distribute tokens to the msg.sender automatically
494      *      If distributeAmount is 0, this function doesn't work
495      */
496     function autoDistribute() payable public {
497         require(distributeAmount > 0
498                 && balanceOf[depositAddress] >= distributeAmount
499                 && now > unlockUnixTime[msg.sender]);
500         if(msg.value > 0) depositAddress.transfer(msg.value);
501 
502         balanceOf[depositAddress] = balanceOf[depositAddress].sub(distributeAmount);
503         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
504         Transfer(depositAddress, msg.sender, distributeAmount);
505     }
506 
507     /**
508      * @dev fallback function
509      */
510     function() payable public {
511         autoDistribute();
512      }
513 }