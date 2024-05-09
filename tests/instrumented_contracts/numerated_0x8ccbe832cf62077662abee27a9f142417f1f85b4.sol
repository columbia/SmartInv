1 pragma solidity ^0.4.19;
2 
3 // File: contracts/BdpBaseData.sol
4 
5 contract BdpBaseData {
6 
7 	address public ownerAddress;
8 
9 	address public managerAddress;
10 
11 	address[16] public contracts;
12 
13 	bool public paused = false;
14 
15 	bool public setupCompleted = false;
16 
17 	bytes8 public version;
18 
19 }
20 
21 // File: contracts/libraries/BdpContracts.sol
22 
23 library BdpContracts {
24 
25 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
26 		return _contracts[0];
27 	}
28 
29 	function getBdpController(address[16] _contracts) pure internal returns (address) {
30 		return _contracts[1];
31 	}
32 
33 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
34 		return _contracts[3];
35 	}
36 
37 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
38 		return _contracts[4];
39 	}
40 
41 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
42 		return _contracts[5];
43 	}
44 
45 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
46 		return _contracts[6];
47 	}
48 
49 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
50 		return _contracts[7];
51 	}
52 
53 }
54 
55 // File: contracts/BdpEntryPoint.sol
56 
57 contract BdpEntryPoint is BdpBaseData {
58 
59 	function () payable public {
60 		address _impl = BdpContracts.getBdpController(contracts);
61 		require(_impl != address(0));
62 		bytes memory data = msg.data;
63 
64 		assembly {
65 			let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
66 			let size := returndatasize
67 			let ptr := mload(0x40)
68 			returndatacopy(ptr, 0, size)
69 			switch result
70 			case 0 { revert(ptr, size) }
71 			default { return(ptr, size) }
72 		}
73 	}
74 
75 	function BdpEntryPoint(address[16] _contracts, bytes8 _version) public {
76 		ownerAddress = msg.sender;
77 		managerAddress = msg.sender;
78 		contracts = _contracts;
79 		setupCompleted = true;
80 		version = _version;
81 	}
82 
83 }