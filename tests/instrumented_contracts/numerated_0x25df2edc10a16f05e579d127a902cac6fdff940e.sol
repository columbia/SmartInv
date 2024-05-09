1 /*
2 
3 The Sale contract manages a token sale.
4 
5 The Sale contract primarily does the following:
6 
7 	- allows individuals to buy tokens during a token sale
8 	- allows individuals to claim the tokens after a successful token sale
9 	- allows individuals to receive an ETH refund after a cancelled token sale
10 	- allows an admin to cancel a token sale, after which individuals can request refunds
11 	- allows an admin to certify a token sale, after which an admin can withdraw contributed ETH
12 	- allows an admin to complete a token sale, after which an individual (following a brief release period) can request their tokens
13 	- allows an admin to return contributed ETH to individuals
14 	- allows an admin to grant tokens to an individual
15 	- allows an admin to withdraw ETH from the token sale
16 	- allows an admin to add and remove individuals from a whitelist
17 	- allows an admin to pause or activate the token sale
18 	
19 The sale runs from a start timestamp to a finish timestamp.  After the release timestamp (assuming a successful sale), individuals can claim their tokens.  If the sale is cancelled, individuals can request a refund.  Furthermore, an admin may return ETH and negate purchases to respective individuals as deemed necessary.  Once the sale is certified or completed, ETH can be withdrawn by the company.
20 
21 The contract creator appoints a delegate to perform most administrative tasks.
22 
23 All events are logged for the purpose of transparency.
24 
25 All math uses SafeMath.
26 
27 ETH and tokens (often referred to as "value" and "tokens" in variable names) are really 1/10^18 of their respective parent units.  Basically, the values represent wei and the token equivalent thereof.
28 
29 */
30 
31 pragma solidity ^0.4.18;
32 
33 contract SafeMath {
34     function safeMul(uint a, uint b) internal returns (uint) {
35         uint c = a * b;
36         assert(a == 0 || c / a == b);
37         return c;
38     }
39 
40     function safeDiv(uint a, uint b) internal returns (uint) {
41         assert(b > 0);
42         uint c = a / b;
43         assert(a == b * c + a % b);
44         return c;
45     }
46 
47     function safeSub(uint a, uint b) internal returns (uint) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     function safeAdd(uint a, uint b) internal returns (uint) {
53         uint c = a + b;
54         assert(c>=a && c>=b);
55         return c;
56     }
57 }
58 
59 contract SaleCallbackInterface {
60     function handleSaleCompletionCallback(uint256 _tokens) external payable returns (bool);
61     function handleSaleClaimCallback(address _recipient, uint256 _tokens) external returns (bool);  
62 }
63 
64 contract Sale is SafeMath {
65     
66     address public creator;		    // address of the contract's creator
67     address public delegate;		// address of an entity allowed to perform administrative functions on behalf of the creator
68     
69     address public marketplace;	    // address of another smart contract that manages the token and Smart Exchange
70     
71     uint256 public start;			// timestamp that the sale begins
72     uint256 public finish;			// timestamp that the sale ends
73     uint256 public release;			// timestamp that sale participants may "claim" their tokens (will be after the finish)
74     
75     uint256 public pricer;			// a multiplier (>= 1) used to determine how many tokens (or, really, 10^18 sub-units of that token) to give purchasers
76     uint256 public size;			// maximum number of 10^18 sub-units of tokens that can be purchased/granted during the sale
77     
78     bool public restricted;		    // whether purchasers and recipients of tokens must be whitelisted manually prior to participating in the sale
79 
80     bool public active;			    // whether individuals are allowed to purchase tokens -- if false, they cannot.  if true, they can or cannot.  
81     								// other factors, like start/finish, size, and others can restrict participation as well, even if active = true.
82     								// this also can remain true indefinitely, even if the token sale has been cancelled or has completed.
83     								
84     
85     int8 public progress;			// -1 = token sale cancelled, 0 = token sale ongoing, 1 = token sale certified (can withdraw ETH while sale is live), 2 = token sale completed
86     
87     uint256 public tokens;			// number of sub-tokens that have been purchased/granted during the sale.  purchases/grants can be reversed while progress = 0 || progress = 1 resulting in tokens going down
88     uint256 public value;			// number of sub-ether (wei) that have been contributed during the sale.  purchases can be resversed while progress = 0 || progress = 1 resulting in value going down
89     
90     uint256 public withdrawls;		// the number of sub-ether (wei) that have been withdrawn by the contract owner
91     uint256 public reserves;		// the number of sub-ether (wei) that have been sent to serve as reserve in the marketplace
92     
93     mapping(address => bool) public participants;			// mapping to record who has participated in the sale (purchased/granted)
94     address[] public participantIndex;						// index of participants
95     
96     mapping(address => uint256) public participantTokens;	// sub-tokens purchased/granted to each participant
97     mapping(address => uint256) public participantValues;	// sub-ether contributed by each participant
98     
99     mapping(address => bool) public participantRefunds;	    // mapping to record who has been awarded a refund after a cancelled sale
100     mapping(address => bool) public participantClaims;		// mapping to record who has claimed their tokens after a completed sale
101     
102     mapping(address => bool) public whitelist;				// mapping to record who has been approved to participate in a "restricted" sale
103     
104     uint256[] public bonuses;								// stores bonus percentages, where even numbered elements store timestamps and odd numbered elements store bonus percentages
105     
106     bool public mutable;									// whether certain properties (like finish and release) of the sale can be updated to increase the liklihood of a successful token sale for all parties involved
107     
108     modifier ifCreator { require(msg.sender == creator); _; }		// if the caller created the contract...
109     modifier ifDelegate { require(msg.sender == delegate); _; }		// if the caller is currently the appointed delegate...
110     modifier ifMutable { require(mutable); _; }						// if the certain properties of the sale can be changed....
111     
112     event Created();																						// the contract was created
113     event Bought(address indexed _buyer, address indexed _recipient, uint256 _tokens, uint256 _value);		// an individual bought tokens
114     event Claimed(address indexed _recipient, uint256 _tokens);												// an individual claimed tokens after the completion of the sale and after tokens were scheduled for release
115     event Refunded(address indexed _recipient, uint256 _value);												// an individual requested a refund of the ETH they contributed after a cancelled token sale
116     event Reversed(address indexed _recipient, uint256 _tokens, uint256 _value);							// an individual was sent the ETH they contributed to the sale and will not receive tokens
117     event Granted(address indexed _recipient, uint256 _tokens);												// an individual was granted tokens, without contributing ETH
118     event Withdrew(address _recipient, uint256 _value);														// the contract creator withdrew ETH from the token sale
119     event Completed(uint256 _tokens, uint256 _value, uint256 _reserves);									// the contract creator signaled that the sale completed successfuly
120     event Certified(uint256 _tokens, uint256 _value);														// the contract creator certified the sale
121     event Cancelled(uint256 _tokens, uint256 _value);														// the contract creator cancelled the sale
122     event Listed(address _participant);																		// an individual was added to the whitelist
123     event Delisted(address _participant);																	// an individual was removed from the whitelist
124     event Paused();																							// the sale was paused (active = false)
125     event Activated();    																					// the sale was activated (active = true)
126 
127     function Sale() {
128         
129         creator = msg.sender;
130         delegate = msg.sender;
131         
132         start = 1;					            // contributions may be made as soon as the contract is published
133         finish = 1535760000;				    // the sale continues through 09/01/2018 @ 00:00:00
134         release = 1536969600;				    // tokens will be available to participants starting 09/15/2018 @ 00:00:00
135         
136         pricer = 100000;					    // each ETH is worth 100,000 tokens
137         
138         size = 10 ** 18 * pricer * 2000 * 2;	// 2,000 ETH, plus a 100% buffer to account for the possibility of a 50% decrease in ETH value during the sale
139 
140         restricted = false;                     // the sale accepts contributions from everyone.  
141                                                 // however, participants who do not submit formal KYC verification before the end of the token sale will have their contributions reverted
142     
143         bonuses = [1, 20];                      // the bonus during the pre-sale starts at 20%
144         
145         mutable = true;                         // certain attributes, such as token sale finish and release dates, may be updated to increase the liklihood of a successful token sale for all parties involved
146         active = true;                          // the token sale is active from the point the contract is published in the form of a pre-sale         
147         
148         Created();
149         Activated();
150     }
151     
152     // returns the number of sub-tokens the calling account purchased/was granted
153     
154     function getMyTokenBalance() external constant returns (uint256) {
155         return participantTokens[msg.sender];
156     }
157     
158     // allows an individual to buy tokens (which will not be issued immediately)
159     // individual instructs the tokens to be delivered to a specific account, which may be different than msg.sender
160     
161     function buy(address _recipient) public payable {
162         
163         // _recipient address must not be all 0's
164         
165         require(_recipient != address(0x0));
166 
167 		// contributor must send more than 1/10 ETH
168 		
169         require(msg.value >= 10 ** 17);
170 
171 		// sale must be considered active
172 		
173         require(active);
174 
175 		// sale must be ongoing or certified
176 
177         require(progress == 0 || progress == 1);
178 
179 		// current timestamp must be greater than or equal to the start of the token sale
180 		
181         require(block.timestamp >= start);
182 
183 		// current timestamp must be less than the end of the token sale
184 		
185         require(block.timestamp < finish);
186 		
187 		// either the token sale isn't restricted, or the sender is on the whitelist
188 
189         require((! restricted) || whitelist[msg.sender]);
190         
191         // either the token sale isn't restricted, or the recipient is on the whitelist
192 
193         require((! restricted) || whitelist[_recipient]);
194         
195         // multiply sub-ether by the pricer (which will be a whole number >= 1) to get sub-tokens
196 
197         uint256 baseTokens = safeMul(msg.value, pricer);
198         
199         // determine how many bonus sub-tokens to award and add that to the base tokens
200         
201         uint256 totalTokens = safeAdd(baseTokens, safeDiv(safeMul(baseTokens, getBonusPercentage()), 100));
202 
203 		// ensure the purchase does not cause the sale to exceed its maximum size
204 		
205         require(safeAdd(tokens, totalTokens) <= size);
206         
207         // if the recipient is new, add them as a participant
208 
209         if (! participants[_recipient]) {
210             participants[_recipient] = true;
211             participantIndex.push(_recipient);
212         }
213         
214         // increment the participant's sub-tokens and sub-ether
215 
216         participantTokens[_recipient] = safeAdd(participantTokens[_recipient], totalTokens);
217         participantValues[_recipient] = safeAdd(participantValues[_recipient], msg.value);
218 
219 		// increment sale sub-tokens and sub-ether
220 
221         tokens = safeAdd(tokens, totalTokens);
222         value = safeAdd(value, msg.value);
223         
224         // log purchase event
225 
226         Bought(msg.sender, _recipient, totalTokens, msg.value);
227     }
228     
229     // token sale participants call this to claim their tokens after the sale is completed and tokens are scheduled for release
230     
231     function claim() external {
232 	    
233 	    // sale must be completed
234         
235         require(progress == 2);
236         
237         // tokens must be scheduled for release
238         
239         require(block.timestamp >= release);
240         
241         // participant must have tokens to claim
242         
243         require(participantTokens[msg.sender] > 0);
244         
245         // participant must not have already claimed tokens
246         
247         require(! participantClaims[msg.sender]);
248         
249 		// record that the participant claimed their tokens
250 
251         participantClaims[msg.sender] = true;
252         
253         // log the event
254         
255         Claimed(msg.sender, participantTokens[msg.sender]);
256         
257         // call the marketplace contract, which will actually issue the tokens to the participant
258         
259         SaleCallbackInterface(marketplace).handleSaleClaimCallback(msg.sender, participantTokens[msg.sender]);
260     }
261     
262     // token sale participants call this to request a refund if the sale was cancelled
263     
264     function refund() external {
265         
266         // the sale must be cancelled
267         
268         require(progress == -1);
269         
270         // the participant must have contributed ETH
271         
272         require(participantValues[msg.sender] > 0);
273         
274         // the participant must not have already requested a refund
275         
276         require(! participantRefunds[msg.sender]);
277         
278 		// record that the participant requested a refund
279         
280         participantRefunds[msg.sender] = true;
281         
282         // log the event
283         
284         Refunded(msg.sender, participantValues[msg.sender]);
285         
286         // transfer contributed ETH back to the participant
287     
288         address(msg.sender).transfer(participantValues[msg.sender]);
289     }    
290     
291     // the contract creator calls this to withdraw contributed ETH to a specific address
292     
293     function withdraw(uint256 _sanity, address _recipient, uint256 _value) ifCreator external {
294         
295         // avoid unintended transaction calls
296         
297         require(_sanity == 100010001);
298         
299         // address must not be 0-value
300         
301         require(_recipient != address(0x0));
302         
303         // token sale must be certified or completed
304         
305         require(progress == 1 || progress == 2);
306         
307         // the amount of ETH in the contract must be greater than the amount the creator is attempting to withdraw
308         
309         require(this.balance >= _value);
310         
311         // increment the amount that's been withdrawn
312         
313         withdrawls = safeAdd(withdrawls, _value);
314         
315         // log the withdrawl
316         
317         Withdrew(_recipient, _value);
318         
319         // send the ETH to the recipient
320         
321         address(_recipient).transfer(_value);
322     } 
323     
324     // the contract owner calls this to complete (finalize/wrap up, etc.) the sale
325     
326     function complete(uint256 _sanity, uint256 _value) ifCreator external {
327         
328         // avoid unintended transaction calls
329         
330         require(_sanity == 101010101);
331 	    
332 	    // the sale must be marked as ongoing or certified (aka, not cancelled -1)
333         
334         require(progress == 0 || progress == 1);
335         
336         // the sale can only be completed after the finish time
337         
338         require(block.timestamp >= finish);
339         
340         // ETH is withdrawn in the process and sent to the marketplace contract.  ensure the amount that is being withdrawn is greater than the balance in the smart contract.
341         
342         require(this.balance >= _value);
343         
344         // mark the sale as completed
345         
346         progress = 2;
347         
348         // the amount that is sent to the other contract is added to the ETH reserve.  denote this amount as reserves.
349         
350         reserves = safeAdd(reserves, _value);
351         
352         // log the completion of the sale, including the number of sub-tokens created by the sale, the amount of net sub-eth received during the sale, and the amount of sub-eth to be added to the reserve
353         
354         Completed(tokens, value, _value);
355         
356         // call the marketplace contract, sending the ETH for the reserve and including the number of sub-tokens 
357         
358         SaleCallbackInterface(marketplace).handleSaleCompletionCallback.value(_value)(tokens);
359     }    
360     
361     // the creator can certify a sale, meaning it cannot be cancelled, and ETH can be withdrawn from the sale by the creator
362     
363     function certify(uint256 _sanity) ifCreator external {
364         
365         // avoid unintended transaction calls
366         
367         require(_sanity == 101011111);
368 	    
369 	    // the sale must be ongoing
370 	    
371         require(progress == 0);
372         
373         // the sale must have started
374         
375         require(block.timestamp >= start);
376         
377         // record that the sale is certified
378         
379         progress = 1;
380         
381         // log the certification
382         
383         Certified(tokens, value);
384     }
385     
386     // the creator can cancel a sale 
387     
388     function cancel(uint256 _sanity) ifCreator external {
389         
390         // avoid unintended transaction calls
391         
392         require(_sanity == 111110101);
393 	    
394 	    // the sale must be ongoing
395 	    
396         require(progress == 0);
397         
398         // record that the sale is cancelled
399         
400         progress = -1;
401         
402         // log the cancellation
403         
404         Cancelled(tokens, value);
405     }    
406     
407     // called by the delegate to reverse purchases/grants for a particular contributor
408     
409     function reverse(address _recipient) ifDelegate external {
410         
411         // the recipient address must not be all 0's
412         
413         require(_recipient != address(0x0));
414         
415         // the sale must be ongoing or certified
416         
417         require(progress == 0 || progress == 1);
418         
419         // the recipient must have contributed ETH and/or received tokens
420         
421         require(participantTokens[_recipient] > 0 || participantValues[_recipient] > 0);
422         
423         uint256 initialParticipantTokens = participantTokens[_recipient];
424         uint256 initialParticipantValue = participantValues[_recipient];
425         
426         // subtract sub-tokens and sub-ether from sale totals
427         
428         tokens = safeSub(tokens, initialParticipantTokens);
429         value = safeSub(value, initialParticipantValue);
430         
431         // reset participant sub-tokens and sub-ether
432         
433         participantTokens[_recipient] = 0;
434         participantValues[_recipient] = 0;
435         
436         // log the reversal, including the initial sub-tokens and initial sub-ether
437         
438         Reversed(_recipient, initialParticipantTokens, initialParticipantValue);
439         
440         // if the participant previously sent ETH, return it
441         
442         if (initialParticipantValue > 0) {
443             address(_recipient).transfer(initialParticipantValue);
444         }
445     }
446     
447     // called by the delegate to grant tokens to a recipient
448     
449     function grant(address _recipient, uint256 _tokens) ifDelegate external {
450         
451        	// the recipient's address cannot be 0-value
452        
453         require(_recipient != address(0x0));
454 		
455 		// the sale must be ongoing or certified
456 		
457         require(progress == 0 || progress == 1);
458         
459         // if the recipient has not participated previously, add them as a participant
460         
461         if (! participants[_recipient]) {
462             participants[_recipient] = true;
463             participantIndex.push(_recipient);
464         }
465         
466         // add sub-tokens to the recipient's balance
467         
468         participantTokens[_recipient] = safeAdd(participantTokens[_recipient], _tokens);
469         
470         // add sub-tokens to the sale's total
471         
472         tokens = safeAdd(tokens, _tokens);
473         
474         // log the grant
475         
476         Granted(_recipient, _tokens);
477     }    
478     
479     // adds a set of addresses to the whitelist
480     
481     function list(address[] _addresses) ifDelegate external {
482         for (uint256 i = 0; i < _addresses.length; i++) {
483             whitelist[_addresses[i]] = true;
484             Listed(_addresses[i]);
485         }
486     }
487     
488     // removes a set of addresses from the whitelist
489     
490     function delist(address[] _addresses) ifDelegate external {
491         for (uint256 i = 0; i < _addresses.length; i++) {
492             whitelist[_addresses[i]] = false;
493             Delisted(_addresses[i]);
494         }
495     }  
496     
497 	// pause the sale
498     
499     function pause() ifDelegate external {
500         active = false;
501         Paused();
502     }
503     
504     // activate the sale
505 
506     function activate() ifDelegate external {
507         active = true;
508         Activated();
509     }
510 
511     function setDelegate(address _delegate) ifCreator external {
512         delegate = _delegate;
513     }
514     
515     function setRestricted(bool _restricted) ifDelegate external {
516         restricted = _restricted;
517     }
518     
519     function setMarketplace(address _marketplace) ifCreator ifMutable external {
520         marketplace = _marketplace;
521     }
522     
523     function setBonuses(uint256[] _bonuses) ifDelegate ifMutable external {
524         bonuses = _bonuses;
525     }
526     
527     function setFinish(uint256 _finish) ifDelegate ifMutable external {
528         finish = _finish;
529     }
530 
531     function setRelease(uint256 _release) ifDelegate ifMutable external {
532         release = _release;
533     }     
534     
535     // get the current bonus percentage, as a whole number
536     
537     function getBonusPercentage() public constant returns (uint256) {
538         
539         uint256 finalBonus;
540         
541         uint256 iterativeTimestamp;
542         uint256 iterativeBonus;
543         
544         // within bonuses, even numbered elements store timestamps and odd numbered elements store bonus percentages
545         // timestamps are in order from oldest to newest
546         // iterates over the elements and if the timestamp has been surpassed, the bonus percentage is denoted
547         // the last bonus percentage that was denoted, if one was denoted at all, is the correct bonus percentage at this time
548         
549         for (uint256 i = 0; i < bonuses.length; i++) {
550             if (i % 2 == 0) {
551                 iterativeTimestamp = bonuses[i];
552             } else {
553                 iterativeBonus = bonuses[i];
554                 if (block.timestamp >= iterativeTimestamp) {
555                     finalBonus = iterativeBonus;
556                 }
557             }
558         } 
559         
560         return finalBonus;
561     }    
562     
563     function() public payable {
564         buy(msg.sender);
565     }
566     
567 }