1 pragma solidity ^0.4.24;
2 
3 contract Audit {
4 
5   struct Proof {
6     uint level;         // Audit level
7     uint insertedBlock; // Audit's block
8     bytes32 ipfsHash;   // IPFS dag-cbor proof
9     address auditedBy;  // Audited by address
10   }
11 
12   event AttachedEvidence(address indexed auditorAddr, bytes32 indexed codeHash, bytes32 ipfsHash);
13   event NewAudit(address indexed auditorAddr, bytes32 indexed codeHash);
14 
15   // Maps auditor address and code's keccak256 to Audit
16   mapping (address => mapping (bytes32 => Proof)) public auditedContracts;
17   // Maps auditor address to a list of audit code hashes
18   mapping (address => bytes32[]) public auditorContracts;
19   
20   // Returns code audit level, 0 if not present
21   function isVerifiedAddress(address _auditorAddr, address _contractAddr) public view returns(uint) {
22     bytes32 codeHash = getCodeHash(_contractAddr);
23     return auditedContracts[_auditorAddr][codeHash].level;
24   }
25 
26   function isVerifiedCode(address _auditorAddr, bytes32 _codeHash) public view returns(uint) {
27     return auditedContracts[_auditorAddr][_codeHash].level;
28   }
29 
30   function getCodeHash(address _contractAddr) public view returns(bytes32) {
31       return keccak256(codeAt(_contractAddr));
32   }
33   
34   // Add audit information
35   function addAudit(bytes32 _codeHash, uint _level, bytes32 _ipfsHash) public {
36     address auditor = msg.sender;
37     require(auditedContracts[auditor][_codeHash].insertedBlock == 0);
38     auditedContracts[auditor][_codeHash] = Proof({ 
39         level: _level,
40         auditedBy: auditor,
41         insertedBlock: block.number,
42         ipfsHash: _ipfsHash
43     });
44     auditorContracts[auditor].push(_codeHash);
45     emit NewAudit(auditor, _codeHash);
46   }
47   
48   // Add evidence to audited code, only author, if _newLevel is different from original
49   // updates the contract's level
50   function addEvidence(bytes32 _codeHash, uint _newLevel, bytes32 _ipfsHash) public {
51     address auditor = msg.sender;
52     require(auditedContracts[auditor][_codeHash].insertedBlock != 0);
53     if (auditedContracts[auditor][_codeHash].level != _newLevel)
54       auditedContracts[auditor][_codeHash].level = _newLevel;
55     emit AttachedEvidence(auditor, _codeHash, _ipfsHash);
56   }
57 
58   function codeAt(address _addr) public view returns (bytes code) {
59     assembly {
60       // retrieve the size of the code, this needs assembly
61       let size := extcodesize(_addr)
62       // allocate output byte array - this could also be done without assembly
63       // by using o_code = new bytes(size)
64       code := mload(0x40)
65       // new "memory end" including padding
66       mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
67       // store length in memory
68       mstore(code, size)
69       // actually retrieve the code, this needs assembly
70       extcodecopy(_addr, add(code, 0x20), 0, size)
71     }
72   }
73 }