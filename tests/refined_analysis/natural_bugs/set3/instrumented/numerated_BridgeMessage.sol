1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ External Imports ============
5 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
6 
7 library BridgeMessage {
8     // ============ Libraries ============
9 
10     using TypedMemView for bytes;
11     using TypedMemView for bytes29;
12 
13     // ============ Enums ============
14 
15     // WARNING: do NOT re-write the numbers / order
16     // of message types in an upgrade;
17     // will cause in-flight messages to be mis-interpreted
18     // The Types enum has to do with the TypedMemView library and it defines
19     // the types of `views` that we use in BridgeMessage. A view is not interesting data
20     // itself, but rather it points to a specific part of the memory where
21     // the data we care about live. When we give a `type` to a view, we define what type
22     // is the data it points to, so that we can do easy runtime assertions without
23     // having to fetch the whole data from memory and check for ourselves. In BridgeMessage.sol
24     // the types of `data` we can have are defined in this enum and may belong to different taxonomies.
25     // For example, a `Message` includes a `TokenId` and an Action, either a `Transfer` or a `TransferToHook`.
26     // The Message is a different TYPE of data than a TokenId or Transfer, as TokenId and Transfer live inside
27     // the message. For that reason, we define them as different data types and we add them to the same enum
28     // for ease of use.
29     enum Types {
30         Invalid, // 0
31         TokenId, // 1
32         Message, // 2
33         Transfer, // 3
34         DeprecatedFastTransfer, // 4
35         TransferToHook, // 5
36         ExtraData // 6
37     }
38 
39     // ============ Structs ============
40 
41     // Tokens are identified by a TokenId:
42     // domain - 4 byte chain ID of the chain from which the token originates
43     // id - 32 byte identifier of the token address on the origin chain, in that chain's address format
44     struct TokenId {
45         uint32 domain;
46         bytes32 id;
47     }
48 
49     // ============ Constants ============
50 
51     uint256 private constant TOKEN_ID_LEN = 36; // 4 bytes domain + 32 bytes id
52     uint256 private constant IDENTIFIER_LEN = 1;
53     uint256 private constant TRANSFER_LEN = 97; // 1 byte identifier + 32 bytes recipient + 32 bytes amount + 32 bytes detailsHash
54     uint256 private constant MIN_TRANSFER_HOOK_LEN = 129; // 1 byte identifier + 32 bytes hook address + 32 bytes amount + 32 bytes detailsHash + 32 bytes sender + X bytes extraData
55 
56     // ============ Modifiers ============
57 
58     /**
59      * @notice Asserts a message is of type `_t`
60      * @param _view The message
61      * @param _t The expected type
62      */
63     modifier typeAssert(bytes29 _view, Types _t) {
64         _view.assertType(uint40(_t));
65         _;
66     }
67 
68     // ============ Internal Functions ============
69 
70     /**
71      * @notice Checks that Action is valid type
72      * @param _action The action
73      * @return TRUE if action is valid
74      */
75     function isValidAction(bytes29 _action) internal pure returns (bool) {
76         return isTransfer(_action) || isTransferToHook(_action);
77     }
78 
79     /**
80      * @notice Checks that view is a valid message length
81      * @param _view The bytes string
82      * @return TRUE if message is valid
83      */
84     function isValidMessageLength(bytes29 _view) internal pure returns (bool) {
85         uint256 _len = _view.len();
86         return
87             _len == TOKEN_ID_LEN + TRANSFER_LEN ||
88             _len >= TOKEN_ID_LEN + MIN_TRANSFER_HOOK_LEN;
89     }
90 
91     /**
92      * @notice Formats an action message
93      * @param _tokenId The token ID
94      * @param _action The action
95      * @return The formatted message
96      */
97     function formatMessage(bytes29 _tokenId, bytes29 _action)
98         internal
99         view
100         typeAssert(_tokenId, Types.TokenId)
101         returns (bytes memory)
102     {
103         require(isValidAction(_action), "!action");
104         bytes29[] memory _views = new bytes29[](2);
105         _views[0] = _tokenId;
106         _views[1] = _action;
107         return TypedMemView.join(_views);
108     }
109 
110     /**
111      * @notice Returns the type of the message
112      * @param _view The message
113      * @return The type of the message
114      */
115     function messageType(bytes29 _view) internal pure returns (Types) {
116         return Types(uint8(_view.typeOf()));
117     }
118 
119     /**
120      * @notice Checks that the message is of the specified type
121      * @param _type the type to check for
122      * @param _action The message
123      * @return True if the message is of the specified type
124      */
125     function isType(bytes29 _action, Types _type) internal pure returns (bool) {
126         return
127             actionType(_action) == uint8(_type) &&
128             messageType(_action) == _type;
129     }
130 
131     /**
132      * @notice Checks that the message is of type Transfer
133      * @param _action The message
134      * @return True if the message is of type Transfer
135      */
136     function isTransfer(bytes29 _action) internal pure returns (bool) {
137         return isType(_action, Types.Transfer);
138     }
139 
140     /**
141      * @notice Checks that the message is of type TransferToHook
142      * @param _action The message
143      * @return True if the message is of type TransferToHook
144      */
145     function isTransferToHook(bytes29 _action) internal pure returns (bool) {
146         return isType(_action, Types.TransferToHook);
147     }
148 
149     /**
150      * @notice Formats Transfer
151      * @param _to The recipient address as bytes32
152      * @param _amnt The transfer amount
153      * @param _detailsHash The hash of the token name, symbol, and decimals
154      * @return
155      */
156     function formatTransfer(
157         bytes32 _to,
158         uint256 _amnt,
159         bytes32 _detailsHash
160     ) internal pure returns (bytes29) {
161         return
162             abi.encodePacked(Types.Transfer, _to, _amnt, _detailsHash).ref(
163                 uint40(Types.Transfer)
164             );
165     }
166 
167     /**
168      * @notice Formats TransferToHook message
169      * @param _hook The hook that will handle this token transfer
170      * @param _amnt The transfer amount
171      * @param _detailsHash The hash of the token name, symbol, and decimals
172      * @param _extraData User-provided data for the receiving hook
173      * @return
174      */
175     function formatTransferToHook(
176         bytes32 _hook,
177         uint256 _amnt,
178         bytes32 _detailsHash,
179         bytes32 _sender,
180         bytes memory _extraData
181     ) internal pure returns (bytes29) {
182         return
183             abi
184                 .encodePacked(
185                     Types.TransferToHook,
186                     _hook,
187                     _amnt,
188                     _detailsHash,
189                     _sender,
190                     _extraData
191                 )
192                 .ref(uint40(Types.TransferToHook));
193     }
194 
195     /**
196      * @notice Serializes a Token ID struct
197      * @param _tokenId The token id struct
198      * @return The formatted Token ID
199      */
200     function formatTokenId(TokenId memory _tokenId)
201         internal
202         pure
203         returns (bytes29)
204     {
205         return formatTokenId(_tokenId.domain, _tokenId.id);
206     }
207 
208     /**
209      * @notice Creates a serialized Token ID from components
210      * @param _domain The domain
211      * @param _id The ID
212      * @return The formatted Token ID
213      */
214     function formatTokenId(uint32 _domain, bytes32 _id)
215         internal
216         pure
217         returns (bytes29)
218     {
219         return abi.encodePacked(_domain, _id).ref(uint40(Types.TokenId));
220     }
221 
222     /**
223      * @notice Formats the keccak256 hash of the token details
224      * Token Details Format:
225      *      length of name cast to bytes - 32 bytes
226      *      name - x bytes (variable)
227      *      length of symbol cast to bytes - 32 bytes
228      *      symbol - x bytes (variable)
229      *      decimals - 1 byte
230      * @param _name The name
231      * @param _symbol The symbol
232      * @param _decimals The decimals
233      * @return The Details message
234      */
235     function getDetailsHash(
236         string memory _name,
237         string memory _symbol,
238         uint8 _decimals
239     ) internal pure returns (bytes32) {
240         return
241             keccak256(
242                 abi.encodePacked(
243                     bytes(_name).length,
244                     _name,
245                     bytes(_symbol).length,
246                     _symbol,
247                     _decimals
248                 )
249             );
250     }
251 
252     /**
253      * @notice Retrieves the domain from a TokenID
254      * @param _tokenId The message
255      * @return The domain
256      */
257     function domain(bytes29 _tokenId)
258         internal
259         pure
260         typeAssert(_tokenId, Types.TokenId)
261         returns (uint32)
262     {
263         return uint32(_tokenId.indexUint(0, 4));
264     }
265 
266     /**
267      * @notice Retrieves the ID from a TokenID
268      * @param _tokenId The message
269      * @return The ID
270      */
271     function id(bytes29 _tokenId)
272         internal
273         pure
274         typeAssert(_tokenId, Types.TokenId)
275         returns (bytes32)
276     {
277         // before = 4 bytes domain
278         return _tokenId.index(4, 32);
279     }
280 
281     /**
282      * @notice Retrieves the EVM ID
283      * @param _tokenId The message
284      * @return The EVM ID
285      */
286     function evmId(bytes29 _tokenId)
287         internal
288         pure
289         typeAssert(_tokenId, Types.TokenId)
290         returns (address)
291     {
292         // before = 4 bytes domain + 12 bytes empty to trim for address
293         return _tokenId.indexAddress(16);
294     }
295 
296     /**
297      * @notice Retrieves the action identifier from message
298      * @param _message The action
299      * @return The message type
300      */
301     function msgType(bytes29 _message) internal pure returns (uint8) {
302         return uint8(_message.indexUint(TOKEN_ID_LEN, 1));
303     }
304 
305     /**
306      * @notice Retrieves the identifier from action
307      * @param _action The action
308      * @return The action type
309      */
310     function actionType(bytes29 _action) internal pure returns (uint8) {
311         return uint8(_action.indexUint(0, 1));
312     }
313 
314     /**
315      * @notice Retrieves the recipient from a Transfer
316      * @param _transferAction The message
317      * @return The recipient address as bytes32
318      */
319     function recipient(bytes29 _transferAction)
320         internal
321         pure
322         typeAssert(_transferAction, Types.Transfer)
323         returns (bytes32)
324     {
325         // before = 1 byte identifier
326         return _transferAction.index(1, 32);
327     }
328 
329     /**
330      * @notice Retrieves the EVM Recipient from a Transfer
331      * @param _transferAction The message
332      * @return The EVM Recipient
333      */
334     function evmRecipient(bytes29 _transferAction)
335         internal
336         pure
337         typeAssert(_transferAction, Types.Transfer)
338         returns (address)
339     {
340         // before = 1 byte identifier + 12 bytes empty to trim for address = 13 bytes
341         return _transferAction.indexAddress(13);
342     }
343 
344     /**
345      * @notice Retrieves the amount from a Transfer
346      * @param _transferAction The message
347      * @return The amount
348      */
349     function amnt(bytes29 _transferAction) internal pure returns (uint256) {
350         // before = 1 byte identifier + 32 bytes ID = 33 bytes
351         return _transferAction.indexUint(33, 32);
352     }
353 
354     /**
355      * @notice Retrieves the detailsHash from a Transfer
356      * @param _transferAction The message
357      * @return The detailsHash
358      */
359     function detailsHash(bytes29 _transferAction)
360         internal
361         pure
362         returns (bytes32)
363     {
364         // before = 1 byte identifier + 32 bytes ID + 32 bytes amount = 65 bytes
365         return _transferAction.index(65, 32);
366     }
367 
368     /**
369      * @notice Retrieves the token ID from a Message
370      * @param _message The message
371      * @return The ID
372      */
373     function tokenId(bytes29 _message)
374         internal
375         pure
376         typeAssert(_message, Types.Message)
377         returns (bytes29)
378     {
379         return _message.slice(0, TOKEN_ID_LEN, uint40(Types.TokenId));
380     }
381 
382     /**
383      * @notice Retrieves the hook contract EVM address from a TransferWithHook
384      * @param _transferAction The message
385      * @return The hook contract address
386      */
387     function evmHook(bytes29 _transferAction)
388         internal
389         pure
390         typeAssert(_transferAction, Types.TransferToHook)
391         returns (address)
392     {
393         return _transferAction.indexAddress(13);
394     }
395 
396     /**
397      * @notice Retrieves the sender from a TransferWithHook
398      * @param _transferAction The message
399      * @return The sender as bytes32
400      */
401     function sender(bytes29 _transferAction)
402         internal
403         pure
404         typeAssert(_transferAction, Types.TransferToHook)
405         returns (bytes32)
406     {
407         // before = 1 byte identifier + 32 bytes hook address + 32 bytes amount + 32 bytes detailsHash = 97
408         return _transferAction.index(97, 32);
409     }
410 
411     /**
412      * @notice Retrieves the extra data from a TransferWithHook
413      * @param _transferAction The message
414      * @return A TypedMemview of extraData
415      */
416     function extraData(bytes29 _transferAction)
417         internal
418         pure
419         typeAssert(_transferAction, Types.TransferToHook)
420         returns (bytes29)
421     {
422         // anything past the end is the extradata
423         return
424             _transferAction.slice(
425                 MIN_TRANSFER_HOOK_LEN,
426                 _transferAction.len() - MIN_TRANSFER_HOOK_LEN,
427                 uint40(Types.ExtraData)
428             );
429     }
430 
431     /**
432      * @notice Retrieves the action data from a Message
433      * @param _message The message
434      * @return The action
435      */
436     function action(bytes29 _message)
437         internal
438         pure
439         typeAssert(_message, Types.Message)
440         returns (bytes29)
441     {
442         uint256 _actionLen = _message.len() - TOKEN_ID_LEN;
443         uint40 _type = uint40(msgType(_message));
444         return _message.slice(TOKEN_ID_LEN, _actionLen, _type);
445     }
446 
447     /**
448      * @notice Converts to a Message
449      * @param _message The message
450      * @return The newly typed message
451      */
452     function tryAsMessage(bytes29 _message) internal pure returns (bytes29) {
453         if (isValidMessageLength(_message)) {
454             return _message.castTo(uint40(Types.Message));
455         }
456         return TypedMemView.nullView();
457     }
458 
459     /**
460      * @notice Asserts that the message is of type Message
461      * @param _view The message
462      * @return The message
463      */
464     function mustBeMessage(bytes29 _view) internal pure returns (bytes29) {
465         return tryAsMessage(_view).assertValid();
466     }
467 }
