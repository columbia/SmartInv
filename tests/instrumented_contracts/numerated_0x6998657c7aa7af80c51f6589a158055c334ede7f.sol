1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     require(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     //   require(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     //   require(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     require(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 contract Governable {
76 
77   // list of admins
78   address[] public admins;
79 
80   function Governable() {
81     admins.length = 1;
82     admins[0] = msg.sender;
83   }
84 
85   modifier onlyAdmins() {
86     bool isAdmin = false;
87     for (uint256 i = 0; i < admins.length; i++) {
88       if (msg.sender == admins[i]) {
89         isAdmin = true;
90       }
91     }
92     require(isAdmin == true);
93     _;
94   }
95 
96   function addAdmin(address _admin) public onlyAdmins {
97     for (uint256 i = 0; i < admins.length; i++) {
98       require(_admin != admins[i]);
99     }
100     require(admins.length < 10);
101     admins[admins.length++] = _admin;
102   }
103 
104   function removeAdmin(address _admin) public onlyAdmins {
105     uint256 pos = admins.length;
106     for (uint256 i = 0; i < admins.length; i++) {
107       if (_admin == admins[i]) {
108         pos = i;
109       }
110     }
111     require(pos < admins.length);
112     // if not last element, switch with last
113     if (pos < admins.length - 1) {
114       admins[pos] = admins[admins.length - 1];
115     }
116     // then cut off the tail
117     admins.length--;
118   }
119 
120 }
121 
122 /**
123  * @title Pausable
124  * @dev Base contract which allows children to implement an emergency stop mechanism.
125  */
126 contract Pausable is Governable {
127   event Pause();
128   event Unpause();
129 
130   bool public paused = true;
131 
132 
133   /**
134    * @dev Modifier to make a function callable only when the contract is not paused.
135    */
136   modifier whenNotPaused() {
137     require(!paused);
138     _;
139   }
140 
141   /**
142    * @dev Modifier to make a function callable only when the contract is paused.
143    */
144   modifier whenPaused() {
145     require(paused);
146     _;
147   }
148 
149   /**
150    * @dev called by the owner to pause, triggers stopped state
151    */
152   function pause() onlyAdmins whenNotPaused public {
153     paused = true;
154     Pause();
155   }
156 
157   /**
158    * @dev called by the owner to unpause, returns to normal state
159    */
160   function unpause() onlyAdmins whenPaused public {
161     paused = false;
162     Unpause();
163   }
164 }
165 
166 contract DataCentre is Ownable {
167     struct Container {
168         mapping(bytes32 => uint256) values;
169         mapping(bytes32 => address) addresses;
170         mapping(bytes32 => bool) switches;
171         mapping(address => uint256) balances;
172         mapping(address => mapping (address => uint)) constraints;
173     }
174 
175     mapping(bytes32 => Container) containers;
176 
177     // Owner Functions
178     function setValue(bytes32 _container, bytes32 _key, uint256 _value) onlyOwner {
179         containers[_container].values[_key] = _value;
180     }
181 
182     function setAddress(bytes32 _container, bytes32 _key, address _value) onlyOwner {
183         containers[_container].addresses[_key] = _value;
184     }
185 
186     function setBool(bytes32 _container, bytes32 _key, bool _value) onlyOwner {
187         containers[_container].switches[_key] = _value;
188     }
189 
190     function setBalanace(bytes32 _container, address _key, uint256 _value) onlyOwner {
191         containers[_container].balances[_key] = _value;
192     }
193 
194 
195     function setConstraint(bytes32 _container, address _source, address _key, uint256 _value) onlyOwner {
196         containers[_container].constraints[_source][_key] = _value;
197     }
198 
199     // Constant Functions
200     function getValue(bytes32 _container, bytes32 _key) constant returns(uint256) {
201         return containers[_container].values[_key];
202     }
203 
204     function getAddress(bytes32 _container, bytes32 _key) constant returns(address) {
205         return containers[_container].addresses[_key];
206     }
207 
208     function getBool(bytes32 _container, bytes32 _key) constant returns(bool) {
209         return containers[_container].switches[_key];
210     }
211 
212     function getBalanace(bytes32 _container, address _key) constant returns(uint256) {
213         return containers[_container].balances[_key];
214     }
215 
216     function getConstraint(bytes32 _container, address _source, address _key) constant returns(uint256) {
217         return containers[_container].constraints[_source][_key];
218     }
219 }
220 
221 contract ERC223ReceivingContract {
222     function tokenFallback(address _from, uint _value, bytes _data);
223 }
224 
225 
226 /*
227  * ERC20Basic
228  * Simpler version of ERC20 interface
229  * see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20Basic {
232   function totalSupply() constant returns (uint256);
233   function balanceOf(address _owner) constant returns (uint256);
234   function transfer(address _to, uint256 _value) returns (bool);
235   event Transfer(address indexed from, address indexed to, uint value);
236 }
237 
238 contract ERC223Basic is ERC20Basic {
239     function transfer(address to, uint value, bytes data) returns (bool);
240 }
241 
242 /*
243  * ERC20 interface
244  * see https://github.com/ethereum/EIPs/issues/20
245  */
246 contract ERC20 is ERC223Basic {
247   // active supply of tokens
248   function allowance(address _owner, address _spender) constant returns (uint256);
249   function transferFrom(address _from, address _to, uint _value) returns (bool);
250   function approve(address _spender, uint256 _value) returns (bool);
251   event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 contract ControllerInterface {
255 
256   function totalSupply() constant returns (uint256);
257   function balanceOf(address _owner) constant returns (uint256);
258   function allowance(address _owner, address _spender) constant returns (uint256);
259 
260   function approve(address owner, address spender, uint256 value) public returns (bool);
261   function transfer(address owner, address to, uint value, bytes data) public returns (bool);
262   function transferFrom(address owner, address from, address to, uint256 amount, bytes data) public returns (bool);
263   function mint(address _to, uint256 _amount)  public returns (bool);
264 }
265 
266 contract Token is Ownable, ERC20 {
267 
268   event Mint(address indexed to, uint256 amount);
269   event MintToggle(bool status);
270 
271   // Constant Functions
272   function balanceOf(address _owner) constant returns (uint256) {
273     return ControllerInterface(owner).balanceOf(_owner);
274   }
275 
276   function totalSupply() constant returns (uint256) {
277     return ControllerInterface(owner).totalSupply();
278   }
279 
280   function allowance(address _owner, address _spender) constant returns (uint256) {
281     return ControllerInterface(owner).allowance(_owner, _spender);
282   }
283 
284   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
285     Mint(_to, _amount);
286     Transfer(address(0), _to, _amount);
287     return true;
288   }
289 
290   function mintToggle(bool status) onlyOwner public returns (bool) {
291     MintToggle(status);
292     return true;
293   }
294 
295   // public functions
296   function approve(address _spender, uint256 _value) public returns (bool) {
297     ControllerInterface(owner).approve(msg.sender, _spender, _value);
298     Approval(msg.sender, _spender, _value);
299     return true;
300   }
301 
302   function transfer(address _to, uint256 _value) public returns (bool) {
303     bytes memory empty;
304     return transfer(_to, _value, empty);
305   }
306 
307   function transfer(address to, uint value, bytes data) public returns (bool) {
308     ControllerInterface(owner).transfer(msg.sender, to, value, data);
309     Transfer(msg.sender, to, value);
310     _checkDestination(msg.sender, to, value, data);
311     return true;
312   }
313 
314   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
315     bytes memory empty;
316     return transferFrom(_from, _to, _value, empty);
317   }
318 
319 
320   function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool) {
321     ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amount, _data);
322     Transfer(_from, _to, _amount);
323     _checkDestination(_from, _to, _amount, _data);
324     return true;
325   }
326 
327   // Internal Functions
328   function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {
329 
330     uint256 codeLength;
331     assembly {
332       codeLength := extcodesize(_to)
333     }
334     if(codeLength>0) {
335       ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);
336       // untrusted contract call
337       untrustedReceiver.tokenFallback(_from, _value, _data);
338     }
339   }
340 }
341 
342 /**
343  Simple Token based on OpenZeppelin token contract
344  */
345 contract SGPay is Token {
346 
347   string public constant name = "SGPay Token";
348   string public constant symbol = "SGP";
349   uint8 public constant decimals = 18;
350 
351 }
352 
353 contract CrowdsaleInterface {
354   function changeRate(uint256 _newValue) public;
355 }
356 
357 contract DataManager is Pausable {
358 
359   // dataCentre contract addresses
360   address public dataCentreAddr;
361 
362   function DataManager(address _dataCentreAddr) {
363     dataCentreAddr = _dataCentreAddr;
364   }
365 
366   // Constant Functions
367   function balanceOf(address _owner) constant returns (uint256) {
368     return DataCentre(dataCentreAddr).getBalanace('STK', _owner);
369   }
370 
371   function totalSupply() constant returns (uint256) {
372     return DataCentre(dataCentreAddr).getValue('STK', 'totalSupply');
373   }
374 
375   function allowance(address _owner, address _spender) constant returns (uint256) {
376     return DataCentre(dataCentreAddr).getConstraint('STK', _owner, _spender);
377   }
378 
379   function _setTotalSupply(uint256 _newTotalSupply) internal {
380     DataCentre(dataCentreAddr).setValue('STK', 'totalSupply', _newTotalSupply);
381   }
382 
383   function _setBalanceOf(address _owner, uint256 _newValue) internal {
384     DataCentre(dataCentreAddr).setBalanace('STK', _owner, _newValue);
385   }
386 
387   function _setAllowance(address _owner, address _spender, uint256 _newValue) internal {
388     require(balanceOf(_owner) >= _newValue);
389     DataCentre(dataCentreAddr).setConstraint('STK', _owner, _spender, _newValue);
390   }
391 
392 }
393 
394 contract SimpleControl is DataManager {
395   using SafeMath for uint;
396 
397   // token satellite address
398   address public satellite;
399 
400   modifier onlyToken {
401     require(msg.sender == satellite);
402     _;
403   }
404 
405 
406   function SimpleControl(address _satellite, address _dataCentreAddr)
407     DataManager(_dataCentreAddr)
408   {
409     satellite = _satellite;
410   }
411 
412   // public functions
413   function approve(address _owner, address _spender, uint256 _value) public onlyToken whenNotPaused {
414     require(_owner != _spender);
415     _setAllowance(_owner, _spender, _value);
416   }
417 
418 
419   function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal {
420     require(_to != address(this));
421     require(_to != address(0));
422     require(_amount > 0);
423     require(_from != _to);
424     _setBalanceOf(_from, balanceOf(_from).sub(_amount));
425     _setBalanceOf(_to, balanceOf(_to).add(_amount));
426   }
427 
428   function transfer(address _from, address _to, uint256 _amount, bytes _data) public onlyToken whenNotPaused {
429     _transfer(_from, _to, _amount, _data);
430   }
431 
432   function transferFrom(address _sender, address _from, address _to, uint256 _amount, bytes _data) public onlyToken whenNotPaused {
433     _setAllowance(_from, _to, allowance(_from, _to).sub(_amount));
434     _transfer(_from, _to, _amount, _data);
435   }
436 }
437 
438 contract CrowdsaleControl is SimpleControl {
439   using SafeMath for uint;
440 
441   // not necessary to store in data centre
442   bool public mintingFinished = false;
443 
444   modifier canMint(bool status) {
445     require(!mintingFinished == status);
446     _;
447   }
448 
449   function CrowdsaleControl(address _satellite, address _dataCentreAddr)
450     SimpleControl(_satellite, _dataCentreAddr)
451   {
452 
453   }
454 
455   function mint(address _to, uint256 _amount) whenNotPaused canMint(true) onlyAdmins public returns (bool) {
456     bytes memory empty;
457     _setTotalSupply(totalSupply().add(_amount));
458     _setBalanceOf(_to, balanceOf(_to).add(_amount));
459     Token(satellite).mint(_to, _amount);
460     return true;
461   }
462 
463   function startMinting() onlyAdmins public returns (bool) {
464     mintingFinished = false;
465     Token(satellite).mintToggle(mintingFinished);
466     return true;
467   }
468 
469   function finishMinting() onlyAdmins public returns (bool) {
470     mintingFinished = true;
471     Token(satellite).mintToggle(mintingFinished);
472     return true;
473   }
474 
475   function changeRate(uint256 _newValue) onlyAdmins public returns (bool) {
476     CrowdsaleInterface(admins[1]).changeRate(_newValue);
477   }
478 }
479 
480 /**
481  Controller to interface between DataCentre and Token satellite
482  */
483 contract Controller is CrowdsaleControl {
484 
485   function Controller(address _satellite, address _dataCentreAddr)
486     CrowdsaleControl(_satellite, _dataCentreAddr)
487   {
488 
489   }
490 
491   // Owner Functions
492   function setContracts(address _satellite, address _dataCentreAddr) public onlyAdmins whenPaused {
493     dataCentreAddr = _dataCentreAddr;
494     satellite = _satellite;
495   }
496 
497   function kill(address _newController) public onlyAdmins whenPaused {
498     if (dataCentreAddr != address(0)) { Ownable(dataCentreAddr).transferOwnership(msg.sender); }
499     if (satellite != address(0)) { Ownable(satellite).transferOwnership(msg.sender); }
500     selfdestruct(_newController);
501   }
502 
503 }