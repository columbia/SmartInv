1 pragma solidity ^0.4.16;
2 
3 // SafeMath Taken From FirstBlood
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint a, uint b) internal returns (uint) {
12         assert(b > 0);
13         uint c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint a, uint b) internal returns (uint) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint a, uint b) internal returns (uint) {
24         uint c = a + b;
25         assert(c>=a && c>=b);
26         return c;
27     }
28 }
29 
30 // Ownership
31 contract Owned {
32 
33     address public owner;
34     address public newOwner;
35     modifier onlyOwner { assert(msg.sender == owner); _; }
36 
37     event OwnerUpdate(address _prevOwner, address _newOwner);
38 
39     function Owned() {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address _newOwner) public onlyOwner {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         OwnerUpdate(owner, newOwner);
51         owner = newOwner;
52         newOwner = 0x0;
53     }
54 }
55 
56 // ERC20 Interface
57 contract ERC20 {
58     function totalSupply() constant returns (uint _totalSupply);
59     function balanceOf(address _owner) constant returns (uint balance);
60     function transfer(address _to, uint _value) returns (bool success);
61     function transferFrom(address _from, address _to, uint _value) returns (bool success);
62     function approve(address _spender, uint _value) returns (bool success);
63     function allowance(address _owner, address _spender) constant returns (uint remaining);
64     event Transfer(address indexed _from, address indexed _to, uint _value);
65     event Approval(address indexed _owner, address indexed _spender, uint _value);
66 }
67 
68 // ERC20Token
69 contract ERC20Token is ERC20, SafeMath {
70 
71     mapping(address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     uint256 public totalTokens; 
74     uint256 public contributorTokens; 
75 
76     function transfer(address _to, uint256 _value) returns (bool success) {
77         if (balances[msg.sender] >= _value && _value > 0) {
78             balances[msg.sender] = safeSub(balances[msg.sender], _value);
79             balances[_to] = safeAdd(balances[_to], _value);
80             Transfer(msg.sender, _to, _value);
81             return true;
82         } else {
83             return false;
84         }
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         var _allowance = allowed[_from][msg.sender];
89         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
90             balances[_to] = safeAdd(balances[_to], _value);
91             balances[_from] = safeSub(balances[_from], _value);
92             allowed[_from][msg.sender] = safeSub(_allowance, _value);
93             Transfer(_from, _to, _value);
94             return true;
95         } else {
96             return false;
97         }
98     }
99 
100     function totalSupply() constant returns (uint256) {
101         return totalTokens;
102     }
103 
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint256 _value) returns (bool success) {
109         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
116         return allowed[_owner][_spender];
117     }
118 
119 }
120 
121 contract Wolk is ERC20Token, Owned {
122 
123     // TOKEN INFO
124     string  public constant name = "WOLK TOKEN";
125     string  public constant symbol = "WLK";
126     uint256 public constant decimals = 18;
127 
128     // RESERVE
129     uint256 public reserveBalance = 0; 
130     uint8   public percentageETHReserve = 5;
131 
132     // CONTRACT OWNER
133     address public wolkInc;
134 
135     // TOKEN GENERATION CONTROL
136     bool    public allSaleCompleted = false;
137 
138     modifier isTransferable { require(allSaleCompleted); _; }
139 
140     // TOKEN GENERATION EVENTLOG
141     event WolkCreated(address indexed _to, uint256 _tokenCreated);
142     event WolkDestroyed(address indexed _from, uint256 _tokenDestroyed);
143     event LogRefund(address indexed _to, uint256 _value);
144 }
145 
146 contract WolkTGE is Wolk {
147 
148     // TOKEN GENERATION EVENT
149     mapping (address => uint256) contribution;
150     mapping (address => bool) whitelistContributor;
151     
152     uint256 public constant tokenGenerationMin =   1 * 10**4 * 10**decimals;
153     uint256 public constant tokenGenerationMax = 175 * 10**5 * 10**decimals;
154     uint256 public start_block;
155     uint256 public end_time;
156     bool    kycRequirement = true;
157 
158     // @param _startBlock
159     // @param _endTime
160     // @param _wolkinc - wolk inc tokens sent here
161     // @return success
162     // @dev Wolk Genesis Event [only accessible by Contract Owner]
163     function wolkGenesis(uint256 _startBlock, uint256 _endTime, address _wolkinc) onlyOwner returns (bool success){
164         require((totalTokens < 1) && (block.number <= _startBlock)); 
165         start_block = _startBlock;
166         end_time = _endTime;
167         wolkInc = _wolkinc;
168         return true;
169     }
170     
171     // @param _participants
172     // @return success
173     function updateRequireKYC(bool _kycRequirement) onlyOwner returns (bool success) {
174         kycRequirement = _kycRequirement;
175         return true;
176     } 
177     
178     // @param _participants
179     // @return success
180     function addParticipant(address[] _participants) onlyOwner returns (bool success) {
181         for (uint cnt = 0; cnt < _participants.length; cnt++){           
182             whitelistContributor[_participants[cnt]] = true;
183         }
184         return true;
185     } 
186 
187     // @param _participants
188     // @return success
189     // @dev Revoke designated contributors [only accessible by current Contract Owner]
190     function removeParticipant(address[] _participants) onlyOwner returns (bool success){         
191         for (uint cnt = 0; cnt < _participants.length; cnt++){           
192             whitelistContributor[_participants[cnt]] = false;
193         }
194         return true;
195     }
196 
197     // @param _participant
198     // @return status
199     // @dev return status of given address
200     function participantStatus(address _participant) constant returns (bool status) {
201         return(whitelistContributor[_participant]);
202     }    
203 
204     // @param _participant
205     // @dev use tokenGenerationEvent to handle sale of WOLK
206     function tokenGenerationEvent(address _participant) payable external {
207         require( ( whitelistContributor[_participant] || whitelistContributor[msg.sender] || balances[_participant] > 0 || kycRequirement )  && !allSaleCompleted && ( block.timestamp <= end_time ) && msg.value > 0);
208     
209         uint256 rate = 1000;  // Default Rate
210         rate = safeDiv( 175 * 10**5 * 10**decimals, safeAdd( 875 * 10**1 * 10**decimals, safeDiv( totalTokens, 2 * 10**3)) );
211         if ( rate > 2000 ) rate = 2000;
212         if ( rate < 500 ) rate = 500;
213         require(block.number >= start_block) ;
214 
215         uint256 tokens = safeMul(msg.value, rate);
216         uint256 checkedSupply = safeAdd(totalTokens, tokens);
217         require(checkedSupply <= tokenGenerationMax);
218 
219         totalTokens = checkedSupply;
220         contributorTokens = safeAdd(contributorTokens, tokens);
221         
222         Transfer(address(this), _participant, tokens);
223         balances[_participant] = safeAdd(balances[_participant], tokens);
224         contribution[_participant] = safeAdd(contribution[_participant], msg.value);
225         WolkCreated(_participant, tokens); // logs token creation
226     }
227 
228     function finalize() onlyOwner external {
229         require(!allSaleCompleted);
230         end_time = block.timestamp;
231 
232         // 50MM Wolk allocated to Wolk Inc for development
233         uint256 wolkincTokens =  50 * 10**6 * 10**decimals;
234         balances[wolkInc] = wolkincTokens;
235         totalTokens = safeAdd(totalTokens, wolkincTokens);                 
236 
237         WolkCreated(wolkInc, wolkincTokens); // logs token creation 
238         allSaleCompleted = true;
239         reserveBalance = safeDiv(safeMul(contributorTokens, percentageETHReserve), 100000);
240         var withdrawalBalance = safeSub(this.balance, reserveBalance);
241         msg.sender.transfer(withdrawalBalance);
242     }
243 
244     function refund() external {
245         require((contribution[msg.sender] > 0) && (!allSaleCompleted) && (block.timestamp > end_time)  && (totalTokens < tokenGenerationMin));
246         uint256 tokenBalance = balances[msg.sender];
247         uint256 refundBalance = contribution[msg.sender];
248         balances[msg.sender] = 0;
249         contribution[msg.sender] = 0;
250         totalTokens = safeSub(totalTokens, tokenBalance);
251         WolkDestroyed(msg.sender, tokenBalance);
252         LogRefund(msg.sender, refundBalance);
253         msg.sender.transfer(refundBalance); 
254     }
255 
256     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) onlyOwner returns (bool success) {
257         return ERC20(_tokenAddress).transfer(owner, _amount);
258     }
259 }
260 
261 // Taken from https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/BancorFormula.sol
262 contract IBancorFormula {
263     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint8 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
264     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint8 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
265 }
266 
267 contract WolkExchange is  WolkTGE {
268     address public exchangeFormula;
269     bool    public isPurchasePossible = false;
270     bool    public isSellPossible = false;
271 
272     modifier isPurchasable { require(isPurchasePossible && allSaleCompleted); _; }
273     modifier isSellable { require(isSellPossible && allSaleCompleted); _; }
274     
275     // @param  _newExchangeformula
276     // @return success
277     // @dev Set the bancor formula to use -- only Wolk Inc can set this
278     function setExchangeFormula(address _newExchangeformula) onlyOwner returns (bool success){
279         require(sellWolkEstimate(10**decimals, _newExchangeformula) > 0);
280         require(purchaseWolkEstimate(10**decimals, _newExchangeformula) > 0);
281         isPurchasePossible = false;
282         isSellPossible = false;
283         exchangeFormula = _newExchangeformula;
284         return true;
285     }
286 
287     // @param  _newReserveRatio
288     // @return success
289     // @dev Set the reserve ratio in case of emergency -- only Wolk Inc can set this
290     function updateReserveRatio(uint8 _newReserveRatio) onlyOwner returns (bool success) {
291         require(allSaleCompleted && ( _newReserveRatio > 1 ) && ( _newReserveRatio < 20 ) );
292         percentageETHReserve = _newReserveRatio;
293         return true;
294     }
295 
296     // @param  _isRunning
297     // @return success
298     // @dev updating isPurchasePossible -- only Wolk Inc can set this
299     function updatePurchasePossible(bool _isRunning) onlyOwner returns (bool success){
300         if (_isRunning){
301             require(sellWolkEstimate(10**decimals, exchangeFormula) > 0);
302             require(purchaseWolkEstimate(10**decimals, exchangeFormula) > 0);   
303         }
304         isPurchasePossible = _isRunning;
305         return true;
306     }
307 
308     // @param  _isRunning
309     // @return success
310     // @dev updating isSellPossible -- only Wolk Inc can set this
311     function updateSellPossible(bool _isRunning) onlyOwner returns (bool success){
312         if (_isRunning){
313             require(sellWolkEstimate(10**decimals, exchangeFormula) > 0);
314             require(purchaseWolkEstimate(10**decimals, exchangeFormula) > 0);   
315         }
316         isSellPossible = _isRunning;
317         return true;
318     }
319 
320     function sellWolkEstimate(uint256 _wolkAmountest, address _formula) internal returns(uint256) {
321         uint256 ethReceivable =  IBancorFormula(_formula).calculateSaleReturn(contributorTokens, reserveBalance, percentageETHReserve, _wolkAmountest);
322         return ethReceivable;
323     }
324     
325     function purchaseWolkEstimate(uint256 _ethAmountest, address _formula) internal returns(uint256) {
326         uint256 wolkReceivable = IBancorFormula(_formula).calculatePurchaseReturn(contributorTokens, reserveBalance, percentageETHReserve, _ethAmountest);
327         return wolkReceivable;
328     }
329     
330     // @param _wolkAmount
331     // @return ethReceivable
332     // @dev send Wolk into contract in exchange for eth, at an exchange rate based on the Bancor Protocol derivation and decrease totalSupply accordingly
333     function sellWolk(uint256 _wolkAmount) isSellable() returns(uint256) {
334         require((balances[msg.sender] >= _wolkAmount));
335         uint256 ethReceivable = sellWolkEstimate(_wolkAmount,exchangeFormula);
336         require(this.balance > ethReceivable);
337         balances[msg.sender] = safeSub(balances[msg.sender], _wolkAmount);
338         contributorTokens = safeSub(contributorTokens, _wolkAmount);
339         totalTokens = safeSub(totalTokens, _wolkAmount);
340         reserveBalance = safeSub(this.balance, ethReceivable);
341         WolkDestroyed(msg.sender, _wolkAmount);
342         Transfer(msg.sender, 0x00000000000000000000, _wolkAmount);
343         msg.sender.transfer(ethReceivable);
344         return ethReceivable;     
345     }
346 
347     // @return wolkReceivable    
348     // @dev send eth into contract in exchange for Wolk tokens, at an exchange rate based on the Bancor Protocol derivation and increase totalSupply accordingly
349     function purchaseWolk(address _buyer) isPurchasable() payable returns(uint256){
350         require(msg.value > 0);
351         uint256 wolkReceivable = purchaseWolkEstimate(msg.value, exchangeFormula);
352         require(wolkReceivable > 0);
353 
354         contributorTokens = safeAdd(contributorTokens, wolkReceivable);
355         totalTokens = safeAdd(totalTokens, wolkReceivable);
356         balances[_buyer] = safeAdd(balances[_buyer], wolkReceivable);
357         reserveBalance = safeAdd(reserveBalance, msg.value);
358         WolkCreated(_buyer, wolkReceivable);
359         Transfer(address(this),_buyer,wolkReceivable);
360         return wolkReceivable;
361     }
362 
363     // @dev  fallback function for purchase
364     // @note Automatically fallback to tokenGenerationEvent before sale is completed. After the token generation event, fallback to purchaseWolk. Liquidity exchange will be enabled through updateExchangeStatus  
365     function () payable {
366         require(msg.value > 0);
367         if(!allSaleCompleted){
368             this.tokenGenerationEvent.value(msg.value)(msg.sender);
369         } else if ( block.timestamp >= end_time ){
370             this.purchaseWolk.value(msg.value)(msg.sender);
371         } else {
372             revert();
373         }
374     }
375 }