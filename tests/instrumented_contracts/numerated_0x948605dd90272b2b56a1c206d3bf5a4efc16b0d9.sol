1 pragma solidity ^0.4.24;
2 
3 contract SimpleMultiSig {
4 
5 // EIP712 Precomputed hashes:
6 // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
7 bytes32 constant EIP712DOMAINTYPE_HASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;
8 
9 // kekkac256("Simple MultiSig")
10 bytes32 constant NAME_HASH = 0xb7a0bfa1b79f2443f4d73ebb9259cddbcd510b18be6fc4da7d1aa7b1786e73e6;
11 
12 // kekkac256("1")
13 bytes32 constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
14 
15 // kekkac256("MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address executor,uint256 gasLimit)")
16 bytes32 constant TXTYPE_HASH = 0x3ee892349ae4bbe61dce18f95115b5dc02daf49204cc602458cd4c1f540d56d7;
17 
18 bytes32 constant SALT = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;
19 
20   uint public nonce;                 // (only) mutable state
21   uint public threshold;             // immutable state
22   mapping (address => bool) isOwner; // immutable state
23   address[] public ownersArr;        // immutable state
24 
25   bytes32 DOMAIN_SEPARATOR;          // hash for EIP712, computed from contract address
26   
27   event Deposit(address indexed from, uint value);
28   event Withdrawal(address indexed to, uint value);
29 
30   // Note that owners_ must be strictly increasing, in order to prevent duplicates
31   constructor(uint threshold_, address[] owners_, uint chainId) public {
32     require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ > 0);
33 
34     address lastAdd = address(0);
35     for (uint i = 0; i < owners_.length; i++) {
36       require(owners_[i] > lastAdd);
37       isOwner[owners_[i]] = true;
38       lastAdd = owners_[i];
39     }
40     ownersArr = owners_;
41     threshold = threshold_;
42 
43     DOMAIN_SEPARATOR = keccak256(abi.encode(EIP712DOMAINTYPE_HASH,
44                                             NAME_HASH,
45                                             VERSION_HASH,
46                                             chainId,
47                                             this,
48                                             SALT));
49   }
50 
51   // Note that address recovered from signatures must be strictly increasing, in order to prevent duplicates
52   function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data, address executor, uint gasLimit) public {
53     require(sigR.length == threshold);
54     require(sigR.length == sigS.length && sigR.length == sigV.length);
55     require(executor == msg.sender || executor == address(0));
56 
57     // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
58     bytes32 txInputHash = keccak256(abi.encode(TXTYPE_HASH, destination, value, keccak256(data), nonce, executor, gasLimit));
59     bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, txInputHash));
60 
61     address lastAdd = address(0); // cannot have address(0) as an owner
62     for (uint i = 0; i < threshold; i++) {
63       address recovered = ecrecover(totalHash, sigV[i], sigR[i], sigS[i]);
64       require(recovered > lastAdd && isOwner[recovered]);
65       lastAdd = recovered;
66     }
67 
68     // If we make it here all signatures are accounted for.
69     // The address.call() syntax is no longer recommended, see:
70     // https://github.com/ethereum/solidity/issues/2884
71     nonce = nonce + 1;
72     bool success = false;
73     assembly { success := call(gasLimit, destination, value, add(data, 0x20), mload(data), 0, 0) }
74     emit Withdrawal(destination, value);
75     require(success);
76   }
77 
78   function () payable external {
79     emit Deposit(msg.sender, msg.value);
80   }
81 }