1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract SuperOwners {
35 
36     address public owner1;
37     address public pendingOwner1;
38     
39     address public owner2;
40     address public pendingOwner2;
41 
42     function SuperOwners(address _owner1, address _owner2) internal {
43         require(_owner1 != address(0));
44         owner1 = _owner1;
45         
46         require(_owner2 != address(0));
47         owner2 = _owner2;
48     }
49 
50     modifier onlySuperOwner1() {
51         require(msg.sender == owner1);
52         _;
53     }
54     
55     modifier onlySuperOwner2() {
56         require(msg.sender == owner2);
57         _;
58     }
59     
60     /** Any of the owners can execute this. */
61     modifier onlySuperOwner() {
62         require(isSuperOwner(msg.sender));
63         _;
64     }
65     
66     /** Is msg.sender any of the owners. */
67     function isSuperOwner(address _addr) public view returns (bool) {
68         return _addr == owner1 || _addr == owner2;
69     }
70 
71     /** 
72      * Safe transfer of ownership in 2 steps. Once called, a newOwner needs 
73      * to call claimOwnership() to prove ownership.
74      */
75     function transferOwnership1(address _newOwner1) onlySuperOwner1 public {
76         pendingOwner1 = _newOwner1;
77     }
78     
79     function transferOwnership2(address _newOwner2) onlySuperOwner2 public {
80         pendingOwner2 = _newOwner2;
81     }
82 
83     function claimOwnership1() public {
84         require(msg.sender == pendingOwner1);
85         owner1 = pendingOwner1;
86         pendingOwner1 = address(0);
87     }
88     
89     function claimOwnership2() public {
90         require(msg.sender == pendingOwner2);
91         owner2 = pendingOwner2;
92         pendingOwner2 = address(0);
93     }
94 }
95 
96 contract MultiOwnable is SuperOwners {
97 
98     mapping (address => bool) public ownerMap;
99     address[] public ownerHistory;
100 
101     event OwnerAddedEvent(address indexed _newOwner);
102     event OwnerRemovedEvent(address indexed _oldOwner);
103 
104     function MultiOwnable(address _owner1, address _owner2) 
105         SuperOwners(_owner1, _owner2) internal {}
106 
107     modifier onlyOwner() {
108         require(isOwner(msg.sender));
109         _;
110     }
111 
112     function isOwner(address owner) public view returns (bool) {
113         return isSuperOwner(owner) || ownerMap[owner];
114     }
115     
116     function ownerHistoryCount() public view returns (uint) {
117         return ownerHistory.length;
118     }
119 
120     // Add extra owner
121     function addOwner(address owner) onlySuperOwner public {
122         require(owner != address(0));
123         require(!ownerMap[owner]);
124         ownerMap[owner] = true;
125         ownerHistory.push(owner);
126         OwnerAddedEvent(owner);
127     }
128 
129     // Remove extra owner
130     function removeOwner(address owner) onlySuperOwner public {
131         require(ownerMap[owner]);
132         ownerMap[owner] = false;
133         OwnerRemovedEvent(owner);
134     }
135 }
136 
137 contract Pausable is MultiOwnable {
138 
139     bool public paused;
140 
141     modifier ifNotPaused {
142         require(!paused);
143         _;
144     }
145 
146     modifier ifPaused {
147         require(paused);
148         _;
149     }
150 
151     // Called by the owner on emergency, triggers paused state
152     function pause() external onlySuperOwner {
153         paused = true;
154     }
155 
156     // Called by the owner on end of emergency, returns to normal state
157     function resume() external onlySuperOwner ifPaused {
158         paused = false;
159     }
160 }
161 
162 contract ERC20 {
163 
164     uint256 public totalSupply;
165 
166     function balanceOf(address _owner) public view returns (uint256 balance);
167 
168     function transfer(address _to, uint256 _value) public returns (bool success);
169 
170     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
171 
172     function approve(address _spender, uint256 _value) public returns (bool success);
173 
174     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
175 
176     event Transfer(address indexed _from, address indexed _to, uint256 _value);
177     
178     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
179 }
180 
181 contract StandardToken is ERC20 {
182     
183     using SafeMath for uint;
184 
185     mapping(address => uint256) balances;
186     
187     mapping(address => mapping(address => uint256)) allowed;
188 
189     function balanceOf(address _owner) public view returns (uint256 balance) {
190         return balances[_owner];
191     }
192 
193     function transfer(address _to, uint256 _value) public returns (bool) {
194         require(_to != address(0));
195         require(_value > 0);
196         require(_value <= balances[msg.sender]);
197         
198         balances[msg.sender] = balances[msg.sender].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200         Transfer(msg.sender, _to, _value);
201         return true;
202     }
203 
204     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
205     /// @param _from Address from where tokens are withdrawn.
206     /// @param _to Address to where tokens are sent.
207     /// @param _value Number of tokens to transfer.
208     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209         require(_to != address(0));
210         require(_value > 0);
211         require(_value <= balances[_from]);
212         require(_value <= allowed[_from][msg.sender]);
213         
214         balances[_to] = balances[_to].add(_value);
215         balances[_from] = balances[_from].sub(_value);
216         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217         Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     /// @dev Sets approved amount of tokens for spender. Returns success.
222     /// @param _spender Address of allowed account.
223     /// @param _value Number of approved tokens.
224     function approve(address _spender, uint256 _value) public returns (bool) {
225         allowed[msg.sender][_spender] = _value;
226         Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     /// @dev Returns number of allowed tokens for given address.
231     /// @param _owner Address of token owner.
232     /// @param _spender Address of token spender.
233     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
234         return allowed[_owner][_spender];
235     }
236 }
237 
238 contract CommonToken is StandardToken, MultiOwnable {
239 
240     string public name;
241     string public symbol;
242     uint256 public totalSupply;
243     uint8 public decimals = 18;
244     string public version = 'v0.1';
245 
246     address public seller;     // The main account that holds all tokens at the beginning and during tokensale.
247 
248     uint256 public saleLimit;  // (e18) How many tokens can be sold in total through all tiers or tokensales.
249     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
250     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
251 
252     // Lock the transfer functions during tokensales to prevent price speculations.
253     bool public locked = true;
254     
255     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
256     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
257     event Burn(address indexed _burner, uint256 _value);
258     event Unlock();
259 
260     function CommonToken(
261         address _owner1,
262         address _owner2,
263         address _seller,
264         string _name,
265         string _symbol,
266         uint256 _totalSupplyNoDecimals,
267         uint256 _saleLimitNoDecimals
268     ) MultiOwnable(_owner1, _owner2) public {
269 
270         require(_seller != address(0));
271         require(_totalSupplyNoDecimals > 0);
272         require(_saleLimitNoDecimals > 0);
273 
274         seller = _seller;
275         name = _name;
276         symbol = _symbol;
277         totalSupply = _totalSupplyNoDecimals * 1e18;
278         saleLimit = _saleLimitNoDecimals * 1e18;
279         balances[seller] = totalSupply;
280 
281         Transfer(0x0, seller, totalSupply);
282     }
283     
284     modifier ifUnlocked(address _from, address _to) {
285         require(!locked || isOwner(_from) || isOwner(_to));
286         _;
287     }
288     
289     /** Can be called once by super owner. */
290     function unlock() onlySuperOwner public {
291         require(locked);
292         locked = false;
293         Unlock();
294     }
295 
296     function changeSeller(address newSeller) onlySuperOwner public returns (bool) {
297         require(newSeller != address(0));
298         require(seller != newSeller);
299 
300         address oldSeller = seller;
301         uint256 unsoldTokens = balances[oldSeller];
302         balances[oldSeller] = 0;
303         balances[newSeller] = balances[newSeller].add(unsoldTokens);
304         Transfer(oldSeller, newSeller, unsoldTokens);
305 
306         seller = newSeller;
307         ChangeSellerEvent(oldSeller, newSeller);
308         
309         return true;
310     }
311 
312     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
313         return sell(_to, _value * 1e18);
314     }
315 
316     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
317 
318         // Check that we are not out of limit and still can sell tokens:
319         require(tokensSold.add(_value) <= saleLimit);
320 
321         require(_to != address(0));
322         require(_value > 0);
323         require(_value <= balances[seller]);
324 
325         balances[seller] = balances[seller].sub(_value);
326         balances[_to] = balances[_to].add(_value);
327         Transfer(seller, _to, _value);
328 
329         totalSales++;
330         tokensSold = tokensSold.add(_value);
331         SellEvent(seller, _to, _value);
332 
333         return true;
334     }
335     
336     /**
337      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
338      */
339     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender, _to) public returns (bool) {
340         return super.transfer(_to, _value);
341     }
342 
343     /**
344      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
345      */
346     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from, _to) public returns (bool) {
347         return super.transferFrom(_from, _to, _value);
348     }
349 
350     function burn(uint256 _value) public returns (bool) {
351         require(_value > 0);
352         require(_value <= balances[msg.sender]);
353 
354         balances[msg.sender] = balances[msg.sender].sub(_value) ;
355         totalSupply = totalSupply.sub(_value);
356         Transfer(msg.sender, 0x0, _value);
357         Burn(msg.sender, _value);
358 
359         return true;
360     }
361 }
362 
363 contract RaceToken is CommonToken {
364     
365     function RaceToken() CommonToken(
366         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
367         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
368         0x2821e1486D604566842FF27F626aF133FddD5f89, // __SELLER__
369         'Coin Race',
370         'RACE',
371         100 * 1e6, // 100m tokens in total.
372         70 * 1e6   // 70m tokens for sale.
373     ) public {}
374 }
375 
376 contract CommonTokensale is MultiOwnable, Pausable {
377     
378     using SafeMath for uint;
379     
380     uint public balance1;
381     uint public balance2;
382     
383     // Token contract reference.
384     RaceToken public token;
385 
386     uint public minPaymentWei = 0.001 ether;
387     uint public tokensPerWei = 15000;
388     uint public maxCapTokens = 6 * 1e6 ether; // 6m tokens
389     
390     // Stats for current tokensale:
391     
392     uint public totalTokensSold;  // Total amount of tokens sold during this tokensale.
393     uint public totalWeiReceived; // Total amount of wei received during this tokensale.
394     
395     // This will allow another contract to check whether ETH address is a buyer in this sale.
396     mapping (address => bool) public isBuyer;
397     
398     event ChangeTokenEvent(address indexed _oldAddress, address indexed _newAddress);
399     event ChangeMaxCapTokensEvent(uint _oldMaxCap, uint _newMaxCap);
400     event ChangeTokenPriceEvent(uint _oldPrice, uint _newPrice);
401     event ReceiveEthEvent(address indexed _buyer, uint256 _amountWei);
402     
403     function CommonTokensale(
404         address _owner1,
405         address _owner2
406     ) MultiOwnable(_owner1, _owner2) public {}
407     
408     function setToken(address _token) onlySuperOwner public {
409         require(_token != address(0));
410         require(_token != address(token));
411         
412         ChangeTokenEvent(token, _token);
413         token = RaceToken(_token);
414     }
415     
416     function setMaxCapTokens(uint _maxCap) onlySuperOwner public {
417         require(_maxCap > 0);
418         ChangeMaxCapTokensEvent(maxCapTokens, _maxCap);
419         maxCapTokens = _maxCap;
420     }
421     
422     function setTokenPrice(uint _tokenPrice) onlySuperOwner public {
423         require(_tokenPrice > 0);
424         ChangeTokenPriceEvent(tokensPerWei, _tokenPrice);
425         tokensPerWei = _tokenPrice;
426     }
427 
428     /** The fallback function corresponds to a donation in ETH. */
429     function() public payable {
430         sellTokensForEth(msg.sender, msg.value);
431     }
432     
433     function sellTokensForEth(
434         address _buyer, 
435         uint256 _amountWei
436     ) ifNotPaused public payable {
437         
438         require(_amountWei >= minPaymentWei);
439 
440         uint tokensE18 = weiToTokens(_amountWei);
441         require(totalTokensSold.add(tokensE18) <= maxCapTokens);
442         
443         // Transfer tokens to buyer.
444         require(token.sell(_buyer, tokensE18));
445         
446         // Update total stats:
447         totalTokensSold = totalTokensSold.add(tokensE18);
448         totalWeiReceived = totalWeiReceived.add(_amountWei);
449         isBuyer[_buyer] = true;
450         ReceiveEthEvent(_buyer, _amountWei);
451         
452         uint half = _amountWei / 2;
453         balance1 = balance1.add(half);
454         balance2 = balance2.add(_amountWei - half);
455     }
456     
457     /** Calc how much tokens you can buy at current time. */
458     function weiToTokens(uint _amountWei) public view returns (uint) {
459         return _amountWei.mul(tokensPerWei);
460     }
461 
462     function withdraw1(address _to) onlySuperOwner1 public {
463         if (balance1 > 0) _to.transfer(balance1);
464     }
465     
466     function withdraw2(address _to) onlySuperOwner2 public {
467         if (balance2 > 0) _to.transfer(balance2);
468     }
469 }
470 
471 contract Tokensale is CommonTokensale {
472     
473     function Tokensale() CommonTokensale(
474         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
475         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7  // __OWNER2__
476     ) public {}
477 }