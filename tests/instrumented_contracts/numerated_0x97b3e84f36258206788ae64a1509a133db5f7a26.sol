1 pragma solidity ^0.5.10;
2 
3 contract DenshiJitsuin {
4     /// "60f91998: sign(uint256,bytes32,address,bytes)
5     bytes4 SIGN_METHOD_HASH = 0x60f91998;
6     
7     struct Signature {
8         bool isSigned;
9         bytes32 hash;
10     }
11 
12     // mapping(documentId => mapping(signer => Signature))
13     mapping(uint256 => mapping(address => Signature)) private _signatures; 
14     // mapping(documentId => mapping(index => signer)
15     mapping(uint256 => mapping(uint256 => address)) private _documentSigners;
16     // mapping(documentId => signerCount)
17     mapping(uint256 => uint256) private _documentSignerCount;
18 
19     constructor() public {}
20 
21     /// @dev Sign on a specified document.
22     /// @dev _signer should be matched against the msg.sender or an address recovered from _sig
23     /// @param _documentId Document's ID
24     /// @param _documentHash SHA256 hash of the document's content
25     /// @param _signer Account address who is signing to the document
26     /// @param _sig ECDSA signature (for meta transaction)
27     /// @return bool true if the method succeeded
28     function sign(uint256 _documentId, bytes32 _documentHash, address _signer, bytes calldata _sig) external returns (bool) {
29         if(_signatures[_documentId][_signer].isSigned) {
30             return true;
31         } else {
32             address signer = msg.sender == _signer ? msg.sender : recover(keccak256(abi.encodePacked(SIGN_METHOD_HASH, _documentId, _documentHash)), _sig);
33             require(signer == _signer);
34             _signatures[_documentId][_signer] = Signature(true, _documentHash);
35             _documentSigners[_documentId][_documentSignerCount[_documentId]] = _signer;
36             _documentSignerCount[_documentId]++;
37             return true;
38         }
39     }
40     
41     /// @dev Get status if a specified signer has signed on a specified document or not.
42     /// @dev It also returns document hash sent by the signer at the timing of sigining.
43     /// @param _documentId Document's ID
44     /// @param _signer Account address to inspect its signature on the document
45     /// @return bool true if the method succeeded
46     function getSignature(uint256 _documentId, address _signer) external view returns (bool, bytes32) {
47         Signature memory _signature = _signatures[_documentId][_signer];
48         return (_signature.isSigned, _signature.hash);
49     }
50     
51     /// @dev Get a signer address at the specified document and index
52     /// @param _documentId Document's ID
53     /// @param _index Index number of signer on the document
54     /// @return address Signer address
55     function getSigner(uint256 _documentId, uint256 _index) external view returns (address) {
56         return _documentSigners[_documentId][_index];
57     }
58     
59     /// @dev Get the number of signers on the specified document
60     /// @param _documentId Document's ID
61     /// @return uint256 Number of signers
62     function getSignerCount(uint256 _documentId) external view returns (uint256) {
63         return _documentSignerCount[_documentId];
64     }
65 
66     function recover(bytes32 _hash, bytes memory _sig) public pure returns (address) {
67         bytes32 r;
68         bytes32 s;
69         uint8 v;
70         
71         //Check the signature length
72         if (_sig.length != 65) {
73             return (address(0));
74         }
75 
76         // Divide the signature in r, s and v variables
77         assembly {
78             r := mload(add(_sig, 32))
79             s := mload(add(_sig, 64))
80             v := byte(0, mload(add(_sig, 96)))
81         }
82 
83         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
84         if (v < 27) {
85             v += 27;
86         }
87 
88         // If the version is correct return the signer address
89         if (v != 27 && v != 28) {
90             return (address(0));
91         } else {
92             return ecrecover(_hash, v, r, s);
93         }
94     }
95 }