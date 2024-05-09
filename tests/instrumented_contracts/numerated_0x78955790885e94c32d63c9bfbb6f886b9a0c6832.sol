1 /**
2  *KYB是KY POOL矿池权益代币，KY POOL是一个有着坚实实体区块链挖矿资源的项目，
3  * KY POOL隶属于FlyChain基金会，KYB是基于以太坊Ethereum的去中心化的区块链数字资产，
4  * 发行总量恒定10亿个，每个阶段根据矿池运营的情况对KYB进行回购，用户可通过区块链浏览器查询，
5  * 确保公开透明，KYB作为矿池生态唯一的价值流通通证，KYB与业内最大的存储矿机厂商矿爷合作，
6  * 致力于构建分布于亚洲乃至全球最大最稳定、高效、高产的存储矿池。
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 
12 
13 library SafeMath {
14 
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25 
26   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27     return _a / _b;
28   }
29 
30 
31   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     assert(_b <= _a);
33     return _a - _b;
34   }
35 
36 
37   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
38     c = _a + _b;
39     assert(c >= _a);
40     return c;
41   }
42 }
43 
44 
45 
46 
47 library FrozenChecker {
48 
49     using SafeMath for uint256;
50 
51     struct Rule {
52         uint256 timeT;
53         uint8 initPercent;
54         uint256[] periods;
55         uint8[] percents;
56     }
57 
58     function check(Rule storage self, uint256 totalFrozenValue) internal view returns (uint256) {
59         if (totalFrozenValue == uint256(0)) {
60             return 0;
61         }
62         //uint8 temp = self.initPercent;
63         if (self.timeT == uint256(0) || self.timeT > now) {
64             return totalFrozenValue.sub(totalFrozenValue.mul(self.initPercent).div(100));
65         }
66         for (uint256 i = 0; i < self.periods.length.sub(1); i = i.add(1)) {
67             if (now >= self.timeT.add(self.periods[i]) && now < self.timeT.add(self.periods[i.add(1)])) {
68                 return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[i]).div(100));
69             }
70         }
71         if (now >= self.timeT.add(self.periods[self.periods.length.sub(1)])) {
72             return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[self.periods.length.sub(1)]).div(100));
73         }
74     }
75 
76 }
77 
78 
79 
80 library FrozenValidator {
81     
82     using SafeMath for uint256;
83     using FrozenChecker for FrozenChecker.Rule;
84 
85     struct Validator {
86         mapping(address => IndexValue) data;
87         KeyFlag[] keys;
88         uint256 size;
89     }
90 
91     struct IndexValue {
92         uint256 keyIndex; 
93         FrozenChecker.Rule rule;
94         mapping (address => uint256) frozenBalances;
95     }
96 
97     struct KeyFlag { 
98         address key; 
99         bool deleted; 
100     }
101 
102     function addRule(Validator storage self, address key, uint8 initPercent, uint256[] periods, uint8[] percents) internal returns (bool replaced) {
103         //require(self.size <= 10);
104         require(key != address(0));
105         require(periods.length == percents.length);
106         require(periods.length > 0);
107         require(periods[0] == uint256(0));
108         require(initPercent <= percents[0]);
109         for (uint256 i = 1; i < periods.length; i = i.add(1)) {
110             require(periods[i.sub(1)] < periods[i]);
111             require(percents[i.sub(1)] <= percents[i]);
112         }
113         require(percents[percents.length.sub(1)] == 100);
114         FrozenChecker.Rule memory rule = FrozenChecker.Rule(0, initPercent, periods, percents);
115         uint256 keyIndex = self.data[key].keyIndex;
116         self.data[key].rule = rule;
117         if (keyIndex > 0) {
118             return true;
119         } else {
120             keyIndex = self.keys.length++;
121             self.data[key].keyIndex = keyIndex.add(1);
122             self.keys[keyIndex].key = key;
123             self.size++;
124             return false;
125         }
126     }
127 
128     function removeRule(Validator storage self, address key) internal returns (bool success) {
129         uint256 keyIndex = self.data[key].keyIndex;
130         if (keyIndex == 0) {
131             return false;
132         }
133         delete self.data[key];
134         self.keys[keyIndex.sub(1)].deleted = true;
135         self.size--;
136         return true;
137     }
138 
139     function containRule(Validator storage self, address key) internal view returns (bool) {
140         return self.data[key].keyIndex > 0;
141     }
142 
143     function addTimeT(Validator storage self, address addr, uint256 timeT) internal returns (bool) {
144         require(timeT > now);
145         self.data[addr].rule.timeT = timeT;
146         return true;
147     }
148 
149     function addFrozenBalance(Validator storage self, address from, address to, uint256 value) internal returns (uint256) {
150         self.data[from].frozenBalances[to] = self.data[from].frozenBalances[to].add(value);
151         return self.data[from].frozenBalances[to];
152     }
153 
154     function validate(Validator storage self, address addr) internal view returns (uint256) {
155         uint256 frozenTotal = 0;
156         for (uint256 i = iterateStart(self); iterateValid(self, i); i = iterateNext(self, i)) {
157             address ruleaddr = iterateGet(self, i);
158             FrozenChecker.Rule storage rule = self.data[ruleaddr].rule;
159             frozenTotal = frozenTotal.add(rule.check(self.data[ruleaddr].frozenBalances[addr]));
160         }
161         return frozenTotal;
162     }
163 
164 
165     function iterateStart(Validator storage self) internal view returns (uint256 keyIndex) {
166         return iterateNext(self, uint256(-1));
167     }
168 
169     function iterateValid(Validator storage self, uint256 keyIndex) internal view returns (bool) {
170         return keyIndex < self.keys.length;
171     }
172 
173     function iterateNext(Validator storage self, uint256 keyIndex) internal view returns (uint256) {
174         keyIndex++;
175         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted) {
176             keyIndex++;
177         }
178         return keyIndex;
179     }
180 
181     function iterateGet(Validator storage self, uint256 keyIndex) internal view returns (address) {
182         return self.keys[keyIndex].key;
183     }
184 }
185 
186 
187 
188 contract KYPool {
189 
190     using SafeMath for uint256;
191     using FrozenValidator for FrozenValidator.Validator;
192 
193     mapping (address => uint256) internal balances;
194     mapping (address => mapping (address => uint256)) internal allowed;
195 
196     
197 
198     string public name;
199     string public symbol;
200     uint8 public decimals;
201     uint256 public totalSupply;
202 
203     
204 
205     address internal admin;  //Admin address
206 
207     
208     function changeAdmin(address newAdmin) public returns (bool)  {
209         require(msg.sender == admin);
210         require(newAdmin != address(0));
211         uint256 balAdmin = balances[admin];
212         balances[newAdmin] = balances[newAdmin].add(balAdmin);
213         balances[admin] = 0;
214         admin = newAdmin;
215         emit Transfer(admin, newAdmin, balAdmin);
216         return true;
217     }
218 
219     
220     
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 
224     
225     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 totalTokenSupply ) public {
226         name = tokenName;
227         symbol = tokenSymbol;
228         decimals = tokenDecimals;
229         totalSupply = totalTokenSupply;
230         admin = msg.sender;
231         balances[msg.sender] = totalTokenSupply;
232         emit Transfer(0x0, msg.sender, totalTokenSupply);
233 
234     }
235 
236     
237 
238     
239     mapping (address => bool) frozenAccount; 
240     mapping (address => uint256) frozenTimestamp; 
241 
242     
243     function getFrozenTimestamp(address _target) public view returns (uint256) {
244         return frozenTimestamp[_target];
245     }
246 
247     
248     function getFrozenAccount(address _target) public view returns (bool) {
249         return frozenAccount[_target];
250     }
251 
252     
253     function freeze(address _target, bool _freeze) public returns (bool) {
254         require(msg.sender == admin);
255         require(_target != admin);
256         frozenAccount[_target] = _freeze;
257         return true;
258     }
259 
260     
261     function freezeWithTimestamp(address _target, uint256 _timestamp) public returns (bool) {
262         require(msg.sender == admin);
263         require(_target != admin);
264         frozenTimestamp[_target] = _timestamp;
265         return true;
266     }
267 
268     
269     function multiFreeze(address[] _targets, bool[] _freezes) public returns (bool) {
270         require(msg.sender == admin);
271         require(_targets.length == _freezes.length);
272         uint256 len = _targets.length;
273         require(len > 0);
274         for (uint256 i = 0; i < len; i = i.add(1)) {
275             address _target = _targets[i];
276             require(_target != admin);
277             bool _freeze = _freezes[i];
278             frozenAccount[_target] = _freeze;
279         }
280         return true;
281     }
282 
283     
284     function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public returns (bool) {
285         require(msg.sender == admin);
286         require(_targets.length == _timestamps.length);
287         uint256 len = _targets.length;
288         require(len > 0);
289         for (uint256 i = 0; i < len; i = i.add(1)) {
290             address _target = _targets[i];
291             require(_target != admin);
292             uint256 _timestamp = _timestamps[i];
293             frozenTimestamp[_target] = _timestamp;
294         }
295         return true;
296     }
297 
298     
299 
300 
301 
302     FrozenValidator.Validator validator;
303 
304     function addRule(address addr, uint8 initPercent, uint256[] periods, uint8[] percents) public returns (bool) {
305         require(msg.sender == admin);
306         return validator.addRule(addr, initPercent, periods, percents);
307     }
308 
309     function addTimeT(address addr, uint256 timeT) public returns (bool) {
310         require(msg.sender == admin);
311         return validator.addTimeT(addr, timeT);
312     }
313 
314     function removeRule(address addr) public returns (bool) {
315         require(msg.sender == admin);
316         return validator.removeRule(addr);
317     }
318 
319     
320 
321 
322 
323 
324     function multiTransfer(address[] _tos, uint256[] _values) public returns (bool) {
325         require(!frozenAccount[msg.sender]);
326         require(now > frozenTimestamp[msg.sender]);
327         require(_tos.length == _values.length);
328         uint256 len = _tos.length;
329         require(len > 0);
330         uint256 amount = 0;
331         for (uint256 i = 0; i < len; i = i.add(1)) {
332             amount = amount.add(_values[i]);
333         }
334         require(amount <= balances[msg.sender].sub(validator.validate(msg.sender)));
335         for (uint256 j = 0; j < len; j = j.add(1)) {
336             address _to = _tos[j];
337             if (validator.containRule(msg.sender) && msg.sender != _to) {
338                 validator.addFrozenBalance(msg.sender, _to, _values[j]);
339             }
340             balances[_to] = balances[_to].add(_values[j]);
341             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
342             emit Transfer(msg.sender, _to, _values[j]);
343         }
344         return true;
345     }
346 
347     function transfer(address _to, uint256 _value) public returns (bool) {
348         transferfix(_to, _value);
349         return true;
350     }
351 
352     function transferfix(address _to, uint256 _value) public {
353         require(!frozenAccount[msg.sender]);
354         require(now > frozenTimestamp[msg.sender]);
355         require(balances[msg.sender].sub(_value) >= validator.validate(msg.sender));
356 
357         if (validator.containRule(msg.sender) && msg.sender != _to) {
358             validator.addFrozenBalance(msg.sender, _to, _value);
359         }
360         balances[msg.sender] = balances[msg.sender].sub(_value);
361         balances[_to] = balances[_to].add(_value);
362 
363         emit Transfer(msg.sender, _to, _value);
364     }
365 
366     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
367         require(!frozenAccount[_from]);
368         require(now > frozenTimestamp[_from]);
369         require(_value <= balances[_from].sub(validator.validate(_from)));
370         require(_value <= allowed[_from][msg.sender]);
371 
372         if (validator.containRule(_from) && _from != _to) {
373             validator.addFrozenBalance(_from, _to, _value);
374         }
375 
376         balances[_from] = balances[_from].sub(_value);
377         balances[_to] = balances[_to].add(_value);
378         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
379 
380         emit Transfer(_from, _to, _value);
381         return true;
382     }
383 
384     function approve(address _spender, uint256 _value) public returns (bool) {
385         allowed[msg.sender][_spender] = _value;
386 
387         emit Approval(msg.sender, _spender, _value);
388         return true;
389     }
390 
391     function allowance(address _owner, address _spender) public view returns (uint256) {
392         return allowed[_owner][_spender];
393     }
394 
395     
396     
397     function balanceOf(address _owner) public view returns (uint256) {
398         return balances[_owner]; 
399     }
400 
401     
402 
403     function kill() public {
404         require(msg.sender == admin);
405         selfdestruct(admin);
406     }
407 
408 }