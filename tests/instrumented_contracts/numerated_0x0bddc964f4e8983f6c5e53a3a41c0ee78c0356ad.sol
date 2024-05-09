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
23     bytes32 codeHash = getCodeHash(_contractAddr);
24     return auditedContracts[_auditorAddr][codeHash].level;
25   }
26 
27   function isVerifiedCode(address _auditorAddr, bytes32 _codeHash) public view returns(uint) {
28     return auditedContracts[_auditorAddr][_codeHash].level;
29   }
30   
31   function getCodeHash(address _contractAddr) public view returns(bytes32) {
32       return keccak256(codeAt(_contractAddr));
33   }
34   
35   // Add audit information
36   function addAudit(bytes32 _codeHash, uint _level, bytes32 _ipfsHash) public {
37     address auditor = msg.sender;
38     require(auditedContracts[auditor][_codeHash].insertedBlock == 0);
39     auditedContracts[auditor][_codeHash] = DS.Proof({ 
40         level: _level,
41         auditedBy: auditor,
42         insertedBlock: block.number,
43         ipfsHash: _ipfsHash
44     });
45     auditorContracts[auditor].push(_codeHash);
46     emit NewAudit(auditor, _codeHash);
47   }
48   
49   // Add evidence to audited code, only author, if _newLevel is different from original
50   // updates the contract's level
51   function addEvidence(bytes32 _codeHash, uint _newLevel, bytes32 _ipfsHash) public {
52     address auditor = msg.sender;
53     require(auditedContracts[auditor][_codeHash].insertedBlock != 0);
54     if (auditedContracts[auditor][_codeHash].level != _newLevel)
55       auditedContracts[auditor][_codeHash].level = _newLevel;
56     emit AttachedEvidence(auditor, _codeHash, _ipfsHash);
57   }
58 
59   function codeAt(address _addr) public view returns (bytes code) {
60     assembly {
61       // retrieve the size of the code, this needs assembly
62       let size := extcodesize(_addr)
63       // allocate output byte array - this could also be done without assembly
64       // by using o_code = new bytes(size)
65       code := mload(0x40)
66       // new "memory end" including padding
67       mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
68       // store length in memory
69       mstore(code, size)
70       // actually retrieve the code, this needs assembly
71       extcodecopy(_addr, add(code, 0x20), 0, size)
72     }
73   }
74 }
75 
76 contract MonteLabsMS {
77   // MonteLabs owners
78   mapping (address => bool) public owners;
79   uint8 constant quorum = 2;
80   Audit public auditContract;
81 
82   constructor(address[] _owners, Audit _auditContract) public {
83     auditContract = _auditContract;
84     require(_owners.length == 3);
85     for (uint i = 0; i < _owners.length; ++i) {
86       owners[_owners[i]] = true;
87     }
88   }
89 
90   function addAuditOrEvidence(bool audit, bytes32 _codeHash, uint _level,
91                               bytes32 _ipfsHash, uint8 _v, bytes32 _r, 
92                               bytes32 _s) internal {
93     address sender = msg.sender;
94     require(owners[sender]);
95 
96     bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32",
97                            keccak256(audit, _codeHash, _level, _ipfsHash));
98 
99     address other = ecrecover(prefixedHash, _v, _r, _s);
100     // At least 2 different owners
101     assert(other != sender);
102     if (audit)
103       auditContract.addAudit(_codeHash, _level, _ipfsHash);
104     else
105       auditContract.addEvidence(_codeHash, _level, _ipfsHash);
106   }
107 
108   function addAudit(bytes32 _codeHash, uint _level, bytes32 _ipfsHash,
109                     uint8 _v, bytes32 _r, bytes32 _s) public {
110     addAuditOrEvidence(true, _codeHash, _level, _ipfsHash, _v, _r, _s);
111   }
112 
113   function addEvidence(bytes32 _codeHash, uint _version, bytes32 _ipfsHash,
114                     uint8 _v, bytes32 _r, bytes32 _s) public {
115     addAuditOrEvidence(false, _codeHash, _version, _ipfsHash, _v, _r, _s);
116   }
117 }