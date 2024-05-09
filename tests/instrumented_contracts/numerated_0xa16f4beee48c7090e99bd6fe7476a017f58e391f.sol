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
84 
85     uint256 public initialPrice = 1000;
86     uint256 public _totalSupply = 225000000e18;
87     uint256 public _icoSupply = 200000000e18;
88 
89     // Balances for each account
90     mapping (address => uint256) balances;
91     
92     
93     //Balances for waiting KYC approving
94     mapping (address => uint256) balancesWaitingKYC;
95 
96     // Owner of account approves the transfer of an amount to another account
97     mapping (address => mapping(address => uint256)) allowed;
98     
99     // start and end timestamps where investments are allowed (both inclusive)
100     uint256 public startTime = 1507334400; 
101     uint256 public endTime = 1514764799; 
102 
103     // Wallet Address of Token
104     address public multisig;
105 
106     // how many token units a buyer gets per wei
107     uint256 public RATE;
108 
109     uint256 public minContribAmount = 0.01 ether;
110     uint256 public kycLevel = 15 ether;
111     uint256 minCapBonus = 200 ether;
112 
113     uint256 public hardCap = 200000000e18;
114     
115     //number of total tokens sold 
116     uint256 public totalNumberTokenSold=0;
117 
118     bool public mintingFinished = false;
119 
120     bool public tradable = true;
121 
122     bool public active = true;
123 
124     event MintFinished();
125     event StartTradable();
126     event PauseTradable();
127     event HaltTokenAllOperation();
128     event ResumeTokenAllOperation();
129     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
130 
131 
132     modifier canMint() {
133         require(!mintingFinished);
134         _;
135     }
136 
137     modifier canTradable() {
138         require(tradable);
139         _;
140     }
141 
142     modifier isActive() {
143         require(active);
144         _;
145     }
146     
147     modifier saleIsOpen(){
148         require(startTime <= getNow() && getNow() <=endTime);
149         _;
150     }
151 
152     // Constructor
153     // @notice CTCToken Contract
154     // @return the transaction address
155     function CTCToken(address _multisig) {
156         require(_multisig != 0x0);
157         multisig = _multisig;
158         RATE = initialPrice;
159 
160         balances[multisig] = _totalSupply;
161 
162         owner = msg.sender;
163     }
164 
165     // Payable method
166     // @notice Anyone can buy the tokens on tokensale by paying ether
167     function () external payable {
168         
169         if (!validPurchase()){
170             refundFunds(msg.sender);
171         }
172         
173         tokensale(msg.sender);
174     }
175 
176     // @notice tokensale
177     // @param recipient The address of the recipient
178     // @return the transaction address and send the event as Transfer
179         function tokensale(address recipient) canMint isActive saleIsOpen payable {
180         require(recipient != 0x0);
181         
182         uint256 weiAmount = msg.value;
183         uint256 nbTokens = weiAmount.mul(RATE).div(1 ether);
184         
185         
186         require(_icoSupply >= nbTokens);
187         
188         bool percentageBonusApplicable = weiAmount >= minCapBonus;
189         if (percentageBonusApplicable) {
190             nbTokens = nbTokens.mul(11).div(10);
191         }
192         
193         totalNumberTokenSold=totalNumberTokenSold.add(nbTokens);
194 
195         _icoSupply = _icoSupply.sub(nbTokens);
196 
197         TokenPurchase(msg.sender, recipient, weiAmount, nbTokens);
198 
199          if(weiAmount< kycLevel) {
200             updateBalances(recipient, nbTokens);
201          } else {
202             balancesWaitingKYC[recipient] = balancesWaitingKYC[recipient].add(nbTokens); 
203          }
204          forwardFunds();  
205         
206     }
207     
208     function updateBalances(address receiver, uint256 tokens) internal {
209         balances[multisig] = balances[multisig].sub(tokens);
210         balances[receiver] = balances[receiver].add(tokens);
211     }
212     
213     //refund back if not KYC approved
214      function refundFunds(address origin) internal {
215         origin.transfer(msg.value);
216     }
217 
218     // send ether to the fund collection wallet
219     // override to create custom fund forwarding mechanisms
220     function forwardFunds() internal {
221         multisig.transfer(msg.value);
222     }
223 
224     // @return true if the transaction can buy tokens
225     function validPurchase() internal constant returns (bool) {
226         bool withinPeriod = getNow() >= startTime && getNow() <= endTime;
227         bool nonZeroPurchase = msg.value != 0;
228         bool minContribution = minContribAmount <= msg.value;
229         bool notReachedHardCap = hardCap >= totalNumberTokenSold;
230         return withinPeriod && nonZeroPurchase && minContribution && notReachedHardCap;
231     }
232 
233     // @return true if crowdsale current lot event has ended
234     function hasEnded() public constant returns (bool) {
235         return getNow() > endTime;
236     }
237 
238     function getNow() public constant returns (uint) {
239         return now;
240     }
241 
242     // Set/change Multi-signature wallet address
243     function changeMultiSignatureWallet (address _multisig) onlyOwner isActive {
244         multisig = _multisig;
245     }
246 
247     // Change ETH/Token exchange rate
248     function changeTokenRate(uint _tokenPrice) onlyOwner isActive {
249         RATE = _tokenPrice;
250     }
251 
252     // Set Finish Minting.
253     function finishMinting() onlyOwner isActive {
254         mintingFinished = true;
255         MintFinished();
256     }
257 
258     // Start or pause tradable to Transfer token
259     function startTradable(bool _tradable) onlyOwner isActive {
260         tradable = _tradable;
261         if (tradable)
262             StartTradable();
263         else
264             PauseTradable();
265     }
266 
267     //UpdateICODateTime(uint256 _startTime,)
268     function updateICODate(uint256 _startTime, uint256 _endTime) public onlyOwner {
269         startTime = _startTime;
270         endTime = _endTime;
271     }
272     
273     //Change startTime to start ICO manually
274     function changeStartTime(uint256 _startTime) onlyOwner {
275         startTime = _startTime;
276     }
277 
278     //Change endTime to end ICO manually
279     function changeEndTime(uint256 _endTime) onlyOwner {
280         endTime = _endTime;
281     }
282 
283     // @return total tokens supplied
284     function totalSupply() constant returns (uint256) {
285         return _totalSupply;
286     }
287     
288     // @return total tokens supplied
289     function totalNumberTokenSold() constant returns (uint256) {
290         return totalNumberTokenSold;
291     }
292 
293 
294     //Change total supply
295     function changeTotalSupply(uint256 totalSupply) onlyOwner {
296         _totalSupply = totalSupply;
297     }
298 
299 
300     // What is the balance of a particular account?
301     // @param who The address of the particular account
302     // @return the balanace the particular account
303     function balanceOf(address who) constant returns (uint256) {
304         return balances[who];
305     }
306 
307     // What is the balance of a particular account?
308     // @param who The address of the particular account
309     // @return the balance of KYC waiting to be approved
310     function balanceOfKyCToBeApproved(address who) constant returns (uint256) {
311         return balancesWaitingKYC[who];
312     }
313     
314 
315     function approveBalancesWaitingKYC(address[] listAddresses) onlyOwner {
316          for (uint256 i = 0; i < listAddresses.length; i++) {
317              address client = listAddresses[i];
318              balances[multisig] = balances[multisig].sub(balancesWaitingKYC[client]);
319              balances[client] = balances[client].add(balancesWaitingKYC[client]);
320              totalNumberTokenSold=totalNumberTokenSold.add(balancesWaitingKYC[client]);
321              _icoSupply = _icoSupply.sub(balancesWaitingKYC[client]);
322              balancesWaitingKYC[client] = 0;
323         }
324     }
325 
326     function addBonusForOneHolder(address holder, uint256 bonusToken) onlyOwner{
327          require(holder != 0x0); 
328          balances[multisig] = balances[multisig].sub(bonusToken);
329          balances[holder] = balances[holder].add(bonusToken);
330          totalNumberTokenSold=totalNumberTokenSold.add(bonusToken);
331          _icoSupply = _icoSupply.sub(bonusToken);
332     }
333 
334     
335     function addBonusForMultipleHolders(address[] listAddresses, uint256[] bonus) onlyOwner {
336         require(listAddresses.length == bonus.length); 
337          for (uint256 i = 0; i < listAddresses.length; i++) {
338                 require(listAddresses[i] != 0x0); 
339                 balances[listAddresses[i]] = balances[listAddresses[i]].add(bonus[i]);
340                 balances[multisig] = balances[multisig].sub(bonus[i]);
341                 totalNumberTokenSold=totalNumberTokenSold.add(bonus[i]);
342                 _icoSupply = _icoSupply.sub(bonus[i]);
343          }
344     }
345     
346    
347     
348     function modifyCurrentHardCap(uint256 _hardCap) onlyOwner isActive {
349         hardCap = _hardCap;
350     }
351 
352     // @notice send `value` token to `to` from `msg.sender`
353     // @param to The address of the recipient
354     // @param value The amount of token to be transferred
355     // @return the transaction address and send the event as Transfer
356     function transfer(address to, uint256 value) canTradable isActive {
357         require (
358             balances[msg.sender] >= value && value > 0
359         );
360         balances[msg.sender] = balances[msg.sender].sub(value);
361         balances[to] = balances[to].add(value);
362         Transfer(msg.sender, to, value);
363     }
364 
365     // @notice send `value` token to `to` from `from`
366     // @param from The address of the sender
367     // @param to The address of the recipient
368     // @param value The amount of token to be transferred
369     // @return the transaction address and send the event as Transfer
370     function transferFrom(address from, address to, uint256 value) canTradable isActive {
371         require (
372             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
373         );
374         balances[from] = balances[from].sub(value);
375         balances[to] = balances[to].add(value);
376         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
377         Transfer(from, to, value);
378     }
379 
380     // Allow spender to withdraw from your account, multiple times, up to the value amount.
381     // If this function is called again it overwrites the current allowance with value.
382     // @param spender The address of the sender
383     // @param value The amount to be approved
384     // @return the transaction address and send the event as Approval
385     function approve(address spender, uint256 value) isActive {
386         require (
387             balances[msg.sender] >= value && value > 0
388         );
389         allowed[msg.sender][spender] = value;
390         Approval(msg.sender, spender, value);
391     }
392 
393     // Check the allowed value for the spender to withdraw from owner
394     // @param owner The address of the owner
395     // @param spender The address of the spender
396     // @return the amount which spender is still allowed to withdraw from owner
397     function allowance(address _owner, address spender) constant returns (uint256) {
398         return allowed[_owner][spender];
399     }
400 
401     // Get current price of a Token
402     // @return the price or token value for a ether
403     function getRate() constant returns (uint256 result) {
404       return RATE;
405     }
406     
407     function getTokenDetail() public constant returns (string, string, uint256, uint256, uint256, uint256, uint256) {
408         return (name, symbol, startTime, endTime, _totalSupply, _icoSupply, totalNumberTokenSold);
409     }
410 }