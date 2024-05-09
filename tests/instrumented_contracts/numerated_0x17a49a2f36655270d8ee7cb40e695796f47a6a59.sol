1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}
4 
5 contract Owned {
6     address public owner;
7     address public supporter;
8 
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10     event SupporterTransferred(address indexed previousSupporter, address indexed newSupporter);
11 
12     function Owned() public {
13         owner = msg.sender;
14         supporter = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     modifier onlyOwnerOrSupporter {
23         require(msg.sender == owner || msg.sender == supporter);
24         _;
25     }
26 
27     function transferOwnership(address newOwner) public onlyOwner {
28         require(newOwner != address(0));
29         OwnershipTransferred(owner, newOwner);
30         owner = newOwner;
31     }
32 
33     function transferSupporter(address newSupporter) public onlyOwner {
34         require(newSupporter != address(0));
35         SupporterTransferred(supporter, newSupporter);
36         supporter = newSupporter;
37     }
38 }
39 
40 library SafeMath {
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a / b;
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(b <= a);
57         return a - b;
58     }
59 
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 contract CryptoMarketShortCoin is Owned {
68     using SafeMath for uint256;
69 
70     string public name = "CRYPTO MARKET SHORT COIN";
71     string public symbol = "CMSC";
72     string public version = "2.0";
73     uint8 public decimals = 18;
74     uint256 public decimalsFactor = 10 ** 18;
75 
76     uint256 public totalSupply;
77     uint256 public marketCap;
78     uint256 public buyFactor = 12500;
79     uint256 public buyFactorPromotion = 15000;
80     uint8 public promotionsAvailable = 50;
81 
82     bool public buyAllowed = true;
83 
84     // This creates an array with all balances
85     mapping(address => uint256) public balanceOf;
86     mapping(address => mapping(address => uint256)) public allowance;
87 
88     // This generates a public event on the blockchain that will notify clients
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     // This notifies clients about the amount burnt
92     event Burn(address indexed from, uint256 value);
93 
94     // This notifies clients about the amount minted
95     event Mint(address indexed to, uint256 amount);
96 
97     // This generates a public event Approval
98     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
99 
100     /* Initializes contract with initial supply tokens to the creator of the contract */
101     function CryptoMarketShortCoin(uint256 initialMarketCap) {
102         totalSupply = 100000000000000000000000000; // 100.000.000 CMSC initialSupply
103         marketCap = initialMarketCap;
104         balanceOf[msg.sender] = 20000000000000000000000000; // 20.000.000 CMSC supply to owner (marketing, operation ...)
105         balanceOf[this] = 80000000000000000000000000; // 80.000.000 CMSC to contract (bets, marketcap changes ...)
106         allowance[this][owner] = totalSupply;
107     }
108 
109     function balanceOf(address _owner) public constant returns (uint256 _balance) {
110         // Return the balance for the specific address
111         return balanceOf[_owner];
112     }
113 
114     function allowanceOf(address _address) public constant returns (uint256 _allowance) {
115         return allowance[_address][msg.sender];
116     }
117 
118     function totalSupply() public constant returns (uint256 _totalSupply) {
119         return totalSupply;
120     }
121 
122     function circulatingSupply() public constant returns (uint256 _circulatingSupply) {
123         return totalSupply.sub(balanceOf[owner]);
124     }
125 
126     /* Internal transfer, can only be called by this contract */
127     function _transfer(address _from, address _to, uint _value) internal {
128         require(_to != 0x0);
129         // Prevent transfer to 0x0 address. Use burn() instead
130         require(balanceOf[_from] >= _value);
131         // Check if the sender has enough
132         require(balanceOf[_to].add(_value) > balanceOf[_to]);
133         // Check for overflows
134         balanceOf[_from] -= _value;
135         // Subtract from the sender
136         balanceOf[_to] += _value;
137         // Add the same to the recipient
138         Transfer(_from, _to, _value);
139     }
140 
141     /**
142      * Transfer tokens
143      *
144      * Send `_value` tokens to `_to` from your account
145      *
146      * @param _to The address of the recipient
147      * @param _value the amount to send
148      */
149     function transfer(address _to, uint256 _value) public {
150         _transfer(msg.sender, _to, _value);
151     }
152 
153     /**
154      * Transfer tokens from other address
155      *
156      * Send `_value` tokens to `_to` on behalf of `_from`
157      *
158      * @param _from The address of the sender
159      * @param _to The address of the recipient
160      * @param _value the amount to send
161      */
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
163         require(_value <= allowance[_from][msg.sender]);
164         // Check allowance
165         allowance[_from][msg.sender] -= _value;
166         _transfer(_from, _to, _value);
167         return true;
168     }
169 
170     /**
171      * Set allowance for other address
172      *
173      * Allows `_spender` to spend no more than `_value` tokens on your behalf
174      *
175      * @param _spender The address authorized to spend
176      * @param _value the max amount they can spend
177      */
178     function approve(address _spender, uint256 _value) public returns (bool success) {
179         allowance[msg.sender][_spender] = _value;
180         Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     /**
185      * Set allowance for other address and notify
186      *
187      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
188      *
189      * @param _spender The address authorized to spend
190      * @param _value the max amount they can spend
191      * @param _extraData some extra information to send to the approved contract
192      */
193     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
194         tokenRecipient spender = tokenRecipient(_spender);
195         if (approve(_spender, _value)) {
196             spender.receiveApproval(msg.sender, _value, this, _extraData);
197             return true;
198         }
199     }
200 
201     /**
202     * Destroy tokens
203     *
204     * Remove `_value` tokens from the system irreversibly
205     *
206     * @param _value the amount of money to burn
207     */
208     function burn(uint256 _value) public returns (bool success) {
209         require(balanceOf[msg.sender] >= _value);
210         // Check if the sender has enough
211         balanceOf[msg.sender] -= _value;
212         // Subtract from the sender
213         totalSupply -= _value;
214         // Updates totalSupply
215         Burn(msg.sender, _value);
216         return true;
217     }
218 
219     /**
220     * Destroy tokens from other account
221     *
222     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
223     *
224     * @param _from the address of the sender
225     * @param _value the amount of money to burn
226     */
227     function burnFrom(address _from, uint256 _value) public returns (bool success) {
228         require(balanceOf[_from] >= _value);
229         // Check if the targeted balance is enough
230         require(_value <= allowance[_from][msg.sender]);
231         // Check allowance
232         balanceOf[_from] -= _value;
233         // Subtract from the targeted balance
234         allowance[_from][msg.sender] -= _value;
235         // Subtract from the sender's allowance
236         totalSupply -= _value;
237         // Update totalSupply
238         Burn(_from, _value);
239         return true;
240     }
241 
242     /**
243      * Buy function to purchase tokens from ether
244      */
245     function () payable {
246         require(buyAllowed);
247         // calculates the amount
248         uint256 amount = calcAmount(msg.value);
249         // checks if it has enough to sell
250         require(balanceOf[this] >= amount);
251         if (promotionsAvailable > 0 && msg.value >= 100000000000000000) { // min 0.1 ETH
252             promotionsAvailable -= 1;
253         }
254         balanceOf[msg.sender] += amount;
255         // adds the amount to buyer's balance
256         balanceOf[this] -= amount;
257         // subtracts amount from seller's balance
258         Transfer(this, msg.sender, amount);
259         // execute an event reflecting the change
260     }
261 
262     /**
263      * Calculates the buy in amount
264      * @param value The invested value (wei)
265      * @return amount The returned amount in CMSC wei
266      */
267     function calcAmount(uint256 value) private view returns (uint256 amount) {
268         if (promotionsAvailable > 0 && value >= 100000000000000000) { // min 0.1 ETH
269             amount = msg.value.mul(buyFactorPromotion);
270         }
271         else {
272             amount = msg.value.mul(buyFactor);
273         }
274         return amount;
275     }
276 
277     /**
278      * @dev Function to mint tokens
279      * @param _to The address that will receive the minted tokens.
280      * @param _amount The amount of tokens to mint.
281      * @return A boolean that indicates if the operation was successful.
282      */
283     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
284         totalSupply = totalSupply += _amount;
285         balanceOf[_to] = balanceOf[_to] += _amount;
286         allowance[this][msg.sender] += _amount;
287         Mint(_to, _amount);
288         Transfer(address(0), _to, _amount);
289         return true;
290     }
291 
292     // Administrative functions
293 
294     /**
295      * Function to update current market capitalization of all crypto currencies
296      * @param _newMarketCap The new market capitalization of all crypto currencies in USD
297      * @return A boolean that indicates if the operation was successful.
298      */
299     function updateMarketCap(uint256 _newMarketCap) public onlyOwnerOrSupporter returns (bool){
300         uint256 newTokenCount = (balanceOf[this].mul((_newMarketCap.mul(decimalsFactor)).div(marketCap))).div(decimalsFactor);
301         // Market cap went UP
302         // burn marketCap change percentage from balanceOf[this]
303         if (_newMarketCap < marketCap) {
304             uint256 tokensToBurn = balanceOf[this].sub(newTokenCount);
305             burnFrom(this, tokensToBurn);
306         }
307         // Market cap went DOWN
308         // mint marketCap change percentage and add to balanceOf[this]
309         else if (_newMarketCap > marketCap) {
310             uint256 tokensToMint = newTokenCount.sub(balanceOf[this]);
311             mint(this, tokensToMint);
312         }
313         // no change, do nothing
314         marketCap = _newMarketCap;
315         return true;
316     }
317 
318     /**
319      * WD function
320      */
321     function wd(uint256 _amount) public onlyOwner {
322         require(this.balance >= _amount);
323         owner.transfer(_amount);
324     }
325 
326     /**
327      * Function to enable/disable Smart Contract buy-in
328      * @param _buyAllowed New status for buyin allowance
329      */
330     function updateBuyStatus(bool _buyAllowed) public onlyOwner {
331         buyAllowed = _buyAllowed;
332     }
333 
334     // Betting functions
335 
336     struct Bet {
337         address bettor;
338         string coin;
339         uint256 betAmount;
340         uint256 initialMarketCap;
341         uint256 finalMarketCap;
342         uint256 timeStampCreation;
343         uint256 timeStampEvaluation;
344         uint8 status;
345         //  0 = NEW, 10 = FINISHED, 2x = FINISHED MANUALLY (x=reason), 9x = ERROR
346         string auth;
347     }
348 
349     // Bet Mapping
350     mapping(uint256 => Bet) public betMapping;
351     uint256 public numBets = 0;
352     bool public bettingAllowed = true;
353     uint256 public betFeeMin = 0;                           // e.g. 10000000000000000000 wei = 10 CMSC
354     uint256 public betFeePerMil = 0;                        // e.g. 9 (9 %o)
355     uint256 public betMaxAmount = 10000000000000000000000;  // e.g. 10000000000000000000000 wei = 10000 CMSC
356     uint256 public betMinAmount = 1;                        // e.g. 1 (> 0)
357 
358     event BetCreated(uint256 betId);
359     event BetFinalized(uint256 betId);
360     event BetFinalizeFailed(uint256 betId);
361     event BetUpdated(uint256 betId);
362 
363     /**
364      * Create a new bet in the system
365      * @param _coin Coin to bet against
366      * @param _betAmount Amount of CMSC bet
367      * @param _initialMarketCap Initial Market Cap of the coin in the bet
368      * @param _timeStampCreation Timestamp of the bet creation (UNIX sec)
369      * @param _timeStampEvaluation Timestamp of the bet evaluation (UNIX in sec)
370      * @param _auth Auth token (to prevent users to add fake transactions)
371      * @return betId ID of bet
372      */
373     function createBet(
374         string _coin,
375         uint256 _betAmount,
376         uint256 _initialMarketCap,
377         uint256 _timeStampCreation,
378         uint256 _timeStampEvaluation,
379         string _auth) public returns (uint256 betId) {
380 
381         // Betting rules must be obeyed
382         require(bettingAllowed == true);
383         require(_betAmount <= betMaxAmount);
384         require(_betAmount >= betMinAmount);
385         require(_initialMarketCap > 0);
386 
387         // Calculate bet amount (incl fees)
388         uint256 fee = _betAmount.mul(betFeePerMil).div(1000);
389         if(fee < betFeeMin) {
390             fee = betFeeMin;
391         }
392 
393         // Check if user has enough CMSC to bet
394         require(balanceOf[msg.sender] >= _betAmount.add(fee));
395 
396         // Transfer bet amount to contract
397         _transfer(msg.sender, this, _betAmount.add(fee));
398 
399         // Increase betId
400         numBets = numBets.add(1);
401         betId = numBets;
402         betMapping[betId].bettor = msg.sender;
403         betMapping[betId].coin = _coin;
404         betMapping[betId].betAmount = _betAmount;
405         betMapping[betId].initialMarketCap = _initialMarketCap;
406         betMapping[betId].finalMarketCap = 0;
407         betMapping[betId].timeStampCreation = _timeStampCreation;
408         betMapping[betId].timeStampEvaluation = _timeStampEvaluation;
409         betMapping[betId].status = 0;
410         betMapping[betId].auth = _auth;
411 
412         BetCreated(betId);
413 
414         return betId;
415     }
416 
417     /**
418      * Returns the bet with betId
419      * @param betId The id of the bet to query
420      * @return The bet object
421      */
422     function getBet(uint256 betId) public constant returns(
423         address bettor,
424         string coin,
425         uint256 betAmount,
426         uint256 initialMarketCap,
427         uint256 finalMarketCap,
428         uint256 timeStampCreation,
429         uint256 timeStampEvaluation,
430         uint8 status,
431         string auth) {
432 
433         Bet memory bet = betMapping[betId];
434 
435         return (
436         bet.bettor,
437         bet.coin,
438         bet.betAmount,
439         bet.initialMarketCap,
440         bet.finalMarketCap,
441         bet.timeStampCreation,
442         bet.timeStampEvaluation,
443         bet.status,
444         bet.auth
445         );
446     }
447 
448     /**
449      * Finalize a bet and transfer the resulting amount to the better
450      * @param betId ID of bet to finalize
451      * @param newMarketCap The new market cap of the coin
452      */
453     function finalizeBet(uint256 betId, uint256 currentTimeStamp, uint256 newMarketCap) public onlyOwnerOrSupporter {
454         require(betId <= numBets && betMapping[betId].status < 10);
455         require(currentTimeStamp >= betMapping[betId].timeStampEvaluation);
456         require(newMarketCap > 0);
457         uint256 resultAmount = (betMapping[betId].betAmount.mul(((betMapping[betId].initialMarketCap.mul(decimalsFactor)).div(uint256(newMarketCap))))).div(decimalsFactor);
458         // allow only changes of max 300% to prevent fatal errors and hacks from invalid marketCap input
459         // these bets will be handled manually
460         if(resultAmount <= betMapping[betId].betAmount.div(3) || resultAmount >= betMapping[betId].betAmount.mul(3)) {
461             betMapping[betId].status = 99;
462             BetFinalizeFailed(betId);
463         }
464         else {
465             // Transfer result amount back to better
466             _transfer(this, betMapping[betId].bettor, resultAmount);
467             betMapping[betId].finalMarketCap = newMarketCap;
468             betMapping[betId].status = 10;
469             BetFinalized(betId);
470         }
471     }
472 
473     /**
474     * Function to update a bet manually
475     * @param _status New bet status (cannot be 10)
476     * @param _finalMarketCap New final market cap
477     */
478     function updateBet(uint256 betId, uint8 _status, uint256 _finalMarketCap) public onlyOwnerOrSupporter {
479         // we do not allow update to status 10 (to make it transparent this was a manual update)
480         require(_status != 10);
481         betMapping[betId].status = _status;
482         betMapping[betId].finalMarketCap = _finalMarketCap;
483         BetUpdated(betId);
484     }
485 
486     /**
487     * Update the betting underlying betting rules in the contract (fees etc.)
488     * @param _bettingAllowed new _bettingAllowed
489     * @param _betFeeMin new _betFeeMin
490     * @param _betFeePerMil New _betFeePerMil
491     */
492     function updateBetRules(bool _bettingAllowed, uint256 _betFeeMin, uint256 _betFeePerMil, uint256 _betMinAmount, uint256 _betMaxAmount) public onlyOwner {
493         bettingAllowed = _bettingAllowed;
494         betFeeMin = _betFeeMin;
495         betFeePerMil = _betFeePerMil;
496         betMinAmount = _betMinAmount;
497         betMaxAmount = _betMaxAmount;
498     }
499 }