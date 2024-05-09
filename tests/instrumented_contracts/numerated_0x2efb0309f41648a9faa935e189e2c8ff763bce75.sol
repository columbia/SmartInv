1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Global Mobile Industry Service Ecosystem Chain 
6  * @dev Developed By Jack 5/15 2018 
7  * @dev contact:jack.koe@gmail.com
8  */
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a / b;
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41     function Ownable() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function isOwner() internal view returns(bool success) {
51         if (msg.sender == owner) return true;
52         return false;
53     }
54 
55     function transferOwnership(address newOwner) onlyOwner public {
56         require(newOwner != address(0));
57         OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59     }
60 }
61 
62 /**
63  * @title ERC20Basic
64  * @dev see https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67     uint256 public totalSupply;
68     function balanceOf(address who) public view returns (uint256);
69     function transfer(address to, uint256 value) public returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public view returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92 
93     function transfer(address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106 }
107 
108 /**
109  * @title Standard ERC20 token
110  * @dev Implementation of the basic standard token.
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114     mapping (address => mapping (address => uint256)) internal allowed;
115 
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[_from]);
119         require(_value <= allowed[_from][msg.sender]);
120 
121         balances[_from] = balances[_from].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124         Transfer(_from, _to, _value);
125         return true;
126     }
127 
128     function approve(address _spender, uint256 _value) public returns (bool) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) public view returns (uint256) {
135         return allowed[_owner][_spender];
136     }
137 
138     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141         return true;
142     }
143 
144     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145         uint oldValue = allowed[msg.sender][_spender];
146         if (_subtractedValue > oldValue) {
147             allowed[msg.sender][_spender] = 0;
148         } else {
149             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150         }
151         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153     }
154 }
155 
156 contract MSCE is Ownable, StandardToken {
157     using SafeMath for uint256;
158 
159     uint8 public constant TOKEN_DECIMALS = 18;
160 
161     string public name = "Mobile Ecosystem"; 
162     string public symbol = "MSCE";
163     uint8 public decimals = TOKEN_DECIMALS;
164 
165 
166     uint256 public totalSupply = 500000000 *(10**uint256(TOKEN_DECIMALS)); 
167     uint256 public soldSupply = 0; 
168     uint256 public sellSupply = 0; 
169     uint256 public buySupply = 0; 
170     bool public stopSell = true;
171     bool public stopBuy = false;
172 
173     uint256 public crowdsaleStartTime = block.timestamp;
174     uint256 public crowdsaleEndTime = 1526831999;
175 
176     uint256 public crowdsaleTotal = 2000*40000*(10**18);
177 
178 
179     uint256 public buyExchangeRate = 40000;   
180     uint256 public sellExchangeRate = 100000;  
181     address public ethFundDeposit;  
182 
183 
184     bool public allowTransfers = true; 
185 
186 
187     mapping (address => bool) public frozenAccount;
188 
189     bool public enableInternalLock = true; 
190     mapping (address => bool) public internalLockAccount;
191 
192     mapping (address => uint256) public releaseLockAccount;
193 
194 
195     event FrozenFunds(address target, bool frozen);
196     event IncreaseSoldSaleSupply(uint256 _value);
197     event DecreaseSoldSaleSupply(uint256 _value);
198 
199     function MSCE() public {
200 
201 
202         balances[msg.sender] = totalSupply;             
203 
204         ethFundDeposit = msg.sender;                      
205         allowTransfers = true;
206     }
207 
208     function _isUserInternalLock() internal view returns (bool) {
209 
210         return getAccountLockState(msg.sender);
211 
212     }
213 
214     function increaseSoldSaleSupply (uint256 _value) onlyOwner public {
215         require (_value + soldSupply < totalSupply);
216         soldSupply = soldSupply.add(_value);
217         IncreaseSoldSaleSupply(_value);
218     }
219 
220     function decreaseSoldSaleSupply (uint256 _value) onlyOwner public {
221         require (soldSupply - _value > 0);
222         soldSupply = soldSupply.sub(_value);
223         DecreaseSoldSaleSupply(_value);
224     }
225 
226     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
227         balances[target] = balances[target].add(mintedAmount);
228         totalSupply = totalSupply.add(mintedAmount);
229         Transfer(0, this, mintedAmount);
230         Transfer(this, target, mintedAmount);
231     }
232 
233     function destroyToken(address target, uint256 amount) onlyOwner public {
234         balances[target] = balances[target].sub(amount);
235         totalSupply = totalSupply.sub(amount);
236         Transfer(target, this, amount);
237         Transfer(this, 0, amount);
238     }
239 
240 
241     function freezeAccount(address target, bool freeze) onlyOwner public {
242         frozenAccount[target] = freeze;
243         FrozenFunds(target, freeze);
244     }
245 
246 
247     function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {
248         require(_ethFundDeposit != address(0));
249         ethFundDeposit = _ethFundDeposit;
250     }
251 
252     function transferETH() onlyOwner public {
253         require(ethFundDeposit != address(0));
254         require(this.balance != 0);
255         require(ethFundDeposit.send(this.balance));
256     }
257 
258 
259     function setExchangeRate(uint256 _sellExchangeRate, uint256 _buyExchangeRate) onlyOwner public {
260         sellExchangeRate = _sellExchangeRate;
261         buyExchangeRate = _buyExchangeRate;
262     }
263 
264     function setExchangeStatus(bool _stopSell, bool _stopBuy) onlyOwner public {
265         stopSell = _stopSell;
266         stopBuy = _stopBuy;
267     }
268 
269     function setName(string _name) onlyOwner public {
270         name = _name;
271     }
272 
273     function setSymbol(string _symbol) onlyOwner public {
274         symbol = _symbol;
275     }
276 
277     function setAllowTransfers(bool _allowTransfers) onlyOwner public {
278         allowTransfers = _allowTransfers;
279     }
280 
281     function transferFromAdmin(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
282         require(_to != address(0));
283         require(_value <= balances[_from]);
284 
285         balances[_from] = balances[_from].sub(_value);
286         balances[_to] = balances[_to].add(_value);
287         Transfer(_from, _to, _value);
288         return true;
289     }
290 
291     function setEnableInternalLock(bool _isEnable) onlyOwner public {
292         enableInternalLock = _isEnable;
293     }
294 
295     function lockInternalAccount(address _target, bool _lock, uint256 _releaseTime) onlyOwner public {
296         require(_target != address(0));
297 
298         internalLockAccount[_target] = _lock;
299         releaseLockAccount[_target] = _releaseTime;
300 
301     }
302 
303     function getAccountUnlockTime(address _target) public view returns(uint256) {
304 
305         return releaseLockAccount[_target];
306 
307     }
308     function getAccountLockState(address _target) public view returns(bool) {
309         if(enableInternalLock && internalLockAccount[_target]){
310             if((releaseLockAccount[_target] > 0)&&(releaseLockAccount[_target]<block.timestamp)){       
311                 return false;
312             }          
313             return true;
314         }
315         return false;
316 
317     }
318 
319     function internalSellTokenFromAdmin(address _to, uint256 _value, bool _lock, uint256 _releaseTime) onlyOwner public returns (bool) {
320         require(_to != address(0));
321         require(_value <= balances[owner]);
322 
323         balances[owner] = balances[owner].sub(_value);
324         balances[_to] = balances[_to].add(_value);
325         soldSupply = soldSupply.add(_value);
326         sellSupply = sellSupply.add(_value);
327 
328         Transfer(owner, _to, _value);
329         
330         lockInternalAccount(_to, _lock, _releaseTime);
331 
332         return true;
333     }
334 
335     /***************************************************/
336     /*              BASE Functions                     */
337     /***************************************************/
338 
339     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
340         if (!isOwner()) {
341             require (allowTransfers);
342             require(!frozenAccount[_from]);                                         
343             require(!frozenAccount[_to]);                                        
344             require(!_isUserInternalLock());                                       
345         }
346         return super.transferFrom(_from, _to, _value);
347     }
348 
349     function transfer(address _to, uint256 _value) public returns (bool) {
350         if (!isOwner()) {
351             require (allowTransfers);
352             require(!frozenAccount[msg.sender]);                                       
353             require(!frozenAccount[_to]);                                             
354             require(!_isUserInternalLock());                                           
355         }
356         return super.transfer(_to, _value);
357     }
358 
359     function () internal payable{
360 
361         uint256 currentTime = block.timestamp;
362         require((currentTime>crowdsaleStartTime)&&(currentTime<crowdsaleEndTime));
363         require(crowdsaleTotal>0);
364 
365         require(buy());
366 
367         crowdsaleTotal = crowdsaleTotal.sub(msg.value.mul(buyExchangeRate));
368 
369     }
370 
371     function buy() payable public returns (bool){
372 
373 
374         uint256 amount = msg.value.mul(buyExchangeRate);
375 
376         require(!stopBuy);
377         require(amount <= balances[owner]);
378 
379         balances[owner] = balances[owner].sub(amount);
380         balances[msg.sender] = balances[msg.sender].add(amount);
381 
382         soldSupply = soldSupply.add(amount);
383         buySupply = buySupply.add(amount);
384 
385         Transfer(owner, msg.sender, amount);
386         return true;
387     }
388 
389     function sell(uint256 amount) public {
390         uint256 ethAmount = amount.div(sellExchangeRate);
391         require(!stopSell);
392         require(this.balance >= ethAmount);      
393         require(ethAmount >= 1);      
394 
395         require(balances[msg.sender] >= amount);                 
396         require(balances[owner] + amount > balances[owner]);       
397         require(!frozenAccount[msg.sender]);                       
398         require(!_isUserInternalLock());                                          
399 
400         balances[owner] = balances[owner].add(amount);
401         balances[msg.sender] = balances[msg.sender].sub(amount);
402 
403         soldSupply = soldSupply.sub(amount);
404         sellSupply = sellSupply.add(amount);
405 
406         Transfer(msg.sender, owner, amount);
407 
408         msg.sender.transfer(ethAmount); 
409     }
410 
411     function setCrowdsaleStartTime(uint256 _crowdsaleStartTime) onlyOwner public {
412         crowdsaleStartTime = _crowdsaleStartTime;
413     }
414 
415     function setCrowdsaleEndTime(uint256 _crowdsaleEndTime) onlyOwner public {
416         crowdsaleEndTime = _crowdsaleEndTime;
417     }
418    
419 
420     function setCrowdsaleTotal(uint256 _crowdsaleTotal) onlyOwner public {
421         crowdsaleTotal = _crowdsaleTotal;
422     }
423 }