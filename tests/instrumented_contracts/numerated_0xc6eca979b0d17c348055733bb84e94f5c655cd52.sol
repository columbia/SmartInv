1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-11
7 */
8 
9 pragma solidity >=0.6.0;
10 
11 
12 contract Upgradeable {
13     event Upgrade(
14         address indexed sender,
15         address indexed from,
16         address indexed to
17     );
18 
19     //https://eips.ethereum.org/EIPS/eip-1967
20     //bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
21     bytes32
22         internal constant IMPLEMENTATION_STORAGE_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
23     bytes32
24         internal constant AUTHENTICATION_STORAGE_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
25 
26     constructor(address _authentication, address _implementation) public {
27         require(_authentication != address(0), "Upgradeable.constructor.EID00090");
28         require(_implementation != address(0), "Upgradeable.constructor.EID00090");
29         _setauthentication(_authentication);
30         _setimplementation(_implementation);
31     }
32 
33     modifier auth() {
34         require(msg.sender == authentication(), "Upgradeable.auth.EID00001");
35         _;
36     }
37 
38     function authentication() public view returns (address _authentication) {
39         bytes32 slot = AUTHENTICATION_STORAGE_SLOT;
40         assembly {
41             _authentication := sload(slot)
42         }
43     }
44 
45     function implementation() public view returns (address _implementation) {
46         bytes32 slot = IMPLEMENTATION_STORAGE_SLOT;
47         assembly {
48             _implementation := sload(slot)
49         }
50     }
51 
52     function upgrade(address _implementation)
53         public
54         auth
55         returns (address)
56     {
57         require(_implementation != address(0), "Upgradeable.upgrade.EID00090");
58         address from = _setimplementation(_implementation);
59         emit Upgrade(msg.sender, from, _implementation);
60         return from;
61     }
62 
63     fallback() external payable {
64         address _implementation = implementation();
65         assembly {
66             calldatacopy(0, 0, calldatasize())
67             let result := delegatecall(
68                 gas(),
69                 _implementation,
70                 0,
71                 calldatasize(),
72                 0,
73                 0
74             )
75             returndatacopy(0, 0, returndatasize())
76             switch result
77                 case 0 {
78                     revert(0, returndatasize())
79                 }
80                 default {
81                     return(0, returndatasize())
82                 }
83         }
84     }
85 
86     function _setimplementation(address _implementation)
87         internal
88         returns (address)
89     {
90         address from = implementation();
91         bytes32 slot = IMPLEMENTATION_STORAGE_SLOT;
92         assembly {
93             sstore(slot, _implementation)
94         }
95         return from;
96     }
97 
98     function _setauthentication(address _authentication)
99         internal
100         returns (address)
101     {
102         address from = authentication();
103         bytes32 slot = AUTHENTICATION_STORAGE_SLOT;
104         assembly {
105             sstore(slot, _authentication)
106         }
107         return from;
108     }
109 }