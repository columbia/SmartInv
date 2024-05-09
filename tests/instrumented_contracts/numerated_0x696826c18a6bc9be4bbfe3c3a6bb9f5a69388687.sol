1 pragma solidity ^0.4.25;
2 
3 contract DecentralizationSmartGames{
4     using SafeMath for uint256;
5     
6     string public constant name   = "Decentralization Smart Games";
7     string public constant symbol = "DSG";
8     uint8 public constant decimals = 18;
9     uint256 public constant tokenPrice = 0.00065 ether;
10     uint256 public totalSupply; /* Total number of existing DSG tokens */
11     uint256 public divPerTokenPool; /* Trigger for calculating dividends on "Pool dividends" program */
12     uint256 public divPerTokenGaming; /* Trigger for calculating dividends on "Gaming dividends" program */
13     uint256 public developmentBalance; /* Balance that is used to support the project and games development */
14     uint256 public charityBalance;  /* Balance that is used for charity */
15     address[2] public owners;  /* Addresses of the contract owners */
16     address[2] public candidates; /* Addresses of the future contract owners */
17     /**Fee public fee - Structure where all percentages of the distribution of incoming funds are stored
18      * uint8 fee.r0 - First referrer - 6%
19      * uint8 fee.r1 - Second referrer - 4%
20      * uint8 fee.r2 - Third referrer - 3%
21      * uint8 fee.r3 - Fourth referrer - 2%
22      * uint8 fee.r4 - Fifth referrer - 1%
23      * uint8 fee.charity - Charity - 1%
24      * uint8 fee.development - For game development and project support - 18%
25      * uint8 fee.buy - For buying DSG tokens - 65%
26      */
27     Fee public fee = Fee(6,4,3,2,1,1,18,65);
28     /**Dividends public totalDividends - Structure where general dividend payments are kept
29      * uint256 totalDividends.referrer - Referrer Dividends
30      * uint256 totalDividends.gaming - Gaming Dividends
31      * uint256 totalDividends.pool - Pool Dividends
32      */
33     Dividends public totalDividends  = Dividends(0,0,0);
34     mapping (address => mapping (address => uint256)) private allowed;
35     /**mapping (address => Account) private account - Investors accounts data
36      * uint256 account[address].tokenBalance - Number of DSG tokens on balance
37      * uint256 account[address].ethereumBalance - The amount of ETH on balance (dividends)
38      * uint256 account[address].lastDivPerTokenPool - The trigger of last dividend payment upon the "Pool dividends" program 
39      * uint256 account[address].lastDivPerTokenGaming - The trigger of last dividend payment upon the "Gaming dividends" program
40      * uint256 account[address].totalDividendsReferrer - Total amount of dividends upon the "Referrer dividends" program
41      * uint256 account[address].totalDividendsGaming - Total amount of dividends upon the "Gaming dividends" program 
42      * uint256 account[address].totalDividendsPool -Total amount of dividends upon the "Pool dividends" program
43      * address[5] account[address].referrer - Array of all the referrers
44      * bool account[address].active - True, if the account is active
45      */
46     mapping (address => Account) public account;
47     mapping (address => bool) public games; /* The list of contracts from which dividends are allowed */
48     
49     struct Account {
50         uint256 tokenBalance;
51         uint256 ethereumBalance;
52         uint256 lastDivPerTokenPool;
53         uint256 lastDivPerTokenGaming;
54         uint256 totalDividendsReferrer;
55         uint256 totalDividendsGaming;
56         uint256 totalDividendsPool;
57         address[5] referrer;
58         bool active;
59     }
60     struct Fee{
61         uint8 r1;
62         uint8 r2;
63         uint8 r3;
64         uint8 r4;
65         uint8 r5;
66         uint8 charity;
67         uint8 development;
68         uint8 buy;
69     }
70     struct Dividends{
71         uint256 referrer;
72         uint256 gaming;
73         uint256 pool;
74     }
75     /* Allowed if the address is not 0x */
76     modifier check0x(address address0x) {
77         require(address0x != address(0), "Address is 0x");
78         _;
79     }
80     /* Allowed if on balance of DSG tokens >= amountDSG */
81     modifier checkDSG(uint256 amountDSG) {
82         require(account[msg.sender].tokenBalance >= amountDSG, "You don't have enough DSG on balance");
83         _;
84     }
85     /* Allowed if on balance ETH >= amountETH */
86     modifier checkETH(uint256 amountETH) {
87         require(account[msg.sender].ethereumBalance >= amountETH, "You don't have enough ETH on balance");
88         _;
89     }
90     /* Allowed if the function is called by one the contract owners */
91     modifier onlyOwners() {
92         require(msg.sender == owners[0] || msg.sender == owners[1], "You are not owner");
93         _;
94     }
95     /* Allowed if the sale is still active */
96     modifier sellTime() { 
97         require(now <= 1560211200, "The sale is over");
98         _;
99     }
100     /* Dividends upon the "Pool Dividends" program are being paid */
101     /* Dividends upon the "Gaming Dividends" program are being paid */
102     modifier payDividends(address sender) {
103         uint256 poolDividends = getPoolDividends();
104         uint256 gamingDividends = getGamingDividends();
105 		if(poolDividends > 0 && account[sender].active == true){
106 			account[sender].totalDividendsPool = account[sender].totalDividendsPool.add(poolDividends);
107 			account[sender].ethereumBalance = account[sender].ethereumBalance.add(poolDividends);
108 		}
109         if(gamingDividends > 0 && account[sender].active == true){
110 			account[sender].totalDividendsGaming = account[sender].totalDividendsGaming.add(gamingDividends);
111 			account[sender].ethereumBalance = account[sender].ethereumBalance.add(gamingDividends);
112 		}
113         _;
114 	    account[sender].lastDivPerTokenPool = divPerTokenPool;
115         account[sender].lastDivPerTokenGaming = divPerTokenGaming;
116         
117     }
118     /**We assign two contract owners, whose referrers are from the same address
119      * In the same manner we activate their accounts
120      */
121     constructor(address owner2) public{
122         address owner1 = msg.sender;
123         owners[0]                = owner1;
124         owners[1]                = owner2;
125         account[owner1].active   = true;
126         account[owner2].active   = true;
127         account[owner1].referrer = [owner1, owner1, owner1, owner1, owner1];
128         account[owner2].referrer = [owner2, owner2, owner2, owner2, owner2];
129     }
130     /**buy() - the function of buying DSG tokens.
131      * It is active only during the time interval specified in sellTime()
132      * Dividends upon Pool Dividends program are being paid
133      * Dividends upon the Gaming Dividends program are being paid
134      * address referrerAddress - The address of the referrer who invited to the program
135      * require - Minimum purchase is 100 DSG or 0.1 ETH
136      */
137     function buy(address referrerAddress) payDividends(msg.sender) sellTime public payable
138     {
139         require(msg.value >= 0.1 ether, "Minimum investment is 0.1 ETH");
140         uint256 forTokensPurchase = msg.value.mul(fee.buy).div(100); /* 65% */
141         uint256 forDevelopment = msg.value.mul(fee.development).div(100); /* 18% */
142         uint256 forCharity = msg.value.mul(fee.charity).div(100); /* 1% */
143         uint256 tokens = forTokensPurchase.mul(10 ** uint(decimals)).div(tokenPrice); /* The number of DSG tokens is counted (1ETH = 1000 DSG) */
144         _setReferrer(referrerAddress, msg.sender);  /* Assigning of referrers */
145         _mint(msg.sender, tokens); /* We create new DSG tokens and add to balance */
146         _setProjectDividends(forDevelopment, forCharity); /*  ETH is accrued to the project balances (18%, 1%) */
147         _distribution(msg.sender, msg.value.mul(fee.r1).div(100), 0); /* Dividends are accrued to the first refferer - 6% */
148         _distribution(msg.sender, msg.value.mul(fee.r2).div(100), 1); /* Dividends are accrued to the second refferer - 4% */
149         _distribution(msg.sender, msg.value.mul(fee.r3).div(100), 2); /* Dividends are accrued to the third refferer - 3% */
150         _distribution(msg.sender, msg.value.mul(fee.r4).div(100), 3); /* Dividends are accrued to the fourth refferer - 2% */
151         _distribution(msg.sender, msg.value.mul(fee.r5).div(100), 4); /* Dividends are accrued to the fifth referrer - 1% */
152         emit Buy(msg.sender, msg.value, tokens, totalSupply, now);
153     }
154     /**reinvest() - dividends reinvestment function.
155      * It is active only during the time interval specified in sellTime()
156      * Dividends upon the Pool Dividends and Gaming Dividends programs are being paid - payDividends(msg.sender)
157      * Checking whether the investor has a given amount of ETH in the contract - checkETH(amountEthereum)
158      * address amountEthereum - The amount of ETH sent for reinvestment (dividends)
159      */
160     function reinvest(uint256 amountEthereum) payDividends(msg.sender) checkETH(amountEthereum) sellTime public
161     {
162         uint256 tokens = amountEthereum.mul(10 ** uint(decimals)).div(tokenPrice); /* The amount of DSG tokens is counted (1ETH = 1000 DSG) */
163         _mint(msg.sender, tokens); /* We create DSG tokens and add to the balance */
164         account[msg.sender].ethereumBalance = account[msg.sender].ethereumBalance.sub(amountEthereum);/* The amount of ETH from the investor is decreased */
165         emit Reinvest(msg.sender, amountEthereum, tokens, totalSupply, now);
166     }
167     /**reinvest() - dividends reinvestment function.
168      * Checking whether there are enough DSG tokens on balance - checkDSG(amountTokens)
169      * Dividends upon the Pool Dividends and Gaming Dividends program are being paid - payDividends(msg.sender)
170      * address amountEthereum - The amount of ETH sent for reinvestment (dividends)
171      * require - Checking whether the investor has a given amount of ETH in the contract
172      */
173     function sell(uint256 amountTokens) payDividends(msg.sender) checkDSG(amountTokens) public
174     {
175         uint256 ethereum = amountTokens.mul(tokenPrice).div(10 ** uint(decimals));/* Counting the number of ETH (1000 DSG = 1ETH) */
176         account[msg.sender].ethereumBalance = account[msg.sender].ethereumBalance.add(ethereum);
177         _burn(msg.sender, amountTokens);/* Tokens are burnt */
178         emit Sell(msg.sender, amountTokens, ethereum, totalSupply, now);
179     }
180     /**withdraw() - the function of ETH withdrawal from the contract
181      * Dividends upon the Pool Dividends and Gaming Dividends programs are being paid - payDividends(msg.sender)
182      * Checking whether the investor has a given amount of ETH in the contract - checkETH(amountEthereum)
183      * address amountEthereum - The amount of ETH requested for withdrawal
184      */
185     function withdraw(uint256 amountEthereum) payDividends(msg.sender) checkETH(amountEthereum) public
186     {
187         msg.sender.transfer(amountEthereum); /* ETH is sent */
188         account[msg.sender].ethereumBalance = account[msg.sender].ethereumBalance.sub(amountEthereum);/* Decreasing the amount of ETH from the investor */
189         emit Withdraw(msg.sender, amountEthereum, now);
190     }
191     /**gamingDividendsReception() - function that receives and distributes dividends upon the "Gaming Dividends" program
192      * require - if the address of the game is not registered in mapping games, the transaction will be declined
193      */
194     function gamingDividendsReception() payable external{
195         require(getGame(msg.sender) == true, "Game not active");
196         uint256 eth            = msg.value;
197         uint256 forDevelopment = eth.mul(19).div(100); /* To support the project - 19% */
198         uint256 forInvesotrs   = eth.mul(80).div(100); /* To all DSG holders - 80% */
199         uint256 forCharity     = eth.div(100); /* For charity - 1% */
200         _setProjectDividends(forDevelopment, forCharity); /* Dividends for supporting the projects are distributed */
201         _setGamingDividends(forInvesotrs); /* Gaming dividends are distributed */
202     }
203     /**_distribution() - function of dividends distribution upon the "Referrer Dividends" program
204      * With a mimimum purchase ranging from 100 to 9999 DSG
205      * Only the first level of the referral program is open and a floating percentage is offered, which depends on the amount of investment.
206      * Formula - ETH * DSG / 10000 = %
207      * ETH   - the amount of Ethereum, which the investor should have received  if the balance had been >= 10000 DSG (6%)
208      * DSG   - the amount of tokens on the referrer's balance, which accrues interest
209      * 10000 - minimum amount of tokens when all the percentage levels are open
210      * - The first level is a floating percentage depending on the amount of holding
211      * - The second level - for all upon the "Pool dividends" program
212      * - The third level - for all upon the "Pool dividends" program
213      * - The fourth level - for all upon the "Pool dividends" program
214      * - The fifth level - for all upon the "Pool dividends" program
215      * With 10000 DSG on balance and more the entire referral system will be activated and the investor will receive all interest from all levels
216      * The function automatically checks the investor's DSG balance at the time of dividends distribution, this that referral
217      * program can be fully activated or deactivated automatically depending on the DSG balance at the time of distribution
218      * address senderAddress - the address of referral that sends dividends to his referrer
219      * uint256 eth - the amount of ETH which referrer should send to the referrer
220      * uint8 k - the number of referrer
221      */
222     function _distribution(address senderAddress, uint256 eth, uint8 k) private{
223         address referrer = account[senderAddress].referrer[k];
224         uint256 referrerBalance = account[referrer].tokenBalance;
225         uint256 senderTokenBalance = account[senderAddress].tokenBalance;
226         uint256 minReferrerBalance = 10000e18;
227         if(referrerBalance >= minReferrerBalance){
228             _setReferrerDividends(referrer, eth);/* The interest is sent to the referrer */
229         }
230         else if(k == 0 && referrerBalance < minReferrerBalance && referrer != address(0)){
231             uint256 forReferrer = eth.mul(referrerBalance).div(minReferrerBalance);/* The floating percentage is counted */
232             uint256 forPool = eth.sub(forReferrer);/* Amount for Pool Dividends (all DSG holders) */
233             _setReferrerDividends(referrer, forReferrer);/* The referrer is sent his interest */
234             _setPoolDividends(forPool, senderTokenBalance);/* Dividends are paid to all the DSG token holders */
235         }
236         else{
237             _setPoolDividends(eth, senderTokenBalance);/* If the refferal is 0x - Dividends are paid to all the DSG token holders */
238         }
239     }
240     /* _setReferrerDividends() - the function which sends referrer his dividends */
241     function _setReferrerDividends(address referrer, uint256 eth) private {
242         account[referrer].ethereumBalance = account[referrer].ethereumBalance.add(eth);
243         account[referrer].totalDividendsReferrer = account[referrer].totalDividendsReferrer.add(eth);
244         totalDividends.referrer = totalDividends.referrer.add(eth);
245     }
246     /**_setReferrer() - the function which assigns referrers to the buyer
247      * address referrerAddress - the address of referrer who invited the investor to the project
248      * address senderAddress - the buyer's address
249      * The function assigns referrers only once when buying tokens
250      * Referrers can not be changed
251      * require(referrerAddress != senderAddress) - Checks whether the buyer is not a referrer himself
252      * require(account[referrerAddress].active == true || referrerAddress == address(0))
253      * Checks whether the referrer exists in the project
254      */
255     function _setReferrer(address referrerAddress, address senderAddress) private
256     {
257         if(account[senderAddress].active == false){
258             require(referrerAddress != senderAddress, "You can't be referrer for yourself");
259             require(account[referrerAddress].active == true || referrerAddress == address(0), "Your referrer was not found in the contract");
260             account[senderAddress].referrer = [
261                                                referrerAddress, /* The referrer who invited the investor */
262                                                account[referrerAddress].referrer[0],
263                                                account[referrerAddress].referrer[1],
264                                                account[referrerAddress].referrer[2],
265                                                account[referrerAddress].referrer[3]
266                                               ];
267             account[senderAddress].active   = true; /* The account is activated */
268             emit Referrer(
269                 senderAddress,
270                 account[senderAddress].referrer[0],
271                 account[senderAddress].referrer[1],
272                 account[senderAddress].referrer[2],
273                 account[senderAddress].referrer[3],
274                 account[senderAddress].referrer[4],
275                 now
276             );
277         }
278     }
279     /**setRef_setProjectDividendserrer() - the function of dividends payment to support the project
280      * uint256 forDevelopment - To support the project - 18%
281      * uint256 forCharity - For charity - 1%
282      */
283     function _setProjectDividends(uint256 forDevelopment, uint256 forCharity) private{
284         developmentBalance = developmentBalance.add(forDevelopment);
285         charityBalance = charityBalance.add(forCharity);
286     }
287     /**_setPoolDividends() - the function of uniform distribution of dividends to all DSG holders upon the "Pool Dividends" program
288      * During the distribution of dividends, the amount of tokens that are on the buyer's balance is not taken into account,
289      * since he does not participate in the distribution of dividends
290      * uint256 amountEthereum - the amount of ETH which should be distributed to all DSG holders
291      * uint256 userTokens - the amount of DSG that is on the buyer's balance
292      */
293     function _setPoolDividends(uint256 amountEthereum, uint256 userTokens) private{
294         if(amountEthereum > 0){
295 		    divPerTokenPool = divPerTokenPool.add(amountEthereum.mul(10 ** uint(decimals)).div(totalSupply.sub(userTokens)));
296 		    totalDividends.pool = totalDividends.pool.add(amountEthereum);
297         }
298     }
299     /**_setGamingDividends() - the function of uniform distribution of dividends to all DSG holders upon the "Gaming Dividends" program
300      * uint256 amountEthereum - the amount of ETH which should be distributed to all DSG holders
301      */
302     function _setGamingDividends(uint256 amountEthereum) private{
303         if(amountEthereum > 0){
304 		    divPerTokenGaming = divPerTokenGaming.add(amountEthereum.mul(10 ** uint(decimals)).div(totalSupply));
305 		    totalDividends.gaming = totalDividends.gaming.add(amountEthereum);
306         }
307     }
308     /**setGame() - the function of adding a new address of the game contract, from which you can receive dividends
309      * address gameAddress - the address of the game contract
310      * bool active - if TRUE, the dividends can be received
311      */
312     function setGame(address gameAddress, bool active) public onlyOwners returns(bool){
313         games[gameAddress] = active;
314         return true;
315     }
316     /**getPoolDividends() - the function of calculating dividends for the investor upon the "Pool Dividends" program
317      * returns(uint256) - the amount of ETH that was counted to the investor is returned
318      * and which has not been paid to him yet
319      */
320     function getPoolDividends() public view returns(uint256)
321     {
322         uint newDividendsPerToken = divPerTokenPool.sub(account[msg.sender].lastDivPerTokenPool);
323         return account[msg.sender].tokenBalance.mul(newDividendsPerToken).div(10 ** uint(decimals));
324     }
325     /**getGameDividends() - the function of calculating dividends for the investor upon the "Gaming Dividends" program
326      * returns(uint256) - the amount of ETH that was counted to the investor is returned,
327      * and which has not been paid to him yet
328      */
329     function getGamingDividends() public view returns(uint256)
330     {
331         uint newDividendsPerToken = divPerTokenGaming.sub(account[msg.sender].lastDivPerTokenGaming);
332         return account[msg.sender].tokenBalance.mul(newDividendsPerToken).div(10 ** uint(decimals));
333     }
334     /* getAccountData() - the function that returns all the data of the investor */
335     function getAccountData() public view returns(
336         uint256 tokenBalance,
337         uint256 ethereumBalance, 
338         uint256 lastDivPerTokenPool,
339         uint256 lastDivPerTokenGaming,
340         uint256 totalDividendsPool,
341         uint256 totalDividendsReferrer,
342         uint256 totalDividendsGaming,
343         address[5] memory referrer,
344         bool active)
345     {
346         return(
347             account[msg.sender].tokenBalance,
348             account[msg.sender].ethereumBalance,
349             account[msg.sender].lastDivPerTokenPool,
350             account[msg.sender].lastDivPerTokenGaming,
351             account[msg.sender].totalDividendsPool,
352             account[msg.sender].totalDividendsReferrer,
353             account[msg.sender].totalDividendsGaming,
354             account[msg.sender].referrer,
355             account[msg.sender].active
356         );
357     }
358     /* getContractBalance() - the function that returns a contract balance */
359     function getContractBalance() view public returns (uint256) {
360         return address(this).balance;
361     }
362     /* getGame() - the function that checks whether the game is active or not. If TRUE - the game is active. If FALSE - the game is not active */
363     function getGame(address gameAddress) view public returns (bool) {
364         return games[gameAddress];
365     }
366     /* transferOwnership() - the function that assigns the future founder of the contract */
367     function transferOwnership(address candidate, uint8 k) check0x(candidate) onlyOwners public
368     {
369         candidates[k] = candidate;
370     }
371     /* confirmOwner() - the function that confirms the new founder of the contract and assigns him */
372     function confirmOwner(uint8 k) public
373     {
374         require(msg.sender == candidates[k], "You are not candidate");
375         owners[k] = candidates[k];
376         delete candidates[k];
377     }
378     /* charitytWithdraw() - the function of withdrawal for charity */
379     function charitytWithdraw(address recipient) onlyOwners check0x(recipient) public
380     {
381         recipient.transfer(charityBalance);
382         delete charityBalance;
383     }
384     /* developmentWithdraw() - the function of withdrawal for the project support */
385     function developmentWithdraw(address recipient) onlyOwners check0x(recipient) public
386     {
387         recipient.transfer(developmentBalance);
388         delete developmentBalance;
389     }
390     /* balanceOf() - the function that returns the amount of DSG tokens on balance (ERC20 standart) */
391     function balanceOf(address owner) public view returns(uint256)
392     {
393         return account[owner].tokenBalance;
394     }
395     /* allowance() - the function that checks how much spender can spend tokens of the owner user (ERC20 standart) */
396     function allowance(address owner, address spender) public view returns(uint256)
397     {
398         return allowed[owner][spender];
399     }
400     /* transferTo() - the function sends DSG tokens to another user (ERC20 standart) */
401     function transfer(address to, uint256 value) public returns(bool)
402     {
403         _transfer(msg.sender, to, value);
404         return true;
405     }
406     /* transferTo() - the function that allows the user to spend n-number of tokens for spender (ERC20 standart) */
407     function approve(address spender, uint256 value) check0x(spender) checkDSG(value) public returns(bool)
408     {
409         allowed[msg.sender][spender] = value;
410         emit Approval(msg.sender, spender, value);
411         return true;
412     }
413     /* transferFrom() - the function sends tokens from one address to another, only to the address that gave the permission (ERC20 standart) */
414     function transferFrom(address from, address to, uint256 value) public returns(bool)
415     {
416         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
417         _transfer(from, to, value);
418         emit Approval(from, msg.sender, allowed[from][msg.sender]);
419         return true;
420     }
421     /* _transfer() - the function of tokens sending  (ERC20 standart) */
422     function _transfer(address from, address to, uint256 value) payDividends(from) payDividends(to) checkDSG(value) check0x(to) private
423     {
424         account[from].tokenBalance = account[from].tokenBalance.sub(value);
425         account[to].tokenBalance = account[to].tokenBalance.add(value);
426         if(account[to].active == false) account[to].active = true;
427         emit Transfer(from, to, value);
428     }
429     /* transferFrom() - the function of tokens creating (ERC20 standart) */
430     function _mint(address customerAddress, uint256 value) check0x(customerAddress) private
431     {
432         totalSupply = totalSupply.add(value);
433         account[customerAddress].tokenBalance = account[customerAddress].tokenBalance.add(value);
434         emit Transfer(address(0), customerAddress, value);
435     }
436     /* transferFrom() - the function of tokens _burning (ERC20 standart) */
437     function _burn(address customerAddress, uint256 value) check0x(customerAddress) private
438     {
439         totalSupply = totalSupply.sub(value);
440         account[customerAddress].tokenBalance = account[customerAddress].tokenBalance.sub(value);
441         emit Transfer(customerAddress, address(0), value);
442     }
443     event Buy(
444         address indexed customerAddress,
445         uint256 inputEthereum,
446         uint256 outputToken,
447         uint256 totalSupply,
448         uint256 timestamp
449     );
450     event Sell(
451         address indexed customerAddress,
452         uint256 amountTokens,
453         uint256 outputEthereum,
454         uint256 totalSupply,
455         uint256 timestamp
456     );
457     event Reinvest(
458         address indexed customerAddress,
459         uint256 amountEthereum,
460         uint256 outputToken,
461         uint256 totalSupply,
462         uint256 timestamp
463     );
464     event Withdraw(
465         address indexed customerAddress,
466         uint256 indexed amountEthereum,
467         uint256 timestamp
468     );
469     event Referrer(
470         address indexed customerAddress,
471         address indexed referrer1,
472         address referrer2,
473         address referrer3,
474         address referrer4,
475         address referrer5,
476         uint256 timestamp
477     );
478     event Transfer(
479         address indexed from,
480         address indexed to,
481         uint tokens
482     );
483     event Approval(
484         address indexed tokenOwner,
485         address indexed spender,
486         uint tokens
487     );
488 }
489 library SafeMath {
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         if (a == 0) {  return 0; }
492         uint256 c = a * b;
493         require(c / a == b, "Mul error");
494         return c;
495     }
496     function div(uint256 a, uint256 b) internal pure returns (uint256) {
497         require(b > 0, "Div error");
498         uint256 c = a / b;
499         return c;
500     }
501     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
502         require(b <= a, "Sub error");
503         uint256 c = a - b;
504         return c;
505     }
506     function add(uint256 a, uint256 b) internal pure returns (uint256) {
507         uint256 c = a + b;
508         require(c >= a, "Add error");
509         return c;
510     }
511     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
512         require(b != 0, "Mod error");
513         return a % b;
514     }
515 }