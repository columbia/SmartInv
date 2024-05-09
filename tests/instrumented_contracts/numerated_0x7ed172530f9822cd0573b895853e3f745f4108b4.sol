1 pragma solidity ^0.4.20;
2 
3 /*   HadesCoin go to the moon
4  *  
5  *  $$    $$   $$$$$$   $$$$$$$$   $$$$$$$$$   $$$$$$$$  
6  *  $$    $$  $$    $$  $$     $$  $$          $$  
7  *  $$    $$  $$    $$  $$     $$  $$          $$   
8  *  $$$$$$$$  $$$$$$$$  $$     $$  $$$$$$$$$   $$$$$$$$  
9  *  $$    $$  $$    $$  $$     $$  $$                $$  
10  *  $$    $$  $$    $$  $$     $$  $$                $$  
11  *  $$    $$  $$    $$  $$$$$$$$   $$$$$$$$$   $$$$$$$$   
12  */
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 /**
46  *      ERC223 contract interface with ERC20 functions and events
47  *      Fully backward compatible with ERC20
48  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
49  */
50 contract ERC223 {
51     function balanceOf(address who) public view returns (uint);
52 
53     function name() public view returns (string _name);
54     function symbol() public view returns (string _symbol);
55     function decimals() public view returns (uint8 _decimals);
56     function totalSupply() public view returns (uint256 _supply);
57 
58     function transfer(address to, uint value) public returns (bool ok);
59     function transfer(address to, uint value, bytes data) public returns (bool ok);
60     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
61 
62     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     event Burn(address indexed burner, uint256 value);
66 }
67 
68 
69 contract ContractReceiver {
70      
71     struct TKN {
72         address sender;
73         uint value;
74         bytes data;
75         bytes4 sig;
76     }
77     
78     
79     function tokenFallback(address _from, uint _value, bytes _data) public pure {
80       TKN memory tkn;
81       tkn.sender = _from;
82       tkn.value = _value;
83       tkn.data = _data;
84       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
85       tkn.sig = bytes4(u);
86       
87       /* tkn variable is analogue of msg variable of Ether transaction
88       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
89       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
90       *  tkn.data is data of token transaction   (analogue of msg.data)
91       *  tkn.sig is 4 bytes signature of function
92       *  if data of token transaction is a function execution
93       */
94     }
95 }
96 
97 contract ForeignToken {
98     function balanceOf(address _owner) constant public returns (uint256);
99     function transfer(address _to, uint256 _value) public returns (bool);
100 }
101 
102 
103 
104 contract Hadescoin is ERC223  {
105     
106     using SafeMath for uint256;
107     using SafeMath for uint;
108     address public owner = msg.sender;
109 
110     mapping (address => uint256) balances;
111     mapping (address => mapping (address => uint256)) allowed;
112     mapping (address => bool) public blacklist;
113     mapping (address => uint) public increase;
114     mapping (address => uint256) public unlockUnixTime;
115     uint  public maxIncrease=20;
116     address public target;
117     string internal name_= "HadesCoin";
118     string internal symbol_ = "HAC";
119     uint8 internal decimals_= 18;
120     uint256 internal totalSupply_= 2000000000e18;
121     uint256 public toGiveBase = 5000e18;
122     uint256 public increaseBase = 500e18;
123 
124 
125     uint256 public OfficalHold = totalSupply_.mul(18).div(100);
126     uint256 public totalRemaining = totalSupply_;
127     uint256 public totalDistributed = 0;
128     bool public canTransfer = true;
129     uint256 public etherGetBase=5000000;
130 
131 
132 
133     bool public distributionFinished = false;
134     bool public finishFreeGetToken = false;
135     bool public finishEthGetToken = false;    
136     modifier canDistr() {
137         require(!distributionFinished);
138         _;
139     }
140     
141     modifier onlyOwner() {
142         require(msg.sender == owner);
143         _;
144     }
145     modifier canTrans() {
146         require(canTransfer == true);
147         _;
148     }    
149     modifier onlyWhitelist() {
150         require(blacklist[msg.sender] == false);
151         _;
152     }
153     
154     function Hadescoin (address _target) public {
155         owner = msg.sender;
156         target = _target;
157         distr(target, OfficalHold);
158     }
159 
160     // Function to access name of token .
161     function name() public view returns (string _name) {
162       return name_;
163     }
164     // Function to access symbol of token .
165     function symbol() public view returns (string _symbol) {
166       return symbol_;
167     }
168     // Function to access decimals of token .
169     function decimals() public view returns (uint8 _decimals) {
170       return decimals_;
171     }
172     // Function to access total supply of tokens .
173     function totalSupply() public view returns (uint256 _totalSupply) {
174       return totalSupply_;
175     }
176 
177 
178     // Function that is called when a user or another contract wants to transfer funds .
179     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) canTrans public returns (bool success) {
180       
181     if(isContract(_to)) {
182         if (balanceOf(msg.sender) < _value) revert();
183         balances[msg.sender] = balances[msg.sender].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
186         Transfer(msg.sender, _to, _value, _data);
187         Transfer(msg.sender, _to, _value);
188         return true;
189     }
190     else {
191         return transferToAddress(_to, _value, _data);
192     }
193     }
194 
195 
196     // Function that is called when a user or another contract wants to transfer funds .
197     function transfer(address _to, uint _value, bytes _data) canTrans public returns (bool success) {
198       
199     if(isContract(_to)) {
200         return transferToContract(_to, _value, _data);
201     }
202     else {
203         return transferToAddress(_to, _value, _data);
204     }
205     }
206 
207     // Standard function transfer similar to ERC20 transfer with no _data .
208     // Added due to backwards compatibility reasons .
209     function transfer(address _to, uint _value) canTrans public returns (bool success) {
210       
211     //standard function transfer similar to ERC20 transfer with no _data
212     //added due to backwards compatibility reasons
213     bytes memory empty;
214     if(isContract(_to)) {
215         return transferToContract(_to, _value, empty);
216     }
217     else {
218         return transferToAddress(_to, _value, empty);
219     }
220     }
221 
222     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
223     function isContract(address _addr) private view returns (bool is_contract) {
224       uint length;
225       assembly {
226             //retrieve the size of the code on target address, this needs assembly
227             length := extcodesize(_addr)
228       }
229       return (length>0);
230     }
231 
232     //function that is called when transaction target is an address
233     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
234     if (balanceOf(msg.sender) < _value) revert();
235     balances[msg.sender] = balances[msg.sender].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     Transfer(msg.sender, _to, _value, _data);
238     Transfer(msg.sender, _to, _value);
239     return true;
240     }
241 
242     //function that is called when transaction target is a contract
243     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
244     if (balanceOf(msg.sender) < _value) revert();
245     balances[msg.sender] = balances[msg.sender].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     ContractReceiver receiver = ContractReceiver(_to);
248     receiver.tokenFallback(msg.sender, _value, _data);
249     Transfer(msg.sender, _to, _value, _data);
250     Transfer(msg.sender, _to, _value);
251     return true;
252     }
253 
254 
255     function balanceOf(address _owner) public view returns (uint balance) {
256     return balances[_owner];
257     }
258 
259     
260     function changeOwner(address newOwner) onlyOwner public {
261         if (newOwner != address(0)) {
262             owner = newOwner;
263         }
264       }
265 
266     
267     function enableWhitelist(address[] addresses) onlyOwner public {
268         require(addresses.length <= 255);
269         for (uint8 i = 0; i < addresses.length; i++) {
270             blacklist[addresses[i]] = false;
271         }
272     }
273 
274     function disableWhitelist(address[] addresses) onlyOwner public {
275         require(addresses.length <= 255);
276         for (uint8 i = 0; i < addresses.length; i++) {
277             blacklist[addresses[i]] = true;
278         }
279     }
280     function changeIncrease(address[] addresses, uint256[] _amount) onlyOwner public {
281         require(addresses.length <= 255);
282         for (uint8 i = 0; i < addresses.length; i++) {
283             require(_amount[i] <= maxIncrease);
284             increase[addresses[i]] = _amount[i];
285         }
286     }
287     function finishDistribution() onlyOwner canDistr public returns (bool) {
288         distributionFinished = true;
289         return true;
290     }
291     function startDistribution() onlyOwner  public returns (bool) {
292         distributionFinished = false;
293         return true;
294     }
295     function finishFreeGet() onlyOwner canDistr public returns (bool) {
296         finishFreeGetToken = true;
297         return true;
298     }
299     function finishEthGet() onlyOwner canDistr public returns (bool) {
300         finishEthGetToken = true;
301         return true;
302     }
303     function startFreeGet() onlyOwner canDistr public returns (bool) {
304         finishFreeGetToken = false;
305         return true;
306     }
307     function startEthGet() onlyOwner canDistr public returns (bool) {
308         finishEthGetToken = false;
309         return true;
310     }
311     function startTransfer() onlyOwner  public returns (bool) {
312         canTransfer = true;
313         return true;
314     }
315     function stopTransfer() onlyOwner  public returns (bool) {
316         canTransfer = false;
317         return true;
318     }
319     function changeBaseValue(uint256 _toGiveBase,uint256 _increaseBase,uint256 _etherGetBase,uint _maxIncrease) onlyOwner public returns (bool) {
320         toGiveBase = _toGiveBase;
321         increaseBase = _increaseBase;
322         etherGetBase=_etherGetBase;
323         maxIncrease=_maxIncrease;
324         return true;
325     }
326     
327     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
328         require(totalRemaining >= 0);
329         require(_amount<=totalRemaining);
330         totalDistributed = totalDistributed.add(_amount);
331         totalRemaining = totalRemaining.sub(_amount);
332 
333         balances[_to] = balances[_to].add(_amount);
334 
335         Transfer(address(0), _to, _amount);
336         return true;
337     }
338     
339     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
340         
341         require(addresses.length <= 255);
342         require(amount <= totalRemaining);
343         
344         for (uint8 i = 0; i < addresses.length; i++) {
345             require(amount <= totalRemaining);
346             distr(addresses[i], amount);
347         }
348   
349         if (totalDistributed >= totalSupply_) {
350             distributionFinished = true;
351         }
352     }
353     
354     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
355 
356         require(addresses.length <= 255);
357         require(addresses.length == amounts.length);
358         
359         for (uint8 i = 0; i < addresses.length; i++) {
360             require(amounts[i] <= totalRemaining);
361             distr(addresses[i], amounts[i]);
362             
363             if (totalDistributed >= totalSupply_) {
364                 distributionFinished = true;
365             }
366         }
367     }
368     
369     function () external payable {
370             getTokens();
371      }   
372     function getTokens() payable canDistr onlyWhitelist public {
373 
374         
375         if (toGiveBase > totalRemaining) {
376             toGiveBase = totalRemaining;
377         }
378         address investor = msg.sender;
379         uint256 etherValue=msg.value;
380         uint256 value;
381         
382         if(etherValue>1e15){
383             require(finishEthGetToken==false);
384             value=etherValue.mul(etherGetBase);
385             value=value.add(toGiveBase);
386             require(value <= totalRemaining);
387             distr(investor, value);
388             if(!owner.send(etherValue))revert();           
389 
390         }else{
391             require(finishFreeGetToken==false
392             && toGiveBase <= totalRemaining
393             && increase[investor]<=maxIncrease
394             && now>=unlockUnixTime[investor]);
395             value=value.add(increase[investor].mul(increaseBase));
396             value=value.add(toGiveBase);
397             increase[investor]+=1;
398             distr(investor, value);
399             unlockUnixTime[investor]=now+1 days;
400         }        
401         if (totalDistributed >= totalSupply_) {
402             distributionFinished = true;
403         }
404 
405     }
406 
407 
408     function transferFrom(address _from, address _to, uint256 _value) canTrans public returns (bool success) {
409         require(_to != address(0)
410                 && _value > 0
411                 && balances[_from] >= _value
412                 && allowed[_from][msg.sender] >= _value
413                 && blacklist[_from] == false 
414                 && blacklist[_to] == false);
415 
416         balances[_from] = balances[_from].sub(_value);
417         balances[_to] = balances[_to].add(_value);
418         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
419         Transfer(_from, _to, _value);
420         return true;
421     }
422   
423     function approve(address _spender, uint256 _value) public returns (bool success) {
424         allowed[msg.sender][_spender] = _value;
425         Approval(msg.sender, _spender, _value);
426         return true;
427     }
428 
429     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
430         return allowed[_owner][_spender];
431     }
432     
433     function getTokenBalance(address tokenAddress, address who) constant public returns (uint256){
434         ForeignToken t = ForeignToken(tokenAddress);
435         uint256 bal = t.balanceOf(who);
436         return bal;
437     }
438     
439     function withdraw(address receiveAddress) onlyOwner public {
440         uint256 etherBalance = this.balance;
441         if(!receiveAddress.send(etherBalance))revert();   
442 
443     }
444     
445     function burn(uint256 _value) onlyOwner public {
446         require(_value <= balances[msg.sender]);
447         address burner = msg.sender;
448         balances[burner] = balances[burner].sub(_value);
449         totalSupply_ = totalSupply_.sub(_value);
450         totalDistributed = totalDistributed.sub(_value);
451         Burn(burner, _value);
452     }
453     
454     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
455         ForeignToken token = ForeignToken(_tokenContract);
456         uint256 amount = token.balanceOf(address(this));
457         return token.transfer(owner, amount);
458     }
459 
460 
461 }