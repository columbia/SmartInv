1 pragma solidity ^0.5.1;
2 
3 contract Ownable {
4     address payable public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     address payable public newOwner;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address payable otherOwner) onlyOwner public {
19         require(otherOwner != address(0));
20         newOwner = otherOwner;
21     }
22 
23     function approveOwnership() public {
24         require(msg.sender == newOwner);
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27         newOwner = address(0);
28     }
29 }
30 
31 contract Pausable is Ownable {
32     event Pause();
33     event Unpause();
34 
35     bool public paused = false;
36 
37     modifier whenNotPaused() {
38         require(!paused);
39         _;
40     }
41 
42     modifier whenPaused() {
43         require(paused);
44         _;
45     }
46 
47     function pause() onlyOwner whenNotPaused public {
48         paused = true;
49         emit Pause();
50     }
51 
52     function unpause() onlyOwner whenPaused public {
53         paused = false;
54         emit Unpause();
55     }
56 }
57 
58 library SafeMath {
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b);
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a / b;
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         return a - b;
76     }
77 
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81         return c;
82     }
83 }
84 
85 contract ERC20Basic {
86     function totalSupply() public view returns (uint256);
87     function balanceOf(address who) public view returns (uint256);
88     function transfer(address payable to, uint256 value) public returns (bool);
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 contract ERC20 is ERC20Basic {
93     function allowance(address owner, address spender) public view returns (uint256);
94     function transferFrom(address payable from, address payable to, uint256 value) public returns (bool);
95     function approve(address spender, uint256 value) public returns (bool);
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 contract SunRichConfig is Ownable {
100     mapping(string => uint256) private data;
101 
102     function set(string memory _key, uint256 _value) onlyOwner public {
103         data[_key] = _value;
104     }
105 
106     function get(string memory _key) public view returns (uint256 _value){
107         return data[_key];
108     }
109 
110     constructor() public {
111         // Fees (in percent x100)
112         set('fee.a2a_sender',   200); // 2.00
113         set('fee.a2a_receiver', 0);
114         set('fee.a2b_sender',   0);
115         set('fee.a2b_receiver', 200); // 2.00
116         set('fee.b2a_sender',   200); // 2.00
117         set('fee.b2a_receiver', 0);
118         set('fee.b2b_sender',   200); // 2.00
119         set('fee.b2b_receiver', 200); // 2.00
120 
121         // Address for fee collection
122         set('fee.collector', uint256(msg.sender));
123 
124         // Address for token issuer
125         set('eth.issuer', uint256(msg.sender));
126 
127         // ETH topup enabled
128         set('eth.topup', 1);
129         // Minimum balance in finney for auto topup
130         set('eth.minBalance', 5);
131     }
132 }
133 
134 contract SunRichAccounts is Ownable {
135     using SafeMath for uint256;
136 
137     uint256 totalSupply;
138 
139     mapping(address => uint256) balances;
140     mapping(address => bool) systemAccounts;
141     mapping(address => bool) businessAccounts;
142     mapping(address => uint256) premiumAccounts;
143     mapping (address => mapping (address => uint256)) internal allowed;
144     mapping(address => bool) frozen;
145 
146     SunRichController ctrl;
147 
148     modifier onlyController {
149         require(msg.sender == address(ctrl));
150         _;
151     }
152  
153     function setController(address payable _ctrl) public onlyOwner {
154         ctrl = SunRichController(_ctrl);
155     }
156 
157     function getBalance(address _owner) public view returns (uint256) {
158         return balances[_owner];
159     }
160 
161     function addTo(address _to, uint256 _value) public onlyController returns (uint256) {
162         require(_to != address(0));
163         balances[_to] = balances[_to].add(_value);
164         return balances[_to];
165     }
166 
167     function subFrom(address _from, uint256 _value) public onlyController returns (uint256) {
168         require(_value <= balances[_from]);
169         balances[_from] = balances[_from].sub(_value);
170         return balances[_from];
171     }
172 
173     function getAllowance(address _owner, address _spender) public view returns (uint256) {
174         return allowed[_owner][_spender];
175     }
176 
177     function addAllowance(address _owner, address _spender, uint256 _value) public onlyController returns (uint256) {
178         allowed[_owner][_spender] = allowed[_owner][_spender].add(_value);
179         return allowed[_owner][_spender];
180     }
181 
182     function subAllowance(address _owner, address _spender, uint256 _value) public onlyController returns (uint256) {
183         require(_value <= allowed[_owner][_spender]);
184         allowed[_owner][_spender] = allowed[_owner][_spender].sub(_value);
185         return allowed[_owner][_spender];
186     }
187 
188     function getTotalSupply() public view returns (uint256) {
189         return totalSupply;
190     }
191 
192     function addTotalSupply(uint256 _value) public onlyController returns (uint256) {
193         totalSupply = totalSupply.add(_value);
194         return totalSupply;
195     }
196 
197     function subTotalSupply(uint256 _value) public onlyController returns (uint256) {
198         totalSupply = totalSupply.sub(_value);
199         return totalSupply;
200     }
201 
202     function setBusiness(address _owner, bool _value) public onlyController {
203         businessAccounts[_owner] = _value;
204     }
205 
206     function isBusiness(address _owner) public view returns (bool) {
207         return businessAccounts[_owner];
208     }
209 
210     function setSystem(address _owner, bool _value) public onlyController {
211         systemAccounts[_owner] = _value;
212     }
213 
214     function isSystem(address _owner) public view returns (bool) {
215         return systemAccounts[_owner];
216     }
217 
218     function setPremium(address _owner, uint256 _value) public onlyController {
219         premiumAccounts[_owner] = _value;
220     }
221 
222     function isPremium(address _owner) public view returns (bool) {
223         return (premiumAccounts[_owner] >= now);
224     }
225 }
226 
227 contract SunRichController is Pausable {
228     using SafeMath for uint256;
229 
230     SunRich master;
231     SunRichConfig config;
232     SunRichAccounts accounts;
233 
234     // Can receive ether
235     function() external payable {
236     }
237 
238     modifier onlyMaster {
239         require(msg.sender == address(master));
240         _;
241     }
242 
243     function setMaster(address _master) public onlyOwner {
244         if(_master == address(0x0)){
245             owner.transfer(address(this).balance);
246         }
247         master = SunRich(_master);
248     }
249 
250     function setConfig(address _config) public onlyOwner {
251         config = SunRichConfig(_config);
252     }
253 
254     function setAccounts(address _accounts) public onlyOwner {
255         accounts = SunRichAccounts(_accounts);
256     }
257 
258     function totalSupply() public view onlyMaster returns (uint256) {
259         return accounts.getTotalSupply();
260     }
261 
262     function balanceOf(address _owner) public view onlyMaster returns (uint256 balance) {
263         return accounts.getBalance(_owner);
264     }
265 
266     function allowance(address _owner, address _spender) public view onlyMaster returns (uint256 remaining) {
267         return accounts.getAllowance(_owner, _spender);
268     }
269 
270     function approve(address _owner, address _spender, uint256 _value) public onlyMaster whenNotPaused returns (bool) {
271         accounts.addAllowance(_owner, _spender, _value);
272         master.emitApproval(_owner, _spender, _value);
273         return true;
274     }
275 
276     function transferWithSender(address payable _from, address payable _to, uint256 _value) public onlyMaster whenNotPaused returns (bool) {
277         if(_from == address(config.get('eth.issuer'))){
278             _issue(_to, _value);
279         } else {
280             if((_from != owner) && (_to != owner)){
281                 _value = _transferFee(_from, _to, _value);
282             }
283 
284             _transfer(_from, _to, _value);
285             master.emitTransfer(_from, _to, _value);
286 
287             _topup(_from);
288             _topup(_to);
289         }
290 
291         return true;
292     }
293 
294     function transferFrom(address payable _from, address payable _to, uint256 _value) public onlyMaster whenNotPaused returns (bool) {
295         if((_from != owner) && (_to != owner)){
296             _value = _transferFee(_from, _to, _value);
297         }
298 
299         _transfer(_from, _to, _value);
300         master.emitTransfer(_from, _to, _value);
301 
302         accounts.subAllowance(_from, _to, _value);
303 
304         _topup(_from);
305         _topup(_to);
306 
307         return true;
308     }
309 
310     function setBusinessAccount(address _sender, address _owner, bool _value) public onlyMaster whenNotPaused {
311         require(accounts.isSystem(_sender));
312         accounts.setBusiness(_owner, _value);
313     }
314 
315     function setSystemAccount(address _owner, bool _value) public onlyOwner {
316         accounts.setSystem(_owner, _value);
317     }
318 
319     function setPremiumAccount(address _owner, uint256 _value) public onlyOwner {
320         accounts.setPremium(_owner, _value);
321     }
322 
323     function _transfer(address _from, address _to, uint256 _value) internal {
324         accounts.subFrom(_from, _value);
325         accounts.addTo(_to, _value);
326     }
327 
328     /**
329      * Fee collection logic goes here
330      */
331     function _transferFee(address _from, address _to, uint256 _value) internal returns (uint256){
332         uint256 feeSender = 0;
333         uint256 feeReceiver = 0;
334 
335         if (!accounts.isBusiness(_from) && !accounts.isBusiness(_to)) {
336             feeSender = config.get('fee.a2a_sender');
337             feeReceiver = config.get('fee.a2a_receiver');
338         }
339         if (!accounts.isBusiness(_from) && accounts.isBusiness(_to)) {
340             feeSender = config.get('fee.a2b_sender');
341             feeReceiver = config.get('fee.a2b_receiver');
342         }
343         if (accounts.isBusiness(_from) && !accounts.isBusiness(_to)) {
344             feeSender = config.get('fee.b2a_sender');
345             feeReceiver = config.get('fee.b2a_receiver');
346         }
347         if (accounts.isBusiness(_from) && accounts.isBusiness(_to)) {
348             feeSender = config.get('fee.b2b_sender');
349             feeReceiver = config.get('fee.b2b_receiver');
350         }
351         if(accounts.isPremium(_from)){
352             feeSender = 0;
353         }
354         if(accounts.isPremium(_to)){
355             feeReceiver = 0;
356         }
357         if(accounts.isSystem(_from) || accounts.isSystem(_to)){
358             feeSender = 0;
359             feeReceiver = 0;
360         }
361 
362         address feeCollector = address(config.get('fee.collector'));
363         address feeSpender = _from;
364         uint256 feeValue = 0;
365         if(feeSender > 0){
366             feeValue = _value.mul(feeSender).div(10000);
367             if(feeValue > 0) {
368                 _transfer(feeSpender, feeCollector, feeValue);
369                 master.emitTransfer(feeSpender, feeCollector, feeValue);
370             }
371         }
372         if(feeReceiver > 0){
373             feeValue = _value.mul(feeReceiver).div(10000);
374             if(feeValue > 0) {
375                 _value = _value.sub(feeValue);
376                 feeSpender = _to;
377                 _transfer(feeSpender, feeCollector, feeValue);
378                 master.emitTransfer(feeSpender, feeCollector, feeValue);
379             }
380         }
381         return _value;
382     }
383 
384     function _topup(address payable _address) internal {
385         uint256 topupEnabled = config.get('eth.topup');
386         if(topupEnabled > 0){
387             uint256 minBalance = config.get('eth.minBalance') * 1 finney;
388             if(address(this).balance > minBalance){
389                 if(_address.balance < minBalance){
390                     _address.transfer(minBalance.sub(_address.balance));
391                 }
392             }
393         }
394     }
395 
396     function _issue(address payable _to, uint256 _value) internal returns (bool) {
397         accounts.addTo(_to, _value);
398         accounts.addTotalSupply(_value);
399         master.emitTransfer(address(0x0), _to, _value);
400         _topup(_to);
401         return true;
402     }
403 
404     /**
405      * OWNER METHODS
406      */
407     function issue(address payable _to, uint256 _value) public onlyOwner returns (bool) {
408         return _issue(_to, _value);
409     }
410 
411     function burn(address _from, uint256 _value) public onlyOwner returns (bool) {
412         accounts.subFrom(_from, _value);
413         accounts.subTotalSupply(_value);
414         // todo: emitBurn
415         return true;
416     }
417 
418     function ownerTransferFrom(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
419         accounts.addTo(_to, _value);
420         accounts.subFrom(_from, _value);
421         master.emitTransfer(_from, _to, _value);
422         return true;
423     }
424 }
425 
426 contract SunRich is ERC20, Ownable {
427     string public constant version = "0.4";
428     string public name = "Sunrich (RUB)";
429     string public symbol = "SRT(R)";
430     uint256 public constant decimals = 2;
431 
432     SunRichController public ctrl;
433 
434     modifier onlyController {
435         require(msg.sender == address(ctrl));
436         _;
437     }
438 
439     constructor() public {
440     }
441 
442     function updateName(string memory _name) public onlyOwner {
443         name = _name;
444     }
445     
446     function updateSymbol(string memory _symbol) public onlyOwner {
447         symbol = _symbol;
448     }
449 
450     function setController(address payable _ctrl) public onlyOwner {
451         ctrl = SunRichController(_ctrl);
452     }
453 
454     function totalSupply() public view returns (uint256) {
455         return ctrl.totalSupply();
456     }
457 
458     function balanceOf(address _who) public view returns (uint256) {
459         return ctrl.balanceOf(_who);
460     }
461 
462     function transfer(address payable _to, uint256 _value) public returns (bool) {
463         return ctrl.transferWithSender(msg.sender, _to, _value);
464     }
465 
466     function allowance(address _owner, address _spender) public view returns (uint256) {
467         return ctrl.allowance(_owner, _spender);
468     }
469 
470     function transferFrom(address payable _from, address payable _to, uint256 _value) public returns (bool) {
471         return ctrl.transferFrom(_from, _to, _value);
472     }
473 
474     function approve(address _spender, uint256 _value) public returns (bool) {
475         return ctrl.approve(msg.sender, _spender, _value);
476     }
477 
478     function emitTransfer(address _from, address _to, uint256 _value) public onlyController {
479         emit Transfer(_from, _to, _value);
480     }
481 
482     function emitApproval(address _owner, address _spender, uint256 _value) public onlyController {
483         emit Approval(_owner, _spender, _value);
484     }
485 
486     function setBusinessAccount(address _owner, bool _value) public {
487         ctrl.setBusinessAccount(msg.sender, _owner, _value);
488     }
489 }