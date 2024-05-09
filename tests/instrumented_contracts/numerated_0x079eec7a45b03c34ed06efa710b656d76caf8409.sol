1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.4;
4 
5 /*
6  __________________________________
7 |                                  |
8 | $ + $ + $ + $ + $ + $ + $ + $ + $|
9 |+ $ + $ + $ + $ + $ + $ + $ + $ + |
10 | + $ + $ + $ + $ + $ + $ + $ + $ +|
11 |$ + $ + $ + $ + $ + $ + $ + $ + $ |
12 | $ + $ + $ + $ + $ + $ + $ + $ + $|
13 |+ $ + $ + $ + $ + $ + $ + $ + $ + |
14 | + $ + $ + $ + $ + $ + $ + $ + $ +|
15 |__________________________________|
16 
17 */
18 
19 contract NFTBrokerProxy {
20 
21     modifier onlyOwner() {
22         require(msg.sender == getOwner(), "caller not the owner");
23         _;
24     }
25 
26     constructor (address target) {
27         setTargetSlot(target);
28         setOwnerSlot(tx.origin);
29     }
30 
31     fallback() external payable {
32         address target = getTargetSlot();
33         assembly {
34             calldatacopy(0, 0, calldatasize())
35             let result := delegatecall(gas(), target, 0, calldatasize(), 0, 0)
36             returndatacopy(0, 0, returndatasize())
37             switch result
38             case 0 {
39                 revert(0, returndatasize())
40             }
41             default {
42                 return(0, returndatasize())
43             }
44         }
45     }
46 
47     receive() external payable {}
48 
49     /**
50      * @dev Gets proxy target address from storage slot.
51      * @return target Address of smart contract source code.
52      */
53     function getTargetSlot() internal view returns (address target) {
54         // The slot hash has been precomputed for gas optimizaion
55         // bytes32 slot = bytes32(uint256(keccak256('eip1967.CXIP.NFTBrokerProxy.target')) - 1);
56         assembly {
57             target := sload(
58                 /* slot */
59                 0x172d303713ab541af50b05036cc57f0c0c8733f85d5ceb2137350b11166ad9bd
60             )
61         }
62     }
63 
64     function getTarget() public view returns (address target) {
65         return getTargetSlot();
66     }
67 
68     /**
69      * @dev Sets proxy target address to storage slot.
70      * @param target Address of smart contract source code.
71      */
72     function setTargetSlot(address target) internal {
73         // The slot hash has been precomputed for gas optimizaion
74         // bytes32 slot = bytes32(uint256(keccak256('eip1967.CXIP.NFTBrokerProxy.target')) - 1);
75         assembly {
76             sstore(
77                 /* slot */
78                 0x172d303713ab541af50b05036cc57f0c0c8733f85d5ceb2137350b11166ad9bd,
79                 target
80             )
81         }
82     }
83 
84     function setTarget(address target) public onlyOwner {
85         setTargetSlot(target);
86     }
87 
88     /**
89      * @dev Gets proxy owner address from storage slot.
90      * @return owner Address of owner.
91      */
92     function getOwnerSlot() internal view returns (address owner) {
93         // The slot hash has been precomputed for gas optimizaion
94         // bytes32 slot = bytes32(uint256(keccak256('eip1967.CXIP.NFTBrokerProxy.owner')) - 1);
95         assembly {
96             owner := sload(
97                 /* slot */
98                 0x2d33df155922a1acf3c04048b6cc8aa3f641ab2dc6ecf84d346b5653b679e017
99             )
100         }
101     }
102 
103     function getOwner() public view returns (address owner) {
104         return getOwnerSlot();
105     }
106 
107     /**
108      * @dev Sets proxy owner address to storage slot.
109      * @param owner Address of owner.
110      */
111     function setOwnerSlot(address owner) internal {
112         // The slot hash has been precomputed for gas optimizaion
113         // bytes32 slot = bytes32(uint256(keccak256('eip1967.CXIP.NFTBrokerProxy.owner')) - 1);
114         assembly {
115             sstore(
116                 /* slot */
117                 0x2d33df155922a1acf3c04048b6cc8aa3f641ab2dc6ecf84d346b5653b679e017,
118                 owner
119             )
120         }
121     }
122 
123     function setOwner(address owner) public onlyOwner {
124         setOwnerSlot(owner);
125     }
126 
127     function transferOwnership(address newOwner) public onlyOwner {
128         require(newOwner != address(0), "cannot use zero address");
129         setOwner(newOwner);
130     }
131 
132 }