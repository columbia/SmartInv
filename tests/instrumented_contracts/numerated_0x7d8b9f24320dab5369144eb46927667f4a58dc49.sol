1 pragma solidity ^ 0.4.18;
2 
3 /**
4  * @title Owned
5  * @dev The Owned contract has an owner address, and provides basic authorization control
6  */
7 contract Owned {
8     address public owner;
9    
10     /*Set owner of the contract*/
11     function Owned() public {
12         owner = msg.sender;
13     }
14 
15     /*only owner can be modifier*/
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 }
21 
22 /**
23  * @title Pausable
24  * @dev Base contract which allows children to implement an emergency stop mechanism.
25  */
26 contract Pausable is Owned {
27   event Pause();
28   event Unpause();
29 
30   bool public paused = false;
31 
32 
33   /**
34    * @dev Modifier to make a function callable only when the contract is not paused.
35    */
36   modifier whenNotPaused() {
37     require(!paused);
38     _;
39   }
40 
41   /**
42    * @dev Modifier to make a function callable only when the contract is paused.
43    */
44   modifier whenPaused() {
45     require(paused);
46     _;
47   }
48 
49   /**
50    * @dev called by the owner to pause, triggers stopped state
51    */
52   function pause() public onlyOwner whenNotPaused {
53     paused = true;
54     Pause();
55   }
56 
57   /**
58    * @dev called by the owner to unpause, returns to normal state
59    */
60   function unpause() public onlyOwner whenPaused {
61     paused = false;
62     Unpause();
63   }
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71     /**
72      * @dev Multiplies two numbers, throws on overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         assert(c / a == b);
80         return c;
81     }
82 
83     /**
84      * @dev Integer division of two numbers, truncating the quotient.
85      */
86     function div(uint256 a, uint256 b) internal pure returns(uint256) {
87         // assert(b > 0); // Solidity automatically throws when dividing by 0
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90         return c;
91     }
92 
93     /**
94      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95      */
96     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
97         assert(b <= a);
98         return a - b;
99     }
100 
101     /**
102      * @dev Adds two numbers, throws on overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns(uint256) {
105         uint256 c = a + b;
106         assert(c >= a);
107         return c;
108     }
109 
110 }
111 
112 /*ERC20*/
113 contract TokenERC20 is Pausable {
114     using SafeMath for uint256;
115     // Public variables of the token
116     string public name = "NRC";
117     string public symbol = "R";
118     uint8 public decimals = 0;
119     // how many token units a buyer gets per wei
120     uint256 public rate = 50000;
121     // address where funds are collected
122     address public wallet = 0xd3C8326064044c36B73043b009155a59e92477D0;
123     // contributors address
124     address public contributorsAddress = 0xa7db53CB73DBe640DbD480a928dD06f03E2aE7Bd;
125     // company address
126     address public companyAddress = 0x9c949b51f2CafC3A5efc427621295489B63D861D;
127     // market Address 
128     address public marketAddress = 0x199EcdFaC25567eb4D21C995B817230050d458d9;
129     // share of all token 
130     uint8 public constant ICO_SHARE = 20;
131     uint8 public constant CONTRIBUTORS_SHARE = 30;
132     uint8 public constant COMPANY_SHARE = 20;
133     uint8 public constant MARKET_SHARE = 30;
134     // unfronzen periods 
135     uint8 constant COMPANY_PERIODS = 10;
136     uint8 constant CONTRIBUTORS_PERIODS = 3;
137     // token totalsupply amount
138     uint256 public constant TOTAL_SUPPLY = 80000000000;
139     // ico token amount
140     uint256 public icoTotalAmount = 16000000000;
141     uint256 public companyPeriodsElapsed;
142     uint256 public contributorsPeriodsElapsed;
143     // token frozened amount
144     uint256 public frozenSupply;
145     uint256 public initDate;
146     uint8 public contributorsCurrentPeriod;
147     uint8 public companyCurrentPeriod;
148     // This creates an array with all balances
149     mapping(address => uint256) public balanceOf;
150 
151     // This generates a public event on the blockchain that will notify clients
152     event Transfer(address indexed from, address indexed to, uint256 value);
153     event InitialToken(string desc, address indexed target, uint256 value);    
154     
155     /**
156      * Constrctor function
157      * Initializes contract with initial supply tokens to the creator of the contract
158      */
159     function TokenERC20(
160     ) public {
161         // contributors share 30% of totalSupply,but get all by 3 years
162         uint256 tempContributors = TOTAL_SUPPLY.mul(CONTRIBUTORS_SHARE).div(100).div(CONTRIBUTORS_PERIODS);
163         contributorsPeriodsElapsed = tempContributors;
164         balanceOf[contributorsAddress] = tempContributors;
165         InitialToken("contributors", contributorsAddress, tempContributors);
166         
167         // company shares 20% of totalSupply,but get all by 10 years
168         uint256 tempCompany = TOTAL_SUPPLY.mul(COMPANY_SHARE).div(100).div(COMPANY_PERIODS);
169         companyPeriodsElapsed = tempCompany;
170         balanceOf[companyAddress] = tempCompany;
171         InitialToken("company", companyAddress, tempCompany);
172 
173         // ico takes 20% of totalSupply
174         uint256 tempIco = TOTAL_SUPPLY.mul(ICO_SHARE).div(100);
175         icoTotalAmount = tempIco;
176 
177         // expand the market cost 30% of totalSupply
178         uint256 tempMarket = TOTAL_SUPPLY.mul(MARKET_SHARE).div(100);
179         balanceOf[marketAddress] = tempMarket;
180         InitialToken("market", marketAddress, tempMarket);
181 
182         // frozenSupply waitting for being unfrozen
183         uint256 tempFrozenSupply = TOTAL_SUPPLY.sub(tempContributors).sub(tempIco).sub(tempCompany).sub(tempMarket);
184         frozenSupply = tempFrozenSupply;
185         initDate = block.timestamp;
186         contributorsCurrentPeriod = 1;
187         companyCurrentPeriod = 1;
188         paused = true;
189     }
190 
191     /**
192      * Internal transfer, only can be called by this contract
193      */
194     function _transfer(address _from, address _to, uint _value) internal {
195         // Prevent transfer to 0x0 address. Use burn() instead
196         require(_to != 0x0);
197         // Check if the sender has enough
198         require(balanceOf[_from] >= _value);
199         // Check for overflows
200         require(balanceOf[_to].add(_value) > balanceOf[_to]);
201         // Save this for an assertion in the future
202         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
203         // Subtract from the sender
204         balanceOf[_from] = balanceOf[_from].sub(_value);
205         // Add the same to the recipient
206         balanceOf[_to] = balanceOf[_to].add(_value);
207         Transfer(_from, _to, _value);
208         // Asserts are used to use static analysis to find bugs in your code. They should never fail
209         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
210     }
211 
212     /**
213      * Transfer tokens
214      *
215      * Send `_value` tokens to `_to` from your account
216      *
217      * @param _to The address of the recipient
218      * @param _value the amount to send
219      */
220     function transfer(address _to, uint256 _value) public {
221         _transfer(msg.sender, _to, _value);
222     }
223 }
224 /******************************************/
225 /*       NRCToken STARTS HERE       */
226 /******************************************/
227 
228 contract NRCToken is Owned, TokenERC20 {
229     uint256 private etherChangeRate = 10 ** 18;
230     uint256 private minutesOneYear = 365*24*60 minutes;
231     bool public  tokenSaleActive = true;
232     // token have been sold
233     uint256 public totalSoldToken;
234     // all frozenAccount addresses
235     mapping(address => bool) public frozenAccount;
236 
237     /* This generates a public log event on the blockchain that will notify clients */
238     event LogFrozenAccount(address target, bool frozen);
239     event LogUnfrozenTokens(string desc, address indexed targetaddress, uint256 unfrozenTokensAmount);
240     event LogSetTokenPrice(uint256 tokenPrice);
241     event TimePassBy(string desc, uint256 times );
242     /**
243      * event for token purchase logging
244      * @param purchaser who paid for the tokens
245      * @param value ehter paid for purchase
246      * @param amount amount of tokens purchased
247      */
248     event LogTokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
249     // ICO finished Event
250     event TokenSaleFinished(string desc, address indexed contributors, uint256 icoTotalAmount, uint256 totalSoldToken, uint256 leftAmount);
251     
252     /* Initializes contract with initial supply tokens to the creator of the contract */
253     function NRCToken() TokenERC20() public {}
254 
255     /* Internal transfer, only can be called by this contract */
256     function _transfer(address _from, address _to, uint _value) internal {
257         require(_from != _to);
258         require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
259         require(balanceOf[_from] >= _value); // Check if the sender has enough
260         require(balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
261         require(!frozenAccount[_from]); // Check if sender is frozen
262         require(!frozenAccount[_to]); // Check if recipient is frozen
263         balanceOf[_from] = balanceOf[_from].sub(_value); // Subtract from the sender
264         balanceOf[_to] = balanceOf[_to].add(_value); // Add the same to the recipient
265         Transfer(_from, _to, _value);
266     }
267        /**
268      * Transfer tokens
269      *
270      * Send `_value` tokens to `_to` from your account
271      *
272      * @param _to The address of the recipient
273      * @param _value the amount to send
274      */
275     function transfer(address _to, uint256 _value) public {
276         _transfer(msg.sender, _to, _value);
277     }
278 
279     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
280     /// @param target Address to be frozen
281     /// @param freeze either to freeze it or not
282     function freezeAccount(address target, bool freeze) public onlyOwner whenNotPaused {
283         require(target != 0x0);
284         require(target != owner);
285         require(frozenAccount[target] != freeze);
286         frozenAccount[target] = freeze;
287         LogFrozenAccount(target, freeze);
288     }
289 
290     /// @notice Allow users to buy tokens for `newTokenRate` eth
291     /// @param newTokenRate Price users can buy from the contract
292     function setPrices(uint256 newTokenRate) public onlyOwner whenNotPaused {
293         require(newTokenRate > 0);
294         require(newTokenRate <= icoTotalAmount);
295         require(tokenSaleActive);
296         rate = newTokenRate;
297         LogSetTokenPrice(newTokenRate);
298     }
299 
300     /// @notice Buy tokens from contract by sending ether
301     function buy() public payable whenNotPaused {
302         // if ICO finished ,can not buy any more!
303         require(!frozenAccount[msg.sender]); 
304         require(tokenSaleActive);
305         require(validPurchase());
306         uint tokens = getTokenAmount(msg.value); // calculates the amount
307         require(!validSoldOut(tokens));
308         LogTokenPurchase(msg.sender, msg.value, tokens);
309         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
310         calcTotalSoldToken(tokens);
311         forwardFunds();
312     }
313 
314     // Override this method to have a way to add business logic to your crowdsale when buying
315     function getTokenAmount(uint256 etherAmount) internal view returns(uint256) {
316         uint256 temp = etherAmount.mul(rate);
317         uint256 amount = temp.div(etherChangeRate);
318         return amount;
319     }
320 
321     // send ether to the funder wallet
322     function forwardFunds() internal {
323         wallet.transfer(msg.value);
324     }
325 
326     // calc totalSoldToken
327     function calcTotalSoldToken(uint256 soldAmount) internal {
328         totalSoldToken = totalSoldToken.add(soldAmount);
329         if (totalSoldToken >= icoTotalAmount) { 
330             tokenSaleActive = false;
331         }
332     }
333 
334     // @return true if the transaction can buy tokens
335     function validPurchase() internal view returns(bool) {
336         bool limitPurchase = msg.value >= 1 ether;
337         bool isNotTheOwner = msg.sender != owner;
338         bool isNotTheCompany = msg.sender != companyAddress;
339         bool isNotWallet = msg.sender != wallet;
340         bool isNotContributors = msg.sender != contributorsAddress;
341         bool isNotMarket = msg.sender != marketAddress;
342         return limitPurchase && isNotTheOwner && isNotTheCompany && isNotWallet && isNotContributors && isNotMarket;
343     }
344 
345     // @return true if the ICO is in progress.
346     function validSoldOut(uint256 soldAmount) internal view returns(bool) {
347         return totalSoldToken.add(soldAmount) > icoTotalAmount;
348     }
349     // @return current timestamp
350     function time() internal constant returns (uint) {
351         return block.timestamp;
352     }
353 
354     /// @dev send the rest of the tokens after the crowdsale end and
355     /// send to contributors address
356     function finaliseICO() public onlyOwner whenNotPaused {
357         require(tokenSaleActive == true);        
358         uint256 tokensLeft = icoTotalAmount.sub(totalSoldToken);
359         tokenSaleActive = false;
360         require(tokensLeft > 0);
361         balanceOf[contributorsAddress] = balanceOf[contributorsAddress].add(tokensLeft);
362         TokenSaleFinished("finaliseICO", contributorsAddress, icoTotalAmount, totalSoldToken, tokensLeft);
363         totalSoldToken = icoTotalAmount;
364     }
365 
366 
367     /// @notice freeze unfrozenAmount
368     function unfrozenTokens() public onlyOwner whenNotPaused {
369         require(frozenSupply >= 0);
370         if (contributorsCurrentPeriod < CONTRIBUTORS_PERIODS) {
371             unfrozenContributorsTokens();
372             unfrozenCompanyTokens();
373         } else {
374             unfrozenCompanyTokens();
375         }
376     }
377 
378     // unfrozen contributors token year by year
379     function unfrozenContributorsTokens() internal {
380         require(contributorsCurrentPeriod < CONTRIBUTORS_PERIODS);
381         uint256 contributortimeShouldPassBy = contributorsCurrentPeriod * (minutesOneYear);
382         TimePassBy("contributortimeShouldPassBy", contributortimeShouldPassBy);
383         uint256 contributorsTimePassBy = time() - initDate;
384         TimePassBy("contributortimePassBy", contributorsTimePassBy);
385 
386         contributorsCurrentPeriod = contributorsCurrentPeriod + 1;
387         require(contributorsTimePassBy >= contributortimeShouldPassBy);
388         frozenSupply = frozenSupply.sub(contributorsPeriodsElapsed);
389         balanceOf[contributorsAddress] = balanceOf[contributorsAddress].add(contributorsPeriodsElapsed);
390         LogUnfrozenTokens("contributors", contributorsAddress, contributorsPeriodsElapsed);
391     }
392 
393     // unfrozen company token year by year
394     function unfrozenCompanyTokens() internal {
395         require(companyCurrentPeriod < COMPANY_PERIODS);
396         uint256 companytimeShouldPassBy = companyCurrentPeriod * (minutesOneYear);
397         TimePassBy("CompanytimeShouldPassBy", companytimeShouldPassBy);
398         uint256 companytimePassBy = time() - initDate;
399         TimePassBy("CompanytimePassBy", companytimePassBy);
400 
401         require(companytimePassBy >= companytimeShouldPassBy);
402         companyCurrentPeriod = companyCurrentPeriod + 1;
403         frozenSupply = frozenSupply.sub(companyPeriodsElapsed);
404         balanceOf[companyAddress] = balanceOf[companyAddress].add(companyPeriodsElapsed);
405         LogUnfrozenTokens("company", companyAddress, companyPeriodsElapsed);
406     }
407 
408     // fallback function - do not allow any eth transfers to this contract
409     function() external {
410         revert();
411     }
412 
413 }