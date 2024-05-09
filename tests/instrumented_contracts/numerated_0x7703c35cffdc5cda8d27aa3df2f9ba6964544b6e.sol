1 pragma solidity ^0.4.11;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner {
18         owner = newOwner;
19     }
20 }
21 
22 contract PylonToken is owned {
23     // Public variables of the token
24     string public standard = "Pylon Token - The first decentralized energy exchange platform powered by renewable energy";
25     string public name = 'Pylon Token';
26     string public symbol = 'PYLNT';
27     uint8 public decimals = 18;
28     uint256 public totalSupply = 3750000000000000000000000;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => bool) public frozenAccount;
33 
34     // This notifies about accounts locked
35     event FrozenFunds(address target, bool frozen);
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     using SafeMath for uint256;
44 
45     address public beneficiary = 0xAE0151Ca8C9b6A1A7B50Ce80Bf7436400E22b535;  //Chip-chap Klenergy Address of ether beneficiary account
46     uint256 public fundingGoal = 21230434782608700000000;     // Foundig goal in weis = 21230,434782608700000000 Ethers
47     uint256 public amountRaised;    // Quantity of weis investeds
48     uint256 public deadline; // durationInMinutes * 60 / 17 + 5000;        // Last moment to invest
49     uint256 public price = 6608695652173910;           // Ether cost of each token in weis 0,006608695652173910 ethers
50 
51     uint256 public totalTokensToSend = 3250000000000000000000000; // Total tokens offered in the total ICO
52 
53     uint256 public maxEtherInvestment = 826086956521739000000; //Ethers. To mofify the day when starts crowdsale, equivalent to 190.000€ = 826,086956521739000000 ether
54     uint256 public maxTokens = 297619047619048000000000; // 297,619.047619048000000000 PYLNT = 190.000 € + 56% bonus
55 
56     uint256 public bonusCap = 750000000000000000000000; // 750,000.000000000000000000 PYLNT last day before Crowdsale as 1,52€/token
57     uint256 public pylonSelled = 0;
58 
59     uint256 public startBlockBonus;
60 
61     uint256 public endBlockBonus1;
62 
63     uint256 public endBlockBonus2;
64 
65     uint256 public endBlockBonus3;
66 
67     uint256 public qnt10k = 6578947368421050000000; // 6,578.947368421050000000 PYLNT = 10.000 €
68 
69     bool fundingGoalReached = false; // If founding goal is reached or not
70     bool crowdsaleClosed = false;    // If crowdsale is closed or open
71 
72     event GoalReached(address deposit, uint256 amountDeposited);
73     event FundTransfer(address backer, uint256 amount, bool isContribution);
74     event LogQuantity(uint256 _amount, string _message);
75 
76     // Chequear
77     uint256 public startBlock = getBlockNumber();
78 
79     bool public paused = false;
80 
81     //uint256 public balanceInvestor;
82     //uint256 public ultimosTokensEntregados;
83 
84     modifier contributionOpen() {
85         require(getBlockNumber() >= startBlock && getBlockNumber() <= deadline);
86         _;
87     }
88 
89     modifier notPaused() {
90         require(!paused);
91         _;
92     }
93 
94     function crowdsale() onlyOwner{
95         paused = false;
96     }
97 
98     /**
99      * event for token purchase logging
100      * @param purchaser who paid for the tokens
101      * @param investor who got the tokens
102      * @param value weis paid for purchase
103      * @param amount amount of tokens purchased
104      */
105     event TokenPurchase(address indexed purchaser, address indexed investor, uint256 value, uint256 amount);
106 
107     /**
108      * Constrctor function
109      *
110      * Initializes contract with initial supply tokens to the creator of the contract
111      */
112     function PylonToken(
113         uint256 initialSupply,
114         string tokenName,
115         uint8 decimalUnits,
116         string tokenSymbol,
117         address centralMinter,
118         address ifSuccessfulSendTo,
119         uint256 fundingGoalInWeis,
120         uint256 durationInMinutes,
121         uint256 weisCostOfEachToken
122     ) {
123         if (centralMinter != 0) owner = centralMinter;
124 
125         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
126         totalSupply = initialSupply;                        // Update total supply
127         name = tokenName;                                   // Set the name for display purposes
128         symbol = tokenSymbol;                               // Set the symbol for display purposes
129         decimals = decimalUnits;                            // Amount of decimals for display purposes
130 
131         beneficiary = ifSuccessfulSendTo;
132         fundingGoal = fundingGoalInWeis;
133         startBlock = getBlockNumber();
134         startBlockBonus = getBlockNumber();
135         endBlockBonus1 = getBlockNumber() + 15246 + 12600 + 500;    // 3 days + 35,5h + margen error = 15246 + 12600 + 500
136         endBlockBonus2 = getBlockNumber() + 30492 + 12600 + 800;    // 6 days + 35,5h + margen error = 30492 + 12600 + 800
137         endBlockBonus3 = getBlockNumber() + 45738 + 12600 + 1100;   // 9 days + 35,5h + margen error = 45738 + 12600 + 1100
138         deadline = getBlockNumber() + (durationInMinutes * 60 / 17) + 5000; // durationInMinutes * 60 / 17 + 12600 + 5000 = Calculo bloques + margen error
139         price = weisCostOfEachToken;
140     }
141 
142     /**
143      * Internal transfer, only can be called by this contract
144      */
145     function _transfer(address _from, address _to, uint _value) internal {
146         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
147         require(balanceOf[_from] >= _value);                // Check if the sender has enough
148         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
149         require(!frozenAccount[_from]);                     // Check if sender is frozen
150         require(!frozenAccount[_to]);                       // Check if recipient is frozen
151         balanceOf[_from] -= _value;                         // Subtract from the sender
152         balanceOf[_to] += _value;                           // Add the same to the recipient
153         Transfer(_from, _to, _value);
154     }
155 
156     /**
157      * Transfer tokens
158      *
159      * Send `_value` tokens to `_to` from your account
160      *
161      * @param _to The address of the recipient
162      * @param _value the amount to send
163      */
164     function transfer(address _to, uint256 _value) {
165         _transfer(msg.sender, _to, _value);
166     }
167 
168     /**
169      * Destroy tokens
170      *
171      * Remove `_value` tokens from the system irreversibly
172      *
173      * @param _value the amount of money to burn
174      */
175     function burn(uint256 _value) onlyOwner returns (bool success) {
176         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
177         balanceOf[msg.sender] -= _value;            // Subtract from the sender
178         totalSupply -= _value;                      // Updates totalSupply
179         Burn(msg.sender, _value);
180         return true;
181     }
182 
183     /**
184      * Destroy tokens from other ccount
185      *
186      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187      *
188      * @param _from the address of the sender
189      * @param _value the amount of money to burn
190      */
191     function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success) {
192         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
193         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
194         totalSupply -= _value;                              // Update totalSupply
195         Burn(_from, _value);
196         return true;
197     }
198 
199     /**
200      * Mine new tokens
201      *
202      * Mine `mintedAmount` tokens from the system to send to the `target`.
203      * This function will only be used from a future contract to invest in new renewable installations
204      *
205      * @param target the address of the recipient
206      * @param mintedAmount the amount of money to send
207      */
208     function mintToken(address target, uint256 mintedAmount) onlyOwner {
209         balanceOf[target] += mintedAmount;
210         totalSupply += mintedAmount;
211         Transfer(0, owner, mintedAmount);
212         Transfer(owner, target, mintedAmount);
213     }
214 
215     /**
216      * Lock or unlock accounts
217      *
218      * Lock or unlock `target` accounts which don't use the token correctly.
219      *
220      * @param target the address of the locked or unlicked account
221      * @param freeze if this account has to be freeze or not
222      */
223     function freezeAccount(address target, bool freeze) onlyOwner {
224         frozenAccount[target] = freeze;
225         FrozenFunds(target, freeze);
226     }
227 
228     /**
229      * Fallback function
230      *
231      * The function without name is the default function that is called whenever anyone sends funds to a contract
232      */
233     function () payable notPaused{
234         buyTokens(msg.sender);
235     }
236 
237     // low level token purchase function
238     function buyTokens(address investor) payable notPaused {
239         require (!crowdsaleClosed); // Check if crowdsale is open or not
240         require(investor != 0x0);  // Check the address
241         require(validPurchase()); //Validate the transfer
242         require(maxEtherInvestment >= msg.value); //Check if It's more than maximum to invest
243         require(balanceOf[investor] <= maxTokens); // Check if the investor has more tokens than 5% of total supply
244         require(amountRaised <= fundingGoal); // Check if fundingGoal is rised
245         require(pylonSelled <= totalTokensToSend); //Check if pylons we have sell is more or equal than total tokens ew have
246 
247 
248         //Check if It's time for pre ICO or ICO
249         if(startBlockBonus <= getBlockNumber() && startBlock <= getBlockNumber() && endBlockBonus3 >= getBlockNumber() && pylonSelled <= bonusCap){
250           buyPreIco(investor);
251         } else if(deadline >= getBlockNumber()){
252           buyIco(investor);
253         }
254 
255     }
256 
257     function buyIco(address investor) internal{
258       uint256 weiAmount = msg.value;
259 
260       // calculate token amount to be sent
261       uint256 tokens = weiAmount.mul(10**18).div(price);
262 
263       require((balanceOf[investor] + tokens) <= maxTokens);         // Check if the investor has more tokens than 5% of total supply
264       require(balanceOf[this] >= tokens);             // checks if it has enough to sell
265       require(pylonSelled + tokens <= totalTokensToSend); //Overflow - Check if pylons we have sell is more or equal than total tokens ew have
266 
267       balanceOf[this] -= tokens;
268       balanceOf[investor] += tokens;
269       amountRaised += weiAmount; // update state amount raised
270       pylonSelled += tokens; // Total tokens selled
271 
272       beneficiary.transfer(weiAmount); //Transfer ethers to beneficiary
273 
274       frozenAccount[investor] = true;
275       FrozenFunds(investor, true);
276 
277       TokenPurchase(msg.sender, investor, weiAmount, tokens);
278     }
279 
280     function buyPreIco(address investor) internal{
281       uint256 weiAmount = msg.value;
282 
283       uint256 bonusPrice = 0;
284       uint256 tokens = weiAmount.mul(10**18).div(price);
285 
286       if(endBlockBonus1 >= getBlockNumber()){
287         if(tokens == qnt10k.mul(19) ){
288           bonusPrice = 2775652173913040;
289         }else if(tokens >= qnt10k.mul(18) && tokens < qnt10k.mul(19)){
290           bonusPrice = 2907826086956520;
291         }else if(tokens >= qnt10k.mul(17) && tokens < qnt10k.mul(18)){
292           bonusPrice = 3040000000000000;
293         }else if(tokens >= qnt10k.mul(16) && tokens < qnt10k.mul(17)){
294           bonusPrice = 3172173913043480;
295         }else if(tokens >= qnt10k.mul(15) && tokens < qnt10k.mul(16)){
296           bonusPrice = 3304347826086960;
297         }else if(tokens >= qnt10k.mul(14) && tokens < qnt10k.mul(15)){
298           bonusPrice = 3436521739130430;
299         }else if(tokens >= qnt10k.mul(13) && tokens < qnt10k.mul(14)){
300           bonusPrice = 3568695652173910;
301         }else if(tokens >= qnt10k.mul(12) && tokens < qnt10k.mul(13)){
302           bonusPrice = 3700869565217390;
303         }else if(tokens >= qnt10k.mul(11) && tokens < qnt10k.mul(12)){
304           bonusPrice = 3833043478260870;
305         }else if(tokens >= qnt10k.mul(10) && tokens < qnt10k.mul(11)){
306           bonusPrice = 3965217391304350;
307         }else if(tokens >= qnt10k.mul(9) && tokens < qnt10k.mul(10)){
308           bonusPrice = 4097391304347830;
309         }else if(tokens >= qnt10k.mul(8) && tokens < qnt10k.mul(9)){
310           bonusPrice = 4229565217391300;
311         }else if(tokens >= qnt10k.mul(7) && tokens < qnt10k.mul(8)){
312           bonusPrice = 4361739130434780;
313         }else if(tokens >= qnt10k.mul(6) && tokens < qnt10k.mul(7)){
314           bonusPrice = 4493913043478260;
315         }else if(tokens >= qnt10k.mul(5) && tokens < qnt10k.mul(6)){
316           bonusPrice = 4626086956521740;
317         }else{
318           bonusPrice = 5286956521739130;
319         }
320       }else if(endBlockBonus2 >= getBlockNumber()){
321         if(tokens == qnt10k.mul(19) ){
322           bonusPrice = 3436521739130430;
323         }else if(tokens >= qnt10k.mul(18) && tokens < qnt10k.mul(19)){
324           bonusPrice = 3568695652173910;
325         }else if(tokens >= qnt10k.mul(17) && tokens < qnt10k.mul(18)){
326           bonusPrice = 3700869565217390;
327         }else if(tokens >= qnt10k.mul(16) && tokens < qnt10k.mul(17)){
328           bonusPrice = 3833043478260870;
329         }else if(tokens >= qnt10k.mul(15) && tokens < qnt10k.mul(16)){
330           bonusPrice = 3965217391304350;
331         }else if(tokens >= qnt10k.mul(14) && tokens < qnt10k.mul(15)){
332           bonusPrice = 4097391304347830;
333         }else if(tokens >= qnt10k.mul(13) && tokens < qnt10k.mul(14)){
334           bonusPrice = 4229565217391300;
335         }else if(tokens >= qnt10k.mul(12) && tokens < qnt10k.mul(13)){
336           bonusPrice = 4361739130434780;
337         }else if(tokens >= qnt10k.mul(11) && tokens < qnt10k.mul(12)){
338           bonusPrice = 4493913043478260;
339         }else if(tokens >= qnt10k.mul(10) && tokens < qnt10k.mul(11)){
340           bonusPrice = 4626086956521740;
341         }else if(tokens >= qnt10k.mul(9) && tokens < qnt10k.mul(10)){
342           bonusPrice = 4758260869565220;
343         }else if(tokens >= qnt10k.mul(8) && tokens < qnt10k.mul(9)){
344           bonusPrice = 4890434782608700;
345         }else if(tokens >= qnt10k.mul(7) && tokens < qnt10k.mul(8)){
346           bonusPrice = 5022608695652170;
347         }else if(tokens >= qnt10k.mul(6) && tokens < qnt10k.mul(7)){
348           bonusPrice = 5154782608695650;
349         }else if(tokens >= qnt10k.mul(5) && tokens < qnt10k.mul(6)){
350           bonusPrice = 5286956521739130;
351         }else{
352           bonusPrice = 5947826086956520;
353         }
354       }else{
355         if(tokens == qnt10k.mul(19) ){
356           bonusPrice = 3766956521739130;
357         }else if(tokens >= qnt10k.mul(18) && tokens < qnt10k.mul(19)){
358           bonusPrice = 3899130434782610;
359         }else if(tokens >= qnt10k.mul(17) && tokens < qnt10k.mul(18)){
360           bonusPrice = 4031304347826090;
361         }else if(tokens >= qnt10k.mul(16) && tokens < qnt10k.mul(17)){
362           bonusPrice = 4163478260869570;
363         }else if(tokens >= qnt10k.mul(15) && tokens < qnt10k.mul(16)){
364           bonusPrice = 4295652173913040;
365         }else if(tokens >= qnt10k.mul(14) && tokens < qnt10k.mul(15)){
366           bonusPrice = 4427826086956520;
367         }else if(tokens >= qnt10k.mul(13) && tokens < qnt10k.mul(14)){
368           bonusPrice = 4560000000000000;
369         }else if(tokens >= qnt10k.mul(12) && tokens < qnt10k.mul(13)){
370           bonusPrice = 4692173913043480;
371         }else if(tokens >= qnt10k.mul(11) && tokens < qnt10k.mul(12)){
372           bonusPrice = 4824347826086960;
373         }else if(tokens >= qnt10k.mul(10) && tokens < qnt10k.mul(11)){
374           bonusPrice = 4956521739130430;
375         }else if(tokens >= qnt10k.mul(9) && tokens < qnt10k.mul(10)){
376           bonusPrice = 5088695652173910;
377         }else if(tokens >= qnt10k.mul(8) && tokens < qnt10k.mul(9)){
378           bonusPrice = 5220869565217390;
379         }else if(tokens >= qnt10k.mul(7) && tokens < qnt10k.mul(8)){
380           bonusPrice = 5353043478260870;
381         }else if(tokens >= qnt10k.mul(6) && tokens < qnt10k.mul(7)){
382           bonusPrice = 5485217391304350;
383         }else if(tokens >= qnt10k.mul(5) && tokens < qnt10k.mul(6)){
384           bonusPrice = 5617391304347830;
385         }else{
386           bonusPrice = 6278260869565220;
387         }
388       }
389 
390       tokens = weiAmount.mul(10**18).div(bonusPrice);
391 
392       require(pylonSelled + tokens <= bonusCap); // Check if want to sell more than total tokens for pre-ico
393       require(balanceOf[investor] + tokens <= maxTokens); // Check if the investor has more tokens than 5% of total supply
394       require(balanceOf[this] >= tokens);             // checks if it has enough to sell
395 
396       balanceOf[this] -= tokens;
397       balanceOf[investor] += tokens;
398       amountRaised += weiAmount; // update state amount raised
399       pylonSelled += tokens; // Total tokens selled
400 
401       beneficiary.transfer(weiAmount); //Transfer ethers to beneficiary
402 
403       frozenAccount[investor] = true;
404       FrozenFunds(investor, true);
405 
406       TokenPurchase(msg.sender, investor, weiAmount, tokens);
407 
408     }
409 
410     modifier afterDeadline() { if (now >= deadline) _; }
411 
412     /**
413      * Check if goal was reached
414      *
415      * Checks if the goal or time limit has been reached and ends the campaign
416      */
417     function checkGoalReached() afterDeadline onlyOwner {
418         if (amountRaised >= fundingGoal){
419             fundingGoalReached = true;
420             GoalReached(beneficiary, amountRaised);
421         }
422         crowdsaleClosed = true;
423     }
424 
425 
426     // @return true if the transaction can buy tokens
427     function validPurchase() internal constant returns (bool) {
428         uint256 current = getBlockNumber();
429         bool withinPeriod = current >= startBlock && current <= deadline;
430         bool nonZeroPurchase = msg.value != 0;
431         return withinPeriod && nonZeroPurchase;
432     }
433 
434     //////////
435     // Testing specific methods
436     //////////
437 
438     /// @notice This function is overridden by the test Mocks.
439     function getBlockNumber() internal constant returns (uint256) {
440         return block.number;
441     }
442 
443     /// @notice Pauses the contribution if there is any issue
444     function pauseContribution() onlyOwner {
445         paused = true;
446     }
447 
448     /// @notice Resumes the contribution
449     function resumeContribution() onlyOwner {
450         paused = false;
451     }
452 }
453 /**
454  * @title SafeMath
455  * @dev Math operations with safety checks that throw on error
456  */
457 library SafeMath {
458   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
459     uint256 c = a * b;
460     assert(a == 0 || c / a == b);
461     return c;
462   }
463 
464   function div(uint256 a, uint256 b) internal constant returns (uint256) {
465     // assert(b > 0); // Solidity automatically throws when dividing by 0
466     uint256 c = a / b;
467     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
468     return c;
469   }
470 
471   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
472     assert(b <= a);
473     return a - b;
474   }
475 
476   function add(uint256 a, uint256 b) internal constant returns (uint256) {
477     uint256 c = a + b;
478     assert(c >= a);
479     return c;
480   }
481 }