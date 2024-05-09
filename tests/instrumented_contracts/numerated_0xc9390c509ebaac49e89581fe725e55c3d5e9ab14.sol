1 pragma solidity ^0.5.13;
2 
3 contract SimpleMultiSig {
4 
5 // EIP712 Precomputed hashes:
6 // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
7 bytes32 constant EIP712DOMAINTYPE_HASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;
8 
9 // keccak256("Simple MultiSig")
10 bytes32 constant NAME_HASH = 0xb7a0bfa1b79f2443f4d73ebb9259cddbcd510b18be6fc4da7d1aa7b1786e73e6;
11 
12 // keccak256("1")
13 bytes32 constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
14 
15 // keccak256("MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address executor,uint256 gasLimit)")
16 bytes32 constant TXTYPE_HASH = 0x3ee892349ae4bbe61dce18f95115b5dc02daf49204cc602458cd4c1f540d56d7;
17 
18 bytes32 constant SALT = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;
19 
20   event Execute(address[] _confirmAddrs, address _destination, uint _value, bytes data);
21   event Deposit(address indexed _from,uint _value);
22 
23   // debug events
24   // event DbgExecuteParam(bytes32 sperator, bytes32 txInputHash, bytes32 totalHash, bytes txInput);
25   // event DbgRecover(address _recovered);
26 
27   uint public nonce;                 // (only) mutable state
28   uint public threshold;             // immutable state
29   mapping (address => bool) isOwner; // immutable state
30   address[] public ownersArr;        // immutable state
31 
32   bytes32 DOMAIN_SEPARATOR;          // hash for EIP712, computed from contract address
33 
34   // Note that owners_ must be strictly increasing, in order to prevent duplicates
35   constructor(uint threshold_, address[] memory owners_, uint chainId) public {
36     require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ > 0, "0<threshold<owners.length");
37 
38     address lastAdd = address(0);
39     for (uint i = 0; i < owners_.length; i++) {
40       require(owners_[i] > lastAdd, "repeated owner or not sorted");
41       isOwner[owners_[i]] = true;
42       lastAdd = owners_[i];
43     }
44     ownersArr = owners_;
45     threshold = threshold_;
46 
47     DOMAIN_SEPARATOR = keccak256(abi.encode(EIP712DOMAINTYPE_HASH,
48                                             NAME_HASH,
49                                             VERSION_HASH,
50                                             chainId,
51                                             this,
52                                             SALT));
53   }
54 
55   // Note that address recovered from signatures must be strictly increasing, in order to prevent duplicates
56   function execute(uint8[] memory sigV, bytes32[] memory sigR, bytes32[] memory sigS,
57     address destination, uint value, bytes memory data, address executor, uint gasLimit) public {
58 
59     require(sigR.length == threshold, "R len not equal to threshold");
60     require(sigR.length == sigS.length && sigR.length == sigV.length, "length of r/s/v not match");
61     require(executor == msg.sender || executor == address(0), "wrong executor");
62 
63     // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
64     bytes32 txInputHash = keccak256(abi.encode(TXTYPE_HASH, destination, value, keccak256(data), nonce, executor, gasLimit));
65     bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, txInputHash));
66 
67     // emit DbgExecuteParam(DOMAIN_SEPARATOR, txInputHash, totalHash, abi.encode(TXTYPE_HASH, destination, value, keccak256(data), nonce, executor, gasLimit));
68 
69     address lastAdd = address(0); // cannot have address(0) as an owner
70     address[] memory confirmAddrs = new address[](threshold);
71     for (uint i = 0; i < threshold; i++) {
72       address recovered = ecrecover(totalHash, sigV[i], sigR[i], sigS[i]);
73       require(recovered > lastAdd && isOwner[recovered], "Verify sig failed");
74       // emit DbgRecover(recovered);
75       confirmAddrs[i] = recovered;
76       lastAdd = recovered;
77     }
78 
79     // If we make it here all signatures are accounted for.
80     // The address.call() syntax is no longer recommended, see:
81     // https://github.com/ethereum/solidity/issues/2884
82     nonce = nonce + 1;
83     bool success = false;
84     assembly { success := call(gasLimit, destination, value, add(data, 0x20), mload(data), 0, 0) }
85     require(success, "not_success");
86     emit Execute(confirmAddrs, destination, value, data);
87   }
88 
89   function getVersion() external pure returns (string memory) {
90     return "1"; //
91   }
92 
93   function getOwersLength() external view returns (int8) {
94     return int8(ownersArr.length); //owners.length <= 10 (see constructor), so type convert is ok
95   }
96 
97   function () external payable {
98     emit Deposit(msg.sender, msg.value);
99   }
100 }