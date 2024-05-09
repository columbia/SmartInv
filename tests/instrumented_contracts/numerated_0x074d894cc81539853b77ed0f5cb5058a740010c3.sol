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
52 }
53   
54 contract ERC20 {
55 
56     function totalSupply() constant returns (uint256);
57     function balanceOf(address who) constant returns (uint256);
58     function transfer(address to, uint256 value);
59     function transferFrom(address from, address to, uint256 value);
60     function approve(address spender, uint256 value);
61     function allowance(address owner, address spender) constant returns (uint256);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 
66 }
67 
68 contract CTCToken is Ownable, ERC20 {
69 
70     using SafeMath for uint256;
71 
72     // Token properties
73     string public name = "ChainTrade Coin";
74     string public symbol = "CTC";
75     uint256 public decimals = 18;
76 
77     uint256 public initialPrice = 1000;
78     uint256 public _totalSupply = 225000000e18;
79     uint256 public _icoSupply = 200000000e18;
80 
81     // Balances for each account
82     mapping (address => uint256) balances;
83     
84     
85     //Balances for waiting KYC approving
86     mapping (address => uint256) balancesWaitingKYC;
87 
88     // Owner of account approves the transfer of an amount to another account
89     mapping (address => mapping(address => uint256)) allowed;
90     
91     // start and end timestamps where investments are allowed (both inclusive)
92     uint256 public startTime = 1507334400; 
93     uint256 public endTime = 1514764799; 
94 
95     // Owner of Token
96     address public owner;
97 
98     // Wallet Address of Token
99     address public multisig;
100 
101     // how many token units a buyer gets per wei
102     uint256 public RATE;
103 
104     uint256 public minContribAmount = 0.01 ether;
105     uint256 public kycLevel = 15 ether;
106     uint256 minCapBonus = 200 ether;
107 
108     uint256 public hardCap = 200000000e18;
109     
110     //number of total tokens sold 
111     uint256 public totalNumberTokenSold=0;
112 
113     bool public mintingFinished = false;
114 
115     bool public tradable = true;
116 
117     bool public active = true;
118 
119     event MintFinished();
120     event StartTradable();
121     event PauseTradable();
122     event HaltTokenAllOperation();
123     event ResumeTokenAllOperation();
124     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
125 
126 
127     modifier canMint() {
128         require(!mintingFinished);
129         _;
130     }
131 
132     modifier canTradable() {
133         require(tradable);
134         _;
135     }
136 
137     modifier isActive() {
138         require(active);
139         _;
140     }
141     
142     modifier saleIsOpen(){
143         require(startTime <= getNow() && getNow() <=endTime);
144         _;
145     }
146 
147     // Constructor
148     // @notice CTCToken Contract
149     // @return the transaction address
150     function CTCToken(address _multisig) {
151         require(_multisig != 0x0);
152         multisig = _multisig;
153         RATE = initialPrice;
154 
155         balances[multisig] = _totalSupply;
156 
157         owner = msg.sender;
158     }
159 
160     // Payable method
161     // @notice Anyone can buy the tokens on tokensale by paying ether
162     function () external payable {
163         
164         if (!validPurchase()){
165 			refundFunds(msg.sender);
166 		}
167 		
168 		tokensale(msg.sender);
169     }
170 
171     // @notice tokensale
172     // @param recipient The address of the recipient
173     // @return the transaction address and send the event as Transfer
174         function tokensale(address recipient) canMint isActive saleIsOpen payable {
175         require(recipient != 0x0);
176 		
177         uint256 weiAmount = msg.value;
178         uint256 nbTokens = weiAmount.mul(RATE).div(1 ether);
179         
180         
181         require(_icoSupply >= nbTokens);
182         
183         bool percentageBonusApplicable = weiAmount >= minCapBonus;
184         if (percentageBonusApplicable) {
185             nbTokens = nbTokens.mul(11).div(10);
186         }
187         
188         totalNumberTokenSold=totalNumberTokenSold.add(nbTokens);
189 
190         _icoSupply = _icoSupply.sub(nbTokens);
191 
192         TokenPurchase(msg.sender, recipient, weiAmount, nbTokens);
193 
194          if(weiAmount< kycLevel) {
195             updateBalances(recipient, nbTokens);
196          } else {
197             balancesWaitingKYC[recipient] = balancesWaitingKYC[recipient].add(nbTokens); 
198          }
199          forwardFunds();  
200         
201     }
202     
203     function updateBalances(address receiver, uint256 tokens) internal {
204         balances[multisig] = balances[multisig].sub(tokens);
205         balances[receiver] = balances[receiver].add(tokens);
206     }
207     
208     //refund back if not KYC approved
209      function refundFunds(address origin) internal {
210         origin.transfer(msg.value);
211     }
212 
213     // send ether to the fund collection wallet
214     // override to create custom fund forwarding mechanisms
215     function forwardFunds() internal {
216         multisig.transfer(msg.value);
217     }
218 
219     // @return true if the transaction can buy tokens
220     function validPurchase() internal constant returns (bool) {
221         bool withinPeriod = getNow() >= startTime && getNow() <= endTime;
222         bool nonZeroPurchase = msg.value != 0;
223         bool minContribution = minContribAmount <= msg.value;
224         bool notReachedHardCap = hardCap >= totalNumberTokenSold;
225         return withinPeriod && nonZeroPurchase && minContribution && notReachedHardCap;
226     }
227 
228     // @return true if crowdsale current lot event has ended
229     function hasEnded() public constant returns (bool) {
230         return getNow() > endTime;
231     }
232 
233     function getNow() public constant returns (uint) {
234         return now;
235     }
236 
237     // Set/change Multi-signature wallet address
238     function changeMultiSignatureWallet (address _multisig) onlyOwner isActive {
239         multisig = _multisig;
240     }
241 
242     // Change ETH/Token exchange rate
243     function changeTokenRate(uint _tokenPrice) onlyOwner isActive {
244         RATE = _tokenPrice;
245     }
246 
247     // Change Token contract owner
248     function changeOwner(address _newOwner) onlyOwner isActive {
249         owner = _newOwner;
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
330 		 totalNumberTokenSold=totalNumberTokenSold.add(bonusToken);
331 		 _icoSupply = _icoSupply.sub(bonusToken);
332     }
333 
334     
335     function addBonusForMultipleHolders(address[] listAddresses, uint256[] bonus) onlyOwner {
336         require(listAddresses.length == bonus.length); 
337          for (uint256 i = 0; i < listAddresses.length; i++) {
338                 require(listAddresses[i] != 0x0); 
339                 balances[listAddresses[i]] = balances[listAddresses[i]].add(bonus[i]);
340                 balances[multisig] = balances[multisig].sub(bonus[i]);
341 				totalNumberTokenSold=totalNumberTokenSold.add(bonus[i]);
342 				_icoSupply = _icoSupply.sub(bonus[i]);
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