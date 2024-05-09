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
124         // ETH topup enabled
125         set('eth.topup', 1);
126         // Minimum balance in finney for auto topup
127         set('eth.minBalance', 5);
128     }
129 }
130 
131 contract SunRichAccounts is Ownable {
132     using SafeMath for uint256;
133 
134     uint256 totalSupply;
135 
136     mapping(address => uint256) balances;
137     mapping(address => bool) systemAccounts;
138     mapping(address => bool) businessAccounts;
139     mapping(address => uint256) premiumAccounts;
140     mapping (address => mapping (address => uint256)) internal allowed;
141     mapping(address => bool) frozen;
142 
143     SunRichController ctrl;
144 
145     modifier onlyController {
146         require(msg.sender == address(ctrl));
147         _;
148     }
149  
150     function setController(address payable _ctrl) public onlyOwner {
151         ctrl = SunRichController(_ctrl);
152     }
153 
154     function getBalance(address _owner) public view returns (uint256) {
155         return balances[_owner];
156     }
157 
158     function addTo(address _to, uint256 _value) public onlyController returns (uint256) {
159         require(_to != address(0));
160         balances[_to] = balances[_to].add(_value);
161         return balances[_to];
162     }
163 
164     function subFrom(address _from, uint256 _value) public onlyController returns (uint256) {
165         require(_value <= balances[_from]);
166         balances[_from] = balances[_from].sub(_value);
167         return balances[_from];
168     }
169 
170     function getAllowance(address _owner, address _spender) public view returns (uint256) {
171         return allowed[_owner][_spender];
172     }
173 
174     function addAllowance(address _owner, address _spender, uint256 _value) public onlyController returns (uint256) {
175         allowed[_owner][_spender] = allowed[_owner][_spender].add(_value);
176         return allowed[_owner][_spender];
177     }
178 
179     function subAllowance(address _owner, address _spender, uint256 _value) public onlyController returns (uint256) {
180         require(_value <= allowed[_owner][_spender]);
181         allowed[_owner][_spender] = allowed[_owner][_spender].sub(_value);
182         return allowed[_owner][_spender];
183     }
184 
185     function getTotalSupply() public view returns (uint256) {
186         return totalSupply;
187     }
188 
189     function addTotalSupply(uint256 _value) public onlyController returns (uint256) {
190         totalSupply = totalSupply.add(_value);
191         return totalSupply;
192     }
193 
194     function subTotalSupply(uint256 _value) public onlyController returns (uint256) {
195         totalSupply = totalSupply.sub(_value);
196         return totalSupply;
197     }
198 
199     function setBusiness(address _owner, bool _value) public onlyController {
200         businessAccounts[_owner] = _value;
201     }
202 
203     function isBusiness(address _owner) public view returns (bool) {
204         return businessAccounts[_owner];
205     }
206 
207     function setSystem(address _owner, bool _value) public onlyController {
208         systemAccounts[_owner] = _value;
209     }
210 
211     function isSystem(address _owner) public view returns (bool) {
212         return systemAccounts[_owner];
213     }
214 
215     function setPremium(address _owner, uint256 _value) public onlyController {
216         premiumAccounts[_owner] = _value;
217     }
218 
219     function isPremium(address _owner) public view returns (bool) {
220         return (premiumAccounts[_owner] >= now);
221     }
222 }
223 
224 contract SunRichController is Pausable {
225     using SafeMath for uint256;
226 
227     SunRich master;
228     SunRichConfig config;
229     SunRichAccounts accounts;
230 
231     // Can receive ether
232     function() external payable {
233     }
234 
235     modifier onlyMaster {
236         require(msg.sender == address(master));
237         _;
238     }
239 
240     function setMaster(address _master) public onlyOwner {
241         if(_master == address(0x0)){
242             owner.transfer(address(this).balance);
243         }
244         master = SunRich(_master);
245     }
246 
247     function setConfig(address _config) public onlyOwner {
248         config = SunRichConfig(_config);
249     }
250 
251     function setAccounts(address _accounts) public onlyOwner {
252         accounts = SunRichAccounts(_accounts);
253     }
254 
255     function totalSupply() public view onlyMaster returns (uint256) {
256         return accounts.getTotalSupply();
257     }
258 
259     function balanceOf(address _owner) public view onlyMaster returns (uint256 balance) {
260         return accounts.getBalance(_owner);
261     }
262 
263     function allowance(address _owner, address _spender) public view onlyMaster returns (uint256 remaining) {
264         return accounts.getAllowance(_owner, _spender);
265     }
266 
267     function approve(address _owner, address _spender, uint256 _value) public onlyMaster whenNotPaused returns (bool) {
268         accounts.addAllowance(_owner, _spender, _value);
269         master.emitApproval(_owner, _spender, _value);
270         return true;
271     }
272 
273     function transferWithSender(address payable _from, address payable _to, uint256 _value) public onlyMaster whenNotPaused returns (bool) {
274         if(_from == address(config.get('eth.issuer'))){
275             _issue(_to, _value);
276         } else {
277             if((_from != owner) && (_to != owner)){
278                 _value = _transferFee(_from, _to, _value);
279             }
280 
281             _transfer(_from, _to, _value);
282             master.emitTransfer(_from, _to, _value);
283 
284             _topup(_from);
285             _topup(_to);
286         }
287 
288         return true;
289     }
290 
291     function transferFrom(address payable _from, address payable _to, uint256 _value) public onlyMaster whenNotPaused returns (bool) {
292         if((_from != owner) && (_to != owner)){
293             _value = _transferFee(_from, _to, _value);
294         }
295 
296         _transfer(_from, _to, _value);
297         master.emitTransfer(_from, _to, _value);
298 
299         accounts.subAllowance(_from, _to, _value);
300 
301         _topup(_from);
302         _topup(_to);
303 
304         return true;
305     }
306 
307     function setBusinessAccount(address _sender, address _owner, bool _value) public onlyMaster whenNotPaused {
308         require(accounts.isSystem(_sender));
309         accounts.setBusiness(_owner, _value);
310     }
311 
312     function setSystemAccount(address _owner, bool _value) public onlyOwner {
313         accounts.setSystem(_owner, _value);
314     }
315 
316     function setPremiumAccount(address _owner, uint256 _value) public onlyOwner {
317         accounts.setPremium(_owner, _value);
318     }
319 
320     function _transfer(address _from, address _to, uint256 _value) internal {
321         accounts.subFrom(_from, _value);
322         accounts.addTo(_to, _value);
323     }
324 
325     /**
326      * Fee collection logic goes here
327      */
328     function _transferFee(address _from, address _to, uint256 _value) internal returns (uint256){
329         uint256 feeSender = 0;
330         uint256 feeReceiver = 0;
331 
332         if (!accounts.isBusiness(_from) && !accounts.isBusiness(_to)) {
333             feeSender = config.get('fee.a2a_sender');
334             feeReceiver = config.get('fee.a2a_receiver');
335         }
336         if (!accounts.isBusiness(_from) && accounts.isBusiness(_to)) {
337             feeSender = config.get('fee.a2b_sender');
338             feeReceiver = config.get('fee.a2b_receiver');
339         }
340         if (accounts.isBusiness(_from) && !accounts.isBusiness(_to)) {
341             feeSender = config.get('fee.b2a_sender');
342             feeReceiver = config.get('fee.b2a_receiver');
343         }
344         if (accounts.isBusiness(_from) && accounts.isBusiness(_to)) {
345             feeSender = config.get('fee.b2b_sender');
346             feeReceiver = config.get('fee.b2b_receiver');
347         }
348         if(accounts.isPremium(_from)){
349             feeSender = 0;
350         }
351         if(accounts.isPremium(_to)){
352             feeReceiver = 0;
353         }
354         if(accounts.isSystem(_from) || accounts.isSystem(_to)){
355             feeSender = 0;
356             feeReceiver = 0;
357         }
358 
359         address feeCollector = address(config.get('fee.collector'));
360         address feeSpender = _from;
361         uint256 feeValue = 0;
362         if(feeSender > 0){
363             feeValue = _value.mul(feeSender).div(10000);
364             if(feeValue > 0) {
365                 _transfer(feeSpender, feeCollector, feeValue);
366                 master.emitTransfer(feeSpender, feeCollector, feeValue);
367             }
368         }
369         if(feeReceiver > 0){
370             feeValue = _value.mul(feeReceiver).div(10000);
371             if(feeValue > 0) {
372                 _value = _value.sub(feeValue);
373                 feeSpender = _to;
374                 _transfer(feeSpender, feeCollector, feeValue);
375                 master.emitTransfer(feeSpender, feeCollector, feeValue);
376             }
377         }
378         return _value;
379     }
380 
381     function _topup(address payable _address) internal {
382         uint256 topupEnabled = config.get('eth.topup');
383         if(topupEnabled > 0){
384             uint256 minBalance = config.get('eth.minBalance') * 1 finney;
385             if(address(this).balance > minBalance){
386                 if(_address.balance < minBalance){
387                     _address.transfer(minBalance.sub(_address.balance));
388                 }
389             }
390         }
391     }
392 
393     function _issue(address payable _to, uint256 _value) internal returns (bool) {
394         accounts.addTo(_to, _value);
395         accounts.addTotalSupply(_value);
396         master.emitTransfer(address(0x0), _to, _value);
397         _topup(_to);
398         return true;
399     }
400 
401     /**
402      * OWNER METHODS
403      */
404     function issue(address payable _to, uint256 _value) public onlyOwner returns (bool) {
405         return _issue(_to, _value);
406     }
407 
408     function burn(address _from, uint256 _value) public onlyOwner returns (bool) {
409         accounts.subFrom(_from, _value);
410         accounts.subTotalSupply(_value);
411         // todo: emitBurn
412         return true;
413     }
414 
415     function ownerTransferFrom(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
416         accounts.addTo(_to, _value);
417         accounts.subFrom(_from, _value);
418         master.emitTransfer(_from, _to, _value);
419         return true;
420     }
421 }
422 
423 contract SunRich is ERC20, Ownable {
424     string public constant version = "0.4";
425     string public name = "Sunrich (RUB)";
426     string public symbol = "SRT(R)";
427     uint256 public constant decimals = 2;
428 
429     SunRichController public ctrl;
430 
431     modifier onlyController {
432         require(msg.sender == address(ctrl));
433         _;
434     }
435 
436     constructor() public {
437     }
438 
439     function updateName(string memory _name) public onlyOwner {
440         name = _name;
441     }
442     
443     function updateSymbol(string memory _symbol) public onlyOwner {
444         symbol = _symbol;
445     }
446 
447     function setController(address payable _ctrl) public onlyOwner {
448         ctrl = SunRichController(_ctrl);
449     }
450 
451     function totalSupply() public view returns (uint256) {
452         return ctrl.totalSupply();
453     }
454 
455     function balanceOf(address _who) public view returns (uint256) {
456         return ctrl.balanceOf(_who);
457     }
458 
459     function transfer(address payable _to, uint256 _value) public returns (bool) {
460         return ctrl.transferWithSender(msg.sender, _to, _value);
461     }
462 
463     function allowance(address _owner, address _spender) public view returns (uint256) {
464         return ctrl.allowance(_owner, _spender);
465     }
466 
467     function transferFrom(address payable _from, address payable _to, uint256 _value) public returns (bool) {
468         return ctrl.transferFrom(_from, _to, _value);
469     }
470 
471     function approve(address _spender, uint256 _value) public returns (bool) {
472         return ctrl.approve(msg.sender, _spender, _value);
473     }
474 
475     function emitTransfer(address _from, address _to, uint256 _value) public onlyController {
476         emit Transfer(_from, _to, _value);
477     }
478 
479     function emitApproval(address _owner, address _spender, uint256 _value) public onlyController {
480         emit Approval(_owner, _spender, _value);
481     }
482 
483     function setBusinessAccount(address _owner, bool _value) public {
484         ctrl.setBusinessAccount(msg.sender, _owner, _value);
485     }
486 }