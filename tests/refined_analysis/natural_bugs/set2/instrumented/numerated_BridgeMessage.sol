1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
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
18     enum Types {
19         Invalid, // 0
20         TokenId, // 1
21         Message, // 2
22         Transfer, // 3
23         FastTransfer // 4
24     }
25 
26     // ============ Structs ============
27 
28     // Tokens are identified by a TokenId:
29     // domain - 4 byte chain ID of the chain from which the token originates
30     // id - 32 byte identifier of the token address on the origin chain, in that chain's address format
31     struct TokenId {
32         uint32 domain;
33         bytes32 id;
34     }
35 
36     // ============ Constants ============
37 
38     uint256 private constant TOKEN_ID_LEN = 36; // 4 bytes domain + 32 bytes id
39     uint256 private constant IDENTIFIER_LEN = 1;
40     uint256 private constant TRANSFER_LEN = 97; // 1 byte identifier + 32 bytes recipient + 32 bytes amount + 32 bytes detailsHash
41 
42     // ============ Modifiers ============
43 
44     /**
45      * @notice Asserts a message is of type `_t`
46      * @param _view The message
47      * @param _t The expected type
48      */
49     modifier typeAssert(bytes29 _view, Types _t) {
50         _view.assertType(uint40(_t));
51         _;
52     }
53 
54     // ============ Internal Functions ============
55 
56     /**
57      * @notice Checks that Action is valid type
58      * @param _action The action
59      * @return TRUE if action is valid
60      */
61     function isValidAction(bytes29 _action) internal pure returns (bool) {
62         return isTransfer(_action) || isFastTransfer(_action);
63     }
64 
65     /**
66      * @notice Checks that view is a valid message length
67      * @param _view The bytes string
68      * @return TRUE if message is valid
69      */
70     function isValidMessageLength(bytes29 _view) internal pure returns (bool) {
71         uint256 _len = _view.len();
72         return _len == TOKEN_ID_LEN + TRANSFER_LEN;
73     }
74 
75     /**
76      * @notice Formats an action message
77      * @param _tokenId The token ID
78      * @param _action The action
79      * @return The formatted message
80      */
81     function formatMessage(bytes29 _tokenId, bytes29 _action)
82         internal
83         view
84         typeAssert(_tokenId, Types.TokenId)
85         returns (bytes memory)
86     {
87         require(isValidAction(_action), "!action");
88         bytes29[] memory _views = new bytes29[](2);
89         _views[0] = _tokenId;
90         _views[1] = _action;
91         return TypedMemView.join(_views);
92     }
93 
94     /**
95      * @notice Returns the type of the message
96      * @param _view The message
97      * @return The type of the message
98      */
99     function messageType(bytes29 _view) internal pure returns (Types) {
100         return Types(uint8(_view.typeOf()));
101     }
102 
103     /**
104      * @notice Checks that the message is of the specified type
105      * @param _type the type to check for
106      * @param _action The message
107      * @return True if the message is of the specified type
108      */
109     function isType(bytes29 _action, Types _type) internal pure returns (bool) {
110         return
111             actionType(_action) == uint8(_type) &&
112             messageType(_action) == _type;
113     }
114 
115     /**
116      * @notice Checks that the message is of type Transfer
117      * @param _action The message
118      * @return True if the message is of type Transfer
119      */
120     function isTransfer(bytes29 _action) internal pure returns (bool) {
121         return isType(_action, Types.Transfer);
122     }
123 
124     /**
125      * @notice Checks that the message is of type FastTransfer
126      * @param _action The message
127      * @return True if the message is of type FastTransfer
128      */
129     function isFastTransfer(bytes29 _action) internal pure returns (bool) {
130         return isType(_action, Types.FastTransfer);
131     }
132 
133     /**
134      * @notice Formats Transfer
135      * @param _to The recipient address as bytes32
136      * @param _amnt The transfer amount
137      * @param _enableFast True to format FastTransfer, False to format regular Transfer
138      * @return
139      */
140     function formatTransfer(
141         bytes32 _to,
142         uint256 _amnt,
143         bytes32 _detailsHash,
144         bool _enableFast
145     ) internal pure returns (bytes29) {
146         Types _type = _enableFast ? Types.FastTransfer : Types.Transfer;
147         return
148             abi.encodePacked(_type, _to, _amnt, _detailsHash).ref(0).castTo(
149                 uint40(_type)
150             );
151     }
152 
153     /**
154      * @notice Serializes a Token ID struct
155      * @param _tokenId The token id struct
156      * @return The formatted Token ID
157      */
158     function formatTokenId(TokenId memory _tokenId)
159         internal
160         pure
161         returns (bytes29)
162     {
163         return formatTokenId(_tokenId.domain, _tokenId.id);
164     }
165 
166     /**
167      * @notice Creates a serialized Token ID from components
168      * @param _domain The domain
169      * @param _id The ID
170      * @return The formatted Token ID
171      */
172     function formatTokenId(uint32 _domain, bytes32 _id)
173         internal
174         pure
175         returns (bytes29)
176     {
177         return
178             abi.encodePacked(_domain, _id).ref(0).castTo(uint40(Types.TokenId));
179     }
180 
181     /**
182      * @notice Formats the keccak256 hash of the token details
183      * Token Details Format:
184      *      length of name cast to bytes - 32 bytes
185      *      name - x bytes (variable)
186      *      length of symbol cast to bytes - 32 bytes
187      *      symbol - x bytes (variable)
188      *      decimals - 1 byte
189      * @param _name The name
190      * @param _symbol The symbol
191      * @param _decimals The decimals
192      * @return The Details message
193      */
194     function getDetailsHash(
195         string memory _name,
196         string memory _symbol,
197         uint8 _decimals
198     ) internal pure returns (bytes32) {
199         return
200             keccak256(
201                 abi.encodePacked(
202                     bytes(_name).length,
203                     _name,
204                     bytes(_symbol).length,
205                     _symbol,
206                     _decimals
207                 )
208             );
209     }
210 
211     /**
212      * @notice get the preFillId used to identify
213      * fast liquidity provision for incoming token send messages
214      * @dev used to identify a token/transfer pair in the prefill LP mapping.
215      * @param _origin The domain of the chain from which the transfer originated
216      * @param _nonce The unique identifier for the message from origin to destination
217      * @param _tokenId The token ID
218      * @param _action The action
219      */
220     function getPreFillId(
221         uint32 _origin,
222         uint32 _nonce,
223         bytes29 _tokenId,
224         bytes29 _action
225     ) internal view returns (bytes32) {
226         bytes29[] memory _views = new bytes29[](3);
227         _views[0] = abi.encodePacked(_origin, _nonce).ref(0);
228         _views[1] = _tokenId;
229         _views[2] = _action;
230         return TypedMemView.joinKeccak(_views);
231     }
232 
233     /**
234      * @notice Retrieves the domain from a TokenID
235      * @param _tokenId The message
236      * @return The domain
237      */
238     function domain(bytes29 _tokenId)
239         internal
240         pure
241         typeAssert(_tokenId, Types.TokenId)
242         returns (uint32)
243     {
244         return uint32(_tokenId.indexUint(0, 4));
245     }
246 
247     /**
248      * @notice Retrieves the ID from a TokenID
249      * @param _tokenId The message
250      * @return The ID
251      */
252     function id(bytes29 _tokenId)
253         internal
254         pure
255         typeAssert(_tokenId, Types.TokenId)
256         returns (bytes32)
257     {
258         // before = 4 bytes domain
259         return _tokenId.index(4, 32);
260     }
261 
262     /**
263      * @notice Retrieves the EVM ID
264      * @param _tokenId The message
265      * @return The EVM ID
266      */
267     function evmId(bytes29 _tokenId)
268         internal
269         pure
270         typeAssert(_tokenId, Types.TokenId)
271         returns (address)
272     {
273         // before = 4 bytes domain + 12 bytes empty to trim for address
274         return _tokenId.indexAddress(16);
275     }
276 
277     /**
278      * @notice Retrieves the action identifier from message
279      * @param _message The action
280      * @return The message type
281      */
282     function msgType(bytes29 _message) internal pure returns (uint8) {
283         return uint8(_message.indexUint(TOKEN_ID_LEN, 1));
284     }
285 
286     /**
287      * @notice Retrieves the identifier from action
288      * @param _action The action
289      * @return The action type
290      */
291     function actionType(bytes29 _action) internal pure returns (uint8) {
292         return uint8(_action.indexUint(0, 1));
293     }
294 
295     /**
296      * @notice Retrieves the recipient from a Transfer
297      * @param _transferAction The message
298      * @return The recipient address as bytes32
299      */
300     function recipient(bytes29 _transferAction)
301         internal
302         pure
303         returns (bytes32)
304     {
305         // before = 1 byte identifier
306         return _transferAction.index(1, 32);
307     }
308 
309     /**
310      * @notice Retrieves the EVM Recipient from a Transfer
311      * @param _transferAction The message
312      * @return The EVM Recipient
313      */
314     function evmRecipient(bytes29 _transferAction)
315         internal
316         pure
317         returns (address)
318     {
319         // before = 1 byte identifier + 12 bytes empty to trim for address = 13 bytes
320         return _transferAction.indexAddress(13);
321     }
322 
323     /**
324      * @notice Retrieves the amount from a Transfer
325      * @param _transferAction The message
326      * @return The amount
327      */
328     function amnt(bytes29 _transferAction) internal pure returns (uint256) {
329         // before = 1 byte identifier + 32 bytes ID = 33 bytes
330         return _transferAction.indexUint(33, 32);
331     }
332 
333     /**
334      * @notice Retrieves the detailsHash from a Transfer
335      * @param _transferAction The message
336      * @return The detailsHash
337      */
338     function detailsHash(bytes29 _transferAction)
339         internal
340         pure
341         returns (bytes32)
342     {
343         // before = 1 byte identifier + 32 bytes ID + 32 bytes amount = 65 bytes
344         return _transferAction.index(65, 32);
345     }
346 
347     /**
348      * @notice Retrieves the token ID from a Message
349      * @param _message The message
350      * @return The ID
351      */
352     function tokenId(bytes29 _message)
353         internal
354         pure
355         typeAssert(_message, Types.Message)
356         returns (bytes29)
357     {
358         return _message.slice(0, TOKEN_ID_LEN, uint40(Types.TokenId));
359     }
360 
361     /**
362      * @notice Retrieves the action data from a Message
363      * @param _message The message
364      * @return The action
365      */
366     function action(bytes29 _message)
367         internal
368         pure
369         typeAssert(_message, Types.Message)
370         returns (bytes29)
371     {
372         uint256 _actionLen = _message.len() - TOKEN_ID_LEN;
373         uint40 _type = uint40(msgType(_message));
374         return _message.slice(TOKEN_ID_LEN, _actionLen, _type);
375     }
376 
377     /**
378      * @notice Converts to a Message
379      * @param _message The message
380      * @return The newly typed message
381      */
382     function tryAsMessage(bytes29 _message) internal pure returns (bytes29) {
383         if (isValidMessageLength(_message)) {
384             return _message.castTo(uint40(Types.Message));
385         }
386         return TypedMemView.nullView();
387     }
388 
389     /**
390      * @notice Asserts that the message is of type Message
391      * @param _view The message
392      * @return The message
393      */
394     function mustBeMessage(bytes29 _view) internal pure returns (bytes29) {
395         return tryAsMessage(_view).assertValid();
396     }
397 }
