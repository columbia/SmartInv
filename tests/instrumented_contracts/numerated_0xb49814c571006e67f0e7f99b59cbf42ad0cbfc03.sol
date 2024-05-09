1 /**
2  * @title CryptoDivert DAPP
3  * @dev Implementation of the CryptoDivert Smart Contract.
4  * @version 2018.04.05 
5  * @copyright All rights reserved (c) 2018 Cryptology ltd, Hong Kong.
6  * @author Cryptology ltd, Hong Kong.
7  * @disclaimer CryptoDivert DAPP provided by Cryptology ltd, Hong Kong is for illustrative purposes only. 
8  * 
9  * The interface for this contract is running on https://CryptoDivert.io 
10  * 
11  * You can also use the contract in https://www.myetherwallet.com/#contracts. 
12  * With ABI / JSON Interface:
13  * [{"constant":true,"inputs":[],"name":"showPendingAdmin","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_password","type":"string"},{"name":"_originAddress","type":"address"}],"name":"Retrieve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"ping","outputs":[{"name":"","type":"string"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"whoIsAdmin","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newAdmin","type":"address"}],"name":"setAdmin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_originAddressHash","type":"bytes20"},{"name":"_releaseTime","type":"uint256"},{"name":"_privacyCommission","type":"uint16"}],"name":"SafeGuard","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"_originAddressHash","type":"bytes20"}],"name":"AuditSafeGuard","outputs":[{"name":"_safeGuarded","type":"uint256"},{"name":"_timelock","type":"uint256"},{"name":"_privacypercentage","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"AuditBalances","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"confirmAdmin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"RetrieveCommissions","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"pendingAdmin","type":"address"},{"indexed":false,"name":"currentAdmin","type":"address"}],"name":"ContractAdminTransferPending","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"newAdmin","type":"address"},{"indexed":false,"name":"previousAdmin","type":"address"}],"name":"NewContractAdmin","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"value","type":"uint256"}],"name":"CommissionsWithdrawn","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"hash","type":"bytes20"},{"indexed":false,"name":"value","type":"uint256"},{"indexed":false,"name":"comissions","type":"uint256"}],"name":"SafeGuardSuccess","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"value","type":"uint256"}],"name":"RetrieveSuccess","type":"event"}]
14  * 
15  * ABOUT
16  * This Distributed Application (DAPP) provides private (pseudo-anonymous) transactions on the ETH blockchain.
17  * A forensic expert will be able to trace these transaction with some time and effort. If you don't do
18  * anything illegal where time and effort will be spend to trace you down this should be providing you enough privacy. 
19  * You can create public and private transfers (public: anybody with the password can retrieve, private: only a specific address can retrieve).
20  * For private transfers there will be no direct link between safeguarding and retrieving the funds, only an indirect link
21  * where a forensic investigator would have to trial and error hashing all retrieved password/address combinations 
22  * until he stumbles upon the one you used to safeguard the ETH. The more usage this DAPP gets, the more private it becomes.
23  *
24  * You can check our FAQ at https://cryptodivert.io/faq for details.
25  * 
26  * This software is supplied "AS IS" without any warranties and support. 
27  * Cryptology ltd assumes no responsibility or liability for the use of the software, 
28  * conveys no license or title under any patent, copyright, or mask work right to the product. 
29  * Cryptology ltd make no representation or warranty that such application will be suitable for 
30  * the specified use without further testing or modification.
31  * 
32  * To the maximum extent permitted by applicable law, in no event shall Cryptology ltd be liable for 
33  * any direct, indirect, punitive, incidental, special, consequential damages or any damages 
34  * whatsoever including, without limitation, damages for loss of use, data or profits, arising 
35  * out of or in any way connected with the use or performance of the CryptoDivert DAPP, with the delay 
36  * or inability to use the CryptoDivert DAPP or related services, the provision of or failure to 
37  * provide services, or for any information obtained through the CryptoDivert DAPP, or otherwise arising out 
38  * of the use of the CryptoDivert DAPP, whether based on contract, tort, negligence, strict liability 
39  * or otherwise, even if Cryptology ltd has been advised of the possibility of damages. 
40  * Because some states/jurisdictions do not allow the exclusion or limitation of liability for 
41  * consequential or incidental damages, the above limitation may not apply to you. 
42  * If you are dissatisfied with any portion of the CryptoDivert DAPP, or with any of these terms of 
43  * use, your sole and exclusive remedy is to discontinue using the CryptoDivert DAPP.
44  * 
45  * DO NOT USE THIS DAPP IN A WAY THAT VIOLATES ANY LAW, WOULD CREATE LIABILITY OR PROMOTES
46  * ILLEGAL ACTIVITIES. 
47  */
48  
49 pragma solidity ^0.4.21;
50 
51 contract CryptoDivert {
52     using SafeMath for uint256; // We don't like overflow errors.
53     
54     // ETH address of the admin.
55     // Some methods from this contract can only be executed by the admin address.
56     address private admin;
57     
58     // Used to confirm a new Admin address. The current admin sets this variable 
59     // when he wants to transfer the contract. The change will only be implemented 
60     // once the new admin ETH address confirms the address is correct.
61     address private pendingAdmin; 
62     
63     // 0x ETH address, we check input against this address.
64     address private constant NO_ADDRESS = address(0);
65     
66     // Store the originating addresses for every SafeGuard. These will be used to 
67     // verify the bytes20 hash when a safeguard is retrieved.
68     mapping (bytes20 => address) private senders;
69     
70     // Allow a SafeGuard to be locked until a certain time (e.g. can`t be retrieved before).
71     mapping (bytes20 => uint256) private timers;
72     
73     // Allow a maximum deviation of the amount by x% where x/100 is x * 1%
74     mapping (bytes20 => uint16) private privacyDeviation;
75     
76     // Store the value of every SafeGuard.
77     mapping (bytes20 => uint256) private balances;
78     
79     // Keep balance administrations. 
80     uint256 private userBalance; // The total value of all outstanding safeguards combined.
81     
82     // Create additional privacy (only for receiver hashed transfers)
83     uint256 private privacyFund;
84     
85     /// EVENTS ///
86     event ContractAdminTransferPending(address pendingAdmin, address currentAdmin);
87     event NewContractAdmin(address newAdmin, address previousAdmin);
88     event SafeGuardSuccess(bytes20 hash, uint256 value, uint256 comissions);
89     event RetrieveSuccess(uint256 value);
90     
91     
92     /// MODIFIERS ///
93     /**
94      * @dev Only allow a method to be executed if '_who' is not the 0x address
95      */
96     modifier isAddress(address _who) {
97         require(_who != NO_ADDRESS);
98         _;
99     }
100     
101     /**
102      * @dev Only allow a method the be executed if the input hasn't been messed with.
103      */
104     modifier onlyPayloadSize(uint size) {
105         assert(msg.data.length >= size +4); // +4 because the 4 bytes of the method.
106         _;
107     }
108     
109     /**
110      * @dev Only allow a method to be executed if 'msg.sender' is the admin.
111      */
112     modifier OnlyByAdmin() {
113         require(msg.sender == admin);
114         _;
115     }
116     
117     /**
118      * @dev Only allow a method to be executed if '_who' is not the admin.
119      */
120     modifier isNotAdmin(address _who) {
121         require(_who != admin);
122         _;
123     }
124 
125     /// PUBLIC METHODS ///    
126     function CryptoDivert() public {
127         // We need to define the initial administrator for this DAPP.
128         // This should be transferred to the permanent administrator after the contract
129         // has been created on the blockchain.
130         admin = msg.sender;
131     }
132     
133     /**
134      * @dev Process users sending ETH to this contract.
135      * Don't send ETH directly to this contract, use the SafeGuard method to 
136      * safeguard your ETHs; then again we don't mind if you like to 
137      * buy us a beer (or a Lambo). In that case thanks for the ETH! 
138      * We'll assume you actually intended to tip us.
139      */
140     function() public payable {
141     }
142     
143     /// EXTERNAL VIEW METHODS ///
144     /**
145      * @dev Test for web3js interface to see if contract is correctly initialized.
146      */
147     function ping() external view returns(string, uint256) {
148         return ("CryptoDivert version 2018.04.05", now);
149     }
150     
151     
152     /**
153      * @dev Shows who is the pending admin for this contract
154      * @return 'pendingAdmin'
155      */
156     function showPendingAdmin() external view 
157     OnlyByAdmin()
158     returns(address) 
159     {
160         require(pendingAdmin != NO_ADDRESS);
161         return pendingAdmin;
162     }
163     
164     /**
165      * @dev Shows who is the admin for this contract
166      * @return 'admin'
167      */
168     function whoIsAdmin() external view 
169     returns(address) 
170     {
171         return admin;
172     }
173     
174     /**
175      * @dev Check if the internal administration is correct. The safeguarded user balances added to the 
176      * un-retrieved admin commission should be the same as the ETH balance of this contract.
177      * 
178      * @return uint256 The total current safeguarded balance of all users 'userBalance' + 'privacyfund'.
179      * @return uint256 The outstanding admin commissions 'commissions'.
180      */
181     function AuditBalances() external view returns(uint256, uint256) {
182         assert(address(this).balance >= userBalance);
183         uint256 pendingBalance = userBalance.add(privacyFund);
184         uint256 commissions = address(this).balance.sub(pendingBalance);
185         
186         return(pendingBalance, commissions);
187     }
188     
189     /**
190      * @dev Check the remaining balance for a safeguarded transaction
191      *
192      * @param _originAddressHash The RIPEMD160 Hash (bytes20) of a password and the originating ETH address.
193      * @return uint256 The remaining value in Wei for this safeguard.
194      */
195     function AuditSafeGuard(bytes20 _originAddressHash) external view 
196     returns(uint256 _safeGuarded, uint256 _timelock, uint16 _privacypercentage)
197     {
198         // Only by the address that uploaded the safeguard to make it harder for prying eyes to track.
199         require(msg.sender == senders[_originAddressHash] || msg.sender == admin);
200          
201         _safeGuarded = balances[_originAddressHash];
202         _timelock = timers[_originAddressHash];
203         _privacypercentage = privacyDeviation[_originAddressHash];
204         
205         return (_safeGuarded, _timelock, _privacypercentage);
206     }
207     
208     
209     /// EXTERNAL METHODS ///
210     /**
211      * @dev Safeguard a value in Wei. You can retreive this after '_releaseTime' via any ETH address 
212      * by callling the Retreive method with your password and the originating ETH address.
213      * 
214      * To prevent the password from being visible in the blockchain (everything added is visible in the blockchain!)
215      * and allow more users to set the same password, you need to create a RIPEMD160 Hash from your password
216      * and your originating (or intended receiver) ETH address: e.g. if you choose password: 'secret' and transfer balance 
217      * from (or to) ETH address (ALL LOWERCASE!) '0x14723a09acff6d2a60dcdf7aa4aff308fddc160c' you should RIPEMD160 Hash:
218      * 'secret0x14723a09acff6d2a60dcdf7aa4aff308fddc160c'.
219      * http://www.md5calc.com/ RIPEMD160 gives us the 20 bytes Hash: '602bc74a8e09f80c2d5bbc4374b8f400f33f2683'.
220      * If you manually transfer value to this contract make sure to enter the hash as a bytes20 '0x602bc74a8e09f80c2d5bbc4374b8f400f33f2683'.
221      * Before you transfer any value to SafeGuard, test the example above and make sure you get the same hash, 
222      * then test a transfer (and Retreive!) with a small amount (minimal 1 finney) before SafeGuarding a larger amount. 
223      * 
224      * IF YOU MAKE AN ERROR WITH YOUR HASH, OR FORGET YOUR PASSWORD, YOUR FUNDS WILL BE SAFEGUARDED FOREVER.
225      * 
226      * @param _originAddressHash The RIPEMD160 Hash (bytes20) of a password and the msg.sender or intended receiver ETH address.
227      * @param _releaseTime The UNIX time (uint256) until when this balance is locked up.
228      * @param _privacyCommission The maximum deviation (up or down) that you are willing to use to make tracking on the amount harder.
229      * @return true Usefull if this method is called from a contract.
230      */
231     function SafeGuard(bytes20 _originAddressHash, uint256 _releaseTime, uint16 _privacyCommission) external payable
232     onlyPayloadSize(3*32)
233     returns(bool)
234     {
235         // We can only SafeGuard anything if there is value transferred.
236         // Minimal value is 1 finney, to prevent SPAM and any errors with the commissions calculations.
237         require(msg.value >= 1 finney); 
238         
239         // Prevent Re-usage of a compromised password by this address; Check that we have not used this before. 
240         // In case we have used this password, but haven't retrieved the amount, the password is still 
241         // uncompromised and we can add this amount to the existing amount.
242         // A password/ETH combination that was used before will be known to the blockchain (clear text) 
243         // after the Retrieve method has been called and can't be used again to prevent others retrieving you funds.
244         require(senders[_originAddressHash] == NO_ADDRESS || balances[_originAddressHash] > 0);
245        
246         // We don't know your password (Only you do!) so we can't possible check wether or not 
247         // you created the correct hash, we have to assume you did. Only store the first sender of this hash
248         // to prevent someone uploading a small amount with this hash to gain access to the AuditSafeGuard method 
249         // or reset the timer.
250         if(senders[_originAddressHash] == NO_ADDRESS) {
251             
252             senders[_originAddressHash] = msg.sender;
253             
254             // If you set a timer we check if it's in the future and add it to this SafeGuard.
255             if (_releaseTime > now) {
256                 timers[_originAddressHash] = _releaseTime;
257             } else {
258                 timers[_originAddressHash] = now;
259             }
260             
261             // if we have set a privacy deviation store it, max 100% = 10000.
262             if (_privacyCommission > 0 && _privacyCommission <= 10000) {
263                 privacyDeviation[_originAddressHash] = _privacyCommission;
264             }
265         }    
266         
267         // To pay for our servers (and maybe a beer or two) we charge a 0.8% fee (that's 80cents per 100$).
268         uint256 _commission = msg.value.div(125); //100/125 = 0.8
269         uint256 _balanceAfterCommission = msg.value.sub(_commission);
270         balances[_originAddressHash] = balances[_originAddressHash].add(_balanceAfterCommission);
271         
272         // Keep score of total user balance 
273         userBalance = userBalance.add(_balanceAfterCommission);
274         
275         // Double check that our administration is correct.
276         // The administration can only be incorrect if someone found a loophole in Solidity or in our programming.
277         // The assert will effectively revert the transaction in case someone is cheating.
278         assert(address(this).balance >= userBalance); 
279         
280         // Let the user know what a great success.
281         emit SafeGuardSuccess(_originAddressHash, _balanceAfterCommission, _commission);
282         
283         return true;
284     } 
285     
286     /**
287      * @dev Retrieve a safeguarded value to the ETH address that calls this method.
288      * 
289      * The safeguarded value can be retrieved by any ETH address, including the originating ETH address and contracts.
290      * All you need is the (clear text) password and the originating ETH address that was used to transfer the 
291      * value to this contract. This method will recreate the RIPEMD160 Hash that was 
292      * given to the SafeGuard method (this will only succeed when both password and address are correct).
293      * The value can only be retrieved after the release timer for this SafeGuard (if any) has expired.
294      * 
295      * This Retrieve method can be traced in the blockchain via the input field. 
296      * We can create additional anonimity by hashing the receivers address instead of the originating address
297      * in the SafeGuard method. By doing this we render searching for the originating address 
298      * in the input field useless. To make the tracement harder, we will charge an addition random 
299      * commission between 0 and 5% so the outgoing value is randomized. This will still not create 
300      * 100% anonimity because it is possible to hash every password and receiver address combination and compare it
301      * to the hash that was originally given when safeguarding the transaction. 
302      * 
303      * @param _password The password that was originally hashed for this safeguarded value.
304      * @param _originAddress The address where this safeguarded value was received from.
305      * @return true Usefull if this method is called from a contract.
306      */ 
307     function Retrieve(string _password, address _originAddress) external 
308     isAddress(_originAddress) 
309     onlyPayloadSize(2*32)
310     returns(bool)
311     {
312         
313         // Re-create the _originAddressHash that was given when transferring to this contract.
314         // Either the sender's address was hashed (and allows to retrieve from any address) or 
315         // the receiver's address was hashed (more private, but only allows to retrieve from that address).
316         bytes20 _addressHash = _getOriginAddressHash(_originAddress, _password); 
317         bytes20 _senderHash = _getOriginAddressHash(msg.sender, _password); 
318         bytes20 _transactionHash;
319         uint256 _randomPercentage; // used to make a receiver hashed transaction more private.
320         uint256 _month = 30 * 24 * 60 * 60;
321         
322         // Check if the given '_originAddress' is the same as the address that transferred to this contract.
323         // We do this to prevent people simply giving any hash.
324         if (_originAddress == senders[_addressHash]) { // Public Transaction, hashed with originating address.
325             
326             // Anybody with the password and the sender's address
327             _transactionHash = _addressHash;
328             
329         } 
330         else if (msg.sender == senders[_addressHash] && timers[_addressHash].add(_month) < now ) { // Private transaction, retrieve by sender after a month delay. 
331             
332             // Allow a sender to retrieve his transfer, only a month after the timelock expired 
333             _transactionHash = _addressHash;
334             
335         }
336         else { // Private transaction, hashed with receivers address
337             
338             // Allow a pre-defined receiver to retrieve.
339             _transactionHash = _senderHash;
340         }
341         
342         // Check if the _transactionHash exists and this balance hasn't been received already.
343         // We would normally do this with a require(), but to keep it more private we need the 
344         // method to be executed also if it will not result.
345         if (balances[_transactionHash] == 0) {
346             emit RetrieveSuccess(0);
347             return false;    
348         }
349         
350         // Check if this SafeGuard has a timelock and if it already has expired.
351         // In case the transaction was sent to a pre-defined address, the sender can retrieve the transaction 1 month after it expired.
352         // We would normally do this with a require(), but to keep it more private we need the 
353         // method to be executed also if it will not result.
354         if (timers[_transactionHash] > now ) {
355             emit RetrieveSuccess(0);
356             return false;
357         }
358         
359         // Prepare to transfer the balance out.
360         uint256 _balance = balances[_transactionHash];
361         balances[_transactionHash] = 0;
362         
363         // Check if the sender allowed for a deviation (up or down) of the value to make tracking harder.
364         // To do this we need to randomize the balance a little so it
365         // become less traceable: To make the tracement harder, we will calculate an 
366         // additional random commission between 0 and the allowed deviation which can be added to or substracted from 
367         // this transfer's balance so the outgoing value is randomized.
368         if (privacyDeviation[_transactionHash] > 0) {
369              _randomPercentage = _randomize(now, privacyDeviation[_transactionHash]);
370         }
371         
372         if(_randomPercentage > 0) {
373             // Calculate the privacy commissions amount in wei.
374             uint256 _privacyCommission = _balance.div(10000).mul(_randomPercentage);
375             
376             // Check integrity of privacyFund
377             if (userBalance.add(privacyFund) > address(this).balance) {
378                 privacyFund = 0;
379             }
380             
381             // Check if we have enough availability in the privacy fund to add to this Retrieve
382             if (_privacyCommission <= privacyFund) {
383                 // we have enough funds to add
384                  privacyFund = privacyFund.sub(_privacyCommission);
385                  userBalance = userBalance.add(_privacyCommission);
386                 _balance = _balance.add(_privacyCommission);
387                
388             } else {
389                 // the privacy fund is not filled enough, you will contribute to it.
390                 _balance = _balance.sub(_privacyCommission);
391                 userBalance = userBalance.sub(_privacyCommission);
392                 privacyFund = privacyFund.add(_privacyCommission);
393             }
394         }
395         
396         // Keep score of total user balance 
397         userBalance = userBalance.sub(_balance);
398         
399         // Transfer the value.
400         msg.sender.transfer(_balance);
401         
402         // Double check that our admin is correct. If not then revert this transaction.
403         assert(address(this).balance >= userBalance);
404         
405         emit RetrieveSuccess(_balance);
406         
407         return true;
408     }
409     
410     /**
411      * @dev Retrieve commissions to the Admin address. 
412      */
413     function RetrieveCommissions() external OnlyByAdmin() {
414         // The fees are the remainder of the contract balance after the userBalance and privacyFund
415         // reservations have been substracted. 
416         uint256 pendingBalance = userBalance.add(privacyFund);
417         uint256 commissions = address(this).balance.sub(pendingBalance);
418         
419         // Transfer the commissions.
420         msg.sender.transfer(commissions);
421         
422         // Double check that our admin is correct.
423         assert(address(this).balance >= userBalance);
424     } 
425     
426     /**
427      * @dev Approve a new admin for this contract. The new admin will have to 
428      * confirm that he is the admin. 
429      * @param _newAdmin the new owner of the contract.
430      */
431     function setAdmin(address _newAdmin) external 
432     OnlyByAdmin() 
433     isAddress(_newAdmin)
434     isNotAdmin(_newAdmin)
435     onlyPayloadSize(32)
436     {
437         pendingAdmin = _newAdmin;
438         emit ContractAdminTransferPending(pendingAdmin, admin);
439     }
440     
441     /**
442      * @dev Let the pending admin confirm his address and become the new admin.
443      */ 
444     function confirmAdmin() external
445     {
446         require(msg.sender==pendingAdmin);
447         address _previousAdmin = admin;
448         admin = pendingAdmin;
449         pendingAdmin = NO_ADDRESS;
450         
451         emit NewContractAdmin(admin, _previousAdmin);
452     }
453     
454     
455     /// PRIVATE METHODS ///
456     /**
457      * @dev Create a (semi) random number.
458      * This is not truely random, as that isn't possible in the blockchain, but 
459      * random enough for our purpose.
460      * 
461      * @param _seed Randomizing seed.
462      * @param _max Max value.
463      */
464     function _randomize(uint256 _seed, uint256 _max) private view returns(uint256 _return) {
465         _return = uint256(keccak256(_seed, block.blockhash(block.number -1), block.difficulty, block.coinbase));
466         return _return % _max;
467     }
468     
469     function _getOriginAddressHash(address _address, string _password) private pure returns(bytes20) {
470         string memory _addressString = toAsciiString(_address);
471         return ripemd160(_password,"0x",_addressString);
472     }
473     
474     function toAsciiString(address x) private pure returns (string) {
475     bytes memory s = new bytes(40);
476         for (uint i = 0; i < 20; i++) {
477             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
478             byte hi = byte(uint8(b) / 16);
479             byte lo = byte(uint8(b) - 16 * uint8(hi));
480             s[2*i] = char(hi);
481             s[2*i+1] = char(lo);            
482         }
483         return string(s);
484     }
485     
486     function char(byte b) private pure returns (byte c) {
487         if (b < 10) return byte(uint8(b) + 0x30);
488         else return byte(uint8(b) + 0x57);
489     }
490 }
491 
492 /**
493  * @title SafeMath
494  * @dev Math operations with safety checks that throw on error
495  */
496 library SafeMath {
497 
498   /**
499   * @dev Multiplies two numbers, throws on overflow.
500   */
501   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
502     if (a == 0) {
503       return 0;
504     }
505     uint256 c = a * b;
506     assert(c / a == b);
507     return c;
508   }
509 
510   /**
511   * @dev Integer division of two numbers, truncating the quotient.
512   */
513   function div(uint256 a, uint256 b) internal pure returns (uint256) {
514     // assert(b > 0); // Solidity automatically throws when dividing by 0
515     uint256 c = a / b;
516     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
517     return c;
518   }
519 
520   /**
521   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
522   */
523   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
524     assert(b <= a);
525     return a - b;
526   }
527 
528   /**
529   * @dev Adds two numbers, throws on overflow.
530   */
531   function add(uint256 a, uint256 b) internal pure returns (uint256) {
532     uint256 c = a + b;
533     assert(c >= a);
534     return c;
535   }
536 }