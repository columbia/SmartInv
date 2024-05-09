1 /*                                                                           
2     .'''''''''''..     ..''''''''''''''''..       ..'''''''''''''''..       
3     .;;;;;;;;;;;'.   .';;;;;;;;;;;;;;;;;;,.     .,;;;;;;;;;;;;;;;;;,.       
4     .;;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;,.    .,;;;;;;;;;;;;;;;;;;,.       
5     .;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.   .;;;;;;;;;;;;;;;;;;;;,.       
6     ';;;;;;;;'.  .';;;;;;;;;;;;;;;;;;;;;;,. .';;;;;;;;;;;;;;;;;;;;;,.       
7     ';;;;;,..   .';;;;;;;;;;;;;;;;;;;;;;;,..';;;;;;;;;;;;;;;;;;;;;;,.       
8     ......     .';;;;;;;;;;;;;,'''''''''''.,;;;;;;;;;;;;;,'''''''''..       
9               .,;;;;;;;;;;;;;.           .,;;;;;;;;;;;;;.                   
10              .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.                    
11             .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.                     
12            .,;;;;;;;;;;;;,.           .;;;;;;;;;;;;;,.     .....            
13           .;;;;;;;;;;;;;'.         ..';;;;;;;;;;;;;'.    .',;;;;,'.         
14         .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.   .';;;;;;;;;;.        
15        .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.    .;;;;;;;;;;;,.       
16       .,;;;;;;;;;;;;;'...........,;;;;;;;;;;;;;;.      .;;;;;;;;;;;,.       
17      .,;;;;;;;;;;;;,..,;;;;;;;;;;;;;;;;;;;;;;;,.       ..;;;;;;;;;,.        
18     .,;;;;;;;;;;;;,. .,;;;;;;;;;;;;;;;;;;;;;;,.          .',;;;,,..         
19    .,;;;;;;;;;;;;,.  .,;;;;;;;;;;;;;;;;;;;;;,.              ....            
20     ..',;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.                               
21        ..',;;;;'.    .,;;;;;;;;;;;;;;;;;;;'.                                
22           ...'..     .';;;;;;;;;;;;;;,,,'.                                  
23                        ...............                                      
24 */
25 
26 // https://github.com/trusttoken/smart-contracts
27 // SPDX-License-Identifier: MIT
28 
29 // File: contracts/proxy/OwnedUpgradeabilityProxy.sol
30 pragma solidity 0.6.10;
31 
32 /**
33  * @title OwnedUpgradeabilityProxy
34  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
35  */
36 contract OwnedUpgradeabilityProxy {
37     /**
38      * @dev Event to show ownership has been transferred
39      * @param previousOwner representing the address of the previous owner
40      * @param newOwner representing the address of the new owner
41      */
42     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Event to show ownership transfer is pending
46      * @param currentOwner representing the address of the current owner
47      * @param pendingOwner representing the address of the pending owner
48      */
49     event NewPendingOwner(address currentOwner, address pendingOwner);
50 
51     // Storage position of the owner and pendingOwner of the contract
52     bytes32 private constant proxyOwnerPosition = 0x6279e8199720cf3557ecd8b58d667c8edc486bd1cf3ad59ea9ebdfcae0d0dfac; //keccak256("trueUSD.proxy.owner");
53     bytes32 private constant pendingProxyOwnerPosition = 0x8ddbac328deee8d986ec3a7b933a196f96986cb4ee030d86cc56431c728b83f4; //keccak256("trueUSD.pending.proxy.owner");
54 
55     /**
56      * @dev the constructor sets the original owner of the contract to the sender account.
57      */
58     constructor() public {
59         _setUpgradeabilityOwner(msg.sender);
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyProxyOwner() {
66         require(msg.sender == proxyOwner(), "only Proxy Owner");
67         _;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the pending owner.
72      */
73     modifier onlyPendingProxyOwner() {
74         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
75         _;
76     }
77 
78     /**
79      * @dev Tells the address of the owner
80      * @return owner the address of the owner
81      */
82     function proxyOwner() public view returns (address owner) {
83         bytes32 position = proxyOwnerPosition;
84         assembly {
85             owner := sload(position)
86         }
87     }
88 
89     /**
90      * @dev Tells the address of the owner
91      * @return pendingOwner the address of the pending owner
92      */
93     function pendingProxyOwner() public view returns (address pendingOwner) {
94         bytes32 position = pendingProxyOwnerPosition;
95         assembly {
96             pendingOwner := sload(position)
97         }
98     }
99 
100     /**
101      * @dev Sets the address of the owner
102      */
103     function _setUpgradeabilityOwner(address newProxyOwner) internal {
104         bytes32 position = proxyOwnerPosition;
105         assembly {
106             sstore(position, newProxyOwner)
107         }
108     }
109 
110     /**
111      * @dev Sets the address of the owner
112      */
113     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
114         bytes32 position = pendingProxyOwnerPosition;
115         assembly {
116             sstore(position, newPendingProxyOwner)
117         }
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer control of the contract to a newOwner.
122      *changes the pending owner to newOwner. But doesn't actually transfer
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
126         require(newOwner != address(0));
127         _setPendingUpgradeabilityOwner(newOwner);
128         emit NewPendingOwner(proxyOwner(), newOwner);
129     }
130 
131     /**
132      * @dev Allows the pendingOwner to claim ownership of the proxy
133      */
134     function claimProxyOwnership() external onlyPendingProxyOwner {
135         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
136         _setUpgradeabilityOwner(pendingProxyOwner());
137         _setPendingUpgradeabilityOwner(address(0));
138     }
139 
140     /**
141      * @dev Allows the proxy owner to upgrade the current version of the proxy.
142      * @param implementation representing the address of the new implementation to be set.
143      */
144     function upgradeTo(address implementation) public virtual onlyProxyOwner {
145         address currentImplementation;
146         bytes32 position = implementationPosition;
147         assembly {
148             currentImplementation := sload(position)
149         }
150         require(currentImplementation != implementation);
151         assembly {
152             sstore(position, implementation)
153         }
154         emit Upgraded(implementation);
155     }
156 
157     /**
158      * @dev This event will be emitted every time the implementation gets upgraded
159      * @param implementation representing the address of the upgraded implementation
160      */
161     event Upgraded(address indexed implementation);
162 
163     // Storage position of the address of the current implementation
164     bytes32 private constant implementationPosition = 0x6e41e0fbe643dfdb6043698bf865aada82dc46b953f754a3468eaa272a362dc7; //keccak256("trueUSD.proxy.implementation");
165 
166     function implementation() public view returns (address impl) {
167         bytes32 position = implementationPosition;
168         assembly {
169             impl := sload(position)
170         }
171     }
172 
173     /**
174      * @dev Fallback functions allowing to perform a delegatecall to the given implementation.
175      * This function will return whatever the implementation call returns
176      */
177     fallback() external payable {
178         proxyCall();
179     }
180 
181     receive() external payable {
182         proxyCall();
183     }
184 
185     function proxyCall() internal {
186         bytes32 position = implementationPosition;
187 
188         assembly {
189             let ptr := mload(0x40)
190             calldatacopy(ptr, returndatasize(), calldatasize())
191             let result := delegatecall(gas(), sload(position), ptr, calldatasize(), returndatasize(), returndatasize())
192             returndatacopy(ptr, 0, returndatasize())
193 
194             switch result
195                 case 0 {
196                     revert(ptr, returndatasize())
197                 }
198                 default {
199                     return(ptr, returndatasize())
200                 }
201         }
202     }
203 }