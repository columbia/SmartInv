1 pragma solidity ^0.4.23;
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
52 
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender)
67     public view returns (uint256);
68 
69   function transferFrom(address from, address to, uint256 value)
70     public returns (bool);
71 
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(
74     address indexed owner,
75     address indexed spender,
76     uint256 value
77   );
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
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
153   event OwnershipRenounced(address indexed previousOwner);
154   event OwnershipTransferred(
155     address indexed previousOwner,
156     address indexed newOwner
157   );
158 
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
224 contract FreezableToken is StandardToken {
225     mapping (bytes32 => uint64) internal chains;
226     mapping (bytes32 => uint) internal freezings;
227     mapping (address => uint) internal freezingBalance;
228     event Freezed(address indexed to, uint64 release, uint amount);
229     event Released(address indexed owner, uint amount);
230 
231     function balanceOf(address _owner) public view returns (uint256 balance) {
232         return super.balanceOf(_owner) + freezingBalance[_owner];
233     }
234 
235     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
236         return super.balanceOf(_owner);
237     }
238 
239     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
240         return freezingBalance[_owner];
241     }
242 
243     function freezingCount(address _addr) public view returns (uint count) {
244         uint64 release = chains[toKey(_addr, 0)];
245         while (release != 0) {
246             count++;
247             release = chains[toKey(_addr, release)];
248         }
249     }
250 
251     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
252         for (uint i = 0; i < _index + 1; i++) {
253             _release = chains[toKey(_addr, _release)];
254             if (_release == 0) {
255                 return;
256             }
257         }
258         _balance = freezings[toKey(_addr, _release)];
259     }
260 
261     function freezeTo(address _to, uint _amount, uint64 _until) public {
262         require(_to != address(0));
263         require(_amount <= balances[msg.sender]);
264 
265         balances[msg.sender] = balances[msg.sender].sub(_amount);
266 
267         bytes32 currentKey = toKey(_to, _until);
268         freezings[currentKey] = freezings[currentKey].add(_amount);
269         freezingBalance[_to] = freezingBalance[_to].add(_amount);
270 
271         freeze(_to, _until);
272         emit Transfer(msg.sender, _to, _amount);
273         emit Freezed(_to, _until, _amount);
274     }
275 
276     function releaseOnce() public {
277         bytes32 headKey = toKey(msg.sender, 0);
278         uint64 head = chains[headKey];
279         require(head != 0);
280         require(uint64(block.timestamp) > head);
281         bytes32 currentKey = toKey(msg.sender, head);
282 
283         uint64 next = chains[currentKey];
284 
285         uint amount = freezings[currentKey];
286         delete freezings[currentKey];
287 
288         balances[msg.sender] = balances[msg.sender].add(amount);
289         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
290 
291         if (next == 0) {
292             delete chains[headKey];
293         } else {
294             chains[headKey] = next;
295             delete chains[currentKey];
296         }
297         emit Released(msg.sender, amount);
298     }
299 
300     function releaseAll() public returns (uint tokens) {
301         uint release;
302         uint balance;
303         (release, balance) = getFreezing(msg.sender, 0);
304         while (release != 0 && block.timestamp > release) {
305             releaseOnce();
306             tokens += balance;
307             (release, balance) = getFreezing(msg.sender, 0);
308         }
309     }
310 
311     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
312         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
313         assembly {
314             result := or(result, mul(_addr, 0x10000000000000000))
315             result := or(result, _release)
316         }
317     }
318 
319     function freeze(address _to, uint64 _until) internal {
320         require(_until > block.timestamp);
321         bytes32 key = toKey(_to, _until);
322         bytes32 parentKey = toKey(_to, uint64(0));
323         uint64 next = chains[parentKey];
324 
325         if (next == 0) {
326             chains[parentKey] = _until;
327             return;
328         }
329 
330         bytes32 nextKey = toKey(_to, next);
331         uint parent;
332 
333         while (next != 0 && _until > next) {
334             parent = next;
335             parentKey = nextKey;
336 
337             next = chains[nextKey];
338             nextKey = toKey(_to, next);
339         }
340 
341         if (_until == next) {
342             return;
343         }
344 
345         if (next != 0) {
346             chains[key] = next;
347         }
348 
349         chains[parentKey] = _until;
350     }
351 }
352 
353 contract BurnableToken is BasicToken {
354 
355   event Burn(address indexed burner, uint256 value);
356   function burn(uint256 _value) public {
357     _burn(msg.sender, _value);
358   }
359 
360   function _burn(address _who, uint256 _value) internal {
361     require(_value <= balances[_who]);
362     balances[_who] = balances[_who].sub(_value);
363     totalSupply_ = totalSupply_.sub(_value);
364     emit Burn(_who, _value);
365     emit Transfer(_who, address(0), _value);
366   }
367 }
368 
369 contract Pausable is Ownable {
370   event Pause();
371   event Unpause();
372 
373   bool public paused = false;
374 
375   modifier whenNotPaused() {
376     require(!paused);
377     _;
378   }
379 
380   modifier whenPaused() {
381     require(paused);
382     _;
383   }
384 
385   function pause() onlyOwner whenNotPaused public {
386     paused = true;
387     emit Pause();
388   }
389 
390   function unpause() onlyOwner whenPaused public {
391     paused = false;
392     emit Unpause();
393   }
394 }
395 
396 contract FreezableMintableToken is FreezableToken, MintableToken {
397     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
398         totalSupply_ = totalSupply_.add(_amount);
399 
400         bytes32 currentKey = toKey(_to, _until);
401         freezings[currentKey] = freezings[currentKey].add(_amount);
402         freezingBalance[_to] = freezingBalance[_to].add(_amount);
403 
404         freeze(_to, _until);
405         emit Mint(_to, _amount);
406         emit Freezed(_to, _until, _amount);
407         emit Transfer(msg.sender, _to, _amount);
408         return true;
409     }
410 }
411 
412 contract Consts {
413     uint public constant TOKEN_DECIMALS = 18;
414     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
415     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
416     string public constant TOKEN_NAME = "Mindsync";
417     string public constant TOKEN_SYMBOL = "MAI";
418     bool public constant PAUSED = false;
419     address public constant TARGET_USER = 0x108fd0EF043b56adfD0C80A9A453a0c5ad299117;
420     bool public constant CONTINUE_MINTING = true;
421 }
422 
423 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
424 {
425     event Initialized();
426     bool public initialized = false;
427 
428     constructor() public {
429         init();
430         transferOwnership(TARGET_USER);
431     }
432 
433     function name() public pure returns (string _name) {
434         return TOKEN_NAME;
435     }
436 
437     function symbol() public pure returns (string _symbol) {
438         return TOKEN_SYMBOL;
439     }
440 
441     function decimals() public pure returns (uint8 _decimals) {
442         return TOKEN_DECIMALS_UINT8;
443     }
444 
445     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
446         require(!paused);
447         return super.transferFrom(_from, _to, _value);
448     }
449 
450     function transfer(address _to, uint256 _value) public returns (bool _success) {
451         require(!paused);
452         return super.transfer(_to, _value);
453     }
454     
455     function init() private {
456         require(!initialized);
457         initialized = true;
458 
459         if (PAUSED) {
460             pause();
461         }
462         
463         address[5] memory addresses = [address(0x56652B3Af157535dA3F6a5601F9C0C0Dfa788024),address(0x091Db50Dd49CB0Bec67BFF3CEf52724A57e7955C),address(0xdCf85aa5A932c4F9252c308929fC933B1cA321F8),address(0x68991C51518BEa730493891F45d64CBcCb72e2dF),address(0xF847B03799170FBD8981cc0913072e3a1F78ae49)];
464         uint[5] memory amounts = [uint(200000000000000000000000000),uint(37500000000000000000000000),uint(80000000000000000000000000),uint(50000000000000000000000000),uint(20000000000000000000000000)];
465         uint64[5] memory freezes = [uint64(1561928401),uint64(1585688401),uint64(1551387601),uint64(0),uint64(0)];
466 
467         for (uint i = 0; i < addresses.length; i++) {
468             if (freezes[i] == 0) {
469                 mint(addresses[i], amounts[i]);
470             } else {
471                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
472             }
473         }
474 
475         if (!CONTINUE_MINTING) {
476             finishMinting();
477         }
478 
479         emit Initialized();
480     }
481 }