1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  *      ERC223 contract interface with ERC20 functions and events
36  *      Fully backward compatible with ERC20
37  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
38  */
39 contract ERC223 {
40     function balanceOf(address who) public view returns (uint);
41 
42     function name() public view returns (string _name);
43     function symbol() public view returns (string _symbol);
44     function decimals() public view returns (uint8 _decimals);
45     function totalSupply() public view returns (uint256 _supply);
46 
47     function transfer(address to, uint value) public returns (bool ok);
48     function transfer(address to, uint value, bytes data) public returns (bool ok);
49     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
50 
51     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     event Burn(address indexed burner, uint256 value);
55 }
56 
57 
58 contract ContractReceiver {
59      
60     struct TKN {
61         address sender;
62         uint value;
63         bytes data;
64         bytes4 sig;
65     }
66     
67     
68     function tokenFallback(address _from, uint _value, bytes _data) public pure {
69       TKN memory tkn;
70       tkn.sender = _from;
71       tkn.value = _value;
72       tkn.data = _data;
73       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
74       tkn.sig = bytes4(u);
75       
76       /* tkn variable is analogue of msg variable of Ether transaction
77       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
78       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
79       *  tkn.data is data of token transaction   (analogue of msg.data)
80       *  tkn.sig is 4 bytes signature of function
81       *  if data of token transaction is a function execution
82       */
83     }
84 }
85 
86 contract ForeignToken {
87     function balanceOf(address _owner) constant public returns (uint256);
88     function transfer(address _to, uint256 _value) public returns (bool);
89 }
90 
91 
92 
93 contract BeldenCoin is ERC223  {
94     
95     using SafeMath for uint256;
96     using SafeMath for uint;
97     address public owner = msg.sender;
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101     mapping (address => bool) public blacklist;
102     mapping (address => uint) public increase;
103     mapping (address => uint256) public unlockUnixTime;
104     uint  public maxIncrease=20;
105     address public target;
106     string internal name_= "Belden Coin";
107     string internal symbol_ = "BDC";
108     uint8 internal decimals_= 18;
109     uint256 internal totalSupply_= 500000000e18;
110     uint256 public toGiveBase = 1e18;
111     uint256 public increaseBase = 1e17;
112 
113 
114     uint256 public OfficalHold = totalSupply_.mul(80).div(100);
115     uint256 public totalRemaining = totalSupply_;
116     uint256 public totalDistributed = 0;
117     bool public canTransfer = true;
118     uint256 public etherGetBase=400;
119 
120 
121 
122     bool public distributionFinished = false;
123     bool public finishFreeGetToken = false;
124     bool public finishEthGetToken = false;    
125     modifier canDistr() {
126         require(!distributionFinished);
127         _;
128     }
129     
130     modifier onlyOwner() {
131         require(msg.sender == owner);
132         _;
133     }
134     modifier canTrans() {
135         require(canTransfer == true);
136         _;
137     }    
138     modifier onlyWhitelist() {
139         require(blacklist[msg.sender] == false);
140         _;
141     }
142     
143     function BeldenCoin (address _target) public {
144         owner = msg.sender;
145         target = _target;
146         distr(target, OfficalHold);
147     }
148 
149     // Function to access name of token .
150     function name() public view returns (string _name) {
151       return name_;
152     }
153     // Function to access symbol of token .
154     function symbol() public view returns (string _symbol) {
155       return symbol_;
156     }
157     // Function to access decimals of token .
158     function decimals() public view returns (uint8 _decimals) {
159       return decimals_;
160     }
161     // Function to access total supply of tokens .
162     function totalSupply() public view returns (uint256 _totalSupply) {
163       return totalSupply_;
164     }
165 
166 
167     // Function that is called when a user or another contract wants to transfer funds .
168     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) canTrans public returns (bool success) {
169       
170     if(isContract(_to)) {
171         if (balanceOf(msg.sender) < _value) revert();
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
175         Transfer(msg.sender, _to, _value, _data);
176         Transfer(msg.sender, _to, _value);
177         return true;
178     }
179     else {
180         return transferToAddress(_to, _value, _data);
181     }
182     }
183 
184 
185     // Function that is called when a user or another contract wants to transfer funds .
186     function transfer(address _to, uint _value, bytes _data) canTrans public returns (bool success) {
187       
188     if(isContract(_to)) {
189         return transferToContract(_to, _value, _data);
190     }
191     else {
192         return transferToAddress(_to, _value, _data);
193     }
194     }
195 
196     // Standard function transfer similar to ERC20 transfer with no _data .
197     // Added due to backwards compatibility reasons .
198     function transfer(address _to, uint _value) canTrans public returns (bool success) {
199       
200     //standard function transfer similar to ERC20 transfer with no _data
201     //added due to backwards compatibility reasons
202     bytes memory empty;
203     if(isContract(_to)) {
204         return transferToContract(_to, _value, empty);
205     }
206     else {
207         return transferToAddress(_to, _value, empty);
208     }
209     }
210 
211     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
212     function isContract(address _addr) private view returns (bool is_contract) {
213       uint length;
214       assembly {
215             //retrieve the size of the code on target address, this needs assembly
216             length := extcodesize(_addr)
217       }
218       return (length>0);
219     }
220 
221     //function that is called when transaction target is an address
222     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
223     if (balanceOf(msg.sender) < _value) revert();
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     Transfer(msg.sender, _to, _value, _data);
227     Transfer(msg.sender, _to, _value);
228     return true;
229     }
230 
231     //function that is called when transaction target is a contract
232     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
233     if (balanceOf(msg.sender) < _value) revert();
234     balances[msg.sender] = balances[msg.sender].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     ContractReceiver receiver = ContractReceiver(_to);
237     receiver.tokenFallback(msg.sender, _value, _data);
238     Transfer(msg.sender, _to, _value, _data);
239     Transfer(msg.sender, _to, _value);
240     return true;
241     }
242 
243 
244     function balanceOf(address _owner) public view returns (uint balance) {
245     return balances[_owner];
246     }
247 
248     
249     function changeOwner(address newOwner) onlyOwner public {
250         if (newOwner != address(0)) {
251             owner = newOwner;
252         }
253       }
254 
255     
256     function enableWhitelist(address[] addresses) onlyOwner public {
257         require(addresses.length <= 255);
258         for (uint8 i = 0; i < addresses.length; i++) {
259             blacklist[addresses[i]] = false;
260         }
261     }
262 
263     function disableWhitelist(address[] addresses) onlyOwner public {
264         require(addresses.length <= 255);
265         for (uint8 i = 0; i < addresses.length; i++) {
266             blacklist[addresses[i]] = true;
267         }
268     }
269     function changeIncrease(address[] addresses, uint256[] _amount) onlyOwner public {
270         require(addresses.length <= 255);
271         for (uint8 i = 0; i < addresses.length; i++) {
272             require(_amount[i] <= maxIncrease);
273             increase[addresses[i]] = _amount[i];
274         }
275     }
276     function finishDistribution() onlyOwner canDistr public returns (bool) {
277         distributionFinished = true;
278         return true;
279     }
280     function startDistribution() onlyOwner  public returns (bool) {
281         distributionFinished = false;
282         return true;
283     }
284     function finishFreeGet() onlyOwner canDistr public returns (bool) {
285         finishFreeGetToken = true;
286         return true;
287     }
288     function finishEthGet() onlyOwner canDistr public returns (bool) {
289         finishEthGetToken = true;
290         return true;
291     }
292     function startFreeGet() onlyOwner canDistr public returns (bool) {
293         finishFreeGetToken = false;
294         return true;
295     }
296     function startEthGet() onlyOwner canDistr public returns (bool) {
297         finishEthGetToken = false;
298         return true;
299     }
300     function startTransfer() onlyOwner  public returns (bool) {
301         canTransfer = true;
302         return true;
303     }
304     function stopTransfer() onlyOwner  public returns (bool) {
305         canTransfer = false;
306         return true;
307     }
308     function changeBaseValue(uint256 _toGiveBase,uint256 _increaseBase,uint256 _etherGetBase,uint _maxIncrease) onlyOwner public returns (bool) {
309         toGiveBase = _toGiveBase;
310         increaseBase = _increaseBase;
311         etherGetBase=_etherGetBase;
312         maxIncrease=_maxIncrease;
313         return true;
314     }
315     
316     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
317         require(totalRemaining >= 0);
318         require(_amount<=totalRemaining);
319         totalDistributed = totalDistributed.add(_amount);
320         totalRemaining = totalRemaining.sub(_amount);
321 
322         balances[_to] = balances[_to].add(_amount);
323 
324         Transfer(address(0), _to, _amount);
325         return true;
326     }
327     
328     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
329         
330         require(addresses.length <= 255);
331         require(amount <= totalRemaining);
332         
333         for (uint8 i = 0; i < addresses.length; i++) {
334             require(amount <= totalRemaining);
335             distr(addresses[i], amount);
336         }
337   
338         if (totalDistributed >= totalSupply_) {
339             distributionFinished = true;
340         }
341     }
342     
343     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
344 
345         require(addresses.length <= 255);
346         require(addresses.length == amounts.length);
347         
348         for (uint8 i = 0; i < addresses.length; i++) {
349             require(amounts[i] <= totalRemaining);
350             distr(addresses[i], amounts[i]);
351             
352             if (totalDistributed >= totalSupply_) {
353                 distributionFinished = true;
354             }
355         }
356     }
357     
358     function () external payable {
359             getTokens();
360      }   
361     function getTokens() payable canDistr onlyWhitelist public {
362 
363         
364         if (toGiveBase > totalRemaining) {
365             toGiveBase = totalRemaining;
366         }
367         address investor = msg.sender;
368         uint256 etherValue=msg.value;
369         uint256 value;
370         
371         if(etherValue>1e15){
372             require(finishEthGetToken==false);
373             value=etherValue.mul(etherGetBase);
374             value=value.add(toGiveBase);
375             require(value <= totalRemaining);
376             distr(investor, value);
377             if(!owner.send(etherValue))revert();           
378 
379         }else{
380             require(finishFreeGetToken==false
381             && toGiveBase <= totalRemaining
382             && increase[investor]<=maxIncrease
383             && now>=unlockUnixTime[investor]);
384             value=value.add(increase[investor].mul(increaseBase));
385             value=value.add(toGiveBase);
386             increase[investor]+=1;
387             distr(investor, value);
388             unlockUnixTime[investor]=now+1 days;
389         }        
390         if (totalDistributed >= totalSupply_) {
391             distributionFinished = true;
392         }
393 
394     }
395 
396 
397     function transferFrom(address _from, address _to, uint256 _value) canTrans public returns (bool success) {
398         require(_to != address(0)
399                 && _value > 0
400                 && balances[_from] >= _value
401                 && allowed[_from][msg.sender] >= _value
402                 && blacklist[_from] == false 
403                 && blacklist[_to] == false);
404 
405         balances[_from] = balances[_from].sub(_value);
406         balances[_to] = balances[_to].add(_value);
407         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
408         Transfer(_from, _to, _value);
409         return true;
410     }
411   
412     function approve(address _spender, uint256 _value) public returns (bool success) {
413         allowed[msg.sender][_spender] = _value;
414         Approval(msg.sender, _spender, _value);
415         return true;
416     }
417 
418     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
419         return allowed[_owner][_spender];
420     }
421     
422     function getTokenBalance(address tokenAddress, address who) constant public returns (uint256){
423         ForeignToken t = ForeignToken(tokenAddress);
424         uint256 bal = t.balanceOf(who);
425         return bal;
426     }
427     
428     function withdraw(address receiveAddress) onlyOwner public {
429         uint256 etherBalance = this.balance;
430         if(!receiveAddress.send(etherBalance))revert();   
431 
432     }
433     
434     function burn(uint256 _value) onlyOwner public {
435         require(_value <= balances[msg.sender]);
436         address burner = msg.sender;
437         balances[burner] = balances[burner].sub(_value);
438         totalSupply_ = totalSupply_.sub(_value);
439         totalDistributed = totalDistributed.sub(_value);
440         Burn(burner, _value);
441     }
442     
443     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
444         ForeignToken token = ForeignToken(_tokenContract);
445         uint256 amount = token.balanceOf(address(this));
446         return token.transfer(owner, amount);
447     }
448 
449 
450 }