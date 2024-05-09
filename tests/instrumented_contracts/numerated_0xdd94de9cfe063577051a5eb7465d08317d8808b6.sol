1 pragma solidity ^0.4.0;
2 
3 
4 library ECVerifyLib {
5     // From: https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
6     // Duplicate Solidity's ecrecover, but catching the CALL return value
7     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
8         // We do our own memory management here. Solidity uses memory offset
9         // 0x40 to store the current end of memory. We write past it (as
10         // writes are memory extensions), but don't update the offset so
11         // Solidity will reuse it. The memory used here is only needed for
12         // this context.
13 
14         // FIXME: inline assembly can't access return values
15         bool ret;
16         address addr;
17 
18         assembly {
19             let size := mload(0x40)
20             mstore(size, hash)
21             mstore(add(size, 32), v)
22             mstore(add(size, 64), r)
23             mstore(add(size, 96), s)
24 
25             // NOTE: we can reuse the request memory because we deal with
26             //       the return code
27             ret := call(3000, 1, 0, size, 128, size, 32)
28             addr := mload(size)
29         }
30 
31         return (ret, addr);
32     }
33 
34     function ecrecovery(bytes32 hash, bytes sig) returns (bool, address) {
35         bytes32 r;
36         bytes32 s;
37         uint8 v;
38 
39         if (sig.length != 65)
40           return (false, 0);
41 
42         // The signature format is a compact form of:
43         //   {bytes32 r}{bytes32 s}{uint8 v}
44         // Compact means, uint8 is not padded to 32 bytes.
45         assembly {
46             r := mload(add(sig, 32))
47             s := mload(add(sig, 64))
48 
49             // Here we are loading the last 32 bytes. We exploit the fact that
50             // 'mload' will pad with zeroes if we overread.
51             // There is no 'mload8' to do this, but that would be nicer.
52             v := byte(0, mload(add(sig, 96)))
53 
54             // Alternative solution:
55             // 'byte' is not working due to the Solidity parser, so lets
56             // use the second best option, 'and'
57             // v := and(mload(add(sig, 65)), 255)
58         }
59 
60         // albeit non-transactional signatures are not specified by the YP, one would expect it
61         // to match the YP range of [27, 28]
62         //
63         // geth uses [0, 1] and some clients have followed. This might change, see:
64         //  https://github.com/ethereum/go-ethereum/issues/2053
65         if (v < 27)
66           v += 27;
67 
68         if (v != 27 && v != 28)
69             return (false, 0);
70 
71         return safer_ecrecover(hash, v, r, s);
72     }
73 
74     function ecverify(bytes32 hash, bytes sig, address signer) returns (bool) {
75         bool ret;
76         address addr;
77         (ret, addr) = ecrecovery(hash, sig);
78         return ret == true && addr == signer;
79     }
80 }
81 
82 
83 contract IndividualityTokenInterface {
84     /*
85      *  Events
86      */
87     event Mint(address indexed _owner, bytes32 _tokenID);
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 
91     /*
92      * Read storage functions
93      */
94 
95     /// @dev Return the number of tokens
96     function totalSupply() constant returns (uint256 supply);
97 
98     /// @dev Returns id of token owned by given address (encoded as an integer).
99     /// @param _owner Address of token owner.
100     function balanceOf(address _owner) constant returns (uint256 balance);
101 
102     /// @dev Returns the token id that may transfer from _owner account by _spender..
103     /// @param _owner Address of token owner.
104     /// @param _spender Address of token spender.
105     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
106 
107     /*
108      *  Write storage functions
109      */
110 
111     /// @dev Transfers sender token to given address. Returns success.
112     /// @param _to Address of new token owner.
113     /// @param _value Bytes32 id of the token to transfer.
114     function transfer(address _to, uint256 _value) public returns (bool success);
115     function transfer(address _to) public returns (bool success);
116 
117     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
118     /// @param _from Address of token owner.
119     /// @param _to Address of new token owner.
120     /// @param _value Bytes32 id of the token to transfer.
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
122     function transferFrom(address _from, address _to) public returns (bool success);
123 
124     /// @dev Sets approval spender to transfer ownership of token. Returns success.
125     /// @param _spender Address of spender..
126     /// @param _value Bytes32 id of token that can be spend.
127     function approve(address _spender, uint256 _value) public returns (bool success);
128     function approve(address _spender) public returns (bool success);
129 
130     /*
131      *  Extra non ERC20 functions
132      */
133 
134     /// @dev Returns whether the address owns a token.
135     /// @param _owner Address to check.
136     function isTokenOwner(address _owner) constant returns (bool);
137 
138     /// @dev Returns the address of the owner of the given token id.
139     /// @param _tokenID Bytes32 id of token to lookup.
140     function ownerOf(bytes32 _tokenID) constant returns (address owner);
141 
142     /// @dev Returns the token ID for the given address or 0x0 if they are not a token owner.
143     /// @param _owner Address of the owner to lookup.
144     function tokenId(address _owner) constant returns (bytes32 tokenID);
145 }
146 
147 
148 contract IndividualityTokenRootInterface is IndividualityTokenInterface {
149     /// @dev Imports a token from the Devcon2Token contract.
150     function upgrade() public returns (bool success);
151 
152     /// @dev Upgrades a token from the previous contract
153     /// @param _owner the address of the owner of the token on the original contract
154     /// @param _newOwner the address that should own the token on the new contract.
155     /// @param signature 65 byte signature of the tightly packed bytes (address(this) + _owner + _newOwner), signed by _owner
156     function proxyUpgrade(address _owner,
157                           address _newOwner,
158                           bytes signature) public returns (bool);
159 
160     /// @dev Returns the number of tokens that have been upgraded.
161     function upgradeCount() constant returns (uint256 amount);
162 
163     /// @dev Returns the number of tokens that have been upgraded.
164     /// @param _tokenID the id of the token to query
165     function isTokenUpgraded(bytes32 _tokenID) constant returns (bool isUpgraded);
166 }
167 
168 
169 library TokenEventLib {
170     /*
171      * When underlying solidity issue is fixed this library will not be needed.
172      * https://github.com/ethereum/solidity/issues/1215
173      */
174     event Transfer(address indexed _from,
175                    address indexed _to,
176                    bytes32 indexed _tokenID);
177     event Approval(address indexed _owner,
178                    address indexed _spender,
179                    bytes32 indexed _tokenID);
180 
181     function _Transfer(address _from, address _to, bytes32 _tokenID) public {
182         Transfer(_from, _to, _tokenID);
183     }
184 
185     function _Approval(address _owner, address _spender, bytes32 _tokenID) public {
186         Approval(_owner, _spender, _tokenID);
187     }
188 }
189 
190 
191 contract TokenInterface {
192     /*
193      *  Events
194      */
195     event Mint(address indexed _to, bytes32 _id);
196     event Destroy(bytes32 _id);
197     event Transfer(address indexed _from, address indexed _to, uint256 _value);
198     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
199     event MinterAdded(address who);
200     event MinterRemoved(address who);
201 
202     /*
203      *  Minting
204      */
205     /// @dev Mints a new token.
206     /// @param _to Address of token owner.
207     /// @param _identity String for owner identity.
208     function mint(address _to, string _identity) returns (bool success);
209 
210     /// @dev Destroy a token
211     /// @param _id Bytes32 id of the token to destroy.
212     function destroy(bytes32 _id) returns (bool success);
213 
214     /// @dev Add a new minter
215     /// @param who Address the address that can now mint tokens.
216     function addMinter(address who) returns (bool);
217 
218     /// @dev Remove a minter
219     /// @param who Address the address that will no longer be a minter.
220     function removeMinter(address who) returns (bool);
221 
222     /*
223      *  Read and write storage functions
224      */
225 
226     /// @dev Return the number of tokens
227     function totalSupply() returns (uint supply);
228 
229     /// @dev Transfers sender token to given address. Returns success.
230     /// @param _to Address of new token owner.
231     /// @param _value Bytes32 id of the token to transfer.
232     function transfer(address _to, uint256 _value) returns (bool success);
233     function transfer(address _to, bytes32 _value) returns (bool success);
234 
235     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
236     /// @param _from Address of token owner.
237     /// @param _to Address of new token owner.
238     /// @param _value Bytes32 id of the token to transfer.
239     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
240     function transferFrom(address _from, address _to, bytes32 _value) returns (bool success);
241 
242     /// @dev Sets approval spender to transfer ownership of token. Returns success.
243     /// @param _spender Address of spender..
244     /// @param _value Bytes32 id of token that can be spend.
245     function approve(address _spender, uint256 _value) returns (bool success);
246     function approve(address _spender, bytes32 _value) returns (bool success);
247 
248     /*
249      * Read storage functions
250      */
251     /// @dev Returns id of token owned by given address (encoded as an integer).
252     /// @param _owner Address of token owner.
253     function balanceOf(address _owner) constant returns (uint256 balance);
254 
255     /// @dev Returns the token id that may transfer from _owner account by _spender..
256     /// @param _owner Address of token owner.
257     /// @param _spender Address of token spender.
258     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
259 
260     /*
261      *  Extra non ERC20 functions
262      */
263     /// @dev Returns whether the address owns a token.
264     /// @param _owner Address to check.
265     function isTokenOwner(address _owner) constant returns (bool);
266 
267     /// @dev Returns the identity of the given token id.
268     /// @param _id Bytes32 id of token to lookup.
269     function identityOf(bytes32 _id) constant returns (string identity);
270 
271     /// @dev Returns the address of the owner of the given token id.
272     /// @param _id Bytes32 id of token to lookup.
273     function ownerOf(bytes32 _id) constant returns (address owner);
274 }
275 
276 
277 contract IndividualityTokenRoot is IndividualityTokenRootInterface {
278     TokenInterface public devcon2Token;
279 
280     function IndividualityTokenRoot(address _devcon2Token) {
281         devcon2Token = TokenInterface(_devcon2Token);
282     }
283 
284     // owner => token
285     mapping (address => bytes32) ownerToToken;
286 
287     // token => owner
288     mapping (bytes32 => address) tokenToOwner;
289 
290     // owner => spender => token
291     mapping (address => mapping (address => bytes32)) approvals;
292 
293     uint _upgradeCount;
294 
295     /*
296      * Internal Helpers
297      */
298     function isEligibleForUpgrade(address _owner) internal returns (bool) {
299         if (ownerToToken[_owner] != 0x0) {
300             // already a token owner
301             return false;
302         } else if (!devcon2Token.isTokenOwner(_owner)) {
303             // not a token owner on the original devcon2Token contract.
304             return false;
305         } else if (isTokenUpgraded(bytes32(devcon2Token.balanceOf(_owner)))) {
306             // the token has already been upgraded.
307             return false;
308         } else {
309             return true;
310         }
311     }
312 
313     /*
314      * Any function modified with this will perform the `upgrade` call prior to
315      * execution which allows people to use this contract as-if they had
316      * already processed the upgrade.
317      */
318     modifier silentUpgrade {
319         if (isEligibleForUpgrade(msg.sender)) {
320             upgrade();
321         }
322         _;
323     }
324 
325 
326     /// @dev Return the number of tokens
327     function totalSupply() constant returns (uint256) {
328         return devcon2Token.totalSupply();
329     }
330 
331     /// @dev Returns id of token owned by given address (encoded as an integer).
332     /// @param _owner Address of token owner.
333     function balanceOf(address _owner) constant returns (uint256 balance) {
334         if (_owner == 0x0) {
335             return 0;
336         } else if (ownerToToken[_owner] == 0x0) {
337             // not a current token owner.  Check whether they are on the
338             // original contract.
339             if (devcon2Token.isTokenOwner(_owner)) {
340                 // pull the tokenID
341                 var tokenID = bytes32(devcon2Token.balanceOf(_owner));
342 
343                 if (tokenToOwner[tokenID] == 0x0) {
344                     // the token hasn't yet been upgraded so we can return 1.
345                     return 1;
346                 }
347             }
348             return 0;
349         } else {
350             return 1;
351         }
352     }
353 
354     /// @dev Returns the token id that may transfer from _owner account by _spender..
355     /// @param _owner Address of token owner.
356     /// @param _spender Address of token spender.
357     function allowance(address _owner,
358                        address _spender) constant returns (uint256 remaining) {
359         var approvedTokenID = approvals[_owner][_spender];
360 
361         if (approvedTokenID == 0x0) {
362             return 0;
363         } else if (_owner == 0x0 || _spender == 0x0) {
364             return 0;
365         } else if (tokenToOwner[approvedTokenID] == _owner) {
366             return 1;
367         } else {
368             return 0;
369         }
370     }
371 
372     /// @dev Transfers sender token to given address. Returns success.
373     /// @param _to Address of new token owner.
374     /// @param _value Bytes32 id of the token to transfer.
375     function transfer(address _to,
376                       uint256 _value) public silentUpgrade returns (bool success) {
377         if (_value != 1) {
378             // 1 is the only value that makes any sense here.
379             return false;
380         } else if (_to == 0x0) {
381             // cannot transfer to the null address.
382             return false;
383         } else if (ownerToToken[msg.sender] == 0x0) {
384             // msg.sender is not a token owner
385             return false;
386         } else if (ownerToToken[_to] != 0x0) {
387             // cannot transfer to an address that already owns a token.
388             return false;
389         } else if (isEligibleForUpgrade(_to)) {
390             // cannot transfer to an account which is still holding their token
391             // in the old system.
392             return false;
393         }
394 
395         // pull the token id.
396         var tokenID = ownerToToken[msg.sender];
397 
398         // remove the token from the sender.
399         ownerToToken[msg.sender] = 0x0;
400 
401         // assign the token to the new owner
402         ownerToToken[_to] = tokenID;
403         tokenToOwner[tokenID] = _to;
404 
405         // log the transfer
406         Transfer(msg.sender, _to, 1);
407         TokenEventLib._Transfer(msg.sender, _to, tokenID);
408 
409         return true;
410     }
411 
412     /// @dev Transfers sender token to given address. Returns success.
413     /// @param _to Address of new token owner.
414     function transfer(address _to) public returns (bool success) {
415         return transfer(_to, 1);
416     }
417 
418     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
419     /// @param _from Address of token owner.
420     /// @param _to Address of new token owner.
421     /// @param _value Bytes32 id of the token to transfer.
422     function transferFrom(address _from,
423                           address _to,
424                           uint256 _value) public returns (bool success) {
425         if (_value != 1) {
426             // Cannot transfer anything other than 1 token.
427             return false;
428         } else if (_to == 0x0) {
429             // Cannot transfer to the null address
430             return false;
431         } else if (ownerToToken[_from] == 0x0) {
432             // Cannot transfer if _from is not a token owner
433             return false;
434         } else if (ownerToToken[_to] != 0x0) {
435             // Cannot transfer to an existing token owner
436             return false;
437         } else if (approvals[_from][msg.sender] != ownerToToken[_from]) {
438             // The approved token doesn't match the token being transferred.
439             return false;
440         } else if (isEligibleForUpgrade(_to)) {
441             // cannot transfer to an account which is still holding their token
442             // in the old system.
443             return false;
444         }
445 
446         // pull the tokenID
447         var tokenID = ownerToToken[_from];
448 
449         // null out the approval
450         approvals[_from][msg.sender] = 0x0;
451 
452         // remove the token from the sender.
453         ownerToToken[_from] = 0x0;
454 
455         // assign the token to the new owner
456         ownerToToken[_to] = tokenID;
457         tokenToOwner[tokenID] = _to;
458 
459         // log the transfer
460         Transfer(_from, _to, 1);
461         TokenEventLib._Transfer(_from, _to, tokenID);
462 
463         return true;
464     }
465 
466     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
467     /// @param _from Address of token owner.
468     /// @param _to Address of new token owner.
469     function transferFrom(address _from, address _to) public returns (bool success) {
470         return transferFrom(_from, _to, 1);
471     }
472 
473     /// @dev Sets approval spender to transfer ownership of token. Returns success.
474     /// @param _spender Address of spender..
475     /// @param _value Bytes32 id of token that can be spend.
476     function approve(address _spender,
477                      uint256 _value) public silentUpgrade returns (bool success) {
478         if (_value != 1) {
479             // cannot approve any value other than 1
480             return false;
481         } else if (_spender == 0x0) {
482             // cannot approve the null address as a spender.
483             return false;
484         } else if (ownerToToken[msg.sender] == 0x0) {
485             // cannot approve if not a token owner.
486             return false;
487         }
488 
489         var tokenID = ownerToToken[msg.sender];
490         approvals[msg.sender][_spender] = tokenID;
491 
492         Approval(msg.sender, _spender, 1);
493         TokenEventLib._Approval(msg.sender, _spender, tokenID);
494 
495         return true;
496     }
497 
498     /// @dev Sets approval spender to transfer ownership of token. Returns success.
499     /// @param _spender Address of spender..
500     function approve(address _spender) public returns (bool success) {
501         return approve(_spender, 1);
502     }
503 
504     /*
505      *  Extra non ERC20 functions
506      */
507     /// @dev Returns whether the address owns a token.
508     /// @param _owner Address to check.
509     function isTokenOwner(address _owner) constant returns (bool) {
510         if (_owner == 0x0) {
511             return false;
512         } else if (ownerToToken[_owner] == 0x0) {
513             // Check if the owner has a token on the main devcon2Token contract.
514             if (devcon2Token.isTokenOwner(_owner)) {
515                 // pull the token ID
516                 var tokenID = bytes32(devcon2Token.balanceOf(_owner));
517 
518                 if (tokenToOwner[tokenID] == 0x0) {
519                     // They own an un-transfered token in the parent
520                     // devcon2Token contract.
521                     return true;
522                 }
523             }
524             return false;
525         } else {
526             return true;
527         }
528     }
529 
530     /// @dev Returns the address of the owner of the given token id.
531     /// @param _tokenID Bytes32 id of token to lookup.
532     function ownerOf(bytes32 _tokenID) constant returns (address owner) {
533         if (_tokenID == 0x0) {
534             return 0x0;
535         } else if (tokenToOwner[_tokenID] != 0x0) {
536             return tokenToOwner[_tokenID];
537         } else {
538             return devcon2Token.ownerOf(_tokenID);
539         }
540     }
541 
542     /// @dev Returns the token ID for the given address or 0x0 if they are not a token owner.
543     /// @param _owner Address of the owner to lookup.
544     function tokenId(address _owner) constant returns (bytes32 tokenID) {
545         if (_owner == 0x0) {
546             return 0x0;
547         } else if (ownerToToken[_owner] != 0x0) {
548             return ownerToToken[_owner];
549         } else {
550             tokenID = bytes32(devcon2Token.balanceOf(_owner));
551             if (tokenToOwner[tokenID] == 0x0) {
552                 // this token has not been transfered yet so return the proxied
553                 // value.
554                 return tokenID;
555             } else {
556                 // The token has already been transferred so ignore the parent
557                 // contract data.
558                 return 0x0;
559             }
560         }
561     }
562 
563     /// @dev Upgrades a token from the previous contract
564     function upgrade() public returns (bool success) {
565         if (!devcon2Token.isTokenOwner(msg.sender)) {
566             // not a token owner.
567             return false;
568         } else if (ownerToToken[msg.sender] != 0x0) {
569             // already owns a token
570             return false;
571         }
572         
573         // pull the token ID
574         var tokenID = bytes32(devcon2Token.balanceOf(msg.sender));
575 
576         if (tokenID == 0x0) {
577             // (should not be possible but here as a sanity check)
578             // null token is invalid.
579             return false;
580         } else if (tokenToOwner[tokenID] != 0x0) {
581             // already upgraded.
582             return false;
583         } else if (devcon2Token.ownerOf(tokenID) != msg.sender) {
584             // (should not be possible but here as a sanity check)
585             // not the owner of the token.
586             return false;
587         }
588 
589         // Assign the new ownership.
590         ownerToToken[msg.sender] = tokenID;
591         tokenToOwner[tokenID] = msg.sender;
592 
593         // increment the number of tokens that have been upgraded.
594         _upgradeCount += 1;
595 
596         // Log it
597         Mint(msg.sender, tokenID);
598         return true;
599     }
600 
601     /// @dev Upgrades a token from the previous contract
602     /// @param _owner the address of the owner of the token on the original contract
603     /// @param _newOwner the address that should own the token on the new contract.
604     /// @param signature 65 byte signature of the tightly packed bytes (address(this) + _owner + _newOwner), signed by _owner
605     function proxyUpgrade(address _owner,
606                           address _newOwner,
607                           bytes signature) public returns (bool) {
608         if (_owner == 0x0 || _newOwner == 0x0) {
609             // cannot work with null addresses.
610             return false;
611         } else if (!devcon2Token.isTokenOwner(_owner)) {
612             // not a token owner on the original devcon2Token contract.
613             return false;
614         }
615 
616         bytes32 tokenID = bytes32(devcon2Token.balanceOf(_owner));
617 
618         if (tokenID == 0x0) {
619             // (should not be possible since we already checked isTokenOwner
620             // but I like being explicit)
621             return false;
622         } else if (isTokenUpgraded(tokenID)) {
623             // the token has already been upgraded.
624             return false;
625         } else if (ownerToToken[_newOwner] != 0x0) {
626             // new owner already owns a token
627             return false;
628         } else if (_owner != _newOwner && isEligibleForUpgrade(_newOwner)) {
629             // cannot upgrade to account that is still has an upgradable token
630             // on the old system.
631             return false;
632         }
633 
634         bytes32 signatureHash = sha3(address(this), _owner, _newOwner);
635 
636         if (!ECVerifyLib.ecverify(signatureHash, signature, _owner)) {
637             return false;
638         }
639 
640         // Assign the new token
641         tokenToOwner[tokenID] = _newOwner;
642         ownerToToken[_newOwner] = tokenID;
643 
644         // increment the number of tokens that have been upgraded.
645         _upgradeCount += 1;
646 
647         // Log it
648         Mint(_newOwner, tokenID);
649 
650         return true;
651     }
652 
653     /// @dev Returns the number of tokens that have been upgraded.
654     function upgradeCount() constant returns (uint256 _amount) {
655         return _upgradeCount;
656     }
657 
658     /// @dev Returns the number of tokens that have been upgraded.
659     /// @param _tokenID the id of the token to query
660     function isTokenUpgraded(bytes32 _tokenID) constant returns (bool isUpgraded) {
661         return (tokenToOwner[_tokenID] != 0x0);
662     }
663 }
664 
665 
666 contract MainnetIndividualityTokenRoot is 
667          IndividualityTokenRoot(0x0a43edfe106d295e7c1e591a4b04b5598af9474c) {
668 }