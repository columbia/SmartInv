1 pragma solidity ^0.4.19;
2 
3 contract BdpBaseData {
4 
5 	address public ownerAddress;
6 
7 	address public managerAddress;
8 
9 	address[16] public contracts;
10 
11 	bool public paused = false;
12 
13 	bool public setupComplete = false;
14 
15 	bytes8 public version;
16 
17 }
18 
19 library BdpContracts {
20 
21 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
22 		return _contracts[0];
23 	}
24 
25 	function getBdpController(address[16] _contracts) pure internal returns (address) {
26 		return _contracts[1];
27 	}
28 
29 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
30 		return _contracts[3];
31 	}
32 
33 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
34 		return _contracts[4];
35 	}
36 
37 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
38 		return _contracts[5];
39 	}
40 
41 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
42 		return _contracts[6];
43 	}
44 
45 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
46 		return _contracts[7];
47 	}
48 
49 }
50 
51 contract BdpEntryPoint is BdpBaseData {
52 
53 	function () payable public {
54 		address _impl = BdpContracts.getBdpController(contracts);
55 		require(_impl != address(0));
56 		bytes memory data = msg.data;
57 
58 		assembly {
59 			let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
60 			let size := returndatasize
61 			let ptr := mload(0x40)
62 			returndatacopy(ptr, 0, size)
63 			switch result
64 			case 0 { revert(ptr, size) }
65 			default { return(ptr, size) }
66 		}
67 	}
68 
69 	function BdpEntryPoint(address[16] _contracts, bytes8 _version) public {
70 		ownerAddress = msg.sender;
71 		managerAddress = msg.sender;
72 		contracts = _contracts;
73 		setupComplete = true;
74 		version = _version;
75 	}
76 
77 }