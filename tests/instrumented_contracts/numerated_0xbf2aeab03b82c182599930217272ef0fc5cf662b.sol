1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 // produced by the Solididy File Flattener (c) David Appleton 2018
4 // contact : dave@akomba.com
5 // released under Apache 2.0 licence
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 library ECTools {
14 
15     // @dev Recovers the address which has signed a message
16     // @thanks https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
17     function recoverSigner(bytes32 _hashedMsg, string _sig) public pure returns (address) {
18         require(_hashedMsg != 0x00);
19 
20         // need this for test RPC
21         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
22         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashedMsg));
23 
24         if (bytes(_sig).length != 132) {
25             return 0x0;
26         }
27         bytes32 r;
28         bytes32 s;
29         uint8 v;
30         bytes memory sig = hexstrToBytes(substring(_sig, 2, 132));
31         assembly {
32             r := mload(add(sig, 32))
33             s := mload(add(sig, 64))
34             v := byte(0, mload(add(sig, 96)))
35         }
36         if (v < 27) {
37             v += 27;
38         }
39         if (v < 27 || v > 28) {
40             return 0x0;
41         }
42         return ecrecover(prefixedHash, v, r, s);
43     }
44 
45     // @dev Verifies if the message is signed by an address
46     function isSignedBy(bytes32 _hashedMsg, string _sig, address _addr) public pure returns (bool) {
47         require(_addr != 0x0);
48 
49         return _addr == recoverSigner(_hashedMsg, _sig);
50     }
51 
52     // @dev Converts an hexstring to bytes
53     function hexstrToBytes(string _hexstr) public pure returns (bytes) {
54         uint len = bytes(_hexstr).length;
55         require(len % 2 == 0);
56 
57         bytes memory bstr = bytes(new string(len / 2));
58         uint k = 0;
59         string memory s;
60         string memory r;
61         for (uint i = 0; i < len; i += 2) {
62             s = substring(_hexstr, i, i + 1);
63             r = substring(_hexstr, i + 1, i + 2);
64             uint p = parseInt16Char(s) * 16 + parseInt16Char(r);
65             bstr[k++] = uintToBytes32(p)[31];
66         }
67         return bstr;
68     }
69 
70     // @dev Parses a hexchar, like 'a', and returns its hex value, in this case 10
71     function parseInt16Char(string _char) public pure returns (uint) {
72         bytes memory bresult = bytes(_char);
73         // bool decimals = false;
74         if ((bresult[0] >= 48) && (bresult[0] <= 57)) {
75             return uint(bresult[0]) - 48;
76         } else if ((bresult[0] >= 65) && (bresult[0] <= 70)) {
77             return uint(bresult[0]) - 55;
78         } else if ((bresult[0] >= 97) && (bresult[0] <= 102)) {
79             return uint(bresult[0]) - 87;
80         } else {
81             revert();
82         }
83     }
84 
85     // @dev Converts a uint to a bytes32
86     // @thanks https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity
87     function uintToBytes32(uint _uint) public pure returns (bytes b) {
88         b = new bytes(32);
89         assembly {mstore(add(b, 32), _uint)}
90     }
91 
92     // @dev Hashes the signed message
93     // @ref https://github.com/ethereum/go-ethereum/issues/3731#issuecomment-293866868
94     function toEthereumSignedMessage(string _msg) public pure returns (bytes32) {
95         uint len = bytes(_msg).length;
96         require(len > 0);
97         bytes memory prefix = "\x19Ethereum Signed Message:\n";
98         return keccak256(abi.encodePacked(prefix, uintToString(len), _msg));
99     }
100 
101     // @dev Converts a uint in a string
102     function uintToString(uint _uint) public pure returns (string str) {
103         uint len = 0;
104         uint m = _uint + 0;
105         while (m != 0) {
106             len++;
107             m /= 10;
108         }
109         bytes memory b = new bytes(len);
110         uint i = len - 1;
111         while (_uint != 0) {
112             uint remainder = _uint % 10;
113             _uint = _uint / 10;
114             b[i--] = byte(48 + remainder);
115         }
116         str = string(b);
117     }
118 
119 
120     // @dev extract a substring
121     // @thanks https://ethereum.stackexchange.com/questions/31457/substring-in-solidity
122     function substring(string _str, uint _startIndex, uint _endIndex) public pure returns (string) {
123         bytes memory strBytes = bytes(_str);
124         require(_startIndex <= _endIndex);
125         require(_startIndex >= 0);
126         require(_endIndex <= strBytes.length);
127 
128         bytes memory result = new bytes(_endIndex - _startIndex);
129         for (uint i = _startIndex; i < _endIndex; i++) {
130             result[i - _startIndex] = strBytes[i];
131         }
132         return string(result);
133     }
134 }
135 library SafeMath {
136 
137     /**
138     * @dev Multiplies two numbers, reverts on overflow.
139     */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b);
150 
151         return c;
152     }
153 
154     /**
155     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
156     */
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         require(b > 0); // Solidity only automatically asserts when dividing by 0
159         uint256 c = a / b;
160         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162         return c;
163     }
164 
165     /**
166     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
167     */
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         require(b <= a);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176     * @dev Adds two numbers, reverts on overflow.
177     */
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         require(c >= a);
181 
182         return c;
183     }
184 
185     /**
186     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
187     * reverts when dividing by zero.
188     */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         require(b != 0);
191         return a % b;
192     }
193 }
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 contract ChannelManager {
202     using SafeMath for uint256;
203 
204     string public constant NAME = "Channel Manager";
205     string public constant VERSION = "0.0.1";
206 
207     address public hub;
208     uint256 public challengePeriod;
209     ERC20 public approvedToken;
210 
211     uint256 public totalChannelWei;
212     uint256 public totalChannelToken;
213 
214     event DidHubContractWithdraw (
215         uint256 weiAmount,
216         uint256 tokenAmount
217     );
218 
219     // Note: the payload of DidUpdateChannel contains the state that caused
220     // the update, not the state post-update (ex, if the update contains a
221     // deposit, the event's ``pendingDeposit`` field will be present and the
222     // event's ``balance`` field will not have been updated to reflect that
223     // balance).
224     event DidUpdateChannel (
225         address indexed user,
226         uint256 senderIdx, // 0: hub, 1: user
227         uint256[2] weiBalances, // [hub, user]
228         uint256[2] tokenBalances, // [hub, user]
229         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
230         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
231         uint256[2] txCount, // [global, onchain]
232         bytes32 threadRoot,
233         uint256 threadCount
234     );
235 
236     // Note: unlike the DidUpdateChannel event, the ``DidStartExitChannel``
237     // event will contain the channel state after any state that has been
238     // applied as part of startExitWithUpdate.
239     event DidStartExitChannel (
240         address indexed user,
241         uint256 senderIdx, // 0: hub, 1: user
242         uint256[2] weiBalances, // [hub, user]
243         uint256[2] tokenBalances, // [hub, user]
244         uint256[2] txCount, // [global, onchain]
245         bytes32 threadRoot,
246         uint256 threadCount
247     );
248 
249     event DidEmptyChannel (
250         address indexed user,
251         uint256 senderIdx, // 0: hub, 1: user
252         uint256[2] weiBalances, // [hub, user]
253         uint256[2] tokenBalances, // [hub, user]
254         uint256[2] txCount, // [global, onchain]
255         bytes32 threadRoot,
256         uint256 threadCount
257     );
258 
259     event DidStartExitThread (
260         address user,
261         address indexed sender,
262         address indexed receiver,
263         uint256 threadId,
264         address senderAddress, // either hub or user
265         uint256[2] weiBalances, // [sender, receiver]
266         uint256[2] tokenBalances, // [sender, receiver]
267         uint256 txCount
268     );
269 
270     event DidChallengeThread (
271         address indexed sender,
272         address indexed receiver,
273         uint256 threadId,
274         address senderAddress, // can be either hub, sender, or receiver
275         uint256[2] weiBalances, // [sender, receiver]
276         uint256[2] tokenBalances, // [sender, receiver]
277         uint256 txCount
278     );
279 
280     event DidEmptyThread (
281         address user,
282         address indexed sender,
283         address indexed receiver,
284         uint256 threadId,
285         address senderAddress, // can be anyone
286         uint256[2] channelWeiBalances,
287         uint256[2] channelTokenBalances,
288         uint256[2] channelTxCount,
289         bytes32 channelThreadRoot,
290         uint256 channelThreadCount
291     );
292 
293     event DidNukeThreads(
294         address indexed user,
295         address senderAddress, // can be anyone
296         uint256 weiAmount, // amount of wei sent
297         uint256 tokenAmount, // amount of tokens sent
298         uint256[2] channelWeiBalances,
299         uint256[2] channelTokenBalances,
300         uint256[2] channelTxCount,
301         bytes32 channelThreadRoot,
302         uint256 channelThreadCount
303     );
304 
305     enum ChannelStatus {
306        Open,
307        ChannelDispute,
308        ThreadDispute
309     }
310 
311     struct Channel {
312         uint256[3] weiBalances; // [hub, user, total]
313         uint256[3] tokenBalances; // [hub, user, total]
314         uint256[2] txCount; // persisted onchain even when empty [global, pending]
315         bytes32 threadRoot;
316         uint256 threadCount;
317         address exitInitiator;
318         uint256 channelClosingTime;
319         ChannelStatus status;
320     }
321 
322     struct Thread {
323         uint256[2] weiBalances; // [sender, receiver]
324         uint256[2] tokenBalances; // [sender, receiver]
325         uint256 txCount; // persisted onchain even when empty
326         uint256 threadClosingTime;
327         bool[2] emptied; // [sender, receiver]
328     }
329 
330     mapping(address => Channel) public channels;
331     mapping(address => mapping(address => mapping(uint256 => Thread))) threads; // threads[sender][receiver][threadId]
332 
333     bool locked;
334 
335     modifier onlyHub() {
336         require(msg.sender == hub);
337         _;
338     }
339 
340     modifier noReentrancy() {
341         require(!locked, "Reentrant call.");
342         locked = true;
343         _;
344         locked = false;
345     }
346 
347     constructor(address _hub, uint256 _challengePeriod, address _tokenAddress) public {
348         hub = _hub;
349         challengePeriod = _challengePeriod;
350         approvedToken = ERC20(_tokenAddress);
351     }
352 
353     function hubContractWithdraw(uint256 weiAmount, uint256 tokenAmount) public noReentrancy onlyHub {
354         require(
355             getHubReserveWei() >= weiAmount,
356             "hubContractWithdraw: Contract wei funds not sufficient to withdraw"
357         );
358         require(
359             getHubReserveTokens() >= tokenAmount,
360             "hubContractWithdraw: Contract token funds not sufficient to withdraw"
361         );
362 
363         hub.transfer(weiAmount);
364         require(
365             approvedToken.transfer(hub, tokenAmount),
366             "hubContractWithdraw: Token transfer failure"
367         );
368 
369         emit DidHubContractWithdraw(weiAmount, tokenAmount);
370     }
371 
372     function getHubReserveWei() public view returns (uint256) {
373         return address(this).balance.sub(totalChannelWei);
374     }
375 
376     function getHubReserveTokens() public view returns (uint256) {
377         return approvedToken.balanceOf(address(this)).sub(totalChannelToken);
378     }
379 
380     function hubAuthorizedUpdate(
381         address user,
382         address recipient,
383         uint256[2] weiBalances, // [hub, user]
384         uint256[2] tokenBalances, // [hub, user]
385         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
386         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
387         uint256[2] txCount, // [global, onchain] persisted onchain even when empty
388         bytes32 threadRoot,
389         uint256 threadCount,
390         uint256 timeout,
391         string sigUser
392     ) public noReentrancy onlyHub {
393         Channel storage channel = channels[user];
394 
395         _verifyAuthorizedUpdate(
396             channel,
397             txCount,
398             weiBalances,
399             tokenBalances,
400             pendingWeiUpdates,
401             pendingTokenUpdates,
402             timeout,
403             true
404         );
405 
406         _verifySig(
407             [user, recipient],
408             weiBalances,
409             tokenBalances,
410             pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
411             pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
412             txCount,
413             threadRoot,
414             threadCount,
415             timeout,
416             "", // skip hub sig verification
417             sigUser,
418             [false, true] // [checkHubSig?, checkUser] <- only need to check user
419         );
420 
421         _updateChannelBalances(channel, weiBalances, tokenBalances, pendingWeiUpdates, pendingTokenUpdates);
422 
423         // transfer wei and token to recipient
424         recipient.transfer(pendingWeiUpdates[3]);
425         require(approvedToken.transfer(recipient, pendingTokenUpdates[3]), "user token withdrawal transfer failed");
426 
427         // update state variables
428         channel.txCount = txCount;
429         channel.threadRoot = threadRoot;
430         channel.threadCount = threadCount;
431 
432         emit DidUpdateChannel(
433             user,
434             0, // senderIdx
435             weiBalances,
436             tokenBalances,
437             pendingWeiUpdates,
438             pendingTokenUpdates,
439             txCount,
440             threadRoot,
441             threadCount
442         );
443     }
444 
445     function userAuthorizedUpdate(
446         address recipient,
447         uint256[2] weiBalances, // [hub, user]
448         uint256[2] tokenBalances, // [hub, user]
449         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
450         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
451         uint256[2] txCount, // persisted onchain even when empty
452         bytes32 threadRoot,
453         uint256 threadCount,
454         uint256 timeout,
455         string sigHub
456     ) public payable noReentrancy {
457         require(msg.value == pendingWeiUpdates[2], "msg.value is not equal to pending user deposit");
458 
459         Channel storage channel = channels[msg.sender];
460 
461         _verifyAuthorizedUpdate(
462             channel,
463             txCount,
464             weiBalances,
465             tokenBalances,
466             pendingWeiUpdates,
467             pendingTokenUpdates,
468             timeout,
469             false
470         );
471 
472         _verifySig(
473             [msg.sender, recipient],
474             weiBalances,
475             tokenBalances,
476             pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
477             pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
478             txCount,
479             threadRoot,
480             threadCount,
481             timeout,
482             sigHub,
483             "", // skip user sig verification
484             [true, false] // [checkHubSig?, checkUser] <- only need to check hub
485         );
486 
487         // transfer user token deposit to this contract
488         require(approvedToken.transferFrom(msg.sender, address(this), pendingTokenUpdates[2]), "user token deposit failed");
489 
490         _updateChannelBalances(channel, weiBalances, tokenBalances, pendingWeiUpdates, pendingTokenUpdates);
491 
492         // transfer wei and token to recipient
493         recipient.transfer(pendingWeiUpdates[3]);
494         require(approvedToken.transfer(recipient, pendingTokenUpdates[3]), "user token withdrawal transfer failed");
495 
496         // update state variables
497         channel.txCount = txCount;
498         channel.threadRoot = threadRoot;
499         channel.threadCount = threadCount;
500 
501         emit DidUpdateChannel(
502             msg.sender,
503             1, // senderIdx
504             weiBalances,
505             tokenBalances,
506             pendingWeiUpdates,
507             pendingTokenUpdates,
508             channel.txCount,
509             channel.threadRoot,
510             channel.threadCount
511         );
512     }
513 
514     /**********************
515      * Unilateral Functions
516      *********************/
517 
518     // start exit with onchain state
519     function startExit(
520         address user
521     ) public noReentrancy {
522         require(user != hub, "user can not be hub");
523         require(user != address(this), "user can not be channel manager");
524 
525         Channel storage channel = channels[user];
526         require(channel.status == ChannelStatus.Open, "channel must be open");
527 
528         require(msg.sender == hub || msg.sender == user, "exit initiator must be user or hub");
529 
530         channel.exitInitiator = msg.sender;
531         channel.channelClosingTime = now.add(challengePeriod);
532         channel.status = ChannelStatus.ChannelDispute;
533 
534         emit DidStartExitChannel(
535             user,
536             msg.sender == hub ? 0 : 1,
537             [channel.weiBalances[0], channel.weiBalances[1]],
538             [channel.tokenBalances[0], channel.tokenBalances[1]],
539             channel.txCount,
540             channel.threadRoot,
541             channel.threadCount
542         );
543     }
544 
545     // start exit with offchain state
546     function startExitWithUpdate(
547         address[2] user, // [user, recipient]
548         uint256[2] weiBalances, // [hub, user]
549         uint256[2] tokenBalances, // [hub, user]
550         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
551         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
552         uint256[2] txCount, // [global, onchain] persisted onchain even when empty
553         bytes32 threadRoot,
554         uint256 threadCount,
555         uint256 timeout,
556         string sigHub,
557         string sigUser
558     ) public noReentrancy {
559         Channel storage channel = channels[user[0]];
560         require(channel.status == ChannelStatus.Open, "channel must be open");
561 
562         require(msg.sender == hub || msg.sender == user[0], "exit initiator must be user or hub");
563 
564         require(timeout == 0, "can't start exit with time-sensitive states");
565 
566         _verifySig(
567             user,
568             weiBalances,
569             tokenBalances,
570             pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
571             pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
572             txCount,
573             threadRoot,
574             threadCount,
575             timeout,
576             sigHub,
577             sigUser,
578             [true, true] // [checkHubSig?, checkUser] <- check both sigs
579         );
580 
581         require(txCount[0] > channel.txCount[0], "global txCount must be higher than the current global txCount");
582         require(txCount[1] >= channel.txCount[1], "onchain txCount must be higher or equal to the current onchain txCount");
583 
584         // offchain wei/token balances do not exceed onchain total wei/token
585         require(weiBalances[0].add(weiBalances[1]) <= channel.weiBalances[2], "wei must be conserved");
586         require(tokenBalances[0].add(tokenBalances[1]) <= channel.tokenBalances[2], "tokens must be conserved");
587 
588         // pending onchain txs have been executed - force update offchain state to reflect this
589         if (txCount[1] == channel.txCount[1]) {
590             _applyPendingUpdates(channel.weiBalances, weiBalances, pendingWeiUpdates);
591             _applyPendingUpdates(channel.tokenBalances, tokenBalances, pendingTokenUpdates);
592 
593         // pending onchain txs have *not* been executed - revert pending deposits and withdrawals back into offchain balances
594         } else { //txCount[1] > channel.txCount[1]
595             _revertPendingUpdates(channel.weiBalances, weiBalances, pendingWeiUpdates);
596             _revertPendingUpdates(channel.tokenBalances, tokenBalances, pendingTokenUpdates);
597         }
598 
599         // update state variables
600         // only update txCount[0] (global)
601         // - txCount[1] should only be updated by user/hubAuthorizedUpdate
602         channel.txCount[0] = txCount[0];
603         channel.threadRoot = threadRoot;
604         channel.threadCount = threadCount;
605 
606         channel.exitInitiator = msg.sender;
607         channel.channelClosingTime = now.add(challengePeriod);
608         channel.status = ChannelStatus.ChannelDispute;
609 
610         emit DidStartExitChannel(
611             user[0],
612             msg.sender == hub ? 0 : 1,
613             [channel.weiBalances[0], channel.weiBalances[1]],
614             [channel.tokenBalances[0], channel.tokenBalances[1]],
615             channel.txCount,
616             channel.threadRoot,
617             channel.threadCount
618         );
619     }
620 
621     // party that didn't start exit can challenge and empty
622     function emptyChannelWithChallenge(
623         address[2] user,
624         uint256[2] weiBalances, // [hub, user]
625         uint256[2] tokenBalances, // [hub, user]
626         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
627         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
628         uint256[2] txCount, // persisted onchain even when empty
629         bytes32 threadRoot,
630         uint256 threadCount,
631         uint256 timeout,
632         string sigHub,
633         string sigUser
634     ) public noReentrancy {
635         Channel storage channel = channels[user[0]];
636         require(channel.status == ChannelStatus.ChannelDispute, "channel must be in dispute");
637         require(now < channel.channelClosingTime, "channel closing time must not have passed");
638 
639         require(msg.sender != channel.exitInitiator, "challenger can not be exit initiator");
640         require(msg.sender == hub || msg.sender == user[0], "challenger must be either user or hub");
641 
642         require(timeout == 0, "can't start exit with time-sensitive states");
643 
644         _verifySig(
645             user,
646             weiBalances,
647             tokenBalances,
648             pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
649             pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
650             txCount,
651             threadRoot,
652             threadCount,
653             timeout,
654             sigHub,
655             sigUser,
656             [true, true] // [checkHubSig?, checkUser] <- check both sigs
657         );
658 
659         require(txCount[0] > channel.txCount[0], "global txCount must be higher than the current global txCount");
660         require(txCount[1] >= channel.txCount[1], "onchain txCount must be higher or equal to the current onchain txCount");
661 
662         // offchain wei/token balances do not exceed onchain total wei/token
663         require(weiBalances[0].add(weiBalances[1]) <= channel.weiBalances[2], "wei must be conserved");
664         require(tokenBalances[0].add(tokenBalances[1]) <= channel.tokenBalances[2], "tokens must be conserved");
665 
666         // pending onchain txs have been executed - force update offchain state to reflect this
667         if (txCount[1] == channel.txCount[1]) {
668             _applyPendingUpdates(channel.weiBalances, weiBalances, pendingWeiUpdates);
669             _applyPendingUpdates(channel.tokenBalances, tokenBalances, pendingTokenUpdates);
670 
671         // pending onchain txs have *not* been executed - revert pending deposits and withdrawals back into offchain balances
672         } else { //txCount[1] > channel.txCount[1]
673             _revertPendingUpdates(channel.weiBalances, weiBalances, pendingWeiUpdates);
674             _revertPendingUpdates(channel.tokenBalances, tokenBalances, pendingTokenUpdates);
675         }
676 
677         // deduct hub/user wei/tokens from total channel balances
678         channel.weiBalances[2] = channel.weiBalances[2].sub(channel.weiBalances[0]).sub(channel.weiBalances[1]);
679         channel.tokenBalances[2] = channel.tokenBalances[2].sub(channel.tokenBalances[0]).sub(channel.tokenBalances[1]);
680 
681         // transfer hub wei balance from channel to reserves
682         totalChannelWei = totalChannelWei.sub(channel.weiBalances[0]).sub(channel.weiBalances[1]);
683         // transfer user wei balance to user
684         user[0].transfer(channel.weiBalances[1]);
685         channel.weiBalances[0] = 0;
686         channel.weiBalances[1] = 0;
687 
688         // transfer hub token balance from channel to reserves
689         totalChannelToken = totalChannelToken.sub(channel.tokenBalances[0]).sub(channel.tokenBalances[1]);
690         // transfer user token balance to user
691         require(approvedToken.transfer(user[0], channel.tokenBalances[1]), "user token withdrawal transfer failed");
692         channel.tokenBalances[0] = 0;
693         channel.tokenBalances[1] = 0;
694 
695         // update state variables
696         // only update txCount[0] (global)
697         // - txCount[1] should only be updated by user/hubAuthorizedUpdate
698         channel.txCount[0] = txCount[0];
699         channel.threadRoot = threadRoot;
700         channel.threadCount = threadCount;
701 
702         if (channel.threadCount > 0) {
703             channel.status = ChannelStatus.ThreadDispute;
704         } else {
705             channel.channelClosingTime = 0;
706             channel.status = ChannelStatus.Open;
707         }
708 
709         channel.exitInitiator = address(0x0);
710 
711         emit DidEmptyChannel(
712             user[0],
713             msg.sender == hub ? 0 : 1,
714             [channel.weiBalances[0], channel.weiBalances[1]],
715             [channel.tokenBalances[0], channel.tokenBalances[1]],
716             channel.txCount,
717             channel.threadRoot,
718             channel.threadCount
719         );
720     }
721 
722     // after timer expires - anyone can call; even before timer expires, non-exit-initiating party can call
723     function emptyChannel(
724         address user
725     ) public noReentrancy {
726         require(user != hub, "user can not be hub");
727         require(user != address(this), "user can not be channel manager");
728 
729         Channel storage channel = channels[user];
730         require(channel.status == ChannelStatus.ChannelDispute, "channel must be in dispute");
731 
732         require(
733           channel.channelClosingTime < now ||
734           msg.sender != channel.exitInitiator && (msg.sender == hub || msg.sender == user),
735           "channel closing time must have passed or msg.sender must be non-exit-initiating party"
736         );
737 
738         // deduct hub/user wei/tokens from total channel balances
739         channel.weiBalances[2] = channel.weiBalances[2].sub(channel.weiBalances[0]).sub(channel.weiBalances[1]);
740         channel.tokenBalances[2] = channel.tokenBalances[2].sub(channel.tokenBalances[0]).sub(channel.tokenBalances[1]);
741 
742         // transfer hub wei balance from channel to reserves
743         totalChannelWei = totalChannelWei.sub(channel.weiBalances[0]).sub(channel.weiBalances[1]);
744         // transfer user wei balance to user
745         user.transfer(channel.weiBalances[1]);
746         channel.weiBalances[0] = 0;
747         channel.weiBalances[1] = 0;
748 
749         // transfer hub token balance from channel to reserves
750         totalChannelToken = totalChannelToken.sub(channel.tokenBalances[0]).sub(channel.tokenBalances[1]);
751         // transfer user token balance to user
752         require(approvedToken.transfer(user, channel.tokenBalances[1]), "user token withdrawal transfer failed");
753         channel.tokenBalances[0] = 0;
754         channel.tokenBalances[1] = 0;
755 
756         if (channel.threadCount > 0) {
757             channel.status = ChannelStatus.ThreadDispute;
758         } else {
759             channel.channelClosingTime = 0;
760             channel.status = ChannelStatus.Open;
761         }
762 
763         channel.exitInitiator = address(0x0);
764 
765         emit DidEmptyChannel(
766             user,
767             msg.sender == hub ? 0 : 1,
768             [channel.weiBalances[0], channel.weiBalances[1]],
769             [channel.tokenBalances[0], channel.tokenBalances[1]],
770             channel.txCount,
771             channel.threadRoot,
772             channel.threadCount
773         );
774     }
775 
776     // **********************
777     // THREAD DISPUTE METHODS
778     // **********************
779 
780     // either party starts exit with initial state
781     function startExitThread(
782         address user,
783         address sender,
784         address receiver,
785         uint256 threadId,
786         uint256[2] weiBalances, // [sender, receiver]
787         uint256[2] tokenBalances, // [sender, receiver]
788         bytes proof,
789         string sig
790     ) public noReentrancy {
791         Channel storage channel = channels[user];
792         require(channel.status == ChannelStatus.ThreadDispute, "channel must be in thread dispute phase");
793         require(msg.sender == hub || msg.sender == user, "thread exit initiator must be user or hub");
794         require(user == sender || user == receiver, "user must be thread sender or receiver");
795 
796         require(weiBalances[1] == 0 && tokenBalances[1] == 0, "initial receiver balances must be zero");
797 
798         Thread storage thread = threads[sender][receiver][threadId];
799 
800         require(thread.threadClosingTime == 0, "thread closing time must be zero");
801 
802         _verifyThread(sender, receiver, threadId, weiBalances, tokenBalances, 0, proof, sig, channel.threadRoot);
803 
804         thread.weiBalances = weiBalances;
805         thread.tokenBalances = tokenBalances;
806         thread.threadClosingTime = now.add(challengePeriod);
807 
808         emit DidStartExitThread(
809             user,
810             sender,
811             receiver,
812             threadId,
813             msg.sender,
814             thread.weiBalances,
815             thread.tokenBalances,
816             thread.txCount
817         );
818     }
819 
820     // either party starts exit with offchain state
821     function startExitThreadWithUpdate(
822         address user,
823         address[2] threadMembers, //[sender, receiver]
824         uint256 threadId,
825         uint256[2] weiBalances, // [sender, receiver]
826         uint256[2] tokenBalances, // [sender, receiver]
827         bytes proof,
828         string sig,
829         uint256[2] updatedWeiBalances, // [sender, receiver]
830         uint256[2] updatedTokenBalances, // [sender, receiver]
831         uint256 updatedTxCount,
832         string updateSig
833     ) public noReentrancy {
834         Channel storage channel = channels[user];
835         require(channel.status == ChannelStatus.ThreadDispute, "channel must be in thread dispute phase");
836         require(msg.sender == hub || msg.sender == user, "thread exit initiator must be user or hub");
837         require(user == threadMembers[0] || user == threadMembers[1], "user must be thread sender or receiver");
838 
839         require(weiBalances[1] == 0 && tokenBalances[1] == 0, "initial receiver balances must be zero");
840 
841         Thread storage thread = threads[threadMembers[0]][threadMembers[1]][threadId];
842         require(thread.threadClosingTime == 0, "thread closing time must be zero");
843 
844         _verifyThread(threadMembers[0], threadMembers[1], threadId, weiBalances, tokenBalances, 0, proof, sig, channel.threadRoot);
845 
846         // *********************
847         // PROCESS THREAD UPDATE
848         // *********************
849 
850         require(updatedTxCount > 0, "updated thread txCount must be higher than 0");
851         require(updatedWeiBalances[0].add(updatedWeiBalances[1]) == weiBalances[0], "sum of updated wei balances must match sender's initial wei balance");
852         require(updatedTokenBalances[0].add(updatedTokenBalances[1]) == tokenBalances[0], "sum of updated token balances must match sender's initial token balance");
853 
854         // Note: explicitly set threadRoot == 0x0 because then it doesn't get checked by _isContained (updated state is not part of root)
855         _verifyThread(threadMembers[0], threadMembers[1], threadId, updatedWeiBalances, updatedTokenBalances, updatedTxCount, "", updateSig, bytes32(0x0));
856 
857         thread.weiBalances = updatedWeiBalances;
858         thread.tokenBalances = updatedTokenBalances;
859         thread.txCount = updatedTxCount;
860         thread.threadClosingTime = now.add(challengePeriod);
861 
862         emit DidStartExitThread(
863             user,
864             threadMembers[0],
865             threadMembers[1],
866             threadId,
867             msg.sender == hub ? 0 : 1,
868             thread.weiBalances,
869             thread.tokenBalances,
870             thread.txCount
871         );
872     }
873 
874     // either hub, sender, or receiver can update the thread state in place
875     function challengeThread(
876         address sender,
877         address receiver,
878         uint256 threadId,
879         uint256[2] weiBalances, // updated weiBalances
880         uint256[2] tokenBalances, // updated tokenBalances
881         uint256 txCount,
882         string sig
883     ) public noReentrancy {
884         require(msg.sender == hub || msg.sender == sender || msg.sender == receiver, "only hub, sender, or receiver can call this function");
885 
886         Thread storage thread = threads[sender][receiver][threadId];
887         //verify that thread settlement period has not yet expired
888         require(now < thread.threadClosingTime, "thread closing time must not have passed");
889 
890         // assumes that the non-sender has a later thread state than what was being proposed when the thread exit started
891         require(txCount > thread.txCount, "thread txCount must be higher than the current thread txCount");
892         require(weiBalances[0].add(weiBalances[1]) == thread.weiBalances[0].add(thread.weiBalances[1]), "updated wei balances must match sum of thread wei balances");
893         require(tokenBalances[0].add(tokenBalances[1]) == thread.tokenBalances[0].add(thread.tokenBalances[1]), "updated token balances must match sum of thread token balances");
894 
895         require(weiBalances[1] >= thread.weiBalances[1] && tokenBalances[1] >= thread.tokenBalances[1], "receiver balances may never decrease");
896 
897         // Note: explicitly set threadRoot == 0x0 because then it doesn't get checked by _isContained (updated state is not part of root)
898         _verifyThread(sender, receiver, threadId, weiBalances, tokenBalances, txCount, "", sig, bytes32(0x0));
899 
900         // save the thread balances and txCount
901         thread.weiBalances = weiBalances;
902         thread.tokenBalances = tokenBalances;
903         thread.txCount = txCount;
904 
905         emit DidChallengeThread(
906             sender,
907             receiver,
908             threadId,
909             msg.sender,
910             thread.weiBalances,
911             thread.tokenBalances,
912             thread.txCount
913         );
914     }
915 
916     //After the thread state has been finalized onchain, emptyThread can be called to withdraw funds for each channel separately.
917     function emptyThread(
918         address user,
919         address sender,
920         address receiver,
921         uint256 threadId,
922         uint256[2] weiBalances, // [sender, receiver] -> initial balances
923         uint256[2] tokenBalances, // [sender, receiver] -> initial balances
924         bytes proof,
925         string sig
926     ) public noReentrancy {
927         Channel storage channel = channels[user];
928         require(channel.status == ChannelStatus.ThreadDispute, "channel must be in thread dispute");
929         require(msg.sender == hub || msg.sender == user, "only hub or user can empty thread");
930         require(user == sender || user == receiver, "user must be thread sender or receiver");
931 
932         require(weiBalances[1] == 0 && tokenBalances[1] == 0, "initial receiver balances must be zero");
933 
934         Thread storage thread = threads[sender][receiver][threadId];
935 
936         // We check to make sure that the thread state has been finalized
937         require(thread.threadClosingTime != 0 && thread.threadClosingTime < now, "Thread closing time must have passed");
938 
939         // Make sure user has not emptied before
940         require(!thread.emptied[user == sender ? 0 : 1], "user cannot empty twice");
941 
942         // verify initial thread state.
943         _verifyThread(sender, receiver, threadId, weiBalances, tokenBalances, 0, proof, sig, channel.threadRoot);
944 
945         require(thread.weiBalances[0].add(thread.weiBalances[1]) == weiBalances[0], "sum of thread wei balances must match sender's initial wei balance");
946         require(thread.tokenBalances[0].add(thread.tokenBalances[1]) == tokenBalances[0], "sum of thread token balances must match sender's initial token balance");
947 
948         // deduct sender/receiver wei/tokens about to be emptied from the thread from the total channel balances
949         channel.weiBalances[2] = channel.weiBalances[2].sub(thread.weiBalances[0]).sub(thread.weiBalances[1]);
950         channel.tokenBalances[2] = channel.tokenBalances[2].sub(thread.tokenBalances[0]).sub(thread.tokenBalances[1]);
951 
952         // deduct wei balances from total channel wei and reset thread balances
953         totalChannelWei = totalChannelWei.sub(thread.weiBalances[0]).sub(thread.weiBalances[1]);
954 
955         // if user is receiver, send them receiver wei balance
956         if (user == receiver) {
957             user.transfer(thread.weiBalances[1]);
958         // if user is sender, send them remaining sender wei balance
959         } else if (user == sender) {
960             user.transfer(thread.weiBalances[0]);
961         }
962 
963         // deduct token balances from channel total balances and reset thread balances
964         totalChannelToken = totalChannelToken.sub(thread.tokenBalances[0]).sub(thread.tokenBalances[1]);
965 
966         // if user is receiver, send them receiver token balance
967         if (user == receiver) {
968             require(approvedToken.transfer(user, thread.tokenBalances[1]), "user [receiver] token withdrawal transfer failed");
969         // if user is sender, send them remaining sender token balance
970         } else if (user == sender) {
971             require(approvedToken.transfer(user, thread.tokenBalances[0]), "user [sender] token withdrawal transfer failed");
972         }
973 
974         // Record that user has emptied
975         thread.emptied[user == sender ? 0 : 1] = true;
976 
977         // decrement the channel threadCount
978         channel.threadCount = channel.threadCount.sub(1);
979 
980         // if this is the last thread being emptied, re-open the channel
981         if (channel.threadCount == 0) {
982             channel.threadRoot = bytes32(0x0);
983             channel.channelClosingTime = 0;
984             channel.status = ChannelStatus.Open;
985         }
986 
987         emit DidEmptyThread(
988             user,
989             sender,
990             receiver,
991             threadId,
992             msg.sender,
993             [channel.weiBalances[0], channel.weiBalances[1]],
994             [channel.tokenBalances[0], channel.tokenBalances[1]],
995             channel.txCount,
996             channel.threadRoot,
997             channel.threadCount
998         );
999     }
1000 
1001 
1002     // anyone can call to re-open an account stuck in threadDispute after 10x challengePeriods from channel state finalization
1003     function nukeThreads(
1004         address user
1005     ) public noReentrancy {
1006         require(user != hub, "user can not be hub");
1007         require(user != address(this), "user can not be channel manager");
1008 
1009         Channel storage channel = channels[user];
1010         require(channel.status == ChannelStatus.ThreadDispute, "channel must be in thread dispute");
1011         require(channel.channelClosingTime.add(challengePeriod.mul(10)) < now, "channel closing time must have passed by 10 challenge periods");
1012 
1013         // transfer any remaining channel wei to user
1014         totalChannelWei = totalChannelWei.sub(channel.weiBalances[2]);
1015         user.transfer(channel.weiBalances[2]);
1016         uint256 weiAmount = channel.weiBalances[2];
1017         channel.weiBalances[2] = 0;
1018 
1019         // transfer any remaining channel tokens to user
1020         totalChannelToken = totalChannelToken.sub(channel.tokenBalances[2]);
1021         require(approvedToken.transfer(user, channel.tokenBalances[2]), "user token withdrawal transfer failed");
1022         uint256 tokenAmount = channel.tokenBalances[2];
1023         channel.tokenBalances[2] = 0;
1024 
1025         // reset channel params
1026         channel.threadCount = 0;
1027         channel.threadRoot = bytes32(0x0);
1028         channel.channelClosingTime = 0;
1029         channel.status = ChannelStatus.Open;
1030 
1031         emit DidNukeThreads(
1032             user,
1033             msg.sender,
1034             weiAmount,
1035             tokenAmount,
1036             [channel.weiBalances[0], channel.weiBalances[1]],
1037             [channel.tokenBalances[0], channel.tokenBalances[1]],
1038             channel.txCount,
1039             channel.threadRoot,
1040             channel.threadCount
1041         );
1042     }
1043 
1044     function() external payable {}
1045 
1046     // ******************
1047     // INTERNAL FUNCTIONS
1048     // ******************
1049 
1050     function _verifyAuthorizedUpdate(
1051         Channel storage channel,
1052         uint256[2] txCount,
1053         uint256[2] weiBalances,
1054         uint256[2] tokenBalances, // [hub, user]
1055         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
1056         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
1057         uint256 timeout,
1058         bool isHub
1059     ) internal view {
1060         require(channel.status == ChannelStatus.Open, "channel must be open");
1061 
1062         // Usage:
1063         // 1. exchange operations to protect user from exchange rate fluctuations
1064         // 2. protects hub against user delaying forever
1065         require(timeout == 0 || now < timeout, "the timeout must be zero or not have passed");
1066 
1067         require(txCount[0] > channel.txCount[0], "global txCount must be higher than the current global txCount");
1068         require(txCount[1] >= channel.txCount[1], "onchain txCount must be higher or equal to the current onchain txCount");
1069 
1070         // offchain wei/token balances do not exceed onchain total wei/token
1071         require(weiBalances[0].add(weiBalances[1]) <= channel.weiBalances[2], "wei must be conserved");
1072         require(tokenBalances[0].add(tokenBalances[1]) <= channel.tokenBalances[2], "tokens must be conserved");
1073 
1074         // hub has enough reserves for wei/token deposits for both the user and itself (if isHub, user deposit comes from hub)
1075         if (isHub) {
1076             require(pendingWeiUpdates[0].add(pendingWeiUpdates[2]) <= getHubReserveWei(), "insufficient reserve wei for deposits");
1077             require(pendingTokenUpdates[0].add(pendingTokenUpdates[2]) <= getHubReserveTokens(), "insufficient reserve tokens for deposits");
1078         // hub has enough reserves for only its own wei/token deposits
1079         } else {
1080             require(pendingWeiUpdates[0] <= getHubReserveWei(), "insufficient reserve wei for deposits");
1081             require(pendingTokenUpdates[0] <= getHubReserveTokens(), "insufficient reserve tokens for deposits");
1082         }
1083 
1084         // wei is conserved - the current total channel wei + both deposits > final balances + both withdrawals
1085         require(channel.weiBalances[2].add(pendingWeiUpdates[0]).add(pendingWeiUpdates[2]) >=
1086                 weiBalances[0].add(weiBalances[1]).add(pendingWeiUpdates[1]).add(pendingWeiUpdates[3]), "insufficient wei");
1087 
1088         // token is conserved - the current total channel token + both deposits > final balances + both withdrawals
1089         require(channel.tokenBalances[2].add(pendingTokenUpdates[0]).add(pendingTokenUpdates[2]) >=
1090                 tokenBalances[0].add(tokenBalances[1]).add(pendingTokenUpdates[1]).add(pendingTokenUpdates[3]), "insufficient token");
1091     }
1092 
1093     function _applyPendingUpdates(
1094         uint256[3] storage channelBalances,
1095         uint256[2] balances,
1096         uint256[4] pendingUpdates
1097     ) internal {
1098         // update hub balance
1099         // If the deposit is greater than the withdrawal, add the net of deposit minus withdrawal to the balances.
1100         // Assumes the net has *not yet* been added to the balances.
1101         if (pendingUpdates[0] > pendingUpdates[1]) {
1102             channelBalances[0] = balances[0].add(pendingUpdates[0].sub(pendingUpdates[1]));
1103         // Otherwise, if the deposit is less than or equal to the withdrawal,
1104         // Assumes the net has *already* been added to the balances.
1105         } else {
1106             channelBalances[0] = balances[0];
1107         }
1108 
1109         // update user balance
1110         // If the deposit is greater than the withdrawal, add the net of deposit minus withdrawal to the balances.
1111         // Assumes the net has *not yet* been added to the balances.
1112         if (pendingUpdates[2] > pendingUpdates[3]) {
1113             channelBalances[1] = balances[1].add(pendingUpdates[2].sub(pendingUpdates[3]));
1114 
1115         // Otherwise, if the deposit is less than or equal to the withdrawal,
1116         // Assumes the net has *already* been added to the balances.
1117         } else {
1118             channelBalances[1] = balances[1];
1119         }
1120     }
1121 
1122     function _revertPendingUpdates(
1123         uint256[3] storage channelBalances,
1124         uint256[2] balances,
1125         uint256[4] pendingUpdates
1126     ) internal {
1127         // If the pending update has NOT been executed AND deposits > withdrawals, offchain state was NOT updated with delta, and is thus correct
1128         if (pendingUpdates[0] > pendingUpdates[1]) {
1129             channelBalances[0] = balances[0];
1130 
1131         // If the pending update has NOT been executed AND deposits < withdrawals, offchain state should have been updated with delta, and must be reverted
1132         } else {
1133             channelBalances[0] = balances[0].add(pendingUpdates[1].sub(pendingUpdates[0])); // <- add withdrawal, sub deposit (opposite order as _applyPendingUpdates)
1134         }
1135 
1136         // If the pending update has NOT been executed AND deposits > withdrawals, offchain state was NOT updated with delta, and is thus correct
1137         if (pendingUpdates[2] > pendingUpdates[3]) {
1138             channelBalances[1] = balances[1];
1139 
1140         // If the pending update has NOT been executed AND deposits > withdrawals, offchain state should have been updated with delta, and must be reverted
1141         } else {
1142             channelBalances[1] = balances[1].add(pendingUpdates[3].sub(pendingUpdates[2])); // <- add withdrawal, sub deposit (opposite order as _applyPendingUpdates)
1143         }
1144     }
1145 
1146     function _updateChannelBalances(
1147         Channel storage channel,
1148         uint256[2] weiBalances,
1149         uint256[2] tokenBalances,
1150         uint256[4] pendingWeiUpdates,
1151         uint256[4] pendingTokenUpdates
1152     ) internal {
1153         _applyPendingUpdates(channel.weiBalances, weiBalances, pendingWeiUpdates);
1154         _applyPendingUpdates(channel.tokenBalances, tokenBalances, pendingTokenUpdates);
1155 
1156         totalChannelWei = totalChannelWei.add(pendingWeiUpdates[0]).add(pendingWeiUpdates[2]).sub(pendingWeiUpdates[1]).sub(pendingWeiUpdates[3]);
1157         totalChannelToken = totalChannelToken.add(pendingTokenUpdates[0]).add(pendingTokenUpdates[2]).sub(pendingTokenUpdates[1]).sub(pendingTokenUpdates[3]);
1158 
1159         // update channel total balances
1160         channel.weiBalances[2] = channel.weiBalances[2].add(pendingWeiUpdates[0]).add(pendingWeiUpdates[2]).sub(pendingWeiUpdates[1]).sub(pendingWeiUpdates[3]);
1161         channel.tokenBalances[2] = channel.tokenBalances[2].add(pendingTokenUpdates[0]).add(pendingTokenUpdates[2]).sub(pendingTokenUpdates[1]).sub(pendingTokenUpdates[3]);
1162     }
1163 
1164     function _verifySig (
1165         address[2] user, // [user, recipient]
1166         uint256[2] weiBalances, // [hub, user]
1167         uint256[2] tokenBalances, // [hub, user]
1168         uint256[4] pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
1169         uint256[4] pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
1170         uint256[2] txCount, // [global, onchain] persisted onchain even when empty
1171         bytes32 threadRoot,
1172         uint256 threadCount,
1173         uint256 timeout,
1174         string sigHub,
1175         string sigUser,
1176         bool[2] checks // [checkHubSig?, checkUserSig?]
1177     ) internal view {
1178         require(user[0] != hub, "user can not be hub");
1179         require(user[0] != address(this), "user can not be channel manager");
1180 
1181         // prepare state hash to check hub sig
1182         bytes32 state = keccak256(
1183             abi.encodePacked(
1184                 address(this),
1185                 user, // [user, recipient]
1186                 weiBalances, // [hub, user]
1187                 tokenBalances, // [hub, user]
1188                 pendingWeiUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
1189                 pendingTokenUpdates, // [hubDeposit, hubWithdrawal, userDeposit, userWithdrawal]
1190                 txCount, // persisted onchain even when empty
1191                 threadRoot,
1192                 threadCount,
1193                 timeout
1194             )
1195         );
1196 
1197         if (checks[0]) {
1198             require(hub == ECTools.recoverSigner(state, sigHub), "hub signature invalid");
1199         }
1200 
1201         if (checks[1]) {
1202             require(user[0] == ECTools.recoverSigner(state, sigUser), "user signature invalid");
1203         }
1204     }
1205 
1206     function _verifyThread(
1207         address sender,
1208         address receiver,
1209         uint256 threadId,
1210         uint256[2] weiBalances,
1211         uint256[2] tokenBalances,
1212         uint256 txCount,
1213         bytes proof,
1214         string sig,
1215         bytes32 threadRoot
1216     ) internal view {
1217         require(sender != receiver, "sender can not be receiver");
1218         require(sender != hub && receiver != hub, "hub can not be sender or receiver");
1219         require(sender != address(this) && receiver != address(this), "channel manager can not be sender or receiver");
1220 
1221         bytes32 state = keccak256(
1222             abi.encodePacked(
1223                 address(this),
1224                 sender,
1225                 receiver,
1226                 threadId,
1227                 weiBalances, // [sender, receiver]
1228                 tokenBalances, // [sender, receiver]
1229                 txCount // persisted onchain even when empty
1230             )
1231         );
1232         require(ECTools.isSignedBy(state, sig, sender), "signature invalid");
1233 
1234         if (threadRoot != bytes32(0x0)) {
1235             require(_isContained(state, proof, threadRoot), "initial thread state is not contained in threadRoot");
1236         }
1237     }
1238 
1239     function _isContained(bytes32 _hash, bytes _proof, bytes32 _root) internal pure returns (bool) {
1240         bytes32 cursor = _hash;
1241         bytes32 proofElem;
1242 
1243         for (uint256 i = 64; i <= _proof.length; i += 32) {
1244             assembly { proofElem := mload(add(_proof, i)) }
1245 
1246             if (cursor < proofElem) {
1247                 cursor = keccak256(abi.encodePacked(cursor, proofElem));
1248             } else {
1249                 cursor = keccak256(abi.encodePacked(proofElem, cursor));
1250             }
1251         }
1252 
1253         return cursor == _root;
1254     }
1255 
1256     function getChannelBalances(address user) constant public returns (
1257         uint256 weiHub,
1258         uint256 weiUser,
1259         uint256 weiTotal,
1260         uint256 tokenHub,
1261         uint256 tokenUser,
1262         uint256 tokenTotal
1263     ) {
1264         Channel memory channel = channels[user];
1265         return (
1266             channel.weiBalances[0],
1267             channel.weiBalances[1],
1268             channel.weiBalances[2],
1269             channel.tokenBalances[0],
1270             channel.tokenBalances[1],
1271             channel.tokenBalances[2]
1272         );
1273     }
1274 
1275     function getChannelDetails(address user) constant public returns (
1276         uint256 txCountGlobal,
1277         uint256 txCountChain,
1278         bytes32 threadRoot,
1279         uint256 threadCount,
1280         address exitInitiator,
1281         uint256 channelClosingTime,
1282         ChannelStatus status
1283     ) {
1284         Channel memory channel = channels[user];
1285         return (
1286             channel.txCount[0],
1287             channel.txCount[1],
1288             channel.threadRoot,
1289             channel.threadCount,
1290             channel.exitInitiator,
1291             channel.channelClosingTime,
1292             channel.status
1293         );
1294     }
1295 }