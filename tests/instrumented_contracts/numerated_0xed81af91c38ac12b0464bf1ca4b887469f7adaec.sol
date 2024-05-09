1 pragma solidity ^0.4.18;
2 
3 
4  /*
5  * Contract that is working with ERC223 tokens
6  */
7 
8 contract ERC223ReceivingContract {
9     function tokenFallback(address _from, uint _value, bytes _data) public;
10 }
11 
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal returns (uint256) {
19         uint256 c = a * b;
20         require(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal returns (uint256) {
25         //   require(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         //   require(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal returns (uint256) {
32         require(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a);
39         return c;
40     }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49     address public owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54     * @dev Throws if called by any account other than the owner.
55     */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70     * @dev Allows the current owner to transfer control of the contract to a newOwner.
71     * @param newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address newOwner) onlyOwner public {
74         require(newOwner != address(0));
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 
79 }
80 
81 /**
82  * @title ControlCentreInterface
83  * @dev ControlCentreInterface is an interface for providing commonly used function
84  * signatures to the ControlCentre
85  */
86 contract ControllerInterface {
87 
88     function totalSupply() public constant returns (uint256);
89     function balanceOf(address _owner) public constant returns (uint256);
90     function allowance(address _owner, address _spender) public constant returns (uint256);
91     function approve(address owner, address spender, uint256 value) public returns (bool);
92     function transfer(address owner, address to, uint value, bytes data) public returns (bool);
93     function transferFrom(address owner, address from, address to, uint256 amount, bytes data) public returns (bool);
94     function mint(address _to, uint256 _amount) public returns (bool);
95 }
96 
97 
98 /*
99  * ERC20Basic
100  * Simpler version of ERC20 interface
101  * see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20Basic {
104     function totalSupply() public constant returns (uint256);
105     function balanceOf(address _owner) public constant returns (uint256);
106     function transfer(address _to, uint256 _value) public returns (bool);
107     event Transfer(address indexed from, address indexed to, uint value);
108 }
109 
110 
111 contract ERC223Basic is ERC20Basic {
112     function transfer(address to, uint value, bytes data) public returns (bool);
113 }
114 
115 contract ERC20 is ERC223Basic {
116     // active supply of tokens
117     function allowance(address _owner, address _spender) public constant returns (uint256);
118     function transferFrom(address _from, address _to, uint _value) public returns (bool);
119     function approve(address _spender, uint256 _value) public returns (bool);
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract Token is Ownable, ERC20 {
124 
125     event Mint(address indexed to, uint256 amount);
126     event MintToggle(bool status);
127 
128     // Constant Functions
129     function balanceOf(address _owner) public constant returns (uint256) {
130         return ControllerInterface(owner).balanceOf(_owner);
131     }
132 
133     function totalSupply() public constant returns (uint256) {
134         return ControllerInterface(owner).totalSupply();
135     }
136 
137     function allowance(address _owner, address _spender) public constant returns (uint256) {
138         return ControllerInterface(owner).allowance(_owner, _spender);
139     }
140 
141     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
142         bytes memory empty;
143         _checkDestination(address(this), _to, _amount, empty);
144         Mint(_to, _amount);
145         Transfer(address(0), _to, _amount);
146         return true;
147     }
148 
149     function mintToggle(bool status) onlyOwner public returns (bool) {
150         MintToggle(status);
151         return true;
152     }
153 
154     // public functions
155     function approve(address _spender, uint256 _value) public returns (bool) {
156         ControllerInterface(owner).approve(msg.sender, _spender, _value);
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     function transfer(address _to, uint256 _value) public returns (bool) {
162         bytes memory empty;
163         return transfer(_to, _value, empty);
164     }
165 
166     function transfer(address to, uint value, bytes data) public returns (bool) {
167         ControllerInterface(owner).transfer(msg.sender, to, value, data);
168         Transfer(msg.sender, to, value);
169         _checkDestination(msg.sender, to, value, data);
170         return true;
171     }
172 
173     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
174         bytes memory empty;
175         return transferFrom(_from, _to, _value, empty);
176     }
177 
178 
179     function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool) {
180         ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amount, _data);
181         Transfer(_from, _to, _amount);
182         _checkDestination(_from, _to, _amount, _data);
183         return true;
184     }
185 
186     // Internal Functions
187     function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {
188         uint256 codeLength;
189         assembly {
190             codeLength := extcodesize(_to)
191         }
192         if(codeLength>0) {
193             ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);
194             // untrusted contract call
195             untrustedReceiver.tokenFallback(_from, _value, _data);
196         }
197     }
198 }
199 
200 
201 contract DataCentre is Ownable {
202     struct Container {
203         mapping(bytes32 => uint256) values;
204         mapping(bytes32 => address) addresses;
205         mapping(bytes32 => bool) switches;
206         mapping(address => uint256) balances;
207         mapping(address => mapping (address => uint)) constraints;
208     }
209 
210     mapping(bytes32 => Container) containers;
211 
212     // Owner Functions
213     function setValue(bytes32 _container, bytes32 _key, uint256 _value) public onlyOwner {
214         containers[_container].values[_key] = _value;
215     }
216 
217     function setAddress(bytes32 _container, bytes32 _key, address _value) public onlyOwner {
218         containers[_container].addresses[_key] = _value;
219     }
220 
221     function setBool(bytes32 _container, bytes32 _key, bool _value) public onlyOwner {
222         containers[_container].switches[_key] = _value;
223     }
224 
225     function setBalanace(bytes32 _container, address _key, uint256 _value) public onlyOwner {
226         containers[_container].balances[_key] = _value;
227     }
228 
229 
230     function setConstraint(bytes32 _container, address _source, address _key, uint256 _value) public onlyOwner {
231         containers[_container].constraints[_source][_key] = _value;
232     }
233 
234     // Constant Functions
235     function getValue(bytes32 _container, bytes32 _key) public constant returns(uint256) {
236         return containers[_container].values[_key];
237     }
238 
239     function getAddress(bytes32 _container, bytes32 _key) public constant returns(address) {
240         return containers[_container].addresses[_key];
241     }
242 
243     function getBool(bytes32 _container, bytes32 _key) public constant returns(bool) {
244         return containers[_container].switches[_key];
245     }
246 
247     function getBalanace(bytes32 _container, address _key) public constant returns(uint256) {
248         return containers[_container].balances[_key];
249     }
250 
251     function getConstraint(bytes32 _container, address _source, address _key) public constant returns(uint256) {
252         return containers[_container].constraints[_source][_key];
253     }
254 }
255 
256 contract Governable {
257 
258     // list of admins, council at first spot
259     address[] public admins;
260 
261     modifier onlyAdmins() {
262         var(adminStatus, ) = isAdmin(msg.sender);
263         require(adminStatus == true);
264         _;
265     }
266 
267     function Governable() public {
268         admins.length = 1;
269         admins[0] = msg.sender;
270     }
271 
272     function addAdmin(address _admin) public onlyAdmins {
273         var(adminStatus, ) = isAdmin(_admin);
274         require(!adminStatus);
275         require(admins.length < 10);
276         admins[admins.length++] = _admin;
277     }
278 
279     function removeAdmin(address _admin) public onlyAdmins {
280         var(adminStatus, pos) = isAdmin(_admin);
281         require(adminStatus);
282         require(pos < admins.length);
283         // if not last element, switch with last
284         if (pos < admins.length - 1) {
285             admins[pos] = admins[admins.length - 1];
286         }
287         // then cut off the tail
288         admins.length--;
289     }
290 
291     function isAdmin(address _addr) internal returns (bool isAdmin, uint256 pos) {
292         isAdmin = false;
293         for (uint256 i = 0; i < admins.length; i++) {
294             if (_addr == admins[i]) {
295             isAdmin = true;
296             pos = i;
297             }
298         }
299     }
300 }
301 
302 
303 /**
304  * @title Pausable
305  * @dev Base contract which allows children to implement an emergency stop mechanism.
306  */
307 contract Pausable is Governable {
308     event Pause();
309     event Unpause();
310 
311     bool public paused = true;
312 
313     /**
314     * @dev Modifier to make a function callable only when the contract is not paused.
315     */
316     modifier whenNotPaused(address _to) {
317         var(adminStatus, ) = isAdmin(_to);
318         require(!paused || adminStatus);
319         _;
320     }
321 
322     /**
323     * @dev Modifier to make a function callable only when the contract is paused.
324     */
325     modifier whenPaused(address _to) {
326         var(adminStatus, ) = isAdmin(_to);
327         require(paused || adminStatus);
328         _;
329     }
330 
331     /**
332     * @dev called by the owner to pause, triggers stopped state
333     */
334     function pause() onlyAdmins whenNotPaused(msg.sender) public {
335         paused = true;
336         Pause();
337     }
338 
339     /**
340     * @dev called by the owner to unpause, returns to normal state
341     */
342     function unpause() onlyAdmins whenPaused(msg.sender) public {
343         paused = false;
344         Unpause();
345     }
346 }
347 
348 contract DataManager is Pausable {
349 
350     // satelite contract addresses
351     address public dataCentreAddr;
352 
353     function DataManager(address _dataCentreAddr) {
354         dataCentreAddr = _dataCentreAddr;
355     }
356 
357     // Constant Functions
358     function balanceOf(address _owner) public constant returns (uint256) {
359         return DataCentre(dataCentreAddr).getBalanace("FORCE", _owner);
360     }
361 
362     function totalSupply() public constant returns (uint256) {
363         return DataCentre(dataCentreAddr).getValue("FORCE", "totalSupply");
364     }
365 
366     function allowance(address _owner, address _spender) public constant returns (uint256) {
367         return DataCentre(dataCentreAddr).getConstraint("FORCE", _owner, _spender);
368     }
369 
370     function _setTotalSupply(uint256 _newTotalSupply) internal {
371         DataCentre(dataCentreAddr).setValue("FORCE", "totalSupply", _newTotalSupply);
372     }
373 
374     function _setBalanceOf(address _owner, uint256 _newValue) internal {
375         DataCentre(dataCentreAddr).setBalanace("FORCE", _owner, _newValue);
376     }
377 
378     function _setAllowance(address _owner, address _spender, uint256 _newValue) internal {
379         require(balanceOf(_owner) >= _newValue);
380         DataCentre(dataCentreAddr).setConstraint("FORCE", _owner, _spender, _newValue);
381     }
382 
383 }
384 
385 contract SimpleControl is DataManager {
386     using SafeMath for uint;
387 
388     // not necessary to store in data centre  address public satellite;
389 
390     address public satellite;
391 
392     modifier onlyToken {
393         require(msg.sender == satellite);
394         _;
395     }
396 
397     function SimpleControl(address _satellite, address _dataCentreAddr) public
398         DataManager(_dataCentreAddr)
399     {
400         satellite = _satellite;
401     }
402 
403     // public functions
404     function approve(address _owner, address _spender, uint256 _value) public onlyToken whenNotPaused(_owner) {
405         require(_owner != _spender);
406         _setAllowance(_owner, _spender, _value);
407     }
408 
409     function transfer(address _from, address _to, uint256 _amount, bytes _data) public onlyToken whenNotPaused(_from) {
410         _transfer(_from, _to, _amount, _data);
411     }
412 
413     function transferFrom(address _sender, address _from, address _to, uint256 _amount, bytes _data) public onlyToken whenNotPaused(_sender) {
414         _setAllowance(_from, _to, allowance(_from, _to).sub(_amount));
415         _transfer(_from, _to, _amount, _data);
416     }
417 
418     function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal {
419         require(_to != address(this));
420         require(_to != address(0));
421         require(_amount > 0);
422         require(_from != _to);
423         _setBalanceOf(_from, balanceOf(_from).sub(_amount));
424         _setBalanceOf(_to, balanceOf(_to).add(_amount));
425     }
426 }
427 
428 
429 contract CrowdsaleControl is SimpleControl {
430     using SafeMath for uint;
431 
432     // not necessary to store in data centre
433     bool public mintingFinished;
434 
435     modifier canMint(bool status, address _to) {
436         var(adminStatus, ) = isAdmin(_to);
437         require(!mintingFinished == status || adminStatus);
438         _;
439     }
440 
441     function CrowdsaleControl(address _satellite, address _dataCentreAddr) public
442         SimpleControl(_satellite, _dataCentreAddr)
443     {
444 
445     }
446 
447     function mint(address _to, uint256 _amount) whenNotPaused(_to) canMint(true, msg.sender) onlyAdmins public returns (bool) {
448         _setTotalSupply(totalSupply().add(_amount));
449         _setBalanceOf(_to, balanceOf(_to).add(_amount));
450         Token(satellite).mint(_to, _amount);
451         return true;
452     }
453 
454     function startMinting() onlyAdmins public returns (bool) {
455         mintingFinished = false;
456         Token(satellite).mintToggle(mintingFinished);
457         return true;
458     }
459 
460     function finishMinting() onlyAdmins public returns (bool) {
461         mintingFinished = true;
462         Token(satellite).mintToggle(mintingFinished);
463         return true;
464     }
465 }
466 
467 
468 /**
469  Simple Token based on OpenZeppelin token contract
470  */
471 contract Controller is CrowdsaleControl {
472 
473     /**
474     * @dev Constructor that gives msg.sender all of existing tokens.
475     */
476     function Controller(address _satellite, address _dataCentreAddr) public
477         CrowdsaleControl(_satellite, _dataCentreAddr)
478     {
479 
480     }
481 
482     // Owner Functions
483     function setContracts(address _satellite, address _dataCentreAddr) public onlyAdmins whenPaused(msg.sender) {
484         dataCentreAddr = _dataCentreAddr;
485         satellite = _satellite;
486     }
487 
488     function kill(address _newController) public onlyAdmins whenPaused(msg.sender) {
489         if (dataCentreAddr != address(0)) { 
490             Ownable(dataCentreAddr).transferOwnership(msg.sender);
491         }
492         if (satellite != address(0)) {
493             Ownable(satellite).transferOwnership(msg.sender);
494         }
495         selfdestruct(_newController);
496     }
497 }