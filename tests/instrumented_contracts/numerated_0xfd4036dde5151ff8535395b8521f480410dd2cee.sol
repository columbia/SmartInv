1 pragma solidity ^0.4.24;
2 
3 contract Token{
4     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
5     uint256 public totalSupply;
6 
7     /// 获取账户_owner拥有token的数量 
8     function balanceOf(address _owner) constant public returns (uint256 balance);
9 
10     //从消息发送者账户中往_to账户转数量为_value的token
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
14     function transferFrom(address _from, address _to, uint256 _value) public returns   
15     (bool success);
16 
17     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
18     function approve(address _spender, uint256 _value) public returns (bool success);
19 
20     //获取账户_spender可以从账户_owner中转出token的数量
21     function allowance(address _owner, address _spender) constant public returns 
22     (uint256 remaining);
23 
24     //发生转账时必须要触发的事件 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
28     event Approval(address indexed _owner, address indexed _spender, uint256 
29     _value);
30     
31     event Burn(address indexed from, uint256 value);  //减去用户余额事件
32 }
33 
34 contract StandardToken is Token {
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         //默认totalSupply 不会超过最大值 (2^256 - 1).
37         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
38         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
39         require(balances[msg.sender] >= _value);
40         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
41         balances[_to] += _value;//往接收账户增加token数量_value
42         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
43         return true;
44     }
45 
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns 
48     (bool success) {
49         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
50         // _value && balances[_to] + _value > balances[_to]);
51         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
52         balances[_to] += _value;//接收账户增加token数量_value
53         balances[_from] -= _value; //支出账户_from减去token数量_value
54         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
55         emit Transfer(_from, _to, _value);//触发转币交易事件
56         return true;
57     }
58     function balanceOf(address _owner) constant public returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62 
63     function approve(address _spender, uint256 _value) public returns (bool success)   
64     {
65         allowed[msg.sender][_spender] = _value;
66         emit Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70 
71     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
72         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
73     }
74     
75     
76     /**
77      * 减少代币调用者的余额
78      *
79      * 操作以后是不可逆的
80      *
81      * @param _value 要删除的数量
82      */
83     function burn(uint256 _value) public returns (bool success) {
84         //检查帐户余额是否大于要减去的值
85         require(balances[msg.sender] >= _value);   // Check if the sender has enough
86 
87         //给指定帐户减去余额
88         balances[msg.sender] -= _value;
89 
90         //代币问题做相应扣除
91         totalSupply -= _value;
92 
93         emit Burn(msg.sender, _value);
94         return true;
95     }
96 
97     /**
98      * 删除帐户的余额（含其他帐户）
99      *
100      * 删除以后是不可逆的
101      *
102      * @param _from 要操作的帐户地址
103      * @param _value 要减去的数量
104      */
105     function burnFrom(address _from, uint256 _value) public returns (bool success) {
106 
107         //检查帐户余额是否大于要减去的值
108         require(balances[_from] >= _value);
109 
110         //检查 其他帐户 的余额是否够使用
111         require(_value <= allowed[_from][msg.sender]);
112 
113         //减掉代币
114         balances[_from] -= _value;
115         allowed[_from][msg.sender] -= _value;
116 
117         //更新总量
118         totalSupply -= _value;
119         emit Burn(_from, _value);
120         return true;
121     }
122     
123     mapping (address => uint256) balances;
124     mapping (address => mapping (address => uint256)) allowed;
125 }
126 
127 // ERC20 standard token
128 contract MUSD is StandardToken{
129     
130     address public admin; // 管理员
131     string public name = "CHINA MOROCCO MERCANTILE EXCHANGE CLIENT TRUST ACCOUNT"; // 代币名称
132     string public symbol = "MUSD"; // 代币符号
133     uint8 public decimals = 18; // 代币精度
134     uint256 public INITIAL_SUPPLY = 10000000000000000000000000; // 总量80亿 *10^18
135     // 同一个账户满足任意冻结条件均被冻结
136     mapping (address => bool) public frozenAccount; //无限期冻结的账户
137     mapping (address => uint256) public frozenTimestamp; // 有限期冻结的账户
138 
139     bool public exchangeFlag = true; // 代币兑换开启
140     // 不满足条件或募集完成多出的eth均返回给原账户
141     uint256 public minWei = 1;  //最低打 1 wei  1eth = 1*10^18 wei
142     uint256 public maxWei = 20000000000000000000000; // 最多一次打 20000 eth
143     uint256 public maxRaiseAmount = 20000000000000000000000; // 募集上限 20000 eth
144     uint256 public raisedAmount = 0; // 已募集 0 eth
145     uint256 public raiseRatio = 200000; // 兑换比例 1eth = 20万token
146     // event 通知
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     // 构造函数
151     constructor() public {
152         totalSupply = INITIAL_SUPPLY;
153         admin = msg.sender;
154         balances[msg.sender] = INITIAL_SUPPLY;
155     }
156 
157     // fallback 向合约地址转账 or 调用非合约函数触发
158     // 代币自动兑换eth
159     function()
160     public payable {
161         require(msg.value > 0);
162         if (exchangeFlag) {
163             if (msg.value >= minWei && msg.value <= maxWei){
164                 if (raisedAmount < maxRaiseAmount) {
165                     uint256 valueNeed = msg.value;
166                     raisedAmount = raisedAmount + msg.value;
167                     if (raisedAmount > maxRaiseAmount) {
168                         uint256 valueLeft = raisedAmount - maxRaiseAmount;
169                         valueNeed = msg.value - valueLeft;
170                         msg.sender.transfer(valueLeft);
171                         raisedAmount = maxRaiseAmount;
172                     }
173                     if (raisedAmount >= maxRaiseAmount) {
174                         exchangeFlag = false;
175                     }
176                     // 已处理过精度 *10^18
177                     uint256 _value = valueNeed * raiseRatio;
178 
179                     require(_value <= balances[admin]);
180                     balances[admin] = balances[admin] - _value;
181                     balances[msg.sender] = balances[msg.sender] + _value;
182 
183                     emit Transfer(admin, msg.sender, _value);
184 
185                 }
186             } else {
187                 msg.sender.transfer(msg.value);
188             }
189         } else {
190             msg.sender.transfer(msg.value);
191         }
192     }
193 
194     /**
195     * 修改管理员
196     */
197     function changeAdmin(
198         address _newAdmin
199     )
200     public
201     returns (bool)  {
202         require(msg.sender == admin);
203         require(_newAdmin != address(0));
204         balances[_newAdmin] = balances[_newAdmin] + balances[admin];
205         balances[admin] = 0;
206         admin = _newAdmin;
207         return true;
208     }
209     /**
210     * 增发
211     */
212     function generateToken(
213         address _target,
214         uint256 _amount
215     )
216     public
217     returns (bool)  {
218         require(msg.sender == admin);
219         require(_target != address(0));
220         balances[_target] = balances[_target] + _amount;
221         totalSupply = totalSupply + _amount;
222         INITIAL_SUPPLY = totalSupply;
223         return true;
224     }
225 
226     // 从合约提现
227     // 只能提给管理员
228     function withdraw (
229         uint256 _amount
230     )
231     public
232     returns (bool) {
233         require(msg.sender == admin);
234         msg.sender.transfer(_amount);
235         return true;
236     }
237     /**
238     * 锁定账户
239     */
240     function freeze(
241         address _target,
242         bool _freeze
243     )
244     public
245     returns (bool) {
246         require(msg.sender == admin);
247         require(_target != address(0));
248         frozenAccount[_target] = _freeze;
249         return true;
250     }
251     /**
252     * 通过时间戳锁定账户
253     */
254     function freezeWithTimestamp(
255         address _target,
256         uint256 _timestamp
257     )
258     public
259     returns (bool) {
260         require(msg.sender == admin);
261         require(_target != address(0));
262         frozenTimestamp[_target] = _timestamp;
263         return true;
264     }
265 
266     /**
267         * 批量锁定账户
268         */
269     function multiFreeze(
270         address[] _targets,
271         bool[] _freezes
272     )
273     public
274     returns (bool) {
275         require(msg.sender == admin);
276         require(_targets.length == _freezes.length);
277         uint256 len = _targets.length;
278         require(len > 0);
279         for (uint256 i = 0; i < len; i += 1) {
280             address _target = _targets[i];
281             require(_target != address(0));
282             bool _freeze = _freezes[i];
283             frozenAccount[_target] = _freeze;
284         }
285         return true;
286     }
287     /**
288             * 批量通过时间戳锁定账户
289             */
290     function multiFreezeWithTimestamp(
291         address[] _targets,
292         uint256[] _timestamps
293     )
294     public
295     returns (bool) {
296         require(msg.sender == admin);
297         require(_targets.length == _timestamps.length);
298         uint256 len = _targets.length;
299         require(len > 0);
300         for (uint256 i = 0; i < len; i += 1) {
301             address _target = _targets[i];
302             require(_target != address(0));
303             uint256 _timestamp = _timestamps[i];
304             frozenTimestamp[_target] = _timestamp;
305         }
306         return true;
307     }
308     /**
309     * 批量转账
310     */
311     function multiTransfer(
312         address[] _tos,
313         uint256[] _values
314     )
315     public
316     returns (bool) {
317         require(!frozenAccount[msg.sender]);
318         require(now > frozenTimestamp[msg.sender]);
319         require(_tos.length == _values.length);
320         uint256 len = _tos.length;
321         require(len > 0);
322         uint256 amount = 0;
323         for (uint256 i = 0; i < len; i += 1) {
324             amount = amount + _values[i];
325         }
326         require(amount <= balances[msg.sender]);
327         for (uint256 j = 0; j < len; j += 1) {
328             address _to = _tos[j];
329             require(_to != address(0));
330             balances[_to] = balances[_to] + _values[j];
331             balances[msg.sender] = balances[msg.sender] - _values[j];
332             emit Transfer(msg.sender, _to, _values[j]);
333         }
334         return true;
335     }
336     /**
337     * 从调用者转账至_to
338     */
339     function transfer(
340         address _to,
341         uint256 _value
342     )
343     public
344     returns (bool) {
345         require(!frozenAccount[msg.sender]);
346         require(now > frozenTimestamp[msg.sender]);
347         require(_to != address(0));
348         require(_value <= balances[msg.sender]);
349 
350         balances[msg.sender] = balances[msg.sender] - _value;
351         balances[_to] = balances[_to] + _value;
352 
353         emit Transfer(msg.sender, _to, _value);
354         return true;
355     }
356     /*
357     * 从调用者作为from代理将from账户中的token转账至to
358     * 调用者在from的许可额度中必须>=value
359     */
360     function transferFrom(
361         address _from,
362         address _to,
363         uint256 _value
364     )
365     public
366     returns (bool)
367     {
368         require(!frozenAccount[_from]);
369         require(now > frozenTimestamp[msg.sender]);
370         require(_to != address(0));
371         require(_value <= balances[_from]);
372         require(_value <= allowed[_from][msg.sender]);
373 
374         balances[_from] = balances[_from] - _value;
375         balances[_to] = balances[_to] + _value;
376         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
377 
378         emit Transfer(_from, _to, _value);
379         return true;
380     }
381     /**
382     * 调整转账代理方spender的代理的许可额度
383     */
384     function approve(
385         address _spender,
386         uint256 _value
387     ) public
388     returns (bool) {
389         // 转账的时候会校验balances，该处require无意义
390         // require(_value <= balances[msg.sender]);
391 
392         allowed[msg.sender][_spender] = _value;
393 
394         emit Approval(msg.sender, _spender, _value);
395         return true;
396     }
397     /**
398     * 增加转账代理方spender的代理的许可额度
399     * 意义不大的function
400     */
401     // function increaseApproval(
402     //     address _spender,
403     //     uint256 _addedValue
404     // )
405     // public
406     // returns (bool)
407     // {
408     //     // uint256 value_ = allowed[msg.sender][_spender].add(_addedValue);
409     //     // require(value_ <= balances[msg.sender]);
410     //     // allowed[msg.sender][_spender] = value_;
411 
412     //     // emit Approval(msg.sender, _spender, value_);
413     //     return true;
414     // }
415     /**
416     * 减少转账代理方spender的代理的许可额度
417     * 意义不大的function
418     */
419     // function decreaseApproval(
420     //     address _spender,
421     //     uint256 _subtractedValue
422     // )
423     // public
424     // returns (bool)
425     // {
426     //     // uint256 oldValue = allowed[msg.sender][_spender];
427     //     // if (_subtractedValue > oldValue) {
428     //     //    allowed[msg.sender][_spender] = 0;
429     //     // } else {
430     //     //    uint256 newValue = oldValue.sub(_subtractedValue);
431     //     //    require(newValue <= balances[msg.sender]);
432     //     //   allowed[msg.sender][_spender] = newValue;
433     //     //}
434 
435     //     // emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
436     //     return true;
437     // }
438 
439     //********************************************************************************
440     //查询账户是否存在锁定时间戳
441     function getFrozenTimestamp(
442         address _target
443     )
444     public view
445     returns (uint256) {
446         require(_target != address(0));
447         return frozenTimestamp[_target];
448     }
449     //查询账户是否被锁定
450     function getFrozenAccount(
451         address _target
452     )
453     public view
454     returns (bool) {
455         require(_target != address(0));
456         return frozenAccount[_target];
457     }
458     //查询合约的余额
459     function getBalance()
460     public view
461     returns (uint256) {
462         return address(this).balance;
463     }
464     // 修改name
465     function setName (
466         string _value
467     )
468     public
469     returns (bool) {
470         require(msg.sender == admin);
471         name = _value;
472         return true;
473     }
474     // 修改symbol
475     function setSymbol (
476         string _value
477     )
478     public
479     returns (bool) {
480         require(msg.sender == admin);
481         symbol = _value;
482         return true;
483     }
484 
485     // 修改募集flag
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
496     // 修改单笔募集下限
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
507     // 修改单笔募集上限
508     function setMaxWei (
509         uint256 _value
510     )
511     public
512     returns (bool) {
513         require(msg.sender == admin);
514         maxWei = _value;
515         return true;
516     }
517     // 修改总募集上限
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
528     // 修改已募集数
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
539     // 修改募集比例
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
550     // 销毁合约
551     function kill()
552     public {
553         require(msg.sender == admin);
554         selfdestruct(admin);
555     }
556 
557 }