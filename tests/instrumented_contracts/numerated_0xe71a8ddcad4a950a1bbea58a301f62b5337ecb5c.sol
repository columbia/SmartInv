1 // File: @openzeppelin/contracts/proxy/Proxy.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
9  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
10  * be specified by overriding the virtual {_implementation} function.
11  *
12  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
13  * different contract through the {_delegate} function.
14  *
15  * The success and return data of the delegated call will be returned back to the caller of the proxy.
16  */
17 abstract contract Proxy {
18     /**
19      * @dev Delegates the current call to `implementation`.
20      *
21      * This function does not return to its internall call site, it will return directly to the external caller.
22      */
23     function _delegate(address implementation) internal virtual {
24         assembly {
25             // Copy msg.data. We take full control of memory in this inline assembly
26             // block because it will not return to Solidity code. We overwrite the
27             // Solidity scratch pad at memory position 0.
28             calldatacopy(0, 0, calldatasize())
29 
30             // Call the implementation.
31             // out and outsize are 0 because we don't know the size yet.
32             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
33 
34             // Copy the returned data.
35             returndatacopy(0, 0, returndatasize())
36 
37             switch result
38             // delegatecall returns 0 on error.
39             case 0 {
40                 revert(0, returndatasize())
41             }
42             default {
43                 return(0, returndatasize())
44             }
45         }
46     }
47 
48     /**
49      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
50      * and {_fallback} should delegate.
51      */
52     function _implementation() internal view virtual returns (address);
53 
54     /**
55      * @dev Delegates the current call to the address returned by `_implementation()`.
56      *
57      * This function does not return to its internall call site, it will return directly to the external caller.
58      */
59     function _fallback() internal virtual {
60         _beforeFallback();
61         _delegate(_implementation());
62     }
63 
64     /**
65      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
66      * function in the contract matches the call data.
67      */
68     fallback() external payable virtual {
69         _fallback();
70     }
71 
72     /**
73      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
74      * is empty.
75      */
76     receive() external payable virtual {
77         _fallback();
78     }
79 
80     /**
81      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
82      * call, or as part of the Solidity `fallback` or `receive` functions.
83      *
84      * If overriden should call `super._beforeFallback()`.
85      */
86     function _beforeFallback() internal virtual {}
87 }
88 
89 // File: contracts/Proxy.sol
90 
91 
92 pragma solidity ^0.8.4;
93 
94 
95 contract UnstructuredProxy is Proxy {
96     
97     // Storage position of the address of the current implementation
98     bytes32 private constant implementationPosition = 
99         keccak256("org.smartdefi.implementation.address");
100     
101     // Storage position of the owner of the contract
102     bytes32 private constant proxyOwnerPosition = 
103         keccak256("org.smartdefi.proxy.owner");
104     
105     /**
106     * @dev Throws if called by any account other than the owner.
107     */
108     modifier onlyProxyOwner() {
109         require (msg.sender == proxyOwner(), "Not Proxy owner");
110         _;
111     }
112     
113     /**
114     * @dev the constructor sets owner
115     */
116     constructor() {
117         _setUpgradeabilityOwner(msg.sender);
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer ownership
122      * @param _newOwner The address to transfer ownership to
123      */
124     function transferProxyOwnership(address _newOwner) 
125         public onlyProxyOwner 
126     {
127         require(_newOwner != address(0));
128         _setUpgradeabilityOwner(_newOwner);
129     }
130     
131     /**
132      * @dev Allows the proxy owner to upgrade the implementation
133      * @param _impl address of the new implementation
134      */
135     function upgradeTo(address _impl) 
136         public onlyProxyOwner
137     {
138         _upgradeTo(_impl);
139     }
140     
141     /**
142      * @dev Tells the address of the current implementation
143      * @return impl address of the current implementation
144      */
145     function _implementation()
146         internal
147         view
148         override
149         returns (address impl)
150     {
151         bytes32 position = implementationPosition;
152         assembly {
153             impl := sload(position)
154         }
155     }
156 
157     function implementation() external view returns (address) {
158         return _implementation();
159     }
160     
161     /**
162      * @dev Tells the address of the owner
163      * @return owner the address of the owner
164      */
165     function proxyOwner() public view returns (address owner) {
166         bytes32 position = proxyOwnerPosition;
167         assembly {
168             owner := sload(position)
169         }
170     }
171     
172     /**
173      * @dev Sets the address of the current implementation
174      * @param _newImplementation address of the new implementation
175      */
176     function _setImplementation(address _newImplementation) 
177         internal 
178     {
179         bytes32 position = implementationPosition;
180         assembly {
181             sstore(position, _newImplementation)
182         }
183     }
184     
185     /**
186      * @dev Upgrades the implementation address
187      * @param _newImplementation address of the new implementation
188      */
189     function _upgradeTo(address _newImplementation) internal {
190         address currentImplementation = _implementation();
191         require(currentImplementation != _newImplementation);
192         _setImplementation(_newImplementation);
193     }
194     
195     /**
196      * @dev Sets the address of the owner
197      */
198     function _setUpgradeabilityOwner(address _newProxyOwner) 
199         internal 
200     {
201         bytes32 position = proxyOwnerPosition;
202         assembly {
203             sstore(position, _newProxyOwner)
204         }
205     }
206 }