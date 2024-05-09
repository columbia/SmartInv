1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
37   function Ownable() public {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner. 
44    */
45   modifier onlyOwner() {
46     if (msg.sender != owner) {
47       revert();
48     }
49     _;
50  }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to. 
55    */
56   function transferOwnership(address newOwner) public onlyOwner {
57       owner = newOwner;
58   }
59  
60 }
61   
62 contract ERC20 {
63 
64     function totalSupply() public constant returns (uint256);
65     function balanceOf(address who) public constant returns (uint256);
66     function transfer(address to, uint256 value) public;
67     function transferFrom(address from, address to, uint256 value) public;
68     function approve(address spender, uint256 value) public;
69     function allowance(address owner, address spender) public constant returns (uint256);
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74 }
75 
76 contract RAOToken is Ownable, ERC20 {
77 
78     using SafeMath for uint256;
79 
80     // Token properties
81     string public name = "RadioYo Coin";
82     string public symbol = "RAO";
83     uint256 public decimals = 18;
84     uint256 public numberDecimal18 = 1000000000000000000;
85 
86     uint256 public initialPrice = 3000e18;
87     uint256 public _totalSupply = 33000000e18;
88     uint256 public _icoSupply = 33000000e18;
89     uint256 public _softcap = 165000e18;
90 
91     // Balances for each account
92     mapping (address => uint256) balances;
93 
94     // whitelisting users
95     mapping (address => bool) whitelist;
96 
97     // time seal for upper management
98     mapping (address => uint256) vault;
99     
100     
101     //Balances for waiting KYC approving
102     mapping (address => uint256) balancesWaitingKYC;
103 
104     // Owner of account approves the transfer of an amount to another account
105     mapping (address => mapping(address => uint256)) allowed;
106     
107     // start and end timestamps where investments are allowed (both inclusive)
108     uint256 public startTime; 
109     uint256 public endTime; 
110     uint256 public sealdate;
111 
112     // Wallet Address of Token
113     address public multisig;
114 
115     // how many token units a buyer get in base unit 
116     uint256 public RATE;
117 
118     uint256 public kycLevel = 15 ether;
119 
120 
121     uint256 public hardCap = 200000000e18;
122     
123     //number of total tokens sold 
124     uint256 public totalNumberTokenSold=0;
125 
126     bool public mintingFinished = false;
127 
128     bool public tradable = true;
129 
130     bool public active = true;
131 
132     event MintFinished();
133     event StartTradable();
134     event PauseTradable();
135     event HaltTokenAllOperation();
136     event ResumeTokenAllOperation();
137     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
138     event Burn(address indexed burner, uint256 value);
139 
140 
141     modifier canMint() {
142         require(!mintingFinished);
143         _;
144     }
145 
146     modifier canTradable() {
147         require(tradable);
148         _;
149     }
150 
151     modifier isActive() {
152         require(active);
153         _;
154     }
155     
156     modifier saleIsOpen(){
157         require(startTime <= getNow() && getNow() <= endTime);
158         _;
159     }
160 
161     // Constructor
162     // @notice RAOToken Contract
163     // @return the transaction address
164     function RAOToken(address _multisig) public {
165         require(_multisig != 0x0);
166         multisig = _multisig;
167         RATE = initialPrice;
168         startTime = now;
169 
170         // the balances will be sealed for 6 months
171         sealdate = startTime + 180 days;
172 
173         // for now the token sale will run for 30 days
174         endTime = startTime + 60 days;
175         balances[multisig] = _totalSupply;
176 
177         owner = msg.sender;
178     }
179 
180     // Payable method
181     // @notice Anyone can buy the tokens on tokensale by paying ether
182     function () external payable {
183         
184         if (!validPurchase()) {
185             refundFunds(msg.sender);
186         }
187         
188         tokensale(msg.sender);
189     }
190 
191     function whitelisted(address user) public constant returns (bool) {
192         return whitelist[user];
193     }
194 
195     // @notice tokensale
196     // @param recipient The address of the recipient
197     // @return the transaction address and send the event as Transfer
198     function tokensale(address recipient) internal canMint isActive saleIsOpen {
199         require(recipient != 0x0);
200         require(whitelisted(recipient));
201         
202         uint256 weiAmount = msg.value;
203         uint256 numberRaoToken = weiAmount.mul(RATE).div(1 ether);
204         
205         require(_icoSupply >= numberRaoToken);   
206                 
207         totalNumberTokenSold = totalNumberTokenSold.add(numberRaoToken);
208 
209         _icoSupply = _icoSupply.sub(numberRaoToken);
210 
211         TokenPurchase(msg.sender, recipient, weiAmount, numberRaoToken);
212 
213          if (weiAmount < kycLevel) {
214             updateBalances(recipient, numberRaoToken);
215          } else {
216             balancesWaitingKYC[recipient] = balancesWaitingKYC[recipient].add(numberRaoToken); 
217          }
218         forwardFunds();
219         // a sender can only buy once per white list entry
220         setWhitelistStatus(recipient, false);
221          
222     }
223     
224     function updateBalances(address receiver, uint256 tokens) internal {
225         balances[multisig] = balances[multisig].sub(tokens);
226         balances[receiver] = balances[receiver].add(tokens);
227     }
228     
229     //refund back if not KYC approved
230      function refundFunds(address origin) internal {
231         origin.transfer(msg.value);
232     }
233 
234     // send ether to the fund collection wallet
235     // override to create custom fund forwarding mechanisms
236     function forwardFunds() internal {
237         multisig.transfer(msg.value);
238     }
239 
240     function setWhitelistStatus(address user,bool status) public returns (bool) {
241         if (status == true) {
242             //only owner can set whitelist
243             require(msg.sender == owner);
244             whitelist[user] = true;        
245         } else {
246             // owner and the user themselves can remove them selves from whitelist
247             require(msg.sender == owner || msg.sender == user);
248             whitelist[user] = false;
249         }
250         return whitelist[user];
251     }
252     
253     function setWhitelistForBulk(address[] listAddresses, bool status) public onlyOwner {
254         for (uint256 i = 0; i < listAddresses.length; i++) {
255             whitelist[listAddresses[i]] = status;
256         }
257     }
258     
259     // @return true if the transaction can buy tokens
260     function validPurchase() internal constant returns (bool) {
261         bool withinPeriod = getNow() >= startTime && getNow() <= endTime;
262         bool nonZeroPurchase = msg.value != 0;
263         bool notReachedHardCap = hardCap >= totalNumberTokenSold;
264         return withinPeriod && nonZeroPurchase && notReachedHardCap;
265     }
266 
267     // @return true if crowdsale current lot event has ended
268     function hasEnded() public constant returns (bool) {
269         return getNow() > endTime;
270     }
271 
272     function getNow() public constant returns (uint) {
273         return now;
274     }
275 
276     // Set/change Multi-signature wallet address
277     function changeMultiSignatureWallet (address _multisig) public onlyOwner isActive {
278         multisig = _multisig;
279     }
280 
281     // Change ETH/Token exchange rate
282     function changeTokenRate(uint _tokenPrice) public onlyOwner isActive {
283         RATE = _tokenPrice;
284     }
285 
286     // Set Finish Minting.
287     function finishMinting() public onlyOwner isActive {
288         mintingFinished = true;
289         MintFinished();
290     }
291 
292 
293 
294     // Start or pause tradable to Transfer token
295     function startTradable(bool _tradable) public onlyOwner isActive {
296         tradable = _tradable;
297         if (tradable)
298             StartTradable();
299         else
300             PauseTradable();
301     }
302 
303     //UpdateICODateTime(uint256 _startTime,)
304     function updateICODate(uint256 _startTime, uint256 _endTime) public onlyOwner {
305         startTime = _startTime;
306         endTime = _endTime;
307     }
308     
309     //Change startTime to start ICO manually
310     function changeStartTime(uint256 _startTime) public onlyOwner {
311         startTime = _startTime;
312     }
313 
314     //Change endTime to end ICO manually
315     function changeEndTime(uint256 _endTime) public onlyOwner {
316         endTime = _endTime;
317     }
318 
319     // @return total tokens supplied
320     function totalSupply() public constant returns (uint256) {
321         return _totalSupply;
322     }
323     
324     // @return total tokens supplied
325     function totalNumberTokenSold() public constant returns (uint256) {
326         return totalNumberTokenSold;
327     }
328 
329 
330     //Change total supply
331     function changeTotalSupply(uint256 newSupply) public onlyOwner {
332         _totalSupply = newSupply;
333     }
334 
335 
336     // What is the balance of a particular account?
337     // @param who The address of the particular account
338     // @return the balance the particular account
339     function balanceOf(address who) public constant returns (uint256) {
340         return balances[who];
341     }
342 
343 
344     function vaultBalanceOf(address who) public constant returns (uint256) {
345         return vault[who];
346     }
347 
348     function transferToVault(address recipient, uint256 amount) public onlyOwner isActive {
349         require (
350             balances[multisig] >= amount && amount > 0
351         );
352 
353         balances[multisig] = balances[multisig].sub(amount);
354         // sending tokens to vault is not part of ICO, its a decision made by the owner
355         // _icoSupply = _icoSupply.sub(amount);
356         vault[recipient] = vault[recipient].add(amount);
357 
358     }
359 
360     // What is the balance of a particular account?
361     // @param who The address of the particular account
362     // @return the balance of KYC waiting to be approved
363     function balanceOfKyCToBeApproved(address who) public constant returns (uint256) {
364         return balancesWaitingKYC[who];
365     }
366     
367 
368     function approveBalancesWaitingKYC(address[] listAddresses) public onlyOwner {
369          for (uint256 i = 0; i < listAddresses.length; i++) {
370              address client = listAddresses[i];
371              balances[multisig] = balances[multisig].sub(balancesWaitingKYC[client]);
372              balances[client] = balances[client].add(balancesWaitingKYC[client]);
373              balancesWaitingKYC[client] = 0;
374         }
375     }
376 
377     function remit() public {
378         require(vault[msg.sender] > 0 && now >= sealdate);
379         balances[msg.sender] = balances[msg.sender].add(vault[msg.sender]);
380         vault[msg.sender] = 0;
381     }
382 
383     function remitFor(address person) public onlyOwner {
384         require(vault[person] > 0 && now >= sealdate);
385         balances[person] = balances[person].add(vault[person]);
386         vault[person] = 0;
387     }
388 
389     function addTimeToSeal(uint256 time) public onlyOwner {
390         sealdate = sealdate.add(time);
391     }
392 
393     function setSealDate(uint256 _sealdate) public onlyOwner {
394         sealdate = _sealdate;
395     } 
396 
397     function resetTimeSeal() public onlyOwner {
398         sealdate = now;
399     }
400 
401     function getSealDate() public constant returns (uint256) {
402         return sealdate;
403     }
404 
405     
406     function modifyCurrentHardCap(uint256 _hardCap) public onlyOwner isActive {
407         hardCap = _hardCap;
408     }
409 
410 
411     function burn(uint256 _value) public {
412         require(_value <= balances[multisig]);
413         balances[multisig] = balances[multisig].sub(_value);
414         _totalSupply = _totalSupply.sub(_value);
415         Burn(multisig, _value);
416         
417     }
418 
419 
420     // @notice send `value` token to `to` from `msg.sender`
421     // @param to The address of the recipient
422     // @param value The amount of token to be transferred
423     // @return the transaction address and send the event as Transfer
424     function transfer(address to, uint256 value) public canTradable isActive {
425         require (
426             balances[msg.sender] >= value && value > 0
427         );
428         balances[msg.sender] = balances[msg.sender].sub(value);
429         balances[to] = balances[to].add(value);
430         Transfer(msg.sender, to, value);
431     }
432     
433     function transferToAll(address[] tos, uint256[] values) public onlyOwner canTradable isActive {
434         require(
435             tos.length == values.length
436             );
437         
438         for(uint256 i = 0; i < tos.length; i++){
439         require(_icoSupply >= values[i]);   
440         totalNumberTokenSold = totalNumberTokenSold.add(values[i]);
441         _icoSupply = _icoSupply.sub(values[i]);
442         updateBalances(tos[i],values[i]);
443         }
444     }
445 
446     // @notice send `value` token to `to` from `from`
447     // @param from The address of the sender
448     // @param to The address of the recipient
449     // @param value The amount of token to be transferred
450     // @return the transaction address and send the event as Transfer
451     function transferFrom(address from, address to, uint256 value) public canTradable isActive {
452         require (
453             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
454         );
455         balances[from] = balances[from].sub(value);
456         balances[to] = balances[to].add(value);
457         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
458         Transfer(from, to, value);
459     }
460 
461     // Allow spender to withdraw from your account, multiple times, up to the value amount.
462     // If this function is called again it overwrites the current allowance with value.
463     // @param spender The address of the sender
464     // @param value The amount to be approved
465     // @return the transaction address and send the event as Approval
466     function approve(address spender, uint256 value) public isActive {
467         require (
468             balances[msg.sender] >= value && value > 0
469         );
470         allowed[msg.sender][spender] = value;
471         Approval(msg.sender, spender, value);
472     }
473 
474     // Check the allowed value for the spender to withdraw from owner
475     // @param owner The address of the owner
476     // @param spender The address of the spender
477     // @return the amount which spender is still allowed to withdraw from owner
478     function allowance(address _owner, address spender) public constant returns (uint256) {
479         return allowed[_owner][spender];
480     }
481 
482     // Get current price of a Token
483     // @return the price or token value for a ether
484     function getRate() public constant returns (uint256 result) {
485       return RATE;
486     }
487     
488     function getTokenDetail() public constant returns (string, string, uint256, uint256, uint256, uint256, uint256) {
489         return (name, symbol, startTime, endTime, _totalSupply, _icoSupply, totalNumberTokenSold);
490     }
491 
492 }