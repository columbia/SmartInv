1 pragma solidity ^0.4.24;
2 
3 library DS {
4   struct Proof {
5     uint level;         // Audit level
6     uint insertedBlock; // Audit's block
7     bytes32 ipfsHash;   // IPFS dag-cbor proof
8     address auditedBy;  // Audited by address
9   }
10 }
11 
12 contract Audit {
13   event AttachedEvidence(address indexed auditorAddr, bytes32 indexed codeHash, bytes32 ipfsHash);
14   event NewAudit(address indexed auditorAddr, bytes32 indexed codeHash);
15 
16   // Maps auditor address and code's keccak256 to Audit
17   mapping (address => mapping (bytes32 => DS.Proof)) public auditedContracts;
18   // Maps auditor address to a list of audit code hashes
19   mapping (address => bytes32[]) public auditorContracts;
20   
21   // Returns code audit level, 0 if not present
22   function isVerifiedAddress(address _auditorAddr, address _contractAddr) public view returns(uint) {
23     bytes32 codeHash = keccak256(codeAt(_contractAddr));
24     return auditedContracts[_auditorAddr][codeHash].level;
25   }
26 
27   function isVerifiedCode(address _auditorAddr, bytes32 _codeHash) public view returns(uint) {
28     return auditedContracts[_auditorAddr][_codeHash].level;
29   }
30   
31   // Add audit information
32   function addAudit(bytes32 _codeHash, uint _level, bytes32 _ipfsHash) public {
33     address auditor = msg.sender;
34     require(auditedContracts[auditor][_codeHash].insertedBlock == 0);
35     auditedContracts[auditor][_codeHash] = DS.Proof({ 
36         level: _level,
37         auditedBy: auditor,
38         insertedBlock: block.number,
39         ipfsHash: _ipfsHash
40     });
41     auditorContracts[auditor].push(_codeHash);
42     emit NewAudit(auditor, _codeHash);
43   }
44   
45   // Add evidence to audited code, only author, if _newLevel is different from original
46   // updates the contract's level
47   function addEvidence(bytes32 _codeHash, uint _newLevel, bytes32 _ipfsHash) public {
48     address auditor = msg.sender;
49     require(auditedContracts[auditor][_codeHash].insertedBlock != 0);
50     if (auditedContracts[auditor][_codeHash].level != _newLevel)
51       auditedContracts[auditor][_codeHash].level = _newLevel;
52     emit AttachedEvidence(auditor, _codeHash, _ipfsHash);
53   }
54 
55   function codeAt(address _addr) public view returns (bytes code) {
56     assembly {
57       // retrieve the size of the code, this needs assembly
58       let size := extcodesize(_addr)
59       // allocate output byte array - this could also be done without assembly
60       // by using o_code = new bytes(size)
61       code := mload(0x40)
62       // new "memory end" including padding
63       mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
64       // store length in memory
65       mstore(code, size)
66       // actually retrieve the code, this needs assembly
67       extcodecopy(_addr, add(code, 0x20), 0, size)
68     }
69   }
70 }
71 
72 contract MonteLabsMS {
73   // MonteLabs owners
74   mapping (address => bool) public owners;
75   uint8 constant quorum = 2;
76   Audit public auditContract;
77 
78   constructor(address[] _owners, Audit _auditContract) public {
79     auditContract = _auditContract;
80     require(_owners.length == 3);
81     for (uint i = 0; i < _owners.length; ++i) {
82       owners[_owners[i]] = true;
83     }
84   }
85 
86   function addAuditOrEvidence(bool audit, bytes32 _codeHash, uint _level,
87                               bytes32 _ipfsHash, uint8 _v, bytes32 _r, 
88                               bytes32 _s) internal {
89     address sender = msg.sender;
90     require(owners[sender]);
91 
92     bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32",
93                            keccak256(audit, _codeHash, _level, _ipfsHash));
94 
95     address other = ecrecover(prefixedHash, _v, _r, _s);
96     // At least 2 different owners
97     assert(other != sender);
98     if (audit)
99       auditContract.addAudit(_codeHash, _level, _ipfsHash);
100     else
101       auditContract.addEvidence(_codeHash, _level, _ipfsHash);
102   }
103 
104   function addAudit(bytes32 _codeHash, uint _level, bytes32 _ipfsHash,
105                     uint8 _v, bytes32 _r, bytes32 _s) public {
106     addAuditOrEvidence(true, _codeHash, _level, _ipfsHash, _v, _r, _s);
107   }
108 
109   function addEvidence(bytes32 _codeHash, uint _version, bytes32 _ipfsHash,
110                     uint8 _v, bytes32 _r, bytes32 _s) public {
111     addAuditOrEvidence(false, _codeHash, _version, _ipfsHash, _v, _r, _s);
112   }
113 }