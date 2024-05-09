1 pragma solidity ^0.8.12;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `to`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address to, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `from` to `to` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address from,
65         address to,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 interface IFeeDB {
85     event UpdateFeeAndRecipient(uint256 newFee, address newRecipient);
86     event UpdatePaysFeeWhenSending(bool newType);
87     event UpdateNFTDiscountRate(address nft, uint256 discountRate);
88     event UpdateUserDiscountRate(address user, uint256 discountRate);
89 
90     function protocolFee() external view returns (uint256);
91 
92     function protocolFeeRecipient() external view returns (address);
93 
94     function paysFeeWhenSending() external view returns (bool);
95 
96     function userDiscountRate(address user) external view returns (uint256);
97 
98     function nftDiscountRate(address nft) external view returns (uint256);
99 
100     function getFeeDataForSend(address user, bytes calldata data)
101         external
102         view
103         returns (
104             bool _paysFeeWhenSending,
105             address _recipient,
106             uint256 _protocolFee,
107             uint256 _discountRate
108         );
109 
110     function getFeeDataForReceive(address user, bytes calldata data)
111         external
112         view
113         returns (address _recipient, uint256 _discountRate);
114 }
115 
116 interface IAPMReservoir {
117     function token() external returns (address);
118 
119     event AddSigner(address signer);
120     event RemoveSigner(address signer);
121     event UpdateFeeDB(IFeeDB newFeeDB);
122     event UpdateQuorum(uint256 newQuorum);
123     event SendToken(
124         address indexed sender,
125         uint256 indexed toChainId,
126         address indexed receiver,
127         uint256 amount,
128         uint256 sendingId,
129         bool isFeePayed,
130         uint256 protocolFee,
131         uint256 senderDiscountRate
132     );
133     event ReceiveToken(
134         address indexed sender,
135         uint256 indexed fromChainId,
136         address indexed receiver,
137         uint256 amount,
138         uint256 sendingId
139     );
140     event SetChainValidity(uint256 indexed chainId, bool status);
141     event Migrate(address newReservoir);
142     event TransferFee(address user, address feeRecipient, uint256 amount);
143 
144     function getSigners() external view returns (address[] memory);
145 
146     function signingNonce() external view returns (uint256);
147 
148     function quorum() external view returns (uint256);
149 
150     function feeDB() external view returns (IFeeDB);
151 
152     function signersLength() external view returns (uint256);
153 
154     function isSigner(address signer) external view returns (bool);
155 
156     function isValidChain(uint256 toChainId) external view returns (bool);
157 
158     function sendingData(
159         address sender,
160         uint256 toChainId,
161         address receiver,
162         uint256 sendingId
163     )
164         external
165         view
166         returns (
167             uint256 amount,
168             uint256 atBlock,
169             bool isFeePayed,
170             uint256 protocolFee,
171             uint256 senderDiscountRate
172         );
173 
174     function isTokenReceived(
175         address sender,
176         uint256 fromChainId,
177         address receiver,
178         uint256 sendingId
179     ) external view returns (bool);
180 
181     function sendingCounts(
182         address sender,
183         uint256 toChainId,
184         address receiver
185     ) external view returns (uint256);
186 
187     function sendToken(
188         uint256 toChainId,
189         address receiver,
190         uint256 amount,
191         bytes calldata data
192     ) external returns (uint256 sendingId);
193 
194     function receiveToken(
195         address sender,
196         uint256 fromChainId,
197         address receiver,
198         uint256 amount,
199         uint256 sendingId,
200         bool isFeePayed,
201         uint256 protocolFee,
202         uint256 senderDiscountRate,
203         bytes calldata data,
204         uint8[] calldata vs,
205         bytes32[] calldata rs,
206         bytes32[] calldata ss
207     ) external;
208 }
209 
210 library Signature {
211     function recover(
212         bytes32 hash,
213         uint8 v,
214         bytes32 r,
215         bytes32 s
216     ) internal pure returns (address signer) {
217         require(
218             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
219             "invalid signature 's' value"
220         );
221         require(v == 27 || v == 28, "invalid signature 'v' value");
222 
223         signer = ecrecover(hash, v, r, s);
224         require(signer != address(0), "invalid signature");
225     }
226 }
227 
228 contract APMReservoir is IAPMReservoir {
229     address[] private signers;
230     mapping(address => uint256) private signerIndex;
231     uint256 public signingNonce;
232     uint256 public quorum;
233 
234     IFeeDB public feeDB;
235     address public immutable token;
236 
237     constructor(
238         address _token,
239         uint256 _quorum,
240         IFeeDB _feeDB,
241         address[] memory _signers
242     ) {
243         require(_token != address(0), "invalid token address");
244         token = _token;
245 
246         require(_quorum > 0, "invalid quorum");
247         quorum = _quorum;
248         emit UpdateQuorum(_quorum);
249 
250         require(_signers.length > _quorum, "signers should be more than quorum");
251         signers = _signers;
252 
253         for (uint256 i = 0; i < _signers.length; i++) {
254             address signer = _signers[i];
255             require(signer != address(0), "invalid signer");
256             require(signerIndex[signer] == 0, "already added");
257 
258             signerIndex[signer] = i + 1;
259             emit AddSigner(signer);
260         }
261 
262         require(address(_feeDB) != address(0), "invalid feeDB address");
263         feeDB = _feeDB;
264         emit UpdateFeeDB(_feeDB);
265 
266         isValidChain[8217] = true;
267         emit SetChainValidity(8217, true);
268     }
269 
270     function signersLength() external view returns (uint256) {
271         return signers.length;
272     }
273 
274     function isSigner(address signer) external view returns (bool) {
275         return signerIndex[signer] != 0;
276     }
277 
278     function getSigners() external view returns (address[] memory) {
279         return signers;
280     }
281 
282     function _checkSigners(
283         bytes32 message,
284         uint8[] memory vs,
285         bytes32[] memory rs,
286         bytes32[] memory ss
287     ) private view {
288         uint256 length = vs.length;
289         require(length == rs.length && length == ss.length, "length is not equal");
290         require(length >= quorum, "signatures should be quorum or more");
291 
292         address lastSigner;
293         for (uint256 i = 0; i < length; i++) {
294             address signer = Signature.recover(message, vs[i], rs[i], ss[i]);
295             require(lastSigner < signer && signerIndex[signer] != 0, "invalid signer");
296             lastSigner = signer;
297         }
298     }
299 
300     function addSigner(
301         address signer,
302         uint8[] calldata vs,
303         bytes32[] calldata rs,
304         bytes32[] calldata ss
305     ) external {
306         require(signer != address(0), "invalid signer parameter");
307         require(signerIndex[signer] == 0, "already added");
308 
309         bytes32 hash = keccak256(abi.encodePacked("addSigner", block.chainid, address(this), signer, signingNonce++));
310         bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
311         _checkSigners(message, vs, rs, ss);
312 
313         signers.push(signer);
314         signerIndex[signer] = signers.length;
315         emit AddSigner(signer);
316     }
317 
318     function removeSigner(
319         address signer,
320         uint8[] calldata vs,
321         bytes32[] calldata rs,
322         bytes32[] calldata ss
323     ) external {
324         require(signer != address(0), "invalid signer parameter");
325         require(signerIndex[signer] != 0, "not added");
326 
327         bytes32 hash = keccak256(abi.encodePacked("removeSigner", block.chainid, address(this), signer, signingNonce++));
328         bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
329         _checkSigners(message, vs, rs, ss);
330 
331         uint256 lastIndex = signers.length - 1;
332         require(lastIndex > quorum, "signers should be more than quorum");
333 
334         uint256 _signerIndex = signerIndex[signer];
335         uint256 targetIndex = _signerIndex - 1;
336         if (targetIndex != lastIndex) {
337             address lastSigner = signers[lastIndex];
338             signers[targetIndex] = lastSigner;
339             signerIndex[lastSigner] = _signerIndex;
340         }
341 
342         signers.pop();
343         delete signerIndex[signer];
344 
345         emit RemoveSigner(signer);
346     }
347 
348     function updateQuorum(
349         uint256 newQuorum,
350         uint8[] calldata vs,
351         bytes32[] calldata rs,
352         bytes32[] calldata ss
353     ) external {
354         require(newQuorum > 0 && newQuorum < signers.length, "invalid newQuorum parameter");
355 
356         bytes32 hash = keccak256(abi.encodePacked("updateQuorum", block.chainid, address(this), newQuorum, signingNonce++));
357         bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
358         _checkSigners(message, vs, rs, ss);
359 
360         quorum = newQuorum;
361         emit UpdateQuorum(newQuorum);
362     }
363 
364     function updateFeeDB(
365         IFeeDB newDB,
366         uint8[] calldata vs,
367         bytes32[] calldata rs,
368         bytes32[] calldata ss
369     ) external {
370         require(address(newDB) != address(0), "invalid newDB parameter");
371 
372         bytes32 hash = keccak256(abi.encodePacked("updateFeeDB", block.chainid, address(this), newDB, signingNonce++));
373         bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
374         _checkSigners(message, vs, rs, ss);
375 
376         feeDB = newDB;
377         emit UpdateFeeDB(newDB);
378     }
379 
380     struct SendingData {
381         uint256 amount;
382         uint256 atBlock;
383         bool isFeePayed;
384         uint256 protocolFee;
385         uint256 senderDiscountRate;
386     }
387     mapping(address => mapping(uint256 => mapping(address => SendingData[]))) public sendingData;
388     mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => bool)))) public isTokenReceived;
389     mapping(uint256 => bool) public isValidChain;
390 
391     function setChainValidity(
392         uint256 chainId,
393         bool isValid,
394         uint8[] calldata vs,
395         bytes32[] calldata rs,
396         bytes32[] calldata ss
397     ) external {
398         bytes32 hash = keccak256(
399             abi.encodePacked("setChainValidity", block.chainid, address(this), chainId, isValid, signingNonce++)
400         );
401         bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
402         _checkSigners(message, vs, rs, ss);
403 
404         isValidChain[chainId] = isValid;
405         emit SetChainValidity(chainId, isValid);
406     }
407 
408     function sendingCounts(
409         address sender,
410         uint256 toChainId,
411         address receiver
412     ) external view returns (uint256) {
413         return sendingData[sender][toChainId][receiver].length;
414     }
415 
416     function sendToken(
417         uint256 toChainId,
418         address receiver,
419         uint256 amount,
420         bytes calldata data
421     ) external returns (uint256 sendingId) {
422         require(isValidChain[toChainId], "invalid toChainId parameter");
423         require(receiver != address(0), "invalid receiver parameter");
424         require(amount != 0, "invalid amount parameter");
425 
426         (bool paysFee, address feeRecipient, uint256 protocolFee, uint256 senderDiscountRate) = feeDB.getFeeDataForSend(
427             msg.sender,
428             data
429         );
430 
431         sendingId = sendingData[msg.sender][toChainId][receiver].length;
432         sendingData[msg.sender][toChainId][receiver].push(
433             SendingData({
434                 amount: amount,
435                 atBlock: block.number,
436                 isFeePayed: paysFee,
437                 protocolFee: protocolFee,
438                 senderDiscountRate: senderDiscountRate
439             })
440         );
441         _takeAmount(paysFee, feeRecipient, protocolFee, senderDiscountRate, amount);
442         emit SendToken(msg.sender, toChainId, receiver, amount, sendingId, paysFee, protocolFee, senderDiscountRate);
443     }
444 
445     function receiveToken(
446         address sender,
447         uint256 fromChainId,
448         address receiver,
449         uint256 amount,
450         uint256 sendingId,
451         bool isFeePayed,
452         uint256 protocolFee,
453         uint256 senderDiscountRate,
454         bytes memory data,
455         uint8[] memory vs,
456         bytes32[] memory rs,
457         bytes32[] memory ss
458     ) public {
459         require(!isTokenReceived[sender][fromChainId][receiver][sendingId], "already received");
460         {
461             bytes32 hash = keccak256(
462                 abi.encodePacked(
463                     address(this),
464                     fromChainId,
465                     sender,
466                     block.chainid,
467                     receiver,
468                     amount,
469                     sendingId,
470                     isFeePayed,
471                     protocolFee,
472                     senderDiscountRate
473                 )
474             );
475             bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
476             _checkSigners(message, vs, rs, ss);
477         }
478         isTokenReceived[sender][fromChainId][receiver][sendingId] = true;
479         _giveAmount(receiver, amount, isFeePayed, protocolFee, senderDiscountRate, data);
480 
481         emit ReceiveToken(sender, fromChainId, receiver, amount, sendingId);
482     }
483 
484     function _takeAmount(
485         bool paysFee,
486         address feeRecipient,
487         uint256 protocolFee,
488         uint256 discountRate,
489         uint256 amount
490     ) private {
491         require(protocolFee < 100 && discountRate <= 10000, "invalid feeData");
492         if (paysFee && feeRecipient != address(0)) {
493             uint256 feeAmount = (amount * ((protocolFee * (10000 - discountRate)) / 10000)) / 10000;
494             if (feeAmount != 0) {
495                 IERC20(token).transferFrom(msg.sender, feeRecipient, feeAmount);
496                 emit TransferFee(msg.sender, feeRecipient, feeAmount);
497             }
498         }
499         IERC20(token).transferFrom(msg.sender, address(this), amount);
500     }
501 
502     function _giveAmount(
503         address receiver,
504         uint256 amount,
505         bool isFeePayed,
506         uint256 protocolFee,
507         uint256 senderDiscountRate,
508         bytes memory data
509     ) private {
510         uint256 feeAmount;
511         require(protocolFee < 100 && senderDiscountRate <= 10000, "invalid feeDate");
512         if (!isFeePayed && protocolFee != 0 && senderDiscountRate != 10000) {
513             (address feeRecipient, uint256 receiverDiscountRate) = feeDB.getFeeDataForReceive(receiver, data);
514 
515             if (feeRecipient != address(0) && receiverDiscountRate != 10000) {
516                 uint256 maxDiscountRate = senderDiscountRate > receiverDiscountRate
517                     ? senderDiscountRate
518                     : receiverDiscountRate;
519                 feeAmount = (amount * ((protocolFee * (10000 - maxDiscountRate)) / 10000)) / 10000;
520 
521                 if (feeAmount != 0) {
522                     IERC20(token).transfer(feeRecipient, feeAmount);
523                     emit TransferFee(receiver, feeRecipient, feeAmount);
524                 }
525             }
526         }
527         IERC20(token).transfer(receiver, amount - feeAmount);
528     }
529 
530     function migrate(
531         address newReservoir,
532         uint8[] calldata vs,
533         bytes32[] calldata rs,
534         bytes32[] calldata ss
535     ) external {
536         require(newReservoir != address(0), "invalid newReservoir parameter");
537 
538         bytes32 hash = keccak256(abi.encodePacked("migrate", block.chainid, address(this), newReservoir, signingNonce++));
539         bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
540         _checkSigners(message, vs, rs, ss);
541 
542         uint256 ethBalance = address(this).balance;
543         if (ethBalance > 0) {
544             (bool success, ) = payable(newReservoir).call{value: ethBalance}("");
545             require(success, "eth transfer failure");
546         }
547 
548         uint256 ApmBalance = IERC20(token).balanceOf(address(this));
549         if (ApmBalance > 0) IERC20(token).transfer(newReservoir, ApmBalance);
550 
551         emit Migrate(newReservoir);
552     }
553 }