1 pragma solidity ^0.4.24;
2 
3 // Fallback ERC20 token definition.
4 contract tokenFallback {
5 	uint256 public totalSupply;
6 
7 	function balanceOf(address _owner) public constant returns (uint256 balance);
8 	function transfer(address _to, uint256 _value) public returns (bool success);
9 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10 	function approve(address _spender, uint256 _value) public returns (bool success);
11 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
12 
13 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
14 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 contract TokenBurner {
18 	struct Claim {
19 		uint256[] amount;
20 		string[] pubkey;
21 	}
22 
23 	struct BatchTime {
24 		uint256 blockNumber;
25 		uint256 eventCount;
26 	}
27 
28 	// Keep track of token burn batches - use this number for filtering in the emitted Burn event.
29 	uint16 public AEdeliveryBatchCounter = 0;
30 
31 	// The admin who may count up the AE delivery batch count
32 	address public AEdmin;
33 	address public AEToken;
34 
35 	// check if transaction sender is AEdmin.
36 	modifier onlyAEdmin() {
37 		require (msg.sender == AEdmin);
38 		_;
39 	}
40 
41 	mapping(address => Claim) burned;
42 	// count the amount of burns for later filtering of all burnings
43 	uint256 public burnCount;
44 	// track amount of burn events for each delivery period e.g. for checking if the event scanner missed something
45 	mapping(uint16 => BatchTime) public batchTimes;
46 
47 	constructor(address _AEdmin, address _AEToken) public {
48 		require (_AEdmin != 0x0);
49 		AEdmin = _AEdmin;
50 
51 		if (_AEToken == 0x0) {
52 			_AEToken = 0x5CA9a71B1d01849C0a95490Cc00559717fCF0D1d; // Mainnet contract
53 		}
54 
55 		AEToken = _AEToken;
56 	}
57 
58 	// check if address starts with an ak_
59 	function checkAddress(bytes str) public pure returns (bool) {
60 		bytes memory ak = "ak_";
61 		bytes memory result = new bytes(3);
62 		for(uint i = 0; i < 3; i++) {
63 			result[i-0] = str[i];
64 		}
65 		return (keccak256(result) == keccak256(ak));
66 	}
67 
68 	function receiveApproval(
69 			address _from,
70 			uint256 _value,
71 			address _token,
72 			bytes _pubkey
73 			) public returns (bool) {
74 
75 		// Only let people burn AE through original AEToken contract.
76 		require(msg.sender == AEToken);
77 
78 		// minimal form of type checking with room for unexpected outcomes of base58 encodings
79 
80 		// we need to cast _pubKey to string before performing length checks, because sometimes
81 		// transaction data can have extra zeros at the end, which are cut away when
82 		// casting string from bytes
83 		string memory pubKeyString = string(_pubkey);
84 
85 		require (bytes(pubKeyString).length > 50 && bytes(pubKeyString).length < 70);
86 		require (checkAddress(_pubkey));
87 
88 		require(tokenFallback(_token).transferFrom(_from, this, _value));
89 		burned[_from].pubkey.push(pubKeyString); // pushing pubkey and value, to allow 1 user burn n times to m pubkeys
90 		burned[_from].amount.push(_value);
91 		emit Burn(_from, _pubkey, _value, ++burnCount, AEdeliveryBatchCounter);
92 		return true;
93 	}
94 
95 	function countUpDeliveryBatch()
96 		public onlyAEdmin
97 		{
98 			batchTimes[AEdeliveryBatchCounter].blockNumber = block.number;
99 			batchTimes[AEdeliveryBatchCounter].eventCount = burnCount;
100 			++AEdeliveryBatchCounter;
101 		}
102 
103 	event Burn(address indexed _from, bytes _pubkey, uint256 _value, uint256 _count, uint16 indexed _deliveryPeriod);
104 }