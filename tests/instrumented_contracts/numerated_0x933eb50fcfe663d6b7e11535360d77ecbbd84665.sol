1 pragma solidity ^0.4.24;
2 
3 contract ICollectable {
4 
5     function mint(uint32 delegateID, address to) public returns (uint);
6 
7     function transferFrom(address from, address to, uint256 tokenId) public;
8     function approve(address to, uint256 tokenId) public;
9     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
10 
11     function safeTransferFrom(address from, address to, uint256 tokenId) public;
12 
13 }
14 
15 contract Ownable {
16 
17     address public owner;
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     function setOwner(address _owner) public onlyOwner {
24         owner = _owner;
25     }
26 
27     function getOwner() public view returns (address) {
28         return owner;
29     }
30 
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35 
36 }
37 
38 contract SimpleNonceMinter is Ownable {
39 
40     ICollectable collectable;
41     uint32 delegateID;
42     mapping(uint => bool) public nonces;
43     mapping(address => bool) public signers;
44 
45     constructor(ICollectable _collectable, uint32 _delegateID) public {
46         collectable = _collectable;
47         delegateID = _delegateID;
48     }
49 
50     function setCanSign(address _signer, bool _can) public onlyOwner {
51         signers[_signer] = _can;
52     }
53 
54     function mint(bytes memory sig, address to, uint nonce, bool add27) public returns (uint) {
55         require(!nonces[nonce], "can only claim once");
56         bytes32 message = prefixed(keccak256(abi.encodePacked(address(this), nonce)));
57         require(signers[getSigner(message, sig, add27)], "must be signed by approved signer");
58         nonces[nonce] = true;
59         return collectable.mint(delegateID, to);
60     }
61 
62     function getSigner(bytes32 message, bytes memory sig, bool add27) internal pure returns (address) {
63         uint8 v;
64         bytes32 r;
65         bytes32 s;
66 
67         (v, r, s) = splitSignature(sig);
68 
69         if (add27) {
70             v += 27;
71         }
72 
73         return ecrecover(message, v, r, s);
74     }
75 
76     function prefixed(bytes32 hash) internal pure returns (bytes32) {
77         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
78     }
79 
80     function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
81         require(sig.length == 65, "incorrect signature length");
82 
83         assembly {
84             // first 32 bytes, after the length prefix
85             r := mload(add(sig, 32))
86             // second 32 bytes
87             s := mload(add(sig, 64))
88             // final byte (first byte of the next 32 bytes)
89             v := byte(0, mload(add(sig, 96)))
90         }
91 
92         return (v, r, s);
93     }
94 
95 }