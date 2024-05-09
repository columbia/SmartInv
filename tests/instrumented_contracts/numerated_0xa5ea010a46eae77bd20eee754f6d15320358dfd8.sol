1 # @version 0.3.7
2 # @notice NPC-ers NFT
3 # @dev Implementation of ERC-721 non-fungible token standard.
4 # @author npcers.eth
5 # @license MIT
6 # Modified from: https://github.com/vyperlang/vyper/blob/de74722bf2d8718cca46902be165f9fe0e3641dd/examples/tokens/ERC721.vy
7 
8 """
9          :=+******++=-:                 
10       -+*+======------=+++=:            
11      #+========------------=++=.        
12     #+=======------------------++:      
13    *+=======--------------------:++     
14   =*=======------------------------*.   
15  .%========-------------------------*.  
16  %+=======-------------------------:-#  
17 +*========--------------------------:#  
18 %=========--------------------------:#. 
19 %=========--------------------+**=--:++ 
20 #+========-----=*#%#=--------#@@@@+-::*:
21 :%========-----+@@@@%=-------=@@@@#-::+=
22  -#======-------+@@@%=----=*=--+**=-::#:
23   :#+====---------==----===@%=------::% 
24     #+===-------------======@%=------:=+
25     .%===------------=======+@%------::#
26      #+==-----------=========+@%-------+
27      %===------------*%%%%%%%%@@#-----#.
28      %====-----------============----#: 
29      *+==#+----------+##%%%%%%%%@--=*.  
30      -#==+%=---------=+=========--*=    
31       +===+%+--------------------*-     
32        =====*#=------------------#      
33        .======*#*=------------=*+.      
34          -======+*#*+--------*+         
35           .-========+***+++=-.          
36              .-=======:           
37 
38 """
39 
40 from vyper.interfaces import ERC20
41 from vyper.interfaces import ERC165
42 from vyper.interfaces import ERC721
43 
44 implements: ERC721
45 implements: ERC165
46 
47 # Interface for the contract called by safeTransferFrom()
48 interface ERC721Receiver:
49     def onERC721Received(
50             operator: address,
51             sender: address,
52             tokenId: uint256,
53             data: Bytes[1024]
54         ) -> bytes4: nonpayable
55 
56 
57 # @dev Emits when ownership of any NFT changes by any mechanism.
58 #      This event emits when NFTs are created (`from` == 0) and destroyed (`to` == 0).
59 #      Exception: during contract creation, any number of NFTs may be created and assigned without emitting.
60 #      At the time of any transfer, the approved address for that NFT (if any) is reset to none.
61 # @param _from Sender of NFT (if address is zero address it indicates token creation).
62 # @param _to Receiver of NFT (if address is zero address it indicates token destruction).
63 # @param _tokenId The NFT that got transfered.
64 
65 event Transfer:
66     _from: indexed(address)
67     _to: indexed(address)
68     _tokenId: indexed(uint256)
69 
70 
71 # @dev This emits when the approved address for an NFT is changed or reaffirmed.
72 #      The zero address indicates there is no approved address.
73 #      When a Transfer event emits, this also indicates any approved address resets to none.
74 # @param _owner Owner of NFT.
75 # @param _approved Address that we are approving.
76 # @param _tokenId NFT which we are approving.
77 
78 event Approval:
79     _owner: indexed(address)
80     _approved: indexed(address)
81     _tokenId: indexed(uint256)
82 
83 
84 # @dev This emits when an operator is enabled or disabled for an owner.
85 #      The operator can manage all NFTs of the owner.
86 # @param _owner Owner of NFT.
87 # @param _operator Address to which we are setting operator rights.
88 # @param _approved Status of operator rights (true if operator rights given, false if revoked).
89 
90 event ApprovalForAll:
91     _owner: indexed(address)
92     _operator: indexed(address)
93     _approved: bool
94 
95 IDENTITY_PRECOMPILE: constant(address) = 0x0000000000000000000000000000000000000004
96 
97 # Metadata
98 symbol: public(String[32])
99 name: public(String[32])
100 
101 # Permission
102 owner: public(address)
103 minter: public(address)
104 
105 # URI
106 base_uri: public(String[128])
107 contract_uri: String[128]
108 
109 # NFT Data
110 token_by_owner: HashMap[address, HashMap[uint256, uint256]]
111 token_count: uint256
112 
113 owned_tokens: HashMap[uint256, address]                       # @dev NFT ID to the address that owns it
114 token_approvals: HashMap[uint256, address]                    # @dev NFT ID to approved address
115 operator_approvals: HashMap[address, HashMap[address, bool]]  # @dev Owner address to mapping of operator addresses
116 balances: HashMap[address, uint256]                           # @dev Owner address to token count
117 
118 # @dev Static list of supported ERC165 interface ids
119 SUPPORTED_INTERFACES: constant(bytes4[5]) = [
120     0x01FFC9A7,  # ERC165
121     0x80AC58CD,  # ERC721
122     0x150B7A02,  # ERC721TokenReceiver
123     0x780E9D63,  # ERC721Enumerable
124     0x5B5E139F,  # ERC721Metadata
125 ]
126 
127 # Custom NPC
128 revealed: public(bool)
129 default_uri: public(String[150])
130 
131 
132 @external
133 def __init__():
134     self.symbol = "NPC"
135     self.name = "NPC-ers"
136 
137     self.owner = msg.sender
138     self.minter = msg.sender
139 
140     self.base_uri = "ipfs://bafybeibzrvcnrfzy6q5t5tkzmzktdqwlbvywtgzxybdkycubquh3e5rl2u/"
141     self.contract_uri = "ipfs://QmTPTu31EEFawxbXEiAaZehLajRAKc7YhxPkTSg31SNVSe"
142     self.default_uri = "ipfs://QmPQZadNVNeJ729toJ3ZTjSvC2xhgsQDJuwfSJRN43T2eu"
143 
144     self.revealed = True
145 
146 
147 @pure
148 @external
149 def supportsInterface(interface_id: bytes4) -> bool:
150     """
151     @notice Query if a contract implements an interface.
152     @dev Interface identification is specified in ERC-165.
153     @param interface_id Bytes4 representing the interface.
154     @return bool True if supported.
155     """
156 
157     return interface_id in SUPPORTED_INTERFACES
158 
159 
160 ### VIEW FUNCTIONS ###
161 
162 
163 @view
164 @external
165 def balanceOf(owner: address) -> uint256:
166     """
167     @notice Count all NFTs assigned to an owner.
168     @dev Returns the number of NFTs owned by `owner`.
169          Throws if `owner` is the zero address.
170          NFTs assigned to the zero address are considered invalid.
171     @param owner Address for whom to query the balance.
172     @return The address of the owner of the NFT
173     """
174 
175     assert owner != empty(address)  # dev: "ERC721: balance query for the zero address"
176     return self.balances[owner]
177 
178 
179 @view
180 @external
181 def ownerOf(token_id: uint256) -> address:
182     """
183     @notice Find the owner of an NFT.
184     @dev Returns the address of the owner of the NFT.
185          Throws if `token_id` is not a valid NFT.
186     @param token_id The identifier for an NFT.
187     @return The address of the owner of the NFT
188     """
189 
190     owner: address = self.owned_tokens[token_id]
191     assert owner != empty(address)  # dev: "ERC721: owner query for nonexistent token"
192     return owner
193 
194 
195 @view
196 @external
197 def getApproved(token_id: uint256) -> address:
198     """
199     @notice Get the approved address for a single NFT
200     @dev Get the approved address for a single NFT.
201          Throws if `token_id` is not a valid NFT.
202     @param token_id ID of the NFT for which to query approval.
203     @return The approved address for this NFT, or the zero address if there is none
204     """
205 
206     assert self.owned_tokens[token_id] != empty(
207         address
208     )  # dev: "ERC721: approved query for nonexistent token"
209     return self.token_approvals[token_id]
210 
211 
212 @view
213 @external
214 def isApprovedForAll(owner: address, operator: address) -> bool:
215     """
216     @notice Query if an address is an authorized operator for another address
217     @dev Checks if `operator` is an approved operator for `owner`.
218     @param owner The address that owns the NFTs.
219     @param operator The address that acts on behalf of the owner.
220     @return True if `_operator` is an approved operator for `_owner`, false otherwise
221     """
222 
223     return (self.operator_approvals[owner])[operator]
224 
225 
226 ### TRANSFER FUNCTION HELPERS ###
227 
228 
229 @view
230 @internal
231 def _is_approved_or_owner(spender: address, token_id: uint256) -> bool:
232     """
233     @dev Returns whether the given spender can transfer a given token ID
234     @param spender address of the spender to query
235     @param token_id uint256 ID of the token to be transferred
236     @return bool whether the msg.sender is approved for the given token ID,
237         is an operator of the owner, or is the owner of the token
238     """
239 
240     owner: address = self.owned_tokens[token_id]
241     spender_is_owner: bool = owner == spender
242     spender_is_approved: bool = spender == self.token_approvals[token_id]
243     spender_is_approved_for_all: bool = self.operator_approvals[owner][spender]
244 
245     return (spender_is_owner or spender_is_approved) or spender_is_approved_for_all
246 
247 
248 @internal
249 def _add_token_to(_to: address, _token_id: uint256):
250     """
251     @dev Add a NFT to a given address
252          Throws if `_token_id` is owned by someone.
253     """
254 
255     # Throws if `_token_id` is owned by someone
256     assert self.owned_tokens[_token_id] == empty(address)
257 
258     # Change the owner
259     self.owned_tokens[_token_id] = _to
260 
261     # Change count tracking
262     self.token_by_owner[_to][self.balances[_to]] = _token_id
263     self.balances[_to] += 1
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
279     # Change count tracking
280     self.balances[_from] -= 1
281 
282 
283 @internal
284 def _clear_approval(_owner: address, _token_id: uint256):
285     """
286     @dev Clear an approval of a given address
287          Throws if `_owner` is not the current owner.
288     """
289 
290     # Throws if `_owner` is not the current owner
291     assert self.owned_tokens[_token_id] == _owner
292     if self.token_approvals[_token_id] != empty(address):
293         # Reset approvals
294         self.token_approvals[_token_id] = empty(address)
295 
296 
297 @internal
298 def _transfer_from(_from: address, _to: address, _token_id: uint256, _sender: address):
299     """
300     @dev Execute transfer of a NFT.
301          Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
302          address for this NFT. (NOTE: `msg.sender` not allowed in private function so pass `_sender`.)
303          Throws if `_to` is the zero address.
304          Throws if `_from` is not the current owner.
305          Throws if `_token_id` is not a valid NFT.
306     """
307 
308     # Throws if `_to` is the zero address
309     assert _to != empty(address)  # dev : "ERC721: transfer to the zero address"
310 
311     # Check requirements
312     assert self._is_approved_or_owner(
313         _sender, _token_id
314     )  # dev : "ERC721: transfer caller is not owner nor approved"
315 
316     # Clear approval. Throws if `_from` is not the current owner
317     self._clear_approval(_from, _token_id)
318 
319     # Remove NFT. Throws if `_token_id` is not a valid NFT
320     self._remove_token_from(_from, _token_id)
321 
322     # Add NFT
323     self._add_token_to(_to, _token_id)
324 
325     # Log the transfer
326     log Transfer(_from, _to, _token_id)
327 
328 
329 ### TRANSFER FUNCTIONS ###
330 
331 
332 @external
333 def transferFrom(from_addr: address, to_addr: address, token_id: uint256):
334     """
335     @dev Throws unless `msg.sender` is the current owner, an authorized operato_addrr, or the approved address for this NFT.
336          Throws if `from_addr` is not the current owner.
337          Throws if `to_addr` is the zero address.
338          Throws if `token_id` is not a valid NFT.
339     @notice The caller is responsible to_addr confirm that `to_addr` is capable of receiving NFTs or else they maybe be permanently lost.
340     @param from_addr The current owner of the NFT.
341     @param to_addr The new owner.
342     @param token_id The NFT to_addr transfer.
343     """
344 
345     self._transfer_from(from_addr, to_addr, token_id, msg.sender)
346 
347 
348 @external
349 def safeTransferFrom(
350     from_addr: address, to_addr: address, token_id: uint256, data: Bytes[1024] = b""
351 ):
352     """
353     @dev Transfers the ownership of an NFT from one address to another address.
354          Throws unless `msg.sender` is the current owner, an authorized operator, or the approved address for this NFT.
355          Throws if `from_addr` is not the current owner.
356          Throws if `to_addr` is the zero address.
357          Throws if `token_id` is not a valid NFT.
358          If `to_addr` is a smart contract, it calls `onERC721Received` on `to_addr` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
359          NOTE: bytes4 is represented by bytes32 with padding
360     @param from_addr The current owner of the NFT.
361     @param to_addr The new owner.
362     @param token_id The NFT to transfer.
363     @param data Additional data with no specified format, sent in call to `to_addr`.
364     """
365 
366     self._transfer_from(from_addr, to_addr, token_id, msg.sender)
367 
368     if to_addr.is_contract:  # check if `to_addr` is a contract address
369         return_value: bytes4 = ERC721Receiver(to_addr).onERC721Received(
370             msg.sender, from_addr, token_id, data
371         )
372 
373         # Throws if transfer destination is a contract which does not implement 'onERC721Received'
374         assert return_value == method_id(
375             "onERC721Received(address,address,uint256,bytes)", output_type=bytes4
376         )
377 
378 
379 @external
380 def approve(approved: address, token_id: uint256):
381     """
382     @notice Change or reaffirm the approved address for an NFT
383     @dev Set or reaffirm the approved address for an NFT. The zero address indicates there is no approved address.
384          Throws unless `msg.sender` is the current NFT owner, or an authorized operator of the current owner.
385          Throws if `token_id` is not a valid NFT. (NOTE: This is not written the EIP)
386          Throws if `approved` is the current owner. (NOTE: This is not written the EIP)
387     @param approved Address to be approved for the given NFT ID.
388     @param token_id ID of the token to be approved.
389     """
390 
391     owner: address = self.owned_tokens[token_id]
392 
393     # Throws if `token_id` is not a valid NFT
394     assert owner != empty(address)  # dev: "ERC721: owner query for nonexistent token"
395 
396     # Throws if `approved` is the current owner
397     assert approved != owner  # dev: "ERC721: approval to current owner"
398 
399     # Check requirements
400     is_owner: bool = self.owned_tokens[token_id] == msg.sender
401     is_approved_all: bool = (self.operator_approvals[owner])[msg.sender]
402     assert (
403         is_owner or is_approved_all
404     )  # dev: "ERC721: approve caller is not owner nor approved for all"
405 
406     # Set the approval
407     self.token_approvals[token_id] = approved
408 
409     log Approval(owner, approved, token_id)
410 
411 
412 @external
413 def setApprovalForAll(operator: address, approved: bool):
414     """
415     @notice notice Enable or disable approval for a third party ("operator") to manage all of `msg.sender`'s assets
416     @dev Enables or disables approval for a third party ("operator") to manage all of`msg.sender`'s assets. It also emits the ApprovalForAll event.
417          Throws if `operator` is the `msg.sender`. (NOTE: This is not written the EIP)
418     This works even if sender doesn't own any tokens at the time.
419     @param operator Address to add to the set of authorized operators.
420     @param approved True if the operators is approved, false to revoke approval.
421     """
422 
423     # Throws if `operator` is the `msg.sender`
424     assert operator != msg.sender
425     self.operator_approvals[msg.sender][operator] = approved
426 
427     log ApprovalForAll(msg.sender, operator, approved)
428 
429 
430 ### MINT FUNCTIONS ###
431 
432 
433 @external
434 def mint(receiver: address):
435     """
436     @notice Function to mint a token
437     @dev Function to mint tokens
438          Throws if `msg.sender` is not the minter.
439          Throws if `_to` is zero address.
440     """
441 
442     # Checks
443     assert msg.sender in [self.minter, self.owner]
444     assert receiver != empty(address)  # dev: Cannot mint to empty address
445 
446     # Add NFT. Throws if `_token_id` is owned by someone
447     token_id: uint256 = self.token_count
448     self._add_token_to(receiver, token_id)
449     self.token_count += 1
450 
451     log Transfer(empty(address), receiver, token_id)
452 
453 
454 ### ERC721-URI STORAGE FUNCTIONS ###
455 
456 
457 @external
458 @view
459 def tokenURI(token_id: uint256) -> String[256]:
460     """
461     @notice A distinct Uniform Resource Identifier (URI) for a given asset.
462     @dev Throws if `_token_id` is not a valid NFT. URIs are defined in RFC 6686. The URI may point to a JSON file that conforms to the "ERC721 Metadata JSON Schema".
463     """
464     if self.owned_tokens[token_id] == empty(address):
465         raise  # dev: "ERC721URIStorage: URI query for nonexistent token"
466 
467     if self.revealed:
468         return concat(self.base_uri, uint2str(token_id))
469     else:
470         return self.default_uri
471 
472 
473 @external
474 @view
475 def contractURI() -> String[128]:
476     """
477     @notice URI for contract level metadata
478     @return Contract URI
479     """
480     return self.contract_uri
481 
482 
483 ### ADMIN FUNCTIONS
484 
485 
486 @external
487 def set_base_uri(base_uri: String[128]):
488     """
489     @notice Admin function to set a new Base URI for
490     @dev Globally prepended to token_uri
491     @param base_uri New URI for the token
492 
493     """
494     assert msg.sender == self.owner
495     self.base_uri = base_uri
496 
497 
498 @external
499 def set_contract_uri(new_uri: String[66]):
500     """
501     @notice Admin function to set a new contract URI
502     @param new_uri New URI for the contract
503     """
504 
505     assert msg.sender in [self.owner, self.minter]  # dev: Only Admin
506     self.contract_uri = new_uri
507 
508 
509 @external
510 def set_owner(new_addr: address):
511     """
512     @notice Admin function to update owner
513     @param new_addr The new owner address to take over immediately
514     """
515 
516     assert msg.sender == self.owner  # dev: Only Owner
517     self.owner = new_addr
518 
519 
520 @external
521 def set_revealed(flag: bool):
522     """
523     @notice Admin function to reveal collection.  If not revealed, all NFTs show default_uri
524     @param flag Boolean, True to reveal, False to conceal
525     """
526     assert msg.sender in [self.owner, self.minter]
527     self.revealed = flag
528 
529 
530 @external
531 def set_minter(new_address: address):
532     """
533     @notice Admin function to set a new minter address
534     @dev Update the address authorized to mint
535     @param new_address New minter address
536     """
537 
538     assert msg.sender in [self.owner, self.minter]
539     self.minter = new_address
540 
541 
542 @external
543 def admin_withdraw_erc20(coin: address, target: address, amount: uint256):
544     """
545     @notice Withdraw ERC20 tokens accidentally sent to contract
546     @param coin ERC20 address
547     @param target Address to receive
548     @param amount Wei
549     """
550     assert self.owner == msg.sender  # dev: "Admin Only"
551     ERC20(coin).transfer(target, amount)
552 
553 
554 ## ERC-721 Enumerable Functions
555 
556 
557 @external
558 @view
559 def totalSupply() -> uint256:
560     """
561     @notice Enumerate valid NFTs
562     @dev Throws if `_index` >= `totalSupply()`.
563     @return The token identifier for the `_index`th NFT
564     """
565     return self.token_count
566 
567 
568 @external
569 @view
570 def tokenByIndex(_index: uint256) -> uint256:
571     """
572     @notice Enumerate valid NFTs
573     @dev With no burn and direct minting, this is simple
574     @param _index A counter less than `totalSupply()`
575     @return The token identifier for the `_index`th NFT,
576     """
577 
578     return _index
579 
580 
581 @external
582 @view
583 def tokenOfOwnerByIndex(owner: address, index: uint256) -> uint256:
584     """
585     @notice Enumerate NFTs assigned to an owner
586     @dev Throws if `index` >= `balanceOf(owner)` or if `owner` is the zero address, representing invalid NFTs.
587     @param owner An address where we are interested in NFTs owned by them
588     @param index A counter less than `balanceOf(owner)`
589     @return The token identifier for the `index`th NFT assigned to `owner`, (sort order not specified)
590     """
591     assert owner != empty(address)
592     assert index < self.balances[owner]
593     return self.token_by_owner[owner][index]