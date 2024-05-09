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
115 
116   function increaseApproval(
117     address _spender,
118     uint256 _addedValue
119   )
120     public
121     returns (bool)
122   {
123     allowed[msg.sender][_spender] = (
124       allowed[msg.sender][_spender].add(_addedValue));
125     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129   function decreaseApproval(
130     address _spender,
131     uint256 _subtractedValue
132   )
133     public
134     returns (bool)
135   {
136     uint256 oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue >= oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146 }
147  
148 // ERC20 standard token
149 contract XYC is StandardToken {
150     address public admin; // ����Ա
151     string public name = "XYCoin(逍遥生态币)"; // ��������
152     string public symbol = "XYC"; // ���ҷ���
153     uint8 public decimals = 18; // ���Ҿ���
154     uint256 public totalSupply = 10000000000e18; // ����80�� *10^18
155     // ͬһ���˻��������ⶳ��������������
156     mapping (address => bool) public frozenAccount; //�����ڶ�����˻�
157     mapping (address => uint256) public frozenTimestamp; // �����ڶ�����˻�
158 
159     bool public exchangeFlag = true; // ���Ҷһ�����
160     // ������������ļ����ɶ����eth�����ظ�ԭ�˻�
161     uint256 public minWei = 1;  //��ʹ� 1 wei  1eth = 1*10^18 wei
162     uint256 public maxWei = 20000e18; // ���һ�δ� 20000 eth
163     uint256 public maxRaiseAmount = 20000e18; // ļ������ 20000 eth
164     uint256 public raisedAmount = 0; // ��ļ�� 0 eth
165     uint256 public raiseRatio = 200000; // �һ����� 1eth = 20��token
166     // event ֪ͨ
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     // ���캯��
171     constructor() public {
172         totalSupply_ = totalSupply;
173         admin = msg.sender;
174         balances[msg.sender] = totalSupply;
175     }
176 
177     // fallback ���Լ��ַת�� or ���÷Ǻ�Լ��������
178     // �����Զ��һ�eth
179     function()
180     public payable {
181         require(msg.value > 0);
182         if (exchangeFlag) {
183             if (msg.value >= minWei && msg.value <= maxWei){
184                 if (raisedAmount < maxRaiseAmount) {
185                     uint256 valueNeed = msg.value;
186                     raisedAmount = raisedAmount.add(msg.value);
187                     if (raisedAmount > maxRaiseAmount) {
188                         uint256 valueLeft = raisedAmount.sub(maxRaiseAmount);
189                         valueNeed = msg.value.sub(valueLeft);
190                         msg.sender.transfer(valueLeft);
191                         raisedAmount = maxRaiseAmount;
192                     }
193                     if (raisedAmount >= maxRaiseAmount) {
194                         exchangeFlag = false;
195                     }
196                     // �Ѵ��������� *10^18
197                     uint256 _value = valueNeed.mul(raiseRatio);
198 
199                     require(_value <= balances[admin]);
200                     balances[admin] = balances[admin].sub(_value);
201                     balances[msg.sender] = balances[msg.sender].add(_value);
202 
203                     emit Transfer(admin, msg.sender, _value);
204 
205                 }
206             } else {
207                 msg.sender.transfer(msg.value);
208             }
209         } else {
210             msg.sender.transfer(msg.value);
211         }
212     }
213 
214     /**
215     * �޸Ĺ���Ա
216     */
217     function changeAdmin(
218         address _newAdmin
219     )
220     public
221     returns (bool)  {
222         require(msg.sender == admin);
223         require(_newAdmin != address(0));
224         balances[_newAdmin] = balances[_newAdmin].add(balances[admin]);
225         balances[admin] = 0;
226         admin = _newAdmin;
227         return true;
228     }
229     /**
230     * ����
231     */
232     function generateToken(
233         address _target,
234         uint256 _amount
235     )
236     public
237     returns (bool)  {
238         require(msg.sender == admin);
239         require(_target != address(0));
240         balances[_target] = balances[_target].add(_amount);
241         totalSupply_ = totalSupply_.add(_amount);
242         totalSupply = totalSupply_;
243         return true;
244     }
245 
246     // �Ӻ�Լ����
247     // ֻ���������Ա
248     function withdraw (
249         uint256 _amount
250     )
251     public
252     returns (bool) {
253         require(msg.sender == admin);
254         msg.sender.transfer(_amount);
255         return true;
256     }
257     /**
258     * �����˻�
259     */
260     function freeze(
261         address _target,
262         bool _freeze
263     )
264     public
265     returns (bool) {
266         require(msg.sender == admin);
267         require(_target != address(0));
268         frozenAccount[_target] = _freeze;
269         return true;
270     }
271     /**
272     * ͨ��ʱ��������˻�
273     */
274     function freezeWithTimestamp(
275         address _target,
276         uint256 _timestamp
277     )
278     public
279     returns (bool) {
280         require(msg.sender == admin);
281         require(_target != address(0));
282         frozenTimestamp[_target] = _timestamp;
283         return true;
284     }
285 
286     /**
287         * ���������˻�
288         */
289     function multiFreeze(
290         address[] _targets,
291         bool[] _freezes
292     )
293     public
294     returns (bool) {
295         require(msg.sender == admin);
296         require(_targets.length == _freezes.length);
297         uint256 len = _targets.length;
298         require(len > 0);
299         for (uint256 i = 0; i < len; i = i.add(1)) {
300             address _target = _targets[i];
301             require(_target != address(0));
302             bool _freeze = _freezes[i];
303             frozenAccount[_target] = _freeze;
304         }
305         return true;
306     }
307     /**
308             * ����ͨ��ʱ��������˻�
309             */
310     function multiFreezeWithTimestamp(
311         address[] _targets,
312         uint256[] _timestamps
313     )
314     public
315     returns (bool) {
316         require(msg.sender == admin);
317         require(_targets.length == _timestamps.length);
318         uint256 len = _targets.length;
319         require(len > 0);
320         for (uint256 i = 0; i < len; i = i.add(1)) {
321             address _target = _targets[i];
322             require(_target != address(0));
323             uint256 _timestamp = _timestamps[i];
324             frozenTimestamp[_target] = _timestamp;
325         }
326         return true;
327     }
328     /**
329     * ����ת��
330     */
331     function multiTransfer(
332         address[] _tos,
333         uint256[] _values
334     )
335     public
336     returns (bool) {
337         require(!frozenAccount[msg.sender]);
338         require(now > frozenTimestamp[msg.sender]);
339         require(_tos.length == _values.length);
340         uint256 len = _tos.length;
341         require(len > 0);
342         uint256 amount = 0;
343         for (uint256 i = 0; i < len; i = i.add(1)) {
344             amount = amount.add(_values[i]);
345         }
346         require(amount <= balances[msg.sender]);
347         for (uint256 j = 0; j < len; j = j.add(1)) {
348             address _to = _tos[j];
349             require(_to != address(0));
350             balances[_to] = balances[_to].add(_values[j]);
351             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
352             emit Transfer(msg.sender, _to, _values[j]);
353         }
354         return true;
355     }
356     /**
357     * �ӵ�����ת����_to
358     */
359     function transfer(
360         address _to,
361         uint256 _value
362     )
363     public
364     returns (bool) {
365         require(!frozenAccount[msg.sender]);
366         require(now > frozenTimestamp[msg.sender]);
367         require(_to != address(0));
368         require(_value <= balances[msg.sender]);
369 
370         balances[msg.sender] = balances[msg.sender].sub(_value);
371         balances[_to] = balances[_to].add(_value);
372 
373         emit Transfer(msg.sender, _to, _value);
374         return true;
375     }
376     /*
377     * �ӵ�������Ϊfrom������from�˻��е�tokenת����to
378     * ��������from�����ɶ���б���>=value
379     */
380     function transferFrom(
381         address _from,
382         address _to,
383         uint256 _value
384     )
385     public
386     returns (bool)
387     {
388         require(!frozenAccount[_from]);
389         require(now > frozenTimestamp[msg.sender]);
390         require(_to != address(0));
391         require(_value <= balances[_from]);
392         require(_value <= allowed[_from][msg.sender]);
393 
394         balances[_from] = balances[_from].sub(_value);
395         balances[_to] = balances[_to].add(_value);
396         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
397 
398         emit Transfer(_from, _to, _value);
399         return true;
400     }
401     /**
402     * ����ת�˴�����spender�Ĵ��������ɶ��
403     */
404     function approve(
405         address _spender,
406         uint256 _value
407     ) public
408     returns (bool) {
409         // ת�˵�ʱ���У��balances���ô�require������
410         // require(_value <= balances[msg.sender]);
411 
412         allowed[msg.sender][_spender] = _value;
413 
414         emit Approval(msg.sender, _spender, _value);
415         return true;
416     }
417     /**
418     * ����ת�˴�����spender�Ĵ��������ɶ��
419     * ���岻���function
420     */
421     function increaseApproval(
422         address _spender,
423         uint256 _addedValue
424     )
425     public
426     returns (bool)
427     {
428         // uint256 value_ = allowed[msg.sender][_spender].add(_addedValue);
429         // require(value_ <= balances[msg.sender]);
430         // allowed[msg.sender][_spender] = value_;
431 
432         // emit Approval(msg.sender, _spender, value_);
433         return true;
434     }
435     /**
436     * ����ת�˴�����spender�Ĵ��������ɶ��
437     * ���岻���function
438     */
439     function decreaseApproval(
440         address _spender,
441         uint256 _subtractedValue
442     )
443     public
444     returns (bool)
445     {
446         // uint256 oldValue = allowed[msg.sender][_spender];
447         // if (_subtractedValue > oldValue) {
448         //    allowed[msg.sender][_spender] = 0;
449         // } else {
450         //    uint256 newValue = oldValue.sub(_subtractedValue);
451         //    require(newValue <= balances[msg.sender]);
452         //   allowed[msg.sender][_spender] = newValue;
453         //}
454 
455         // emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
456         return true;
457     }
458 
459     //********************************************************************************
460     //��ѯ�˻��Ƿ��������ʱ���
461     function getFrozenTimestamp(
462         address _target
463     )
464     public view
465     returns (uint256) {
466         require(_target != address(0));
467         return frozenTimestamp[_target];
468     }
469     //��ѯ�˻��Ƿ�����
470     function getFrozenAccount(
471         address _target
472     )
473     public view
474     returns (bool) {
475         require(_target != address(0));
476         return frozenAccount[_target];
477     }
478     //��ѯ��Լ�����
479     function getBalance()
480     public view
481     returns (uint256) {
482         return address(this).balance;
483     }
484 	
485     // �޸�ļ��flag
486     function setExchangeFlag (
487         bool _flag
488     )
489     public
490     returns (bool) {
491         require(msg.sender == admin);
492         exchangeFlag = _flag;
493         return true;
494 
495     }
496     // �޸ĵ���ļ������
497     function setMinWei (
498         uint256 _value
499     )
500     public
501     returns (bool) {
502         require(msg.sender == admin);
503         minWei = _value;
504         return true;
505 
506     }
507     // �޸ĵ���ļ������
508     function setMaxWei (
509         uint256 _value
510     )
511     public
512     returns (bool) {
513         require(msg.sender == admin);
514         maxWei = _value;
515         return true;
516     }
517     // �޸���ļ������
518     function setMaxRaiseAmount (
519         uint256 _value
520     )
521     public
522     returns (bool) {
523         require(msg.sender == admin);
524         maxRaiseAmount = _value;
525         return true;
526     }
527 
528     // �޸���ļ����
529     function setRaisedAmount (
530         uint256 _value
531     )
532     public
533     returns (bool) {
534         require(msg.sender == admin);
535         raisedAmount = _value;
536         return true;
537     }
538 
539     // �޸�ļ������
540     function setRaiseRatio (
541         uint256 _value
542     )
543     public
544     returns (bool) {
545         require(msg.sender == admin);
546         raiseRatio = _value;
547         return true;
548     }
549 
550     // ���ٺ�Լ
551     function kill()
552     public {
553         require(msg.sender == admin);
554         selfdestruct(admin);
555     }
556 
557 }