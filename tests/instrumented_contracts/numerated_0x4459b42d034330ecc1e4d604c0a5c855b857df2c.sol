1 /***
2  * ██████╗ █████╗██████╗██████╗██╗    ███████╗     █████╗████████╗██████╗██████╗ ██████╗██████╗███████╗
3  * ██╔══████╔══████╔══████╔══████║    ██╔════╝    ██╔══██████╔══████╔══████╔══████╔═══████╔══████╔════╝
4  * ██║  ███████████████╔██████╔██║    █████╗      ███████████████╔██║  ████████╔██║   ████████╔███████╗
5  * ██║  ████╔══████╔═══╝██╔═══╝██║    ██╔══╝      ██╔══██████╔══████║  ████╔══████║   ████╔═══╝╚════██║
6  * ██████╔██║  ████║    ██║    ██████████████╗    ██║  ██████║  ████████╔██║  ██╚██████╔██║    ███████║
7  * ╚═════╝╚═╝  ╚═╚═╝    ╚═╝    ╚══════╚══════╝    ╚═╝  ╚═╚═╚═╝  ╚═╚═════╝╚═╝  ╚═╝╚═════╝╚═╝    ╚══════╝
8  *        
9  * MIT License
10  *
11  * Copyright (c) 2018 Dapple Airdrops
12  * 
13  * Permission is hereby granted, free of charge, to any person obtaining a copy
14  * of this software and associated documentation files (the "Software"), to deal
15  * in the Software without restriction, including without limitation the rights
16  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
17  * copies of the Software, and to permit persons to whom the Software is
18  * furnished to do so, subject to the following conditions:
19  * 
20  * The above copyright notice and this permission notice shall be included in all
21  * copies or substantial portions of the Software.
22  * 
23  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
24  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
25  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
26  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
27  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
28  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
29  * SOFTWARE.
30  * 
31  * @author Zenos Pavlakou
32  */
33  
34 pragma solidity ^0.4.19;
35 
36 library SafeMath {
37     
38     /**
39     * @dev Multiplies two numbers, throws on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48         
49         c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53     
54 
55     /**
56     * @dev Integer division of two numbers, truncating the quotient.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // assert(b > 0); // Solidity automatically throws when dividing by 0
60         // uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62         return a / b;
63     }
64 
65 
66     /**
67     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74 
75     /**
76     * @dev Adds two numbers, throws on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         assert(c >= a);
81         return c;
82     }
83 }
84 
85 
86 
87 contract Ownable {
88     
89     address public owner;
90     
91     event OwnershipTransferred(address indexed from, address indexed to);
92     
93     
94     /**
95      * Constructor assigns ownership to the address used to deploy the contract.
96      * */
97     function Ownable() public {
98         owner = msg.sender;
99     }
100 
101 
102     /**
103      * Any function with this modifier in its method signature can only be executed by
104      * the owner of the contract. Any attempt made by any other account to invoke the 
105      * functions with this modifier will result in a loss of gas and the contract's state
106      * will remain untampered.
107      * */
108     modifier onlyOwner {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     /**
114      * Allows for the transfer of ownership to another address;
115      * 
116      * @param _newOwner The address to be assigned new ownership.
117      * */
118     function transferOwnership(address _newOwner) public onlyOwner {
119         require(
120             _newOwner != address(0)
121             && _newOwner != owner 
122         );
123         OwnershipTransferred(owner, _newOwner);
124         owner = _newOwner;
125     }
126 }
127 
128 
129 
130 /**
131  * Contract acts as an interface between the DappleAirdrops contract and all ERC20 compliant
132  * tokens. 
133  * */
134 contract ERCInterface {
135     function transferFrom(address _from, address _to, uint256 _value) public;
136     function balanceOf(address who) constant public returns (uint256);
137     function allowance(address owner, address spender) constant public returns (uint256);
138     function transfer(address to, uint256 value) public returns(bool);
139 }
140 
141 
142 
143 contract DappleAirdrops is Ownable {
144     
145     using SafeMath for uint256;
146     
147     mapping (address => uint256) public bonusDropsOf;
148     mapping (address => uint256) public ethBalanceOf;
149     mapping (address => bool) public tokenIsBanned;
150     mapping (address => uint256) public trialDrops;
151         
152     uint256 public rate;
153     uint256 public dropUnitPrice;
154     uint256 public bonus;
155     uint256 public maxDropsPerTx;
156     uint256 public maxTrialDrops;
157     string public constant website = "www.dappleairdrops.com";
158     
159     event BonusCreditGranted(address indexed to, uint256 credit);
160     event BonusCreditRevoked(address indexed from, uint256 credit);
161     event CreditPurchased(address indexed by, uint256 etherValue, uint256 credit);
162     event AirdropInvoked(address indexed by, uint256 creditConsumed);
163     event BonustChanged(uint256 from, uint256 to);
164     event TokenBanned(address indexed tokenAddress);
165     event TokenUnbanned(address indexed tokenAddress);
166     event EthWithdrawn(address indexed by, uint256 totalWei);
167     event RateChanged(uint256 from, uint256 to);
168     event MaxDropsChanged(uint256 from, uint256 to);
169     event RefundIssued(address indexed to, uint256 totalWei);
170     event ERC20TokensWithdrawn(address token, address sentTo, uint256 value);
171 
172     
173     /**
174      * Constructor sets the rate such that 1 ETH = 10,000 credits (i.e., 10,000 airdrop recipients)
175      * which equates to a unit price of 0.00001 ETH per airdrop recipient. The bonus percentage
176      * is set to 20% but is subject to change. Bonus credits will only be issued after once normal
177      * credits have been used (unless credits have been granted to an address by the owner of the 
178      * contract).
179      * */
180     function DappleAirdrops() public {
181         rate = 10000;
182         dropUnitPrice = 1e14; 
183         bonus = 20;
184         maxDropsPerTx = 100;
185         maxTrialDrops = 100;
186     }
187     
188     
189     /**
190      * Checks whether or not an ERC20 token has used its free trial of 100 drops. This is a constant 
191      * function which does not alter the state of the contract and therefore does not require any gas 
192      * or a signature to be executed. 
193      * 
194      * @param _addressOfToken The address of the token being queried.
195      * 
196      * @return true if the token being queried has not used its 100 first free trial drops, false
197      * otherwise.
198      * */
199     function tokenHasFreeTrial(address _addressOfToken) public view returns(bool) {
200         return trialDrops[_addressOfToken] < maxTrialDrops;
201     }
202     
203     
204     /**
205      * Checks how many remaining free trial drops a token has.
206      * 
207      * @param _addressOfToken the address of the token being queried.
208      * 
209      * @return the total remaining free trial drops of a token.
210      * */
211     function getRemainingTrialDrops(address _addressOfToken) public view returns(uint256) {
212         if(tokenHasFreeTrial(_addressOfToken)) {
213             return maxTrialDrops.sub(trialDrops[_addressOfToken]);
214         } 
215         return 0;
216     }
217     
218     
219     /**
220      * Allows for the price of drops to be changed by the owner of the contract. Any attempt made by 
221      * any other account to invoke the function will result in a loss of gas and the price will remain 
222      * untampered.
223      * 
224      * @return true if function executes successfully, false otherwise.
225      * */
226     function setRate(uint256 _newRate) public onlyOwner returns(bool) {
227         require(
228             _newRate != rate 
229             && _newRate > 0
230         );
231         RateChanged(rate, _newRate);
232         rate = _newRate;
233         uint256 eth = 1 ether;
234         dropUnitPrice = eth.div(rate);
235         return true;
236     }
237     
238     
239     function getRate() public view returns(uint256) {
240         return rate;
241     }
242 
243     
244     /**
245      * Allows for the maximum number of participants to be queried. This is a constant function 
246      * which does not alter the state of the contract and therefore does not require any gas or a
247      * signature to be executed. 
248      * 
249      * @return the maximum number of recipients per transaction.
250      * */
251     function getMaxDropsPerTx() public view returns(uint256) {
252         return maxDropsPerTx;
253     }
254     
255     
256     /**
257      * Allows for the maximum number of recipients per transaction to be changed by the owner. 
258      * Any attempt made by any other account to invoke the function will result in a loss of gas 
259      * and the maximum number of recipients will remain untampered.
260      * 
261      * @return true if function executes successfully, false otherwise.
262      * */
263     function setMaxDrops(uint256 _maxDrops) public onlyOwner returns(bool) {
264         require(_maxDrops >= 100);
265         MaxDropsChanged(maxDropsPerTx, _maxDrops);
266         maxDropsPerTx = _maxDrops;
267         return true;
268     }
269     
270     /**
271      * Allows for the bonus to be changed at any point in time by the owner of the contract. Any
272      * attempt made by any other account to invoke the function will result in a loss of gas and 
273      * the bonus will remain untampered.
274      * 
275      * @param _newBonus The value of the new bonus to be set.
276      * */
277     function setBonus(uint256 _newBonus) public onlyOwner returns(bool) {
278         require(bonus != _newBonus);
279         BonustChanged(bonus, _newBonus);
280         bonus = _newBonus;
281     }
282     
283     
284     /**
285      * Allows for bonus drops to be granted to a recipient address by the owner of the contract. 
286      * Any attempt made by any other account to invoke the function will result in a loss of gas 
287      * and the bonus drops of the recipient will remain untampered.
288      * 
289      * @param _addr The address which will receive bonus credits.
290      * @param _bonusDrops The amount of bonus drops to be granted.
291      * 
292      * @return true if function executes successfully, false otherwise.
293      * */
294     function grantBonusDrops(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
295         require(
296             _addr != address(0) 
297             && _bonusDrops > 0
298         );
299         bonusDropsOf[_addr] = bonusDropsOf[_addr].add(_bonusDrops);
300         BonusCreditGranted(_addr, _bonusDrops);
301         return true;
302     }
303     
304     
305     /**
306      * Allows for bonus drops of an address to be revoked by the owner of the contract. Any 
307      * attempt made by any other account to invoke the function will result in a loss of gas
308      * and the bonus drops of the recipient will remain untampered.
309      * 
310      * @param _addr The address to revoke bonus credits from.
311      * @param _bonusDrops The amount of bonus drops to be revoked.
312      * 
313      * @return true if function executes successfully, false otherwise.
314      * */
315     function revokeBonusCreditOf(address _addr, uint256 _bonusDrops) public onlyOwner returns(bool) {
316         require(
317             _addr != address(0) 
318             && bonusDropsOf[_addr] >= _bonusDrops
319         );
320         bonusDropsOf[_addr] = bonusDropsOf[_addr].sub(_bonusDrops);
321         BonusCreditRevoked(_addr, _bonusDrops);
322         return true;
323     }
324     
325     
326     /**
327      * Allows for the credit of an address to be queried. This is a constant function which
328      * does not alter the state of the contract and therefore does not require any gas or a
329      * signature to be executed. 
330      * 
331      * @param _addr The address of which to query the credit balance of. 
332      * 
333      * @return The total amount of credit the address has (minus any bonus credits).
334      * */
335     function getDropsOf(address _addr) public view returns(uint256) {
336         return (ethBalanceOf[_addr].mul(rate)).div(10 ** 18);
337     }
338     
339     
340     /**
341      * Allows for the bonus credit of an address to be queried. This is a constant function 
342      * which does not alter the state of the contract and therefore does not require any gas 
343      * or a signature to be executed. 
344      * 
345      * @param _addr The address of which to query the bonus credits. 
346      * 
347      * @return The total amount of bonus credit the address has (minus non-bonus credit).
348      * */
349     function getBonusDropsOf(address _addr) public view returns(uint256) {
350         return bonusDropsOf[_addr];
351     }
352     
353     
354     /**
355      * Allows for the total credit (bonus + non-bonus) of an address to be queried. This is a 
356      * constant function which does not alter the state of the contract and therefore does not  
357      * require any gas or a signature to be executed. 
358      * 
359      * @param _addr The address of which to query the total credits. 
360      * 
361      * @return The total amount of credit the address has (bonus + non-bonus credit).
362      * */
363     function getTotalDropsOf(address _addr) public view returns(uint256) {
364         return getDropsOf(_addr).add(getBonusDropsOf(_addr));
365     }
366     
367     
368     /**
369      * Allows for the total ETH balance of an address to be queried. This is a constant
370      * function which does not alter the state of the contract and therefore does not  
371      * require any gas or a signature to be executed. 
372      * 
373      * @param _addr The address of which to query the total ETH balance. 
374      * 
375      * @return The total amount of ETH balance the address has.
376      * */
377     function getEthBalanceOf(address _addr) public view returns(uint256) {
378         return ethBalanceOf[_addr];
379     }
380 
381     
382     /**
383      * Allows for suspected fraudulent ERC20 tokens to be banned from being airdropped by the 
384      * owner of the contract. Any attempt made by any other account to invoke the function will 
385      * result in a loss of gas and the token to remain unbanned.
386      * 
387      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
388      * 
389      * @return true if function executes successfully, false otherwise.
390      * */
391     function banToken(address _tokenAddr) public onlyOwner returns(bool) {
392         require(!tokenIsBanned[_tokenAddr]);
393         tokenIsBanned[_tokenAddr] = true;
394         TokenBanned(_tokenAddr);
395         return true;
396     }
397     
398     
399     /**
400      * Allows for previously suspected fraudulent ERC20 tokens to become unbanned by the owner
401      * of the contract. Any attempt made by any other account to invoke the function will 
402      * result in a loss of gas and the token to remain banned.
403      * 
404      * @param _tokenAddr The contract address of the ERC20 token to be banned from being airdropped. 
405      * 
406      * @return true if function executes successfully, false otherwise.
407      **/
408     function unbanToken(address _tokenAddr) public onlyOwner returns(bool) {
409         require(tokenIsBanned[_tokenAddr]);
410         tokenIsBanned[_tokenAddr] = false;
411         TokenUnbanned(_tokenAddr);
412         return true;
413     }
414     
415     
416     /**
417      * Allows for the allowance of a token from its owner to this contract to be queried. 
418      * 
419      * As part of the ERC20 standard all tokens which fall under this category have an allowance 
420      * function which enables owners of tokens to allow (or give permission) to another address 
421      * to spend tokens on behalf of the owner. This contract uses this as part of its protocol.
422      * Users must first give permission to the contract to transfer tokens on their behalf, however,
423      * this does not mean that the tokens will ever be transferrable without the permission of the 
424      * owner. This is a security feature which was implemented on this contract. It is not possible
425      * for the owner of this contract or anyone else to transfer the tokens which belong to others. 
426      * 
427      * @param _addr The address of the token's owner.
428      * @param _addressOfToken The contract address of the ERC20 token.
429      * 
430      * @return The ERC20 token allowance from token owner to this contract. 
431      * */
432     function getTokenAllowance(address _addr, address _addressOfToken) public view returns(uint256) {
433         ERCInterface token = ERCInterface(_addressOfToken);
434         return token.allowance(_addr, address(this));
435     }
436     
437     
438     /**
439      * Allows users to buy and receive credits automatically when sending ETH to the contract address.
440      * */
441     function() public payable {
442         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].add(msg.value);
443         CreditPurchased(msg.sender, msg.value, msg.value.mul(rate));
444     }
445 
446     
447     /**
448      * Allows users to withdraw their ETH for drops which they have bought and not used. This 
449      * will result in the credit of the user being set back to 0. However, bonus credits will 
450      * remain the same because they are granted when users use their drops. 
451      * 
452      * @param _eth The amount of ETH to withdraw
453      * 
454      * @return true if function executes successfully, false otherwise.
455      * */
456     function withdrawEth(uint256 _eth) public returns(bool) {
457         require(
458             ethBalanceOf[msg.sender] >= _eth
459             && _eth > 0 
460         );
461         uint256 toTransfer = _eth;
462         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_eth);
463         msg.sender.transfer(toTransfer);
464         EthWithdrawn(msg.sender, toTransfer);
465     }
466     
467     
468     /**
469      * Allows for refunds to be made by the owner of the contract. Any attempt made by any other account 
470      * to invoke the function will result in a loss of gas and no refunds will be made.
471      * */
472     function issueRefunds(address[] _addrs) public onlyOwner returns(bool) {
473         require(_addrs.length <= maxDropsPerTx);
474         for(uint i = 0; i < _addrs.length; i++) {
475             if(_addrs[i] != address(0) && ethBalanceOf[_addrs[i]] > 0) {
476                 uint256 toRefund = ethBalanceOf[_addrs[i]];
477                 ethBalanceOf[_addrs[i]] = 0;
478                 _addrs[i].transfer(toRefund);
479                 RefundIssued(_addrs[i], toRefund);
480             }
481         }
482     }
483     
484     
485     /**
486      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
487      * a time. This function only facilitates batch transfers of constant values (i.e., all recipients
488      * will receive the same amount of tokens).
489      * 
490      * @param _addressOfToken The contract address of an ERC20 token.
491      * @param _recipients The list of addresses which will receive tokens. 
492      * @param _value The amount of tokens all addresses will receive. 
493      * 
494      * @return true if function executes successfully, false otherwise.
495      * */
496     function singleValueAirdrop(address _addressOfToken,  address[] _recipients, uint256 _value) public returns(bool) {
497         ERCInterface token = ERCInterface(_addressOfToken);
498         require(
499             _recipients.length <= maxDropsPerTx 
500             && (
501                 getTotalDropsOf(msg.sender)>= _recipients.length 
502                 || tokenHasFreeTrial(_addressOfToken) 
503             )
504             && !tokenIsBanned[_addressOfToken]
505         );
506         for(uint i = 0; i < _recipients.length; i++) {
507             if(_recipients[i] != address(0)) {
508                 token.transferFrom(msg.sender, _recipients[i], _value);
509             }
510         }
511         if(tokenHasFreeTrial(_addressOfToken)) {
512             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
513         } else {
514             updateMsgSenderBonusDrops(_recipients.length);
515         }
516         AirdropInvoked(msg.sender, _recipients.length);
517         return true;
518     }
519     
520     
521     /**
522      * Allows for the distribution of an ERC20 token to be transferred to up to 100 recipients at 
523      * a time. This function facilitates batch transfers of differing values (i.e., all recipients
524      * can receive different amounts of tokens).
525      * 
526      * @param _addressOfToken The contract address of an ERC20 token.
527      * @param _recipients The list of addresses which will receive tokens. 
528      * @param _values The corresponding values of tokens which each address will receive.
529      * 
530      * @return true if function executes successfully, false otherwise.
531      * */    
532     function multiValueAirdrop(address _addressOfToken,  address[] _recipients, uint256[] _values) public returns(bool) {
533         ERCInterface token = ERCInterface(_addressOfToken);
534         require(
535             _recipients.length <= maxDropsPerTx 
536             && _recipients.length == _values.length 
537             && (
538                 getTotalDropsOf(msg.sender) >= _recipients.length
539                 || tokenHasFreeTrial(_addressOfToken)
540             )
541             && !tokenIsBanned[_addressOfToken]
542         );
543         for(uint i = 0; i < _recipients.length; i++) {
544             if(_recipients[i] != address(0) && _values[i] > 0) {
545                 token.transferFrom(msg.sender, _recipients[i], _values[i]);
546             }
547         }
548         if(tokenHasFreeTrial(_addressOfToken)) {
549             trialDrops[_addressOfToken] = trialDrops[_addressOfToken].add(_recipients.length);
550         } else {
551             updateMsgSenderBonusDrops(_recipients.length);
552         }
553         AirdropInvoked(msg.sender, _recipients.length);
554         return true;
555     }
556     
557     
558     /**
559      * Invoked internally by the airdrop functions. The purpose of thie function is to grant bonus 
560      * drops to users who spend their ETH airdropping tokens, and to remove bonus drops when users 
561      * no longer have ETH in their account but do have some bonus drops when airdropping tokens.
562      * 
563      * @param _drops The amount of recipients which received tokens from the airdrop.
564      * */
565     function updateMsgSenderBonusDrops(uint256 _drops) internal {
566         if(_drops <= getDropsOf(msg.sender)) {
567             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(_drops.mul(bonus).div(100));
568             ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_drops.mul(dropUnitPrice));
569             owner.transfer(_drops.mul(dropUnitPrice));
570         } else {
571             uint256 remainder = _drops.sub(getDropsOf(msg.sender));
572             if(ethBalanceOf[msg.sender] > 0) {
573                 bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].add(getDropsOf(msg.sender).mul(bonus).div(100));
574                 owner.transfer(ethBalanceOf[msg.sender]);
575                 ethBalanceOf[msg.sender] = 0;
576             }
577             bonusDropsOf[msg.sender] = bonusDropsOf[msg.sender].sub(remainder);
578         }
579     }
580     
581 
582     /**
583      * Allows for any ERC20 tokens which have been mistakenly  sent to this contract to be returned 
584      * to the original sender by the owner of the contract. Any attempt made by any other account 
585      * to invoke the function will result in a loss of gas and no tokens will be transferred out.
586      * 
587      * @param _addressOfToken The contract address of an ERC20 token.
588      * @param _recipient The address which will receive tokens. 
589      * @param _value The amount of tokens to refund.
590      * 
591      * @return true if function executes successfully, false otherwise.
592      * */  
593     function withdrawERC20Tokens(address _addressOfToken,  address _recipient, uint256 _value) public onlyOwner returns(bool){
594         require(
595             _addressOfToken != address(0)
596             && _recipient != address(0)
597             && _value > 0
598         );
599         ERCInterface token = ERCInterface(_addressOfToken);
600         token.transfer(_recipient, _value);
601         ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
602         return true;
603     }
604 }