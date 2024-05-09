1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function safeMul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function safeDiv(uint a, uint b) internal pure returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function safeSub(uint a, uint b) internal pure returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function safeAdd(uint a, uint b) internal pure returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
34     return a < b ? a : b;
35   }
36   function safePerc(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(a >= 0);
38     uint256 c = (a * b) / 100;
39     return c;
40   }
41   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     if (a == 0) {
43       return 0;
44     }
45     c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     return a / b;
51   }
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77   mapping(address => uint256) balances;
78   uint256 totalSupply_;
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     emit Transfer(msg.sender, _to, _value);
88     return true;
89   }
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94 }
95 contract StandardToken is ERC20, BasicToken {
96   mapping (address => mapping (address => uint256)) internal allowed;
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101     balances[_from] = balances[_from].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104     emit Transfer(_from, _to, _value);
105     return true;
106   }
107  function approve(address _spender, uint256 _value) public returns (bool) {
108     allowed[msg.sender][_spender] = _value;
109     emit Approval(msg.sender, _spender, _value);
110     return true;
111   }
112   function allowance(address _owner, address _spender) public view returns (uint256) {
113     return allowed[_owner][_spender];
114   }
115   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
116     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
117     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121     uint oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131 }
132 
133 contract ERC865 is ERC20 {
134      function transferPreSigned(
135         bytes _signature,
136         address _to,
137         uint256 _value,
138         uint256 _fee,
139         uint256 _nonce
140     )
141         public
142         returns (bool);
143      function approvePreSigned(
144         bytes _signature,
145         address _spender,
146         uint256 _value,
147         uint256 _fee,
148         uint256 _nonce
149     )
150         public
151         returns (bool);
152      function increaseApprovalPreSigned(
153         bytes _signature,
154         address _spender,
155         uint256 _addedValue,
156         uint256 _fee,
157         uint256 _nonce
158     )
159         public
160         returns (bool);
161      function decreaseApprovalPreSigned(
162         bytes _signature,
163         address _spender,
164         uint256 _subtractedValue,
165         uint256 _fee,
166         uint256 _nonce
167     )
168         public
169         returns (bool);
170      function transferFromPreSigned(
171         bytes _signature,
172         address _from,
173         address _to,
174         uint256 _value,
175         uint256 _fee,
176         uint256 _nonce
177     )
178         public
179         returns (bool);
180 }
181 contract Ownable {
182   address public owner;
183   event transferOwner(address indexed existingOwner, address indexed newOwner);
184   constructor() public {
185     owner = msg.sender;
186   }
187   modifier onlyOwner() {
188     require(msg.sender == owner);
189     _;
190   }
191   function transferOwnership(address newOwner) onlyOwner public {
192     if (newOwner != address(0)) {
193       owner = newOwner;
194       emit transferOwner(msg.sender, owner);
195     }
196   }
197 }
198 contract Pausable is Ownable {
199   event Pause();
200   event Unpause();
201   bool public paused = false;
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206   modifier whenPaused() {
207     require(paused);
208     _;
209   }
210   function pause() onlyOwner whenNotPaused public {
211     paused = true;
212     emit Pause();
213   }
214   function unpause() onlyOwner whenPaused public {
215     paused = false;
216     emit Unpause();
217   }
218 }
219 contract PausableToken is StandardToken, Pausable {
220   function transfer(
221     address _to,
222     uint256 _value
223   )
224     public
225     whenNotPaused
226     returns (bool)
227   {
228     return super.transfer(_to, _value);
229   }
230 
231   function transferFrom(
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     public
237     whenNotPaused
238     returns (bool)
239   {
240     return super.transferFrom(_from, _to, _value);
241   }
242 
243   function approve(
244     address _spender,
245     uint256 _value
246   )
247     public
248     whenNotPaused
249     returns (bool)
250   {
251     return super.approve(_spender, _value);
252   }
253 
254   function increaseApproval(
255     address _spender,
256     uint _addedValue
257   )
258     public
259     whenNotPaused
260     returns (bool success)
261   {
262     return super.increaseApproval(_spender, _addedValue);
263   }
264 
265   function decreaseApproval(
266     address _spender,
267     uint _subtractedValue
268   )
269     public
270     whenNotPaused
271     returns (bool success)
272   {
273     return super.decreaseApproval(_spender, _subtractedValue);
274   }
275 }
276 
277  contract OpenSourceToken is ERC865, StandardToken, PausableToken {
278     mapping(bytes => bool) signatures;
279     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
280     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
281     string public constant name = "Open Source Token";
282     string public constant symbol = "OST";
283     uint8 public constant decimals = 8;
284     uint256 public totalSupply = 888888888888888888;
285 	constructor() public {
286 		balances[msg.sender] = totalSupply;
287     }
288     function transferPreSigned(
289         bytes _signature,
290         address _to,
291         uint256 _value,
292         uint256 _fee,
293         uint256 _nonce
294     )
295         public
296         returns (bool)
297     {
298         require(_to != address(0));
299         require(signatures[_signature] == false);
300          bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
301          address from = recover(hashedTx, _signature);
302         require(from != address(0));
303          balances[from] = balances[from].sub(_value).sub(_fee);
304         balances[_to] = balances[_to].add(_value);
305         balances[msg.sender] = balances[msg.sender].add(_fee);
306         signatures[_signature] = true;
307          Transfer(from, _to, _value);
308         Transfer(from, msg.sender, _fee);
309         TransferPreSigned(from, _to, msg.sender, _value, _fee);
310         return true;
311     }
312 	function approvePreSigned(
313         bytes _signature,
314         address _spender,
315         uint256 _value,
316         uint256 _fee,
317         uint256 _nonce
318     )
319         public
320         returns (bool)
321     {
322         require(_spender != address(0));
323         require(signatures[_signature] == false);
324          bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
325         address from = recover(hashedTx, _signature);
326         require(from != address(0));
327          allowed[from][_spender] = _value;
328         balances[from] = balances[from].sub(_fee);
329         balances[msg.sender] = balances[msg.sender].add(_fee);
330         signatures[_signature] = true;
331          Approval(from, _spender, _value);
332         Transfer(from, msg.sender, _fee);
333         ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
334         return true;
335     }
336     function increaseApprovalPreSigned(
337         bytes _signature,
338         address _spender,
339         uint256 _addedValue,
340         uint256 _fee,
341         uint256 _nonce
342     )
343         public
344         returns (bool)
345     {
346         require(_spender != address(0));
347         require(signatures[_signature] == false);
348          bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
349         address from = recover(hashedTx, _signature);
350         require(from != address(0));
351          allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
352         balances[from] = balances[from].sub(_fee);
353         balances[msg.sender] = balances[msg.sender].add(_fee);
354         signatures[_signature] = true;
355          Approval(from, _spender, allowed[from][_spender]);
356         Transfer(from, msg.sender, _fee);
357         ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
358         return true;
359     }
360     function decreaseApprovalPreSigned(
361         bytes _signature,
362         address _spender,
363         uint256 _subtractedValue,
364         uint256 _fee,
365         uint256 _nonce
366     )
367         public
368         returns (bool)
369     {
370         require(_spender != address(0));
371         require(signatures[_signature] == false);
372          bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
373         address from = recover(hashedTx, _signature);
374         require(from != address(0));
375          uint oldValue = allowed[from][_spender];
376         if (_subtractedValue > oldValue) {
377             allowed[from][_spender] = 0;
378         } else {
379             allowed[from][_spender] = oldValue.sub(_subtractedValue);
380         }
381         balances[from] = balances[from].sub(_fee);
382         balances[msg.sender] = balances[msg.sender].add(_fee);
383         signatures[_signature] = true;
384          Approval(from, _spender, _subtractedValue);
385         Transfer(from, msg.sender, _fee);
386         ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
387         return true;
388     }
389     function transferFromPreSigned(
390         bytes _signature,
391         address _from,
392         address _to,
393         uint256 _value,
394         uint256 _fee,
395         uint256 _nonce
396     )
397         public
398         returns (bool)
399     {
400         require(_to != address(0));
401         require(signatures[_signature] == false);
402          bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
403          address spender = recover(hashedTx, _signature);
404         require(spender != address(0));
405          balances[_from] = balances[_from].sub(_value);
406         balances[_to] = balances[_to].add(_value);
407         allowed[_from][spender] = allowed[_from][spender].sub(_value);
408          balances[spender] = balances[spender].sub(_fee);
409         balances[msg.sender] = balances[msg.sender].add(_fee);
410         signatures[_signature] = true;
411          Transfer(_from, _to, _value);
412         Transfer(spender, msg.sender, _fee);
413         return true;
414     }
415     function transferPreSignedHashing(
416         address _token,
417         address _to,
418         uint256 _value,
419         uint256 _fee,
420         uint256 _nonce
421     )
422         public
423         pure
424         returns (bytes32)
425     {
426         return keccak256(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce);
427     }
428     function approvePreSignedHashing(
429         address _token,
430         address _spender,
431         uint256 _value,
432         uint256 _fee,
433         uint256 _nonce
434     )
435         public
436         pure
437         returns (bytes32)
438     {
439         return keccak256(bytes4(0xf7ac9c2e), _token, _spender, _value, _fee, _nonce);
440     }
441     function increaseApprovalPreSignedHashing(
442         address _token,
443         address _spender,
444         uint256 _addedValue,
445         uint256 _fee,
446         uint256 _nonce
447     )
448         public
449         pure
450         returns (bytes32)
451     {
452         return keccak256(bytes4(0xa45f71ff), _token, _spender, _addedValue, _fee, _nonce);
453     }
454     function decreaseApprovalPreSignedHashing(
455         address _token,
456         address _spender,
457         uint256 _subtractedValue,
458         uint256 _fee,
459         uint256 _nonce
460     )
461         public
462         pure
463         returns (bytes32)
464     {
465         return keccak256(bytes4(0x59388d78), _token, _spender, _subtractedValue, _fee, _nonce);
466     }
467     function transferFromPreSignedHashing(
468         address _token,
469         address _from,
470         address _to,
471         uint256 _value,
472         uint256 _fee,
473         uint256 _nonce
474     )
475         public
476         pure
477         returns (bytes32)
478     {
479         return keccak256(bytes4(0xb7656dc5), _token, _from, _to, _value, _fee, _nonce);
480     }
481     function recover(bytes32 hash, bytes sig) public pure returns (address) {
482       bytes32 r;
483       bytes32 s;
484       uint8 v;
485       if (sig.length != 65) {
486         return (address(0));
487       }
488       assembly {
489         r := mload(add(sig, 32))
490         s := mload(add(sig, 64))
491         v := byte(0, mload(add(sig, 96)))
492       }
493      if (v < 27) {
494         v += 27;
495       }
496       if (v != 27 && v != 28) {
497         return (address(0));
498       } else {
499         return ecrecover(hash, v, r, s);
500       }
501     }
502  }