1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16 
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     return a / b;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   uint256 totalSupply_;
44 
45   function totalSupply() public view returns (uint256) {
46     return totalSupply_;
47   }
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     emit Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) public view returns (uint256) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender)
66     public view returns (uint256);
67 
68   function transferFrom(address from, address to, uint256 value)
69     public returns (bool);
70 
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(
73     address indexed owner,
74     address indexed spender,
75     uint256 value
76   );
77 }
78 
79 contract StandardToken is ERC20, BasicToken {
80 
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83   function transferFrom(
84     address _from,
85     address _to,
86     uint256 _value
87   )
88     public
89     returns (bool)
90   {
91     require(_to != address(0));
92     require(_value <= balances[_from]);
93     require(_value <= allowed[_from][msg.sender]);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     emit Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     emit Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(
109     address _owner,
110     address _spender
111    )
112     public
113     view
114     returns (uint256)
115   {
116     return allowed[_owner][_spender];
117   }
118 
119   function increaseApproval(
120     address _spender,
121     uint _addedValue
122   )
123     public
124     returns (bool)
125   {
126     allowed[msg.sender][_spender] = (
127       allowed[msg.sender][_spender].add(_addedValue));
128     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129     return true;
130   }
131 
132   function decreaseApproval(
133     address _spender,
134     uint _subtractedValue
135   )
136     public
137     returns (bool)
138   {
139     uint oldValue = allowed[msg.sender][_spender];
140     if (_subtractedValue > oldValue) {
141       allowed[msg.sender][_spender] = 0;
142     } else {
143       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144     }
145     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149 }
150 
151 contract Ownable {
152   address public owner;
153 
154   event OwnershipRenounced(address indexed previousOwner);
155   event OwnershipTransferred(
156     address indexed previousOwner,
157     address indexed newOwner
158   );
159 
160   constructor() public {
161     owner = msg.sender;
162   }
163 
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   function renounceOwnership() public onlyOwner {
170     emit OwnershipRenounced(owner);
171     owner = address(0);
172   }
173 
174   function transferOwnership(address _newOwner) public onlyOwner {
175     _transferOwnership(_newOwner);
176   }
177 
178   function _transferOwnership(address _newOwner) internal {
179     require(_newOwner != address(0));
180     emit OwnershipTransferred(owner, _newOwner);
181     owner = _newOwner;
182   }
183 }
184 
185 contract MintableToken is StandardToken, Ownable {
186   event Mint(address indexed to, uint256 amount);
187   event MintFinished();
188 
189   bool public mintingFinished = false;
190 
191   modifier canMint() {
192     require(!mintingFinished);
193     _;
194   }
195 
196   modifier hasMintPermission() {
197     require(msg.sender == owner);
198     _;
199   }
200 
201   function mint(
202     address _to,
203     uint256 _amount
204   )
205     hasMintPermission
206     canMint
207     public
208     returns (bool)
209   {
210     totalSupply_ = totalSupply_.add(_amount);
211     balances[_to] = balances[_to].add(_amount);
212     emit Mint(_to, _amount);
213     emit Transfer(address(0), _to, _amount);
214     return true;
215   }
216 
217   function finishMinting() onlyOwner canMint public returns (bool) {
218     mintingFinished = true;
219     emit MintFinished();
220     return true;
221   }
222 }
223 
224 
225 contract FreezableToken is StandardToken {
226 
227     mapping (bytes32 => uint64) internal chains;
228     mapping (bytes32 => uint) internal freezings;
229     mapping (address => uint) internal freezingBalance;
230 
231     event Freezed(address indexed to, uint64 release, uint amount);
232     event Released(address indexed owner, uint amount);
233 
234     function balanceOf(address _owner) public view returns (uint256 balance) {
235         return super.balanceOf(_owner) + freezingBalance[_owner];
236     }
237 
238     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
239         return super.balanceOf(_owner);
240     }
241 
242     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
243         return freezingBalance[_owner];
244     }
245 
246     function freezingCount(address _addr) public view returns (uint count) {
247         uint64 release = chains[toKey(_addr, 0)];
248         while (release != 0) {
249             count++;
250             release = chains[toKey(_addr, release)];
251         }
252     }
253 
254     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
255         for (uint i = 0; i < _index + 1; i++) {
256             _release = chains[toKey(_addr, _release)];
257             if (_release == 0) {
258                 return;
259             }
260         }
261         _balance = freezings[toKey(_addr, _release)];
262     }
263 
264     function freezeTo(address _to, uint _amount, uint64 _until) public {
265         require(_to != address(0));
266         require(_amount <= balances[msg.sender]);
267 
268         balances[msg.sender] = balances[msg.sender].sub(_amount);
269 
270         bytes32 currentKey = toKey(_to, _until);
271         freezings[currentKey] = freezings[currentKey].add(_amount);
272         freezingBalance[_to] = freezingBalance[_to].add(_amount);
273 
274         freeze(_to, _until);
275         emit Transfer(msg.sender, _to, _amount);
276         emit Freezed(_to, _until, _amount);
277     }
278 
279     function releaseOnce() public {
280         bytes32 headKey = toKey(msg.sender, 0);
281         uint64 head = chains[headKey];
282         require(head != 0);
283         require(uint64(block.timestamp) > head);
284         bytes32 currentKey = toKey(msg.sender, head);
285 
286         uint64 next = chains[currentKey];
287 
288         uint amount = freezings[currentKey];
289         delete freezings[currentKey];
290 
291         balances[msg.sender] = balances[msg.sender].add(amount);
292         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
293 
294         if (next == 0) {
295             delete chains[headKey];
296         } else {
297             chains[headKey] = next;
298             delete chains[currentKey];
299         }
300         emit Released(msg.sender, amount);
301     }
302 
303     function releaseAll() public returns (uint tokens) {
304         uint release;
305         uint balance;
306         (release, balance) = getFreezing(msg.sender, 0);
307         while (release != 0 && block.timestamp > release) {
308             releaseOnce();
309             tokens += balance;
310             (release, balance) = getFreezing(msg.sender, 0);
311         }
312     }
313 
314     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
315         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
316         assembly {
317             result := or(result, mul(_addr, 0x10000000000000000))
318             result := or(result, _release)
319         }
320     }
321 
322     function freeze(address _to, uint64 _until) internal {
323         require(_until > block.timestamp);
324         bytes32 key = toKey(_to, _until);
325         bytes32 parentKey = toKey(_to, uint64(0));
326         uint64 next = chains[parentKey];
327 
328         if (next == 0) {
329             chains[parentKey] = _until;
330             return;
331         }
332 
333         bytes32 nextKey = toKey(_to, next);
334         uint parent;
335 
336         while (next != 0 && _until > next) {
337             parent = next;
338             parentKey = nextKey;
339 
340             next = chains[nextKey];
341             nextKey = toKey(_to, next);
342         }
343 
344         if (_until == next) {
345             return;
346         }
347 
348         if (next != 0) {
349             chains[key] = next;
350         }
351 
352         chains[parentKey] = _until;
353     }
354 }
355 
356 contract BurnableToken is BasicToken {
357 
358   event Burn(address indexed burner, uint256 value);
359 
360   function burn(uint256 _value) public {
361     _burn(msg.sender, _value);
362   }
363 
364   function _burn(address _who, uint256 _value) internal {
365     require(_value <= balances[_who]);
366 
367     balances[_who] = balances[_who].sub(_value);
368     totalSupply_ = totalSupply_.sub(_value);
369     emit Burn(_who, _value);
370     emit Transfer(_who, address(0), _value);
371   }
372 }
373 
374 contract Pausable is Ownable {
375   event Pause();
376   event Unpause();
377 
378   bool public paused = false;
379 
380   modifier whenNotPaused() {
381     require(!paused);
382     _;
383   }
384 
385   modifier whenPaused() {
386     require(paused);
387     _;
388   }
389 
390   function pause() onlyOwner whenNotPaused public {
391     paused = true;
392     emit Pause();
393   }
394 
395   function unpause() onlyOwner whenPaused public {
396     paused = false;
397     emit Unpause();
398   }
399 }
400 
401 
402 contract FreezableMintableToken is FreezableToken, MintableToken {
403 
404     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
405         totalSupply_ = totalSupply_.add(_amount);
406 
407         bytes32 currentKey = toKey(_to, _until);
408         freezings[currentKey] = freezings[currentKey].add(_amount);
409         freezingBalance[_to] = freezingBalance[_to].add(_amount);
410 
411         freeze(_to, _until);
412         emit Mint(_to, _amount);
413         emit Freezed(_to, _until, _amount);
414         emit Transfer(msg.sender, _to, _amount);
415         return true;
416     }
417 }
418 
419 
420 contract Consts {
421     uint public constant TOKEN_DECIMALS = 3;
422     uint8 public constant TOKEN_DECIMALS_UINT8 = 3;
423     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
424 
425     string public constant TOKEN_NAME = "Abri";
426     string public constant TOKEN_SYMBOL = "ABR";
427     bool public constant PAUSED = false;
428     address public constant TARGET_USER = 0x505c7f3B5fC1D6cD286425BA9460A0Bf0C605fD8;
429     
430     bool public constant CONTINUE_MINTING = false;
431 }
432 
433 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable    
434 {  
435     event Initialized();
436     bool public initialized = false;
437 
438     constructor() public {
439         init();
440         transferOwnership(TARGET_USER);
441     }
442     
443     function name() public pure returns (string _name) {
444         return TOKEN_NAME;
445     }
446 
447     function symbol() public pure returns (string _symbol) {
448         return TOKEN_SYMBOL;
449     }
450 
451     function decimals() public pure returns (uint8 _decimals) {
452         return TOKEN_DECIMALS_UINT8;
453     }
454 
455     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
456         require(!paused);
457         return super.transferFrom(_from, _to, _value);
458     }
459 
460     function transfer(address _to, uint256 _value) public returns (bool _success) {
461         require(!paused);
462         return super.transfer(_to, _value);
463     }
464 
465     
466     function init() private {
467         require(!initialized);
468         initialized = true;
469 
470         if (PAUSED) {
471             pause();
472         }
473 
474         
475         address[1] memory addresses = [address(0x505c7f3B5fC1D6cD286425BA9460A0Bf0C605fD8)];
476         uint[1] memory amounts = [uint(200000000000)];
477         uint64[1] memory freezes = [uint64(0)];
478 
479         for (uint i = 0; i < addresses.length; i++) {
480             if (freezes[i] == 0) {
481                 mint(addresses[i], amounts[i]);
482             } else {
483                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
484             }
485         }
486         
487 
488         if (!CONTINUE_MINTING) {
489             finishMinting();
490         }
491 
492         emit Initialized();
493     }
494     
495 }