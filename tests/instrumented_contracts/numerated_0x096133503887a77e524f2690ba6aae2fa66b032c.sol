1 contract MyEtherBank
2 {
3     /* LICENSE :
4 
5     MIT License
6 
7     Copyright (c) 2016 Consent Development
8 
9     Permission is hereby granted, free of charge, to any person obtaining a copy
10     of this software and associated documentation files (the "Software"), to deal
11     in the Software without restriction, including without limitation the rights
12     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13     copies of the Software, and to permit persons to whom the Software is
14     furnished to do so, subject to the following conditions:
15 
16     The above copyright notice and this permission notice shall be included in all
17     copies or substantial portions of the Software.
18 
19     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
20     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
21     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
22     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
23     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
24     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
25     SOFTWARE.
26 
27     */
28 	
29     // Author : Alex Darby 
30     // Contact email : consentdev@gmail.com 
31     // Version : 1.0 - initial release
32 	// GitHub : https://github.com/ConsentDevelopment/EtherBank
33     //
34     // 
35 	// This smart contract is free to use but donations are always welcome :
36 	//   Donate Ether - 0x65850dfd9c511a5da3132461d57817f56acc1906
37     //   Donate Bitcoin - 36XRasACPNEvd3YxbLoWWeUfSgCUyZ69z8
38 
39     /* -------- State data -------- */
40 
41     // Owner
42     address private _owner;
43     uint256 private _bankDonationsBalance = 0;
44     bool private _connectBankAccountToNewOwnerAddressEnabled = true;
45 
46     // Bank accounts    
47     struct BankAccount
48     {
49         // Members placed in order for optimization, not readability
50         bool passwordSha3HashSet;
51         uint32 number; 
52         uint32 passwordAttempts;
53         uint256 balance;
54         address owner;       
55         bytes32 passwordSha3Hash;   
56         mapping(bytes32 => bool) passwordSha3HashesUsed;
57     }   
58 
59     struct BankAccountAddress
60     {
61         bool accountSet;
62         uint32 accountNumber; // accountNumber member is used to index the bank accounts array
63     }
64  
65     uint32 private _totalBankAccounts = 0;
66     BankAccount[] private _bankAccountsArray; 
67     mapping(address => BankAccountAddress) private _bankAccountAddresses;  
68 
69 
70     /* -------- Constructor -------- */
71 
72     function MyEtherBank() public
73     {
74         // Set the contract owner
75         _owner = msg.sender; 
76     }
77 
78 
79     /* -------- Events -------- */
80 
81     // Donation
82     event event_donationMadeToBank_ThankYou(uint256 donationAmount);
83     event event_getBankDonationsBalance(uint256 donationBalance);
84     event event_bankDonationsWithdrawn(uint256 donationsAmount);
85 
86     // General banking
87     event event_bankAccountOpened_Successful(address indexed bankAccountOwner, uint32 indexed bankAccountNumber, uint256 indexed depositAmount);
88     event event_getBankAccountNumber_Successful(uint32 indexed bankAccountNumber);
89     event event_getBankAccountBalance_Successful(uint32 indexed bankAccountNumber, uint256 indexed balance);
90     event event_depositMadeToBankAccount_Successful(uint32 indexed bankAccountNumber, uint256 indexed depositAmount); 
91     event event_depositMadeToBankAccount_Failed(uint32 indexed bankAccountNumber, uint256 indexed depositAmount); 
92     event event_depositMadeToBankAccountFromDifferentAddress_Successful(uint32 indexed bankAccountNumber, address indexed addressFrom, uint256 indexed depositAmount);
93     event event_depositMadeToBankAccountFromDifferentAddress_Failed(uint32 indexed bankAccountNumber, address indexed addressFrom, uint256 indexed depositAmount);
94     event event_withdrawalMadeFromBankAccount_Successful(uint32 indexed bankAccountNumber, uint256 indexed withdrawalAmount); 
95     event event_withdrawalMadeFromBankAccount_Failed(uint32 indexed bankAccountNumber, uint256 indexed withdrawalAmount); 
96     event event_transferMadeFromBankAccountToAddress_Successful(uint32 indexed bankAccountNumber, uint256 indexed transferalAmount, address indexed destinationAddress); 
97     event event_transferMadeFromBankAccountToAddress_Failed(uint32 indexed bankAccountNumber, uint256 indexed transferalAmount, address indexed destinationAddress); 
98 
99     // Security
100     event event_securityConnectingABankAccountToANewOwnerAddressIsDisabled();
101     event event_securityHasPasswordSha3HashBeenAddedToBankAccount_Yes(uint32 indexed bankAccountNumber);
102     event event_securityHasPasswordSha3HashBeenAddedToBankAccount_No(uint32 indexed bankAccountNumber);
103 	event event_securityPasswordSha3HashAddedToBankAccount_Successful(uint32 indexed bankAccountNumber);
104     event event_securityPasswordSha3HashAddedToBankAccount_Failed_PasswordHashPreviouslyUsed(uint32 indexed bankAccountNumber);
105     event event_securityBankAccountConnectedToNewAddressOwner_Successful(uint32 indexed bankAccountNumber, address indexed newAddressOwner);
106     event event_securityBankAccountConnectedToNewAddressOwner_Failed_PasswordHashHasNotBeenAddedToBankAccount(uint32 indexed bankAccountNumber);
107     event event_securityBankAccountConnectedToNewAddressOwner_Failed_SentPasswordDoesNotMatchAccountPasswordHash(uint32 indexed bankAccountNumber, uint32 indexed passwordAttempts);
108     event event_securityGetNumberOfAttemptsToConnectBankAccountToANewOwnerAddress(uint32 indexed bankAccountNumber, uint32 indexed attempts);
109 
110 
111     /* -------- Modifiers -------- */
112 
113     modifier modifier_isContractOwner()
114     { 
115         // Contact owner?
116         if (msg.sender != _owner)
117         {
118             throw;       
119         }
120         _ 
121     }
122 
123     modifier modifier_doesSenderHaveABankAccount() 
124     { 
125         // Does this sender have a bank account?
126         if (_bankAccountAddresses[msg.sender].accountSet == false)
127         {
128             throw;
129         }
130         else
131         {
132             // Does the bank account owner address match the sender address?
133             uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber;
134             if (msg.sender != _bankAccountsArray[accountNumber_].owner)
135             {
136                 // Sender address previously had a bank account that was transfered to a new owner address
137                 throw;        
138             }
139         }
140         _ 
141     }
142 
143     modifier modifier_wasValueSent()
144     { 
145         // Value sent?
146         if (msg.value > 0)
147         {
148             // Prevent users from sending value accidentally
149             throw;        
150         }
151         _ 
152     }
153 
154 
155     /* -------- Contract owner functions -------- */
156 
157     function Donate() public
158     {
159         if (msg.value > 0)
160         {
161             _bankDonationsBalance += msg.value;
162             event_donationMadeToBank_ThankYou(msg.value);
163         }
164     }
165 
166     function BankOwner_GetDonationsBalance() public      
167         modifier_isContractOwner()
168         modifier_wasValueSent()
169         returns (uint256)
170     {
171         event_getBankDonationsBalance(_bankDonationsBalance);
172   	    return _bankDonationsBalance;
173     }
174 
175     function BankOwner_WithdrawDonations() public
176         modifier_isContractOwner()
177         modifier_wasValueSent()
178     { 
179         if (_bankDonationsBalance > 0)
180         {
181             uint256 amount_ = _bankDonationsBalance;
182             _bankDonationsBalance = 0;
183 
184             // Check if using send() is successful
185             if (msg.sender.send(amount_))
186             {
187                 event_bankDonationsWithdrawn(amount_);
188             }
189             // Check if using call.value() is successful
190             else if (msg.sender.call.value(amount_)())
191             {  
192                 event_bankDonationsWithdrawn(amount_);
193             }
194             else
195             {
196                 // Set the previous balance
197                 _bankDonationsBalance = amount_;
198             }
199         }
200     }
201 
202     function BankOwner_EnableConnectBankAccountToNewOwnerAddress() public
203         modifier_isContractOwner()
204     { 
205         if (_connectBankAccountToNewOwnerAddressEnabled == false)
206         {
207             _connectBankAccountToNewOwnerAddressEnabled = true;
208         }
209     }
210 
211     function  BankOwner_DisableConnectBankAccountToNewOwnerAddress() public
212         modifier_isContractOwner()
213     { 
214         if (_connectBankAccountToNewOwnerAddressEnabled)
215         {
216             _connectBankAccountToNewOwnerAddressEnabled = false;
217         }
218     }
219 
220 
221     /* -------- General bank account functions -------- */
222 
223     // Open bank account
224     function OpenBankAccount() public
225         returns (uint32 newBankAccountNumber) 
226     {
227         // Does this sender already have a bank account or a previously used address for a bank account?
228         if (_bankAccountAddresses[msg.sender].accountSet)
229         {
230             throw;
231         }
232 
233         // Assign the new bank account number
234         newBankAccountNumber = _totalBankAccounts;
235 
236         // Add new bank account to the array
237         _bankAccountsArray.push( 
238             BankAccount(
239             {
240                 passwordSha3HashSet: false,
241                 passwordAttempts: 0,
242                 number: newBankAccountNumber,
243                 balance: 0,
244                 owner: msg.sender,
245                 passwordSha3Hash: "0",
246             }
247             ));
248 
249         // Prevent people using "password" or "Password" sha3 hash for the Security_AddPasswordSha3HashToBankAccount() function
250         bytes32 passwordHash_ = sha3("password");
251         _bankAccountsArray[newBankAccountNumber].passwordSha3HashesUsed[passwordHash_] = true;
252         passwordHash_ = sha3("Password");
253         _bankAccountsArray[newBankAccountNumber].passwordSha3HashesUsed[passwordHash_] = true;
254 
255         // Add the new account
256         _bankAccountAddresses[msg.sender].accountSet = true;
257         _bankAccountAddresses[msg.sender].accountNumber = newBankAccountNumber;
258 
259         // Value sent?
260         if (msg.value > 0)
261         {         
262             _bankAccountsArray[newBankAccountNumber].balance += msg.value;
263         }
264 
265         // Move to the next bank account
266         _totalBankAccounts++;
267 
268         // Event
269         event_bankAccountOpened_Successful(msg.sender, newBankAccountNumber, msg.value);
270         return newBankAccountNumber;
271     }
272 
273     // Get account number from a owner address
274     function GetBankAccountNumber() public      
275         modifier_doesSenderHaveABankAccount()
276         modifier_wasValueSent()
277         returns (uint32)
278     {
279         event_getBankAccountNumber_Successful(_bankAccountAddresses[msg.sender].accountNumber);
280 	    return _bankAccountAddresses[msg.sender].accountNumber;
281     }
282 
283     function GetBankAccountBalance() public
284         modifier_doesSenderHaveABankAccount()
285         modifier_wasValueSent()
286         returns (uint256)
287     {   
288         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber;
289         event_getBankAccountBalance_Successful(accountNumber_, _bankAccountsArray[accountNumber_].balance);
290         return _bankAccountsArray[accountNumber_].balance;
291     }
292 
293 
294     /* -------- Deposit functions -------- */
295 
296     function DepositToBankAccount() public
297         modifier_doesSenderHaveABankAccount()
298         returns (bool)
299     {
300         // Value sent?
301         if (msg.value > 0)
302         {
303             uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
304 
305             // Check for overflow  
306             if ((_bankAccountsArray[accountNumber_].balance + msg.value) < _bankAccountsArray[accountNumber_].balance)
307             {
308                 throw;
309             }
310 
311             _bankAccountsArray[accountNumber_].balance += msg.value; 
312             event_depositMadeToBankAccount_Successful(accountNumber_, msg.value);
313             return true;
314         }
315         else
316         {
317             event_depositMadeToBankAccount_Failed(accountNumber_, msg.value);
318             return false;
319         }
320     }
321 
322     function DepositToBankAccountFromDifferentAddress(uint32 bankAccountNumber) public
323         returns (bool)
324     {
325         // Check if bank account number is valid
326         if (bankAccountNumber >= _totalBankAccounts)
327         {
328            event_depositMadeToBankAccountFromDifferentAddress_Failed(bankAccountNumber, msg.sender, msg.value);
329            return false;     
330         }    
331             
332         // Value sent?
333         if (msg.value > 0)
334         {   
335             // Check for overflow  
336             if ((_bankAccountsArray[bankAccountNumber].balance + msg.value) < _bankAccountsArray[bankAccountNumber].balance)
337             {
338                 throw;
339             }
340 
341             _bankAccountsArray[bankAccountNumber].balance += msg.value; 
342             event_depositMadeToBankAccountFromDifferentAddress_Successful(bankAccountNumber, msg.sender, msg.value);
343             return true;
344         }
345         else
346         {
347             event_depositMadeToBankAccountFromDifferentAddress_Failed(bankAccountNumber, msg.sender, msg.value);
348             return false;
349         }
350     }
351     
352 
353     /* -------- Withdrawal / transfer functions -------- */
354 
355     function WithdrawAmountFromBankAccount(uint256 amount) public
356         modifier_doesSenderHaveABankAccount()
357         modifier_wasValueSent()
358         returns (bool)
359     {
360         bool withdrawalSuccessful_ = false;
361         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
362 
363         // Bank account has value that can be withdrawn?
364         if (amount > 0 && _bankAccountsArray[accountNumber_].balance >= amount)
365         {
366             // Reduce the account balance 
367             _bankAccountsArray[accountNumber_].balance -= amount;
368 
369             // Check if using send() is successful
370             if (msg.sender.send(amount))
371             {
372  	            withdrawalSuccessful_ = true;
373             }
374             // Check if using call.value() is successful
375             else if (msg.sender.call.value(amount)())
376             {  
377                 withdrawalSuccessful_ = true;
378             }  
379             else
380             {
381                 // Set the previous balance
382                 _bankAccountsArray[accountNumber_].balance += amount;
383             }
384         }
385 
386         if (withdrawalSuccessful_)
387         {
388             event_withdrawalMadeFromBankAccount_Successful(accountNumber_, amount); 
389             return true;
390         }
391         else
392         {
393             event_withdrawalMadeFromBankAccount_Failed(accountNumber_, amount); 
394             return false;
395         }
396     }
397 
398     function WithdrawFullBalanceFromBankAccount() public
399         modifier_doesSenderHaveABankAccount()
400         modifier_wasValueSent()
401         returns (bool)
402     {
403         bool withdrawalSuccessful_ = false;
404         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
405         uint256 fullBalance_ = 0;
406 
407         // Bank account has value that can be withdrawn?
408         if (_bankAccountsArray[accountNumber_].balance > 0)
409         {
410             fullBalance_ = _bankAccountsArray[accountNumber_].balance;
411 
412             // Reduce the account balance 
413             _bankAccountsArray[accountNumber_].balance = 0;
414 
415             // Check if using send() is successful
416             if (msg.sender.send(fullBalance_))
417             {
418  	            withdrawalSuccessful_ = true;
419             }
420             // Check if using call.value() is successful
421             else if (msg.sender.call.value(fullBalance_)())
422             {  
423                 withdrawalSuccessful_ = true;
424             }  
425             else
426             {
427                 // Set the previous balance
428                 _bankAccountsArray[accountNumber_].balance = fullBalance_;
429             }
430         }  
431 
432         if (withdrawalSuccessful_)
433         {
434             event_withdrawalMadeFromBankAccount_Successful(accountNumber_, fullBalance_); 
435             return true;
436         }
437         else
438         {
439             event_withdrawalMadeFromBankAccount_Failed(accountNumber_, fullBalance_); 
440             return false;
441         }
442     }
443 
444     function TransferAmountFromBankAccountToAddress(uint256 amount, address destinationAddress) public
445         modifier_doesSenderHaveABankAccount()
446         modifier_wasValueSent()
447         returns (bool)
448     {
449         bool transferSuccessful_ = false; 
450         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
451 
452         // Bank account has value that can be transfered?
453         if (amount > 0 && _bankAccountsArray[accountNumber_].balance >= amount)
454         {
455             // Reduce the account balance 
456             _bankAccountsArray[accountNumber_].balance -= amount; 
457 
458             // Check if using send() is successful
459             if (destinationAddress.send(amount))
460             {
461  	            transferSuccessful_ = true;
462             }
463             // Check if using call.value() is successful
464             else if (destinationAddress.call.value(amount)())
465             {  
466                 transferSuccessful_ = true;
467             }  
468             else
469             {
470                 // Set the previous balance
471                 _bankAccountsArray[accountNumber_].balance += amount;
472             }
473         }  
474 
475         if (transferSuccessful_)
476         {
477             event_transferMadeFromBankAccountToAddress_Successful(accountNumber_, amount, destinationAddress); 
478             return true;
479         }
480         else
481         {
482             event_transferMadeFromBankAccountToAddress_Failed(accountNumber_, amount, destinationAddress); 
483             return false;
484         }
485     }
486 
487 
488     /* -------- Security functions -------- */
489 
490     function Security_HasPasswordSha3HashBeenAddedToBankAccount() public
491         modifier_doesSenderHaveABankAccount()
492         modifier_wasValueSent()
493         returns (bool)
494     {
495         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
496 
497         // Password sha3 hash added to the account?
498         if (_bankAccountsArray[accountNumber_].passwordSha3HashSet)
499         {
500             event_securityHasPasswordSha3HashBeenAddedToBankAccount_Yes(accountNumber_);
501             return true;
502         }
503         else
504         {
505             event_securityHasPasswordSha3HashBeenAddedToBankAccount_No(accountNumber_);
506             return false;
507         }
508     }
509 
510     function Security_AddPasswordSha3HashToBankAccount(bytes32 sha3Hash) public
511         modifier_doesSenderHaveABankAccount()
512         modifier_wasValueSent()
513         returns (bool)
514     {
515         // VERY IMPORTANT -
516         // 
517         // Ethereum uses KECCAK-256. It should be noted that it does not follow the FIPS-202 based standard (a.k.a SHA-3), 
518         // which was finalized in August 2015.
519         // 
520         // Keccak-256 generator link (produces same output as solidity sha3()) - http://emn178.github.io/online-tools/keccak_256.html
521             
522         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
523 
524         // Has this password hash been used before for this account?
525         if (_bankAccountsArray[accountNumber_].passwordSha3HashesUsed[sha3Hash] == true)
526         {
527             event_securityPasswordSha3HashAddedToBankAccount_Failed_PasswordHashPreviouslyUsed(accountNumber_);
528             return false;        
529         }
530 
531         // Set the account password sha3 hash
532         _bankAccountsArray[accountNumber_].passwordSha3HashSet = true;
533         _bankAccountsArray[accountNumber_].passwordSha3Hash = sha3Hash;
534         _bankAccountsArray[accountNumber_].passwordSha3HashesUsed[sha3Hash] = true;
535 
536         // Reset password attempts
537         _bankAccountsArray[accountNumber_].passwordAttempts = 0;
538 
539         event_securityPasswordSha3HashAddedToBankAccount_Successful(accountNumber_);
540         return true;
541     }
542 
543     function Security_ConnectBankAccountToNewOwnerAddress(uint32 bankAccountNumber, string password) public
544         modifier_wasValueSent()
545         returns (bool)
546     {
547         // VERY IMPORTANT -
548         // 
549         // Ethereum uses KECCAK-256. It should be noted that it does not follow the FIPS-202 based standard (a.k.a SHA-3), 
550         // which was finalized in August 2015.
551         // 
552         // Keccak-256 generator link (produces same output as solidity sha3()) - http://emn178.github.io/online-tools/keccak_256.html
553 
554         // Can bank accounts be connected to a new owner address?
555         if (_connectBankAccountToNewOwnerAddressEnabled == false)
556         {
557             event_securityConnectingABankAccountToANewOwnerAddressIsDisabled();
558             return false;        
559         }
560 
561         // Check if bank account number is valid
562         if (bankAccountNumber >= _totalBankAccounts)
563         {
564             return false;     
565         }    
566 
567         // Does the sender already have a bank account?
568         if (_bankAccountAddresses[msg.sender].accountSet)
569         {
570             // A owner address can only have one bank account
571             return false;
572         }
573 
574         // Has password sha3 hash been set?
575         if (_bankAccountsArray[bankAccountNumber].passwordSha3HashSet == false)
576         {
577             event_securityBankAccountConnectedToNewAddressOwner_Failed_PasswordHashHasNotBeenAddedToBankAccount(bankAccountNumber);
578             return false;           
579         }
580 
581         // Check if the password sha3 hash matches.
582         bytes memory passwordString = bytes(password);
583         if (sha3(passwordString) != _bankAccountsArray[bankAccountNumber].passwordSha3Hash)
584         {
585             // Keep track of the number of attempts to connect a bank account to a new owner address
586             _bankAccountsArray[bankAccountNumber].passwordAttempts++;  
587             event_securityBankAccountConnectedToNewAddressOwner_Failed_SentPasswordDoesNotMatchAccountPasswordHash(bankAccountNumber, _bankAccountsArray[bankAccountNumber].passwordAttempts); 
588             return false;        
589         }
590 
591         // Set new bank account address owner and the update the owner address details 
592         _bankAccountsArray[bankAccountNumber].owner = msg.sender;
593         _bankAccountAddresses[msg.sender].accountSet = true;
594         _bankAccountAddresses[msg.sender].accountNumber = bankAccountNumber;
595 
596         // Reset password sha3 hash
597         _bankAccountsArray[bankAccountNumber].passwordSha3HashSet = false;
598         _bankAccountsArray[bankAccountNumber].passwordSha3Hash = "0";
599        
600         // Reset password attempts
601         _bankAccountsArray[bankAccountNumber].passwordAttempts = 0;
602 
603         event_securityBankAccountConnectedToNewAddressOwner_Successful(bankAccountNumber, msg.sender);
604         return true;
605     }
606 
607     function Security_GetNumberOfAttemptsToConnectBankAccountToANewOwnerAddress() public
608         modifier_doesSenderHaveABankAccount()
609         modifier_wasValueSent()
610         returns (uint64)
611     {
612         uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber; 
613         event_securityGetNumberOfAttemptsToConnectBankAccountToANewOwnerAddress(accountNumber_, _bankAccountsArray[accountNumber_].passwordAttempts);
614         return _bankAccountsArray[accountNumber_].passwordAttempts;
615     }
616 
617 
618     /* -------- Default function -------- */
619 
620     function() 
621     {    
622         // Does this sender have a bank account?
623         if (_bankAccountAddresses[msg.sender].accountSet)
624         {
625             // Does the bank account owner address match the sender address?
626             uint32 accountNumber_ = _bankAccountAddresses[msg.sender].accountNumber;
627             address accountOwner_ = _bankAccountsArray[accountNumber_].owner;
628             if (msg.sender == accountOwner_) 
629             {
630                 // Value sent?
631                 if (msg.value > 0)
632                 {                
633                     // Check for overflow
634                     if ((_bankAccountsArray[accountNumber_].balance + msg.value) < _bankAccountsArray[accountNumber_].balance)
635                     {
636                         throw;
637                     }
638  
639                     // Update the bank account balance
640                     _bankAccountsArray[accountNumber_].balance += msg.value;
641                     event_depositMadeToBankAccount_Successful(accountNumber_, msg.value);
642                 }
643                 else
644                 {
645                     throw;
646                 }
647             }
648             else
649             {
650                 // Sender address previously had a bank account that was transfered to a new owner address
651                 throw;
652             }
653         }
654         else
655         {
656             // Open a new bank account for the sender address - this function will also add any value sent to the bank account balance
657             OpenBankAccount();
658         }
659     }
660 }