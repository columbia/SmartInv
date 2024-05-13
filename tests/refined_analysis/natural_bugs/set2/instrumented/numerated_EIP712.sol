1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /* solhint-disable max-line-length */
6 
7 /**
8  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
9  *
10  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
11  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
12  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
13  *
14  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
15  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
16  * ({_hashTypedDataV4}).
17  *
18  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
19  * the chain id to protect against replay attacks on an eventual fork of the chain.
20  *
21  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
22  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
23  *
24  * _Available since v3.4._
25  */
26 abstract contract EIP712 {
27     /* solhint-disable var-name-mixedcase */
28     bytes32 private immutable _HASHED_NAME;
29     bytes32 private immutable _HASHED_VERSION;
30     bytes32 private constant _TYPE_HASH =
31         keccak256(
32             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
33         );
34 
35     /* solhint-enable var-name-mixedcase */
36 
37     /**
38      * @dev Initializes the domain separator and parameter caches.
39      *
40      * The meaning of `name` and `version` is specified in
41      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
42      *
43      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
44      * - `version`: the current major version of the signing domain.
45      *
46      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
47      * contract upgrade].
48      */
49 
50     constructor(string memory name, string memory version) {
51         _HASHED_NAME = keccak256(bytes(name));
52         _HASHED_VERSION = keccak256(bytes(version));
53     }
54 
55     /**
56      * @dev Returns the domain separator for the current chain.
57      */
58     function _domainSeparatorV4() internal view returns (bytes32) {
59         return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
60     }
61 
62     function _buildDomainSeparator(
63         bytes32 typeHash,
64         bytes32 name,
65         bytes32 version
66     ) private view returns (bytes32) {
67         return keccak256(abi.encode(typeHash, name, version, _getChainId(), address(this)));
68     }
69 
70     /**
71      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
72      * function returns the hash of the fully encoded EIP712 message for this domain.
73      *
74      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
75      *
76      * ```solidity
77      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
78      *     keccak256("Mail(address to,string contents)"),
79      *     mailTo,
80      *     keccak256(bytes(mailContents))
81      * )));
82      * address signer = ECDSA.recover(digest, signature);
83      * ```
84      */
85     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
86         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
87     }
88 
89     function _getChainId() private view returns (uint256 chainId) {
90         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
91         // solhint-disable-next-line no-inline-assembly
92         assembly {
93             chainId := chainid()
94         }
95     }
96 
97     /**
98      * @dev The hash of the name parameter for the EIP712 domain.
99      *
100      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
101      * are a concern.
102      */
103     function _EIP712NameHash() internal view virtual returns (bytes32) {
104         return _HASHED_NAME;
105     }
106 
107     /**
108      * @dev The hash of the version parameter for the EIP712 domain.
109      *
110      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
111      * are a concern.
112      */
113     function _EIP712VersionHash() internal view virtual returns (bytes32) {
114         return _HASHED_VERSION;
115     }
116 }
