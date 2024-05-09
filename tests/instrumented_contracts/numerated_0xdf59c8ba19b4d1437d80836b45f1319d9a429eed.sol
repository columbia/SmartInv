1 /*
2  * IZIChain (https://izichain.network/)
3  * Copyright (C) 2018 HVA
4  */
5 pragma solidity ^0.4.23;
6 
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 library SafeMath {
15 
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     return a / b;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   uint256 totalSupply_;
48 
49   function totalSupply() public view returns (uint256) {
50     return totalSupply_;
51   }
52 
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(address _owner) public view returns (uint256) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender)
70     public view returns (uint256);
71 
72   function transferFrom(address from, address to, uint256 value)
73     public returns (bool);
74 
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(
77     address indexed owner,
78     address indexed spender,
79     uint256 value
80   );
81 }
82 
83 contract StandardToken is ERC20, BasicToken {
84 
85   mapping (address => mapping (address => uint256)) internal allowed;
86 
87   function transferFrom(
88     address _from,
89     address _to,
90     uint256 _value
91   )
92     public
93     returns (bool)
94   {
95     require(_to != address(0));
96     require(_value <= balances[_from]);
97     require(_value <= allowed[_from][msg.sender]);
98 
99     balances[_from] = balances[_from].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
102     emit Transfer(_from, _to, _value);
103     return true;
104   }
105 
106   function approve(address _spender, uint256 _value) public returns (bool) {
107     allowed[msg.sender][_spender] = _value;
108     emit Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   function allowance(
113     address _owner,
114     address _spender
115    )
116     public
117     view
118     returns (uint256)
119   {
120     return allowed[_owner][_spender];
121   }
122 
123   function increaseApproval(
124     address _spender,
125     uint _addedValue
126   )
127     public
128     returns (bool)
129   {
130     allowed[msg.sender][_spender] = (
131       allowed[msg.sender][_spender].add(_addedValue));
132     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval(
137     address _spender,
138     uint _subtractedValue
139   )
140     public
141     returns (bool)
142   {
143     uint oldValue = allowed[msg.sender][_spender];
144     if (_subtractedValue > oldValue) {
145       allowed[msg.sender][_spender] = 0;
146     } else {
147       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148     }
149     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153 }
154 
155 contract Ownable {
156   address public owner;
157 
158   event OwnershipRenounced(address indexed previousOwner);
159   event OwnershipTransferred(
160     address indexed previousOwner,
161     address indexed newOwner
162   );
163 
164   constructor() public {
165     owner = msg.sender;
166   }
167 
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173   function renounceOwnership() public onlyOwner {
174     emit OwnershipRenounced(owner);
175     owner = address(0);
176   }
177 
178   function transferOwnership(address _newOwner) public onlyOwner {
179     _transferOwnership(_newOwner);
180   }
181 
182   function _transferOwnership(address _newOwner) internal {
183     require(_newOwner != address(0));
184     emit OwnershipTransferred(owner, _newOwner);
185     owner = _newOwner;
186   }
187 }
188 
189 contract MintableToken is StandardToken, Ownable {
190   event Mint(address indexed to, uint256 amount);
191   event MintFinished();
192 
193   bool public mintingFinished = false;
194 
195   modifier canMint() {
196     require(!mintingFinished);
197     _;
198   }
199 
200   modifier hasMintPermission() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205   function mint(
206     address _to,
207     uint256 _amount
208   )
209     hasMintPermission
210     canMint
211     public
212     returns (bool)
213   {
214     totalSupply_ = totalSupply_.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     emit Mint(_to, _amount);
217     emit Transfer(address(0), _to, _amount);
218     return true;
219   }
220 
221   function finishMinting() onlyOwner canMint public returns (bool) {
222     mintingFinished = true;
223     emit MintFinished();
224     return true;
225   }
226 }
227 
228 
229 contract FreezableToken is StandardToken {
230 
231     mapping (bytes32 => uint64) internal chains;
232     mapping (bytes32 => uint) internal freezings;
233     mapping (address => uint) internal freezingBalance;
234 
235     event Freezed(address indexed to, uint64 release, uint amount);
236     event Released(address indexed owner, uint amount);
237 
238     function balanceOf(address _owner) public view returns (uint256 balance) {
239         return super.balanceOf(_owner) + freezingBalance[_owner];
240     }
241 
242     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
243         return super.balanceOf(_owner);
244     }
245 
246     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
247         return freezingBalance[_owner];
248     }
249 
250     function freezingCount(address _addr) public view returns (uint count) {
251         uint64 release = chains[toKey(_addr, 0)];
252         while (release != 0) {
253             count++;
254             release = chains[toKey(_addr, release)];
255         }
256     }
257 
258     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
259         for (uint i = 0; i < _index + 1; i++) {
260             _release = chains[toKey(_addr, _release)];
261             if (_release == 0) {
262                 return;
263             }
264         }
265         _balance = freezings[toKey(_addr, _release)];
266     }
267 
268     function freezeTo(address _to, uint _amount, uint64 _until) public {
269         require(_to != address(0));
270         require(_amount <= balances[msg.sender]);
271 
272         balances[msg.sender] = balances[msg.sender].sub(_amount);
273 
274         bytes32 currentKey = toKey(_to, _until);
275         freezings[currentKey] = freezings[currentKey].add(_amount);
276         freezingBalance[_to] = freezingBalance[_to].add(_amount);
277 
278         freeze(_to, _until);
279         emit Transfer(msg.sender, _to, _amount);
280         emit Freezed(_to, _until, _amount);
281     }
282 
283     function releaseOnce() public {
284         bytes32 headKey = toKey(msg.sender, 0);
285         uint64 head = chains[headKey];
286         require(head != 0);
287         require(uint64(block.timestamp) > head);
288         bytes32 currentKey = toKey(msg.sender, head);
289 
290         uint64 next = chains[currentKey];
291 
292         uint amount = freezings[currentKey];
293         delete freezings[currentKey];
294 
295         balances[msg.sender] = balances[msg.sender].add(amount);
296         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
297 
298         if (next == 0) {
299             delete chains[headKey];
300         } else {
301             chains[headKey] = next;
302             delete chains[currentKey];
303         }
304         emit Released(msg.sender, amount);
305     }
306 
307     function releaseAll() public returns (uint tokens) {
308         uint release;
309         uint balance;
310         (release, balance) = getFreezing(msg.sender, 0);
311         while (release != 0 && block.timestamp > release) {
312             releaseOnce();
313             tokens += balance;
314             (release, balance) = getFreezing(msg.sender, 0);
315         }
316     }
317 
318     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
319         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
320         assembly {
321             result := or(result, mul(_addr, 0x10000000000000000))
322             result := or(result, _release)
323         }
324     }
325 
326     function freeze(address _to, uint64 _until) internal {
327         require(_until > block.timestamp);
328         bytes32 key = toKey(_to, _until);
329         bytes32 parentKey = toKey(_to, uint64(0));
330         uint64 next = chains[parentKey];
331 
332         if (next == 0) {
333             chains[parentKey] = _until;
334             return;
335         }
336 
337         bytes32 nextKey = toKey(_to, next);
338         uint parent;
339 
340         while (next != 0 && _until > next) {
341             parent = next;
342             parentKey = nextKey;
343 
344             next = chains[nextKey];
345             nextKey = toKey(_to, next);
346         }
347 
348         if (_until == next) {
349             return;
350         }
351 
352         if (next != 0) {
353             chains[key] = next;
354         }
355 
356         chains[parentKey] = _until;
357     }
358 }
359 
360 contract BurnableToken is BasicToken {
361 
362   event Burn(address indexed burner, uint256 value);
363 
364   function burn(uint256 _value) public {
365     _burn(msg.sender, _value);
366   }
367 
368   function _burn(address _who, uint256 _value) internal {
369     require(_value <= balances[_who]);
370 
371     balances[_who] = balances[_who].sub(_value);
372     totalSupply_ = totalSupply_.sub(_value);
373     emit Burn(_who, _value);
374     emit Transfer(_who, address(0), _value);
375   }
376 }
377 
378 contract Pausable is Ownable {
379   event Pause();
380   event Unpause();
381 
382   bool public paused = false;
383 
384   modifier whenNotPaused() {
385     require(!paused);
386     _;
387   }
388 
389   modifier whenPaused() {
390     require(paused);
391     _;
392   }
393 
394   function pause() onlyOwner whenNotPaused public {
395     paused = true;
396     emit Pause();
397   }
398 
399   function unpause() onlyOwner whenPaused public {
400     paused = false;
401     emit Unpause();
402   }
403 }
404 
405 
406 contract FreezableMintableToken is FreezableToken, MintableToken {
407 
408     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
409         totalSupply_ = totalSupply_.add(_amount);
410 
411         bytes32 currentKey = toKey(_to, _until);
412         freezings[currentKey] = freezings[currentKey].add(_amount);
413         freezingBalance[_to] = freezingBalance[_to].add(_amount);
414 
415         freeze(_to, _until);
416         emit Mint(_to, _amount);
417         emit Freezed(_to, _until, _amount);
418         emit Transfer(msg.sender, _to, _amount);
419         return true;
420     }
421 }
422 
423 
424 contract Consts {
425     uint public constant TOKEN_DECIMALS = 4;
426     uint8 public constant TOKEN_DECIMALS_UINT8 = 4;
427     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
428 
429     string public constant TOKEN_NAME = "IZIChain";
430     string public constant TOKEN_SYMBOL = "IZI";
431     bool public constant PAUSED = false;
432     address public constant TARGET_USER = 0x61cce7ffbfd929628020470070382fe3de3d7f1a;
433     
434     bool public constant CONTINUE_MINTING = false;
435 }
436 
437 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable    
438 {  
439     event Initialized();
440     bool public initialized = false;
441 
442     constructor() public {
443         init();
444         transferOwnership(TARGET_USER);
445     }
446     
447     function name() public pure returns (string _name) {
448         return TOKEN_NAME;
449     }
450 
451     function symbol() public pure returns (string _symbol) {
452         return TOKEN_SYMBOL;
453     }
454 
455     function decimals() public pure returns (uint8 _decimals) {
456         return TOKEN_DECIMALS_UINT8;
457     }
458 
459     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
460         require(!paused);
461         return super.transferFrom(_from, _to, _value);
462     }
463 
464     function transfer(address _to, uint256 _value) public returns (bool _success) {
465         require(!paused);
466         return super.transfer(_to, _value);
467     }
468 
469     
470     function init() private {
471         require(!initialized);
472         initialized = true;
473 
474         if (PAUSED) {
475             pause();
476         }
477 
478         
479         address[1] memory addresses = [address(0x61cce7ffbfd929628020470070382fe3de3d7f1a)];
480         uint[1] memory amounts = [uint(12500000000000)];
481         uint64[1] memory freezes = [uint64(0)];
482 
483         for (uint i = 0; i < addresses.length; i++) {
484             if (freezes[i] == 0) {
485                 mint(addresses[i], amounts[i]);
486             } else {
487                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
488             }
489         }
490         
491 
492         if (!CONTINUE_MINTING) {
493             finishMinting();
494         }
495 
496         emit Initialized();
497     }
498     
499 }