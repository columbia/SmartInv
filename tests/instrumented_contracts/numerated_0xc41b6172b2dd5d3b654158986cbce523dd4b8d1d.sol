1 pragma solidity ^0.4.24;
2 
3 contract Token{
4     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
5     uint256 public totalSupply;
6 
7     /// 获取账户_owner拥有token的数量 
8     function balanceOf(address _owner) constant returns (uint256 balance);
9 
10     //从消息发送者账户中往_to账户转数量为_value的token
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
14     function transferFrom(address _from, address _to, uint256 _value) returns   
15     (bool success);
16 
17     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
18     function approve(address _spender, uint256 _value) returns (bool success);
19 
20     //获取账户_spender可以从账户_owner中转出token的数量
21     function allowance(address _owner, address _spender) constant returns 
22     (uint256 remaining);
23 
24     //发生转账时必须要触发的事件 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
28     event Approval(address indexed _owner, address indexed _spender, uint256 
29     _value);
30 }
31 
32 contract StandardToken is Token {
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         //默认totalSupply 不会超过最大值 (2^256 - 1).
35         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
36         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
37         require(balances[msg.sender] >= _value);
38         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
39         balances[_to] += _value;//往接收账户增加token数量_value
40         Transfer(msg.sender, _to, _value);//触发转币交易事件
41         return true;
42     }
43 
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns 
46     (bool success) {
47         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
48         // _value && balances[_to] + _value > balances[_to]);
49         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
50         balances[_to] += _value;//接收账户增加token数量_value
51         balances[_from] -= _value; //支出账户_from减去token数量_value
52         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
53         Transfer(_from, _to, _value);//触发转币交易事件
54         return true;
55     }
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60 
61     function approve(address _spender, uint256 _value) returns (bool success)   
62     {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68 
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
71     }
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 }
75 
76 // ERC20 standard token
77 contract MUSD is StandardToken{
78     
79     address public admin; // 管理员
80     string public name = "CHINA MOROCCO MERCANTILE EXCHANGE"; // 代币名称
81     string public symbol = "MUSD"; // 代币符号
82     uint8 public decimals = 18; // 代币精度
83     uint256 public INITIAL_SUPPLY = 10000000000000000000000000; // 总量80亿 *10^18
84     // 同一个账户满足任意冻结条件均被冻结
85     mapping (address => bool) public frozenAccount; //无限期冻结的账户
86     mapping (address => uint256) public frozenTimestamp; // 有限期冻结的账户
87 
88     bool public exchangeFlag = true; // 代币兑换开启
89     // 不满足条件或募集完成多出的eth均返回给原账户
90     uint256 public minWei = 1;  //最低打 1 wei  1eth = 1*10^18 wei
91     uint256 public maxWei = 20000000000000000000000; // 最多一次打 20000 eth
92     uint256 public maxRaiseAmount = 20000000000000000000000; // 募集上限 20000 eth
93     uint256 public raisedAmount = 0; // 已募集 0 eth
94     uint256 public raiseRatio = 200000; // 兑换比例 1eth = 20万token
95     // event 通知
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     // 构造函数
100     constructor() public {
101         totalSupply = INITIAL_SUPPLY;
102         admin = msg.sender;
103         balances[msg.sender] = INITIAL_SUPPLY;
104     }
105 
106     // fallback 向合约地址转账 or 调用非合约函数触发
107     // 代币自动兑换eth
108     function()
109     public payable {
110         require(msg.value > 0);
111         if (exchangeFlag) {
112             if (msg.value >= minWei && msg.value <= maxWei){
113                 if (raisedAmount < maxRaiseAmount) {
114                     uint256 valueNeed = msg.value;
115                     raisedAmount = raisedAmount + msg.value;
116                     if (raisedAmount > maxRaiseAmount) {
117                         uint256 valueLeft = raisedAmount - maxRaiseAmount;
118                         valueNeed = msg.value - valueLeft;
119                         msg.sender.transfer(valueLeft);
120                         raisedAmount = maxRaiseAmount;
121                     }
122                     if (raisedAmount >= maxRaiseAmount) {
123                         exchangeFlag = false;
124                     }
125                     // 已处理过精度 *10^18
126                     uint256 _value = valueNeed * raiseRatio;
127 
128                     require(_value <= balances[admin]);
129                     balances[admin] = balances[admin] - _value;
130                     balances[msg.sender] = balances[msg.sender] + _value;
131 
132                     emit Transfer(admin, msg.sender, _value);
133 
134                 }
135             } else {
136                 msg.sender.transfer(msg.value);
137             }
138         } else {
139             msg.sender.transfer(msg.value);
140         }
141     }
142 
143     /**
144     * 修改管理员
145     */
146     function changeAdmin(
147         address _newAdmin
148     )
149     public
150     returns (bool)  {
151         require(msg.sender == admin);
152         require(_newAdmin != address(0));
153         balances[_newAdmin] = balances[_newAdmin] + balances[admin];
154         balances[admin] = 0;
155         admin = _newAdmin;
156         return true;
157     }
158     /**
159     * 增发
160     */
161     function generateToken(
162         address _target,
163         uint256 _amount
164     )
165     public
166     returns (bool)  {
167         require(msg.sender == admin);
168         require(_target != address(0));
169         balances[_target] = balances[_target] + _amount;
170         totalSupply = totalSupply + _amount;
171         INITIAL_SUPPLY = totalSupply;
172         return true;
173     }
174 
175     // 从合约提现
176     // 只能提给管理员
177     function withdraw (
178         uint256 _amount
179     )
180     public
181     returns (bool) {
182         require(msg.sender == admin);
183         msg.sender.transfer(_amount);
184         return true;
185     }
186     /**
187     * 锁定账户
188     */
189     function freeze(
190         address _target,
191         bool _freeze
192     )
193     public
194     returns (bool) {
195         require(msg.sender == admin);
196         require(_target != address(0));
197         frozenAccount[_target] = _freeze;
198         return true;
199     }
200     /**
201     * 通过时间戳锁定账户
202     */
203     function freezeWithTimestamp(
204         address _target,
205         uint256 _timestamp
206     )
207     public
208     returns (bool) {
209         require(msg.sender == admin);
210         require(_target != address(0));
211         frozenTimestamp[_target] = _timestamp;
212         return true;
213     }
214 
215     /**
216         * 批量锁定账户
217         */
218     function multiFreeze(
219         address[] _targets,
220         bool[] _freezes
221     )
222     public
223     returns (bool) {
224         require(msg.sender == admin);
225         require(_targets.length == _freezes.length);
226         uint256 len = _targets.length;
227         require(len > 0);
228         for (uint256 i = 0; i < len; i += 1) {
229             address _target = _targets[i];
230             require(_target != address(0));
231             bool _freeze = _freezes[i];
232             frozenAccount[_target] = _freeze;
233         }
234         return true;
235     }
236     /**
237             * 批量通过时间戳锁定账户
238             */
239     function multiFreezeWithTimestamp(
240         address[] _targets,
241         uint256[] _timestamps
242     )
243     public
244     returns (bool) {
245         require(msg.sender == admin);
246         require(_targets.length == _timestamps.length);
247         uint256 len = _targets.length;
248         require(len > 0);
249         for (uint256 i = 0; i < len; i += 1) {
250             address _target = _targets[i];
251             require(_target != address(0));
252             uint256 _timestamp = _timestamps[i];
253             frozenTimestamp[_target] = _timestamp;
254         }
255         return true;
256     }
257     /**
258     * 批量转账
259     */
260     function multiTransfer(
261         address[] _tos,
262         uint256[] _values
263     )
264     public
265     returns (bool) {
266         require(!frozenAccount[msg.sender]);
267         require(now > frozenTimestamp[msg.sender]);
268         require(_tos.length == _values.length);
269         uint256 len = _tos.length;
270         require(len > 0);
271         uint256 amount = 0;
272         for (uint256 i = 0; i < len; i += 1) {
273             amount = amount + _values[i];
274         }
275         require(amount <= balances[msg.sender]);
276         for (uint256 j = 0; j < len; j += 1) {
277             address _to = _tos[j];
278             require(_to != address(0));
279             balances[_to] = balances[_to] + _values[j];
280             balances[msg.sender] = balances[msg.sender] - _values[j];
281             emit Transfer(msg.sender, _to, _values[j]);
282         }
283         return true;
284     }
285     /**
286     * 从调用者转账至_to
287     */
288     function transfer(
289         address _to,
290         uint256 _value
291     )
292     public
293     returns (bool) {
294         require(!frozenAccount[msg.sender]);
295         require(now > frozenTimestamp[msg.sender]);
296         require(_to != address(0));
297         require(_value <= balances[msg.sender]);
298 
299         balances[msg.sender] = balances[msg.sender] - _value;
300         balances[_to] = balances[_to] + _value;
301 
302         emit Transfer(msg.sender, _to, _value);
303         return true;
304     }
305     /*
306     * 从调用者作为from代理将from账户中的token转账至to
307     * 调用者在from的许可额度中必须>=value
308     */
309     function transferFrom(
310         address _from,
311         address _to,
312         uint256 _value
313     )
314     public
315     returns (bool)
316     {
317         require(!frozenAccount[_from]);
318         require(now > frozenTimestamp[msg.sender]);
319         require(_to != address(0));
320         require(_value <= balances[_from]);
321         require(_value <= allowed[_from][msg.sender]);
322 
323         balances[_from] = balances[_from] - _value;
324         balances[_to] = balances[_to] + _value;
325         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
326 
327         emit Transfer(_from, _to, _value);
328         return true;
329     }
330     /**
331     * 调整转账代理方spender的代理的许可额度
332     */
333     function approve(
334         address _spender,
335         uint256 _value
336     ) public
337     returns (bool) {
338         // 转账的时候会校验balances，该处require无意义
339         // require(_value <= balances[msg.sender]);
340 
341         allowed[msg.sender][_spender] = _value;
342 
343         emit Approval(msg.sender, _spender, _value);
344         return true;
345     }
346     /**
347     * 增加转账代理方spender的代理的许可额度
348     * 意义不大的function
349     */
350     function increaseApproval(
351         address _spender,
352         uint256 _addedValue
353     )
354     public
355     returns (bool)
356     {
357         // uint256 value_ = allowed[msg.sender][_spender].add(_addedValue);
358         // require(value_ <= balances[msg.sender]);
359         // allowed[msg.sender][_spender] = value_;
360 
361         // emit Approval(msg.sender, _spender, value_);
362         return true;
363     }
364     /**
365     * 减少转账代理方spender的代理的许可额度
366     * 意义不大的function
367     */
368     function decreaseApproval(
369         address _spender,
370         uint256 _subtractedValue
371     )
372     public
373     returns (bool)
374     {
375         // uint256 oldValue = allowed[msg.sender][_spender];
376         // if (_subtractedValue > oldValue) {
377         //    allowed[msg.sender][_spender] = 0;
378         // } else {
379         //    uint256 newValue = oldValue.sub(_subtractedValue);
380         //    require(newValue <= balances[msg.sender]);
381         //   allowed[msg.sender][_spender] = newValue;
382         //}
383 
384         // emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385         return true;
386     }
387 
388     //********************************************************************************
389     //查询账户是否存在锁定时间戳
390     function getFrozenTimestamp(
391         address _target
392     )
393     public view
394     returns (uint256) {
395         require(_target != address(0));
396         return frozenTimestamp[_target];
397     }
398     //查询账户是否被锁定
399     function getFrozenAccount(
400         address _target
401     )
402     public view
403     returns (bool) {
404         require(_target != address(0));
405         return frozenAccount[_target];
406     }
407     //查询合约的余额
408     function getBalance()
409     public view
410     returns (uint256) {
411         return address(this).balance;
412     }
413     // 修改name
414     function setName (
415         string _value
416     )
417     public
418     returns (bool) {
419         require(msg.sender == admin);
420         name = _value;
421         return true;
422     }
423     // 修改symbol
424     function setSymbol (
425         string _value
426     )
427     public
428     returns (bool) {
429         require(msg.sender == admin);
430         symbol = _value;
431         return true;
432     }
433 
434     // 修改募集flag
435     function setExchangeFlag (
436         bool _flag
437     )
438     public
439     returns (bool) {
440         require(msg.sender == admin);
441         exchangeFlag = _flag;
442         return true;
443 
444     }
445     // 修改单笔募集下限
446     function setMinWei (
447         uint256 _value
448     )
449     public
450     returns (bool) {
451         require(msg.sender == admin);
452         minWei = _value;
453         return true;
454 
455     }
456     // 修改单笔募集上限
457     function setMaxWei (
458         uint256 _value
459     )
460     public
461     returns (bool) {
462         require(msg.sender == admin);
463         maxWei = _value;
464         return true;
465     }
466     // 修改总募集上限
467     function setMaxRaiseAmount (
468         uint256 _value
469     )
470     public
471     returns (bool) {
472         require(msg.sender == admin);
473         maxRaiseAmount = _value;
474         return true;
475     }
476 
477     // 修改已募集数
478     function setRaisedAmount (
479         uint256 _value
480     )
481     public
482     returns (bool) {
483         require(msg.sender == admin);
484         raisedAmount = _value;
485         return true;
486     }
487 
488     // 修改募集比例
489     function setRaiseRatio (
490         uint256 _value
491     )
492     public
493     returns (bool) {
494         require(msg.sender == admin);
495         raiseRatio = _value;
496         return true;
497     }
498 
499     // 销毁合约
500     function kill()
501     public {
502         require(msg.sender == admin);
503         selfdestruct(admin);
504     }
505 
506 }