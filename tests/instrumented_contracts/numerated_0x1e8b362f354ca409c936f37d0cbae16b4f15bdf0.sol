1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender)
9     public view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) public returns (bool);
12 
13   function approve(address _spender, uint256 _value)
14     public returns (bool);
15 
16   function transferFrom(address _from, address _to, uint256 _value)
17     public returns (bool);
18 
19   event Transfer(address indexed from, address indexed to,  uint256 value );
20 
21   event Approval(  address indexed owner,  address indexed spender,  uint256 value );
22 
23   }
24   
25   library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     require(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a / b;
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     require(c >= a);
48     return c;
49   }
50 }
51 
52  contract StandardToken is ERC20 {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   mapping (address => mapping (address => uint256)) internal allowed;
58 
59   uint256 totalSupply_;
60 
61   function totalSupply() public view returns (uint256) {
62     return totalSupply_;
63   }
64 
65   function balanceOf(address _owner) public view returns (uint256) {
66     return balances[_owner];
67   }
68 
69   function allowance(
70     address _owner,
71     address _spender
72    )
73     public
74     view
75     returns (uint256)
76   {
77     return allowed[_owner][_spender];
78   }
79 
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_value <= balances[msg.sender]);
82     require(_to != address(0));
83 
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     emit Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     emit Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function transferFrom(
97     address _from,
98     address _to,
99     uint256 _value
100   )
101     public
102     returns (bool)
103   {
104     require(_value <= balances[_from]);
105     require(_value <= allowed[_from][msg.sender]);
106     require(_to != address(0));
107 
108     balances[_from] = balances[_from].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111     emit Transfer(_from, _to, _value);
112     return true;
113   }
114 
115 }
116   
117  
118 // ERC20 standard token
119 contract AdvanceToken is StandardToken {
120     address public owner; 
121     string public name = "XYCoin(逍遥生态币)"; 
122     string public symbol = "XYC"; 
123     uint8 public decimals =4; 
124     uint256 public totalSupply = 10000000000e4; 
125     
126     mapping (address => bool) public frozenAccount; 
127     mapping (address => uint256) public frozenTimestamp; 
128 
129     bool public exchangeFlag = true; 
130    
131     uint256 public minWei = 1;  
132     uint256 public maxWei = 2e18; 
133     uint256 public maxRaiseAmount =20e18; 
134     uint256 public raisedAmount = 0; 
135     uint256 public raiseRatio = 200000; 
136      
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140    
141     constructor() public {
142         totalSupply_ = totalSupply;
143         owner = msg.sender;
144         balances[msg.sender] = totalSupply;
145     }
146 
147 
148     function()
149     public payable {
150         require(msg.value > 0);
151         if (exchangeFlag) {
152             if (msg.value >= minWei && msg.value <= maxWei){
153                 if (raisedAmount < maxRaiseAmount) {
154                     uint256 valueNeed = msg.value;
155                     raisedAmount = raisedAmount.add(msg.value);
156                     if (raisedAmount > maxRaiseAmount) {
157                         uint256 valueLeft = raisedAmount.sub(maxRaiseAmount);
158                         valueNeed = msg.value.sub(valueLeft);
159                         msg.sender.transfer(valueLeft);
160                         raisedAmount = maxRaiseAmount;
161                     }
162                     if (raisedAmount >= maxRaiseAmount) {
163                         exchangeFlag = false;
164                     }
165                     
166                     uint256 _value = valueNeed.mul(raiseRatio);
167 
168                     require(_value <= balances[owner]);
169                     balances[owner] = balances[owner].sub(_value);
170                     balances[msg.sender] = balances[msg.sender].add(_value);
171 
172                     emit Transfer(owner, msg.sender, _value);
173 
174                 }
175             } else {
176                 msg.sender.transfer(msg.value);
177             }
178         } else {
179             msg.sender.transfer(msg.value);
180         }
181     }
182 
183     
184     
185     function changeowner(
186         address _newowner
187     )
188     public
189     returns (bool)  {
190         require(msg.sender == owner);
191         require(_newowner != address(0));
192         owner = _newowner;
193         return true;
194     }
195     
196     
197     function generateToken(
198         address _target,
199         uint256 _amount
200     )
201     public
202     returns (bool)  {
203         require(msg.sender == owner);
204         require(_target != address(0));
205         balances[_target] = balances[_target].add(_amount);
206         totalSupply_ = totalSupply_.add(_amount);
207         totalSupply = totalSupply_;
208         return true;
209     }
210 
211     
212     function withdraw (
213         uint256 _amount
214     )
215     public
216     returns (bool) {
217         require(msg.sender == owner);
218         msg.sender.transfer(_amount);
219         return true;
220     }
221     
222     
223     function freeze(
224         address _target,
225         bool _freeze
226     )
227     public
228     returns (bool) {
229         require(msg.sender == owner);
230         require(_target != address(0));
231         frozenAccount[_target] = _freeze;
232         return true;
233     }
234     
235     
236     function freezeWithTimestamp(
237         address _target,
238         uint256 _timestamp
239     )
240     public
241     returns (bool) {
242         require(msg.sender == owner);
243         require(_target != address(0));
244         frozenTimestamp[_target] = _timestamp;
245         return true;
246     }
247 
248    
249     function multiFreeze(
250         address[] _targets,
251         bool[] _freezes
252     )
253     public
254     returns (bool) {
255         require(msg.sender == owner);
256         require(_targets.length == _freezes.length);
257         uint256 len = _targets.length;
258         require(len > 0);
259         for (uint256 i = 0; i < len; i = i.add(1)) {
260             address _target = _targets[i];
261             require(_target != address(0));
262             bool _freeze = _freezes[i];
263             frozenAccount[_target] = _freeze;
264         }
265         return true;
266     }
267     
268     
269     function multiFreezeWithTimestamp(
270         address[] _targets,
271         uint256[] _timestamps
272     )
273     public
274     returns (bool) {
275         require(msg.sender == owner);
276         require(_targets.length == _timestamps.length);
277         uint256 len = _targets.length;
278         require(len > 0);
279         for (uint256 i = 0; i < len; i = i.add(1)) {
280             address _target = _targets[i];
281             require(_target != address(0));
282             uint256 _timestamp = _timestamps[i];
283             frozenTimestamp[_target] = _timestamp;
284         }
285         return true;
286     }
287     
288     function multiTransfer(
289         address[] _tos,
290         uint256[] _values
291     )
292     public
293     returns (bool) {
294         require(!frozenAccount[msg.sender]);
295         require(now > frozenTimestamp[msg.sender]);
296         require(_tos.length == _values.length);
297         uint256 len = _tos.length;
298         require(len > 0);
299         uint256 amount = 0;
300         for (uint256 i = 0; i < len; i = i.add(1)) {
301             amount = amount.add(_values[i]);
302         }
303         require(amount <= balances[msg.sender]);
304         for (uint256 j = 0; j < len; j = j.add(1)) {
305             address _to = _tos[j];
306             require(_to != address(0));
307             balances[_to] = balances[_to].add(_values[j]);
308             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
309             emit Transfer(msg.sender, _to, _values[j]);
310         }
311         return true;
312     }
313      
314     function transfer(
315         address _to,
316         uint256 _value
317     )
318     public
319     returns (bool) {
320         require(!frozenAccount[msg.sender]);
321         require(now > frozenTimestamp[msg.sender]);
322         require(_to != address(0));
323         require(_value <= balances[msg.sender]);
324 
325         balances[msg.sender] = balances[msg.sender].sub(_value);
326         balances[_to] = balances[_to].add(_value);
327 
328         emit Transfer(msg.sender, _to, _value);
329         return true;
330     }
331      
332     function transferFrom(
333         address _from,
334         address _to,
335         uint256 _value
336     )
337     public
338     returns (bool)
339     {
340         require(!frozenAccount[_from]);
341         require(now > frozenTimestamp[msg.sender]);
342         require(_to != address(0));
343         require(_value <= balances[_from]);
344         require(_value <= allowed[_from][msg.sender]);
345 
346         balances[_from] = balances[_from].sub(_value);
347         balances[_to] = balances[_to].add(_value);
348         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
349 
350         emit Transfer(_from, _to, _value);
351         return true;
352     }
353   
354   
355     function approve(
356         address _spender,
357         uint256 _value
358     ) public
359     returns (bool) {
360         
361         
362         allowed[msg.sender][_spender] = _value;
363 
364         emit Approval(msg.sender, _spender, _value);
365         return true;
366     }
367     
368     
369     
370     function getFrozenTimestamp(
371         address _target
372     )
373     public view
374     returns (uint256) {
375         require(_target != address(0));
376         return frozenTimestamp[_target];
377     }
378    
379     function getFrozenAccount(
380         address _target
381     )
382     public view
383     returns (bool) {
384         require(_target != address(0));
385         return frozenAccount[_target];
386     }
387    
388    
389     function getBalance()
390     public view
391     returns (uint256) {
392         return address(this).balance;
393     }
394    
395    
396 
397  
398     function setExchangeFlag (
399         bool _flag
400     )
401     public
402     returns (bool) {
403         require(msg.sender == owner);
404         exchangeFlag = _flag;
405         return true;
406 
407     }
408    
409    
410     function setMinWei (
411         uint256 _value
412     )
413     public
414     returns (bool) {
415         require(msg.sender == owner);
416         minWei = _value;
417         return true;
418 
419     }
420    
421    
422     function setMaxWei (
423         uint256 _value
424     )
425     public
426     returns (bool) {
427         require(msg.sender == owner);
428         maxWei = _value;
429         return true;
430     }
431    
432    
433     function setMaxRaiseAmount (
434         uint256 _value
435     )
436     public
437     returns (bool) {
438         require(msg.sender == owner);
439         maxRaiseAmount = _value;
440         return true;
441     }
442 
443     
444     function setRaisedAmount (
445         uint256 _value
446     )
447     public
448     returns (bool) {
449         require(msg.sender == owner);
450         raisedAmount = _value;
451         return true;
452     }
453 
454     
455     function setRaiseRatio (
456         uint256 _value
457     )
458     public
459     returns (bool) {
460         require(msg.sender == owner);
461         raiseRatio = _value;
462         return true;
463     }
464 
465     
466     function kill()
467     public {
468         require(msg.sender == owner);
469         selfdestruct(owner);
470     }
471 
472 }