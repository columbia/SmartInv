1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15         
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20     
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 
53 
54 contract Ownable {
55     
56     address public owner;
57     
58     event OwnershipTransferred(address indexed from, address indexed to);
59     
60     
61     /**
62      * Constructor assigns ownership to the address used to deploy the contract.
63      * */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68 
69     /**
70      * Any function with this modifier in its method signature can only be executed by
71      * the owner of the contract. Any attempt made by any other account to invoke the 
72      * functions with this modifier will result in a loss of gas and the contract's state
73      * will remain untampered.
74      * */
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     /**
81      * Allows for the transfer of ownership to another address;
82      * 
83      * @param _newOwner The address to be assigned new ownership.
84      * */
85     function transferOwnership(address _newOwner) public onlyOwner {
86         require(
87             _newOwner != address(0)
88             && _newOwner != owner 
89         );
90         OwnershipTransferred(owner, _newOwner);
91         owner = _newOwner;
92     }
93 }
94 
95 
96 
97 /**
98  * Contract acts as an interface between the DappleAirdrops contract and all ERC20 compliant
99  * tokens. 
100  * */
101 contract ERCInterface {
102     function transferFrom(address _from, address _to, uint256 _value) public;
103     function balanceOf(address who) constant public returns (uint256);
104     function allowance(address owner, address spender) constant public returns (uint256);
105     function transfer(address to, uint256 value) public returns(bool);
106 }
107 
108 
109 
110 contract DappleAirdrops is Ownable {
111     
112     using SafeMath for uint256;
113     
114     mapping (address => uint256) public bonusDropsOf;
115     mapping (address => uint256) public ethBalanceOf;
116     mapping (address => bool) public tokenIsBanned;
117     mapping (address => uint256) public trialDrops;
118         
119     uint256 public rate;
120     uint256 public dropUnitPrice;
121     uint256 public bonus;
122     uint256 public maxDropsPerTx;
123     uint256 public maxTrialDrops;
124     string public constant website = "www.dappleairdrops.com";
125     
126     event BonusCreditGranted(address indexed to, uint256 credit);
127     event BonusCreditRevoked(address indexed from, uint256 credit);
128     event CreditPurchased(address indexed by, uint256 etherValue, uint256 credit);
129     event AirdropInvoked(address indexed by, uint256 creditConsumed);
130     event BonustChanged(uint256 from, uint256 to);
131     event TokenBanned(address indexed tokenAddress);
132     event TokenUnbanned(address indexed tokenAddress);
133     event EthWithdrawn(address indexed by, uint256 totalWei);
134     event RateChanged(uint256 from, uint256 to);
135     event MaxDropsChanged(uint256 from, uint256 to);
136     event RefundIssued(address indexed to, uint256 totalWei);
137     event ERC20TokensWithdrawn(address token, address sentTo, uint256 value);
138 
139     
140     /**
141      * Constructor sets the rate such that 1 ETH = 10,000 credits (i.e., 10,000 airdrop recipients)
142      * which equates to a unit price of 0.00001 ETH per airdrop recipient. The bonus percentage
143      * is set to 20% but is subject to change. Bonus credits will only be issued after once normal
144      * credits have been used (unless credits have been granted to an address by the owner of the 
145      * contract).
146      * */
147     function DappleAirdrops() public {
148         rate = 10000;
149         dropUnitPrice = 1e14; 
150         bonus = 20;
151         maxDropsPerTx = 1000000;
152         maxTrialDrops = 1000000;
153     }
154     
155     
156     /**
157      * Checks whether or not an ERC20 token has used its free trial of 100 drops. This is a constant 
158      * function which does not alter the state of the contract and therefore does not require any gas 
159      * or a signature to be executed. 
160      * 
161      * @param _addressOfToken The address of the token being queried.
162      * 
163      * @return true if the token being queried has not used its 100 first free trial drops, false
164      * otherwise.
165      * */
166     function tokenHasFreeTrial(address _addressOfToken) public view returns(bool) {
167         return trialDrops[_addressOfToken] < maxTrialDrops;
168     }
169     
170     
171     /**
172      * Checks how many remaining free trial drops a token has.
173      * 
174      * @param _addressOfToken the address of the token being queried.
175      * 
176      * @return the total remaining free trial drops of a token.
177      * */
178     function getRemainingTrialDrops(address _addressOfToken) public view returns(uint256) {
179         if(tokenHasFreeTrial(_addressOfToken)) {
180             return maxTrialDrops.sub(trialDrops[_addressOfToken]);
181         } 
182         return 0;
183     }
184     
185     
186     /**
187      * Allows for the price of drops to be changed by the owner of the contract. Any attempt made by 
188      * any other account to invoke the function will result in a loss of gas and the price will remain 
189      * untampered.
190      * 
191      * @return true if function executes successfully, false otherwise.
192      * */
193     function setRate(uint256 _newRate) public onlyOwner returns(bool) {
194         require(
195             _newRate != rate 
196             && _newRate > 0
197         );
198         RateChanged(rate, _newRate);
199         rate = _newRate;
200         uint256 eth = 1 ether;
201         dropUnitPrice = eth.div(rate);
202         return true;
203     }
204     
205     
206     function getRate() public view returns(uint256) {
207         return rate;
208     }
209 
210     
211     /**
212      * Allows for the maximum number of participants to be queried. This is a constant function 
213      * which does not alter the state of the contract and therefore does not require any gas or a
214      * signature to be executed. 
215      * 
216      * @return the maximum number of recipients per transaction.
217      * */
218     function getMaxDropsPerTx() public view returns(uint256) {
219         return maxDropsPerTx;
220     }
221     
222     
223     /**
224      * Allows for the maximum number of recipients per transaction to be changed by the owner. 
225      * Any attempt made by any other account to invoke the function will result in a loss of gas 
226      * and the maximum number of recipients will remain untampered.
227      * 
228      * @return true if function executes successfully, false otherwise.
229      * */
230     function setMaxDrops(uint256 _maxDrops) public onlyOwner returns(bool) {
231         require(_maxDrops >= 1000000);
232         MaxDropsChanged(maxDropsPerTx, _maxDrops);
233         maxDropsPerTx = _maxDrops;
234         return true;
235     }
236     
237     /**
238      * Allows for the bonus to be changed at any point in time by the owner of the contract. Any
239      * attempt made by any other account to invoke the function will result in a loss of gas and 
240      * the bonus will remain untampered.
241      * 
242      * @param _newBonus The value of the new bonus to be set.
243      * */
244     function setBonus(uint256 _newBonus) public onlyOwner returns(bool) {
245         require(bonus != _newBonus);
246         BonustChanged(bonus, _newBonus);
247         bonus = _newBonus;
248     }
249     
250     
251     /**
252      * Allows for bonus drops to be granted to a recipient address by the owner of the contract. 
253      * Any attempt made by any other account to invoke the function will result in a loss of gas 
254      * and the bonus drops of the recipient will remain untampered.
255      * 
256      * @param _addr The address which will receive bonus credits.
257      * @param _bonusDrops The amount of bonus drops to be granted.
258      * 
259      * @return true if function executes successfully, false otherwise.
260      * */
261     function grantBonusDrops(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
262         require(
263             _addr != address(0) 
264             && _bonusDrops > 0
265         );
266         bonusDropsOf[_addr] = bonusDropsOf[_addr].add(_bonusDrops);
267         BonusCreditGranted(_addr, _bonusDrops);
268         return true;
269     }
270     
271     
272     /**
273      * Allows for bonus drops of an address to be revoked by the owner of the contract. Any 
274      * attempt made by any other account to invoke the function will result in a loss of gas
275      * and the bonus drops of the recipient will remain untampered.
276      * 
277      * @param _addr The address to revoke bonus credits from.
278      * @param _bonusDrops The amount of bonus drops to be revoked.
279      * 
280      * @return true if function executes successfully, false otherwise.
281      * */
282     function revokeBonusCreditOf(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
283         require(
284             _addr != address(0) 
285             && bonusDropsOf[_addr] >= _bonusDrops
286         );
287         bonusDropsOf[_addr] = bonusDropsOf[_addr].sub(_bonusDrops);
288         BonusCreditRevoked(_addr, _bonusDrops);
289         return true;
290     }
291     
292     
293     /**
294      * Allows for the credit of an address to be queried. This is a constant function which
295      * does not alter the state of the contract and therefore does not require any gas or a
296      * signature to be executed. 
297      * 
298      * @param _addr The address of which to query the credit balance of. 
299      * 
300      * @return The total amount of credit the address has (minus any bonus credits).
301      * */
302     function getDropsOf(address _addr) public view returns(uint256) {
303         return (ethBalanceOf[_addr].mul(rate)).div(10 ** 18);
304     }
305     
306     
307     /**
308      * Allows for the bonus credit of an address to be queried. This is a constant function 
309      * which does not alter the state of the contract and therefore does not require any gas 
310      * or a signature to be executed. 
311      * 
312      * @param _addr The address of which to query the bonus credits. 
313      * 
314      * @return The total amount of bonus credit the address has (minus non-bonus credit).
315      * */
316     function getBonusDropsOf(address _addr) public view returns(uint256) {
317         return bonusDropsOf[_addr];
318     }
319     
320     
321     /**
322      * Allows for the total credit (bonus + non-bonus) of an address to be queried. This is a 
323      * constant function which does not alter the state of the contract and therefore does not  
324      * require any gas or a signature to be executed. 
325      * 
326      * @param _addr The address of which to query the total credits. 
327      * 
328      * @return The total amount of credit the address has (bonus + non-bonus credit).
329      * */
330     function getTotalDropsOf(address _addr) public view returns(uint256) {
331         return getDropsOf(_addr).add(getBonusDropsOf(_addr));
332     }
333     
334     
335     /**
336      * Allows for the total ETH balance of an address to be queried. This is a constant
337      * function which does not alter the state of the contract and therefore does not  
338      * require any gas or a signature to be executed. 
339      * 
340      * @param _addr The address of which to query the total ETH balance. 
341      * 
342      * @return The total amount of ETH balance the address has.
343      * */
344     function getEthBalanceOf(address _addr) public view returns(uint256) {
345         return ethBalanceOf[_addr];
346     }
347 
348     
349     /**
350      * Allows for suspected fraudulent ERC20 tokens to be banned from being airdropped by the 
351      * owner of the contract. Any attempt made by any other account to invoke the function will 
352      * result in a loss of gas and the token to remain unbanned.
353      * 
354      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
355      * 
356      * @return true if function executes successfully, false otherwise.
357      * */
358     function banToken(address _tokenAddr) public onlyOwner returns(bool) {
359         require(!tokenIsBanned[_tokenAddr]);
360         tokenIsBanned[_tokenAddr] = true;
361         TokenBanned(_tokenAddr);
362         return true;
363     }
364     
365     
366     /**
367      * Allows for previously suspected fraudulent ERC20 tokens to become unbanned by the owner
368      * of the contract. Any attempt made by any other account to invoke the function will 
369      * result in a loss of gas and the token to remain banned.
370      * 
371      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
372      * 
373      * @return true if function executes successfully, false otherwise.
374      **/
375     function unbanToken(address _tokenAddr) public onlyOwner returns(bool) {
376         require(tokenIsBanned[_tokenAddr]);
377         tokenIsBanned[_tokenAddr] = false;
378         TokenUnbanned(_tokenAddr);
379         return true;
380     }
381     
382     
383     /**
384      * Allows for the allowance of a token from its owner to this contract to be queried. 
385      * 
386      * As part of the ERC20 standard all tokens which fall under this category have an allowance 
387      * function which enables owners of tokens to allow (or give permission) to another address 
388      * to spend tokens on behalf of the owner. This contract uses this as part of its protocol.
389      * Users must first give permission to the contract to transfer tokens on their behalf, however,
390      * this does not mean that the tokens will ever be transferrable without the permission of the 
391      * owner. This is a security feature which was implemented on this contract. It is not possible
392      * for the owner of this contract or anyone else to transfer the tokens which belong to others. 
393      * 
394      * @param _addr The address of the token's owner.
395      * @param _addressOfToken The contract address of the ERC20 token.
396      * 
397      * @return The ERC20 token allowance from token owner to this contract. 
398      * */
399     function getTokenAllowance(address _addr, address _addressOfToken) public view returns(uint256) {
400         ERCInterface token = ERCInterface(_addressOfToken);
401         return token.allowance(_addr, address(this));
402     }
403     
404     
405     /**
406      * Allows users to buy and receive credits automatically when sending ETH to the contract address.
407      * */
408     function() public payable {
409         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].add(msg.value);
410         CreditPurchased(msg.sender, msg.value, msg.value.mul(rate));
411     }
412 
413     
414     /**
415      * Allows users to withdraw their ETH for drops which they have bought and not used. This 
416      * will result in the credit of the user being set back to 0. However, bonus credits will 
417      * remain the same because they are granted when users use their drops. 
418      * 
419      * @param _eth The amount of ETH to withdraw
420      * 
421      * @return true if function executes successfully, false otherwise.
422      * */
423     function withdrawEth(uint256 _eth) public returns(bool) {
424         require(
425             ethBalanceOf[msg.sender] >= _eth
426             && _eth > 0 
427         );
428         uint256 toTransfer = _eth;
429         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_eth);
430         msg.sender.transfer(toTransfer);
431         EthWithdrawn(msg.sender, toTransfer);
432     }
433     
434     
435     /**
436      * Allows for refunds to be made by the owner of the contract. Any attempt made by any other account 
437      * to invoke the function will result in a loss of gas and no refunds will be made.
438      * */
439     function issueRefunds(address[] _addrs) public onlyOwner returns(bool) {
440         require(_addrs.length <= maxDropsPerTx);
441         for(uint i = 0; i < _addrs.length; i++) {
442             if(_addrs[i] != address(0) && ethBalanceOf[_addrs[i]] > 0) {
443                 uint256 toRefund = ethBalanceOf[_addrs[i]];
444                 ethBalanceOf[_addrs[i]] = 0;
445                 _addrs[i].transfer(toRefund);
446                 RefundIssued(_addrs[i], toRefund);
447             }
448         }
449     }
450     
451     
452     /**
453      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
454      * a time. This function only facilitates batch transfers of constant values (i.e., all recipients
455      * will receive the same amount of tokens).
456      * 
457      * @param _addressOfToken The contract address of an ERC20 token.
458      * @param _recipients The list of addresses which will receive tokens. 
459      * @param _value The amount of tokens all addresses will receive. 
460      * 
461      * @return true if function executes successfully, false otherwise.
462      * */
463     function singleValueAirdrop(address _addressOfToken,  address[] _recipients, uint256 _value) public returns(bool) {
464         ERCInterface token = ERCInterface(_addressOfToken);
465         require(
466             _recipients.length <= maxDropsPerTx 
467             && (
468                 getTotalDropsOf(msg.sender)>= _recipients.length 
469                 || tokenHasFreeTrial(_addressOfToken) 
470             )
471             && !tokenIsBanned[_addressOfToken]
472         );
473         for(uint i = 0; i < _recipients.length; i++) {
474             if(_recipients[i] != address(0)) {
475                 token.transferFrom(msg.sender, _recipients[i], _value);
476             }
477         }
478         if(tokenHasFreeTrial(_addressOfToken)) {
479             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
480         } else {
481             updateMsgSenderBonusDrops(_recipients.length);
482         }
483         AirdropInvoked(msg.sender, _recipients.length);
484         return true;
485     }
486     
487     
488     /**
489      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
490      * a time. This function facilitates batch transfers of differing values (i.e., all recipients
491      * can receive different amounts of tokens).
492      * 
493      * @param _addressOfToken The contract address of an ERC20 token.
494      * @param _recipients The list of addresses which will receive tokens. 
495      * @param _values The corresponding values of tokens which each address will receive.
496      * 
497      * @return true if function executes successfully, false otherwise.
498      * */    
499     function multiValueAirdrop(address _addressOfToken,  address[] _recipients, uint256[] _values) public returns(bool) {
500         ERCInterface token = ERCInterface(_addressOfToken);
501         require(
502             _recipients.length <= maxDropsPerTx 
503             && _recipients.length == _values.length 
504             && (
505                 getTotalDropsOf(msg.sender) >= _recipients.length
506                 || tokenHasFreeTrial(_addressOfToken)
507             )
508             && !tokenIsBanned[_addressOfToken]
509         );
510         for(uint i = 0; i < _recipients.length; i++) {
511             if(_recipients[i] != address(0) && _values[i] > 0) {
512                 token.transferFrom(msg.sender, _recipients[i], _values[i]);
513             }
514         }
515         if(tokenHasFreeTrial(_addressOfToken)) {
516             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
517         } else {
518             updateMsgSenderBonusDrops(_recipients.length);
519         }
520         AirdropInvoked(msg.sender, _recipients.length);
521         return true;
522     }
523     
524     
525     /**
526      * Invoked internally by the airdrop functions. The purpose of thie function is to grant bonus 
527      * drops to users who spend their ETH airdropping tokens, and to remove bonus drops when users 
528      * no longer have ETH in their account but do have some bonus drops when airdropping tokens.
529      * 
530      * @param _drops The amount of recipients which received tokens from the airdrop.
531      * */
532     function updateMsgSenderBonusDrops(uint256 _drops) internal {
533         if(_drops <= getDropsOf(msg.sender)) {
534             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(_drops.mul(bonus).div(100));
535             ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_drops.mul(dropUnitPrice));
536             owner.transfer(_drops.mul(dropUnitPrice));
537         } else {
538             uint256 remainder = _drops.sub(getDropsOf(msg.sender));
539             if(ethBalanceOf[msg.sender] > 0) {
540                 bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(getDropsOf(msg.sender).mul(bonus).div(100));
541                 owner.transfer(ethBalanceOf[msg.sender]);
542                 ethBalanceOf[msg.sender] = 0;
543             }
544             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].sub(remainder);
545         }
546     }
547     
548 
549     /**
550      * Allows for any ERC20 tokens which have been mistakenly  sent to this contract to be returned 
551      * to the original sender by the owner of the contract. Any attempt made by any other account 
552      * to invoke the function will result in a loss of gas and no tokens will be transferred out.
553      * 
554      * @param _addressOfToken The contract address of an ERC20 token.
555      * @param _recipient The address which will receive tokens. 
556      * @param _value The amount of tokens to refund.
557      * 
558      * @return true if function executes successfully, false otherwise.
559      * */  
560     function withdrawERC20Tokens(address _addressOfToken,  address _recipient, uint256 _value) public onlyOwner returns(bool){
561         require(
562             _addressOfToken != address(0)
563             && _recipient != address(0)
564             && _value > 0
565         );
566         ERCInterface token = ERCInterface(_addressOfToken);
567         token.transfer(_recipient, _value);
568         ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
569         return true;
570     }
571 }