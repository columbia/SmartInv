1 # @version 0.3.7
2 
3 # @notice Just a basic ERC721, nothing fancy except for allowlist and bulk minting functionality.
4 # @dev This would be equivalent to GBC.sol No extra functionality such as tracking how long an NFT has been held, distributing rewards, or tracking how many times someone has locked, that would all be handled off chain.  Modified from https://github.com/npc-ers/current-thing
5 # @author The Llamas
6 # @license MIT
7 #
8 # ___________.__                 .____     .__
9 # \__    ___/|  |__    ____      |    |    |  |  _____     _____  _____     ______
10 #   |    |   |  |  \ _/ __ \     |    |    |  |  \__  \   /     \ \__  \   /  ___/
11 #   |    |   |   Y  \\  ___/     |    |___ |  |__ / __ \_|  Y Y  \ / __ \_ \___ \
12 #   |____|   |___|  / \___  >    |_______ \|____/(____  /|__|_|  /(____  //____  >
13 #                 \/      \/             \/           \/       \/      \/      \/
14 
15 
16 from vyper.interfaces import ERC20
17 from vyper.interfaces import ERC165
18 from vyper.interfaces import ERC721
19 
20 implements: ERC721
21 implements: ERC165
22 
23 # Interface for the contract called by safeTransferFrom()
24 interface ERC721Receiver:
25     def onERC721Received(
26         operator: address, sender: address, tokenId: uint256, data: Bytes[1024]
27     ) -> bytes4: nonpayable
28 
29 
30 # @dev Emits when ownership of any NFT changes by any mechanism.
31 #      This event emits when NFTs are created (`from` == 0) and destroyed (`to` == 0).
32 #      Exception: during contract creation, any number of NFTs may be created and assigned without emitting.
33 #      At the time of any transfer, the approved address for that NFT (if any) is reset to none.
34 # @param _from Sender of NFT (if address is zero address it indicates token creation).
35 # @param _to Receiver of NFT (if address is zero address it indicates token destruction).
36 # @param _tokenId The NFT that got transfered.
37 
38 event Transfer:
39     _from: indexed(address)
40     _to: indexed(address)
41     _tokenId: indexed(uint256)
42 
43 
44 # @dev This emits when the approved address for an NFT is changed or reaffirmed.
45 #      The zero address indicates there is no approved address.
46 #      When a Transfer event emits, this also indicates any approved address resets to none.
47 # @param _owner Owner of NFT.
48 # @param _approved Address that we are approving.
49 # @param _tokenId NFT which we are approving.
50 
51 event Approval:
52     _owner: indexed(address)
53     _approved: indexed(address)
54     _tokenId: indexed(uint256)
55 
56 
57 # @dev This emits when an operator is enabled or disabled for an owner.
58 #      The operator can manage all NFTs of the owner.
59 # @param _owner Owner of NFT.
60 # @param _operator Address to which we are setting operator rights.
61 # @param _approved Status of operator rights (true if operator rights given, false if revoked).
62 
63 event ApprovalForAll:
64     _owner: indexed(address)
65     _operator: indexed(address)
66     _approved: bool
67 
68 
69 IDENTITY_PRECOMPILE: constant(
70     address
71 ) = 0x0000000000000000000000000000000000000004
72 
73 # Metadata
74 symbol: public(String[32])
75 name: public(String[32])
76 
77 # Permissions
78 owner: public(address)
79 
80 # URI
81 base_uri: public(String[128])
82 contract_uri: String[128]
83 
84 # NFT Data
85 ids_by_owner: HashMap[address, DynArray[uint256, MAX_SUPPLY]]
86 id_to_index: HashMap[uint256, uint256]
87 token_count: uint256
88 
89 owned_tokens: HashMap[
90     uint256, address
91 ]  # @dev NFT ID to the address that owns it
92 token_approvals: HashMap[uint256, address]  # @dev NFT ID to approved address
93 operator_approvals: HashMap[
94     address, HashMap[address, bool]
95 ]  # @dev Owner address to mapping of operator addresses
96 
97 # @dev Static list of supported ERC165 interface ids
98 SUPPORTED_INTERFACES: constant(bytes4[5]) = [
99     0x01FFC9A7,  # ERC165
100     0x80AC58CD,  # ERC721
101     0x150B7A02,  # ERC721TokenReceiver
102     0x780E9D63,  # ERC721Enumerable
103     0x5B5E139F,  # ERC721Metadata
104 ]
105 
106 # Custom NFT
107 revealed: public(bool)
108 default_uri: public(String[150])
109 
110 MAX_SUPPLY: constant(uint256) = 1111
111 MAX_PREMINT: constant(uint256) = 235
112 MAX_MINT_PER_TX: constant(uint256) = 3
113 COST: constant(uint256) = as_wei_value(0.1, "ether")
114 
115 al_mint_started: public(bool)
116 al_signer: public(address)
117 minter: public(address)
118 al_mint_amount: public(HashMap[address, uint256])
119 
120 
121 @external
122 def __init__(preminters: address[MAX_PREMINT]):
123     self.symbol = "LLAMA"
124     self.name = "The Llamas"
125     self.owner = msg.sender
126     self.contract_uri = "https://ivory-fast-planarian-364.mypinata.cloud/ipfs/QmPAS4WmxAcqRnKyUS1KS4pCeWDMmZWyph6N3DzE6rCb7L"
127     self.default_uri = "https://ivory-fast-planarian-364.mypinata.cloud/ipfs/QmSBtCSpm3HzwfqBYLLYb7d1AkbQ73cvGWu3bbk4vP2PGd"
128     self.al_mint_started = False
129     self.al_signer = msg.sender
130     self.minter = msg.sender
131 
132     for i in range(MAX_PREMINT):
133         token_id: uint256 = self.token_count
134         self._add_token_to(preminters[i], token_id)
135         self.token_count += 1
136 
137         log Transfer(empty(address), preminters[i], token_id)
138 
139 
140 @pure
141 @external
142 def supportsInterface(interface_id: bytes4) -> bool:
143     """
144     @notice Query if a contract implements an interface.
145     @dev Interface identification is specified in ERC-165.
146     @param interface_id Bytes4 representing the interface.
147     @return bool True if supported.
148     """
149 
150     return interface_id in SUPPORTED_INTERFACES
151 
152 
153 ### VIEW FUNCTIONS ###
154 
155 
156 @view
157 @external
158 def balanceOf(owner: address) -> uint256:
159     """
160     @notice Count all NFTs assigned to an owner.
161     @dev Returns the number of NFTs owned by `owner`.
162          Throws if `owner` is the zero address.
163          NFTs assigned to the zero address are considered invalid.
164     @param owner Address for whom to query the balance.
165     @return The address of the owner of the NFT
166     """
167 
168     assert owner != empty(
169         address
170     )  # dev: "ERC721: balance query for the zero address"
171     return len(self.ids_by_owner[owner])
172 
173 
174 @view
175 @external
176 def ownerOf(token_id: uint256) -> address:
177     """
178     @notice Find the owner of an NFT.
179     @dev Returns the address of the owner of the NFT.
180          Throws if `token_id` is not a valid NFT.
181     @param token_id The identifier for an NFT.
182     @return The address of the owner of the NFT
183     """
184 
185     owner: address = self.owned_tokens[token_id]
186     assert owner != empty(
187         address
188     )  # dev: "ERC721: owner query for nonexistent token"
189     return owner
190 
191 
192 @view
193 @external
194 def getApproved(token_id: uint256) -> address:
195     """
196     @notice Get the approved address for a single NFT
197     @dev Get the approved address for a single NFT.
198          Throws if `token_id` is not a valid NFT.
199     @param token_id ID of the NFT for which to query approval.
200     @return The approved address for this NFT, or the zero address if there is none
201     """
202 
203     assert self.owned_tokens[token_id] != empty(
204         address
205     )  # dev: "ERC721: approved query for nonexistent token"
206     return self.token_approvals[token_id]
207 
208 
209 @view
210 @external
211 def isApprovedForAll(owner: address, operator: address) -> bool:
212     """
213     @notice Query if an address is an authorized operator for another address
214     @dev Checks if `operator` is an approved operator for `owner`.
215     @param owner The address that owns the NFTs.
216     @param operator The address that acts on behalf of the owner.
217     @return True if `_operator` is an approved operator for `_owner`, false otherwise
218     """
219 
220     return (self.operator_approvals[owner])[operator]
221 
222 
223 ### TRANSFER FUNCTION HELPERS ###
224 
225 
226 @view
227 @internal
228 def _is_approved_or_owner(spender: address, token_id: uint256) -> bool:
229     """
230     @dev Returns whether the given spender can transfer a given token ID
231     @param spender address of the spender to query
232     @param token_id uint256 ID of the token to be transferred
233     @return bool whether the msg.sender is approved for the given token ID,
234         is an operator of the owner, or is the owner of the token
235     """
236 
237     owner: address = self.owned_tokens[token_id]
238     spender_is_owner: bool = owner == spender
239     spender_is_approved: bool = spender == self.token_approvals[token_id]
240     spender_is_approved_for_all: bool = self.operator_approvals[owner][spender]
241 
242     return (
243         spender_is_owner or spender_is_approved
244     ) or spender_is_approved_for_all
245 
246 
247 @internal
248 def _add_token_to(_to: address, _token_id: uint256):
249     """
250     @dev Add a NFT to a given address
251          Throws if `_token_id` is owned by someone.
252     """
253 
254     # Throws if `_token_id` is owned by someone
255     assert self.owned_tokens[_token_id] == empty(address)
256 
257     # Change the owner
258     self.owned_tokens[_token_id] = _to
259 
260     # Change count tracking
261     num_ids: uint256 = len(self.ids_by_owner[_to])
262     self.id_to_index[_token_id] = num_ids
263     self.ids_by_owner[_to].append(_token_id)
264 
265 
266 @internal
267 def _remove_token_from(_from: address, _token_id: uint256):
268     """
269     @dev Remove an NFT from a given address
270          Throws if `_from` is not the current owner.
271     """
272 
273     # Throws if `_from` is not the current owner
274     assert self.owned_tokens[_token_id] == _from
275 
276     # Change the owner
277     self.owned_tokens[_token_id] = empty(address)
278 
279     # Update ids list for user
280     end_index: uint256 = len(self.ids_by_owner[_from]) - 1
281     id_index: uint256 = self.id_to_index[_token_id]
282     if end_index == id_index:
283         # Remove is simple since token is at end of ids list
284         self.ids_by_owner[_from].pop()
285         self.id_to_index[_token_id] = 0
286     else:
287         # Token is not at end;
288         # replace it with the end token and then..
289         end_id: uint256 = self.ids_by_owner[_from][end_index]
290         self.ids_by_owner[_from][id_index] = end_id
291         # ... pop!
292         self.ids_by_owner[_from].pop()
293         self.id_to_index[_token_id] = 0
294         self.id_to_index[end_id] = id_index
295 
296 
297 @internal
298 def _clear_approval(_owner: address, _token_id: uint256):
299     """
300     @dev Clear an approval of a given address
301          Throws if `_owner` is not the current owner.
302     """
303 
304     # Throws if `_owner` is not the current owner
305     assert self.owned_tokens[_token_id] == _owner
306     if self.token_approvals[_token_id] != empty(address):
307         # Reset approvals
308         self.token_approvals[_token_id] = empty(address)
309 
310 
311 @internal
312 def _transfer_from(
313     _from: address, _to: address, _token_id: uint256, _sender: address
314 ):
315     """
316     @dev Execute transfer of a NFT.
317          Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
318          address for this NFT. (NOTE: `msg.sender` not allowed in private function so pass `_sender`.)
319          Throws if `_to` is the zero address.
320          Throws if `_from` is not the current owner.
321          Throws if `_token_id` is not a valid NFT.
322     """
323 
324     # Throws if `_to` is the zero address
325     assert _to != empty(address)  # dev : "ERC721: transfer to the zero address"
326 
327     # Check requirements
328     assert self._is_approved_or_owner(
329         _sender, _token_id
330     )  # dev : "ERC721: transfer caller is not owner nor approved"
331 
332     # Clear approval. Throws if `_from` is not the current owner
333     self._clear_approval(_from, _token_id)
334 
335     # Remove NFT. Throws if `_token_id` is not a valid NFT
336     self._remove_token_from(_from, _token_id)
337 
338     # Add NFT
339     self._add_token_to(_to, _token_id)
340 
341     # Log the transfer
342     log Transfer(_from, _to, _token_id)
343 
344 
345 ### TRANSFER FUNCTIONS ###
346 
347 
348 @external
349 def transferFrom(from_addr: address, to_addr: address, token_id: uint256):
350     """
351     @dev Throws unless `msg.sender` is the current owner, an authorized operato_addrr, or the approved address for this NFT.
352          Throws if `from_addr` is not the current owner.
353          Throws if `to_addr` is the zero address.
354          Throws if `token_id` is not a valid NFT.
355     @notice The caller is responsible to_addr confirm that `to_addr` is capable of receiving NFTs or else they maybe be permanently lost.
356     @param from_addr The current owner of the NFT.
357     @param to_addr The new owner.
358     @param token_id The NFT to_addr transfer.
359     """
360 
361     self._transfer_from(from_addr, to_addr, token_id, msg.sender)
362 
363 
364 @external
365 def safeTransferFrom(
366     from_addr: address,
367     to_addr: address,
368     token_id: uint256,
369     data: Bytes[1024] = b"",
370 ):
371     """
372     @dev Transfers the ownership of an NFT from one address to another address.
373          Throws unless `msg.sender` is the current owner, an authorized operator, or the approved address for this NFT.
374          Throws if `from_addr` is not the current owner.
375          Throws if `to_addr` is the zero address.
376          Throws if `token_id` is not a valid NFT.
377          If `to_addr` is a smart contract, it calls `onERC721Received` on `to_addr` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
378          NOTE: bytes4 is represented by bytes32 with padding
379     @param from_addr The current owner of the NFT.
380     @param to_addr The new owner.
381     @param token_id The NFT to transfer.
382     @param data Additional data with no specified format, sent in call to `to_addr`.
383     """
384 
385     self._transfer_from(from_addr, to_addr, token_id, msg.sender)
386 
387     if to_addr.is_contract:  # check if `to_addr` is a contract address
388         return_value: bytes4 = ERC721Receiver(to_addr).onERC721Received(
389             msg.sender, from_addr, token_id, data
390         )
391 
392         # Throws if transfer destination is a contract which does not implement 'onERC721Received'
393         assert return_value == method_id(
394             "onERC721Received(address,address,uint256,bytes)",
395             output_type=bytes4,
396         )
397 
398 
399 @external
400 def approve(approved: address, token_id: uint256):
401     """
402     @notice Change or reaffirm the approved address for an NFT
403     @dev Set or reaffirm the approved address for an NFT. The zero address indicates there is no approved address.
404          Throws unless `msg.sender` is the current NFT owner, or an authorized operator of the current owner.
405          Throws if `token_id` is not a valid NFT. (NOTE: This is not written the EIP)
406          Throws if `approved` is the current owner. (NOTE: This is not written the EIP)
407     @param approved Address to be approved for the given NFT ID.
408     @param token_id ID of the token to be approved.
409     """
410 
411     owner: address = self.owned_tokens[token_id]
412 
413     # Throws if `token_id` is not a valid NFT
414     assert owner != empty(
415         address
416     )  # dev: "ERC721: owner query for nonexistent token"
417 
418     # Throws if `approved` is the current owner
419     assert approved != owner  # dev: "ERC721: approval to current owner"
420 
421     # Check requirements
422     is_owner: bool = self.owned_tokens[token_id] == msg.sender
423     is_approved_all: bool = (self.operator_approvals[owner])[msg.sender]
424     assert (
425         is_owner or is_approved_all
426     )  # dev: "ERC721: approve caller is not owner nor approved for all"
427 
428     # Set the approval
429     self.token_approvals[token_id] = approved
430 
431     log Approval(owner, approved, token_id)
432 
433 
434 @external
435 def setApprovalForAll(operator: address, approved: bool):
436     """
437     @notice notice Enable or disable approval for a third party ("operator") to manage all of `msg.sender`'s assets
438     @dev Enables or disables approval for a third party ("operator") to manage all of`msg.sender`'s assets. It also emits the ApprovalForAll event.
439          Throws if `operator` is the `msg.sender`. (NOTE: This is not written the EIP)
440     This works even if sender doesn't own any tokens at the time.
441     @param operator Address to add to the set of authorized operators.
442     @param approved True if the operators is approved, false to revoke approval.
443     """
444 
445     # Throws if `operator` is the `msg.sender`
446     assert operator != msg.sender
447     self.operator_approvals[msg.sender][operator] = approved
448 
449     log ApprovalForAll(msg.sender, operator, approved)
450 
451 
452 ### MINT FUNCTIONS ###
453 
454 
455 @external
456 @payable
457 def allowlistMint(
458     mint_amount: uint256, approved_amount: uint256, sig: Bytes[65]
459 ):
460     """
461     @notice Function to mint a token for allowlisted users
462     """
463 
464     # Checks
465     assert self.al_mint_started == True, "AL Mint not active"
466     assert mint_amount <= MAX_MINT_PER_TX, "Transaction exceeds max mint amount"
467     assert (
468         self.checkAlSignature(sig, msg.sender, approved_amount) == True
469     ), "Signature is not valid"
470     assert (
471         (self.al_mint_amount[msg.sender] + mint_amount) <= approved_amount
472     ), "Cannot mint over approved amount"
473     assert msg.value >= COST * mint_amount, "Not enough ether provided"
474 
475     for i in range(MAX_MINT_PER_TX):
476         if i >= mint_amount:
477             break
478 
479         token_id: uint256 = self.token_count
480         assert token_id < MAX_SUPPLY
481         self._add_token_to(msg.sender, token_id)
482         self.token_count += 1
483 
484         log Transfer(empty(address), msg.sender, token_id)
485 
486     self.al_mint_amount[msg.sender] += mint_amount
487 
488 
489 @external
490 def mint() -> uint256:
491     """
492     @notice Function to mint a token
493     """
494 
495     # Checks
496     assert msg.sender == self.minter
497 
498     token_id: uint256 = self.token_count
499     assert token_id < MAX_SUPPLY
500     self._add_token_to(msg.sender, token_id)
501     self.token_count += 1
502 
503     log Transfer(empty(address), msg.sender, token_id)
504 
505     return token_id
506 
507 
508 ### ERC721-URI STORAGE FUNCTIONS ###
509 
510 
511 @external
512 @view
513 def tokenURI(token_id: uint256) -> String[256]:
514     """
515     @notice A distinct Uniform Resource Identifier (URI) for a given asset.
516     @dev Throws if `_token_id` is not a valid NFT. URIs are defined in RFC 6686. The URI may point to a JSON file that conforms to the "ERC721 Metadata JSON Schema".
517     """
518     if self.owned_tokens[token_id] == empty(address):
519         raise  # dev: "ERC721URIStorage: URI query for nonexistent token"
520 
521     if self.revealed:
522         return concat(self.base_uri, uint2str(token_id))
523     else:
524         return self.default_uri
525 
526 
527 @external
528 @view
529 def contractURI() -> String[128]:
530     """
531     @notice URI for contract level metadata
532     @return Contract URI
533     """
534     return self.contract_uri
535 
536 
537 ### ADMIN FUNCTIONS
538 
539 
540 @external
541 def set_minter(minter: address):
542     assert msg.sender == self.owner, "Caller is not the owner"
543     self.minter = minter
544 
545 
546 @external
547 def set_al_signer(al_signer: address):
548     assert msg.sender == self.owner, "Caller is not the owner"
549     self.al_signer = al_signer
550 
551 
552 @external
553 def set_base_uri(base_uri: String[128]):
554     """
555     @notice Admin function to set a new Base URI for
556     @dev Globally prepended to token_uri
557     @param base_uri New URI for the token
558 
559     """
560     assert (
561         msg.sender == self.owner
562     ), "Caller is not the owner"  # dev: Only Admin
563     self.base_uri = base_uri
564 
565 
566 @external
567 def set_contract_uri(new_uri: String[66]):
568     """
569     @notice Admin function to set a new contract URI
570     @param new_uri New URI for the contract
571     """
572 
573     assert (
574         msg.sender == self.owner
575     ), "Caller is not the owner"  # dev: Only Admin
576     self.contract_uri = new_uri
577 
578 
579 @external
580 def set_owner(new_addr: address):
581     """
582     @notice Admin function to update owner
583     @param new_addr The new owner address to take over immediately
584     """
585 
586     assert (
587         msg.sender == self.owner
588     ), "Caller is not the owner"  # dev: Only Owner
589     self.owner = new_addr
590 
591 
592 @external
593 def set_revealed(flag: bool):
594     """
595     @notice Admin function to reveal collection.  If not revealed, all NFTs show default_uri
596     @param flag Boolean, True to reveal, False to conceal
597     """
598     assert (
599         msg.sender == self.owner
600     ), "Caller is not the owner"  # dev: Only Owner
601 
602     self.revealed = flag
603 
604 
605 @external
606 def withdraw():
607     assert (
608         msg.sender == self.owner
609     ), "Caller is not the owner"  # dev: "Admin Only"
610 
611     send(self.owner, self.balance)
612 
613 
614 @external
615 def admin_withdraw_erc20(coin: address, target: address, amount: uint256):
616     """
617     @notice Withdraw ERC20 tokens accidentally sent to contract
618     @param coin ERC20 address
619     @param target Address to receive
620     @param amount Wei
621     """
622     assert (
623         msg.sender == self.owner
624     ), "Caller is not the owner"  # dev: "Admin Only"
625     ERC20(coin).transfer(target, amount)
626 
627 
628 @external
629 def start_al_mint():
630     assert (
631         msg.sender == self.owner
632     ), "Caller is not the owner"  # dev: "Admin Only"
633     self.al_mint_started = True
634 
635 
636 @external
637 def stop_al_mint():
638     assert (
639         msg.sender == self.owner
640     ), "Caller is not the owner"  # dev: "Admin Only"
641     self.al_mint_started = False
642 
643 
644 ## ERC-721 Enumerable Functions
645 
646 
647 @external
648 @view
649 def totalSupply() -> uint256:
650     """
651     @notice Return the total supply
652     @return The token count
653     """
654     return self.token_count
655 
656 
657 @external
658 @view
659 def tokenByIndex(_index: uint256) -> uint256:
660     """
661     @notice Enumerate valid NFTs
662     @dev With no burn and direct minting, this is simple
663     @param _index A counter less than `totalSupply()`
664     @return The token identifier for the `_index`th NFT,
665     """
666 
667     return _index
668 
669 
670 @external
671 @view
672 def tokenOfOwnerByIndex(owner: address, index: uint256) -> uint256:
673     """
674     @notice Enumerate NFTs assigned to an owner
675     @dev Throws if `index` >= `balanceOf(owner)` or if `owner` is the zero address, representing invalid NFTs.
676     @param owner An address where we are interested in NFTs owned by them
677     @param index A counter less than `balanceOf(owner)`
678     @return The token identifier for the `index`th NFT assigned to `owner`, (sort order not specified)
679     """
680     assert owner != empty(address)
681     assert index < len(self.ids_by_owner[owner])
682     return self.ids_by_owner[owner][index]
683 
684 
685 @external
686 @view
687 def tokensForOwner(owner: address) -> DynArray[uint256, MAX_SUPPLY]:
688     return self.ids_by_owner[owner]
689 
690 
691 ## SIGNATURE HELPER
692 
693 
694 @internal
695 @view
696 def checkAlSignature(
697     sig: Bytes[65], sender: address, approved_amount: uint256
698 ) -> bool:
699     r: uint256 = convert(slice(sig, 0, 32), uint256)
700     s: uint256 = convert(slice(sig, 32, 32), uint256)
701     v: uint256 = convert(slice(sig, 64, 1), uint256)
702     ethSignedHash: bytes32 = keccak256(
703         concat(
704             b"\x19Ethereum Signed Message:\n32",
705             keccak256(_abi_encode("allowlist:", sender, approved_amount)),
706         )
707     )
708 
709     return self.al_signer == ecrecover(ethSignedHash, v, r, s)