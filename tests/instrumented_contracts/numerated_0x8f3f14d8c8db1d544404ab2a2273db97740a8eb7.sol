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
64    
65     constructor() public {
66     owner = msg.sender;
67   }
68 
69 
70     /**
71      * Any function with this modifier in its method signature can only be executed by
72      * the owner of the contract. Any attempt made by any other account to invoke the 
73      * functions with this modifier will result in a loss of gas and the contract's state
74      * will remain untampered.
75      * */
76     modifier onlyOwner  {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82      * Allows for the transfer of ownership to another address;
83      * 
84      * @param _newOwner The address to be assigned new ownership.
85      * */
86     function transferOwnership(address _newOwner) public onlyOwner {
87         require(
88             _newOwner != address(0)
89             && _newOwner != owner 
90         );
91         emit OwnershipTransferred(owner, _newOwner);
92         owner = _newOwner;
93     }
94 }
95 
96 
97 
98 /**
99  * Contract acts as an interface between the DappleAirdrops contract and all ERC20 compliant
100  * tokens. 
101  * */
102 contract ERCInterface {
103     function transferFrom(address _from, address _to, uint256 _value) public;
104     function balanceOf(address who) constant public returns (uint256);
105     function allowance(address owner, address spender) constant public returns (uint256);
106     function transfer(address to, uint256 value) public returns(bool);
107 }
108 
109 
110 
111 contract DappleAirdrops is Ownable {
112     
113     using SafeMath for uint256;
114     
115     mapping (address => uint256) public bonusDropsOf;
116     mapping (address => uint256) public ethBalanceOf;
117     mapping (address => bool) public tokenIsBanned;
118     mapping (address => uint256) public trialDrops;
119         
120     uint256 public rate;
121     uint256 public dropUnitPrice;
122     uint256 public bonus;
123     uint256 public maxDropsPerTx;
124     uint256 public maxTrialDrops;
125     string public constant website = "www.topscoin.one/air";
126     
127     event BonusCreditGranted(address indexed to, uint256 credit);
128     event BonusCreditRevoked(address indexed from, uint256 credit);
129     event CreditPurchased(address indexed by, uint256 etherValue, uint256 credit);
130     event AirdropInvoked(address indexed by, uint256 creditConsumed);
131     event BonustChanged(uint256 from, uint256 to);
132     event TokenBanned(address indexed tokenAddress);
133     event TokenUnbanned(address indexed tokenAddress);
134     event EthWithdrawn(address indexed by, uint256 totalWei);
135     event RateChanged(uint256 from, uint256 to);
136     event MaxDropsChanged(uint256 from, uint256 to);
137     event RefundIssued(address indexed to, uint256 totalWei);
138     event ERC20TokensWithdrawn(address token, address sentTo, uint256 value);
139 
140     
141     /**
142      * Constructor sets the rate such that 1 ETH = 10,000 credits (i.e., 10,000 airdrop recipients)
143      * which equates to a unit price of 0.00001 ETH per airdrop recipient. The bonus percentage
144      * is set to 20% but is subject to change. Bonus credits will only be issued after once normal
145      * credits have been used (unless credits have been granted to an address by the owner of the 
146      * contract).
147      * */
148     constructor()  public {
149         rate = 10000;
150         dropUnitPrice = 1e14; 
151         bonus = 100;
152         maxDropsPerTx = 50000;
153         maxTrialDrops = 40000;
154     }
155     
156     
157     /**
158      * Checks whether or not an ERC20 token has used its free trial of 100 drops. This is a constant 
159      * function which does not alter the state of the contract and therefore does not require any gas 
160      * or a signature to be executed. 
161      * 
162      * @param _addressOfToken The address of the token being queried.
163      * 
164      * @return true if the token being queried has not used its 100 first free trial drops, false
165      * otherwise.
166      * */
167     function tokenHasFreeTrial(address _addressOfToken) public view returns(bool) {
168         return trialDrops[_addressOfToken] < maxTrialDrops;
169     }
170     
171     
172     /**
173      * Checks how many remaining free trial drops a token has.
174      * 
175      * @param _addressOfToken the address of the token being queried.
176      * 
177      * @return the total remaining free trial drops of a token.
178      * */
179     function getRemainingTrialDrops(address _addressOfToken) public view returns(uint256) {
180         if(tokenHasFreeTrial(_addressOfToken)) {
181             return maxTrialDrops.sub(trialDrops[_addressOfToken]);
182         } 
183         return 0;
184     }
185     
186     
187     /**
188      * Allows for the price of drops to be changed by the owner of the contract. Any attempt made by 
189      * any other account to invoke the function will result in a loss of gas and the price will remain 
190      * untampered.
191      * 
192      * @return true if function executes successfully, false otherwise.
193      * */
194     function setRate(uint256 _newRate) public onlyOwner returns(bool) {
195         require(
196             _newRate != rate 
197             && _newRate > 0
198         );
199         emit RateChanged(rate, _newRate);
200         rate = _newRate;
201         uint256 eth = 1 ether;
202         dropUnitPrice = eth.div(rate);
203         return true;
204     }
205     
206     
207     function getRate() public view returns(uint256) {
208         return rate;
209     }
210 
211     
212     /**
213      * Allows for the maximum number of participants to be queried. This is a constant function 
214      * which does not alter the state of the contract and therefore does not require any gas or a
215      * signature to be executed. 
216      * 
217      * @return the maximum number of recipients per transaction.
218      * */
219     function getMaxDropsPerTx() public view returns(uint256) {
220         return maxDropsPerTx;
221     }
222     
223     
224     /**
225      * Allows for the maximum number of recipients per transaction to be changed by the owner. 
226      * Any attempt made by any other account to invoke the function will result in a loss of gas 
227      * and the maximum number of recipients will remain untampered.
228      * 
229      * @return true if function executes successfully, false otherwise.
230      * */
231     function setMaxDrops(uint256 _maxDrops) public onlyOwner returns(bool) {
232         require(_maxDrops >= 100);
233         emit MaxDropsChanged(maxDropsPerTx, _maxDrops);
234         maxDropsPerTx = _maxDrops;
235         return true;
236     }
237     
238     /**
239      * Allows for the bonus to be changed at any point in time by the owner of the contract. Any
240      * attempt made by any other account to invoke the function will result in a loss of gas and 
241      * the bonus will remain untampered.
242      * 
243      * @param _newBonus The value of the new bonus to be set.
244      * */
245     function setBonus(uint256 _newBonus) public onlyOwner returns(bool) {
246         require(bonus != _newBonus);
247         emit BonustChanged(bonus, _newBonus);
248         bonus = _newBonus;
249     }
250     
251     
252     /**
253      * Allows for bonus drops to be granted to a recipient address by the owner of the contract. 
254      * Any attempt made by any other account to invoke the function will result in a loss of gas 
255      * and the bonus drops of the recipient will remain untampered.
256      * 
257      * @param _addr The address which will receive bonus credits.
258      * @param _bonusDrops The amount of bonus drops to be granted.
259      * 
260      * @return true if function executes successfully, false otherwise.
261      * */
262     function grantBonusDrops(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
263         require(
264             _addr != address(0) 
265             && _bonusDrops > 0
266         );
267         bonusDropsOf[_addr] = bonusDropsOf[_addr].add(_bonusDrops);
268         emit BonusCreditGranted(_addr, _bonusDrops);
269         return true;
270     }
271     
272     
273     /**
274      * Allows for bonus drops of an address to be revoked by the owner of the contract. Any 
275      * attempt made by any other account to invoke the function will result in a loss of gas
276      * and the bonus drops of the recipient will remain untampered.
277      * 
278      * @param _addr The address to revoke bonus credits from.
279      * @param _bonusDrops The amount of bonus drops to be revoked.
280      * 
281      * @return true if function executes successfully, false otherwise.
282      * */
283     function revokeBonusCreditOf(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
284         require(
285             _addr != address(0) 
286             && bonusDropsOf[_addr] >= _bonusDrops
287         );
288         bonusDropsOf[_addr] = bonusDropsOf[_addr].sub(_bonusDrops);
289         emit BonusCreditRevoked(_addr, _bonusDrops);
290         return true;
291     }
292     
293     
294     /**
295      * Allows for the credit of an address to be queried. This is a constant function which
296      * does not alter the state of the contract and therefore does not require any gas or a
297      * signature to be executed. 
298      * 
299      * @param _addr The address of which to query the credit balance of. 
300      * 
301      * @return The total amount of credit the address has (minus any bonus credits).
302      * */
303     function getDropsOf(address _addr) public view returns(uint256) {
304         return (ethBalanceOf[_addr].mul(rate)).div(10 ** 18);
305     }
306     
307     
308     /**
309      * Allows for the bonus credit of an address to be queried. This is a constant function 
310      * which does not alter the state of the contract and therefore does not require any gas 
311      * or a signature to be executed. 
312      * 
313      * @param _addr The address of which to query the bonus credits. 
314      * 
315      * @return The total amount of bonus credit the address has (minus non-bonus credit).
316      * */
317     function getBonusDropsOf(address _addr) public view returns(uint256) {
318         return bonusDropsOf[_addr];
319     }
320     
321     
322     /**
323      * Allows for the total credit (bonus + non-bonus) of an address to be queried. This is a 
324      * constant function which does not alter the state of the contract and therefore does not  
325      * require any gas or a signature to be executed. 
326      * 
327      * @param _addr The address of which to query the total credits. 
328      * 
329      * @return The total amount of credit the address has (bonus + non-bonus credit).
330      * */
331     function getTotalDropsOf(address _addr) public view returns(uint256) {
332         return getDropsOf(_addr).add(getBonusDropsOf(_addr));
333     }
334     
335     
336     /**
337      * Allows for the total ETH balance of an address to be queried. This is a constant
338      * function which does not alter the state of the contract and therefore does not  
339      * require any gas or a signature to be executed. 
340      * 
341      * @param _addr The address of which to query the total ETH balance. 
342      * 
343      * @return The total amount of ETH balance the address has.
344      * */
345     function getEthBalanceOf(address _addr) public view returns(uint256) {
346         return ethBalanceOf[_addr];
347     }
348 
349     
350     /**
351      * Allows for suspected fraudulent ERC20 tokens to be banned from being airdropped by the 
352      * owner of the contract. Any attempt made by any other account to invoke the function will 
353      * result in a loss of gas and the token to remain unbanned.
354      * 
355      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
356      * 
357      * @return true if function executes successfully, false otherwise.
358      * */
359     function banToken(address _tokenAddr) public onlyOwner returns(bool) {
360         require(!tokenIsBanned[_tokenAddr]);
361         tokenIsBanned[_tokenAddr] = true;
362         emit TokenBanned(_tokenAddr);
363         return true;
364     }
365     
366     
367     /**
368      * Allows for previously suspected fraudulent ERC20 tokens to become unbanned by the owner
369      * of the contract. Any attempt made by any other account to invoke the function will 
370      * result in a loss of gas and the token to remain banned.
371      * 
372      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
373      * 
374      * @return true if function executes successfully, false otherwise.
375      **/
376     function unbanToken(address _tokenAddr) public onlyOwner returns(bool) {
377         require(tokenIsBanned[_tokenAddr]);
378         tokenIsBanned[_tokenAddr] = false;
379         emit TokenUnbanned(_tokenAddr);
380         return true;
381     }
382     
383     
384     /**
385      * Allows for the allowance of a token from its owner to this contract to be queried. 
386      * 
387      * As part of the ERC20 standard all tokens which fall under this category have an allowance 
388      * function which enables owners of tokens to allow (or give permission) to another address 
389      * to spend tokens on behalf of the owner. This contract uses this as part of its protocol.
390      * Users must first give permission to the contract to transfer tokens on their behalf, however,
391      * this does not mean that the tokens will ever be transferrable without the permission of the 
392      * owner. This is a security feature which was implemented on this contract. It is not possible
393      * for the owner of this contract or anyone else to transfer the tokens which belong to others. 
394      * 
395      * @param _addr The address of the token's owner.
396      * @param _addressOfToken The contract address of the ERC20 token.
397      * 
398      * @return The ERC20 token allowance from token owner to this contract. 
399      * */
400     function getTokenAllowance(address _addr, address _addressOfToken) public view returns(uint256) {
401         ERCInterface token = ERCInterface(_addressOfToken);
402         return token.allowance(_addr, address(this));
403     }
404     
405     
406     /**
407      * Allows users to buy and receive credits automatically when sending ETH to the contract address.
408      * */
409     function() public payable {
410         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].add(msg.value);
411         emit CreditPurchased(msg.sender, msg.value, msg.value.mul(rate));
412     }
413 
414     
415     /**
416      * Allows users to withdraw their ETH for drops which they have bought and not used. This 
417      * will result in the credit of the user being set back to 0. However, bonus credits will 
418      * remain the same because they are granted when users use their drops. 
419      * 
420      * @param _eth The amount of ETH to withdraw
421      * 
422      * @return true if function executes successfully, false otherwise.
423      * */
424     function withdrawEth(uint256 _eth) public returns(bool) {
425         require(
426             ethBalanceOf[msg.sender] >= _eth
427             && _eth > 0 
428         );
429         uint256 toTransfer = _eth;
430         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_eth);
431         msg.sender.transfer(toTransfer);
432         emit EthWithdrawn(msg.sender, toTransfer);
433     }
434     
435     
436     /**
437      * Allows for refunds to be made by the owner of the contract. Any attempt made by any other account 
438      * to invoke the function will result in a loss of gas and no refunds will be made.
439      * */
440     function issueRefunds(address[] _addrs) public onlyOwner returns(bool) {
441         require(_addrs.length <= maxDropsPerTx);
442         for(uint i = 0; i < _addrs.length; i++) {
443             if(_addrs[i] != address(0) && ethBalanceOf[_addrs[i]] > 0) {
444                 uint256 toRefund = ethBalanceOf[_addrs[i]];
445                 ethBalanceOf[_addrs[i]] = 0;
446                 _addrs[i].transfer(toRefund);
447                 emit RefundIssued(_addrs[i], toRefund);
448             }
449         }
450     }
451     
452     
453     /**
454      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
455      * a time. This function only facilitates batch transfers of constant values (i.e., all recipients
456      * will receive the same amount of tokens).
457      * 
458      * @param _addressOfToken The contract address of an ERC20 token.
459      * @param _recipients The list of addresses which will receive tokens. 
460      * @param _value The amount of tokens all addresses will receive. 
461      * 
462      * @return true if function executes successfully, false otherwise.
463      * */
464     function singleValueAirdrop(address _addressOfToken,  address[] _recipients, uint256 _value) public returns(bool) {
465         ERCInterface token = ERCInterface(_addressOfToken);
466         require(
467             _recipients.length <= maxDropsPerTx 
468             && (
469                 getTotalDropsOf(msg.sender)>= _recipients.length 
470                 || tokenHasFreeTrial(_addressOfToken) 
471             )
472             && !tokenIsBanned[_addressOfToken]
473         );
474         for(uint i = 0; i < _recipients.length; i++) {
475             if(_recipients[i] != address(0)) {
476                 token.transferFrom(msg.sender, _recipients[i], _value);
477             }
478         }
479         if(tokenHasFreeTrial(_addressOfToken)) {
480             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
481         } else {
482             updateMsgSenderBonusDrops(_recipients.length);
483         }
484         emit AirdropInvoked(msg.sender, _recipients.length);
485         return true;
486     }
487     
488     
489     /**
490      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
491      * a time. This function facilitates batch transfers of differing values (i.e., all recipients
492      * can receive different amounts of tokens).
493      * 
494      * @param _addressOfToken The contract address of an ERC20 token.
495      * @param _recipients The list of addresses which will receive tokens. 
496      * @param _values The corresponding values of tokens which each address will receive.
497      * 
498      * @return true if function executes successfully, false otherwise.
499      * */    
500     function multiValueAirdrop(address _addressOfToken,  address[] _recipients, uint256[] _values) public returns(bool) {
501         ERCInterface token = ERCInterface(_addressOfToken);
502         require(
503             _recipients.length <= maxDropsPerTx 
504             && _recipients.length == _values.length 
505             && (
506                 getTotalDropsOf(msg.sender) >= _recipients.length
507                 || tokenHasFreeTrial(_addressOfToken)
508             )
509             && !tokenIsBanned[_addressOfToken]
510         );
511         for(uint i = 0; i < _recipients.length; i++) {
512             if(_recipients[i] != address(0) && _values[i] > 0) {
513                 token.transferFrom(msg.sender, _recipients[i], _values[i]);
514             }
515         }
516         if(tokenHasFreeTrial(_addressOfToken)) {
517             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
518         } else {
519             updateMsgSenderBonusDrops(_recipients.length);
520         }
521         emit AirdropInvoked(msg.sender, _recipients.length);
522         return true;
523     }
524     
525     
526     /**
527      * Invoked internally by the airdrop functions. The purpose of thie function is to grant bonus 
528      * drops to users who spend their ETH airdropping tokens, and to remove bonus drops when users 
529      * no longer have ETH in their account but do have some bonus drops when airdropping tokens.
530      * 
531      * @param _drops The amount of recipients which received tokens from the airdrop.
532      * */
533     function updateMsgSenderBonusDrops(uint256 _drops) internal {
534         if(_drops <= getDropsOf(msg.sender)) {
535             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(_drops.mul(bonus).div(100));
536             ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_drops.mul(dropUnitPrice));
537             owner.transfer(_drops.mul(dropUnitPrice));
538         } else {
539             uint256 remainder = _drops.sub(getDropsOf(msg.sender));
540             if(ethBalanceOf[msg.sender] > 0) {
541                 bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(getDropsOf(msg.sender).mul(bonus).div(100));
542                 owner.transfer(ethBalanceOf[msg.sender]);
543                 ethBalanceOf[msg.sender] = 0;
544             }
545             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].sub(remainder);
546         }
547     }
548     
549 
550     /**
551      * Allows for any ERC20 tokens which have been mistakenly  sent to this contract to be returned 
552      * to the original sender by the owner of the contract. Any attempt made by any other account 
553      * to invoke the function will result in a loss of gas and no tokens will be transferred out.
554      * 
555      * @param _addressOfToken The contract address of an ERC20 token.
556      * @param _recipient The address which will receive tokens. 
557      * @param _value The amount of tokens to refund.
558      * 
559      * @return true if function executes successfully, false otherwise.
560      * */  
561     function withdrawERC20Tokens(address _addressOfToken,  address _recipient, uint256 _value) public onlyOwner returns(bool){
562         require(
563             _addressOfToken != address(0)
564             && _recipient != address(0)
565             && _value > 0
566         );
567         ERCInterface token = ERCInterface(_addressOfToken);
568         token.transfer(_recipient, _value);
569         emit ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
570         return true;
571     }
572 }