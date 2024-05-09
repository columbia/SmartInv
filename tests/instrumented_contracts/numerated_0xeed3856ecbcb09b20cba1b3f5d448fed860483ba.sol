1 pragma solidity ^0.4.19;
2 
3 /**
4  * Contract acts as an interface between the DappleAirdrops contract and all ERC20 compliant
5  * tokens. 
6  * */
7 contract ERCInterface {
8     function transferFrom(address _from, address _to, uint256 _value) public;
9     function balanceOf(address who) constant public returns (uint256);
10     function allowance(address owner, address spender) constant public returns (uint256);
11     function transfer(address to, uint256 value) public returns(bool);
12 }
13 
14 library SafeMath {
15     
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26         
27         c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31     
32 
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         // uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return a / b;
41     }
42 
43 
44     /**
45     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52 
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 
64 contract Ownable {
65     
66     address public owner;
67     
68     event OwnershipTransferred(address indexed from, address indexed to);
69     
70     
71     /**
72      * Constructor assigns ownership to the address used to deploy the contract.
73      * */
74     function Ownable() public {
75         owner = msg.sender;
76     }
77 
78 
79     /**
80      * Any function with this modifier in its method signature can only be executed by
81      * the owner of the contract. Any attempt made by any other account to invoke the 
82      * functions with this modifier will result in a loss of gas and the contract's state
83      * will remain untampered.
84      * */
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     /**
91      * Allows for the transfer of ownership to another address;
92      * 
93      * @param _newOwner The address to be assigned new ownership.
94      * */
95     function transferOwnership(address _newOwner) public onlyOwner {
96         require(
97             _newOwner != address(0)
98             && _newOwner != owner 
99         );
100         OwnershipTransferred(owner, _newOwner);
101         owner = _newOwner;
102     }
103 }
104 
105 
106 
107 contract DappleAirdrops is Ownable {
108     
109     using SafeMath for uint256;
110     
111     mapping (address => uint256) public bonusDropsOf;
112     mapping (address => uint256) public ethBalanceOf;
113     mapping (address => bool) public tokenIsBanned;
114     mapping (address => uint256) public trialDrops;
115         
116     uint256 public rate;
117     uint256 public dropUnitPrice;
118     uint256 public bonus;
119     uint256 public maxDropsPerTx;
120     uint256 public maxTrialDrops;
121     string public constant website = "www.dappleairdrops.com";
122     
123     event BonusCreditGranted(address indexed to, uint256 credit);
124     event BonusCreditRevoked(address indexed from, uint256 credit);
125     event CreditPurchased(address indexed by, uint256 etherValue, uint256 credit);
126     event AirdropInvoked(address indexed by, uint256 creditConsumed);
127     event BonustChanged(uint256 from, uint256 to);
128     event TokenBanned(address indexed tokenAddress);
129     event TokenUnbanned(address indexed tokenAddress);
130     event EthWithdrawn(address indexed by, uint256 totalWei);
131     event RateChanged(uint256 from, uint256 to);
132     event MaxDropsChanged(uint256 from, uint256 to);
133     event RefundIssued(address indexed to, uint256 totalWei);
134     event ERC20TokensWithdrawn(address token, address sentTo, uint256 value);
135 
136     
137     /**
138      * Constructor sets the rate such that 1 ETH = 10,000 credits (i.e., 10,000 airdrop recipients)
139      * which equates to a unit price of 0.00001 ETH per airdrop recipient. The bonus percentage
140      * is set to 20% but is subject to change. Bonus credits will only be issued after once normal
141      * credits have been used (unless credits have been granted to an address by the owner of the 
142      * contract).
143      * */
144     function DappleAirdrops() public {
145         rate = 10000;
146         dropUnitPrice = 1e14; 
147         bonus = 20;
148         maxDropsPerTx = 100;
149         maxTrialDrops = 100;
150     }
151     
152     
153     /**
154      * Checks whether or not an ERC20 token has used its free trial of 100 drops. This is a constant 
155      * function which does not alter the state of the contract and therefore does not require any gas 
156      * or a signature to be executed. 
157      * 
158      * @param _addressOfToken The address of the token being queried.
159      * 
160      * @return true if the token being queried has not used its 100 first free trial drops, false
161      * otherwise.
162      * */
163     function tokenHasFreeTrial(address _addressOfToken) public view returns(bool) {
164         return trialDrops[_addressOfToken] < maxTrialDrops;
165     }
166     
167     
168     /**
169      * Checks how many remaining free trial drops a token has.
170      * 
171      * @param _addressOfToken the address of the token being queried.
172      * 
173      * @return the total remaining free trial drops of a token.
174      * */
175     function getRemainingTrialDrops(address _addressOfToken) public view returns(uint256) {
176         if(tokenHasFreeTrial(_addressOfToken)) {
177             return maxTrialDrops.sub(trialDrops[_addressOfToken]);
178         } 
179         return 0;
180     }
181     
182     
183     /**
184      * Allows for the price of drops to be changed by the owner of the contract. Any attempt made by 
185      * any other account to invoke the function will result in a loss of gas and the price will remain 
186      * untampered.
187      * 
188      * @return true if function executes successfully, false otherwise.
189      * */
190     function setRate(uint256 _newRate) public onlyOwner returns(bool) {
191         require(
192             _newRate != rate 
193             && _newRate > 0
194         );
195         RateChanged(rate, _newRate);
196         rate = _newRate;
197         uint256 eth = 1 ether;
198         dropUnitPrice = eth.div(rate);
199         return true;
200     }
201     
202     
203     function getRate() public view returns(uint256) {
204         return rate;
205     }
206 
207     
208     /**
209      * Allows for the maximum number of participants to be queried. This is a constant function 
210      * which does not alter the state of the contract and therefore does not require any gas or a
211      * signature to be executed. 
212      * 
213      * @return the maximum number of recipients per transaction.
214      * */
215     function getMaxDropsPerTx() public view returns(uint256) {
216         return maxDropsPerTx;
217     }
218     
219     
220     /**
221      * Allows for the maximum number of recipients per transaction to be changed by the owner. 
222      * Any attempt made by any other account to invoke the function will result in a loss of gas 
223      * and the maximum number of recipients will remain untampered.
224      * 
225      * @return true if function executes successfully, false otherwise.
226      * */
227     function setMaxDrops(uint256 _maxDrops) public onlyOwner returns(bool) {
228         require(_maxDrops >= 100);
229         MaxDropsChanged(maxDropsPerTx, _maxDrops);
230         maxDropsPerTx = _maxDrops;
231         return true;
232     }
233     
234     /**
235      * Allows for the bonus to be changed at any point in time by the owner of the contract. Any
236      * attempt made by any other account to invoke the function will result in a loss of gas and 
237      * the bonus will remain untampered.
238      * 
239      * @param _newBonus The value of the new bonus to be set.
240      * */
241     function setBonus(uint256 _newBonus) public onlyOwner returns(bool) {
242         require(bonus != _newBonus);
243         BonustChanged(bonus, _newBonus);
244         bonus = _newBonus;
245     }
246     
247     
248     /**
249      * Allows for bonus drops to be granted to a recipient address by the owner of the contract. 
250      * Any attempt made by any other account to invoke the function will result in a loss of gas 
251      * and the bonus drops of the recipient will remain untampered.
252      * 
253      * @param _addr The address which will receive bonus credits.
254      * @param _bonusDrops The amount of bonus drops to be granted.
255      * 
256      * @return true if function executes successfully, false otherwise.
257      * */
258     function grantBonusDrops(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
259         require(
260             _addr != address(0) 
261             && _bonusDrops > 0
262         );
263         bonusDropsOf[_addr] = bonusDropsOf[_addr].add(_bonusDrops);
264         BonusCreditGranted(_addr, _bonusDrops);
265         return true;
266     }
267     
268     
269     /**
270      * Allows for bonus drops of an address to be revoked by the owner of the contract. Any 
271      * attempt made by any other account to invoke the function will result in a loss of gas
272      * and the bonus drops of the recipient will remain untampered.
273      * 
274      * @param _addr The address to revoke bonus credits from.
275      * @param _bonusDrops The amount of bonus drops to be revoked.
276      * 
277      * @return true if function executes successfully, false otherwise.
278      * */
279     function revokeBonusCreditOf(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
280         require(
281             _addr != address(0) 
282             && bonusDropsOf[_addr] >= _bonusDrops
283         );
284         bonusDropsOf[_addr] = bonusDropsOf[_addr].sub(_bonusDrops);
285         BonusCreditRevoked(_addr, _bonusDrops);
286         return true;
287     }
288     
289     
290     /**
291      * Allows for the credit of an address to be queried. This is a constant function which
292      * does not alter the state of the contract and therefore does not require any gas or a
293      * signature to be executed. 
294      * 
295      * @param _addr The address of which to query the credit balance of. 
296      * 
297      * @return The total amount of credit the address has (minus any bonus credits).
298      * */
299     function getDropsOf(address _addr) public view returns(uint256) {
300         return (ethBalanceOf[_addr].mul(rate)).div(10 ** 18);
301     }
302     
303     
304     /**
305      * Allows for the bonus credit of an address to be queried. This is a constant function 
306      * which does not alter the state of the contract and therefore does not require any gas 
307      * or a signature to be executed. 
308      * 
309      * @param _addr The address of which to query the bonus credits. 
310      * 
311      * @return The total amount of bonus credit the address has (minus non-bonus credit).
312      * */
313     function getBonusDropsOf(address _addr) public view returns(uint256) {
314         return bonusDropsOf[_addr];
315     }
316     
317     
318     /**
319      * Allows for the total credit (bonus + non-bonus) of an address to be queried. This is a 
320      * constant function which does not alter the state of the contract and therefore does not  
321      * require any gas or a signature to be executed. 
322      * 
323      * @param _addr The address of which to query the total credits. 
324      * 
325      * @return The total amount of credit the address has (bonus + non-bonus credit).
326      * */
327     function getTotalDropsOf(address _addr) public view returns(uint256) {
328         return getDropsOf(_addr).add(getBonusDropsOf(_addr));
329     }
330     
331     
332     /**
333      * Allows for the total ETH balance of an address to be queried. This is a constant
334      * function which does not alter the state of the contract and therefore does not  
335      * require any gas or a signature to be executed. 
336      * 
337      * @param _addr The address of which to query the total ETH balance. 
338      * 
339      * @return The total amount of ETH balance the address has.
340      * */
341     function getEthBalanceOf(address _addr) public view returns(uint256) {
342         return ethBalanceOf[_addr];
343     }
344 
345     
346     /**
347      * Allows for suspected fraudulent ERC20 tokens to be banned from being airdropped by the 
348      * owner of the contract. Any attempt made by any other account to invoke the function will 
349      * result in a loss of gas and the token to remain unbanned.
350      * 
351      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
352      * 
353      * @return true if function executes successfully, false otherwise.
354      * */
355     function banToken(address _tokenAddr) public onlyOwner returns(bool) {
356         require(!tokenIsBanned[_tokenAddr]);
357         tokenIsBanned[_tokenAddr] = true;
358         TokenBanned(_tokenAddr);
359         return true;
360     }
361     
362     
363     /**
364      * Allows for previously suspected fraudulent ERC20 tokens to become unbanned by the owner
365      * of the contract. Any attempt made by any other account to invoke the function will 
366      * result in a loss of gas and the token to remain banned.
367      * 
368      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
369      * 
370      * @return true if function executes successfully, false otherwise.
371      **/
372     function unbanToken(address _tokenAddr) public onlyOwner returns(bool) {
373         require(tokenIsBanned[_tokenAddr]);
374         tokenIsBanned[_tokenAddr] = false;
375         TokenUnbanned(_tokenAddr);
376         return true;
377     }
378     
379     
380     /**
381      * Allows for the allowance of a token from its owner to this contract to be queried. 
382      * 
383      * As part of the ERC20 standard all tokens which fall under this category have an allowance 
384      * function which enables owners of tokens to allow (or give permission) to another address 
385      * to spend tokens on behalf of the owner. This contract uses this as part of its protocol.
386      * Users must first give permission to the contract to transfer tokens on their behalf, however,
387      * this does not mean that the tokens will ever be transferrable without the permission of the 
388      * owner. This is a security feature which was implemented on this contract. It is not possible
389      * for the owner of this contract or anyone else to transfer the tokens which belong to others. 
390      * 
391      * @param _addr The address of the token's owner.
392      * @param _addressOfToken The contract address of the ERC20 token.
393      * 
394      * @return The ERC20 token allowance from token owner to this contract. 
395      * */
396     function getTokenAllowance(address _addr, address _addressOfToken) public view returns(uint256) {
397         ERCInterface token = ERCInterface(_addressOfToken);
398         return token.allowance(_addr, address(this));
399     }
400     
401     
402     /**
403      * Allows users to buy and receive credits automatically when sending ETH to the contract address.
404      * */
405     function() public payable {
406         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].add(msg.value);
407         CreditPurchased(msg.sender, msg.value, msg.value.mul(rate));
408     }
409 
410     
411     /**
412      * Allows users to withdraw their ETH for drops which they have bought and not used. This 
413      * will result in the credit of the user being set back to 0. However, bonus credits will 
414      * remain the same because they are granted when users use their drops. 
415      * 
416      * @param _eth The amount of ETH to withdraw
417      * 
418      * @return true if function executes successfully, false otherwise.
419      * */
420     function withdrawEth(uint256 _eth) public returns(bool) {
421         require(
422             ethBalanceOf[msg.sender] >= _eth
423             && _eth > 0 
424         );
425         uint256 toTransfer = _eth;
426         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_eth);
427         msg.sender.transfer(toTransfer);
428         EthWithdrawn(msg.sender, toTransfer);
429     }
430     
431     
432     /**
433      * Allows for refunds to be made by the owner of the contract. Any attempt made by any other account 
434      * to invoke the function will result in a loss of gas and no refunds will be made.
435      * */
436     function issueRefunds(address[] _addrs) public onlyOwner returns(bool) {
437         require(_addrs.length <= maxDropsPerTx);
438         for(uint i = 0; i < _addrs.length; i++) {
439             if(_addrs[i] != address(0) && ethBalanceOf[_addrs[i]] > 0) {
440                 uint256 toRefund = ethBalanceOf[_addrs[i]];
441                 ethBalanceOf[_addrs[i]] = 0;
442                 _addrs[i].transfer(toRefund);
443                 RefundIssued(_addrs[i], toRefund);
444             }
445         }
446     }
447     
448     
449     /**
450      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
451      * a time. This function only facilitates batch transfers of constant values (i.e., all recipients
452      * will receive the same amount of tokens).
453      * 
454      * @param _addressOfToken The contract address of an ERC20 token.
455      * @param _recipients The list of addresses which will receive tokens. 
456      * @param _value The amount of tokens all addresses will receive. 
457      * 
458      * @return true if function executes successfully, false otherwise.
459      * */
460     function singleValueAirdrop(address _addressOfToken,  address[] _recipients, uint256 _value) public returns(bool) {
461         ERCInterface token = ERCInterface(_addressOfToken);
462         require(
463             _recipients.length <= maxDropsPerTx 
464             && (
465                 getTotalDropsOf(msg.sender)>= _recipients.length 
466                 || tokenHasFreeTrial(_addressOfToken) 
467             )
468             && !tokenIsBanned[_addressOfToken]
469         );
470         for(uint i = 0; i < _recipients.length; i++) {
471             if(_recipients[i] != address(0)) {
472                 token.transferFrom(msg.sender, _recipients[i], _value);
473             }
474         }
475         if(tokenHasFreeTrial(_addressOfToken)) {
476             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
477         } else {
478             updateMsgSenderBonusDrops(_recipients.length);
479         }
480         AirdropInvoked(msg.sender, _recipients.length);
481         return true;
482     }
483     
484     
485     /**
486      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
487      * a time. This function facilitates batch transfers of differing values (i.e., all recipients
488      * can receive different amounts of tokens).
489      * 
490      * @param _addressOfToken The contract address of an ERC20 token.
491      * @param _recipients The list of addresses which will receive tokens. 
492      * @param _values The corresponding values of tokens which each address will receive.
493      * 
494      * @return true if function executes successfully, false otherwise.
495      * */    
496     function multiValueAirdrop(address _addressOfToken,  address[] _recipients, uint256[] _values) public returns(bool) {
497         ERCInterface token = ERCInterface(_addressOfToken);
498         require(
499             _recipients.length <= maxDropsPerTx 
500             && _recipients.length == _values.length 
501             && (
502                 getTotalDropsOf(msg.sender) >= _recipients.length
503                 || tokenHasFreeTrial(_addressOfToken)
504             )
505             && !tokenIsBanned[_addressOfToken]
506         );
507         for(uint i = 0; i < _recipients.length; i++) {
508             if(_recipients[i] != address(0) && _values[i] > 0) {
509                 token.transferFrom(msg.sender, _recipients[i], _values[i]);
510             }
511         }
512         if(tokenHasFreeTrial(_addressOfToken)) {
513             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
514         } else {
515             updateMsgSenderBonusDrops(_recipients.length);
516         }
517         AirdropInvoked(msg.sender, _recipients.length);
518         return true;
519     }
520     
521     
522     /**
523      * Invoked internally by the airdrop functions. The purpose of thie function is to grant bonus 
524      * drops to users who spend their ETH airdropping tokens, and to remove bonus drops when users 
525      * no longer have ETH in their account but do have some bonus drops when airdropping tokens.
526      * 
527      * @param _drops The amount of recipients which received tokens from the airdrop.
528      * */
529     function updateMsgSenderBonusDrops(uint256 _drops) internal {
530         if(_drops <= getDropsOf(msg.sender)) {
531             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(_drops.mul(bonus).div(100));
532             ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_drops.mul(dropUnitPrice));
533             owner.transfer(_drops.mul(dropUnitPrice));
534         } else {
535             uint256 remainder = _drops.sub(getDropsOf(msg.sender));
536             if(ethBalanceOf[msg.sender] > 0) {
537                 bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(getDropsOf(msg.sender).mul(bonus).div(100));
538                 owner.transfer(ethBalanceOf[msg.sender]);
539                 ethBalanceOf[msg.sender] = 0;
540             }
541             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].sub(remainder);
542         }
543     }
544     
545 
546     /**
547      * Allows for any ERC20 tokens which have been mistakenly  sent to this contract to be returned 
548      * to the original sender by the owner of the contract. Any attempt made by any other account 
549      * to invoke the function will result in a loss of gas and no tokens will be transferred out.
550      * 
551      * @param _addressOfToken The contract address of an ERC20 token.
552      * @param _recipient The address which will receive tokens. 
553      * @param _value The amount of tokens to refund.
554      * 
555      * @return true if function executes successfully, false otherwise.
556      * */  
557     function withdrawERC20Tokens(address _addressOfToken,  address _recipient, uint256 _value) public onlyOwner returns(bool){
558         require(
559             _addressOfToken != address(0)
560             && _recipient != address(0)
561             && _value > 0
562         );
563         ERCInterface token = ERCInterface(_addressOfToken);
564         token.transfer(_recipient, _value);
565         ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
566         return true;
567     }
568 }