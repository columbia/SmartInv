1 pragma solidity ^0.4.0;
2 
3 contract SafeMath {
4   //internals
5 
6   function safeMul(uint256 a, uint256 b) internal returns (uint256 c) {
7     c = a * b;
8     assert(a == 0 || c / a == b);
9   }
10 
11   function safeSub(uint256 a, uint256 b) internal returns (uint256 c) {
12     assert(b <= a);
13     c = a - b;
14   }
15 
16   function safeAdd(uint256 a, uint256 b) internal returns (uint256 c) {
17     c = a + b;
18     assert(c>=a && c>=b);
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract Token {
27   /// @return total amount of tokens
28   function totalSupply() constant returns (uint256 supply) {}
29 
30   /// @param _owner The address from which the balance will be retrieved
31   /// @return The balance
32   function balanceOf(address _owner) constant returns (uint256 balance) {}
33 
34   /// @notice send `_value` token to `_to` from `msg.sender`
35   /// @param _to The address of the recipient
36   /// @param _value The amount of token to be transferred
37   /// @return Whether the transfer was successful or not
38   function transfer(address _to, uint256 _value) returns (bool success) {}
39 
40   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41   /// @param _from The address of the sender
42   /// @param _to The address of the recipient
43   /// @param _value The amount of token to be transferred
44   /// @return Whether the transfer was successful or not
45   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48   /// @param _spender The address of the account able to transfer the tokens
49   /// @param _value The amount of wei to be approved for transfer
50   /// @return Whether the approval was successful or not
51   function approve(address _spender, uint256 _value) returns (bool success) {}
52 
53   /// @param _owner The address of the account owning tokens
54   /// @param _spender The address of the account able to transfer the tokens
55   /// @return Amount of remaining tokens allowed to spent
56   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
57 
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61   uint public decimals;
62   string public name;
63 }
64 
65 contract ValueToken is SafeMath,Token{
66     
67     string name = "Value";
68     uint decimals = 0;
69     
70     uint256 supplyNow = 0; 
71     mapping (address => uint256) internal balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     
74     function totalSupply() constant returns (uint256 totalSupply){
75         return supplyNow;
76     }
77     
78     function balanceOf(address _owner) constant returns (uint256 balance){
79         return balances[_owner];
80     }
81     
82     function transfer(address _to, uint256 _value) returns (bool success){
83         if (balanceOf(msg.sender) >= _value) {
84             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
85             balances[_to] = safeAdd(balanceOf(_to), _value);
86             Transfer(msg.sender, _to, _value);
87             return true;
88         } else { return false; }
89         
90     }
91     
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
93         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
94             balances[_to] = safeAdd(balanceOf(_to), _value);
95             balances[_from] = safeSub(balanceOf(_from), _value);
96             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
97             Transfer(_from, _to, _value);
98             return true;
99         } else { return false; }
100     }
101     
102     function approve(address _spender, uint256 _value) returns (bool success){
103         if(balances[msg.sender] >= _value){
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107         } else { return false; }
108     }
109     
110     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
111         return allowed[_owner][_spender];
112     }
113     
114     function createValue(address _owner, uint256 _value) internal returns (bool success){
115         balances[_owner] = safeAdd(balances[_owner], _value);
116         supplyNow = safeAdd(supplyNow, _value);
117         Mint(_owner, _value);
118     }
119     
120     function destroyValue(address _owner, uint256 _value) internal returns (bool success){
121         balances[_owner] = safeSub(balances[_owner], _value);
122         supplyNow = safeSub(supplyNow, _value);
123         Burn(_owner, _value);
124     }
125     
126     event Mint(address indexed _owner, uint256 _value);
127     
128     event Burn(address indexed _owner, uint256 _value);
129     
130 }
131 
132 /// @title Quick trading and interest-yielding savings.
133 contract ValueTrader is SafeMath,ValueToken{
134     
135     function () payable {
136         // this contract eats any money sent to it incorrectly.
137         // thank you for the donation.
138     }
139     
140     // use this to manage tokens
141     struct TokenData {
142         bool isValid; // is this token currently accepted
143         uint256 basePrice; //base price of this token
144         uint256 baseLiquidity; //target liquidity of this token (price = basePrice +psf)
145         uint256 priceScaleFactor; //how quickly does price increase above base
146         bool hasDividend;
147         address divContractAddress;
148         bytes divData;
149     }
150     
151     address owner;
152     address etherContract;
153     uint256 tradeCoefficient; // 1-(this/10000) = fee for instant trades, "negative" fees possible.
154     mapping (address => TokenData) tokenManage;
155     bool public burning = false; //after draining is finished, burn to retrieve tokens, allow suicide.
156     bool public draining = false; //prevent creation of new value
157     
158     modifier owned(){
159         assert(msg.sender == owner);
160         _;
161     }
162     
163     modifier burnBlock(){
164         assert(!burning);
165         _;
166     }
167     
168     modifier drainBlock(){
169         assert(!draining);
170         _;
171     }
172     
173     //you cannot turn off draining without turning off burning first.
174     function toggleDrain() burnBlock owned {
175         draining = !draining;
176     }
177     
178     function toggleBurn() owned {
179         assert(draining);
180         assert(balanceOf(owner) == supplyNow);
181         burning = !burning;
182     }
183     
184     function die() owned burnBlock{
185         //MAKE SURE TO RETRIEVE TOKEN BALANCES BEFORE DOING THIS!
186         selfdestruct(owner);
187     }
188     
189     function validateToken(address token_, uint256 bP_, uint256 bL_, uint256 pF_) owned {
190         
191         tokenManage[token_].isValid = true;
192         tokenManage[token_].basePrice = bP_;
193         tokenManage[token_].baseLiquidity = bL_;
194         tokenManage[token_].priceScaleFactor = pF_;
195         
196     }
197     
198     function configureTokenDividend(address token_, bool hD_, address dA_, bytes dD_) owned {
199     
200         tokenManage[token_].hasDividend = hD_;
201         tokenManage[token_].divContractAddress = dA_;
202         tokenManage[token_].divData = dD_;
203     }
204     
205     function callDividend(address token_) owned {
206         //this is a dangerous and irresponsible feature,
207         //gives owner ability to do virtually anything 
208         //(bar running away with all the ether)
209         //I can't think of a better solution until there is a standard for dividend-paying contracts.
210         assert(tokenManage[token_].hasDividend);
211         assert(tokenManage[token_].divContractAddress.call.value(0)(tokenManage[token_].divData));
212     }
213     
214     function invalidateToken(address token_) owned {
215         tokenManage[token_].isValid = false;
216     }
217     
218     function changeOwner(address owner_) owned {
219         owner = owner_;
220     }
221     
222     function changeFee(uint256 tradeFee) owned {
223         tradeCoefficient = tradeFee;
224     }
225     
226     function changeEtherContract(address eC) owned {
227         etherContract = eC;
228     }
229     
230     event Buy(address tokenAddress, address buyer, uint256 amount, uint256 remaining);
231     event Sell(address tokenAddress, address buyer, uint256 amount, uint256 remaining);
232     event Trade(address fromTokAddress, address toTokAddress, address buyer, uint256 amount);
233 
234     function ValueTrader(){
235         owner = msg.sender;
236         burning = false;
237         draining = false;
238     }
239     
240     
241     
242     function valueWithFee(uint256 tempValue) internal returns (uint256 doneValue){
243         doneValue = safeMul(tempValue,tradeCoefficient)/10000;
244         if(tradeCoefficient < 10000){
245             //send fees to owner (in value tokens).
246             createValue(owner,safeSub(tempValue,doneValue));
247         }
248     }
249     
250     function currentPrice(address token) constant returns (uint256 price){
251         if(draining){
252             price = 1;
253         } else {
254         assert(tokenManage[token].isValid);
255         uint256 basePrice = tokenManage[token].basePrice;
256         uint256 baseLiquidity = tokenManage[token].baseLiquidity;
257         uint256 priceScaleFactor = tokenManage[token].priceScaleFactor;
258         uint256 currentLiquidity;
259         if(token == etherContract){
260             currentLiquidity = this.balance;
261         }else{
262             currentLiquidity = Token(token).balanceOf(this);
263         }
264         price = safeAdd(basePrice,safeMul(priceScaleFactor,baseLiquidity/currentLiquidity));
265         }
266     }
267     
268     function currentLiquidity(address token) constant returns (uint256 liquidity){
269         liquidity = Token(token).balanceOf(this);
270     }
271     
272     function valueToToken(address token, uint256 amount) constant internal returns (uint256 value){
273         value = amount/currentPrice(token);
274         assert(value != 0);
275     }
276     
277     function tokenToValue(address token, uint256 amount) constant internal returns (uint256 value){
278         value = safeMul(amount,currentPrice(token));
279     }
280     
281     function sellToken(address token, uint256 amount) drainBlock {
282     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
283         assert(verifiedTransferFrom(token,msg.sender,amount));
284         assert(createValue(msg.sender, tokenToValue(token,amount)));
285         Sell(token, msg.sender, amount, balances[msg.sender]);
286     }
287 
288     function buyToken(address token, uint256 amount) {
289         assert(!(valueToToken(token,balances[msg.sender]) < amount));
290         assert(destroyValue(msg.sender, tokenToValue(token,amount)));
291         assert(Token(token).transfer(msg.sender, amount));
292         Buy(token, msg.sender, amount, balances[msg.sender]);
293     }
294     
295     function sellEther() payable drainBlock {
296         assert(createValue(msg.sender, tokenToValue(etherContract,msg.value)));
297         Sell(etherContract, msg.sender, msg.value, balances[msg.sender]);
298     }
299     
300     function buyEther(uint256 amount) {
301         assert(valueToToken(etherContract,balances[msg.sender]) >= amount);
302         assert(destroyValue(msg.sender, tokenToValue(etherContract,amount)));
303         assert(msg.sender.call.value(amount)());
304         Buy(etherContract, msg.sender, amount, balances[msg.sender]);
305     }
306     
307     //input a mixture of a token and ether, recieve the output token
308     function quickTrade(address tokenFrom, address tokenTo, uint256 input) payable drainBlock {
309         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the (token) transfer on your behalf.
310         uint256 inValue;
311         uint256 tempInValue = safeAdd(tokenToValue(etherContract,msg.value),
312         tokenToValue(tokenFrom,input));
313         inValue = valueWithFee(tempInValue);
314         uint256 outValue = valueToToken(tokenTo,inValue);
315         assert(verifiedTransferFrom(tokenFrom,msg.sender,input));
316         if (tokenTo == etherContract){
317           assert(msg.sender.call.value(outValue)());  
318         } else assert(Token(tokenTo).transfer(msg.sender, outValue));
319         Trade(tokenFrom, tokenTo, msg.sender, inValue);
320     }
321     
322     function verifiedTransferFrom(address tokenFrom, address senderAdd, uint256 amount) internal returns (bool success){
323     uint256 balanceBefore = Token(tokenFrom).balanceOf(this);
324     success = Token(tokenFrom).transferFrom(senderAdd, this, amount);
325     uint256 balanceAfter = Token(tokenFrom).balanceOf(this);
326     assert((safeSub(balanceAfter,balanceBefore)==amount));
327     }
328 
329     
330 }
331 
332 //manage ValueTrader in an automated way!
333 //fixed amount of (2) holders/managers,
334 //because I'm too lazy to make anything more complex.
335 contract ShopKeeper is SafeMath{
336     
337     ValueTrader public shop;
338     address holderA; //actually manages the trader, recieves equal share of profits
339     address holderB; //only recieves manages own profits, (for profit-container type contracts)
340     
341     
342     modifier onlyHolders(){
343         assert(msg.sender == holderA || msg.sender == holderB);
344         _;
345     }
346     
347     modifier onlyA(){
348         assert(msg.sender == holderA);
349         _;
350     }
351     
352     function(){
353         //this contract is not greedy, should not hold any value.
354         throw;
355     }
356     
357     function ShopKeeper(address other){
358         shop = new ValueTrader();
359         holderA = msg.sender;
360         holderB = other;
361     }
362     
363     function giveAwayOwnership(address newHolder) onlyHolders {
364         if(msg.sender == holderB){
365             holderB = newHolder;
366         } else {
367             holderA = newHolder;
368         }
369     }
370     
371     function splitProfits(){
372         uint256 unprocessedProfit = shop.balanceOf(this);
373         uint256 equalShare = unprocessedProfit/2;
374         assert(shop.transfer(holderA,equalShare));
375         assert(shop.transfer(holderB,equalShare));
376     }
377     
378     //Management interface below
379     
380     function toggleDrain() onlyA {
381         shop.toggleDrain();
382     }
383     
384     function toggleBurn() onlyA {
385         shop.toggleBurn();
386     }
387     
388     function die() onlyA {
389         shop.die();
390     }
391     
392     function validateToken(address token_, uint256 bP_, uint256 bL_, uint256 pF_) onlyHolders {
393         shop.validateToken(token_,bP_,bL_,pF_);
394     }
395     
396     function configureTokenDividend(address token_, bool hD_, address dA_, bytes dD_) onlyA {
397         shop.configureTokenDividend(token_,hD_,dA_,dD_);
398     }
399     
400     function callDividend(address token_) onlyA {
401         shop.callDividend(token_);
402     }
403     
404     function invalidateToken(address token_) onlyHolders {
405         shop.invalidateToken(token_);
406     }
407     
408     function changeOwner(address owner_) onlyA {
409         if(holderB == holderA){ 
410             //if holder has full ownership, they can discard this management contract
411             shop.changeOwner(owner_); 
412         }
413         holderA = owner_;
414     }
415     
416     function changeShop(address newShop) onlyA {
417         if(holderB == holderA){
418             //if holder has full ownership, they can reengage the shop contract
419             shop = ValueTrader(newShop);
420         }
421     }
422     
423     function changeFee(uint256 tradeFee) onlyHolders {
424         shop.changeFee(tradeFee);
425     }
426     
427     function changeEtherContract(address eC) onlyHolders {
428         shop.changeEtherContract(eC);
429     }
430 }
431 
432 //this contract should be holderB in the shopKeeper contract.
433 contract ProfitContainerAdapter is SafeMath{
434     
435     address owner;
436     address shopLocation;
437     address shopKeeperLocation;
438     address profitContainerLocation;
439     
440     modifier owned(){
441         assert(msg.sender == owner);
442         _;
443     }
444     
445     function changeShop(address newShop) owned {
446         shopLocation = newShop;
447     }
448     
449     
450     function changeKeeper(address newKeeper) owned {
451         shopKeeperLocation = newKeeper;
452     }
453     
454     
455     function changeContainer(address newContainer) owned {
456         profitContainerLocation = newContainer;
457     }
458     
459     function ProfitContainerAdapter(address sL, address sKL, address pCL){
460         owner = msg.sender;
461         shopLocation = sL;
462         shopKeeperLocation = sKL;
463         profitContainerLocation = pCL;
464     }
465     
466     function takeEtherProfits(){
467         ShopKeeper(shopKeeperLocation).splitProfits();
468         ValueTrader shop = ValueTrader(shopLocation);
469         shop.buyEther(shop.balanceOf(this));
470         assert(profitContainerLocation.call.value(this.balance)());
471     }
472     
473     //warning: your profit container needs to be able to handle tokens or this is lost forever
474     function takeTokenProfits(address token){
475         ShopKeeper(shopKeeperLocation).splitProfits();
476         ValueTrader shop = ValueTrader(shopLocation);
477         shop.buyToken(token,shop.balanceOf(this));
478         assert(Token(token).transfer(profitContainerLocation,Token(token).balanceOf(this)));
479     }
480     
481     function giveAwayHoldership(address holderB) owned {
482         ShopKeeper(shopKeeperLocation).giveAwayOwnership(holderB);
483     }
484     
485     function giveAwayOwnership(address newOwner) owned {
486         owner = newOwner;
487     }
488     
489 }