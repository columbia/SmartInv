1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization
39  *      control functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the
48      *      sender account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner public {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 }
72 
73 /**
74  * @title ERC223
75  * @dev ERC223 contract interface with ERC20 functions and events
76  *      Fully backward compatible with ERC20
77  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
78  */
79 contract ERC223 {
80     uint public totalSupply;
81 
82     // ERC223 and ERC20 functions and events
83     function balanceOf(address who) public view returns (uint);
84     function totalSupply() public view returns (uint256 _supply);
85     function transfer(address to, uint value) public returns (bool ok);
86     function transfer(address to, uint value, bytes data) public returns (bool ok);
87     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
88     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
89 
90     // ERC223 functions
91     function name() public view returns (string _name);
92     function symbol() public view returns (string _symbol);
93     function decimals() public view returns (uint8 _decimals);
94 
95     // ERC20 functions and events
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
97     function approve(address _spender, uint256 _value) public returns (bool success);
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint _value);
101 }
102 
103 /**
104  * @title ContractReceiver
105  * @dev Contract that is working with ERC223 tokens
106  */
107  contract ContractReceiver {
108 
109     struct TKN {
110         address sender;
111         uint value;
112         bytes data;
113         bytes4 sig;
114     }
115 
116     function tokenFallback(address _from, uint _value, bytes _data) public pure {
117         TKN memory tkn;
118         tkn.sender = _from;
119         tkn.value = _value;
120         tkn.data = _data;
121         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
122         tkn.sig = bytes4(u);
123 
124         /*
125          * tkn variable is analogue of msg variable of Ether transaction
126          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
127          * tkn.value the number of tokens that were sent (analogue of msg.value)
128          * tkn.data is data of token transaction (analogue of msg.data)
129          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
130          */
131     }
132 }
133 
134 /**
135  * @title Arascacoin
136  * @author Arascacoin project
137  * @dev Arascacoin is an ERC223 Token with ERC20 functions and events
138  *      Fully backward compatible with ERC20
139  */
140 contract Arascacoin is ERC223, Ownable {
141     using SafeMath for uint256;
142 
143     string public name = "Arascacoin";
144     string public symbol = "ASC";
145     uint8 public decimals = 8;
146     uint256 public totalSupply = 10512e4 * 1e8;
147     uint256 public distributeAmount = 0;
148     bool public mintingFinished = false;
149 
150     mapping(address => uint256) public balanceOf;
151     mapping(address => mapping (address => uint256)) public allowance;
152     mapping (address => bool) public frozenAccount;
153     mapping (address => uint256) public unlockUnixTime;
154     
155     event FrozenFunds(address indexed target, bool frozen);
156     event LockedFunds(address indexed target, uint256 locked);
157     event Burn(address indexed from, uint256 amount);
158     event Mint(address indexed to, uint256 amount);
159     event MintFinished();
160 
161     /** 
162      * @dev Constructor is called only once and can not be called again
163      */
164     function Arascacoin() public {
165         balanceOf[owner] = totalSupply;
166     }
167 
168     function name() public view returns (string _name) {
169         return name;
170     }
171 
172     function symbol() public view returns (string _symbol) {
173         return symbol;
174     }
175 
176     function decimals() public view returns (uint8 _decimals) {
177         return decimals;
178     }
179 
180     function totalSupply() public view returns (uint256 _totalSupply) {
181         return totalSupply;
182     }
183 
184     function balanceOf(address _owner) public view returns (uint256 balance) {
185         return balanceOf[_owner];
186     }
187 
188     /**
189      * @dev Prevent targets from sending or receiving tokens
190      * @param targets Addresses to be frozen
191      * @param isFrozen either to freeze it or not
192      */
193     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
194         require(targets.length > 0);
195 
196         for (uint j = 0; j < targets.length; j++) {
197             require(targets[j] != 0x0);
198             frozenAccount[targets[j]] = isFrozen;
199             FrozenFunds(targets[j], isFrozen);
200         }
201     }
202 
203     /**
204      * @dev Prevent targets from sending or receiving tokens by setting Unix times
205      * @param targets Addresses to be locked funds
206      * @param unixTimes Unix times when locking up will be finished
207      */
208     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
209         require(targets.length > 0
210                 && targets.length == unixTimes.length);
211 
212         for(uint j = 0; j < targets.length; j++){
213             require(unlockUnixTime[targets[j]] < unixTimes[j]);
214             unlockUnixTime[targets[j]] = unixTimes[j];
215             LockedFunds(targets[j], unixTimes[j]);
216         }
217     }
218 
219     /**
220      * @dev Function that is called when a user or another contract wants to transfer funds
221      */
222     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
223         require(_value > 0
224                 && frozenAccount[msg.sender] == false
225                 && frozenAccount[_to] == false
226                 && now > unlockUnixTime[msg.sender]
227                 && now > unlockUnixTime[_to]);
228 
229         if (isContract(_to)) {
230             require(balanceOf[msg.sender] >= _value);
231             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
232             balanceOf[_to] = balanceOf[_to].add(_value);
233             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
234             Transfer(msg.sender, _to, _value, _data);
235             Transfer(msg.sender, _to, _value);
236             return true;
237         } else {
238             return transferToAddress(_to, _value, _data);
239         }
240     }
241 
242     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
243         require(_value > 0
244                 && frozenAccount[msg.sender] == false
245                 && frozenAccount[_to] == false
246                 && now > unlockUnixTime[msg.sender]
247                 && now > unlockUnixTime[_to]);
248 
249         if (isContract(_to)) {
250             return transferToContract(_to, _value, _data);
251         } else {
252             return transferToAddress(_to, _value, _data);
253         }
254     }
255 
256     /**
257      * @dev Standard function transfer similar to ERC20 transfer with no _data
258      *      Added due to backwards compatibility reasons
259      */
260     function transfer(address _to, uint _value) public returns (bool success) {
261         require(_value > 0
262                 && frozenAccount[msg.sender] == false
263                 && frozenAccount[_to] == false
264                 && now > unlockUnixTime[msg.sender]
265                 && now > unlockUnixTime[_to]);
266 
267         bytes memory empty;
268         if (isContract(_to)) {
269             return transferToContract(_to, _value, empty);
270         } else {
271             return transferToAddress(_to, _value, empty);
272         }
273     }
274 
275     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
276     function isContract(address _addr) private view returns (bool is_contract) {
277         uint length;
278         assembly {
279             //retrieve the size of the code on target address, this needs assembly
280             length := extcodesize(_addr)
281         }
282         return (length > 0);
283     }
284 
285     // function that is called when transaction target is an address
286     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
287         require(balanceOf[msg.sender] >= _value);
288         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
289         balanceOf[_to] = balanceOf[_to].add(_value);
290         Transfer(msg.sender, _to, _value, _data);
291         Transfer(msg.sender, _to, _value);
292         return true;
293     }
294 
295     // function that is called when transaction target is a contract
296     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
297         require(balanceOf[msg.sender] >= _value);
298         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
299         balanceOf[_to] = balanceOf[_to].add(_value);
300         ContractReceiver receiver = ContractReceiver(_to);
301         receiver.tokenFallback(msg.sender, _value, _data);
302         Transfer(msg.sender, _to, _value, _data);
303         Transfer(msg.sender, _to, _value);
304         return true;
305     }
306 
307     /**
308      * @dev Transfer tokens from one address to another
309      *      Added due to backwards compatibility with ERC20
310      * @param _from address The address which you want to send tokens from
311      * @param _to address The address which you want to transfer to
312      * @param _value uint256 the amount of tokens to be transferred
313      */
314     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
315         require(_to != address(0)
316                 && _value > 0
317                 && balanceOf[_from] >= _value
318                 && allowance[_from][msg.sender] >= _value
319                 && frozenAccount[_from] == false
320                 && frozenAccount[_to] == false
321                 && now > unlockUnixTime[_from]
322                 && now > unlockUnixTime[_to]);
323 
324         balanceOf[_from] = balanceOf[_from].sub(_value);
325         balanceOf[_to] = balanceOf[_to].add(_value);
326         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
327         Transfer(_from, _to, _value);
328         return true;
329     }
330 
331     /**
332      * @dev Allows _spender to spend no more than _value tokens in your behalf
333      *      Added due to backwards compatibility with ERC20
334      * @param _spender The address authorized to spend
335      * @param _value the max amount they can spend
336      */
337     function approve(address _spender, uint256 _value) public returns (bool success) {
338         allowance[msg.sender][_spender] = _value;
339         Approval(msg.sender, _spender, _value);
340         return true;
341     }
342 
343     /**
344      * @dev Function to check the amount of tokens that an owner allowed to a spender
345      *      Added due to backwards compatibility with ERC20
346      * @param _owner address The address which owns the funds
347      * @param _spender address The address which will spend the funds
348      */
349     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
350         return allowance[_owner][_spender];
351     }
352 
353     /**
354      * @dev Burns a specific amount of tokens.
355      * @param _from The address that will burn the tokens.
356      * @param _unitAmount The amount of token to be burned.
357      */
358     function burn(address _from, uint256 _unitAmount) onlyOwner public {
359         require(_unitAmount > 0
360                 && balanceOf[_from] >= _unitAmount);
361 
362         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
363         totalSupply = totalSupply.sub(_unitAmount);
364         Burn(_from, _unitAmount);
365     }
366 
367     modifier canMint() {
368         require(!mintingFinished);
369         _;
370     }
371 
372     /**
373      * @dev Function to mint tokens
374      * @param _to The address that will receive the minted tokens.
375      * @param _unitAmount The amount of tokens to mint.
376      */
377     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
378         require(_unitAmount > 0);
379         
380         totalSupply = totalSupply.add(_unitAmount);
381         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
382         Mint(_to, _unitAmount);
383         Transfer(address(0), _to, _unitAmount);
384         return true;
385     }
386 
387     /**
388      * @dev Function to stop minting new tokens.
389      */
390     function finishMinting() onlyOwner canMint public returns (bool) {
391         mintingFinished = true;
392         MintFinished();
393         return true;
394     }
395 
396     /**
397      * @dev Function to distribute tokens to the list of addresses by the provided amount
398      */
399     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
400         require(amount > 0 
401                 && addresses.length > 0
402                 && frozenAccount[msg.sender] == false
403                 && now > unlockUnixTime[msg.sender]);
404 
405         amount = amount.mul(1e8);
406         uint256 totalAmount = amount.mul(addresses.length);
407         require(balanceOf[msg.sender] >= totalAmount);
408         
409         for (uint j = 0; j < addresses.length; j++) {
410             require(addresses[j] != 0x0
411                     && frozenAccount[addresses[j]] == false
412                     && now > unlockUnixTime[addresses[j]]);
413 
414             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
415             Transfer(msg.sender, addresses[j], amount);
416         }
417         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
418         return true;
419     }
420 
421     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
422         require(addresses.length > 0
423                 && addresses.length == amounts.length
424                 && frozenAccount[msg.sender] == false
425                 && now > unlockUnixTime[msg.sender]);
426                 
427         uint256 totalAmount = 0;
428         
429         for(uint j = 0; j < addresses.length; j++){
430             require(amounts[j] > 0
431                     && addresses[j] != 0x0
432                     && frozenAccount[addresses[j]] == false
433                     && now > unlockUnixTime[addresses[j]]);
434                     
435             amounts[j] = amounts[j].mul(1e8);
436             totalAmount = totalAmount.add(amounts[j]);
437         }
438         require(balanceOf[msg.sender] >= totalAmount);
439         
440         for (j = 0; j < addresses.length; j++) {
441             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
442             Transfer(msg.sender, addresses[j], amounts[j]);
443         }
444         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
445         return true;
446     }
447 
448     /**
449      * @dev Function to collect tokens from the list of addresses
450      */
451     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
452         require(addresses.length > 0
453                 && addresses.length == amounts.length);
454 
455         uint256 totalAmount = 0;
456         
457         for (uint j = 0; j < addresses.length; j++) {
458             require(amounts[j] > 0
459                     && addresses[j] != 0x0
460                     && frozenAccount[addresses[j]] == false
461                     && now > unlockUnixTime[addresses[j]]);
462                     
463             amounts[j] = amounts[j].mul(1e8);
464             require(balanceOf[addresses[j]] >= amounts[j]);
465             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
466             totalAmount = totalAmount.add(amounts[j]);
467             Transfer(addresses[j], msg.sender, amounts[j]);
468         }
469         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
470         return true;
471     }
472 
473     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
474         distributeAmount = _unitAmount;
475     }
476     
477     /**
478      * @dev Function to distribute tokens to the msg.sender automatically
479      *      If distributeAmount is 0, this function doesn't work
480      */
481     function autoDistribute() payable public {
482         require(distributeAmount > 0
483                 && balanceOf[owner] >= distributeAmount
484                 && frozenAccount[msg.sender] == false
485                 && now > unlockUnixTime[msg.sender]);
486         if(msg.value > 0) owner.transfer(msg.value);
487         
488         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
489         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
490         Transfer(owner, msg.sender, distributeAmount);
491     }
492 
493     /**
494      * @dev fallback function
495      */
496     function() payable public {
497         autoDistribute();
498     }
499 }