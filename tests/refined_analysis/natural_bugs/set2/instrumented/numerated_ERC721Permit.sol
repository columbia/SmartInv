1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {EIP712} from '@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol';
5 import {IERC721Permit} from '../interfaces/IERC721Permit.sol';
6 import {ERC721} from './ERC721.sol';
7 import {IERC721Permit} from '../interfaces/IERC721Permit.sol';
8 import {Counters} from '@openzeppelin/contracts/utils/Counters.sol';
9 import {ECDSA} from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
10 
11 abstract contract ERC721Permit is IERC721Permit, ERC721, EIP712 {
12     using Counters for Counters.Counter;
13 
14     mapping(uint256 => Counters.Counter) private _nonces;
15 
16     bytes32 public immutable _PERMIT_TYPEHASH =
17         keccak256('Permit(address spender,uint256 tokenId,uint256 nonce,uint256 deadline)');
18 
19     constructor(string memory name) EIP712(name, '1') {}
20 
21     /// @inheritdoc IERC721Permit
22     function permit(
23         address spender,
24         uint256 tokenId,
25         uint256 deadline,
26         uint8 v,
27         bytes32 r,
28         bytes32 s
29     ) external override {
30         address owner = _owners[tokenId];
31 
32         require(block.timestamp <= deadline, 'E602');
33 
34         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, spender, tokenId, _useNonce(tokenId), deadline));
35 
36         bytes32 hash = _hashTypedDataV4(structHash);
37 
38         address signer = ECDSA.recover(hash, v, r, s);
39         require(signer != address(0), 'E606');
40         require(signer == owner, 'E603');
41         require(spender != owner, 'E605');
42 
43         _approve(spender, tokenId);
44     }
45 
46     function nonces(uint256 tokenId) public view virtual returns (uint256) {
47         return _nonces[tokenId].current();
48     }
49 
50     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
51         return _domainSeparatorV4();
52     }
53 
54     function _useNonce(uint256 tokenId) internal virtual returns (uint256 current) {
55         Counters.Counter storage nonce = _nonces[tokenId];
56         current = nonce.current();
57         nonce.increment();
58     }
59 }
