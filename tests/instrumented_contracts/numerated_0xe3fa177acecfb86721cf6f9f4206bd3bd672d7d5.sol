1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /** 
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner. 
44    */
45   modifier onlyOwner() {
46     if (msg.sender != owner) {
47       throw;
48     }
49     _;
50  }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to. 
55    */
56   function transferOwnership(address newOwner) onlyOwner {
57       owner = newOwner;
58   }
59  
60 }
61   
62 contract ERC20 {
63 
64     function totalSupply() constant returns (uint256);
65     function balanceOf(address who) constant returns (uint256);
66     function transfer(address to, uint256 value);
67     function transferFrom(address from, address to, uint256 value);
68     function approve(address spender, uint256 value);
69     function allowance(address owner, address spender) constant returns (uint256);
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74 }
75 
76 contract CTCToken is Ownable, ERC20 {
77 
78     using SafeMath for uint256;
79 
80     // Token properties
81     string public name = "ChainTrade Coin";
82     string public symbol = "CTC";
83     uint256 public decimals = 18;
84     uint256 public numberDecimal18= 1000000000000000000;
85 
86     uint256 public initialPrice = 1000;
87     uint256 public _totalSupply = 225000000e18;
88     uint256 public _icoSupply = 200000000e18;
89 
90     // Balances for each account
91     mapping (address => uint256) balances;
92     
93     
94     //Balances for waiting KYC approving
95     mapping (address => uint256) balancesWaitingKYC;
96 
97     // Owner of account approves the transfer of an amount to another account
98     mapping (address => mapping(address => uint256)) allowed;
99     
100     // start and end timestamps where investments are allowed (both inclusive)
101     uint256 public startTime = 1507334400; 
102     uint256 public endTime = 1514764799; 
103 
104     // Wallet Address of Token
105     address public multisig;
106 
107     // how many token units a buyer gets per wei
108     uint256 public RATE;
109 
110     uint256 public minContribAmount = 0.01 ether;
111     uint256 public kycLevel = 15 ether;
112     uint256 minCapBonus = 200 ether;
113 
114     uint256 public hardCap = 200000000e18;
115     
116     //number of total tokens sold 
117     uint256 public totalNumberTokenSold=0;
118 
119     bool public mintingFinished = false;
120 
121     bool public tradable = true;
122 
123     bool public active = true;
124 
125     event MintFinished();
126     event StartTradable();
127     event PauseTradable();
128     event HaltTokenAllOperation();
129     event ResumeTokenAllOperation();
130     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
131 
132 
133     modifier canMint() {
134         require(!mintingFinished);
135         _;
136     }
137 
138     modifier canTradable() {
139         require(tradable);
140         _;
141     }
142 
143     modifier isActive() {
144         require(active);
145         _;
146     }
147     
148     modifier saleIsOpen(){
149         require(startTime <= getNow() && getNow() <=endTime);
150         _;
151     }
152 
153     // Constructor
154     // @notice CTCToken Contract
155     // @return the transaction address
156     function CTCToken(address _multisig) {
157         require(_multisig != 0x0);
158         multisig = _multisig;
159         RATE = initialPrice;
160 
161         balances[multisig] = _totalSupply;
162 
163         owner = msg.sender;
164     }
165 
166     // Payable method
167     // @notice Anyone can buy the tokens on tokensale by paying ether
168     function () external payable {
169         
170         if (!validPurchase()){
171             refundFunds(msg.sender);
172         }
173         
174         tokensale(msg.sender);
175     }
176 
177     // @notice tokensale
178     // @param recipient The address of the recipient
179     // @return the transaction address and send the event as Transfer
180         function tokensale(address recipient) canMint isActive saleIsOpen payable {
181         require(recipient != 0x0);
182         
183         uint256 weiAmount = msg.value;
184         uint256 nbTokens = weiAmount.mul(RATE).div(1 ether);
185         uint256 numberCtcToken = nbTokens.mul(numberDecimal18);
186         
187         require(_icoSupply >= numberCtcToken);
188         
189         bool percentageBonusApplicable = weiAmount >= minCapBonus;
190         if (percentageBonusApplicable) {
191             numberCtcToken = numberCtcToken.mul(11).div(10);
192         }
193         
194         totalNumberTokenSold=totalNumberTokenSold.add(numberCtcToken);
195 
196         _icoSupply = _icoSupply.sub(numberCtcToken);
197 
198         TokenPurchase(msg.sender, recipient, weiAmount, numberCtcToken);
199 
200          if(weiAmount< kycLevel) {
201             updateBalances(recipient, numberCtcToken);
202             forwardFunds();  
203          } else {
204             balancesWaitingKYC[recipient] = balancesWaitingKYC[recipient].add(numberCtcToken); 
205             forwardFunds();  
206          }
207          
208         
209     }
210     
211     function updateBalances(address receiver, uint256 tokens) internal {
212         balances[multisig] = balances[multisig].sub(tokens);
213         balances[receiver] = balances[receiver].add(tokens);
214     }
215     
216     //refund back if not KYC approved
217      function refundFunds(address origin) internal {
218         origin.transfer(msg.value);
219     }
220 
221     // send ether to the fund collection wallet
222     // override to create custom fund forwarding mechanisms
223     function forwardFunds() internal {
224         multisig.transfer(msg.value);
225     }
226 
227     // @return true if the transaction can buy tokens
228     function validPurchase() internal constant returns (bool) {
229         bool withinPeriod = getNow() >= startTime && getNow() <= endTime;
230         bool nonZeroPurchase = msg.value != 0;
231         bool minContribution = minContribAmount <= msg.value;
232         bool notReachedHardCap = hardCap >= totalNumberTokenSold;
233         return withinPeriod && nonZeroPurchase && minContribution && notReachedHardCap;
234     }
235 
236     // @return true if crowdsale current lot event has ended
237     function hasEnded() public constant returns (bool) {
238         return getNow() > endTime;
239     }
240 
241     function getNow() public constant returns (uint) {
242         return now;
243     }
244 
245     // Set/change Multi-signature wallet address
246     function changeMultiSignatureWallet (address _multisig) onlyOwner isActive {
247         multisig = _multisig;
248     }
249 
250     // Change ETH/Token exchange rate
251     function changeTokenRate(uint _tokenPrice) onlyOwner isActive {
252         RATE = _tokenPrice;
253     }
254 
255     // Set Finish Minting.
256     function finishMinting() onlyOwner isActive {
257         mintingFinished = true;
258         MintFinished();
259     }
260 
261     // Start or pause tradable to Transfer token
262     function startTradable(bool _tradable) onlyOwner isActive {
263         tradable = _tradable;
264         if (tradable)
265             StartTradable();
266         else
267             PauseTradable();
268     }
269 
270     //UpdateICODateTime(uint256 _startTime,)
271     function updateICODate(uint256 _startTime, uint256 _endTime) public onlyOwner {
272         startTime = _startTime;
273         endTime = _endTime;
274     }
275     
276     //Change startTime to start ICO manually
277     function changeStartTime(uint256 _startTime) onlyOwner {
278         startTime = _startTime;
279     }
280 
281     //Change endTime to end ICO manually
282     function changeEndTime(uint256 _endTime) onlyOwner {
283         endTime = _endTime;
284     }
285 
286     // @return total tokens supplied
287     function totalSupply() constant returns (uint256) {
288         return _totalSupply;
289     }
290     
291     // @return total tokens supplied
292     function totalNumberTokenSold() constant returns (uint256) {
293         return totalNumberTokenSold;
294     }
295 
296 
297     //Change total supply
298     function changeTotalSupply(uint256 totalSupply) onlyOwner {
299         _totalSupply = totalSupply;
300     }
301 
302 
303     // What is the balance of a particular account?
304     // @param who The address of the particular account
305     // @return the balanace the particular account
306     function balanceOf(address who) constant returns (uint256) {
307         return balances[who];
308     }
309 
310     // What is the balance of a particular account?
311     // @param who The address of the particular account
312     // @return the balance of KYC waiting to be approved
313     function balanceOfKyCToBeApproved(address who) constant returns (uint256) {
314         return balancesWaitingKYC[who];
315     }
316     
317 
318     function approveBalancesWaitingKYC(address[] listAddresses) onlyOwner {
319          for (uint256 i = 0; i < listAddresses.length; i++) {
320              address client = listAddresses[i];
321              balances[multisig] = balances[multisig].sub(balancesWaitingKYC[client]);
322              balances[client] = balances[client].add(balancesWaitingKYC[client]);
323              totalNumberTokenSold=totalNumberTokenSold.add(balancesWaitingKYC[client]);
324              _icoSupply = _icoSupply.sub(balancesWaitingKYC[client]);
325              balancesWaitingKYC[client] = 0;
326         }
327     }
328 
329     function addBonusForOneHolder(address holder, uint256 bonusToken) onlyOwner{
330          require(holder != 0x0); 
331          balances[multisig] = balances[multisig].sub(bonusToken);
332          balances[holder] = balances[holder].add(bonusToken);
333          totalNumberTokenSold=totalNumberTokenSold.add(bonusToken);
334          _icoSupply = _icoSupply.sub(bonusToken);
335     }
336 
337     
338     function addBonusForMultipleHolders(address[] listAddresses, uint256[] bonus) onlyOwner {
339         require(listAddresses.length == bonus.length); 
340          for (uint256 i = 0; i < listAddresses.length; i++) {
341                 require(listAddresses[i] != 0x0); 
342                 balances[listAddresses[i]] = balances[listAddresses[i]].add(bonus[i]);
343                 balances[multisig] = balances[multisig].sub(bonus[i]);
344                 totalNumberTokenSold=totalNumberTokenSold.add(bonus[i]);
345                 _icoSupply = _icoSupply.sub(bonus[i]);
346          }
347     }
348     
349    
350     
351     function modifyCurrentHardCap(uint256 _hardCap) onlyOwner isActive {
352         hardCap = _hardCap;
353     }
354 
355     // @notice send `value` token to `to` from `msg.sender`
356     // @param to The address of the recipient
357     // @param value The amount of token to be transferred
358     // @return the transaction address and send the event as Transfer
359     function transfer(address to, uint256 value) canTradable isActive {
360         require (
361             balances[msg.sender] >= value && value > 0
362         );
363         balances[msg.sender] = balances[msg.sender].sub(value);
364         balances[to] = balances[to].add(value);
365         Transfer(msg.sender, to, value);
366     }
367 
368     // @notice send `value` token to `to` from `from`
369     // @param from The address of the sender
370     // @param to The address of the recipient
371     // @param value The amount of token to be transferred
372     // @return the transaction address and send the event as Transfer
373     function transferFrom(address from, address to, uint256 value) canTradable isActive {
374         require (
375             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
376         );
377         balances[from] = balances[from].sub(value);
378         balances[to] = balances[to].add(value);
379         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
380         Transfer(from, to, value);
381     }
382 
383     // Allow spender to withdraw from your account, multiple times, up to the value amount.
384     // If this function is called again it overwrites the current allowance with value.
385     // @param spender The address of the sender
386     // @param value The amount to be approved
387     // @return the transaction address and send the event as Approval
388     function approve(address spender, uint256 value) isActive {
389         require (
390             balances[msg.sender] >= value && value > 0
391         );
392         allowed[msg.sender][spender] = value;
393         Approval(msg.sender, spender, value);
394     }
395 
396     // Check the allowed value for the spender to withdraw from owner
397     // @param owner The address of the owner
398     // @param spender The address of the spender
399     // @return the amount which spender is still allowed to withdraw from owner
400     function allowance(address _owner, address spender) constant returns (uint256) {
401         return allowed[_owner][spender];
402     }
403 
404     // Get current price of a Token
405     // @return the price or token value for a ether
406     function getRate() constant returns (uint256 result) {
407       return RATE;
408     }
409     
410     function getTokenDetail() public constant returns (string, string, uint256, uint256, uint256, uint256, uint256) {
411         return (name, symbol, startTime, endTime, _totalSupply, _icoSupply, totalNumberTokenSold);
412     }
413 }