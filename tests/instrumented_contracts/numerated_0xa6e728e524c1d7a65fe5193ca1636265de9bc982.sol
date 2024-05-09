1 pragma solidity ^0.4.21;
2 
3 
4 contract AuctusWhitelist {
5 	address public owner;
6 	uint256 public timeThatFinishGuaranteedPeriod = 1522245600; //2018-03-28 2 PM UTC
7 	uint256 public maximumValueAfterGuaranteedPeriod = 15000 ether; //too high value
8 	uint256 public maximumValueDuringGuaranteedPeriod;
9 	uint256 public maximumValueWithoutProofOfAddress;
10 
11 	mapping(address => WhitelistInfo) public whitelist;
12 	mapping(address => bool) public canListAddress;
13 
14 	struct WhitelistInfo {
15 		bool _whitelisted;
16 		bool _unlimited;
17 		bool _doubleValue;
18 		bool _shouldWaitGuaranteedPeriod;
19 	}
20 
21 	function AuctusWhitelist(uint256 maximumValueToGuaranteedPeriod, uint256 maximumValueForProofOfAddress) public {
22 		owner = msg.sender;
23 		canListAddress[msg.sender] = true;
24 		maximumValueDuringGuaranteedPeriod = maximumValueToGuaranteedPeriod;
25 		maximumValueWithoutProofOfAddress = maximumValueForProofOfAddress;
26 	}
27 
28 	modifier onlyOwner() {
29 		require(owner == msg.sender);
30 		_;
31 	}
32 
33 	function transferOwnership(address newOwner) onlyOwner public {
34 		require(newOwner != address(0));
35 		owner = newOwner;
36 	}
37 
38 	function changeMaximumValueDuringGuaranteedPeriod(uint256 maximumValue) onlyOwner public {
39 		require(maximumValue > 0);
40 		maximumValueDuringGuaranteedPeriod = maximumValue;
41 	}
42 
43 	function changeMaximumValueWithoutProofOfAddress(uint256 maximumValue) onlyOwner public {
44 		require(maximumValue > 0);
45 		maximumValueWithoutProofOfAddress = maximumValue;
46 	}
47 
48 	function setAddressesThatCanList(bool canList, address[] _addresses) onlyOwner public {
49 		for (uint256 i = 0; i < _addresses.length; i++) {
50 			canListAddress[_addresses[i]] = canList;
51 		}
52 	}
53 
54 	function listAddresses(bool whitelisted, bool unlimited, bool doubleValue, bool shouldWait, address[] _addresses) public {
55 		require(canListAddress[msg.sender]);
56 		for (uint256 i = 0; i < _addresses.length; i++) {
57 			whitelist[_addresses[i]] = WhitelistInfo(whitelisted, unlimited, doubleValue, shouldWait);
58 		}
59 	}
60 
61 	function getAllowedAmountToContribute(address addr) view public returns(uint256) {
62 		if (!whitelist[addr]._whitelisted) {
63 			return 0;
64 		} else if (now <= timeThatFinishGuaranteedPeriod) {
65 			if (whitelist[addr]._shouldWaitGuaranteedPeriod) {
66 				return 0;
67 			} else {
68 				if (whitelist[addr]._doubleValue) {
69 					uint256 amount = maximumValueDuringGuaranteedPeriod * 2;
70 					if (whitelist[addr]._unlimited || amount < maximumValueWithoutProofOfAddress) {
71 						return amount;
72 					} else {
73 						return maximumValueWithoutProofOfAddress;
74 					}
75 				} else {
76 					return maximumValueDuringGuaranteedPeriod;
77 				}
78 			}
79 		} else {
80 			if (whitelist[addr]._unlimited) {
81 				return maximumValueAfterGuaranteedPeriod;
82 			} else {
83 				return maximumValueWithoutProofOfAddress;
84 			}
85 		}
86 	}
87 }