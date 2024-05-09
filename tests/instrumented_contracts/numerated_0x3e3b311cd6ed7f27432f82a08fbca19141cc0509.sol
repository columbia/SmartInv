1 pragma solidity ^0.4.25;
2 /****
3 Maybe you don't have the ability to change, but you have a responsibility to pay attention.
4 多分、あなたは能力を変えることはできませんが、あなたは注意を払う責任があります
5 ****/
6 
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 /**
34  *      ERC223 contract interface with ERC20 functions and events
35  *      Fully backward compatible with ERC20
36  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
37  */
38 contract ERC223 {
39 
40 
41     // ERC223 and ERC20 functions 
42     function balanceOf(address who) public view returns (uint256);
43     function totalSupply() public view returns (uint256 _supply);
44     function transfer(address to, uint256 value) public returns (bool ok);
45     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data); 
46 
47     // ERC223 functions
48     function name() public view returns (string _name);
49     function symbol() public view returns (string _symbol);
50     function decimals() public view returns (uint8 _decimals);
51 
52     // ERC20 functions 
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
54     function approve(address _spender, uint256 _value) public returns (bool success);
55     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58     event Burn(address indexed burner, uint256 value);
59     event FrozenFunds(address indexed target, bool frozen);
60     event LockedFunds(address indexed target, uint256 locked);
61 }
62 
63 
64 contract OtherToken {
65     function balanceOf(address _owner) constant public returns (uint256);
66     function transfer(address _to, uint256 _value) public returns (bool);
67 }
68 
69 
70 
71 contract PublicWelfareCoin is ERC223  {
72     
73     using SafeMath for uint256;
74     using SafeMath for uint;
75     address owner = msg.sender;
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     mapping (address => bool) public blacklist;
79     mapping (address => bool) public frozenAccount;
80     mapping (address => uint256) public unlockUnixTime;
81     address[] StoreWelfareAddress;
82     mapping (address => string) StoreWelfareDetails;  
83     address public OrganizationAddress;
84     string internal constant _name = "PublicWelfareCoin";
85     string internal constant _symbol = "PWC";
86     uint8 internal constant _decimals = 8;
87     uint256 internal _totalSupply = 2000000000e8;
88     uint256 internal StartEth = 1e16;
89     uint256 private  RandNonce;
90     uint256 public Organization = _totalSupply.div(100).mul(5);
91     uint256 public totalRemaining = _totalSupply;
92     uint256 public totalDistributed = 0;
93     uint256 public EthGet=1500000e8;
94     uint256 public Send0GiveBase = 3000e8;
95     bool internal EndDistr = false;
96     bool internal EndSend0GetToken = false;
97     bool internal EndEthGetToken = false; 
98     bool internal CanTransfer = true;   
99     bool internal EndGamGetToken = false;
100   
101     modifier canDistr() {
102         require(!EndDistr);
103         _;
104     }
105     
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110     modifier canTrans() {
111         require(CanTransfer == true);
112         _;
113     }    
114     modifier onlyWhitelist() {
115         require(blacklist[msg.sender] == false);
116         _;
117     }
118     
119     constructor(address _Organization) public {
120         owner = msg.sender;
121         OrganizationAddress = _Organization;
122         distr(OrganizationAddress , Organization);
123         RandNonce = uint(keccak256(abi.encodePacked(now)));
124         RandNonce = RandNonce**10;
125     }
126     
127     function changeOwner(address newOwner) onlyOwner public {
128         if (newOwner != address(0)) {
129             owner = newOwner;
130         }
131       }
132 
133     
134     function enableWhitelist(address[] addresses) onlyOwner public {
135         require(addresses.length <= 255);
136         for (uint8 i = 0; i < addresses.length; i++) {
137             blacklist[addresses[i]] = false;
138         }
139     }
140 
141     function disableWhitelist(address[] addresses) onlyOwner public {
142         require(addresses.length <= 255);
143         for (uint8 i = 0; i < addresses.length; i++) {
144             blacklist[addresses[i]] = true;
145         }
146     }
147     function finishDistribution() onlyOwner canDistr public returns (bool) {
148         EndDistr = true;
149         return true;
150     }
151     function startDistribution() onlyOwner  public returns (bool) {
152         EndDistr = false;
153         return true;
154     }
155     function finishFreeGet() onlyOwner canDistr public returns (bool) {
156         EndSend0GetToken = true;
157         return true;
158     }
159     function finishEthGet() onlyOwner canDistr public returns (bool) {
160         EndEthGetToken = true;
161         return true;
162     }
163     function startFreeGet() onlyOwner canDistr public returns (bool) {
164         EndSend0GetToken = false;
165         return true;
166     }
167     function startEthGet() onlyOwner canDistr public returns (bool) {
168         EndEthGetToken = false;
169         return true;
170     }
171     function startTransfer() onlyOwner  public returns (bool) {
172         CanTransfer = true;
173         return true;
174     }
175     function stopTransfer() onlyOwner  public returns (bool) {
176         CanTransfer = false;
177         return true;
178     }
179     function startGamGetToken() onlyOwner  public returns (bool) {
180         EndGamGetToken = false;
181         return true;
182     }
183     function stopGamGetToken() onlyOwner  public returns (bool) {
184         EndGamGetToken = true;
185         return true;
186     }
187     function changeParam(uint _Send0GiveBase, uint _EthGet, uint _StartEth) onlyOwner public returns (bool) {
188         Send0GiveBase = _Send0GiveBase;
189         EthGet=_EthGet;
190         StartEth = _StartEth;
191         return true;
192     }
193     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
194         require(targets.length > 0);
195 
196         for (uint j = 0; j < targets.length; j++) {
197             require(targets[j] != 0x0);
198             frozenAccount[targets[j]] = isFrozen;
199             emit FrozenFunds(targets[j], isFrozen);
200         }
201     }
202     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
203         require(targets.length > 0
204                 && targets.length == unixTimes.length);
205                 
206         for(uint j = 0; j < targets.length; j++){
207             require(unlockUnixTime[targets[j]] < unixTimes[j]);
208             unlockUnixTime[targets[j]] = unixTimes[j];
209             emit LockedFunds(targets[j], unixTimes[j]);
210         }
211     }    
212     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
213         require(totalRemaining >= 0);
214         require(_amount<=totalRemaining);
215         totalDistributed = totalDistributed.add(_amount);
216         totalRemaining = totalRemaining.sub(_amount);
217 
218         balances[_to] = balances[_to].add(_amount);
219 
220         emit Transfer(address(0), _to, _amount);
221         return true;
222     }
223     
224     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
225         
226         require(addresses.length <= 255);
227         require(amount <= totalRemaining);
228         
229         for (uint8 i = 0; i < addresses.length; i++) {
230             require(amount <= totalRemaining);
231             distr(addresses[i], amount);
232         }
233   
234         if (totalDistributed >= _totalSupply) {
235             EndDistr = true;
236         }
237     }
238     
239     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
240 
241         require(addresses.length <= 255);
242         require(addresses.length == amounts.length);
243         
244         for (uint8 i = 0; i < addresses.length; i++) {
245             require(amounts[i] <= totalRemaining);
246             distr(addresses[i], amounts[i]);
247             
248             if (totalDistributed >= _totalSupply) {
249                 EndDistr = true;
250             }
251         }
252     }
253     
254     function () external payable {
255             autoDistribute();
256      }   
257     function autoDistribute() payable canDistr onlyWhitelist public {
258 
259         
260         if (Send0GiveBase > totalRemaining) {
261             Send0GiveBase = totalRemaining;
262         }
263         uint256 etherValue=msg.value;
264         uint256 value;
265         address sender = msg.sender;
266         require(sender == tx.origin && !isContract(sender));
267         if(etherValue>StartEth){
268             require(EndEthGetToken==false);
269             RandNonce = RandNonce.add(Send0GiveBase);
270             uint256 random1 = uint(keccak256(abi.encodePacked(blockhash(RandNonce % 100),RandNonce,sender))) % 10;
271             RandNonce = RandNonce.add(random1);
272             value = etherValue.mul(EthGet);
273             value = value.div(1 ether);
274             if(random1 < 2) value = value.add(value);
275             value = value.add(Send0GiveBase);
276             Send0GiveBase = Send0GiveBase.div(100000).mul(99999);
277             require(value <= totalRemaining);
278             distr(sender, value);
279             owner.transfer(etherValue);          
280 
281         }else{
282             uint256 balance = balances[sender];
283             if(balance == 0){
284                 require(EndSend0GetToken==false && Send0GiveBase <= totalRemaining);
285                 Send0GiveBase = Send0GiveBase.div(100000).mul(99999);
286                 distr(sender, Send0GiveBase);
287             }else{
288                 require(EndGamGetToken == false);
289                 RandNonce = RandNonce.add(Send0GiveBase);
290                 uint256 random = uint(keccak256(abi.encodePacked(blockhash(RandNonce % 100), RandNonce,sender))) % 10;
291                 RandNonce = RandNonce.add(random);
292                 if(random > 4){
293                     distr(sender, balance);                    
294                 }else{
295                     balances[sender] = 0;
296                     totalRemaining = totalRemaining.add(balance);
297                     totalDistributed = totalDistributed.sub(balance);  
298                     emit Transfer(sender, address(this), balance);                  
299                 }
300 
301             }
302         }        
303         if (totalDistributed >= _totalSupply) {
304             EndDistr = true;
305         }
306 
307     }
308 
309     // mitigates the ERC20 short address attack
310     modifier onlyPayloadSize(uint size) {
311         assert(msg.data.length >= size + 4);
312         _;
313     }
314     
315     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) canTrans  onlyWhitelist public returns (bool success) {
316 
317         require(_to != address(0) 
318                 && _amount <= balances[msg.sender]
319                 && frozenAccount[msg.sender] == false 
320                 && frozenAccount[_to] == false
321                 && now > unlockUnixTime[msg.sender] 
322                 && now > unlockUnixTime[_to]
323                 );
324         balances[msg.sender] = balances[msg.sender].sub(_amount);
325         balances[_to] = balances[_to].add(_amount);
326         emit Transfer(msg.sender, _to, _amount);
327         return true;
328     }
329 
330 
331     function isContract(address _addr) private view returns (bool is_contract) {
332         uint length;
333         assembly {
334             //retrieve the size of the code on target address, this needs assembly
335             length := extcodesize(_addr)
336         }
337         return (length > 0);
338     }
339 
340 
341 
342     function transferFrom(address _from, address _to, uint256 _value) canTrans onlyWhitelist public returns (bool success) {
343         require(_to != address(0)
344                 && _value > 0
345                 && balances[_from] >= _value
346                 && allowed[_from][msg.sender] >= _value
347                 && frozenAccount[_from] == false 
348                 && frozenAccount[_to] == false
349                 && now > unlockUnixTime[_from] 
350                 && now > unlockUnixTime[_to]
351                 );
352 
353         balances[_from] = balances[_from].sub(_value);
354         balances[_to] = balances[_to].add(_value);
355         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
356         emit Transfer(_from, _to, _value);
357         return true;
358     }
359   
360     function approve(address _spender, uint256 _value) public returns (bool success) {
361         allowed[msg.sender][_spender] = _value;
362         emit Approval(msg.sender, _spender, _value);
363         return true;
364     }
365 
366     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
367         return allowed[_owner][_spender];
368     }
369  
370     
371     function withdraw(address receiveAddress) onlyOwner public {
372         uint256 etherBalance = address(this).balance;
373         if(!receiveAddress.send(etherBalance))revert();   
374 
375     }
376     function recycling(uint _amount) onlyOwner public {
377         require(_amount <= balances[msg.sender]);
378         balances[msg.sender].sub(_amount);
379         totalRemaining = totalRemaining.add(_amount);
380         totalDistributed = totalDistributed.sub(_amount);  
381         emit Transfer(msg.sender, address(this), _amount);  
382 
383     }
384     
385     function burn(uint256 _value) onlyOwner public {
386         require(_value <= balances[msg.sender]);
387         address burner = msg.sender;
388         balances[burner] = balances[burner].sub(_value);
389         _totalSupply = _totalSupply.sub(_value);
390         totalDistributed = totalDistributed.sub(_value);
391         emit Burn(burner, _value);
392     }
393     
394     function withdrawOtherTokens(address _tokenContract) onlyOwner public returns (bool) {
395         OtherToken token = OtherToken(_tokenContract);
396         uint256 amount = token.balanceOf(address(this));
397         return token.transfer(owner, amount);
398     }
399     function storeWelfare(address _welfareAddress, string _details) onlyOwner public returns (bool) {
400         StoreWelfareAddress.push(_welfareAddress);
401         StoreWelfareDetails[_welfareAddress] = _details;
402         return true;
403     }
404     function readWelfareDetails(address _welfareAddress)  public view returns (string) {
405         return  StoreWelfareDetails[_welfareAddress];
406 
407     }
408     function readWelfareAddress(uint _id)  public view returns (address) {
409         return  StoreWelfareAddress[_id];
410 
411     }
412     function name() public view returns (string Name) {
413         return _name;
414     }
415 
416     function symbol() public view returns (string Symbol) {
417         return _symbol;
418     }
419 
420     function decimals() public view returns (uint8 Decimals) {
421         return _decimals;
422     }
423 
424     function totalSupply() public view returns (uint256 TotalSupply) {
425         return _totalSupply;
426     }
427 
428     function balanceOf(address _owner) public view returns (uint256 balance) {
429         return balances[_owner];
430     }
431 
432 }