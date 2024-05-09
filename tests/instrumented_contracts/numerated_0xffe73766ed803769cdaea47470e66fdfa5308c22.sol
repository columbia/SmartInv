1 // SolidStamp Register contract for https://www.solidstamp.com
2 // The source code is available at https://github.com/SolidStamp/smart-contract/
3 
4 pragma solidity ^0.4.23;
5 
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 pragma solidity ^0.4.24;
67 
68 contract SolidStampRegister is Ownable
69 {
70 /// @dev address of the current SolidStamp contract which can add audits
71     address public contractSolidStamp;
72 
73     /// @dev const value to indicate the contract is audited and approved
74     uint8 public constant NOT_AUDITED = 0x00;
75 
76     /// @dev const value to indicate the contract is audited and approved
77     uint8 public constant AUDITED_AND_APPROVED = 0x01;
78 
79     /// @dev const value to indicate the contract is audited and rejected
80     uint8 public constant AUDITED_AND_REJECTED = 0x02;
81 
82     /// @dev Maps auditor and code hash to the outcome of the audit of
83     /// the particular contract by the particular auditor.
84     /// Map key is: keccack256(auditor address, contract codeHash)
85     /// @dev codeHash is a sha3 from the contract byte code
86     mapping (bytes32 => uint8) public AuditOutcomes;
87 
88     /// @dev event fired when a contract is sucessfully audited
89     event AuditRegistered(address auditor, bytes32 codeHash, bool isApproved);
90 
91     /// @notice SolidStampRegister constructor
92     /// @dev import audits from the SolidStamp v1 contract deployed to: 0x0aA7A4482780F67c6B2862Bd68CD67A83faCe355
93     /// @param _existingAuditors list of existing auditors
94     /// @param _existingCodeHashes list of existing code hashes
95     /// @param _outcomes list of existing audit outcomes
96     /// @dev each n-th element represents an existing audit conducted by _existingAuditors[n]
97     /// on code hash _existingCodeHashes[n] with an outcome _outcomes[n]
98     constructor(address[] _existingAuditors, bytes32[] _existingCodeHashes, bool[] _outcomes) public {
99         uint noOfExistingAudits = _existingAuditors.length;
100         require(noOfExistingAudits == _existingCodeHashes.length, "paramters mismatch");
101         require(noOfExistingAudits == _outcomes.length, "paramters mismatch");
102 
103         // set contract address temporarily to owner so that registerAuditOutcome does not revert
104         contractSolidStamp = msg.sender;
105         for (uint i=0; i<noOfExistingAudits; i++){
106             registerAuditOutcome(_existingAuditors[i], _existingCodeHashes[i], _outcomes[i]);
107         }
108         contractSolidStamp = 0x0;
109     }
110 
111     function getAuditOutcome(address _auditor, bytes32 _codeHash) public view returns (uint8)
112     {
113         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
114         return AuditOutcomes[hashAuditorCode];
115     }
116 
117     function registerAuditOutcome(address _auditor, bytes32 _codeHash, bool _isApproved) public onlySolidStampContract
118     {
119         require(_auditor != 0x0, "auditor cannot be 0x0");
120         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
121         if ( _isApproved )
122             AuditOutcomes[hashAuditorCode] = AUDITED_AND_APPROVED;
123         else
124             AuditOutcomes[hashAuditorCode] = AUDITED_AND_REJECTED;
125         emit AuditRegistered(_auditor, _codeHash, _isApproved);
126     }
127 
128 
129     event SolidStampContractChanged(address newSolidStamp);
130     /**
131      * @dev Throws if called by any account other than the contractSolidStamp
132      */
133     modifier onlySolidStampContract() {
134       require(msg.sender == contractSolidStamp, "cannot be run by not SolidStamp contract");
135       _;
136     }
137 
138     /**
139      * @dev Transfers control of the registry to a _newSolidStamp.
140      * @param _newSolidStamp The address to transfer control registry to.
141      */
142     function changeSolidStampContract(address _newSolidStamp) public onlyOwner {
143       require(_newSolidStamp != address(0), "SolidStamp contract cannot be 0x0");
144       emit SolidStampContractChanged(_newSolidStamp);
145       contractSolidStamp = _newSolidStamp;
146     }
147 
148 }