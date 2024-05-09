1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Global Mobile Industry Service Ecosystem Chain 
6  * @dev Developed By Jack 5/13 2018 
7  * @dev contact:jackoelv2018@gmail.com
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
156 contract msc is Ownable, StandardToken {
157     using SafeMath for uint256;
158 
159     uint8 public constant TOKEN_DECIMALS = 18;  // decimals
160 
161     // Public variables of the token
162     string public name = "Global Mobile Industry Service Ecosystem";
163     string public symbol = "MSC";
164     uint8 public decimals = TOKEN_DECIMALS; // 18 decimals is the strongly suggested default, avoid changing it
165 
166 
167     uint256 public totalSupply = 500000000 *(10**uint256(TOKEN_DECIMALS)); 
168     uint256 public soldSupply = 0; 
169     uint256 public sellSupply = 0; 
170     uint256 public buySupply = 0; 
171     bool public stopSell = true;
172     bool public stopBuy = true;
173 
174     uint256 public crowdsaleStartTime = block.timestamp;
175     uint256 public crowdsaleEndTime = block.timestamp;
176 
177     uint256 public crowdsaleTotal = 0;
178 
179 
180     uint256 public buyExchangeRate = 10000;   
181     uint256 public sellExchangeRate = 60000;  
182     address public ethFundDeposit;  
183 
184 
185     bool public allowTransfers = true; 
186 
187 
188     mapping (address => bool) public frozenAccount;
189 
190     bool public enableInternalLock = true; 
191     mapping (address => bool) public internalLockAccount;
192 
193     mapping (address => uint256) public releaseLockAccount;
194 
195 
196     event FrozenFunds(address target, bool frozen);
197     event IncreaseSoldSaleSupply(uint256 _value);
198     event DecreaseSoldSaleSupply(uint256 _value);
199 
200     function msc() public {
201 
202 
203         balances[msg.sender] = totalSupply;             
204 
205         ethFundDeposit = msg.sender;                      
206         allowTransfers = false;
207     }
208 
209     function _isUserInternalLock() internal view returns (bool) {
210 
211         return getAccountLockState(msg.sender);
212 
213     }
214 
215     function increaseSoldSaleSupply (uint256 _value) onlyOwner public {
216         require (_value + soldSupply < totalSupply);
217         soldSupply = soldSupply.add(_value);
218         IncreaseSoldSaleSupply(_value);
219     }
220 
221     function decreaseSoldSaleSupply (uint256 _value) onlyOwner public {
222         require (soldSupply - _value > 0);
223         soldSupply = soldSupply.sub(_value);
224         DecreaseSoldSaleSupply(_value);
225     }
226 
227     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
228         balances[target] = balances[target].add(mintedAmount);
229         totalSupply = totalSupply.add(mintedAmount);
230         Transfer(0, this, mintedAmount);
231         Transfer(this, target, mintedAmount);
232     }
233 
234     function destroyToken(address target, uint256 amount) onlyOwner public {
235         balances[target] = balances[target].sub(amount);
236         totalSupply = totalSupply.sub(amount);
237         Transfer(target, this, amount);
238         Transfer(this, 0, amount);
239     }
240 
241 
242     function freezeAccount(address target, bool freeze) onlyOwner public {
243         frozenAccount[target] = freeze;
244         FrozenFunds(target, freeze);
245     }
246 
247 
248     function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {
249         require(_ethFundDeposit != address(0));
250         ethFundDeposit = _ethFundDeposit;
251     }
252 
253     function transferETH() onlyOwner public {
254         require(ethFundDeposit != address(0));
255         require(this.balance != 0);
256         require(ethFundDeposit.send(this.balance));
257     }
258 
259 
260     function setExchangeRate(uint256 _sellExchangeRate, uint256 _buyExchangeRate) onlyOwner public {
261         sellExchangeRate = _sellExchangeRate;
262         buyExchangeRate = _buyExchangeRate;
263     }
264 
265     function setExchangeStatus(bool _stopSell, bool _stopBuy) onlyOwner public {
266         stopSell = _stopSell;
267         stopBuy = _stopBuy;
268     }
269 
270     function setAllowTransfers(bool _allowTransfers) onlyOwner public {
271         allowTransfers = _allowTransfers;
272     }
273 
274     function transferFromAdmin(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
275         require(_to != address(0));
276         require(_value <= balances[_from]);
277 
278         balances[_from] = balances[_from].sub(_value);
279         balances[_to] = balances[_to].add(_value);
280         Transfer(_from, _to, _value);
281         return true;
282     }
283 
284     function setEnableInternalLock(bool _isEnable) onlyOwner public {
285         enableInternalLock = _isEnable;
286     }
287 
288     function lockInternalAccount(address _target, bool _lock, uint256 _releaseTime) onlyOwner public {
289         require(_target != address(0));
290 
291         internalLockAccount[_target] = _lock;
292         releaseLockAccount[_target] = _releaseTime;
293 
294     }
295 
296     function getAccountUnlockTime(address _target) public view returns(uint256) {
297 
298         return releaseLockAccount[_target];
299 
300     }
301     function getAccountLockState(address _target) public view returns(bool) {
302         if(enableInternalLock && internalLockAccount[_target]){
303             if((releaseLockAccount[_target] > 0)&&(releaseLockAccount[_target]<block.timestamp)){       
304                 return false;
305             }          
306             return true;
307         }
308         return false;
309 
310     }
311 
312     function internalSellTokenFromAdmin(address _to, uint256 _value, bool _lock, uint256 _releaseTime) onlyOwner public returns (bool) {
313         require(_to != address(0));
314         require(_value <= balances[owner]);
315 
316         balances[owner] = balances[owner].sub(_value);
317         balances[_to] = balances[_to].add(_value);
318         soldSupply = soldSupply.add(_value);
319         sellSupply = sellSupply.add(_value);
320 
321         Transfer(owner, _to, _value);
322         
323         lockInternalAccount(_to, _lock, _releaseTime);
324 
325         return true;
326     }
327 
328     /***************************************************/
329     /*              BASE Functions                     */
330     /***************************************************/
331 
332     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
333         if (!isOwner()) {
334             require (allowTransfers);
335             require(!frozenAccount[_from]);                                         
336             require(!frozenAccount[_to]);                                        
337             require(!_isUserInternalLock());                                       
338         }
339         return super.transferFrom(_from, _to, _value);
340     }
341 
342     function transfer(address _to, uint256 _value) public returns (bool) {
343         if (!isOwner()) {
344             require (allowTransfers);
345             require(!frozenAccount[msg.sender]);                                       
346             require(!frozenAccount[_to]);                                             
347             require(!_isUserInternalLock());                                           
348         }
349         return super.transfer(_to, _value);
350     }
351 
352     function () internal payable{
353 
354         uint256 currentTime = block.timestamp;
355         require((currentTime>crowdsaleStartTime)&&(currentTime<crowdsaleEndTime));
356         require(crowdsaleTotal>0);
357 
358         require(buy());
359 
360         crowdsaleTotal = crowdsaleTotal.sub(msg.value.mul(buyExchangeRate));
361 
362     }
363 
364     function buy() payable public returns (bool){
365 
366 
367         uint256 amount = msg.value.mul(buyExchangeRate);
368 
369         require(!stopBuy);
370         require(amount <= balances[owner]);
371 
372         balances[owner] = balances[owner].sub(amount);
373         balances[msg.sender] = balances[msg.sender].add(amount);
374 
375         soldSupply = soldSupply.add(amount);
376         buySupply = buySupply.add(amount);
377 
378         Transfer(owner, msg.sender, amount);
379         return true;
380     }
381 
382     function sell(uint256 amount) public {
383         uint256 ethAmount = amount.div(sellExchangeRate);
384         require(!stopSell);
385         require(this.balance >= ethAmount);      
386         require(ethAmount >= 1);      
387 
388         require(balances[msg.sender] >= amount);                 
389         require(balances[owner] + amount > balances[owner]);       
390         require(!frozenAccount[msg.sender]);                       
391         require(!_isUserInternalLock());                                          
392 
393         balances[owner] = balances[owner].add(amount);
394         balances[msg.sender] = balances[msg.sender].sub(amount);
395 
396         soldSupply = soldSupply.sub(amount);
397         sellSupply = sellSupply.add(amount);
398 
399         Transfer(msg.sender, owner, amount);
400 
401         msg.sender.transfer(ethAmount); 
402     }
403 
404     function setCrowdsaleStartTime(uint256 _crowdsaleStartTime) onlyOwner public {
405         crowdsaleStartTime = _crowdsaleStartTime;
406     }
407 
408     function setCrowdsaleEndTime(uint256 _crowdsaleEndTime) onlyOwner public {
409         crowdsaleEndTime = _crowdsaleEndTime;
410     }
411    
412 
413     function setCrowdsaleTotal(uint256 _crowdsaleTotal) onlyOwner public {
414         crowdsaleTotal = _crowdsaleTotal;
415     }
416 }