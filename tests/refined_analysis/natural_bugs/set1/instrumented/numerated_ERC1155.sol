1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 import "./IERC1155.sol";
6 import "./IERC1155MetadataURI.sol";
7 import "./IERC1155Receiver.sol";
8 import "../../utils/Context.sol";
9 import "../../introspection/ERC165.sol";
10 import "../../math/SafeMath.sol";
11 import "../../utils/Address.sol";
12 
13 /**
14  *
15  * @dev Implementation of the basic standard multi-token.
16  * See https://eips.ethereum.org/EIPS/eip-1155
17  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
18  *
19  * _Available since v3.1._
20  */
21 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
22     using SafeMath for uint256;
23     using Address for address;
24 
25     // Mapping from token ID to account balances
26     mapping (uint256 => mapping(address => uint256)) private _balances;
27 
28     // Mapping from account to operator approvals
29     mapping (address => mapping(address => bool)) private _operatorApprovals;
30 
31     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
32     string private _uri;
33 
34     /*
35      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
36      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
37      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
38      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
39      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
40      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
41      *
42      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
43      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
44      */
45     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
46 
47     /*
48      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
49      */
50     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
51 
52     /**
53      * @dev See {_setURI}.
54      */
55     constructor (string memory uri_) public {
56         _setURI(uri_);
57 
58         // register the supported interfaces to conform to ERC1155 via ERC165
59         _registerInterface(_INTERFACE_ID_ERC1155);
60 
61         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
62         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
63     }
64 
65     /**
66      * @dev See {IERC1155MetadataURI-uri}.
67      *
68      * This implementation returns the same URI for *all* token types. It relies
69      * on the token type ID substitution mechanism
70      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
71      *
72      * Clients calling this function must replace the `\{id\}` substring with the
73      * actual token type ID.
74      */
75     function uri(uint256) external view virtual override returns (string memory) {
76         return _uri;
77     }
78 
79     /**
80      * @dev See {IERC1155-balanceOf}.
81      *
82      * Requirements:
83      *
84      * - `account` cannot be the zero address.
85      */
86     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
87         require(account != address(0), "ERC1155: balance query for the zero address");
88         return _balances[id][account];
89     }
90 
91     /**
92      * @dev See {IERC1155-balanceOfBatch}.
93      *
94      * Requirements:
95      *
96      * - `accounts` and `ids` must have the same length.
97      */
98     function balanceOfBatch(
99         address[] memory accounts,
100         uint256[] memory ids
101     )
102         public
103         view
104         virtual
105         override
106         returns (uint256[] memory)
107     {
108         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
109 
110         uint256[] memory batchBalances = new uint256[](accounts.length);
111 
112         for (uint256 i = 0; i < accounts.length; ++i) {
113             batchBalances[i] = balanceOf(accounts[i], ids[i]);
114         }
115 
116         return batchBalances;
117     }
118 
119     /**
120      * @dev See {IERC1155-setApprovalForAll}.
121      */
122     function setApprovalForAll(address operator, bool approved) public virtual override {
123         require(_msgSender() != operator, "ERC1155: setting approval status for self");
124 
125         _operatorApprovals[_msgSender()][operator] = approved;
126         emit ApprovalForAll(_msgSender(), operator, approved);
127     }
128 
129     /**
130      * @dev See {IERC1155-isApprovedForAll}.
131      */
132     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
133         return _operatorApprovals[account][operator];
134     }
135 
136     /**
137      * @dev See {IERC1155-safeTransferFrom}.
138      */
139     function safeTransferFrom(
140         address from,
141         address to,
142         uint256 id,
143         uint256 amount,
144         bytes memory data
145     )
146         public
147         virtual
148         override
149     {
150         require(to != address(0), "ERC1155: transfer to the zero address");
151         require(
152             from == _msgSender() || isApprovedForAll(from, _msgSender()),
153             "ERC1155: caller is not owner nor approved"
154         );
155 
156         address operator = _msgSender();
157 
158         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
159 
160         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
161         _balances[id][to] = _balances[id][to].add(amount);
162 
163         emit TransferSingle(operator, from, to, id, amount);
164 
165         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
166     }
167 
168     /**
169      * @dev See {IERC1155-safeBatchTransferFrom}.
170      */
171     function safeBatchTransferFrom(
172         address from,
173         address to,
174         uint256[] memory ids,
175         uint256[] memory amounts,
176         bytes memory data
177     )
178         public
179         virtual
180         override
181     {
182         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
183         require(to != address(0), "ERC1155: transfer to the zero address");
184         require(
185             from == _msgSender() || isApprovedForAll(from, _msgSender()),
186             "ERC1155: transfer caller is not owner nor approved"
187         );
188 
189         address operator = _msgSender();
190 
191         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
192 
193         for (uint256 i = 0; i < ids.length; ++i) {
194             uint256 id = ids[i];
195             uint256 amount = amounts[i];
196 
197             _balances[id][from] = _balances[id][from].sub(
198                 amount,
199                 "ERC1155: insufficient balance for transfer"
200             );
201             _balances[id][to] = _balances[id][to].add(amount);
202         }
203 
204         emit TransferBatch(operator, from, to, ids, amounts);
205 
206         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
207     }
208 
209     /**
210      * @dev Sets a new URI for all token types, by relying on the token type ID
211      * substitution mechanism
212      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
213      *
214      * By this mechanism, any occurrence of the `\{id\}` substring in either the
215      * URI or any of the amounts in the JSON file at said URI will be replaced by
216      * clients with the token type ID.
217      *
218      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
219      * interpreted by clients as
220      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
221      * for token type ID 0x4cce0.
222      *
223      * See {uri}.
224      *
225      * Because these URIs cannot be meaningfully represented by the {URI} event,
226      * this function emits no events.
227      */
228     function _setURI(string memory newuri) internal virtual {
229         _uri = newuri;
230     }
231 
232     /**
233      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
234      *
235      * Emits a {TransferSingle} event.
236      *
237      * Requirements:
238      *
239      * - `account` cannot be the zero address.
240      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
241      * acceptance magic value.
242      */
243     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
244         require(account != address(0), "ERC1155: mint to the zero address");
245 
246         address operator = _msgSender();
247 
248         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
249 
250         _balances[id][account] = _balances[id][account].add(amount);
251         emit TransferSingle(operator, address(0), account, id, amount);
252 
253         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
254     }
255 
256     /**
257      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
258      *
259      * Requirements:
260      *
261      * - `ids` and `amounts` must have the same length.
262      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
263      * acceptance magic value.
264      */
265     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
266         require(to != address(0), "ERC1155: mint to the zero address");
267         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
268 
269         address operator = _msgSender();
270 
271         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
272 
273         for (uint i = 0; i < ids.length; i++) {
274             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
275         }
276 
277         emit TransferBatch(operator, address(0), to, ids, amounts);
278 
279         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
280     }
281 
282     /**
283      * @dev Destroys `amount` tokens of token type `id` from `account`
284      *
285      * Requirements:
286      *
287      * - `account` cannot be the zero address.
288      * - `account` must have at least `amount` tokens of token type `id`.
289      */
290     function _burn(address account, uint256 id, uint256 amount) internal virtual {
291         require(account != address(0), "ERC1155: burn from the zero address");
292 
293         address operator = _msgSender();
294 
295         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
296 
297         _balances[id][account] = _balances[id][account].sub(
298             amount,
299             "ERC1155: burn amount exceeds balance"
300         );
301 
302         emit TransferSingle(operator, account, address(0), id, amount);
303     }
304 
305     /**
306      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
307      *
308      * Requirements:
309      *
310      * - `ids` and `amounts` must have the same length.
311      */
312     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
313         require(account != address(0), "ERC1155: burn from the zero address");
314         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
315 
316         address operator = _msgSender();
317 
318         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
319 
320         for (uint i = 0; i < ids.length; i++) {
321             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
322                 amounts[i],
323                 "ERC1155: burn amount exceeds balance"
324             );
325         }
326 
327         emit TransferBatch(operator, account, address(0), ids, amounts);
328     }
329 
330     /**
331      * @dev Hook that is called before any token transfer. This includes minting
332      * and burning, as well as batched variants.
333      *
334      * The same hook is called on both single and batched variants. For single
335      * transfers, the length of the `id` and `amount` arrays will be 1.
336      *
337      * Calling conditions (for each `id` and `amount` pair):
338      *
339      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
340      * of token type `id` will be  transferred to `to`.
341      * - When `from` is zero, `amount` tokens of token type `id` will be minted
342      * for `to`.
343      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
344      * will be burned.
345      * - `from` and `to` are never both zero.
346      * - `ids` and `amounts` have the same, non-zero length.
347      *
348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
349      */
350     function _beforeTokenTransfer(
351         address operator,
352         address from,
353         address to,
354         uint256[] memory ids,
355         uint256[] memory amounts,
356         bytes memory data
357     )
358         internal
359         virtual
360     { }
361 
362     function _doSafeTransferAcceptanceCheck(
363         address operator,
364         address from,
365         address to,
366         uint256 id,
367         uint256 amount,
368         bytes memory data
369     )
370         private
371     {
372         if (to.isContract()) {
373             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
374                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
375                     revert("ERC1155: ERC1155Receiver rejected tokens");
376                 }
377             } catch Error(string memory reason) {
378                 revert(reason);
379             } catch {
380                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
381             }
382         }
383     }
384 
385     function _doSafeBatchTransferAcceptanceCheck(
386         address operator,
387         address from,
388         address to,
389         uint256[] memory ids,
390         uint256[] memory amounts,
391         bytes memory data
392     )
393         private
394     {
395         if (to.isContract()) {
396             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
397                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
398                     revert("ERC1155: ERC1155Receiver rejected tokens");
399                 }
400             } catch Error(string memory reason) {
401                 revert(reason);
402             } catch {
403                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
404             }
405         }
406     }
407 
408     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
409         uint256[] memory array = new uint256[](1);
410         array[0] = element;
411 
412         return array;
413     }
414 }