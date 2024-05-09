1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File contracts/interfaces/IUpgradable.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8 
9 // General interface for upgradable contracts
10 interface IUpgradable {
11     error NotOwner();
12     error InvalidOwner();
13     error InvalidCodeHash();
14     error InvalidImplementation();
15     error SetupFailed();
16     error NotProxy();
17 
18     event Upgraded(address indexed newImplementation);
19     event OwnershipTransferred(address indexed newOwner);
20 
21     // Get current owner
22     function owner() external view returns (address);
23 
24     function contractId() external pure returns (bytes32);
25 
26     function implementation() external view returns (address);
27 
28     function upgrade(
29         address newImplementation,
30         bytes32 newImplementationCodeHash,
31         bytes calldata params
32     ) external;
33 
34     function setup(bytes calldata data) external;
35 }
36 
37 
38 // File contracts/util/Proxy.sol
39 
40 contract Proxy {
41     error InvalidImplementation();
42     error SetupFailed();
43     error EtherNotAccepted();
44     error NotOwner();
45     error AlreadyInitialized();
46 
47     // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
48     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
49     // keccak256('owner')
50     bytes32 internal constant _OWNER_SLOT = 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0;
51 
52     constructor() {
53         // solhint-disable-next-line no-inline-assembly
54         assembly {
55             sstore(_OWNER_SLOT, caller())
56         }
57     }
58 
59     function init(
60         address implementationAddress,
61         address newOwner,
62         bytes memory params
63     ) external {
64         address owner;
65         // solhint-disable-next-line no-inline-assembly
66         assembly {
67             owner := sload(_OWNER_SLOT)
68         }
69         if (msg.sender != owner) revert NotOwner();
70         if (implementation() != address(0)) revert AlreadyInitialized();
71         if (IUpgradable(implementationAddress).contractId() != contractId()) revert InvalidImplementation();
72 
73         // solhint-disable-next-line no-inline-assembly
74         assembly {
75             sstore(_IMPLEMENTATION_SLOT, implementationAddress)
76             sstore(_OWNER_SLOT, newOwner)
77         }
78         // solhint-disable-next-line avoid-low-level-calls
79         (bool success, ) = implementationAddress.delegatecall(
80             // keccak('setup(bytes)') selector
81             abi.encodeWithSelector(0x9ded06df, params)
82         );
83         if (!success) revert SetupFailed();
84     }
85 
86     // solhint-disable-next-line no-empty-blocks
87     function contractId() internal pure virtual returns (bytes32) {}
88 
89     function implementation() public view returns (address implementation_) {
90         // solhint-disable-next-line no-inline-assembly
91         assembly {
92             implementation_ := sload(_IMPLEMENTATION_SLOT)
93         }
94     }
95 
96     // solhint-disable-next-line no-empty-blocks
97     function setup(bytes calldata data) public {}
98 
99     // solhint-disable-next-line no-complex-fallback
100     fallback() external payable {
101         address implementaion_ = implementation();
102         // solhint-disable-next-line no-inline-assembly
103         assembly {
104             calldatacopy(0, 0, calldatasize())
105 
106             let result := delegatecall(gas(), implementaion_, 0, calldatasize(), 0, 0)
107             returndatacopy(0, 0, returndatasize())
108 
109             switch result
110             case 0 {
111                 revert(0, returndatasize())
112             }
113             default {
114                 return(0, returndatasize())
115             }
116         }
117     }
118 
119     receive() external payable virtual {
120         revert EtherNotAccepted();
121     }
122 }
123 
124 
125 // File contracts/gas-service/AxelarGasServiceProxy.sol
126 
127 contract AxelarGasServiceProxy is Proxy {
128     function contractId() internal pure override returns (bytes32) {
129         return keccak256('axelar-gas-service');
130     }
131 }