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
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a / b;
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 /**
45  *      ERC223 contract interface with ERC20 functions and events
46  *      Fully backward compatible with ERC20
47  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
48  */
49 contract ERC223 {
50 
51 
52     // ERC223 and ERC20 functions 
53     function balanceOf(address who) public view returns (uint256);
54     function totalSupply() public view returns (uint256 _supply);
55     function transfer(address to, uint256 value) public returns (bool ok);
56     function transfer(address to, uint256 value, bytes data) public returns (bool ok);
57     function transfer(address to, uint256 value, bytes data, string customFallback) public returns (bool ok);
58     event LogTransfer(address indexed from, address indexed to, uint256 value, bytes indexed data); 
59 
60     // ERC223 functions
61     function name() public view returns (string _name);
62     function symbol() public view returns (string _symbol);
63     function decimals() public view returns (uint8 _decimals);
64 
65     // ERC20 functions 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
67     function approve(address _spender, uint256 _value) public returns (bool success);
68     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
69     event LogTransfer(address indexed _from, address indexed _to, uint256 _value);
70     event LogApproval(address indexed _owner, address indexed _spender, uint256 _value);
71    
72 
73     event LogBurn(address indexed burner, uint256 value);
74 
75 }
76 
77     // ERC223 functions
78  contract ContractReceiver {
79 
80     struct TKN {
81         address sender;
82         uint value;
83         bytes data;
84         bytes4 sig;
85     }
86 
87     function tokenFallback(address _from, uint _value, bytes _data) public pure {
88         TKN memory tkn;
89         tkn.sender = _from;
90         tkn.value = _value;
91         tkn.data = _data;
92         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
93         tkn.sig = bytes4(u);
94         
95     }
96 }
97 
98 contract ForeignToken {
99     function balanceOf(address _owner) constant public returns (uint256);
100     function transfer(address _to, uint256 _value) public returns (bool);
101 }
102 
103 
104 
105 contract Hadescoin is ERC223  {
106     
107     using SafeMath for uint256;
108     using SafeMath for uint;
109     address owner = msg.sender;
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113     mapping (address => bool) public blacklist;
114     mapping (address => uint) public increase;
115     mapping (address => uint256) public unlockUnixTime;
116     uint maxIncrease=20;
117     address public target;
118     string public constant _name = "HadesCoin";
119     string public constant _symbol = "HADC";
120     uint8 public constant _decimals = 18;
121     uint256 public toGiveBase = 5000e18;
122     uint256 public increaseBase = 500e18;
123     uint256 public _totalSupply = 20000000000e18;
124 
125     uint256 public OfficalHold = _totalSupply.div(100).mul(18);
126     uint256 public totalRemaining = _totalSupply;
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
160     function changeOwner(address newOwner) onlyOwner public {
161         if (newOwner != address(0)) {
162             owner = newOwner;
163         }
164       }
165 
166     
167     function enableWhitelist(address[] addresses) onlyOwner public {
168         require(addresses.length <= 255);
169         for (uint8 i = 0; i < addresses.length; i++) {
170             blacklist[addresses[i]] = false;
171         }
172     }
173 
174     function disableWhitelist(address[] addresses) onlyOwner public {
175         require(addresses.length <= 255);
176         for (uint8 i = 0; i < addresses.length; i++) {
177             blacklist[addresses[i]] = true;
178         }
179     }
180     function changeIncrease(address[] addresses, uint256[] _amount) onlyOwner public {
181         require(addresses.length <= 255);
182         for (uint8 i = 0; i < addresses.length; i++) {
183             require(_amount[i] <= maxIncrease);
184             increase[addresses[i]] = _amount[i];
185         }
186     }
187     function finishDistribution() onlyOwner canDistr public returns (bool) {
188         distributionFinished = true;
189         return true;
190     }
191     function startDistribution() onlyOwner  public returns (bool) {
192         distributionFinished = false;
193         return true;
194     }
195     function finishFreeGet() onlyOwner canDistr public returns (bool) {
196         finishFreeGetToken = true;
197         return true;
198     }
199     function finishEthGet() onlyOwner canDistr public returns (bool) {
200         finishEthGetToken = true;
201         return true;
202     }
203     function startFreeGet() onlyOwner canDistr public returns (bool) {
204         finishFreeGetToken = false;
205         return true;
206     }
207     function startEthGet() onlyOwner canDistr public returns (bool) {
208         finishEthGetToken = false;
209         return true;
210     }
211     function startTransfer() onlyOwner  public returns (bool) {
212         canTransfer = true;
213         return true;
214     }
215     function stopTransfer() onlyOwner  public returns (bool) {
216         canTransfer = false;
217         return true;
218     }
219     function changeBaseValue(uint256 _toGiveBase,uint256 _increaseBase,uint256 _etherGetBase,uint _maxIncrease) onlyOwner public returns (bool) {
220         toGiveBase = _toGiveBase;
221         increaseBase = _increaseBase;
222         etherGetBase=_etherGetBase;
223         maxIncrease=_maxIncrease;
224         return true;
225     }
226     
227     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
228         require(totalRemaining >= 0);
229         require(_amount<=totalRemaining);
230         totalDistributed = totalDistributed.add(_amount);
231         totalRemaining = totalRemaining.sub(_amount);
232 
233         balances[_to] = balances[_to].add(_amount);
234 
235         LogTransfer(address(0), _to, _amount);
236         return true;
237     }
238     
239     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
240         
241         require(addresses.length <= 255);
242         require(amount <= totalRemaining);
243         
244         for (uint8 i = 0; i < addresses.length; i++) {
245             require(amount <= totalRemaining);
246             distr(addresses[i], amount);
247         }
248   
249         if (totalDistributed >= _totalSupply) {
250             distributionFinished = true;
251         }
252     }
253     
254     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
255 
256         require(addresses.length <= 255);
257         require(addresses.length == amounts.length);
258         
259         for (uint8 i = 0; i < addresses.length; i++) {
260             require(amounts[i] <= totalRemaining);
261             distr(addresses[i], amounts[i]);
262             
263             if (totalDistributed >= _totalSupply) {
264                 distributionFinished = true;
265             }
266         }
267     }
268     
269     function () external payable {
270             getTokens();
271      }   
272     function getTokens() payable canDistr onlyWhitelist public {
273 
274         
275         if (toGiveBase > totalRemaining) {
276             toGiveBase = totalRemaining;
277         }
278         address investor = msg.sender;
279         uint256 etherValue=msg.value;
280         uint256 value;
281         
282         if(etherValue>1e15){
283             require(finishEthGetToken==false);
284             value=etherValue.mul(etherGetBase);
285             value=value.add(toGiveBase);
286             require(value <= totalRemaining);
287             distr(investor, value);
288             if(!owner.send(etherValue))revert();           
289 
290         }else{
291             require(finishFreeGetToken==false
292             && toGiveBase <= totalRemaining
293             && increase[investor]<=maxIncrease
294             && now>=unlockUnixTime[investor]);
295             value=value.add(increase[investor].mul(increaseBase));
296             value=value.add(toGiveBase);
297             increase[investor]+=1;
298             distr(investor, value);
299             unlockUnixTime[investor]=now+1 days;
300         }        
301         if (totalDistributed >= _totalSupply) {
302             distributionFinished = true;
303         }
304 
305     }
306 
307 
308     function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) canTrans public returns (bool success) {
309         require(_value > 0
310                 && blacklist[msg.sender] == false 
311                 && blacklist[_to] == false);
312 
313         if (isContract(_to)) {
314             require(balances[msg.sender] >= _value);
315             balances[msg.sender] = balances[msg.sender].sub(_value);
316             balances[_to] = balances[_to].add(_value);
317             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
318             LogTransfer(msg.sender, _to, _value, _data);
319             LogTransfer(msg.sender, _to, _value);
320             return true;
321         } else {
322             return transferToAddress(_to, _value, _data);
323         }
324     }
325 
326     function transfer(address _to, uint256 _value, bytes _data) canTrans public  returns (bool success) {
327         require(_value > 0
328                 && blacklist[msg.sender] == false 
329                 && blacklist[_to] == false);
330 
331         if (isContract(_to)) {
332             return transferToContract(_to, _value, _data);
333         } else {
334             return transferToAddress(_to, _value, _data);
335         }
336     }
337 
338     function transfer(address _to, uint256 _value) canTrans public returns (bool success) {
339         require(_value > 0
340                 && blacklist[msg.sender] == false 
341                 && blacklist[_to] == false);
342 
343         bytes memory empty;
344         if (isContract(_to)) {
345             return transferToContract(_to, _value, empty);
346         } else {
347             return transferToAddress(_to, _value, empty);
348         }
349     }
350     function isContract(address _addr) private view returns (bool is_contract) {
351         uint length;
352         assembly {
353             //retrieve the size of the code on target address, this needs assembly
354             length := extcodesize(_addr)
355         }
356         return (length > 0);
357     }
358 
359     // function that is called when transaction target is an address
360     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
361         require(balances[msg.sender] >= _value);
362         balances[msg.sender] = balances[msg.sender].sub(_value);
363         balances[_to] = balances[_to].add(_value);
364         LogTransfer(msg.sender, _to, _value, _data);
365         LogTransfer(msg.sender, _to, _value);
366         return true;
367     }
368 
369     // function that is called when transaction target is a contract
370     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
371         require(balances[msg.sender] >= _value);
372         balances[msg.sender] = balances[msg.sender].sub(_value);
373         balances[_to] = balances[_to].add(_value);
374         ContractReceiver receiver = ContractReceiver(_to);
375         receiver.tokenFallback(msg.sender, _value, _data);
376         LogTransfer(msg.sender, _to, _value, _data);
377         LogTransfer(msg.sender, _to, _value);
378         return true;
379     }
380 
381     function transferFrom(address _from, address _to, uint256 _value) canTrans public returns (bool success) {
382         require(_to != address(0)
383                 && _value > 0
384                 && balances[_from] >= _value
385                 && allowed[_from][msg.sender] >= _value
386                 && blacklist[_from] == false 
387                 && blacklist[_to] == false);
388 
389         balances[_from] = balances[_from].sub(_value);
390         balances[_to] = balances[_to].add(_value);
391         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
392         LogTransfer(_from, _to, _value);
393         return true;
394     }
395   
396     function approve(address _spender, uint256 _value) public returns (bool success) {
397         allowed[msg.sender][_spender] = _value;
398         LogApproval(msg.sender, _spender, _value);
399         return true;
400     }
401 
402     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
403         return allowed[_owner][_spender];
404     }
405     
406     function getTokenBalance(address tokenAddress, address who) constant public returns (uint256){
407         ForeignToken t = ForeignToken(tokenAddress);
408         uint256 bal = t.balanceOf(who);
409         return bal;
410     }
411     
412     function withdraw(address receiveAddress) onlyOwner public {
413         uint256 etherBalance = this.balance;
414         if(!receiveAddress.send(etherBalance))revert();   
415 
416     }
417     
418     function burn(uint256 _value) onlyOwner public {
419         require(_value <= balances[msg.sender]);
420         address burner = msg.sender;
421         balances[burner] = balances[burner].sub(_value);
422         _totalSupply = _totalSupply.sub(_value);
423         totalDistributed = totalDistributed.sub(_value);
424         LogBurn(burner, _value);
425     }
426     
427     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
428         ForeignToken token = ForeignToken(_tokenContract);
429         uint256 amount = token.balanceOf(address(this));
430         return token.transfer(owner, amount);
431     }
432     function name() public view returns (string Name) {
433         return _name;
434     }
435 
436     function symbol() public view returns (string Symbol) {
437         return _symbol;
438     }
439 
440     function decimals() public view returns (uint8 Decimals) {
441         return _decimals;
442     }
443 
444     function totalSupply() public view returns (uint256 TotalSupply) {
445         return _totalSupply;
446     }
447 
448     function balanceOf(address _owner) public view returns (uint256 balance) {
449         return balances[_owner];
450     }
451 
452 }