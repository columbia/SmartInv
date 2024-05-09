1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20
5  * @dev A standard interface for tokens.
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
7  */
8 contract ERC20 {
9   
10     /// @dev Returns the total token supply
11     function totalSupply() public constant returns (uint256 supply);
12 
13     /// @dev Returns the account balance of the account with address _owner
14     function balanceOf(address _owner) public constant returns (uint256 balance);
15 
16     /// @dev Transfers _value number of tokens to address _to
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     /// @dev Transfers _value number of tokens from address _from to address _to
20     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
21 
22     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
23     function approve(address _spender, uint256 _value) public returns (bool success);
24 
25     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
26     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31 }
32 
33 contract Fundraiser {
34 
35     event Beginning(
36         bytes32 _causeSecret
37     );
38 
39     event Participation(
40         address _participant,
41         bytes32 _message,
42         uint256 _entries,
43         uint256 _refund
44     );
45 
46     event Raise(
47         address _participant,
48         uint256 _entries,
49         uint256 _refund
50     );
51 
52     event Revelation(
53         bytes32 _causeMessage
54     );
55 
56     event Selection(
57         address _participant,
58         bytes32 _participantMessage,
59         bytes32 _causeMessage,
60         bytes32 _ownerMessage
61     );
62 
63     event Cancellation();
64 
65     event Withdrawal(
66         address _address
67     );
68 
69     struct Deployment {
70         address _cause;
71         address _causeWallet;
72         uint256 _causeSplit;
73         uint256 _participantSplit;
74         address _owner;
75         address _ownerWallet;
76         uint256 _ownerSplit;
77         bytes32 _ownerSecret;
78         uint256 _valuePerEntry;
79         uint256 _deployTime;
80         uint256 _endTime;
81         uint256 _expireTime;
82         uint256 _destructTime;
83         uint256 _entropy;
84     }
85 
86     struct State {
87         bytes32 _causeSecret;
88         bytes32 _causeMessage;
89         bool _causeWithdrawn;
90         address _participant;
91         bool _participantWithdrawn;
92         bytes32 _ownerMessage;
93         bool _ownerWithdrawn;
94         bool _cancelled;
95         uint256 _participants;
96         uint256 _entries;
97         uint256 _revealBlockNumber;
98         uint256 _revealBlockHash;
99     }
100 
101     struct Participant {
102         bytes32 _message;
103         uint256 _entries;
104     }
105 
106     struct Fund {
107         address _participant;
108         uint256 _entries;
109     }
110 
111     modifier onlyOwner() {
112         require(msg.sender == deployment._owner);
113         _;
114     }
115 
116     modifier neverOwner() {
117         require(msg.sender != deployment._owner);
118         require(msg.sender != deployment._ownerWallet);
119         _;
120     }
121 
122     modifier onlyCause() {
123         require(msg.sender == deployment._cause);
124         _;
125     }
126 
127     modifier neverCause() {
128         require(msg.sender != deployment._cause);
129         require(msg.sender != deployment._causeWallet);
130         _;
131     }
132 
133     modifier participationPhase() {
134         require(now < deployment._endTime);
135         _;
136     }
137 
138     modifier recapPhase() {
139         require((now >= deployment._endTime) && (now < deployment._expireTime));
140         _;
141     }
142 
143     modifier destructionPhase() {
144         require(now >= deployment._destructTime);
145         _;
146     }
147     
148     Deployment public deployment;
149     mapping(address => Participant) public participants;
150     Fund[] private funds;
151     State private _state;
152 
153     function Fundraiser(
154         address _cause,
155         address _causeWallet,
156         uint256 _causeSplit,
157         uint256 _participantSplit,
158         address _ownerWallet,
159         uint256 _ownerSplit,
160         bytes32 _ownerSecret,
161         uint256 _valuePerEntry,
162         uint256 _endTime,
163         uint256 _expireTime,
164         uint256 _destructTime,
165         uint256 _entropy
166     ) public {
167         require(_cause != 0x0);
168         require(_causeWallet != 0x0);
169         require(_causeSplit != 0);
170         require(_participantSplit != 0);
171         require(_ownerWallet != 0x0);
172         require(_causeSplit + _participantSplit + _ownerSplit == 1000);
173         require(_ownerSecret != 0x0);
174         require(_valuePerEntry != 0);
175         require(_endTime > now); // participation phase
176         require(_expireTime > _endTime); // end phase
177         require(_destructTime > _expireTime); // destruct phase
178         require(_entropy > 0);
179 
180         // set the deployment
181         deployment = Deployment(
182             _cause,
183             _causeWallet,
184             _causeSplit,
185             _participantSplit,
186             msg.sender,
187             _ownerWallet,
188             _ownerSplit,
189             _ownerSecret,
190             _valuePerEntry,
191             now,
192             _endTime,
193             _expireTime,
194             _destructTime,
195             _entropy
196         );
197 
198     }
199 
200     // returns the post-deployment state of the contract
201     function state() public view returns (
202         bytes32 _causeSecret,
203         bytes32 _causeMessage,
204         bool _causeWithdrawn,
205         address _participant,
206         bytes32 _participantMessage,
207         bool _participantWithdrawn,
208         bytes32 _ownerMessage,
209         bool _ownerWithdrawn,
210         bool _cancelled,
211         uint256 _participants,
212         uint256 _entries
213     ) {
214         _causeSecret = _state._causeSecret;
215         _causeMessage = _state._causeMessage;
216         _causeWithdrawn = _state._causeWithdrawn;
217         _participant = _state._participant;
218         _participantMessage = participants[_participant]._message;
219         _participantWithdrawn = _state._participantWithdrawn;
220         _ownerMessage = _state._ownerMessage;
221         _ownerWithdrawn = _state._ownerWithdrawn;
222         _cancelled = _state._cancelled;
223         _participants = _state._participants;
224         _entries = _state._entries;
225     }
226 
227     // returns the balance of a cause, selected participant, owner, or participant (refund)
228     function balance() public view returns (uint256) {
229         // check for fundraiser ended normally
230         if (_state._participant != address(0)) {
231             // selected, get split
232             uint256 _split;
233             // determine split based on sender
234             if (msg.sender == deployment._cause) {
235                 if (_state._causeWithdrawn) {
236                     return 0;
237                 }
238                 _split = deployment._causeSplit;
239             } else if (msg.sender == _state._participant) {
240                 if (_state._participantWithdrawn) {
241                     return 0;
242                 }
243                 _split = deployment._participantSplit;
244             } else if (msg.sender == deployment._owner) {
245                 if (_state._ownerWithdrawn) {
246                     return 0;
247                 }
248                 _split = deployment._ownerSplit;
249             } else {
250                 return 0;
251             }
252             // multiply total entries by split % (non-revealed winnings are forfeited)
253             return _state._entries * deployment._valuePerEntry * _split / 1000;
254         } else if (_state._cancelled) {
255             // value per entry times participant entries == balance
256             Participant storage _participant = participants[msg.sender];
257             return _participant._entries * deployment._valuePerEntry;
258         }
259 
260         return 0;
261     }
262 
263     // called by the cause to begin their fundraiser with their secret
264     function begin(bytes32 _secret) public participationPhase onlyCause {
265         require(!_state._cancelled); // fundraiser not cancelled
266         require(_state._causeSecret == 0x0); // cause has not seeded secret
267         require(_secret != 0x0); // secret cannot be zero
268 
269         // seed cause secret, starting the fundraiser
270         _state._causeSecret = _secret;
271 
272         // broadcast event
273         Beginning(_secret);
274     }
275 
276     // participate in this fundraiser by contributing messages and ether for entries
277     function participate(bytes32 _message) public participationPhase neverCause neverOwner payable {
278         require(!_state._cancelled); // fundraiser not cancelled
279         require(_state._causeSecret != 0x0); // cause has seeded secret
280         require(_message != 0x0); // message cannot be zero
281 
282         // find and check for no existing participant
283         Participant storage _participant = participants[msg.sender];
284         require(_participant._message == 0x0);
285         require(_participant._entries == 0);
286 
287         // add entries to participant
288         var (_entries, _refund) = _raise(_participant);
289         // save participant message, increment total participants
290         _participant._message = _message;
291         _state._participants++;
292 
293         // send out participation update
294         Participation(msg.sender, _message, _entries, _refund);
295     }
296 
297     // called by participate() and the fallback function for obtaining (additional) entries
298     function _raise(Participant storage _participant) private returns (
299         uint256 _entries,
300         uint256 _refund
301     ) {
302         // calculate the number of entries from the wei sent
303         _entries = msg.value / deployment._valuePerEntry;
304         require(_entries >= 1); // ensure we have at least one entry
305         // update participant totals
306         _participant._entries += _entries;
307         _state._entries += _entries;
308 
309         // get previous fund's entries
310         uint256 _previousFundEntries = (funds.length > 0) ?
311             funds[funds.length - 1]._entries : 0;
312         // create and save new fund with cumulative entries
313         Fund memory _fund = Fund(msg.sender, _previousFundEntries + _entries);
314         funds.push(_fund);
315 
316         // calculate partial entry refund
317         _refund = msg.value % deployment._valuePerEntry;
318         // refund any excess wei immediately (partial entry)
319         if (_refund > 0) {
320             msg.sender.transfer(_refund);
321         }
322     }
323 
324     // fallback function that accepts ether for additional entries after an initial participation
325     function () public participationPhase neverCause neverOwner payable {
326         require(!_state._cancelled); // fundraiser not cancelled
327         require(_state._causeSecret != 0x0); // cause has seeded secret
328 
329         // find existing participant
330         Participant storage _participant = participants[msg.sender];
331         require(_participant._message != 0x0); // make sure they participated
332         // forward to raise
333         var (_entries, _refund) = _raise(_participant);
334         
335         // send raise event
336         Raise(msg.sender, _entries, _refund);
337     }
338 
339     // called by the cause to reveal their message after the end time but before the end() function
340     function reveal(bytes32 _message) public recapPhase onlyCause {
341         require(!_state._cancelled); // fundraiser not cancelled
342         require(_state._causeMessage == 0x0); // cannot have revealed already
343         require(_state._revealBlockNumber == 0); // block number of reveal should not be set
344         require(_decode(_state._causeSecret, _message)); // check for valid message
345 
346         // save revealed cause message
347         _state._causeMessage = _message;
348         // save reveal block number
349         _state._revealBlockNumber = block.number;
350 
351         // send reveal event
352         Revelation(_message);
353     }
354 
355     // determines that validity of a message, given a secret
356     function _decode(bytes32 _secret, bytes32 _message) private view returns (bool) {
357         return _secret == keccak256(_message, msg.sender);
358     }
359 
360     // ends this fundraiser, selects a participant to reward, and allocates funds for the cause, the
361     // selected participant, and the contract owner
362     function end(bytes32 _message) public recapPhase onlyOwner {
363         require(!_state._cancelled); // fundraiser not cancelled
364         require(_state._causeMessage != 0x0); // cause must have revealed
365         require(_state._revealBlockNumber != 0); // reveal block number must be set
366         require(_state._ownerMessage == 0x0); // cannot have ended already
367         require(_decode(deployment._ownerSecret, _message)); // check for valid message
368         require(block.number > _state._revealBlockNumber); // verify reveal has been mined
369 
370         // get the (cause) reveal blockhash and ensure within 256 blocks (non-zero)
371         _state._revealBlockHash = uint256(block.blockhash(_state._revealBlockNumber));
372         require(_state._revealBlockHash != 0);
373         // save revealed owner message
374         _state._ownerMessage = _message;
375 
376         bytes32 _randomNumber;
377         address _participant;
378         bytes32 _participantMessage;
379         // add additional entropy to the random from participant messages
380         for (uint256 i = 0; i < deployment._entropy; i++) {
381             // calculate the next random
382             _randomNumber = keccak256(
383                 _message,
384                 _state._causeMessage,
385                 _state._revealBlockHash,
386                 _participantMessage
387             );
388             // calculate next entry and grab corresponding participant
389             uint256 _entry = uint256(_randomNumber) % _state._entries;
390             _participant = _findParticipant(_entry);
391             _participantMessage = participants[_participant]._message;
392         }
393 
394         // the final participant receives the reward
395         _state._participant = _participant;
396         
397         // send out select event
398         Selection(
399             _state._participant,
400             _participantMessage,
401             _state._causeMessage,
402             _message
403         );
404     }
405 
406     // given an entry number, find the corresponding participant (address)
407     function _findParticipant(uint256 _entry) private view returns (address)  {
408         uint256 _leftFundIndex = 0;
409         uint256 _rightFundIndex = funds.length - 1;
410         // loop until participant found
411         while (true) {
412             // first or last fund (edge cases)
413             if (_leftFundIndex == _rightFundIndex) {
414                 return funds[_leftFundIndex]._participant;
415             }
416             // get fund indexes for mid & next
417             uint256 _midFundIndex =
418                 _leftFundIndex + ((_rightFundIndex - _leftFundIndex) / 2);
419             uint256 _nextFundIndex = _midFundIndex + 1;
420             // get mid and next funds
421             Fund memory _midFund = funds[_midFundIndex];
422             Fund memory _nextFund = funds[_nextFundIndex];
423             // binary search
424             if (_entry >= _midFund._entries) {
425                 if (_entry < _nextFund._entries) {
426                     // we are in range, participant found
427                     return _nextFund._participant;
428                 }
429                 // entry is greater, move right
430                 _leftFundIndex = _nextFundIndex;
431             } else {
432                 // entry is less, move left
433                 _rightFundIndex = _midFundIndex;
434             }
435         }
436     }
437 
438     // called by the cause or Seedom before the end time to cancel the fundraiser, refunding all
439     // participants; this function is available to the entire community after the expire time
440     function cancel() public {
441         require(!_state._cancelled); // fundraiser not already cancelled
442         require(_state._participant == address(0)); // selected must not have been chosen
443         
444         // open cancellation to community if past expire time (but before destruct time)
445         if ((msg.sender != deployment._owner) && (msg.sender != deployment._cause)) {
446             require((now >= deployment._expireTime) && (now < deployment._destructTime));
447         }
448 
449         // immediately set us to cancelled
450         _state._cancelled = true;
451 
452         // send out cancellation event
453         Cancellation();
454     }
455 
456     // used to withdraw funds from the contract from an ended fundraiser or refunds when the
457     // fundraiser is cancelled
458     function withdraw() public {
459         // check for a balance
460         uint256 _balance = balance();
461         require (_balance > 0); // can only withdraw a balance
462 
463         address _wallet;
464         // check for fundraiser ended normally
465         if (_state._participant != address(0)) {
466 
467             // determine split based on sender
468             if (msg.sender == deployment._cause) {
469                 _state._causeWithdrawn = true;
470                 _wallet = deployment._causeWallet;
471             } else if (msg.sender == _state._participant) {
472                 _state._participantWithdrawn = true;
473                 _wallet = _state._participant;
474             } else if (msg.sender == deployment._owner) {
475                 _state._ownerWithdrawn = true;
476                 _wallet = deployment._ownerWallet;
477             } else {
478                 revert();
479             }
480 
481         } else if (_state._cancelled) {
482 
483             // set participant entries to zero to prevent multiple refunds
484             Participant storage _participant = participants[msg.sender];
485             _participant._entries = 0;
486             _wallet = msg.sender;
487 
488         } else {
489             // no selected and not cancelled
490             revert();
491         }
492 
493         // execute the refund if we have one
494         _wallet.transfer(_balance);
495         // send withdrawal event
496         Withdrawal(msg.sender);
497     }
498 
499     // destroy() will be used to clean up old contracts from the network
500     function destroy() public destructionPhase onlyOwner {
501         // destroy this contract and send remaining funds to owner
502         selfdestruct(msg.sender);
503     }
504 
505     // recover() allows the owner to recover ERC20 tokens sent to this contract, for later
506     // distribution back to their original holders, upon request
507     function recover(address _token) public onlyOwner {
508         ERC20 _erc20 = ERC20(_token);
509         uint256 _balance = _erc20.balanceOf(this);
510         require(_erc20.transfer(deployment._owner, _balance));
511     }
512 }