1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 }
73 
74 contract ERC223 {
75   uint public totalSupply;
76 
77   function name() public view returns (string _name);
78   function symbol() public view returns (string _symbol);
79   function decimals() public view returns (uint8 _decimals);
80   function totalSupply() public view returns (uint256 _supply);
81   function balanceOf(address who) public view returns (uint);
82 
83   function transfer(address to, uint value) public returns (bool ok);
84   function transfer(address to, uint value, bytes data) public returns (bool ok);
85   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
86   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
87   event Transfer(address indexed _from, address indexed _to, uint256 _value);
88 }
89 
90 /**
91  * @title ContractReceiver
92  * @dev Receiver for ERC223 tokens
93  */
94 contract ContractReceiver {
95 
96   struct TKN {
97     address sender;
98     uint value;
99     bytes data;
100     bytes4 sig;
101   }
102 
103   function tokenFallback(address _from, uint _value, bytes _data) public pure {
104     TKN memory tkn;
105     tkn.sender = _from;
106     tkn.value = _value;
107     tkn.data = _data;
108     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
109     tkn.sig = bytes4(u);
110 
111     /* tkn variable is analogue of msg variable of Ether transaction
112     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
113     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
114     *  tkn.data is data of token transaction   (analogue of msg.data)
115     *  tkn.sig is 4 bytes signature of function
116     *  if data of token transaction is a function execution
117     */
118   }
119 }
120 
121 
122 
123 
124 
125 
126 
127 
128 /** CLIPTOKEN
129 
130                                       .--:///++++++++++///:--.                                     
131                                 .-:/+++++++++++++++++++++++++++++/:.                                
132                             -:++++++++++++++++++++++++++++++++++++++++/-.                           
133                         .:/+++++++++++++++++++++++++++++++++++++++++++++++:.                        
134                      .:++++++++++++++++++++++++++++++++++++++++++++++++++++++:.                     
135                    -/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-                  
136                  -+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-                   
137                -+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                    
138              -/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                      
139             /++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/.          .--           
140           -++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/.          .-::::.          
141          :+++++++++++++++++++++++++++++++//::-........--://++++++++++/.          .-:::::::-         
142         /++++++++++++++++++++++++++++/:.``                ``.:/++++/.         `.-::::::::::-       
143        /++++++++++++++++++++++++++/-.                          `-:.         `.:::::::::::::::      
144       /+++++++++++++++++++++++++/.                                        `.::::::::::::::::::     
145      :++++++++++++++++++++++++/.                                        `.::::::::::::::::::::-     
146     -++++++++++++++++++++++++-                                         .:::::::::::::::::::::::-    
147     +++++++++++++++++++++++/`                                           -:::::::::::::::::::::::   
148    :++++++++++++++++++++++/`                                             .::::::::::::::::::::::-   
149    ++++++++++++++++++++++/`                                               -::::::::::::::::::::::  
150   -++++++++++++++++++++++.                       ..........................::::::::::::::::::::::-  
151   /+++++++++++++++++++++:                       `:::::::::::::::::::::::::::::::::::::::::::::::::  
152   ++++++++++++++++++++++.                       `::::::::::::::::::::::::::::::::::::::::::::::::: 
153   ++++++++++++++++++++++`                       `::::::::::::::::::::::::::::::::::::::::::::::::: 
154   ++++++++++++++++++++++                        `::::::::::::::::::::::::::::::::::::::::::::::::: 
155   ++++++++++++++++++++++`                       `::::::::::::::::::::::::::::::::::::::::::::::::: 
156   ++++++++++++++++++++++`                       `::::::::::::::::::::::::::::::::::::::::::::::::: 
157   /+++++++++++++++++++++:                       `:::::::::::::::::::::::::::::::::::::::::::::::::  
158   -++++++++++++++++++++++`                      `--------------------------:::::::::::::::::::::::  
159    ++++++++++++++++++++++/                                                .:::::::::::::::::::::::  
160    :++++++++++++++++++++++:                                              .:::::::::::::::::::::::   
161     +++++++++++++++++++++++:                                            .:::::::::::::::::::::::.   
162     :++++++++++++++++++++++.                                           .:::::::::::::::::::::::-    
163      /++++++++++++++++++++-                                             .::::::::::::::::::::::.    
164       +++++++++++++++++++-                                                .-::::::::::::::::::.     
165        +++++++++++++++++:                                       ..          .-:::::::::::::::.      
166         /++++++++++++++:        .-//+:-                      .:/++/.          .-::::::::::::.       
167          /++++++++++++:     .-/+++++++++//:-..        ..-://++++++++/.          .-:::::::::        
168           :++++++++++/` .:/+++++++++++++++++++++++++++++++++++++++++++/.          .-:::::-         
169            ./++++++++//+++++++++++++++++++++++++++++++++++++++++++++++++/-          .-::.           
170             `:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`         .`            
171               ./++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                     
172                 ./++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                   
173                   `:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:                   
174                     `-/++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                    
175                        `-/++++++++++++++++++++++++++++++++++++++++++++++++/-.                       
176                           `.:/+++++++++++++++++++++++++++++++++++++++++:-`                          
177                               `.-:++++++++++++++++++++++++++++++++/:.`                              
178                                    ``.-://++++++++++++++++//:--.`                                   
179                                              ``````````                                                
180      
181              ::::::  ::    `::  :::::    ,,,,,,,  ,,,,,,    ,,   ,,, ,,,,,,  ,,.    ,,                   
182             :::,.,:  ::    `::  ::,:::   ,,,,,,, ,,,,,,,,`  ,,  ,,,  ,,,,,,  ,,,    ,,                   
183            ,::       ::    `::  ::  ::     ,,   .,,    ,,,  ,, .,,   ,,      ,,,,   ,,                   
184            ::`       ::    `::  ::  ::     ,,   ,,,     ,,` ,, ,,    ,,      ,,,,,  ,,                   
185            ::        ::    `::  ::::::     ,,   ,,      ,,, ,,,,,    ,,,,,,  ,, ,,, ,,                   
186            ::        ::    `::  :::::      ,,   ,,      ,,, ,,`,,    ,,,,,,  ,, `,, ,,                   
187            ::.       ::    `::  ::         ,,   ,,,     ,,  ,, ,,,   ,,      ,,  ,,,,,                   
188            .::       ::    `::  ::         ,,    ,,.   ,,,  ,,  ,,,  ,,      ,,   ,,,,                   
189             ,::::::  :::::,`::  ::         ,,    .,,,,,,,   ,,  `,,  ,,,,,,  ,,    ,,,                   
190              .:::::  :::::,`::  ::         ,,      ,,,,,    ,,   ,,, ,,,,,,  ,,     ,,                   
191  */
192  
193 contract CLIP is ERC223, Ownable {
194   using SafeMath for uint256;
195 
196   string public name = "ClipToken";
197   string public symbol = "CLIP";
198   uint8 public decimals = 8;
199   uint256 public totalSupply = 333e8 * 1e8;
200   uint256 public distributeAmount = 0;
201 
202   mapping (address => uint256) public balanceOf;
203   mapping (address => bool) public frozenAccount;
204   mapping (address => uint256) public unlockUnixTime;
205 
206   event FrozenFunds(address indexed target, bool frozen);
207   event LockedFunds(address indexed target, uint256 locked);
208   event Burn(address indexed burner, uint256 value);
209 
210   function CLIP() public {
211       balanceOf[msg.sender] = totalSupply;
212   }
213 
214   function name() public view returns (string _name) {
215       return name;
216   }
217 
218   function symbol() public view returns (string _symbol) {
219       return symbol;
220   }
221 
222   function decimals() public view returns (uint8 _decimals) {
223       return decimals;
224   }
225 
226   function totalSupply() public view returns (uint256 _totalSupply) {
227       return totalSupply;
228   }
229 
230 
231   function balanceOf(address _owner) public view returns (uint256 balance) {
232     return balanceOf[_owner];
233   }
234     
235     
236   modifier onlyPayloadSize(uint256 size){
237     assert(msg.data.length >= size + 4);
238     _;
239   }
240 
241   // Function that is called when a user or another contract wants to transfer funds .
242   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
243     require(_value > 0
244             && frozenAccount[msg.sender] == false
245             && frozenAccount[_to] == false
246             && now > unlockUnixTime[msg.sender]
247             && now > unlockUnixTime[_to]);
248 
249     if(isContract(_to)) {
250         if (balanceOf[msg.sender] < _value) revert();
251         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
252         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
253         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
254         Transfer(msg.sender, _to, _value, _data);
255         Transfer(msg.sender, _to, _value);
256         return true;
257     }
258     else {
259         return transferToAddress(_to, _value, _data);
260     }
261   }
262 
263 
264   // Function that is called when a user or another contract wants to transfer funds .
265   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
266     require(_value > 0
267             && frozenAccount[msg.sender] == false
268             && frozenAccount[_to] == false
269             && now > unlockUnixTime[msg.sender]
270             && now > unlockUnixTime[_to]);
271 
272     if(isContract(_to)) {
273         return transferToContract(_to, _value, _data);
274     }
275     else {
276         return transferToAddress(_to, _value, _data);
277     }
278   }
279 
280   // Standard function transfer similar to ERC20 transfer with no _data .
281   // Added due to backwards compatibility reasons .
282   function transfer(address _to, uint _value) public returns (bool success) {
283     require(_value > 0
284             && frozenAccount[msg.sender] == false
285             && frozenAccount[_to] == false
286             && now > unlockUnixTime[msg.sender]
287             && now > unlockUnixTime[_to]);
288 
289     //standard function transfer similar to ERC20 transfer with no _data
290     //added due to backwards compatibility reasons
291     bytes memory empty;
292     if(isContract(_to)) {
293         return transferToContract(_to, _value, empty);
294     }
295     else {
296         return transferToAddress(_to, _value, empty);
297     }
298   }
299 
300   // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
301   function isContract(address _addr) private view returns (bool is_contract) {
302     uint length;
303     assembly {
304       // retrieve the size of the code on target address, this needs assembly
305       length := extcodesize(_addr)
306     }
307     return (length>0);
308   }
309 
310   // function that is called when transaction target is an address
311   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
312     if (balanceOf[msg.sender] < _value) revert();
313     balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
314     balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
315     Transfer(msg.sender, _to, _value, _data);
316     Transfer(msg.sender, _to, _value);
317     return true;
318   }
319 
320   //function that is called when transaction target is a contract
321   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
322     if (balanceOf[msg.sender] < _value) revert();
323     balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
324     balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
325     ContractReceiver receiver = ContractReceiver(_to);
326     receiver.tokenFallback(msg.sender, _value, _data);
327     Transfer(msg.sender, _to, _value, _data);
328     Transfer(msg.sender, _to, _value);
329     return true;
330   }
331 
332   /**
333    * @dev Prevent targets from sending or receiving tokens
334    * @param targets Addresses to be frozen
335    * @param isFrozen either to freeze it or not
336    */
337   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
338     require(targets.length > 0);
339 
340     for (uint i = 0; i < targets.length; i++) {
341       require(targets[i] != 0x0);
342       frozenAccount[targets[i]] = isFrozen;
343       FrozenFunds(targets[i], isFrozen);
344     }
345   }
346 
347   /**
348    * @dev Prevent targets from sending or receiving tokens by setting Unix times
349    * @param targets Addresses to be locked funds
350    * @param unixTimes Unix times when locking up will be finished
351    */
352   function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
353     require(targets.length > 0
354             && targets.length == unixTimes.length);
355 
356     for(uint i = 0; i < targets.length; i++){
357       require(unlockUnixTime[targets[i]] < unixTimes[i]);
358       unlockUnixTime[targets[i]] = unixTimes[i];
359       LockedFunds(targets[i], unixTimes[i]);
360     }
361   }
362 
363   /**
364    * @dev Burns a specific amount of tokens.
365    * @param _from The address that will burn the tokens.
366    * @param _unitAmount The amount of token to be burned.
367    */
368   function burn(address _from, uint256 _unitAmount) onlyOwner public {
369     require(_unitAmount > 0
370             && balanceOf[_from] >= _unitAmount);
371 
372     balanceOf[_from] = SafeMath.sub(balanceOf[_from], _unitAmount);
373     totalSupply = SafeMath.sub(totalSupply, _unitAmount);
374     Burn(_from, _unitAmount);
375   }
376 
377     /**
378      * @dev Function to distribute tokens to the list of addresses by the provided amount
379      */
380     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
381         require(amount > 0
382                 && addresses.length > 0
383                 && frozenAccount[msg.sender] == false
384                 && now > unlockUnixTime[msg.sender]);
385 
386         amount = amount.mul(1e8);
387         uint256 totalAmount = amount.mul(addresses.length);
388         require(balanceOf[msg.sender] >= totalAmount);
389 
390         for (uint i = 0; i < addresses.length; i++) {
391             require(addresses[i] != 0x0
392                     && frozenAccount[addresses[i]] == false
393                     && now > unlockUnixTime[addresses[i]]);
394 
395             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amount);
396             Transfer(msg.sender, addresses[i], amount);
397         }
398         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
399         return true;
400     }
401 
402     function distributeToken(address[] addresses, uint[] amounts) public returns (bool) {
403         require(addresses.length > 0
404                 && addresses.length == amounts.length
405                 && frozenAccount[msg.sender] == false
406                 && now > unlockUnixTime[msg.sender]);
407 
408         uint256 totalAmount = 0;
409 
410         for(uint i = 0; i < addresses.length; i++){
411             require(amounts[i] > 0
412                     && addresses[i] != 0x0
413                     && frozenAccount[addresses[i]] == false
414                     && now > unlockUnixTime[addresses[i]]);
415 
416             amounts[i] = amounts[i].mul(1e8);
417             totalAmount = totalAmount.add(amounts[i]);
418         }
419         require(balanceOf[msg.sender] >= totalAmount);
420 
421         for (i = 0; i < addresses.length; i++) {
422             balanceOf[addresses[i]] = balanceOf[addresses[i]].add(amounts[i]);
423             Transfer(msg.sender, addresses[i], amounts[i]);
424         }
425         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
426         return true;
427     }
428   
429   /**
430    * @dev Function to collect tokens from the list of addresses
431    */
432   function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
433     require(addresses.length > 0
434             && addresses.length == amounts.length);
435 
436     uint256 totalAmount = 0;
437 
438     for (uint i = 0; i < addresses.length; i++) {
439       require(amounts[i] > 0
440               && addresses[i] != 0x0
441               && frozenAccount[addresses[i]] == false
442               && now > unlockUnixTime[addresses[i]]);
443 
444       amounts[i] = SafeMath.mul(amounts[i], 1e8);
445       require(balanceOf[addresses[i]] >= amounts[i]);
446       balanceOf[addresses[i]] = SafeMath.sub(balanceOf[addresses[i]], amounts[i]);
447       totalAmount = SafeMath.add(totalAmount, amounts[i]);
448       Transfer(addresses[i], msg.sender, amounts[i]);
449     }
450     balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], totalAmount);
451     return true;
452   }
453 
454   function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
455     distributeAmount = _unitAmount;
456   }
457 
458   /**
459    * @dev Function to distribute tokens to the msg.sender automatically
460    *      If distributeAmount is 0, this function doesn't work
461    */
462   function autoDistribute() payable public {
463     require(distributeAmount > 0
464             && balanceOf[owner] >= distributeAmount
465             && frozenAccount[msg.sender] == false
466             && now > unlockUnixTime[msg.sender]);
467     if (msg.value > 0) owner.transfer(msg.value);
468 
469     balanceOf[owner] = SafeMath.sub(balanceOf[owner], distributeAmount);
470     balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], distributeAmount);
471     Transfer(owner, msg.sender, distributeAmount);
472   }
473 
474   /**
475    * @dev token fallback function
476    */
477   function() payable public {
478     autoDistribute();
479   }
480 }