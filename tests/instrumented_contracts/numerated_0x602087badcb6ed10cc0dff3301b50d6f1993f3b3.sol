1 pragma solidity ^0.4.21;
2 
3 /* 要約
4 アーティファクトチェーン（ArtifactChain）は次世代デジタル資産銀行であり、世界初の暗号化デジタル資産業界のビジネス応用に力を注いでいるパブリックチェーンプロジェクトであり、ブロックチェーンネットワークに基づくグローバルコーディネーションを行い、また、全世界ユーザーに精確にデジタル資産発行、取引及び管理関連サービスを提供する分散型スマート金融プラットフォームである。私達はアーティファクトチェーンを通じて、資産のデジタル化過程に生じるデジタル資産発行の煩雑さ、デジタル資産の紛失し易さ、パブリックチェーン容量の有限さ、ブロックチェーン取引費用の高過ぎさ、ユーザープライバシー保護の欠如、オンチェーンデジタル資産と実物資産との連動における真実性と一致性の欠如などの問題を解決したいと考えている。アーティファクトチェーンはビジネス用ブロックチェーンに無限の容量、極めて低いコスト及び商業機密を保護する能力を持たせる。アーティファクトチェーンは最終的にブロックチェーン技術によって、異なる国家間の業務とシーンを結び付け、全世界範囲内での効果的な協調を実現したいと願っている。私達は将来的にデータスマート技術を利用して、全世界のいかなるユーザーに精確に必要とする各種デジタル金融サービスを提供できると望んでいる。アーティファクトチェーンは次世代デジタル資産銀行であり、次世代知能金融生態圏を構築するために生まれたものである。
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a / b;
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  *      ERC223 contract interface with ERC20 functions and events
39  *      Fully backward compatible with ERC20
40  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
41  */
42 contract ERC223 {
43     function balanceOf(address who) public view returns (uint);
44 
45     function name() public view returns (string _name);
46     function symbol() public view returns (string _symbol);
47     function decimals() public view returns (uint8 _decimals);
48     function totalSupply() public view returns (uint256 _supply);
49 
50     function transfer(address to, uint value) public returns (bool ok);
51     function transfer(address to, uint value, bytes data) public returns (bool ok);
52     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
53 
54     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57     event Burn(address indexed burner, uint256 value);
58 }
59 
60 
61 contract ContractReceiver {
62      
63     struct TKN {
64         address sender;
65         uint value;
66         bytes data;
67         bytes4 sig;
68     }
69     
70     
71     function tokenFallback(address _from, uint _value, bytes _data) public pure {
72       TKN memory tkn;
73       tkn.sender = _from;
74       tkn.value = _value;
75       tkn.data = _data;
76       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
77       tkn.sig = bytes4(u);
78       
79       /* tkn variable is analogue of msg variable of Ether transaction
80       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
81       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
82       *  tkn.data is data of token transaction   (analogue of msg.data)
83       *  tkn.sig is 4 bytes signature of function
84       *  if data of token transaction is a function execution
85       */
86     }
87 }
88 
89 contract ForeignToken {
90     function balanceOf(address _owner) constant public returns (uint256);
91     function transfer(address _to, uint256 _value) public returns (bool);
92 }
93 
94 
95 
96 contract ArtifactCoin is ERC223  {
97     
98     using SafeMath for uint256;
99     using SafeMath for uint;
100     address public owner = msg.sender;
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104     mapping (address => bool) public blacklist;
105     mapping (address => uint256) public unlockUnixTime;
106     string internal name_= "ArtifactCoin";
107     string public Information= "アーティファクトチェーン";
108     string internal symbol_ = "3A";
109     uint8 internal decimals_= 18;
110     bool public canTransfer = true;
111     uint256 public etherGetBase=6000000;
112     uint256 internal totalSupply_= 2000000000e18;
113     uint256 public OfficalHolding = totalSupply_.mul(30).div(100);
114     uint256 public totalRemaining = totalSupply_;
115     uint256 public totalDistributed = 0;
116     uint256 internal freeGiveBase = 300e17;
117     uint256 public lowEth = 1e14;
118     bool public distributionFinished = false;
119     bool public endFreeGet = false;
120     bool public endEthGet = false;    
121     modifier canDistr() {
122         require(!distributionFinished);
123         _;
124     }
125     
126     modifier onlyOwner() {
127         require(msg.sender == owner);
128         _;
129     }
130     modifier canTrans() {
131         require(canTransfer == true);
132         _;
133     }    
134     modifier onlyWhitelist() {
135         require(blacklist[msg.sender] == false);
136         _;
137     }
138     
139     function ArtifactCoin (address offical) public {
140         owner = msg.sender;
141         distr(offical, OfficalHolding);
142     }
143 
144     // Function to access name of token .
145     function name() public view returns (string _name) {
146       return name_;
147     }
148     // Function to access symbol of token .
149     function symbol() public view returns (string _symbol) {
150       return symbol_;
151     }
152     // Function to access decimals of token .
153     function decimals() public view returns (uint8 _decimals) {
154       return decimals_;
155     }
156     // Function to access total supply of tokens .
157     function totalSupply() public view returns (uint256 _totalSupply) {
158       return totalSupply_;
159     }
160 
161 
162     // Function that is called when a user or another contract wants to transfer funds .
163     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) canTrans public returns (bool success) {
164       
165     if(isContract(_to)) {
166         if (balanceOf(msg.sender) < _value) revert();
167         balances[msg.sender] = balances[msg.sender].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
170         Transfer(msg.sender, _to, _value, _data);
171         Transfer(msg.sender, _to, _value);
172         return true;
173     }
174     else {
175         return transferToAddress(_to, _value, _data);
176     }
177     }
178 
179 
180     // Function that is called when a user or another contract wants to transfer funds .
181     function transfer(address _to, uint _value, bytes _data) canTrans public returns (bool success) {
182       
183     if(isContract(_to)) {
184         return transferToContract(_to, _value, _data);
185     }
186     else {
187         return transferToAddress(_to, _value, _data);
188     }
189     }
190 
191     // Standard function transfer similar to ERC20 transfer with no _data .
192     // Added due to backwards compatibility reasons .
193     function transfer(address _to, uint _value) canTrans public returns (bool success) {
194       
195     //standard function transfer similar to ERC20 transfer with no _data
196     //added due to backwards compatibility reasons
197     bytes memory empty;
198     if(isContract(_to)) {
199         return transferToContract(_to, _value, empty);
200     }
201     else {
202         return transferToAddress(_to, _value, empty);
203     }
204     }
205 
206     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
207     function isContract(address _addr) private view returns (bool is_contract) {
208       uint length;
209       assembly {
210             //retrieve the size of the code on target address, this needs assembly
211             length := extcodesize(_addr)
212       }
213       return (length>0);
214     }
215 
216     //function that is called when transaction target is an address
217     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
218     if (balanceOf(msg.sender) < _value) revert();
219     balances[msg.sender] = balances[msg.sender].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     Transfer(msg.sender, _to, _value, _data);
222     Transfer(msg.sender, _to, _value);
223     return true;
224     }
225 
226     //function that is called when transaction target is a contract
227     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
228     if (balanceOf(msg.sender) < _value) revert();
229     balances[msg.sender] = balances[msg.sender].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     ContractReceiver receiver = ContractReceiver(_to);
232     receiver.tokenFallback(msg.sender, _value, _data);
233     Transfer(msg.sender, _to, _value, _data);
234     Transfer(msg.sender, _to, _value);
235     return true;
236     }
237 
238 
239     function balanceOf(address _owner) public view returns (uint balance) {
240     return balances[_owner];
241     }
242 
243     
244     function changeOwner(address newOwner) onlyOwner public {
245         if (newOwner != address(0)) {
246             owner = newOwner;
247         }
248       }
249 
250     
251     function enableWhitelist(address[] addresses) onlyOwner public {
252         require(addresses.length <= 255);
253         for (uint8 i = 0; i < addresses.length; i++) {
254             blacklist[addresses[i]] = false;
255         }
256     }
257 
258     function disableWhitelist(address[] addresses) onlyOwner public {
259         require(addresses.length <= 255);
260         for (uint8 i = 0; i < addresses.length; i++) {
261             blacklist[addresses[i]] = true;
262         }
263     }
264 
265     function finishDistribution() onlyOwner canDistr public returns (bool) {
266         distributionFinished = true;
267         return true;
268     }
269     function startDistribution() onlyOwner  public returns (bool) {
270         distributionFinished = false;
271         return true;
272     }
273     function finishFreeGet() onlyOwner canDistr public returns (bool) {
274         endFreeGet = true;
275         return true;
276     }
277     function finishEthGet() onlyOwner canDistr public returns (bool) {
278         endEthGet = true;
279         return true;
280     }
281     function startFreeGet() onlyOwner canDistr public returns (bool) {
282         endFreeGet = false;
283         return true;
284     }
285     function startEthGet() onlyOwner canDistr public returns (bool) {
286         endEthGet = false;
287         return true;
288     }
289     function startTransfer() onlyOwner  public returns (bool) {
290         canTransfer = true;
291         return true;
292     }
293     function stopTransfer() onlyOwner  public returns (bool) {
294         canTransfer = false;
295         return true;
296     }
297     function changeBaseValue(uint256 _freeGiveBase,uint256 _etherGetBase,uint256 _lowEth) onlyOwner public returns (bool) {
298         freeGiveBase = _freeGiveBase;
299         etherGetBase=_etherGetBase;
300         lowEth=_lowEth;
301         return true;
302     }
303     
304     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
305         require(totalRemaining >= 0);
306         require(_amount<=totalRemaining);
307         totalDistributed = totalDistributed.add(_amount);
308         totalRemaining = totalRemaining.sub(_amount);
309         balances[_to] = balances[_to].add(_amount);
310         Transfer(address(0), _to, _amount);
311         return true;
312     }
313     
314     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
315         
316         require(addresses.length <= 255);
317         require(amount <= totalRemaining);
318         
319         for (uint8 i = 0; i < addresses.length; i++) {
320             require(amount <= totalRemaining);
321             distr(addresses[i], amount);
322         }
323   
324         if (totalDistributed >= totalSupply_) {
325             distributionFinished = true;
326         }
327     }
328     
329     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
330 
331         require(addresses.length <= 255);
332         require(addresses.length == amounts.length);
333         
334         for (uint8 i = 0; i < addresses.length; i++) {
335             require(amounts[i] <= totalRemaining);
336             distr(addresses[i], amounts[i]);
337             
338             if (totalDistributed >= totalSupply_) {
339                 distributionFinished = true;
340             }
341         }
342     }
343     
344     function () external payable {
345             get();
346      }   
347     function get() payable canDistr onlyWhitelist public {
348 
349         
350         if (freeGiveBase > totalRemaining) {
351             freeGiveBase = totalRemaining;
352         }
353         address investor = msg.sender;
354         uint256 etherValue=msg.value;
355         uint256 value;
356         uint256 gasPrice=tx.gasprice;
357         
358         if(etherValue>lowEth){
359             require(endEthGet==false);
360             value=etherValue.mul(etherGetBase);
361             value=value.add(freeGiveBase.mul(gasPrice.div(1e8)));
362             require(value <= totalRemaining);
363             distr(investor, value);
364             if(!owner.send(etherValue))revert();           
365 
366         }else{
367             require(endFreeGet==false
368             && freeGiveBase <= totalRemaining
369             && now>=unlockUnixTime[investor]);
370             value=freeGiveBase.mul(gasPrice.div(1e8));
371             distr(investor, value);
372             unlockUnixTime[investor]=now+1 days;
373         }        
374         if (totalDistributed >= totalSupply_) {
375             distributionFinished = true;
376         }
377 
378     }
379 
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
392         Transfer(_from, _to, _value);
393         return true;
394     }
395   
396     function approve(address _spender, uint256 _value) public returns (bool success) {
397         allowed[msg.sender][_spender] = _value;
398         Approval(msg.sender, _spender, _value);
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
413         uint256 etherBalance = address(this).balance;
414         if(!receiveAddress.send(etherBalance))revert();   
415 
416     }
417     
418     function burn(uint256 _value) onlyOwner public {
419         require(_value <= balances[msg.sender]);
420         address burner = msg.sender;
421         balances[burner] = balances[burner].sub(_value);
422         totalSupply_ = totalSupply_.sub(_value);
423         totalDistributed = totalDistributed.sub(_value);
424         Burn(burner, _value);
425     }
426     
427     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
428         ForeignToken token = ForeignToken(_tokenContract);
429         uint256 amount = token.balanceOf(address(this));
430         return token.transfer(owner, amount);
431     }
432 
433 
434 }