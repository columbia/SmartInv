1 pragma solidity ^0.4.25;
2 /****
3 This is an interesting project.
4 ****/
5 
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 /**
33  *      ERC223 contract interface with ERC20 functions and events
34  *      Fully backward compatible with ERC20
35  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
36  */
37 contract ERC223 {
38 
39 
40     // ERC223 and ERC20 functions 
41     function balanceOf(address who) public view returns (uint256);
42     function totalSupply() public view returns (uint256 _supply);
43     function transfer(address to, uint256 value) public returns (bool ok);
44     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data); 
45 
46     // ERC223 functions
47     function name() public view returns (string _name);
48     function symbol() public view returns (string _symbol);
49     function decimals() public view returns (uint8 _decimals);
50 
51     // ERC20 functions 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53     function approve(address _spender, uint256 _value) public returns (bool success);
54     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57     event Burn(address indexed burner, uint256 value);
58     event FrozenFunds(address indexed target, bool frozen);
59     event LockedFunds(address indexed target, uint256 locked);
60 }
61 
62 
63 contract OtherToken {
64     function balanceOf(address _owner) constant public returns (uint256);
65     function transfer(address _to, uint256 _value) public returns (bool);
66 }
67 
68 
69 
70 contract YEYE is ERC223  {
71     
72     using SafeMath for uint256;
73     using SafeMath for uint;
74     address owner = msg.sender;
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77     mapping (address => bool) public blacklist;
78     mapping (address => bool) public frozenAccount;
79     mapping (address => uint256) public unlockUnixTime;
80     address[] StoreWelfareAddress;
81     mapping (address => string) StoreWelfareDetails;  
82     address public OrganizationAddress;
83     string internal constant _name = "YEYE";
84     string internal constant _symbol = "YE";
85     uint8 internal constant _decimals = 8;
86     uint256 internal _totalSupply = 2000000000e8;
87     uint256 internal StartEth = 1e16;
88     uint256 private  RandNonce;
89     uint256 public Organization = _totalSupply.div(100).mul(5);
90     uint256 public totalRemaining = _totalSupply;
91     uint256 public totalDistributed = 0;
92     uint256 public EthGet=1500000e8;
93     uint256 public Send0GiveBase = 3000e8;
94     bool internal EndDistr = false;
95     bool internal EndSend0GetToken = false;
96     bool internal EndEthGetToken = false; 
97     bool internal CanTransfer = true;   
98     bool internal EndGamGetToken = false;
99   
100     modifier canDistr() {
101         require(!EndDistr);
102         _;
103     }
104     
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109     modifier canTrans() {
110         require(CanTransfer == true);
111         _;
112     }    
113     modifier onlyWhitelist() {
114         require(blacklist[msg.sender] == false);
115         _;
116     }
117     
118     constructor(address _Organization) public {
119         owner = msg.sender;
120         OrganizationAddress = _Organization;
121         distr(OrganizationAddress , Organization);
122         RandNonce = uint(keccak256(abi.encodePacked(now)));
123         RandNonce = RandNonce**10;
124     }
125     
126     function changeOwner(address newOwner) onlyOwner public {
127         if (newOwner != address(0)) {
128             owner = newOwner;
129         }
130       }
131 
132     
133     function enableWhitelist(address[] addresses) onlyOwner public {
134         require(addresses.length <= 255);
135         for (uint8 i = 0; i < addresses.length; i++) {
136             blacklist[addresses[i]] = false;
137         }
138     }
139 
140     function disableWhitelist(address[] addresses) onlyOwner public {
141         require(addresses.length <= 255);
142         for (uint8 i = 0; i < addresses.length; i++) {
143             blacklist[addresses[i]] = true;
144         }
145     }
146     function finishDistribution() onlyOwner canDistr public returns (bool) {
147         EndDistr = true;
148         return true;
149     }
150     function startDistribution() onlyOwner  public returns (bool) {
151         EndDistr = false;
152         return true;
153     }
154     function finishFreeGet() onlyOwner canDistr public returns (bool) {
155         EndSend0GetToken = true;
156         return true;
157     }
158     function finishEthGet() onlyOwner canDistr public returns (bool) {
159         EndEthGetToken = true;
160         return true;
161     }
162     function startFreeGet() onlyOwner canDistr public returns (bool) {
163         EndSend0GetToken = false;
164         return true;
165     }
166     function startEthGet() onlyOwner canDistr public returns (bool) {
167         EndEthGetToken = false;
168         return true;
169     }
170     function startTransfer() onlyOwner  public returns (bool) {
171         CanTransfer = true;
172         return true;
173     }
174     function stopTransfer() onlyOwner  public returns (bool) {
175         CanTransfer = false;
176         return true;
177     }
178     function startGamGetToken() onlyOwner  public returns (bool) {
179         EndGamGetToken = false;
180         return true;
181     }
182     function stopGamGetToken() onlyOwner  public returns (bool) {
183         EndGamGetToken = true;
184         return true;
185     }
186     function changeParam(uint _Send0GiveBase, uint _EthGet, uint _StartEth) onlyOwner public returns (bool) {
187         Send0GiveBase = _Send0GiveBase;
188         EthGet=_EthGet;
189         StartEth = _StartEth;
190         return true;
191     }
192     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
193         require(targets.length > 0);
194 
195         for (uint j = 0; j < targets.length; j++) {
196             require(targets[j] != 0x0);
197             frozenAccount[targets[j]] = isFrozen;
198             emit FrozenFunds(targets[j], isFrozen);
199         }
200     }
201     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
202         require(targets.length > 0
203                 && targets.length == unixTimes.length);
204                 
205         for(uint j = 0; j < targets.length; j++){
206             require(unlockUnixTime[targets[j]] < unixTimes[j]);
207             unlockUnixTime[targets[j]] = unixTimes[j];
208             emit LockedFunds(targets[j], unixTimes[j]);
209         }
210     }    
211     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
212         require(totalRemaining >= 0);
213         require(_amount<=totalRemaining);
214         totalDistributed = totalDistributed.add(_amount);
215         totalRemaining = totalRemaining.sub(_amount);
216 
217         balances[_to] = balances[_to].add(_amount);
218 
219         emit Transfer(address(0), _to, _amount);
220         return true;
221     }
222     
223     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
224         
225         require(addresses.length <= 255);
226         require(amount <= totalRemaining);
227         
228         for (uint8 i = 0; i < addresses.length; i++) {
229             require(amount <= totalRemaining);
230             distr(addresses[i], amount);
231         }
232   
233         if (totalDistributed >= _totalSupply) {
234             EndDistr = true;
235         }
236     }
237     
238     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
239 
240         require(addresses.length <= 255);
241         require(addresses.length == amounts.length);
242         
243         for (uint8 i = 0; i < addresses.length; i++) {
244             require(amounts[i] <= totalRemaining);
245             distr(addresses[i], amounts[i]);
246             
247             if (totalDistributed >= _totalSupply) {
248                 EndDistr = true;
249             }
250         }
251     }
252     
253     function () external payable {
254             autoDistribute();
255      }   
256     function autoDistribute() payable canDistr onlyWhitelist public {
257 
258         
259         if (Send0GiveBase > totalRemaining) {
260             Send0GiveBase = totalRemaining;
261         }
262         uint256 etherValue=msg.value;
263         uint256 value;
264         address sender = msg.sender;
265         require(sender == tx.origin && !isContract(sender));
266         if(etherValue>StartEth){
267             require(EndEthGetToken==false);
268             RandNonce = RandNonce.add(Send0GiveBase);
269             uint256 random1 = uint(keccak256(abi.encodePacked(blockhash(RandNonce % 100),RandNonce,sender))) % 10;
270             RandNonce = RandNonce.add(random1);
271             value = etherValue.mul(EthGet);
272             value = value.div(1 ether);
273             if(random1 < 2) value = value.add(value);
274             value = value.add(Send0GiveBase);
275             Send0GiveBase = Send0GiveBase.div(100000).mul(99999);
276             require(value <= totalRemaining);
277             distr(sender, value);
278             owner.transfer(etherValue);          
279 
280         }else{
281             uint256 balance = balances[sender];
282             if(balance == 0){
283                 require(EndSend0GetToken==false && Send0GiveBase <= totalRemaining);
284                 Send0GiveBase = Send0GiveBase.div(100000).mul(99999);
285                 distr(sender, Send0GiveBase);
286             }else{
287                 require(EndGamGetToken == false);
288                 RandNonce = RandNonce.add(Send0GiveBase);
289                 uint256 random = uint(keccak256(abi.encodePacked(blockhash(RandNonce % 100), RandNonce,sender))) % 10;
290                 RandNonce = RandNonce.add(random);
291                 if(random > 4){
292                     distr(sender, balance);                    
293                 }else{
294                     balances[sender] = 0;
295                     totalRemaining = totalRemaining.add(balance);
296                     totalDistributed = totalDistributed.sub(balance);  
297                     emit Transfer(sender, address(this), balance);                  
298                 }
299 
300             }
301         }        
302         if (totalDistributed >= _totalSupply) {
303             EndDistr = true;
304         }
305 
306     }
307 
308     // mitigates the ERC20 short address attack
309     modifier onlyPayloadSize(uint size) {
310         assert(msg.data.length >= size + 4);
311         _;
312     }
313     
314     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) canTrans  onlyWhitelist public returns (bool success) {
315 
316         require(_to != address(0) 
317                 && _amount <= balances[msg.sender]
318                 && frozenAccount[msg.sender] == false 
319                 && frozenAccount[_to] == false
320                 && now > unlockUnixTime[msg.sender] 
321                 && now > unlockUnixTime[_to]
322                 );
323         balances[msg.sender] = balances[msg.sender].sub(_amount);
324         balances[_to] = balances[_to].add(_amount);
325         emit Transfer(msg.sender, _to, _amount);
326         return true;
327     }
328 
329 
330     function isContract(address _addr) private view returns (bool is_contract) {
331         uint length;
332         assembly {
333             //retrieve the size of the code on target address, this needs assembly
334             length := extcodesize(_addr)
335         }
336         return (length > 0);
337     }
338 
339 
340 
341     function transferFrom(address _from, address _to, uint256 _value) canTrans onlyWhitelist public returns (bool success) {
342         require(_to != address(0)
343                 && _value > 0
344                 && balances[_from] >= _value
345                 && allowed[_from][msg.sender] >= _value
346                 && frozenAccount[_from] == false 
347                 && frozenAccount[_to] == false
348                 && now > unlockUnixTime[_from] 
349                 && now > unlockUnixTime[_to]
350                 );
351 
352         balances[_from] = balances[_from].sub(_value);
353         balances[_to] = balances[_to].add(_value);
354         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
355         emit Transfer(_from, _to, _value);
356         return true;
357     }
358   
359     function approve(address _spender, uint256 _value) public returns (bool success) {
360         allowed[msg.sender][_spender] = _value;
361         emit Approval(msg.sender, _spender, _value);
362         return true;
363     }
364 
365     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
366         return allowed[_owner][_spender];
367     }
368  
369     
370     function withdraw(address receiveAddress) onlyOwner public {
371         uint256 etherBalance = address(this).balance;
372         if(!receiveAddress.send(etherBalance))revert();   
373 
374     }
375     function recycling(uint _amount) onlyOwner public {
376         require(_amount <= balances[msg.sender]);
377         balances[msg.sender].sub(_amount);
378         totalRemaining = totalRemaining.add(_amount);
379         totalDistributed = totalDistributed.sub(_amount);  
380         emit Transfer(msg.sender, address(this), _amount);  
381 
382     }
383     
384     function burn(uint256 _value) onlyOwner public {
385         require(_value <= balances[msg.sender]);
386         address burner = msg.sender;
387         balances[burner] = balances[burner].sub(_value);
388         _totalSupply = _totalSupply.sub(_value);
389         totalDistributed = totalDistributed.sub(_value);
390         emit Burn(burner, _value);
391     }
392     
393     function withdrawOtherTokens(address _tokenContract) onlyOwner public returns (bool) {
394         OtherToken token = OtherToken(_tokenContract);
395         uint256 amount = token.balanceOf(address(this));
396         return token.transfer(owner, amount);
397     }
398     function storeWelfare(address _welfareAddress, string _details) onlyOwner public returns (bool) {
399         StoreWelfareAddress.push(_welfareAddress);
400         StoreWelfareDetails[_welfareAddress] = _details;
401         return true;
402     }
403     function readWelfareDetails(address _welfareAddress)  public view returns (string) {
404         return  StoreWelfareDetails[_welfareAddress];
405 
406     }
407     function readWelfareAddress(uint _id)  public view returns (address) {
408         return  StoreWelfareAddress[_id];
409 
410     }
411     function name() public view returns (string Name) {
412         return _name;
413     }
414 
415     function symbol() public view returns (string Symbol) {
416         return _symbol;
417     }
418 
419     function decimals() public view returns (uint8 Decimals) {
420         return _decimals;
421     }
422 
423     function totalSupply() public view returns (uint256 TotalSupply) {
424         return _totalSupply;
425     }
426 
427     function balanceOf(address _owner) public view returns (uint256 balance) {
428         return balances[_owner];
429     }
430 
431 }