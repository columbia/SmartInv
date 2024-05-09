1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC223
6  * @dev New Interface for ERC223
7  */
8 contract ERC223 {
9 
10     // functions
11     function balanceOf(address _owner) external view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
15     function approve(address _spender, uint256 _value) external returns (bool success);
16     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
17 
18 
19 
20     // Getters
21     function name() external constant returns  (string _name);
22     function symbol() external constant returns  (string _symbol);
23     function decimals() external constant returns (uint8 _decimals);
24     function totalSupply() external constant returns (uint256 _totalSupply);
25 
26 
27     // Events
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
30     event Approval(address indexed _owner, address indexed _spender, uint _value);
31     event Burn(address indexed burner, uint256 value);
32     event FrozenAccount(address indexed targets);
33     event UnfrozenAccount(address indexed target);
34     event LockedAccount(address indexed target, uint256 locked);
35     event UnlockedAccount(address indexed target);
36 }
37 
38 
39 /**
40  * @notice The contract will throw tokens if it does not inherit this
41  * @title ERC223ReceivingContract
42  * @dev Contract for ERC223 token fallback
43  */
44 contract ERC223ReceivingContract {
45 
46     TKN internal fallback;
47 
48     struct TKN {
49         address sender;
50         uint value;
51         bytes data;
52         bytes4 sig;
53     }
54 
55     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
56         TKN memory tkn;
57         tkn.sender = _from;
58         tkn.value = _value;
59         tkn.data = _data;
60         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
61         tkn.sig = bytes4(u);
62 
63         /*
64          * tkn variable is analogue of msg variable of Ether transaction
65          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
66          * tkn.value the number of tokens that were sent   (analogue of msg.value)
67          * tkn.data is data of token transaction   (analogue of msg.data)
68          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
69          */
70 
71 
72     }
73 }
74 
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         assert(c / a == b);
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // assert(b > 0); // Solidity automatically throws when dividing by 0
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         assert(c >= a);
105         return c;
106     }
107 }
108 
109 
110 /**
111  * @title Ownable
112  * @dev The Ownable contract has an owner address, and provides basic authorization control
113  * functions, this simplifies the implementation of "user permissions".
114  */
115 contract Ownable {
116     address public owner;
117 
118 
119     event OwnershipRenounced(address indexed previousOwner);
120     event OwnershipTransferred(
121       address indexed previousOwner,
122       address indexed newOwner
123     );
124 
125 
126     /**
127      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128      * account.
129      */
130     constructor() public {
131         owner = msg.sender;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(msg.sender == owner);
139         _;
140     }
141 
142     /**
143      * @dev Allows the current owner to relinquish control of the contract.
144      * @notice Renouncing to ownership will leave the contract without an owner.
145      * It will not be possible to call the functions with the `onlyOwner`
146      * modifier anymore.
147      */
148     function renounceOwnership() public onlyOwner {
149         emit OwnershipRenounced(owner);
150         owner = address(0);
151     }
152 
153     /**
154      * @dev Allows the current owner to transfer control of the contract to a newOwner.
155      * @param _newOwner The address to transfer ownership to.
156      */
157     function transferOwnership(address _newOwner) public onlyOwner {
158         _transferOwnership(_newOwner);
159     }
160 
161     /**
162      * @dev Transfers control of the contract to a newOwner.
163      * @param _newOwner The address to transfer ownership to.
164      */
165     function _transferOwnership(address _newOwner) internal {
166         require(_newOwner != address(0));
167         emit OwnershipTransferred(owner, _newOwner);
168         owner = _newOwner;
169     }
170 }
171 
172 
173 
174 /**
175  * @title C3Wallet
176  * @dev C3Wallet is a ERC223 Token with ERC20 functions and events
177  *      Fully backward compatible with ERC20
178  */
179 contract C3Wallet is ERC223, Ownable {
180     using SafeMath for uint;
181 
182 
183     string public name = "C3Wallet";
184     string public symbol = "C3W";
185     uint8 public decimals = 8;
186     uint256 public totalSupply = 5e10 * 1e8;
187     
188     mapping (address => bool) public frozenAccount;
189     mapping (address => uint256) public unlockUnixTime;
190 
191 
192     constructor() public {
193         balances[msg.sender] = totalSupply;
194     }
195 
196 
197     mapping (address => uint256) public balances;
198 
199     mapping(address => mapping (address => uint256)) public allowance;
200 
201 
202     /**
203      * @dev Getters
204      */
205     // Function to access name of token .
206     function name() external constant returns (string _name) {
207         return name;
208     }
209     // Function to access symbol of token .
210     function symbol() external constant returns (string _symbol) {
211         return symbol;
212     }
213     // Function to access decimals of token .
214     function decimals() external constant returns (uint8 _decimals) {
215         return decimals;
216     }
217     // Function to access total supply of tokens .
218     function totalSupply() external constant returns (uint256 _totalSupply) {
219         return totalSupply;
220     }
221 
222 
223     /**
224      * @dev Get balance of a token owner
225      * @param _owner The address which one owns tokens
226      */
227     function balanceOf(address _owner) external view returns (uint256 balance) {
228         return balances[_owner];
229     }
230 
231 
232     /**
233      * @notice This function is modified for erc223 standard
234      * @dev ERC20 transfer function added for backward compatibility.
235      * @param _to Address of token receiver
236      * @param _value Number of tokens to send
237      */
238     function transfer(address _to, uint _value) public returns (bool success) {
239         require(_value > 0
240                 && frozenAccount[msg.sender] == false
241                 && frozenAccount[_to] == false
242                 && now > unlockUnixTime[msg.sender]
243                 && now > unlockUnixTime[_to]
244                 && _to != address(this));
245         bytes memory empty = hex"00000000";
246         if (isContract(_to)) {
247             return transferToContract(_to, _value, empty);
248         } else {
249             return transferToAddress(_to, _value, empty);
250         }
251     }
252 
253 
254     /**
255      * @dev ERC223 transfer function
256      * @param _to Address of token receiver
257      * @param _value Number of tokens to send
258      * @param _data data equivalent to tx.data from ethereum transaction
259      */
260     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
261         require(_value > 0
262                 && frozenAccount[msg.sender] == false
263                 && frozenAccount[_to] == false
264                 && now > unlockUnixTime[msg.sender]
265                 && now > unlockUnixTime[_to]
266                 && _to != address(this));
267         if (isContract(_to)) {
268             return transferToContract(_to, _value, _data);
269         } else {
270             return transferToAddress(_to, _value, _data);
271         }
272     }
273 
274 
275     function isContract(address _addr) private view returns (bool is_contract) {
276         uint length;
277         assembly {
278             //retrieve the size of the code on target address, this needs assembly
279             length := extcodesize(_addr)
280         }
281         return (length > 0);
282     }
283     
284     /**
285      * @dev Prevent targets from sending or receiving tokens
286      * @param _targets Addresses to be frozen
287      */
288     function freezeAccounts(address[] _targets) onlyOwner public {
289         require(_targets.length > 0);
290 
291         for (uint j = 0; j < _targets.length; j++) {
292             require(_targets[j] != 0x0 && _targets[j] != Ownable.owner);
293             frozenAccount[_targets[j]] = true;
294             emit FrozenAccount(_targets[j]);
295         }
296     }
297     
298     /**
299      * @dev Enable frozen targets to send or receive tokens
300      * @param _targets Addresses to be unfrozen
301      */
302     function unfreezeAccounts(address[] _targets) onlyOwner public {
303         require(_targets.length > 0);
304 
305         for (uint j = 0; j < _targets.length; j++) {
306             require(_targets[j] != 0x0 && _targets[j] != Ownable.owner);
307             frozenAccount[_targets[j]] = false;
308             emit UnfrozenAccount(_targets[j]);
309         }
310     }
311     
312     
313 
314     /**
315      * @dev Prevent targets from sending or receiving tokens by setting Unix times.
316      * @param _targets Addresses to be locked funds
317      * @param _unixTimes Unix times when locking up will be finished
318      */
319     function lockAccounts(address[] _targets, uint[] _unixTimes) onlyOwner public {
320         require(_targets.length > 0
321                 && _targets.length == _unixTimes.length);
322 
323         for(uint j = 0; j < _targets.length; j++){
324             require(_targets[j] != Ownable.owner);
325             require(unlockUnixTime[_targets[j]] < _unixTimes[j]);
326             unlockUnixTime[_targets[j]] = _unixTimes[j];
327             emit LockedAccount(_targets[j], _unixTimes[j]);
328         }
329     }
330     
331      /**
332      * @dev Enable locked targets to send or receive tokens.
333      * @param _targets Addresses to be locked funds
334      */
335     function unlockAccounts(address[] _targets) onlyOwner public {
336         require(_targets.length > 0);
337          
338         for(uint j = 0; j < _targets.length; j++){
339             unlockUnixTime[_targets[j]] = 0;
340             emit UnlockedAccount(_targets[j]);
341         }
342     }
343 
344 
345     // function which is called when transaction target is an address
346     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
347         require(balances[msg.sender] >= _value);
348         balances[msg.sender] = balances[msg.sender].sub(_value);
349         balances[_to] = balances[_to].add(_value);
350         emit ERC223Transfer(msg.sender, _to, _value, _data);
351         emit Transfer(msg.sender, _to, _value);
352         return true;
353     }
354 
355 
356     // function which is called when transaction target is a contract
357     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
358         require(balances[msg.sender] >= _value);
359         balances[msg.sender] = balances[msg.sender].sub(_value);
360         balances[_to] = balances[_to].add(_value);
361         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
362         receiver.tokenFallback(msg.sender, _value, _data);
363         emit ERC223Transfer(msg.sender, _to, _value, _data);
364         emit Transfer(msg.sender, _to, _value);
365         return true;
366     }
367 
368 
369     /**
370      * @dev Transfer tokens from one address to another
371      *      Added due to backwards compatibility with ERC20
372      * @param _from address The address which you want to send tokens from
373      * @param _to address The address which you want to transfer to
374      * @param _value uint256 The amount of tokens to be transferred
375      */
376     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
377         require(_to != address(0)
378                 && _value > 0
379                 && balances[_from] >= _value
380                 && allowance[_from][msg.sender] >= _value
381                 && frozenAccount[_from] == false
382                 && frozenAccount[_to] == false
383                 && now > unlockUnixTime[_from]
384                 && now > unlockUnixTime[_to]);
385 
386 
387         balances[_from] = balances[_from].sub(_value);
388         balances[_to] = balances[_to].add(_value);
389         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
390         emit Transfer(_from, _to, _value);
391         return true;
392     }
393 
394 
395     /**
396      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
397      * Beware that changing an allowance with this method brings the risk that someone may use both the old
398      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
399      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
400      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
401      * @param _spender The address which will spend the funds.
402      * @param _value The amount of tokens to be spent.
403      */
404     function approve(address _spender, uint256 _value) external returns (bool success) {
405         allowance[msg.sender][_spender] = 0; // mitigate the race condition
406         allowance[msg.sender][_spender] = _value;
407         emit Approval(msg.sender, _spender, _value);
408         return true;
409     }
410 
411 
412     /**
413      * @dev Function to check the amount of tokens that an owner allowed to a spender.
414      * @param _owner Address The address which owns the funds.
415      * @param _spender Address The address which will spend the funds.
416      * @return A uint256 specifying the amount of tokens still available for the spender.
417      */
418     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
419         return allowance[_owner][_spender];
420     }
421 
422 
423     /**
424      * @dev Function to distribute tokens to the list of addresses by the provided uniform amount
425      * @param _addresses List of addresses
426      * @param _amount Uniform amount of tokens
427      * @return A bool specifying the result of transfer
428      */
429     function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {
430         require(_amount > 0
431                 && _addresses.length > 0
432                 && frozenAccount[msg.sender] == false
433                 && now > unlockUnixTime[msg.sender]);
434 
435         uint256 totalAmount = _amount.mul(_addresses.length);
436         require(balances[msg.sender] >= totalAmount);
437 
438         for (uint j = 0; j < _addresses.length; j++) {
439             require(_addresses[j] != 0x0
440                     && frozenAccount[_addresses[j]] == false
441                     && now > unlockUnixTime[_addresses[j]]);
442                     
443             balances[msg.sender] = balances[msg.sender].sub(_amount);
444             balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
445             emit Transfer(msg.sender, _addresses[j], _amount);
446         }
447         return true;
448     }
449 
450 
451     /**
452      * @dev Function to distribute tokens to the list of addresses by the provided various amount
453      * @param _addresses list of addresses
454      * @param _amounts list of token amounts
455      */
456     function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
457         require(_addresses.length > 0
458                 && _addresses.length == _amounts.length
459                 && frozenAccount[msg.sender] == false
460                 && now > unlockUnixTime[msg.sender]);
461 
462         uint256 totalAmount = 0;
463 
464         for(uint j = 0; j < _addresses.length; j++){
465             require(_amounts[j] > 0
466                     && _addresses[j] != 0x0
467                     && frozenAccount[_addresses[j]] == false
468                     && now > unlockUnixTime[_addresses[j]]);
469 
470             totalAmount = totalAmount.add(_amounts[j]);
471         }
472         require(balances[msg.sender] >= totalAmount);
473 
474         for (j = 0; j < _addresses.length; j++) {
475             balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);
476             balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
477             emit Transfer(msg.sender, _addresses[j], _amounts[j]);
478         }
479         return true;
480     }
481     
482     
483     /**
484      * @dev Burns a specific amount of tokens.
485      * @param _from The address that will burn the tokens.
486      * @param _tokenAmount The amount of token to be burned
487      */
488     function burn(address _from, uint256 _tokenAmount) onlyOwner public {
489         require(_tokenAmount > 0
490                 && balances[_from] >= _tokenAmount);
491         
492         
493         balances[_from] = balances[_from].sub(_tokenAmount);
494         totalSupply = totalSupply.sub(_tokenAmount);
495         emit Burn(_from, _tokenAmount);
496     }
497 
498 
499     /**
500      * @dev default payable function executed after receiving ether
501      */
502     function () public payable {
503         // does not accept ether
504     }
505 }