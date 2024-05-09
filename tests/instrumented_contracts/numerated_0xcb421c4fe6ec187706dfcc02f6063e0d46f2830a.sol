1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Global Mobile Industry Service Ecosystem Chain 
6  * @dev Developed By Jack 5/14 2018 
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
171     bool public stopBuy = true;
172 
173     uint256 public crowdsaleStartTime = block.timestamp;
174     uint256 public crowdsaleEndTime = block.timestamp;
175 
176     uint256 public crowdsaleTotal = 0;
177 
178 
179     uint256 public buyExchangeRate = 10000;   
180     uint256 public sellExchangeRate = 60000;  
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
205         allowTransfers = false;
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
264     function setName(string _name) onlyOwner public {
265         name = _name;
266     }
267 
268     function setSymbol(string _symbol) onlyOwner public {
269         symbol = _symbol;
270     }
271 
272     function setAllowTransfers(bool _allowTransfers) onlyOwner public {
273         allowTransfers = _allowTransfers;
274     }
275 
276     function transferFromAdmin(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
277         require(_to != address(0));
278         require(_value <= balances[_from]);
279 
280         balances[_from] = balances[_from].sub(_value);
281         balances[_to] = balances[_to].add(_value);
282         Transfer(_from, _to, _value);
283         return true;
284     }
285 
286     function setEnableInternalLock(bool _isEnable) onlyOwner public {
287         enableInternalLock = _isEnable;
288     }
289 
290     function lockInternalAccount(address _target, bool _lock, uint256 _releaseTime) onlyOwner public {
291         require(_target != address(0));
292 
293         internalLockAccount[_target] = _lock;
294         releaseLockAccount[_target] = _releaseTime;
295 
296     }
297 
298     function getAccountUnlockTime(address _target) public view returns(uint256) {
299 
300         return releaseLockAccount[_target];
301 
302     }
303     function getAccountLockState(address _target) public view returns(bool) {
304         if(enableInternalLock && internalLockAccount[_target]){
305             if((releaseLockAccount[_target] > 0)&&(releaseLockAccount[_target]<block.timestamp)){       
306                 return false;
307             }          
308             return true;
309         }
310         return false;
311 
312     }
313 
314     function internalSellTokenFromAdmin(address _to, uint256 _value, bool _lock, uint256 _releaseTime) onlyOwner public returns (bool) {
315         require(_to != address(0));
316         require(_value <= balances[owner]);
317 
318         balances[owner] = balances[owner].sub(_value);
319         balances[_to] = balances[_to].add(_value);
320         soldSupply = soldSupply.add(_value);
321         sellSupply = sellSupply.add(_value);
322 
323         Transfer(owner, _to, _value);
324         
325         lockInternalAccount(_to, _lock, _releaseTime);
326 
327         return true;
328     }
329 
330     /***************************************************/
331     /*              BASE Functions                     */
332     /***************************************************/
333 
334     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335         if (!isOwner()) {
336             require (allowTransfers);
337             require(!frozenAccount[_from]);                                         
338             require(!frozenAccount[_to]);                                        
339             require(!_isUserInternalLock());                                       
340         }
341         return super.transferFrom(_from, _to, _value);
342     }
343 
344     function transfer(address _to, uint256 _value) public returns (bool) {
345         if (!isOwner()) {
346             require (allowTransfers);
347             require(!frozenAccount[msg.sender]);                                       
348             require(!frozenAccount[_to]);                                             
349             require(!_isUserInternalLock());                                           
350         }
351         return super.transfer(_to, _value);
352     }
353 
354     function () internal payable{
355 
356         uint256 currentTime = block.timestamp;
357         require((currentTime>crowdsaleStartTime)&&(currentTime<crowdsaleEndTime));
358         require(crowdsaleTotal>0);
359 
360         require(buy());
361 
362         crowdsaleTotal = crowdsaleTotal.sub(msg.value.mul(buyExchangeRate));
363 
364     }
365 
366     function buy() payable public returns (bool){
367 
368 
369         uint256 amount = msg.value.mul(buyExchangeRate);
370 
371         require(!stopBuy);
372         require(amount <= balances[owner]);
373 
374         balances[owner] = balances[owner].sub(amount);
375         balances[msg.sender] = balances[msg.sender].add(amount);
376 
377         soldSupply = soldSupply.add(amount);
378         buySupply = buySupply.add(amount);
379 
380         Transfer(owner, msg.sender, amount);
381         return true;
382     }
383 
384     function sell(uint256 amount) public {
385         uint256 ethAmount = amount.div(sellExchangeRate);
386         require(!stopSell);
387         require(this.balance >= ethAmount);      
388         require(ethAmount >= 1);      
389 
390         require(balances[msg.sender] >= amount);                 
391         require(balances[owner] + amount > balances[owner]);       
392         require(!frozenAccount[msg.sender]);                       
393         require(!_isUserInternalLock());                                          
394 
395         balances[owner] = balances[owner].add(amount);
396         balances[msg.sender] = balances[msg.sender].sub(amount);
397 
398         soldSupply = soldSupply.sub(amount);
399         sellSupply = sellSupply.add(amount);
400 
401         Transfer(msg.sender, owner, amount);
402 
403         msg.sender.transfer(ethAmount); 
404     }
405 
406     function setCrowdsaleStartTime(uint256 _crowdsaleStartTime) onlyOwner public {
407         crowdsaleStartTime = _crowdsaleStartTime;
408     }
409 
410     function setCrowdsaleEndTime(uint256 _crowdsaleEndTime) onlyOwner public {
411         crowdsaleEndTime = _crowdsaleEndTime;
412     }
413    
414 
415     function setCrowdsaleTotal(uint256 _crowdsaleTotal) onlyOwner public {
416         crowdsaleTotal = _crowdsaleTotal;
417     }
418 }