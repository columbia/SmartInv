1 pragma solidity ^0.4.15;
2 
3 contract Permittable {
4     mapping(address => bool) permitted;
5 
6     function Permittable() public {
7         permitted[msg.sender] = true;
8     }
9 
10     modifier onlyPermitted() {
11         require(permitted[msg.sender]);
12         _;
13     }
14 
15     function permit(address _address, bool _isAllowed) public onlyPermitted {
16         permitted[_address] = _isAllowed;
17     }
18 
19     function isPermitted(address _address) public view returns (bool) {
20         return permitted[_address];
21     }
22 }
23 
24 contract Destructable is Permittable {
25     function kill() public onlyPermitted {
26         selfdestruct(msg.sender);
27     }
28 }
29 
30 contract Withdrawable is Permittable {
31     function withdraw(address _to, uint256 _amount) public onlyPermitted {
32         require(_to != address(0));
33 
34         if (_amount == 0)
35             _amount = this.balance;
36 
37         _to.transfer(_amount);
38     }
39 }
40 
41 contract ERC20Token {
42 
43     // Topic: ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
44     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
45 
46     // Topic: 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925
47     event Approval(address indexed _owner, address indexed _recipient, uint256 _amount);
48 
49     function totalSupply() public constant returns (uint256);
50     function balanceOf(address _owner) public constant returns (uint256 balance);
51     function transfer(address _to, uint256 _amount) public returns (bool success);
52     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
53     function approve(address _recipient, uint256 _amount) public returns (bool success);
54     function allowance(address _owner, address _recipient) public constant returns (uint256 remaining);
55 }
56 
57 contract TokenStorage is Permittable, Destructable, Withdrawable {
58     struct Megabox {
59         address owner;
60         uint256 totalSupply;
61         uint256 timestamp;
62     }
63 
64     mapping(address => uint256) private balances;
65     mapping(string => uint256) private settings;
66     mapping(uint256 => Megabox) private megaboxes;
67     uint256 megaboxIndex = 0;
68 
69     function _start() public onlyPermitted {
70         //Number of decimal places
71         uint decimalPlaces = 8;
72         setSetting("decimalPlaces", decimalPlaces);
73 
74         //Tokens stored as integer values multiplied by multiplier. I.e. 1 token with 8 decimals would be stored as 100,000,000
75         setSetting("multiplier", 10 ** decimalPlaces);
76 
77         //Tokens amount to send exhausting warning
78         setSetting("exhaustingNumber", 2 * 10**decimalPlaces);
79 
80         //Token price in weis per 1
81         setSetting("tokenPrice", 15283860872157044);
82 
83         //Decimator for the percents (1000 = 100%)
84         setSetting("percentage", 1000);
85 
86         //TransferFee(10) == 1%
87         setSetting("transferFee", 10);
88 
89         //PurchaseFee(157) == 15.7%
90         setSetting("purchaseFee", 0);
91 
92         //PurchaseCap(5000) == 5000.00000000 tokens
93         setSetting("purchaseCap", 0);
94 
95         //PurchaseTimeout in seconds
96         setSetting("purchaseTimeout", 0);
97 
98         //Timestamp when ICO
99         setSetting("icoTimestamp", now);
100 
101         //RedemptionTimeout in seconds
102         setSetting("redemptionTimeout", 365 * 24 * 60 * 60);
103 
104         //RedemptionFee(157) == 15.7%
105         setSetting("redemptionFee", 0);
106 
107         // Address to return operational fees
108         setSetting("feeReturnAddress", uint(address(0x0d026A63a88A0FEc2344044e656D6B63684FBeA1)));
109 
110         // Address to collect dead tokens
111         setSetting("deadTokensAddress", uint(address(0x4DcB8F5b22557672B35Ef48F8C2b71f8F54c251F)));
112 
113         //Total supply of tokens
114         setSetting("totalSupply", 100 * 1000 * 1000 * (10 ** decimalPlaces));
115 
116         setSetting("newMegaboxThreshold", 1 * 10**decimalPlaces);
117     }
118 
119     function getBalance(address _address) public view onlyPermitted returns(uint256) {
120         return balances[_address];
121     }
122 
123     function setBalance(address _address, uint256 _amount) public onlyPermitted returns (uint256) {
124         balances[_address] = _amount;
125         return balances[_address];
126     }
127 
128     function transfer(address _from, address _to, uint256 _amount) public onlyPermitted returns (uint256) {
129         require(balances[_from] >= _amount);
130 
131         decreaseBalance(_from, _amount);
132         increaseBalance(_to, _amount);
133         return _amount;
134     }
135 
136     function decreaseBalance(address _address, uint256 _amount) public onlyPermitted returns (uint256) {
137         require(balances[_address] >= _amount);
138 
139         balances[_address] -= _amount;
140         return _amount;
141     }
142 
143     function increaseBalance(address _address, uint256 _amount) public onlyPermitted returns (uint256) {
144         balances[_address] += _amount;
145         return _amount;
146     }
147 
148     function getSetting(string _name) public view onlyPermitted returns(uint256) {
149         return settings[_name];
150     }
151 
152     function getSettingAddress(string _name) public view onlyPermitted returns(address) {
153         return address(getSetting(_name));
154     }
155 
156     function setSetting(string _name, uint256 _value) public onlyPermitted returns (uint256) {
157         settings[_name] = _value;
158         return settings[_name];
159     }
160 
161     function newMegabox(address _owner, uint256 _tokens, uint256 _timestamp) public onlyPermitted {
162         uint newMegaboxIndex = megaboxIndex++;
163         megaboxes[newMegaboxIndex] = Megabox({owner: _owner, totalSupply: _tokens, timestamp: _timestamp});
164 
165         setSetting("totalSupply", getSetting("totalSupply") + _tokens);
166 
167         uint256 balance = balances[_owner] + _tokens;
168         setBalance(_owner, balance);
169     }
170 
171     function getMegabox(uint256 index) public view onlyPermitted returns (address, uint256, uint256) {
172         return (megaboxes[index].owner, megaboxes[index].totalSupply, megaboxes[index].timestamp);
173     }
174 
175     function getMegaboxIndex() public view onlyPermitted returns (uint256) {
176         return megaboxIndex;
177     }
178 }
179 
180 contract TokenValidator is Permittable, Destructable {
181     TokenStorage store;
182     mapping(address => uint256) datesOfPurchase;
183 
184     function _setStore(address _address) public onlyPermitted {
185         store = TokenStorage(_address);
186     }
187 
188     function getTransferFee(address _owner, address _address, uint256 _amount) public view returns(uint256) {
189         return (_address == _owner) ? 0 : (_amount * store.getSetting("transferFee") / store.getSetting("percentage"));
190     }
191 
192     function validateAndGetTransferFee(address _owner, address _from, address /*_to*/, uint256 _amount) public view returns(uint256) {
193         uint256 _fee = getTransferFee(_owner, _from, _amount);
194 
195         require(_amount > 0);
196         require((_amount + _fee) > 0);
197         require(store.getBalance(_from) >= (_amount + _fee));
198 
199         return _fee;
200     }
201 
202     function validateResetDeadTokens(uint256 _amount) public view returns(address) {
203         address deadTokensAddress = store.getSettingAddress("deadTokensAddress");
204         uint256 deadTokens = store.getBalance(deadTokensAddress);
205 
206         require(_amount > 0);
207         require(_amount <= deadTokens);
208 
209         return deadTokensAddress;
210     }
211 
212     function validateStart(address _owner, address _store) public view {
213         require(_store != address(0));
214         require(_store == address(store));
215         require(store.getBalance(_owner) == 0);
216     }
217 
218     function validateAndGetPurchaseTokens(address _owner, address _address, uint256 _moneyAmount) public view returns (uint256) {
219         uint256 _tokens = _moneyAmount * store.getSetting("multiplier") / store.getSetting("tokenPrice");
220         uint256 _purchaseTimeout = store.getSetting("purchaseTimeout");
221         uint256 _purchaseCap = store.getSetting("purchaseCap");
222 
223         require((_purchaseTimeout <= 0) || (block.timestamp - datesOfPurchase[_address] > _purchaseTimeout));
224         require(_tokens > 0);
225         require(store.getBalance(_owner) >= _tokens);
226         require((_purchaseCap <= 0) || (_tokens <= _purchaseCap));
227 
228         return _tokens;
229     }
230 
231     function updateDateOfPurchase(address _address, uint256 timestamp) public onlyPermitted {
232         datesOfPurchase[_address] = timestamp;
233     }
234 
235     function validateAndGetRedeemFee(address /*_owner*/, address _address, uint256 _tokens) public view returns (uint256) {
236         uint256 _icoTimestamp = store.getSetting("icoTimestamp");
237         uint256 _redemptionTimeout = store.getSetting("redemptionTimeout");
238         uint256 _fee = _tokens * store.getSetting("redemptionFee") / store.getSetting("percentage");
239 
240         require((_redemptionTimeout <= 0) || (block.timestamp > _icoTimestamp + _redemptionTimeout));
241         require(_tokens > 0);
242         require((_tokens + _fee) >= 0);
243         require(store.getBalance(_address) >= (_tokens + _fee));
244 
245         return _fee;
246     }
247 
248     function validateStartMegabox(address _owner, uint256 _tokens) public view {
249         uint256 _totalSupply = store.getSetting("totalSupply");
250         uint256 _newMegaboxThreshold = store.getSetting("newMegaboxThreshold");
251         uint256 _ownerBalance = store.getBalance(_owner);
252 
253         require(_ownerBalance <= _newMegaboxThreshold);
254         require(_tokens > 0);
255         require((_totalSupply + _tokens) > _totalSupply);
256     }
257 
258     function canPurchase(address _owner, address _address, uint256 _tokens) public view returns(bool, bool, bool, bool) {
259         uint256 _purchaseTimeout = store.getSetting("purchaseTimeout");
260         uint256 _fee = _tokens * store.getSetting("purchaseFee") / store.getSetting("percentage");
261 
262         bool purchaseTimeoutPassed = ((_purchaseTimeout <= 0) || (block.timestamp - datesOfPurchase[_address] > _purchaseTimeout));
263         bool tokensNumberPassed = (_tokens > 0);
264         bool ownerBalancePassed = (store.getBalance(_owner) >= (_tokens + _fee));
265         bool purchaseCapPassed = (store.getSetting("purchaseCap") <= 0) || (_tokens < store.getSetting("purchaseCap"));
266 
267         return (purchaseTimeoutPassed, ownerBalancePassed, tokensNumberPassed, purchaseCapPassed);
268     }
269 
270     function canTransfer(address _owner, address _from, address /*_to*/, uint256 _amount) public view returns (bool, bool) {
271         uint256 _fee = getTransferFee(_owner, _from, _amount);
272 
273         bool transferPositivePassed = (_amount + _fee) > 0;
274         bool ownerBalancePassed = store.getBalance(_from) >= (_amount + _fee);
275 
276         return (transferPositivePassed, ownerBalancePassed);
277     }
278 }
279 
280 contract TokenFacade is Permittable, Destructable, Withdrawable, ERC20Token {
281     TokenStorage private store;
282     TokenValidator validator;
283 
284     address private owner;
285 
286     // Just for information begin //
287     uint256 public infoAboveSpot = 400;
288     string public infoTier = "Tier 1";
289     string public infoTokenSilverRatio = "1 : 1";
290     // Just for information end //
291 
292     event TokenSold(address _from, uint256 _amount);                            //fe2ff4cf36ff7d2c2b06eb960897ee0d76d9c3e58da12feb7b93e86b226dd344
293     event TokenPurchased(address _address, uint256 _amount, uint256 _tokens);   //3ceffd410054fdaed44f598ff5c1fb450658778e2241892da4aa646979dee617
294     event TokenPoolExhausting(uint256 _amount);                                 //29ba2e073781c1157a9b5d5edb561437a6181e92b79152fe776615159312e9cd
295     event FeeApplied(string _name, address _address, uint256 _amount);
296 
297     mapping(address => mapping (address => uint256)) allowed;
298 
299     function TokenFacade() public {
300         owner = msg.sender;
301     }
302 
303     ///@notice Token purchase function. Allows user to purchase amount of tokens acccording to passed amount of Ethers.
304     function () public payable {
305         purchase();
306     }
307 
308     function totalSupply() public constant returns (uint256) {
309         return store.getSetting("totalSupply");
310     }
311 
312     function balanceOf(address _address) public constant returns (uint256) {
313         return store.getBalance(_address);
314     }
315 
316     string public constant symbol = "SLVT";
317     string public constant name = "SilverToken";
318     uint8 public constant decimals = 8;
319 
320     ///@notice Transfer `_amount` of tokens (must be sent as floating point number of token and decimal parts)
321     ///to `_address` with preliminary approving amount + fee from transaction sender
322     ///@param _to Address of the recipient
323     ///@param _amount Amount of tokens to transfer. Passed as `Token.Decimals * 10^8`, @see `decimals`.
324     function transfer(address _to, uint256 _amount) public returns (bool) {
325         uint256 _fee = validator.validateAndGetTransferFee(owner, msg.sender, _to, _amount);
326 
327         store.transfer(msg.sender, _to, _amount);
328 
329         if (_fee > 0)
330             store.transfer(msg.sender, store.getSettingAddress("feeReturnAddress"), _fee);
331 
332         Transfer(msg.sender, _to, _amount);
333 
334         return true;
335     }
336 
337     ///@notice Transfer `_amount` of tokens (must be sent as floating point number of token and decimal parts)
338     ///to `_address` from address `_from` without autoapproving
339     ///@param _to Address of the recipient
340     ///@param _amount Amount of tokens to transfer. Passed as `Token.Decimals * 10^8`, @see `decimals`.
341     ///@return bool Success state
342     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
343         require(allowed[_from][_to] >= _amount);
344 
345         uint256 _fee = validator.validateAndGetTransferFee(owner, _from, _to, _amount);
346 
347         store.transfer(_from, _to, _amount);
348 
349         if (_fee > 0)
350             store.transfer(_from, store.getSettingAddress("feeReturnAddress"), _fee);
351 
352         allowed[_from][_to] -= _amount;
353 
354         Transfer(_from, _to, _amount);
355 
356         return true;
357     }
358 
359     ///@notice Approve amount `_amount` of tokens to send from transaction creator to `_recipient`
360     ///@param _recipient Recipient
361     ///@param _amount Amount to approve `Token.Decimals * 10^8`, @see `decimals`
362     ///@return bool Success state
363     function approve(address _recipient, uint256 _amount) public returns (bool) {
364         return __approve_impl(msg.sender, _recipient, _amount);
365     }
366 
367     ///@notice Return allowed transaction amount from `_from` to `_recipient`
368     ///@param _from Initiator of transaction
369     ///@param _recipient Recipient
370     ///@return uint256 Amount approved to transfer as `Token.Decimals * 10^8`, @see `decimals`
371     function allowance(address _from, address _recipient) public constant returns (uint256) {
372         return allowed[_from][_recipient];
373     }
374 
375     ///@notice Token purchase function. Allows user to purchase amount of tokens acccording to passed amount of Ethers.
376     function purchase() public payable {
377         __purchase_impl(msg.sender, msg.value);
378     }
379 
380     ///@notice Redeem required amount of tokens for the real asset
381     ///@param _tokens Amount of nano tokens provides as `Token.Decimals * 10^8`
382     function redeem(uint256 _tokens) public {
383         __redeem_impl(msg.sender, _tokens);
384     }
385 
386     //@notice Get amount if tokens that actually available for purchase
387     //@returns amount if tokens
388     function getTokensInAction() public view returns (uint256) {
389         address deadTokensAddress = store.getSettingAddress("deadTokensAddress");
390         return store.getBalance(owner) - store.getBalance(deadTokensAddress);
391     }
392 
393     //@notice Get price of specified tokens amount. Depends on the second parameter returns price with fee or without
394     //@return price of specified tokens in Wei
395     function getTokensPrice(uint256 _amount, bool withFee) public constant returns (uint256) {
396         uint256 tokenPrice = store.getSetting("tokenPrice");
397         uint256 result = _amount * tokenPrice / 10**uint256(decimals);
398 
399         if (withFee) {
400             result = result + result * store.getSetting("purchaseFee") / store.getSetting("percentage");
401         }
402 
403         return result;
404     }
405 
406     function resetDeadTokens(uint256 _amount) public onlyPermitted returns (bool) {
407         address deadTokensAddress = validator.validateResetDeadTokens(_amount);
408         store.transfer(deadTokensAddress, owner, _amount);
409     }
410 
411     function canPurchase(address _address, uint256 _tokensAmount) public view returns(bool, bool, bool, bool) {
412         return validator.canPurchase(owner, _address, _tokensAmount);
413     }
414 
415     function canTransfer(address _from, address _to, uint256 _amount) public view returns(bool, bool) {
416         return validator.canTransfer(owner, _from, _to, _amount);
417     }
418 
419     function setInfoAboveSpot(uint256 newInfoAboveSpot) public onlyPermitted {
420         infoAboveSpot = newInfoAboveSpot;
421     }
422 
423     function setInfoTier(string newInfoTier) public onlyPermitted {
424         infoTier = newInfoTier;
425     }
426 
427     function setInfoTokenSilverRatio(string newInfoTokenSilverRatio) public onlyPermitted {
428         infoTokenSilverRatio = newInfoTokenSilverRatio;
429     }
430 
431     function getSetting(string _name) public view returns (uint256) {
432         return store.getSetting(_name);
433     }
434 
435     function getMegabox(uint256 index) public view onlyPermitted returns (address, uint256, uint256) {
436         return store.getMegabox(index);
437     }
438 
439     function getMegaboxIndex() public view onlyPermitted returns (uint256) {
440         return store.getMegaboxIndex();
441     }
442 
443     // Admin functions
444 
445     function _approve(address _from, address _recipient, uint256 _amount) public onlyPermitted returns (bool) {
446         return __approve_impl(_from, _recipient, _amount);
447     }
448 
449     function _transfer(address _from, address _to, uint256 _amount) public onlyPermitted returns (bool) {
450         validator.validateAndGetTransferFee(owner, _from, _to, _amount);
451 
452         store.transfer(_from, _to, _amount);
453 
454         Transfer(_from, _to, _amount);
455 
456         return true;
457     }
458 
459     function _purchase(address _to, uint256 _amount) public onlyPermitted {
460         __purchase_impl(_to, _amount);
461     }
462 
463     function _redeem(address _from, uint256 _tokens) public onlyPermitted {
464         __redeem_impl(_from, _tokens);
465     }
466 
467     function _start() public onlyPermitted {
468         validator.validateStart(owner, store);
469 
470         store.setBalance(owner, store.getSetting("totalSupply"));
471         store.setSetting("icoTimestamp", block.timestamp);
472     }
473 
474     function _setStore(address _address) public onlyPermitted {
475         store = TokenStorage(_address);
476     }
477 
478     function _setValidator(address _address) public onlyPermitted {
479         validator = TokenValidator(_address);
480     }
481 
482     function _setSetting(string _name, uint256 _value) public onlyPermitted {
483         store.setSetting(_name, _value);
484     }
485 
486     function _startMegabox(uint256 _tokens) public onlyPermitted {
487         validator.validateStartMegabox(owner, _tokens);
488         store.newMegabox(owner, _tokens, now);
489     }
490 
491     //
492     // Shareable functions code implementation
493     //
494 
495     function __approve_impl(address _sender, address _recipient, uint256 _amount) private returns (bool) {
496         allowed[_sender][_recipient] = _amount;
497         Approval(_sender, _recipient, _amount);
498         return true;
499     }
500 
501     function __purchase_impl(address _to, uint256 _amount) private {
502         uint256 _amountWithoutFee = _amount * store.getSetting("percentage") / (store.getSetting("purchaseFee") + store.getSetting("percentage"));
503         uint256 _fee = _amountWithoutFee * store.getSetting("purchaseFee") / store.getSetting("percentage");
504         uint256 _ownerBalance = store.getBalance(owner);
505         address _feeReturnAddress = store.getSettingAddress("feeReturnAddress");
506         uint256 _tokens = validator.validateAndGetPurchaseTokens(owner, msg.sender, _amountWithoutFee);
507 
508         store.increaseBalance(_to, _tokens);
509         store.decreaseBalance(owner, _tokens);
510 
511         if (_fee > 0)
512             _feeReturnAddress.transfer(_fee);
513 
514         validator.updateDateOfPurchase(_to, now);
515 
516         if (_ownerBalance < store.getSetting("exhaustingNumber")) {
517             TokenPoolExhausting(_ownerBalance);
518         }
519         TokenPurchased(_to, msg.value, _tokens);
520         Transfer(owner, _to, _tokens);
521     }
522 
523     function __redeem_impl(address _from, uint256 _tokens) private {
524         address deadTokensAddress = store.getSettingAddress("deadTokensAddress");
525         address feeReturnAddress = store.getSettingAddress("feeReturnAddress");
526         uint256 _fee = validator.validateAndGetRedeemFee(owner, _from, _tokens);
527 
528         store.transfer(_from, deadTokensAddress, _tokens);
529         store.transfer(_from, feeReturnAddress, _fee);
530 
531         TokenSold(_from, _tokens);
532     }
533 }