1 pragma solidity ^0.4.24;
2 
3 // File: contracts/upgradeability/ImplementationStorage.sol
4 
5 /**
6  * @title ImplementationStorage
7  * @dev This contract stores proxy implementation address.
8  */
9 contract ImplementationStorage {
10 
11     /**
12      * @dev Storage slot with the address of the current implementation.
13      * This is the keccak-256 hash of "cvc.proxy.implementation", and is validated in the constructor.
14      */
15     bytes32 internal constant IMPLEMENTATION_SLOT = 0xa490aab0d89837371982f93f57ffd20c47991f88066ef92475bc8233036969bb;
16 
17     /**
18     * @dev Constructor
19     */
20     constructor() public {
21         assert(IMPLEMENTATION_SLOT == keccak256("cvc.proxy.implementation"));
22     }
23 
24     /**
25      * @dev Returns the current implementation.
26      * @return Address of the current implementation
27      */
28     function implementation() public view returns (address impl) {
29         bytes32 slot = IMPLEMENTATION_SLOT;
30         assembly {
31             impl := sload(slot)
32         }
33     }
34 }
35 
36 // File: openzeppelin-solidity/contracts/AddressUtils.sol
37 
38 /**
39  * Utility library of inline functions on addresses
40  */
41 library AddressUtils {
42 
43   /**
44    * Returns whether the target address is a contract
45    * @dev This function will return false if invoked during the constructor of a contract,
46    *  as the code is not actually created until after the constructor finishes.
47    * @param addr address to check
48    * @return whether the target address is a contract
49    */
50   function isContract(address addr) internal view returns (bool) {
51     uint256 size;
52     // XXX Currently there is no better way to check if there is a contract in an address
53     // than to check the size of the code at that address.
54     // See https://ethereum.stackexchange.com/a/14016/36603
55     // for more details about how this works.
56     // TODO Check this again before the Serenity release, because all addresses will be
57     // contracts then.
58     // solium-disable-next-line security/no-inline-assembly
59     assembly { size := extcodesize(addr) }
60     return size > 0;
61   }
62 
63 }
64 
65 // File: contracts/upgradeability/CvcProxy.sol
66 
67 /**
68  * @title CvcProxy
69  * @dev Transparent proxy with upgradeability functions and authorization control.
70  */
71 contract CvcProxy is ImplementationStorage {
72 
73     /**
74      * @dev Emitted when the implementation is upgraded.
75      * @param implementation Address of the new implementation.
76      */
77     event Upgraded(address implementation);
78 
79     /**
80      * @dev Emitted when the administration has been transferred.
81      * @param previousAdmin Address of the previous admin.
82      * @param newAdmin Address of the new admin.
83      */
84     event AdminChanged(address previousAdmin, address newAdmin);
85 
86     /**
87      * @dev Storage slot with the admin of the contract.
88      * This is the keccak-256 hash of "cvc.proxy.admin", and is validated in the constructor.
89      */
90     bytes32 private constant ADMIN_SLOT = 0x2bbac3e52eee27be250d682577104e2abe776c40160cd3167b24633933100433;
91 
92     /**
93      * @dev Modifier to check whether the `msg.sender` is the admin.
94      * It executes the function if called by admin. Otherwise, it will delegate the call to the implementation.
95      */
96     modifier ifAdmin() {
97         if (msg.sender == currentAdmin()) {
98             _;
99         } else {
100             delegate(implementation());
101         }
102     }
103 
104     /**
105      * Contract constructor.
106      * It sets the `msg.sender` as the proxy admin.
107      */
108     constructor() public {
109         assert(ADMIN_SLOT == keccak256("cvc.proxy.admin"));
110         setAdmin(msg.sender);
111     }
112 
113     /**
114      * @dev Fallback function.
115      */
116     function() external payable {
117         require(msg.sender != currentAdmin(), "Message sender is not contract admin");
118         delegate(implementation());
119     }
120 
121     /**
122      * @dev Changes the admin of the proxy.
123      * Only the current admin can call this function.
124      * @param _newAdmin Address to transfer proxy administration to.
125      */
126     function changeAdmin(address _newAdmin) external ifAdmin {
127         require(_newAdmin != address(0), "Cannot change contract admin to zero address");
128         emit AdminChanged(currentAdmin(), _newAdmin);
129         setAdmin(_newAdmin);
130     }
131 
132     /**
133      * @dev Allows the proxy owner to upgrade the current version of the proxy.
134      * @param _implementation the address of the new implementation to be set.
135      */
136     function upgradeTo(address _implementation) external ifAdmin {
137         upgradeImplementation(_implementation);
138     }
139 
140     /**
141      * @dev Allows the proxy owner to upgrade and call the new implementation
142      * to initialize whatever is needed through a low level call.
143      * @param _implementation the address of the new implementation to be set.
144      * @param _data the msg.data to bet sent in the low level call. This parameter may include the function
145      * signature of the implementation to be called with the needed payload.
146      */
147     function upgradeToAndCall(address _implementation, bytes _data) external payable ifAdmin {
148         upgradeImplementation(_implementation);
149         //solium-disable-next-line security/no-call-value
150         require(address(this).call.value(msg.value)(_data), "Upgrade error: initialization method call failed");
151     }
152 
153     /**
154      * @dev Returns the Address of the proxy admin.
155      * @return address
156      */
157     function admin() external view ifAdmin returns (address) {
158         return currentAdmin();
159     }
160 
161     /**
162      * @dev Upgrades the implementation address.
163      * @param _newImplementation the address of the new implementation to be set
164      */
165     function upgradeImplementation(address _newImplementation) private {
166         address currentImplementation = implementation();
167         require(currentImplementation != _newImplementation, "Upgrade error: proxy contract already uses specified implementation");
168         setImplementation(_newImplementation);
169         emit Upgraded(_newImplementation);
170     }
171 
172     /**
173      * @dev Delegates execution to an implementation contract.
174      * This is a low level function that doesn't return to its internal call site.
175      * It will return to the external caller whatever the implementation returns.
176      * @param _implementation Address to delegate.
177      */
178     function delegate(address _implementation) private {
179         assembly {
180             // Copy msg.data.
181             calldatacopy(0, 0, calldatasize)
182 
183             // Call current implementation passing proxy calldata.
184             let result := delegatecall(gas, _implementation, 0, calldatasize, 0, 0)
185 
186             // Copy the returned data.
187             returndatacopy(0, 0, returndatasize)
188 
189             // Propagate result (delegatecall returns 0 on error).
190             switch result
191             case 0 {revert(0, returndatasize)}
192             default {return (0, returndatasize)}
193         }
194     }
195 
196     /**
197      * @return The admin slot.
198      */
199     function currentAdmin() private view returns (address proxyAdmin) {
200         bytes32 slot = ADMIN_SLOT;
201         assembly {
202             proxyAdmin := sload(slot)
203         }
204     }
205 
206     /**
207      * @dev Sets the address of the proxy admin.
208      * @param _newAdmin Address of the new proxy admin.
209      */
210     function setAdmin(address _newAdmin) private {
211         bytes32 slot = ADMIN_SLOT;
212         assembly {
213             sstore(slot, _newAdmin)
214         }
215     }
216 
217     /**
218      * @dev Sets the implementation address of the proxy.
219      * @param _newImplementation Address of the new implementation.
220      */
221     function setImplementation(address _newImplementation) private {
222         require(
223             AddressUtils.isContract(_newImplementation),
224             "Cannot set new implementation: no contract code at contract address"
225         );
226         bytes32 slot = IMPLEMENTATION_SLOT;
227         assembly {
228             sstore(slot, _newImplementation)
229         }
230     }
231 
232 }