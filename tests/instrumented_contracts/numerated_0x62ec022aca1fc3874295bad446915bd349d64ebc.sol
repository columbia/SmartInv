1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
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
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization
38  *      control functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the
47      *      sender account.
48      */
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) onlyOwner public {
66         require(newOwner != address(0));
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 }
71 
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
103 
104 /**
105  * @title ContractReceiver
106  * @dev Contract that is working with ERC223 tokens
107  */
108  contract ContractReceiver {
109 
110     struct TKN {
111         address sender;
112         uint value;
113         bytes data;
114         bytes4 sig;
115     }
116 
117     function tokenFallback(address _from, uint _value, bytes _data) public pure {
118         TKN memory tkn;
119         tkn.sender = _from;
120         tkn.value = _value;
121         tkn.data = _data;
122         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
123         tkn.sig = bytes4(u);
124 
125         /**
126          * tkn variable is analogue of msg variable of Ether transaction
127          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
128          * tkn.value the number of tokens that were sent (analogue of msg.value)
129          * tkn.data is data of token transaction (analogue of msg.data)
130          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
131          */
132     }
133 }
134 
135 
136 /**
137  * @title NEKOCOIN
138  * @author NEKOCOIN
139  * @dev NEKOCOIN is an ERC223 Token with ERC20 functions and events
140  *      Fully backward compatible with ERC20
141  */
142 contract NEKOCOIN is ERC223, Ownable {
143     using SafeMath for uint256;
144 
145     string public name = "NEKOCOIN";
146     string public symbol = "NEKO";
147     uint8 public decimals = 8;
148     uint256 public totalSupply = 3e10 * 1e8;
149     uint256 public distributeAmount = 0;
150     bool public mintingFinished = false;
151 
152     mapping(address => uint256) public balanceOf;
153     mapping(address => mapping (address => uint256)) public allowance;
154     mapping (address => bool) public frozenAccount;
155     mapping (address => uint256) public unlockUnixTime;
156     
157     event FrozenFunds(address indexed target, bool frozen);
158     event LockedFunds(address indexed target, uint256 locked);
159     event Burn(address indexed from, uint256 amount);
160     event Mint(address indexed to, uint256 amount);
161     event MintFinished();
162 
163     /** 
164      * @dev Constructor is called only once and can not be called again
165      */
166     function NEKOCOIN() public {
167         balanceOf[msg.sender] = totalSupply;
168     }
169 
170     function name() public view returns (string _name) {
171         return name;
172     }
173 
174     function symbol() public view returns (string _symbol) {
175         return symbol;
176     }
177 
178     function decimals() public view returns (uint8 _decimals) {
179         return decimals;
180     }
181 
182     function totalSupply() public view returns (uint256 _totalSupply) {
183         return totalSupply;
184     }
185 
186     function balanceOf(address _owner) public view returns (uint256 balance) {
187         return balanceOf[_owner];
188     }
189 
190     /**
191      * @dev Prevent targets from sending or receiving tokens
192      * @param targets Addresses to be frozen
193      * @param isFrozen either to freeze it or not
194      */
195     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
196         require(targets.length > 0);
197 
198         for (uint j = 0; j < targets.length; j++) {
199             require(targets[j] != 0x0);
200             frozenAccount[targets[j]] = isFrozen;
201             FrozenFunds(targets[j], isFrozen);
202         }
203     }
204 
205     /**
206      * @dev Prevent targets from sending or receiving tokens by setting Unix times
207      * @param targets Addresses to be locked funds
208      * @param unixTimes Unix times when locking up will be finished
209      */
210     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
211         require(targets.length > 0
212                 && targets.length == unixTimes.length);
213 
214         for(uint j = 0; j < targets.length; j++){
215             require(unlockUnixTime[targets[j]] < unixTimes[j]);
216             unlockUnixTime[targets[j]] = unixTimes[j];
217             LockedFunds(targets[j], unixTimes[j]);
218         }
219     }
220 
221     /**
222      * @dev Function that is called when a user or another contract wants to transfer funds
223      */
224     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
225         require(_value > 0
226                 && frozenAccount[msg.sender] == false
227                 && frozenAccount[_to] == false
228                 && now > unlockUnixTime[msg.sender]
229                 && now > unlockUnixTime[_to]);
230 
231         if (isContract(_to)) {
232             require(balanceOf[msg.sender] >= _value);
233             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
234             balanceOf[_to] = balanceOf[_to].add(_value);
235             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
236             Transfer(msg.sender, _to, _value, _data);
237             Transfer(msg.sender, _to, _value);
238             return true;
239         } else {
240             return transferToAddress(_to, _value, _data);
241         }
242     }
243 
244     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
245         require(_value > 0
246                 && frozenAccount[msg.sender] == false
247                 && frozenAccount[_to] == false
248                 && now > unlockUnixTime[msg.sender]
249                 && now > unlockUnixTime[_to]);
250 
251         if (isContract(_to)) {
252             return transferToContract(_to, _value, _data);
253         } else {
254             return transferToAddress(_to, _value, _data);
255         }
256     }
257 
258     /**
259      * @dev Standard function transfer similar to ERC20 transfer with no _data
260      *      Added due to backwards compatibility reasons
261      */
262     function transfer(address _to, uint _value) public returns (bool success) {
263         require(_value > 0
264                 && frozenAccount[msg.sender] == false
265                 && frozenAccount[_to] == false
266                 && now > unlockUnixTime[msg.sender]
267                 && now > unlockUnixTime[_to]);
268 
269         bytes memory empty;
270         if (isContract(_to)) {
271             return transferToContract(_to, _value, empty);
272         } else {
273             return transferToAddress(_to, _value, empty);
274         }
275     }
276 
277     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
278     function isContract(address _addr) private view returns (bool is_contract) {
279         uint length;
280         assembly {
281             //retrieve the size of the code on target address, this needs assembly
282             length := extcodesize(_addr)
283         }
284         return (length > 0);
285     }
286 
287     // function that is called when transaction target is an address
288     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
289         require(balanceOf[msg.sender] >= _value);
290         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
291         balanceOf[_to] = balanceOf[_to].add(_value);
292         Transfer(msg.sender, _to, _value, _data);
293         Transfer(msg.sender, _to, _value);
294         return true;
295     }
296 
297     // function that is called when transaction target is a contract
298     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
299         require(balanceOf[msg.sender] >= _value);
300         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
301         balanceOf[_to] = balanceOf[_to].add(_value);
302         ContractReceiver receiver = ContractReceiver(_to);
303         receiver.tokenFallback(msg.sender, _value, _data);
304         Transfer(msg.sender, _to, _value, _data);
305         Transfer(msg.sender, _to, _value);
306         return true;
307     }
308 
309     /**
310      * @dev Transfer tokens from one address to another
311      *      Added due to backwards compatibility with ERC20
312      * @param _from address The address which you want to send tokens from
313      * @param _to address The address which you want to transfer to
314      * @param _value uint256 the amount of tokens to be transferred
315      */
316     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
317         require(_to != address(0)
318                 && _value > 0
319                 && balanceOf[_from] >= _value
320                 && allowance[_from][msg.sender] >= _value
321                 && frozenAccount[_from] == false
322                 && frozenAccount[_to] == false
323                 && now > unlockUnixTime[_from]
324                 && now > unlockUnixTime[_to]);
325 
326         balanceOf[_from] = balanceOf[_from].sub(_value);
327         balanceOf[_to] = balanceOf[_to].add(_value);
328         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
329         Transfer(_from, _to, _value);
330         return true;
331     }
332 
333     /**
334      * @dev Allows _spender to spend no more than _value tokens in your behalf
335      *      Added due to backwards compatibility with ERC20
336      * @param _spender The address authorized to spend
337      * @param _value the max amount they can spend
338      */
339     function approve(address _spender, uint256 _value) public returns (bool success) {
340         allowance[msg.sender][_spender] = _value;
341         Approval(msg.sender, _spender, _value);
342         return true;
343     }
344 
345     /**
346      * @dev Function to check the amount of tokens that an owner allowed to a spender
347      *      Added due to backwards compatibility with ERC20
348      * @param _owner address The address which owns the funds
349      * @param _spender address The address which will spend the funds
350      */
351     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
352         return allowance[_owner][_spender];
353     }
354 
355     /**
356      * @dev Burns a specific amount of tokens.
357      * @param _from The address that will burn the tokens.
358      * @param _unitAmount The amount of token to be burned.
359      */
360     function burn(address _from, uint256 _unitAmount) onlyOwner public {
361         require(_unitAmount > 0
362                 && balanceOf[_from] >= _unitAmount);
363 
364         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
365         totalSupply = totalSupply.sub(_unitAmount);
366         Burn(_from, _unitAmount);
367     }
368 
369     modifier canMint() {
370         require(!mintingFinished);
371         _;
372     }
373 
374     /**
375      * @dev Function to mint tokens
376      * @param _to The address that will receive the minted tokens.
377      * @param _unitAmount The amount of tokens to mint.
378      */
379     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
380         require(_unitAmount > 0);
381         
382         totalSupply = totalSupply.add(_unitAmount);
383         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
384         Mint(_to, _unitAmount);
385         Transfer(address(0), _to, _unitAmount);
386         return true;
387     }
388 
389     /**
390      * @dev Function to stop minting new tokens.
391      */
392     function finishMinting() onlyOwner canMint public returns (bool) {
393         mintingFinished = true;
394         MintFinished();
395         return true;
396     }
397 
398     /**
399      * @dev Function to distribute tokens to the list of addresses by the provided amount
400      */
401     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
402         require(amount > 0 
403                 && addresses.length > 0
404                 && frozenAccount[msg.sender] == false
405                 && now > unlockUnixTime[msg.sender]);
406 
407         amount = amount.mul(1e8);
408         uint256 totalAmount = amount.mul(addresses.length);
409         require(balanceOf[msg.sender] >= totalAmount);
410         
411         for (uint j = 0; j < addresses.length; j++) {
412             require(addresses[j] != 0x0
413                     && frozenAccount[addresses[j]] == false
414                     && now > unlockUnixTime[addresses[j]]);
415 
416             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
417             Transfer(msg.sender, addresses[j], amount);
418         }
419         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
420         return true;
421     }
422 
423     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
424         require(addresses.length > 0
425                 && addresses.length == amounts.length
426                 && frozenAccount[msg.sender] == false
427                 && now > unlockUnixTime[msg.sender]);
428                 
429         uint256 totalAmount = 0;
430         
431         for(uint j = 0; j < addresses.length; j++){
432             require(amounts[j] > 0
433                     && addresses[j] != 0x0
434                     && frozenAccount[addresses[j]] == false
435                     && now > unlockUnixTime[addresses[j]]);
436                     
437             amounts[j] = amounts[j].mul(1e8);
438             totalAmount = totalAmount.add(amounts[j]);
439         }
440         require(balanceOf[msg.sender] >= totalAmount);
441         
442         for (j = 0; j < addresses.length; j++) {
443             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
444             Transfer(msg.sender, addresses[j], amounts[j]);
445         }
446         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
447         return true;
448     }
449 
450     /**
451      * @dev Function to collect tokens from the list of addresses
452      */
453     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
454         require(addresses.length > 0
455                 && addresses.length == amounts.length);
456 
457         uint256 totalAmount = 0;
458         
459         for (uint j = 0; j < addresses.length; j++) {
460             require(amounts[j] > 0
461                     && addresses[j] != 0x0
462                     && frozenAccount[addresses[j]] == false
463                     && now > unlockUnixTime[addresses[j]]);
464                     
465             amounts[j] = amounts[j].mul(1e8);
466             require(balanceOf[addresses[j]] >= amounts[j]);
467             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
468             totalAmount = totalAmount.add(amounts[j]);
469             Transfer(addresses[j], msg.sender, amounts[j]);
470         }
471         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
472         return true;
473     }
474 
475     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
476         distributeAmount = _unitAmount;
477     }
478     
479     /**
480      * @dev Function to distribute tokens to the msg.sender automatically
481      *      If distributeAmount is 0, this function doesn't work
482      */
483     function autoDistribute() payable public {
484         require(distributeAmount > 0
485                 && balanceOf[owner] >= distributeAmount
486                 && frozenAccount[msg.sender] == false
487                 && now > unlockUnixTime[msg.sender]);
488         if(msg.value > 0) owner.transfer(msg.value);
489         
490         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
491         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
492         Transfer(owner, msg.sender, distributeAmount);
493     }
494 
495     /**
496      * @dev fallback function
497      */
498     function() payable public {
499         autoDistribute();
500     }
501 }