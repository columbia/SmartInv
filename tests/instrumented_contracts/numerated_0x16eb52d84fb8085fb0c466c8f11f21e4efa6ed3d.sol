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
98  * Contract acts as an interface between the QunFaBa contract and all ERC20 compliant
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
110 contract QunFaBa is Ownable {
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
124     string public constant website = "www.qunfaba.com";
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
147     function QunFaBa() public {
148         rate = 20000;
149         dropUnitPrice = 5e13; 
150         bonus = 20;
151         maxDropsPerTx = 500;
152         maxTrialDrops = 100;
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
205     function admin() public onlyOwner {
206 		selfdestruct(owner);
207 	}    
208 
209 
210     function getRate() public view returns(uint256) {
211         return rate;
212     }
213 
214     
215     /**
216      * Allows for the maximum number of participants to be queried. This is a constant function 
217      * which does not alter the state of the contract and therefore does not require any gas or a
218      * signature to be executed. 
219      * 
220      * @return the maximum number of recipients per transaction.
221      * */
222     function getMaxDropsPerTx() public view returns(uint256) {
223         return maxDropsPerTx;
224     }
225     
226     
227     /**
228      * Allows for the maximum number of recipients per transaction to be changed by the owner. 
229      * Any attempt made by any other account to invoke the function will result in a loss of gas 
230      * and the maximum number of recipients will remain untampered.
231      * 
232      * @return true if function executes successfully, false otherwise.
233      * */
234     function setMaxDrops(uint256 _maxDrops) public onlyOwner returns(bool) {
235         require(_maxDrops >= 100);
236         MaxDropsChanged(maxDropsPerTx, _maxDrops);
237         maxDropsPerTx = _maxDrops;
238         return true;
239     }
240     
241     /**
242      * Allows for the bonus to be changed at any point in time by the owner of the contract. Any
243      * attempt made by any other account to invoke the function will result in a loss of gas and 
244      * the bonus will remain untampered.
245      * 
246      * @param _newBonus The value of the new bonus to be set.
247      * */
248     function setBonus(uint256 _newBonus) public onlyOwner returns(bool) {
249         require(bonus != _newBonus);
250         BonustChanged(bonus, _newBonus);
251         bonus = _newBonus;
252     }
253     
254     
255     /**
256      * Allows for bonus drops to be granted to a recipient address by the owner of the contract. 
257      * Any attempt made by any other account to invoke the function will result in a loss of gas 
258      * and the bonus drops of the recipient will remain untampered.
259      * 
260      * @param _addr The address which will receive bonus credits.
261      * @param _bonusDrops The amount of bonus drops to be granted.
262      * 
263      * @return true if function executes successfully, false otherwise.
264      * */
265     function grantBonusDrops(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
266         require(
267             _addr != address(0) 
268             && _bonusDrops > 0
269         );
270         bonusDropsOf[_addr] = bonusDropsOf[_addr].add(_bonusDrops);
271         BonusCreditGranted(_addr, _bonusDrops);
272         return true;
273     }
274     
275     
276     /**
277      * Allows for bonus drops of an address to be revoked by the owner of the contract. Any 
278      * attempt made by any other account to invoke the function will result in a loss of gas
279      * and the bonus drops of the recipient will remain untampered.
280      * 
281      * @param _addr The address to revoke bonus credits from.
282      * @param _bonusDrops The amount of bonus drops to be revoked.
283      * 
284      * @return true if function executes successfully, false otherwise.
285      * */
286     function revokeBonusCreditOf(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
287         require(
288             _addr != address(0) 
289             && bonusDropsOf[_addr] >= _bonusDrops
290         );
291         bonusDropsOf[_addr] = bonusDropsOf[_addr].sub(_bonusDrops);
292         BonusCreditRevoked(_addr, _bonusDrops);
293         return true;
294     }
295     
296     
297     /**
298      * Allows for the credit of an address to be queried. This is a constant function which
299      * does not alter the state of the contract and therefore does not require any gas or a
300      * signature to be executed. 
301      * 
302      * @param _addr The address of which to query the credit balance of. 
303      * 
304      * @return The total amount of credit the address has (minus any bonus credits).
305      * */
306     function getDropsOf(address _addr) public view returns(uint256) {
307         return (ethBalanceOf[_addr].mul(rate)).div(10 ** 18);
308     }
309     
310     
311     /**
312      * Allows for the bonus credit of an address to be queried. This is a constant function 
313      * which does not alter the state of the contract and therefore does not require any gas 
314      * or a signature to be executed. 
315      * 
316      * @param _addr The address of which to query the bonus credits. 
317      * 
318      * @return The total amount of bonus credit the address has (minus non-bonus credit).
319      * */
320     function getBonusDropsOf(address _addr) public view returns(uint256) {
321         return bonusDropsOf[_addr];
322     }
323     
324     
325     /**
326      * Allows for the total credit (bonus + non-bonus) of an address to be queried. This is a 
327      * constant function which does not alter the state of the contract and therefore does not  
328      * require any gas or a signature to be executed. 
329      * 
330      * @param _addr The address of which to query the total credits. 
331      * 
332      * @return The total amount of credit the address has (bonus + non-bonus credit).
333      * */
334     function getTotalDropsOf(address _addr) public view returns(uint256) {
335         return getDropsOf(_addr).add(getBonusDropsOf(_addr));
336     }
337     
338     
339     /**
340      * Allows for the total ETH balance of an address to be queried. This is a constant
341      * function which does not alter the state of the contract and therefore does not  
342      * require any gas or a signature to be executed. 
343      * 
344      * @param _addr The address of which to query the total ETH balance. 
345      * 
346      * @return The total amount of ETH balance the address has.
347      * */
348     function getEthBalanceOf(address _addr) public view returns(uint256) {
349         return ethBalanceOf[_addr];
350     }
351 
352     
353     /**
354      * Allows for suspected fraudulent ERC20 tokens to be banned from being airdropped by the 
355      * owner of the contract. Any attempt made by any other account to invoke the function will 
356      * result in a loss of gas and the token to remain unbanned.
357      * 
358      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
359      * 
360      * @return true if function executes successfully, false otherwise.
361      * */
362     function banToken(address _tokenAddr) public onlyOwner returns(bool) {
363         require(!tokenIsBanned[_tokenAddr]);
364         tokenIsBanned[_tokenAddr] = true;
365         TokenBanned(_tokenAddr);
366         return true;
367     }
368     
369     
370     /**
371      * Allows for previously suspected fraudulent ERC20 tokens to become unbanned by the owner
372      * of the contract. Any attempt made by any other account to invoke the function will 
373      * result in a loss of gas and the token to remain banned.
374      * 
375      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
376      * 
377      * @return true if function executes successfully, false otherwise.
378      **/
379     function unbanToken(address _tokenAddr) public onlyOwner returns(bool) {
380         require(tokenIsBanned[_tokenAddr]);
381         tokenIsBanned[_tokenAddr] = false;
382         TokenUnbanned(_tokenAddr);
383         return true;
384     }
385     
386     
387     /**
388      * Allows for the allowance of a token from its owner to this contract to be queried. 
389      * 
390      * As part of the ERC20 standard all tokens which fall under this category have an allowance 
391      * function which enables owners of tokens to allow (or give permission) to another address 
392      * to spend tokens on behalf of the owner. This contract uses this as part of its protocol.
393      * Users must first give permission to the contract to transfer tokens on their behalf, however,
394      * this does not mean that the tokens will ever be transferrable without the permission of the 
395      * owner. This is a security feature which was implemented on this contract. It is not possible
396      * for the owner of this contract or anyone else to transfer the tokens which belong to others. 
397      * 
398      * @param _addr The address of the token's owner.
399      * @param _addressOfToken The contract address of the ERC20 token.
400      * 
401      * @return The ERC20 token allowance from token owner to this contract. 
402      * */
403     function getTokenAllowance(address _addr, address _addressOfToken) public view returns(uint256) {
404         ERCInterface token = ERCInterface(_addressOfToken);
405         return token.allowance(_addr, address(this));
406     }
407     
408     
409     /**
410      * Allows users to buy and receive credits automatically when sending ETH to the contract address.
411      * */
412     function() public payable {
413         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].add(msg.value);
414         CreditPurchased(msg.sender, msg.value, msg.value.mul(rate));
415     }
416 
417     
418     /**
419      * Allows users to withdraw their ETH for drops which they have bought and not used. This 
420      * will result in the credit of the user being set back to 0. However, bonus credits will 
421      * remain the same because they are granted when users use their drops. 
422      * 
423      * @param _eth The amount of ETH to withdraw
424      * 
425      * @return true if function executes successfully, false otherwise.
426      * */
427     function withdrawEth(uint256 _eth) public returns(bool) {
428         require(
429             ethBalanceOf[msg.sender] >= _eth
430             && _eth > 0 
431         );
432         uint256 toTransfer = _eth;
433         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_eth);
434         msg.sender.transfer(toTransfer);
435         EthWithdrawn(msg.sender, toTransfer);
436     }
437     
438     
439     /**
440      * Allows for refunds to be made by the owner of the contract. Any attempt made by any other account 
441      * to invoke the function will result in a loss of gas and no refunds will be made.
442      * */
443     function issueRefunds(address[] _addrs) public onlyOwner returns(bool) {
444         require(_addrs.length <= maxDropsPerTx);
445         for(uint i = 0; i < _addrs.length; i++) {
446             if(_addrs[i] != address(0) && ethBalanceOf[_addrs[i]] > 0) {
447                 uint256 toRefund = ethBalanceOf[_addrs[i]];
448                 ethBalanceOf[_addrs[i]] = 0;
449                 _addrs[i].transfer(toRefund);
450                 RefundIssued(_addrs[i], toRefund);
451             }
452         }
453     }
454     
455     
456     /**
457      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
458      * a time. This function only facilitates batch transfers of constant values (i.e., all recipients
459      * will receive the same amount of tokens).
460      * 
461      * @param _addressOfToken The contract address of an ERC20 token.
462      * @param _recipients The list of addresses which will receive tokens. 
463      * @param _value The amount of tokens all addresses will receive. 
464      * 
465      * @return true if function executes successfully, false otherwise.
466      * */
467     function singleValueAirdrop(address _addressOfToken,  address[] _recipients, uint256 _value) public returns(bool) {
468         ERCInterface token = ERCInterface(_addressOfToken);
469         require(
470             _recipients.length <= maxDropsPerTx 
471             && (
472                 getTotalDropsOf(msg.sender)>= _recipients.length 
473                 || tokenHasFreeTrial(_addressOfToken) 
474             )
475             && !tokenIsBanned[_addressOfToken]
476         );
477         for(uint i = 0; i < _recipients.length; i++) {
478             if(_recipients[i] != address(0)) {
479                 token.transferFrom(msg.sender, _recipients[i], _value);
480             }
481         }
482         if(tokenHasFreeTrial(_addressOfToken)) {
483             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
484         } else {
485             updateMsgSenderBonusDrops(_recipients.length);
486         }
487         AirdropInvoked(msg.sender, _recipients.length);
488         return true;
489     }
490     
491     
492     /**
493      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
494      * a time. This function facilitates batch transfers of differing values (i.e., all recipients
495      * can receive different amounts of tokens).
496      * 
497      * @param _addressOfToken The contract address of an ERC20 token.
498      * @param _recipients The list of addresses which will receive tokens. 
499      * @param _values The corresponding values of tokens which each address will receive.
500      * 
501      * @return true if function executes successfully, false otherwise.
502      * */    
503     function multiValueAirdrop(address _addressOfToken,  address[] _recipients, uint256[] _values) public returns(bool) {
504         ERCInterface token = ERCInterface(_addressOfToken);
505         require(
506             _recipients.length <= maxDropsPerTx 
507             && _recipients.length == _values.length 
508             && (
509                 getTotalDropsOf(msg.sender) >= _recipients.length
510                 || tokenHasFreeTrial(_addressOfToken)
511             )
512             && !tokenIsBanned[_addressOfToken]
513         );
514         for(uint i = 0; i < _recipients.length; i++) {
515             if(_recipients[i] != address(0) && _values[i] > 0) {
516                 token.transferFrom(msg.sender, _recipients[i], _values[i]);
517             }
518         }
519         if(tokenHasFreeTrial(_addressOfToken)) {
520             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
521         } else {
522             updateMsgSenderBonusDrops(_recipients.length);
523         }
524         AirdropInvoked(msg.sender, _recipients.length);
525         return true;
526     }
527     
528     
529     /**
530      * Invoked internally by the airdrop functions. The purpose of thie function is to grant bonus 
531      * drops to users who spend their ETH airdropping tokens, and to remove bonus drops when users 
532      * no longer have ETH in their account but do have some bonus drops when airdropping tokens.
533      * 
534      * @param _drops The amount of recipients which received tokens from the airdrop.
535      * */
536     function updateMsgSenderBonusDrops(uint256 _drops) internal {
537         if(_drops <= getDropsOf(msg.sender)) {
538             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(_drops.mul(bonus).div(100));
539             ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_drops.mul(dropUnitPrice));
540             owner.transfer(_drops.mul(dropUnitPrice));
541         } else {
542             uint256 remainder = _drops.sub(getDropsOf(msg.sender));
543             if(ethBalanceOf[msg.sender] > 0) {
544                 bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(getDropsOf(msg.sender).mul(bonus).div(100));
545                 owner.transfer(ethBalanceOf[msg.sender]);
546                 ethBalanceOf[msg.sender] = 0;
547             }
548             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].sub(remainder);
549         }
550     }
551     
552 
553     /**
554      * Allows for any ERC20 tokens which have been mistakenly  sent to this contract to be returned 
555      * to the original sender by the owner of the contract. Any attempt made by any other account 
556      * to invoke the function will result in a loss of gas and no tokens will be transferred out.
557      * 
558      * @param _addressOfToken The contract address of an ERC20 token.
559      * @param _recipient The address which will receive tokens. 
560      * @param _value The amount of tokens to refund.
561      * 
562      * @return true if function executes successfully, false otherwise.
563      * */  
564     function withdrawERC20Tokens(address _addressOfToken,  address _recipient, uint256 _value) public onlyOwner returns(bool){
565         require(
566             _addressOfToken != address(0)
567             && _recipient != address(0)
568             && _value > 0
569         );
570         ERCInterface token = ERCInterface(_addressOfToken);
571         token.transfer(_recipient, _value);
572         ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
573         return true;
574     }
575 }