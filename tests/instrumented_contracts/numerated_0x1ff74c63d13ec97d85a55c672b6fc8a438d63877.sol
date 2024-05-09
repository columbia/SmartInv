1 pragma solidity ^0.4.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Owned {
34 
35     // The address of the account that is the current owner
36     address public owner;
37 
38     // Contract which manage issuing of new tokens (airdrop and referral tokens) 
39     address public issuer;
40 
41     // The publiser is the inital owner
42     function Owned() {
43         owner = msg.sender;
44     }
45 
46     /**
47      * Restricted access to the current owner
48      */
49     modifier onlyOwner() {
50         if (msg.sender != owner) throw;
51         _;
52     }
53 
54     /**
55      * Restricted access to the issuer and owner
56      */
57     modifier onlyIssuer() {
58         if (msg.sender != owner && msg.sender != issuer) throw;
59         _;
60     }
61 
62     /**
63      * Transfer ownership to `_newOwner`
64      *
65      * @param _newOwner The address of the account that will become the new owner
66      */
67     function transferOwnership(address _newOwner) onlyOwner {
68         owner = _newOwner;
69     }
70 }
71 
72 // Abstract contract for the full ERC 20 Token standard
73 // https://github.com/ethereum/EIPs/issues/20
74 contract Token {
75     /// total amount of tokens
76     uint256 public totalSupply;
77 
78     /// @param _owner The address from which the balance will be retrieved
79     /// @return The balance
80     function balanceOf(address _owner) constant returns (uint256 balance);
81 
82     /// @notice send `_value` token to `_to` from `msg.sender`
83     /// @param _to The address of the recipient
84     /// @param _value The amount of token to be transferred
85     /// @return Whether the transfer was successful or not
86     function transfer(address _to, uint256 _value) returns (bool success);
87 
88     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
89     /// @param _from The address of the sender
90     /// @param _to The address of the recipient
91     /// @param _value The amount of token to be transferred
92     /// @return Whether the transfer was successful or not
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
94 
95     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
96     /// @param _spender The address of the account able to transfer the tokens
97     /// @param _value The amount of tokens to be approved for transfer
98     /// @return Whether the approval was successful or not
99     function approve(address _spender, uint256 _value) returns (bool success);
100 
101     /// @param _owner The address of the account owning tokens
102     /// @param _spender The address of the account able to transfer the tokens
103     /// @return Amount of remaining tokens allowed to spent
104     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
105 
106     event Transfer(address indexed _from, address indexed _to, uint256 _value);
107     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
108 }
109 
110 /**
111  * @title Mail token
112  *
113  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition
114  * of ownership, a lock and issuing.
115  *
116  */
117 contract Mail is Owned, Token {
118 
119     using SafeMath for uint256;
120 
121     // Ethereum token standaard
122     string public standard = "Token 0.2";
123 
124     // Full name
125     string public name = "Ethereum Mail";
126 
127     // Symbol
128     string public symbol = "MAIL";
129 
130     // No decimal points
131     uint8 public decimals = 0;
132     
133     // Token distribution
134     uint256 public freeToUseTokens = 10 * 10 ** 6; // 10 million tokens are free to use
135 
136     // List of available tokens for attachment
137     mapping (bytes32 => Token) public tokens;
138     
139     // No decimal points
140     uint256 public maxTotalSupply = 10 ** 9; // 1 billion
141 
142     // Token starts if the locked state restricting transfers
143     bool public locked;
144 
145     mapping (address => uint256) public balances;
146     mapping (address => uint256) public usableBalances;
147     mapping (address => mapping (address => uint256)) public allowed;
148     
149     uint256 public currentMessageNumber;
150     
151     struct Message {
152         bytes32 content;
153         uint256 weight;
154         uint256 validUntil;
155         uint256 time;
156         bytes32 attachmentSymbol;
157         uint256 attachmentValue;
158         address from;
159         address[] to;
160         address[] read;
161     }
162     
163     mapping (uint256 => Message) messages;
164     
165     struct UnreadMessage {
166         uint256 id;
167         bool isOpened;
168         bool free;
169         address from;
170         uint256 time;
171         uint256 weight;
172     }
173     
174     mapping (address => UnreadMessage[]) public unreadMessages;
175     mapping (address => uint256) public unreadMessageCount;
176     uint[] indexesUnread;
177     uint[] indexesRead;
178     mapping (address => uint256) public lastReceivedMessage;
179 
180     /**
181      * Set up issuer
182      *
183      * @param _issuer The address of the account that will become the new issuer
184      */
185     function setIssuer(address _issuer) onlyOwner {
186         issuer = _issuer;
187     }
188     
189     /**
190      * Unlocks the token irreversibly so that the transfering of value is enabled
191      *
192      * @return Whether the unlocking was successful or not
193      */
194     function unlock() onlyOwner returns (bool success)  {
195         locked = false;
196         return true;
197     }
198     
199     /**
200      * Everyone can call this function to invalidate mail if its validation time is already in past  
201      *
202      * @param _number Number od unread messages
203      */
204     function invalidateMail(uint256 _number) {
205         if (messages[_number].validUntil >= now) {
206             throw;
207         }
208         
209         if (messages[_number].attachmentSymbol.length != 0x0 && messages[_number].attachmentValue > 0) {
210             Token token = tokens[messages[_number].attachmentSymbol];
211             token.transfer(messages[_number].from, messages[_number].attachmentValue.mul(messages[_number].to.length.sub(messages[_number].read.length)).div(messages[_number].to.length));
212         }
213         
214         uint256 i = 0;
215         while (i < messages[_number].to.length) {
216             address recipient = messages[_number].to[i];
217 
218             for (uint a = 0; a < unreadMessages[recipient].length; ++a) {
219                 if (unreadMessages[recipient][a].id == _number) {
220 
221                     if (!unreadMessages[recipient][a].isOpened) {
222                         unreadMessages[recipient][a].weight = 0;
223                         unreadMessages[recipient][a].time = 0;
224 
225                         uint256 value = messages[_number].weight.div(messages[_number].to.length);
226 
227                         unreadMessageCount[recipient]--;
228                         balances[recipient] = balances[recipient].sub(value);
229 
230                         if (!unreadMessages[recipient][a].free) {
231                             usableBalances[messages[_number].from] = usableBalances[messages[_number].from].add(value);
232                             balances[messages[_number].from] = balances[messages[_number].from].add(value);
233                         }
234                     }
235 
236                     break;
237                 }
238             }
239             
240             i++;
241         }
242     }
243     
244     /**
245      * Returns number of unread messages for specific user
246      *
247      * @param _userAddress Address of user
248      * @return Number od unread messages
249      */
250     function getUnreadMessageCount(address _userAddress) constant returns (uint256 count)  {
251         uint256 unreadCount;
252         for (uint i = 0; i < unreadMessageCount[_userAddress]; ++i) {
253             if (unreadMessages[_userAddress][i].isOpened == false) {
254                 unreadCount++;    
255             }
256         }
257         
258         return unreadCount;
259     }
260     
261 
262     /**
263      * Returns unread messages for current user
264      * 
265      * @param _userAddress Address of user
266      * @return Unread messages as array of message numbers
267      */
268     function getUnreadMessages(address _userAddress) constant returns (uint[] mmessages)  {
269         for (uint i = 0; i < unreadMessageCount[_userAddress]; ++i) {
270             if (unreadMessages[_userAddress][i].isOpened == false) {
271                 indexesUnread.push(unreadMessages[_userAddress][i].id);
272             }
273         }
274         
275         return indexesUnread;
276     }
277 
278 
279     function getUnreadMessagesArrayContent(uint256 _number) public constant returns(uint256, bool, address, uint256, uint256) {
280         for (uint a = 0; a < unreadMessageCount[msg.sender]; ++a) {
281             if (unreadMessages[msg.sender][a].id == _number) {
282                 return (unreadMessages[msg.sender][a].id,unreadMessages[msg.sender][a].isOpened,unreadMessages[msg.sender][a].from, unreadMessages[msg.sender][a].time,unreadMessages[msg.sender][a].weight);
283             }
284         }
285     }
286 
287     /**
288      * Returns read messages for current user
289      * 
290      * @param _userAddress Address of user
291      * @return Read messages as array of message numbers
292      */
293     function getReadMessages(address _userAddress) constant returns (uint[] mmessages)  {        
294         for (uint i = 0; i < unreadMessageCount[_userAddress]; ++i) {
295             if (unreadMessages[_userAddress][i].isOpened == true) {
296                 indexesRead.push(unreadMessages[_userAddress][i].id);
297             }
298         }
299         
300         return indexesRead;
301     }
302     
303     /**
304      * Add token which will can be used as attachment
305      * 
306      * @param _tokenAddress Address of token contract
307      * @param _symbol Symbol of token
308      * @return If action was successful
309      */
310     function addToken(address _tokenAddress, bytes32 _symbol) onlyOwner returns (bool success)  {
311         Token token = Token(_tokenAddress);
312         tokens[_symbol] = token;
313         
314         return true;
315     }
316 
317     /**
318      * Locks the token irreversibly so that the transfering of value is not enabled
319      *
320      * @return Whether the locking was successful or not
321      */
322     function lock() onlyOwner returns (bool success)  {
323         locked = true;
324         return true;
325     }
326     
327     /**
328      * Restricted access to the current owner
329      */
330     modifier onlyOwner() {
331         if (msg.sender != owner) throw;
332         _;
333     }
334     
335     /**
336      * Get balance of `_owner`
337      *
338      * @param _owner The address from which the balance will be retrieved
339      * @return The balance
340      */
341     function balanceOf(address _owner) constant returns (uint256 balance) {
342         return balances[_owner];
343     }
344     
345     /**
346      * Prevents accidental sending of ether
347      */
348     function () {
349         throw;
350     }
351 
352     /**
353      * Send `_value` token to `_to` from `msg.sender`
354      *
355      * @param _to The address of the recipient
356      * @param _value The amount of token to be transferred
357      * @return Whether the transfer was successful or not
358      */
359     function transfer(address _to, uint256 _value) returns (bool success) {
360 
361         // Unable to transfer while still locked
362         if (locked) {
363             throw;
364         }
365 
366         // Check if the sender has enough tokens
367         if (balances[msg.sender] < _value || usableBalances[msg.sender] < _value) {
368             throw;
369         }
370 
371         // Check for overflows
372         if (balances[_to] + _value < balances[_to])  {
373             throw;
374         }
375 
376         // Transfer tokens
377         balances[msg.sender] -= _value;
378         balances[_to] += _value;
379         
380         usableBalances[msg.sender] -= _value;
381         usableBalances[_to] += _value;
382 
383         // Notify listners
384         Transfer(msg.sender, _to, _value);
385 
386         return true;
387     }
388 
389     /**
390      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
391      *
392      * @param _from The address of the sender
393      * @param _to The address of the recipient
394      * @param _value The amount of token to be transferred
395      * @return Whether the transfer was successful or not
396      */
397     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
398 
399          // Unable to transfer while still locked
400         if (locked) {
401             throw;
402         }
403 
404         // Check if the sender has enough
405         if (balances[_from] < _value || usableBalances[_from] < _value) {
406             throw;
407         }
408 
409         // Check for overflows
410         if (balances[_to] + _value < balances[_to]) {
411             throw;
412         }
413 
414         // Check allowance
415         if (_value > allowed[_from][msg.sender]) {
416             throw;
417         }
418 
419         // Transfer tokens
420         balances[_to] += _value;
421         balances[_from] -= _value;
422         
423         usableBalances[_from] -= _value;
424         usableBalances[_to] += _value;
425 
426         // Update allowance
427         allowed[_from][msg.sender] -= _value;
428 
429         // Notify listners
430         Transfer(_from, _to, _value);
431         
432         return true;
433     }
434 
435     /**
436      * `msg.sender` approves `_spender` to spend `_value` tokens
437      *
438      * @param _spender The address of the account able to transfer the tokens
439      * @param _value The amount of tokens to be approved for transfer
440      * @return Whether the approval was successful or not
441      */
442     function approve(address _spender, uint256 _value) returns (bool success) {
443 
444         // Unable to approve while still locked
445         if (locked) {
446             throw;
447         }
448 
449         // Update allowance
450         allowed[msg.sender][_spender] = _value;
451 
452         // Notify listners
453         Approval(msg.sender, _spender, _value);
454         return true;
455     }
456 
457 
458     /**
459      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
460      *
461      * @param _owner The address of the account owning tokens
462      * @param _spender The address of the account able to transfer the tokens
463      * @return Amount of remaining tokens allowed to spent
464      */
465     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
466       return allowed[_owner][_spender];
467     }
468 
469     /**
470      * Sends an mail to the specific list of recipients with amount of MAIL tokens to spend on them, hash message, time unti when is 
471      * message available and tokens
472      *
473      * @param _to List of recipients
474      * @param _weight Tokens to be spent on messages
475      * @param _hashedMessage Hashed content of mail
476      * @param _validUntil Mail is available until this specific time when will be returned to sender
477      * @param _attachmentToken Name of attached token
478      * @param _attachmentAmount Amount of attached token
479      */
480     function sendMail(address[] _to, uint256 _weight, bytes32 _hashedMessage, uint256 _validUntil, bytes32 _attachmentToken, uint256 _attachmentAmount) {
481         bool useFreeTokens = false;
482         if (_weight == 0 && freeToUseTokens > 0) {
483             _weight = _to.length;
484             useFreeTokens = true;
485         }
486 
487         if ((!useFreeTokens && usableBalances[msg.sender] < _weight) || _weight < _to.length) {
488             throw;
489         }
490         
491         messages[currentMessageNumber].content = _hashedMessage;
492         messages[currentMessageNumber].validUntil = _validUntil;
493         messages[currentMessageNumber].time = now;
494         messages[currentMessageNumber].from = msg.sender;
495         messages[currentMessageNumber].to = _to;
496         
497         if (_attachmentToken != "") {
498             Token token = tokens[_attachmentToken];
499             
500             if (!token.transferFrom(msg.sender, address(this), _attachmentAmount)) {
501                 throw;
502             }
503             
504             messages[currentMessageNumber].attachmentSymbol = _attachmentToken;
505             messages[currentMessageNumber].attachmentValue = _attachmentAmount;
506         }
507         
508         UnreadMessage memory currentUnreadMessage;
509         currentUnreadMessage.id = currentMessageNumber;
510         currentUnreadMessage.isOpened = false;
511         currentUnreadMessage.from = msg.sender;
512         currentUnreadMessage.time = now;
513         currentUnreadMessage.weight = _weight;
514         currentUnreadMessage.free = useFreeTokens;
515 
516         uint256 i = 0;
517         uint256 duplicateWeight = 0;
518         
519         while (i < _to.length) {
520             if (lastReceivedMessage[_to[i]] == currentMessageNumber) {
521                 i++;
522                 duplicateWeight = duplicateWeight.add(_weight.div(_to.length));
523                 continue;
524             }
525 
526             lastReceivedMessage[_to[i]] = currentMessageNumber;
527         
528             unreadMessages[_to[i]].push(currentUnreadMessage);
529         
530             unreadMessageCount[_to[i]]++;
531             balances[_to[i]] = balances[_to[i]].add(_weight.div(_to.length));
532             i++;
533         }
534         
535         if (useFreeTokens) {
536             freeToUseTokens = freeToUseTokens.sub(_weight.sub(duplicateWeight));
537         } else {
538             usableBalances[msg.sender] = usableBalances[msg.sender].sub(_weight.sub(duplicateWeight));
539             balances[msg.sender] = balances[msg.sender].sub(_weight.sub(duplicateWeight));
540         }  
541 
542         messages[currentMessageNumber].weight = _weight.sub(duplicateWeight);  
543 
544         currentMessageNumber++;
545     }
546     
547     function getUnreadMessage(uint256 _number) constant returns (UnreadMessage unread) {
548         for (uint a = 0; a < unreadMessages[msg.sender].length; ++a) {
549             if (unreadMessages[msg.sender][a].id == _number) {
550                 return unreadMessages[msg.sender][a];
551             }
552         }
553     }
554     
555     /**
556      * Open specific mail for current user who receives MAIL tokens and tokens attached to mail 
557      *
558      * @param _number Number of message recipient is trying to open
559      * @return Success of opeining mail
560      */
561     function openMail(uint256 _number) returns (bool success) {
562         UnreadMessage memory currentUnreadMessage = getUnreadMessage(_number);
563 
564         // throw error if it is already opened or invalidate 
565         if (currentUnreadMessage.isOpened || currentUnreadMessage.weight == 0) {
566             throw;
567         }
568         
569         if (messages[_number].attachmentSymbol != 0x0 && messages[_number].attachmentValue > 0) {
570             Token token = tokens[messages[_number].attachmentSymbol];
571             token.transfer(msg.sender, messages[_number].attachmentValue.div(messages[_number].to.length));
572         }
573         
574         for (uint a = 0; a < unreadMessages[msg.sender].length; ++a) {
575             if (unreadMessages[msg.sender][a].id == _number) {
576                 unreadMessages[msg.sender][a].isOpened = true;
577             }
578         }
579         
580         messages[_number].read.push(msg.sender);
581         
582         usableBalances[msg.sender] = usableBalances[msg.sender].add(messages[_number].weight.div(messages[_number].to.length));
583         
584         return true;
585     }
586     
587     /**
588      * Return opened mail with specific number 
589      *
590      * @param _number Number of message 
591      * @return Mail content
592      */
593     function getMail(uint256 _number) constant returns (bytes32 message) {
594         UnreadMessage memory currentUnreadMessage = getUnreadMessage(_number);
595         if (!currentUnreadMessage.isOpened || currentUnreadMessage.weight == 0) {
596             throw;
597         }
598         
599         return messages[_number].content;
600     }
601     
602     /**
603      * Issuing MAIL tokens  
604      *
605      * @param _recipient Recipient of tokens
606      * @param _value Amount of tokens
607      * @return Success of issuing
608      */
609     function issue(address _recipient, uint256 _value) onlyIssuer returns (bool success) {
610 
611         if (totalSupply.add(_value) > maxTotalSupply) {
612             return;
613         }
614         
615         // Create tokens
616         balances[_recipient] = balances[_recipient].add(_value);
617         usableBalances[_recipient] = usableBalances[_recipient].add(_value);
618         totalSupply = totalSupply.add(_value);
619 
620         return true;
621     }
622     
623     function Mail() {
624         balances[msg.sender] = 0;
625         totalSupply = 0;
626         locked = false;
627     }
628 }