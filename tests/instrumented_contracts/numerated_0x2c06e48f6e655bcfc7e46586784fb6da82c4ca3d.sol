1 pragma solidity ^0.4.0;
2 
3 // CryptoTulip Contract
4 // more info at https://cryptotulip.co
5 
6 
7 
8 
9 //*********************************************************************
10 // Land Contract
11 //
12 //                              Apache License
13 //                       Version 2.0, January 2004
14 //                     http://www.apache.org/licenses/
15 // TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
16 
17 // Definitions.
18 
19 // "License" shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.
20 
21 // "Licensor" shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.
22 
23 // "Legal Entity" shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, "control" means (i) the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or (ii) ownership of fifty percent (50%) or more of the outstanding shares, or (iii) beneficial ownership of such entity.
24 
25 // "You" (or "Your") shall mean an individual or Legal Entity exercising permissions granted by this License.
26 
27 // "Source" form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.
28 
29 // "Object" form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.
30 
31 // "Work" shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).
32 
33 // "Derivative Works" shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.
34 
35 // "Contribution" shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, "submitted" means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as "Not a Contribution."
36 
37 // "Contributor" shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.
38 
39 // Grant of Copyright License. Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.
40 
41 // Grant of Patent License. Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.
42 
43 // Redistribution. You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:
44 
45 // (a) You must give any other recipients of the Work or Derivative Works a copy of this License; and
46 
47 // (b) You must cause any modified files to carry prominent notices stating that You changed the files; and
48 
49 // (c) You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
50 
51 // (d) If the Work includes a "NOTICE" text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.
52 
53 // You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.
54 
55 // Submission of Contributions. Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.
56 
57 // Trademarks. This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.
58 
59 // Disclaimer of Warranty. Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.
60 
61 // Limitation of Liability. In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.
62 
63 // Accepting Warranty or Additional Liability. While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.
64 
65 // END OF TERMS AND CONDITIONS
66 
67 // APPENDIX: How to apply the Apache License to your work.
68 
69 //   To apply the Apache License to your work, attach the following
70 //   boilerplate notice, with the fields enclosed by brackets "[]"
71 //   replaced with your own identifying information. (Don't include
72 //   the brackets!)  The text should be enclosed in the appropriate
73 //   comment syntax for the file format. We also recommend that a
74 //   file or class name and description of purpose be included on the
75 //   same "printed page" as the copyright notice for easier
76 //   identification within third-party archives.
77 // Copyright [yyyy] [name of copyright owner]
78 
79 // Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
80 
81 //   http://www.apache.org/licenses/LICENSE-2.0
82 // Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
83 
84 
85 
86 contract NFT {
87   function totalSupply() public constant returns (uint);
88   function balanceOf(address) public constant returns (uint);
89 
90   function tokenOfOwnerByIndex(address owner, uint index) external constant returns (uint);
91   function ownerOf(uint tokenId) external constant returns (address);
92 
93   function transfer(address to, uint tokenId) public;
94   function takeOwnership(uint tokenId) external;
95   function transferFrom(address from, address to, uint tokenId) external;
96   function approve(address beneficiary, uint tokenId) external;
97 
98   function metadata(uint tokenId) external constant returns (string);
99 }
100 
101 contract NFTEvents {
102   event Transferred(uint tokenId, address from, address to);
103   event Approval(address owner, address beneficiary, uint tokenId);
104   event MetadataUpdated(uint tokenId, address owner, string data);
105 }
106 
107 contract BasicNFT is NFT, NFTEvents {
108 
109   uint public totalTokens;
110 
111   // Array of owned tokens for a user
112   mapping(address => uint[]) public ownedTokens;
113   mapping(address => uint) _virtualLength;
114   mapping(uint => uint) _tokenIndexInOwnerArray;
115 
116   // Mapping from token ID to owner
117   mapping(uint => address) public tokenOwner;
118 
119   // Allowed transfers for a token (only one at a time)
120   mapping(uint => address) public allowedTransfer;
121 
122   // Metadata associated with each token
123   mapping(uint => string) public _tokenMetadata;
124 
125   function totalSupply() public constant returns (uint) {
126     return totalTokens;
127   }
128 
129   function balanceOf(address owner) public constant returns (uint) {
130     return _virtualLength[owner];
131   }
132 
133   function tokenOfOwnerByIndex(address owner, uint index) external constant returns (uint) {
134     require(index >= 0 && index < balanceOf(owner));
135     return ownedTokens[owner][index];
136   }
137 
138   function getAllTokens(address owner) public constant returns (uint[]) {
139     uint size = _virtualLength[owner];
140     uint[] memory result = new uint[](size);
141     for (uint i = 0; i < size; i++) {
142       result[i] = ownedTokens[owner][i];
143     }
144     return result;
145   }
146 
147   function ownerOf(uint tokenId) external constant returns (address) {
148     return tokenOwner[tokenId];
149   }
150 
151   function transfer(address to, uint tokenId) public {
152     require(tokenOwner[tokenId] == msg.sender);
153     return _transfer(tokenOwner[tokenId], to, tokenId);
154   }
155 
156   function takeOwnership(uint tokenId) external {
157     require(allowedTransfer[tokenId] == msg.sender);
158     return _transfer(tokenOwner[tokenId], msg.sender, tokenId);
159   }
160 
161   function transferFrom(address from, address to, uint tokenId) external {
162     require(tokenOwner[tokenId] == from);
163     require(allowedTransfer[tokenId] == msg.sender);
164     return _transfer(tokenOwner[tokenId], to, tokenId);
165   }
166 
167   function approve(address beneficiary, uint tokenId) external {
168     require(msg.sender == tokenOwner[tokenId]);
169 
170     if (allowedTransfer[tokenId] != 0) {
171       allowedTransfer[tokenId] = 0;
172     }
173     allowedTransfer[tokenId] = beneficiary;
174     Approval(tokenOwner[tokenId], beneficiary, tokenId);
175   }
176 
177   function tokenMetadata(uint tokenId) external constant returns (string) {
178     return _tokenMetadata[tokenId];
179   }
180 
181   function metadata(uint tokenId) external constant returns (string) {
182     return _tokenMetadata[tokenId];
183   }
184 
185   function updateTokenMetadata(uint tokenId, string _metadata) external {
186     require(msg.sender == tokenOwner[tokenId]);
187     _tokenMetadata[tokenId] = _metadata;
188     MetadataUpdated(tokenId, msg.sender, _metadata);
189   }
190 
191   function _transfer(address from, address to, uint tokenId) internal {
192     _clearApproval(tokenId);
193     if (from != address(0)) {
194         _removeTokenFrom(from, tokenId);
195     }
196     _addTokenTo(to, tokenId);
197     Transferred(tokenId, from, to);
198   }
199 
200   function _clearApproval(uint tokenId) internal {
201     allowedTransfer[tokenId] = 0;
202     Approval(tokenOwner[tokenId], 0, tokenId);
203   }
204 
205   function _removeTokenFrom(address from, uint tokenId) internal {
206     require(_virtualLength[from] > 0);
207 
208     uint length = _virtualLength[from];
209     uint index = _tokenIndexInOwnerArray[tokenId];
210     uint swapToken = ownedTokens[from][length - 1];
211 
212     ownedTokens[from][index] = swapToken;
213     _tokenIndexInOwnerArray[swapToken] = index;
214     _virtualLength[from]--;
215   }
216 
217   function _addTokenTo(address owner, uint tokenId) internal {
218     if (ownedTokens[owner].length == _virtualLength[owner]) {
219       ownedTokens[owner].push(tokenId);
220     } else {
221       ownedTokens[owner][_virtualLength[owner]] = tokenId;
222     }
223     tokenOwner[tokenId] = owner;
224     _tokenIndexInOwnerArray[tokenId] = _virtualLength[owner];
225     _virtualLength[owner]++;
226   }
227 }
228 
229 
230 pragma solidity ^0.4.0;
231 
232 //******************************************************************************
233 //
234 // OpenZeppelin contracts
235 //
236 // The MIT License (MIT)
237 
238 // Copyright (c) 2016 Smart Contract Solutions, Inc.
239 
240 // Permission is hereby granted, free of charge, to any person obtaining
241 // a copy of this software and associated documentation files (the
242 // "Software"), to deal in the Software without restriction, including
243 // without limitation the rights to use, copy, modify, merge, publish,
244 // distribute, sublicense, and/or sell copies of the Software, and to
245 // permit persons to whom the Software is furnished to do so, subject to
246 // the following conditions:
247 
248 // The above copyright notice and this permission notice shall be included
249 // in all copies or substantial portions of the Software.
250 
251 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
252 // OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
253 // MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
254 // IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
255 // CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
256 // TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
257 // SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
258 
259 
260 
261 /**
262  * @title Ownable
263  * @dev The Ownable contract has an owner address, and provides basic authorization control
264  * functions, this simplifies the implementation of "user permissions".
265  */
266 contract Ownable {
267   address public owner;
268 
269 
270   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272 
273   /**
274    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
275    * account.
276    */
277   function Ownable() public {
278     owner = msg.sender;
279   }
280 
281 
282   /**
283    * @dev Throws if called by any account other than the owner.
284    */
285   modifier onlyOwner() {
286     require(msg.sender == owner);
287     _;
288   }
289 
290 
291   /**
292    * @dev Allows the current owner to transfer control of the contract to a newOwner.
293    * @param newOwner The address to transfer ownership to.
294    */
295   function transferOwnership(address newOwner) public onlyOwner {
296     require(newOwner != address(0));
297     OwnershipTransferred(owner, newOwner);
298     owner = newOwner;
299   }
300 
301 }
302 
303 
304 /**
305  * @title Pausable
306  * @dev Base contract which allows children to implement an emergency stop mechanism.
307  */
308 contract Pausable is Ownable {
309   event Pause();
310   event Unpause();
311 
312   bool public paused = false;
313 
314 
315   /**
316    * @dev Modifier to make a function callable only when the contract is not paused.
317    */
318   modifier whenNotPaused() {
319     require(!paused);
320     _;
321   }
322 
323   /**
324    * @dev Modifier to make a function callable only when the contract is paused.
325    */
326   modifier whenPaused() {
327     require(paused);
328     _;
329   }
330 
331   /**
332    * @dev called by the owner to pause, triggers stopped state
333    */
334   function pause() onlyOwner whenNotPaused public {
335     paused = true;
336     Pause();
337   }
338 
339   /**
340    * @dev called by the owner to unpause, returns to normal state
341    */
342   function unpause() onlyOwner whenPaused public {
343     paused = false;
344     Unpause();
345   }
346 }
347 
348 
349 /**
350  * @title Destructible
351  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
352  */
353 contract Destructible is Ownable {
354 
355   function Destructible() public payable { }
356 
357   /**
358    * @dev Transfers the current balance to the owner and terminates the contract.
359    */
360   function destroy() onlyOwner public {
361     selfdestruct(owner);
362   }
363 
364   function destroyAndSend(address _recipient) onlyOwner public {
365     selfdestruct(_recipient);
366   }
367 }
368 
369 
370 
371 
372 
373 
374 //*********************************************************************
375 // CryptoTulip
376 
377 
378 contract CryptoTulip is Destructible, Pausable, BasicNFT {
379 
380     function CryptoTulip() public {
381         // tulip-zero
382         _createTulip(bytes32(-1), 0, 0, 0, address(0));
383         paused = false;
384     }
385 
386     string public name = "CryptoTulip";
387     string public symbol = "TULIP";
388 
389     uint32 internal constant MONTHLY_BLOCKS = 172800;
390 
391     // username
392     mapping(address => string) public usernames;
393 
394 
395     struct Tulip {
396         bytes32 genome;
397         uint64 block;
398         uint64 foundation;
399         uint64 inspiration;
400         uint64 generation;
401     }
402 
403     Tulip[] tulips;
404 
405     uint256 public artistFees = 1 finney;
406 
407     function setArtistFees(uint256 _newFee) external onlyOwner {
408         artistFees = _newFee;
409     }
410 
411     function getTulip(uint256 _id) external view
412       returns (
413         bytes32 genome,
414         uint64 blockNumber,
415         uint64 foundation,
416         uint64 inspiration,
417         uint64 generation
418     ) {
419         require(_id > 0);
420         Tulip storage tulip = tulips[_id];
421 
422         genome = tulip.genome;
423         blockNumber = tulip.block;
424         foundation = tulip.foundation;
425         inspiration = tulip.inspiration;
426         generation = tulip.generation;
427     }
428 
429     // Commission CryptoTulip for abstract deconstructed art.
430     // You: I'd like a painting please. Use my painting for the foundation
431     //      and use that other painting accross the street as inspiration.
432     // Artist: That'll be 10 finneys. Come back one block later.
433     function commissionArt(uint256 _foundation, uint256 _inspiration)
434       external payable whenNotPaused returns (uint)
435     {
436         require(msg.sender == tokenOwner[_foundation]);
437         require(msg.value >= artistFees);
438         uint256 _id = _createTulip(bytes32(0), _foundation, _inspiration, tulips[_foundation].generation + 1, msg.sender);
439         _creativeProcess(_id);
440     }
441 
442     // [Optional] name your masterpiece.
443     // Needs to be funny.
444     function nameArt(uint256 _id, string _newName) external whenNotPaused {
445         require(msg.sender == tokenOwner[_id]);
446         _tokenMetadata[_id] = _newName;
447         MetadataUpdated(_id, msg.sender, _newName);
448     }
449 
450     function setUsername(string _username) external whenNotPaused {
451         usernames[msg.sender] = _username;
452     }
453 
454 
455     // Owner methods
456 
457     uint256 internal constant ORIGINAL_ARTWORK_LIMIT = 10000;
458     uint256 internal originalCount = 0;
459 
460     // Let's the caller create an original artwork with given genome.
461     // For the first month, everyone can create 1 original artwork.
462     // After that, only the owner can create an original, up to 10k pieces.
463     function originalArtwork(bytes32 _genome, address _owner) external payable {
464         address newOwner = _owner;
465         if (newOwner == address(0)) {
466              newOwner = msg.sender;
467         }
468 
469         if (block.number > tulips[0].block + MONTHLY_BLOCKS ) {
470             require(msg.sender == owner);
471             require(originalCount < ORIGINAL_ARTWORK_LIMIT);
472             originalCount++;
473         } else {
474             require(
475                 (msg.value >= artistFees && _virtualLength[msg.sender] < 10) ||
476                 msg.sender == owner);
477         }
478 
479         _createTulip(_genome, 0, 0, 0, newOwner);
480     }
481 
482     // Let's owner withdraw contract balance
483     function withdraw() external onlyOwner {
484         owner.transfer(this.balance);
485     }
486 
487 
488     // *************************************************************************
489     // Internal
490 
491     function _creativeProcess(uint _id) internal {
492         Tulip memory tulip = tulips[_id];
493 
494         require(tulip.genome == bytes32(0));
495         // This is not random. People will know the result before
496         // executing this, because it's based on the last block.
497         // But that's ok. Other way of doing this involved 2 steps,
498         // twice the cost, twice the trouble.
499         bytes32 hash = keccak256(
500             block.blockhash(block.number - 1) ^ block.blockhash(block.number - 2) ^ bytes32(msg.sender));
501 
502         Tulip memory foundation = tulips[tulip.foundation];
503         Tulip memory inspiration = tulips[tulip.inspiration];
504 
505         bytes32 genome = bytes32(0);
506 
507         for (uint8 i = 0; i < 32; i++) {
508             uint8 r = uint8(hash[i]);
509             uint8 gene;
510 
511             if (r % 10 < 2) {
512                gene = uint8(foundation.genome[i]) - 8 + (r / 16);
513             } else if (r % 100 < 99) {
514                gene = uint8(r % 10 < 7 ? foundation.genome[i] : inspiration.genome[i]);
515             } else {
516                 gene = uint8(keccak256(r));
517             }
518 
519             genome = bytes32(gene) | (genome << 8);
520         }
521 
522         tulips[_id].genome = genome;
523     }
524 
525     function _createTulip(
526         bytes32 _genome,
527         uint256 _foundation,
528         uint256 _inspiration,
529         uint256 _generation,
530         address _owner
531     ) internal returns (uint)
532     {
533         Tulip memory newTulip = Tulip({
534             genome: _genome,
535             block: uint64(block.number),
536             foundation: uint64(_foundation),
537             inspiration: uint64(_inspiration),
538             generation: uint64(_generation)
539         });
540 
541         uint256 newTulipId = tulips.push(newTulip) - 1;
542         _transfer(0, _owner, newTulipId);
543         totalTokens++;
544         return newTulipId;
545     }
546 
547 }