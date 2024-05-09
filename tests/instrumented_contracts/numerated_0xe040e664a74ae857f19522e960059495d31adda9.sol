1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address _new_owner) onlyOwner public returns (bool _success) {
44         require(_new_owner != address(0));
45 
46         owner = _new_owner;
47 
48         emit OwnershipTransferred(owner, _new_owner);
49 
50         return true;
51     }
52 }
53 
54 contract Pausable is Ownable {
55     bool public paused = false;
56 
57     modifier whenNotPaused() {
58         require(!paused);
59         _;
60     }
61 
62     function setPauseStatus(bool _pause) onlyOwner public returns (bool _success) {
63         paused = _pause;
64         return true;
65     }
66 }
67 
68 contract ERC223 {
69     uint public totalSupply;
70     function balanceOf(address who) public view returns (uint);
71     function transfer(address to, uint value) public returns (bool _success);
72     function transfer(address to, uint value, bytes data) public returns (bool _success);
73     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
74 
75     function totalSupply() public view returns (uint256 _totalSupply);
76     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool _success);
77 
78     function name() public view returns (string _name);
79     function symbol() public view returns (string _symbol);
80     function decimals() public view returns (uint8 _decimals);
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success);
83     function approve(address _spender, uint256 _value) public returns (bool _success);
84     function allowance(address _owner, address _spender) public view returns (uint256 _remaining);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 contract ContractReceiver {
91     struct TKN {
92         address sender;
93         uint value;
94         bytes data;
95         bytes4 sig;
96     }
97 
98     function tokenFallback(address _from, uint _value, bytes _data) public pure {
99         TKN memory tkn;
100         tkn.sender = _from;
101         tkn.value = _value;
102         tkn.data = _data;
103         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
104         tkn.sig = bytes4(u);
105     }
106 }
107 
108 contract ASTERISK is ERC223, Pausable {
109     using SafeMath for uint256;
110 
111     string public name = "asterisk";
112     string public symbol = "ASTER";
113     uint8 public decimals = 9;
114     uint256 public totalSupply = 10e9 * 1e9;
115 
116     mapping(address => uint256) public balanceOf;
117     mapping(address => mapping(address => uint256)) public allowance;
118     mapping(address => bool) public frozenAccount;
119 
120     event Freeze(address indexed target, uint256 value);
121     event Unfreeze(address indexed target, uint256 value);
122     event Burn(address indexed from, uint256 amount);
123     event Rain(address indexed from, uint256 amount);
124 
125 
126     struct ITEM {
127         uint256 id;
128         address owner;
129         mapping(address => uint256) holders;
130         string name;
131         uint256 price;
132         uint256 itemTotalSupply;
133         bool transferable;
134         bool approveForAll;
135         string option;
136         uint256 limitHolding;
137     }
138 
139     struct ALLOWANCEITEM {
140         uint256 amount;
141         uint256 price;
142     }
143 
144     mapping(uint256 => ITEM) public items;
145 
146     uint256 public itemId = 1;
147 
148     mapping(address => mapping(address => mapping(uint256 => ALLOWANCEITEM))) public allowanceItems;
149 
150     constructor() public {
151         owner = msg.sender;
152         balanceOf[msg.sender] = totalSupply;
153     }
154 
155     modifier messageSenderNotFrozen() {
156         require(frozenAccount[msg.sender] == false);
157         _;
158     }
159 
160     function balanceOf(address _owner) public view returns (uint256 _balance) {
161         return balanceOf[_owner];
162     }
163 
164     function totalSupply() public view returns (uint256 _totalSupply) {
165         return totalSupply;
166     }
167 
168     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) messageSenderNotFrozen whenNotPaused public returns (bool _success) {
169         require(_value > 0 && frozenAccount[_to] == false);
170 
171         if (isContract(_to)) {
172             require(balanceOf[msg.sender] >= _value);
173 
174             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
175             balanceOf[_to] = balanceOf[_to].add(_value);
176 
177             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
178 
179             emit Transfer(msg.sender, _to, _value, _data);
180             emit Transfer(msg.sender, _to, _value);
181 
182             return true;
183         } else {
184             return transferToAddress(_to, _value, _data);
185         }
186     }
187 
188     function transfer(address _to, uint _value, bytes _data) messageSenderNotFrozen whenNotPaused public returns (bool _success) {
189         require(_value > 0 && frozenAccount[_to] == false);
190 
191         if (isContract(_to)) {
192             return transferToContract(_to, _value, _data);
193         } else {
194             return transferToAddress(_to, _value, _data);
195         }
196     }
197 
198     function transfer(address _to, uint _value) messageSenderNotFrozen whenNotPaused public returns (bool _success) {
199         require(_value > 0 && frozenAccount[_to] == false);
200 
201         bytes memory empty;
202 
203         if (isContract(_to)) {
204             return transferToContract(_to, _value, empty);
205         } else {
206             return transferToAddress(_to, _value, empty);
207         }
208     }
209 
210     function name() public view returns (string _name) {
211         return name;
212     }
213 
214     function symbol() public view returns (string _symbol) {
215         return symbol;
216     }
217 
218     function decimals() public view returns (uint8 _decimals) {
219         return decimals;
220     }
221 
222     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool _success) {
223         require(_to != address(0)
224             && _value > 0
225             && balanceOf[_from] >= _value
226             && allowance[_from][msg.sender] >= _value
227             && frozenAccount[_from] == false && frozenAccount[_to] == false);
228 
229         balanceOf[_from] = balanceOf[_from].sub(_value);
230         balanceOf[_to] = balanceOf[_to].add(_value);
231         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
232 
233         emit Transfer(_from, _to, _value);
234 
235         return true;
236     }
237 
238     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool _success) {
239         allowance[msg.sender][_spender] = _value;
240 
241         emit Approval(msg.sender, _spender, _value);
242 
243         return true;
244     }
245 
246     function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {
247         return allowance[_owner][_spender];
248     }
249 
250     function freezeAccounts(address[] _targets) onlyOwner whenNotPaused public returns (bool _success) {
251         require(_targets.length > 0);
252 
253         for (uint j = 0; j < _targets.length; j++) {
254             require(_targets[j] != 0x0);
255 
256             frozenAccount[_targets[j]] = true;
257 
258             emit Freeze(_targets[j], balanceOf[_targets[j]]);
259         }
260         return true;
261     }
262 
263     function unfreezeAccounts(address[] _targets) onlyOwner whenNotPaused public returns (bool _success) {
264         require(_targets.length > 0);
265 
266         for (uint j = 0; j < _targets.length; j++) {
267             require(_targets[j] != 0x0);
268 
269             frozenAccount[_targets[j]] = false;
270 
271             emit Unfreeze(_targets[j], balanceOf[_targets[j]]);
272         }
273         return true;
274     }
275 
276     function isFrozenAccount(address _target) public view returns (bool _is_frozen){
277         return frozenAccount[_target] == true;
278     }
279 
280     function isContract(address _target) private view returns (bool _is_contract) {
281         uint length;
282         assembly {
283             length := extcodesize(_target)
284         }
285         return (length > 0);
286     }
287 
288     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool _success) {
289         require(balanceOf[msg.sender] >= _value);
290 
291         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
292         balanceOf[_to] = balanceOf[_to].add(_value);
293 
294         emit Transfer(msg.sender, _to, _value, _data);
295         emit Transfer(msg.sender, _to, _value);
296 
297         return true;
298     }
299 
300     function transferToContract(address _to, uint _value, bytes _data) private returns (bool _success) {
301         require(balanceOf[msg.sender] >= _value);
302 
303         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
304         balanceOf[_to] = balanceOf[_to].add(_value);
305         ContractReceiver receiver = ContractReceiver(_to);
306         receiver.tokenFallback(msg.sender, _value, _data);
307 
308         emit Transfer(msg.sender, _to, _value, _data);
309         emit Transfer(msg.sender, _to, _value);
310 
311         return true;
312     }
313 
314     function burn(address _from, uint256 _amount) onlyOwner whenNotPaused public returns (bool _success) {
315         require(_amount > 0 && balanceOf[_from] >= _amount);
316 
317         balanceOf[_from] = balanceOf[_from].sub(_amount);
318         totalSupply = totalSupply.sub(_amount);
319 
320         emit Burn(_from, _amount);
321 
322         return true;
323     }
324 
325     function rain(address[] _addresses, uint256 _amount) messageSenderNotFrozen whenNotPaused public returns (bool _success) {
326         require(_amount > 0 && _addresses.length > 0);
327 
328         uint256 totalAmount = _amount.mul(_addresses.length);
329 
330         require(balanceOf[msg.sender] >= totalAmount);
331 
332         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
333 
334         for (uint j = 0; j < _addresses.length; j++) {
335             require(_addresses[j] != address(0));
336 
337             balanceOf[_addresses[j]] = balanceOf[_addresses[j]].add(_amount);
338 
339             emit Transfer(msg.sender, _addresses[j], _amount);
340         }
341 
342         emit Rain(msg.sender, totalAmount);
343         return true;
344     }
345 
346     function collectTokens(address[] _addresses, uint[] _amounts) onlyOwner whenNotPaused public returns (bool _success) {
347         require(_addresses.length > 0 && _amounts.length > 0
348             && _addresses.length == _amounts.length);
349 
350         uint256 totalAmount = 0;
351 
352         for (uint j = 0; j < _addresses.length; j++) {
353             require(_amounts[j] > 0 && _addresses[j] != address(0)
354                 && balanceOf[_addresses[j]] >= _amounts[j]);
355 
356             balanceOf[_addresses[j]] = balanceOf[_addresses[j]].sub(_amounts[j]);
357             totalAmount = totalAmount.add(_amounts[j]);
358 
359             emit Transfer(_addresses[j], msg.sender, _amounts[j]);
360         }
361 
362         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
363         return true;
364     }
365 
366 
367     function createItemId() whenNotPaused private returns (uint256 _id) {
368         return itemId++;
369     }
370 
371 
372 
373     function createItem(string _name, uint256 _initial_amount, uint256 _price, bool _transferable, bool _approve_for_all, string _option, uint256 _limit_holding) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (uint256 _id) {
374         uint256 item_id = createItemId();
375         ITEM memory i;
376         i.id = item_id;
377         i.owner = msg.sender;
378         i.name = _name;
379         i.price = _price;
380         i.itemTotalSupply = _initial_amount;
381         i.transferable = _transferable;
382         i.approveForAll = _approve_for_all;
383         i.option = _option;
384         i.limitHolding = _limit_holding;
385         items[item_id] = i;
386         items[item_id].holders[msg.sender] = _initial_amount;
387         return i.id;
388     }
389 
390 
391     function getItemAmountOf(uint256 _id, address _holder) whenNotItemStopped whenNotPaused public view returns (uint256 _amount) {
392         return items[_id].holders[_holder];
393     }
394 
395 
396     function setItemOption(uint256 _id, string _option) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
397         require(items[_id].owner == msg.sender);
398 
399         items[_id].option = _option;
400 
401         return true;
402     }
403 
404     function setItemApproveForAll(uint256 _id, bool _approve_for_all) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
405         require(items[_id].owner == msg.sender);
406 
407         items[_id].approveForAll = _approve_for_all;
408 
409         return true;
410     }
411 
412     function setItemTransferable(uint256 _id, bool _transferable) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
413         require(items[_id].owner == msg.sender);
414 
415         items[_id].transferable = _transferable;
416 
417         return true;
418     }
419 
420     function setItemPrice(uint256 _id, uint256 _price) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
421         require(items[_id].owner == msg.sender && _price >= 0);
422 
423         items[_id].price = _price;
424 
425         return true;
426     }
427 
428     function setItemLimitHolding(uint256 _id, uint256 _limit) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
429         require(items[_id].owner == msg.sender && _limit > 0);
430 
431         items[_id].limitHolding = _limit;
432 
433         return true;
434     }
435 
436     function buyItem(uint256 _id, uint256 _amount) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
437         require(items[_id].approveForAll
438             && _amount > 0
439             && items[_id].holders[items[_id].owner] >= _amount);
440 
441         uint256 afterAmount = items[_id].holders[msg.sender].add(_amount);
442 
443         require(items[_id].limitHolding >= afterAmount);
444 
445         uint256 value = items[_id].price.mul(_amount);
446 
447         require(balanceOf[msg.sender] >= value);
448 
449         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
450         items[_id].holders[items[_id].owner] = items[_id].holders[items[_id].owner].sub(_amount);
451         items[_id].holders[msg.sender] = items[_id].holders[msg.sender].add(_amount);
452         balanceOf[items[_id].owner] = balanceOf[items[_id].owner].add(value);
453 
454         return true;
455     }
456 
457     function allowanceItem(uint256 _id, uint256 _amount, uint256 _price, address _to) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
458         require(_amount > 0 && _price >= 0
459             && _to != address(0)
460             && items[_id].holders[msg.sender] >= _amount
461             && items[_id].transferable);
462 
463         ALLOWANCEITEM memory a;
464         a.price = _price;
465         a.amount = _amount;
466         allowanceItems[msg.sender][_to][_id] = a;
467 
468         return true;
469     }
470 
471     function getItemAllowanceAmount(uint256 _id, address _from, address _to) whenNotItemStopped whenNotPaused public view returns (uint256 _amount) {
472         return allowanceItems[_from][_to][_id].amount;
473     }
474 
475     function getItemAllowancePrice(uint256 _id, address _from, address _to) whenNotItemStopped whenNotPaused public view returns (uint256 _price) {
476         return allowanceItems[_from][_to][_id].price;
477     }
478 
479     function transferItemFrom(uint256 _id, address _from, uint256 _amount, uint256 _price) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
480         require(_amount > 0 && _price >= 0 && frozenAccount[_from] == false);
481 
482         uint256 value = _amount.mul(_price);
483 
484         require(allowanceItems[_from][msg.sender][_id].amount >= _amount
485             && allowanceItems[_from][msg.sender][_id].price >= _price
486             && balanceOf[msg.sender] >= value
487             && items[_id].holders[_from] >= _amount
488             && items[_id].transferable);
489 
490         uint256 afterAmount = items[_id].holders[msg.sender].add(_amount);
491 
492         require(items[_id].limitHolding >= afterAmount);
493 
494         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
495         allowanceItems[_from][msg.sender][_id].amount = allowanceItems[_from][msg.sender][_id].amount.sub(_amount);
496         items[_id].holders[_from] = items[_id].holders[_from].sub(_amount);
497         items[_id].holders[msg.sender] = items[_id].holders[msg.sender].add(_amount);
498         balanceOf[_from] = balanceOf[_from].add(value);
499 
500         return true;
501     }
502 
503     function transferItem(uint256 _id, address _to, uint256 _amount) messageSenderNotFrozen whenNotItemStopped whenNotPaused public returns (bool _success) {
504         require(frozenAccount[_to] == false && _to != address(0)
505             && _amount > 0 && items[_id].holders[msg.sender] >= _amount
506             && items[_id].transferable);
507 
508         uint256 afterAmount = items[_id].holders[_to].add(_amount);
509 
510         require(items[_id].limitHolding >= afterAmount);
511 
512         items[_id].holders[msg.sender] = items[_id].holders[msg.sender].sub(_amount);
513         items[_id].holders[_to] = items[_id].holders[_to].add(_amount);
514 
515         return true;
516     }
517 
518 
519     bool public isItemStopped = false;
520 
521     modifier whenNotItemStopped() {
522         require(!isItemStopped);
523         _;
524     }
525 
526     function setItemStoppedStatus(bool _status) onlyOwner whenNotPaused public returns (bool _success) {
527         isItemStopped = _status;
528         return true;
529     }
530 
531     function() payable public {}
532 }