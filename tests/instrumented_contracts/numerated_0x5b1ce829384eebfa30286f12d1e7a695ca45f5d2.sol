1 // File: contracts/IManager.sol
2 
3 pragma solidity ^0.5.11;
4 
5 
6 contract IManager {
7     event SetController(address controller);
8     event ParameterUpdate(string param);
9 
10     function setController(address _controller) external;
11 }
12 
13 // File: contracts/zeppelin/Ownable.sol
14 
15 pragma solidity ^0.5.11;
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24     address public owner;
25 
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30     /**
31     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32     * account.
33     */
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46 
47     /**
48     * @dev Allows the current owner to transfer control of the contract to a newOwner.
49     * @param newOwner The address to transfer ownership to.
50     */
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 // File: contracts/zeppelin/Pausable.sol
59 
60 pragma solidity ^0.5.11;
61 
62 
63 
64 /**
65  * @title Pausable
66  * @dev Base contract which allows children to implement an emergency stop mechanism.
67  */
68 contract Pausable is Ownable {
69     event Pause();
70     event Unpause();
71 
72     bool public paused = false;
73 
74 
75     /**
76     * @dev Modifier to make a function callable only when the contract is not paused.
77     */
78     modifier whenNotPaused() {
79         require(!paused);
80         _;
81     }
82 
83     /**
84     * @dev Modifier to make a function callable only when the contract is paused.
85     */
86     modifier whenPaused() {
87         require(paused);
88         _;
89     }
90 
91     /**
92     * @dev called by the owner to pause, triggers stopped state
93     */
94     function pause() public onlyOwner whenNotPaused {
95         paused = true;
96         emit Pause();
97     }
98 
99     /**
100     * @dev called by the owner to unpause, returns to normal state
101     */
102     function unpause() public onlyOwner whenPaused {
103         paused = false;
104         emit Unpause();
105     }
106 }
107 
108 // File: contracts/IController.sol
109 
110 pragma solidity ^0.5.11;
111 
112 
113 
114 contract IController is Pausable {
115     event SetContractInfo(bytes32 id, address contractAddress, bytes20 gitCommitHash);
116 
117     function setContractInfo(bytes32 _id, address _contractAddress, bytes20 _gitCommitHash) external;
118     function updateController(bytes32 _id, address _controller) external;
119     function getContract(bytes32 _id) public view returns (address);
120 }
121 
122 // File: contracts/Manager.sol
123 
124 pragma solidity ^0.5.11;
125 
126 
127 
128 
129 contract Manager is IManager {
130     // Controller that contract is registered with
131     IController public controller;
132 
133     // Check if sender is controller
134     modifier onlyController() {
135         require(msg.sender == address(controller), "caller must be Controller");
136         _;
137     }
138 
139     // Check if sender is controller owner
140     modifier onlyControllerOwner() {
141         require(msg.sender == controller.owner(), "caller must be Controller owner");
142         _;
143     }
144 
145     // Check if controller is not paused
146     modifier whenSystemNotPaused() {
147         require(!controller.paused(), "system is paused");
148         _;
149     }
150 
151     // Check if controller is paused
152     modifier whenSystemPaused() {
153         require(controller.paused(), "system is not paused");
154         _;
155     }
156 
157     constructor(address _controller) public {
158         controller = IController(_controller);
159     }
160 
161     /**
162      * @notice Set controller. Only callable by current controller
163      * @param _controller Controller contract address
164      */
165     function setController(address _controller) external onlyController {
166         controller = IController(_controller);
167 
168         emit SetController(_controller);
169     }
170 }
171 
172 // File: contracts/ManagerProxyTarget.sol
173 
174 pragma solidity ^0.5.11;
175 
176 
177 
178 /**
179  * @title ManagerProxyTarget
180  * @notice The base contract that target contracts used by a proxy contract should inherit from
181  * @dev Both the target contract and the proxy contract (implemented as ManagerProxy) MUST inherit from ManagerProxyTarget in order to guarantee
182  that both contracts have the same storage layout. Differing storage layouts in a proxy contract and target contract can
183  potentially break the delegate proxy upgradeability mechanism
184  */
185 contract ManagerProxyTarget is Manager {
186     // Used to look up target contract address in controller's registry
187     bytes32 public targetContractId;
188 }
189 
190 // File: contracts/ManagerProxy.sol
191 
192 pragma solidity ^0.5.11;
193 
194 
195 
196 /**
197  * @title ManagerProxy
198  * @notice A proxy contract that uses delegatecall to execute function calls on a target contract using its own storage context.
199  The target contract is a Manager contract that is registered with the Controller.
200  * @dev Both this proxy contract and its target contract MUST inherit from ManagerProxyTarget in order to guarantee
201  that both contracts have the same storage layout. Differing storage layouts in a proxy contract and target contract can
202  potentially break the delegate proxy upgradeability mechanism. Since this proxy contract inherits from ManagerProxyTarget which inherits
203  from Manager, it implements the setController() function. The target contract will also implement setController() since it also inherits
204  from ManagerProxyTarget. Thus, any transaction sent to the proxy that calls setController() will execute against the proxy instead
205  of the target. As a result, developers should keep in mind that the proxy will always execute the same logic for setController() regardless
206  of the setController() implementation on the target contract. Generally, developers should not add any additional functions to this proxy contract
207  because any function implemented on the proxy will always be executed against the proxy and the call **will not** be forwarded to the target contract
208  */
209 contract ManagerProxy is ManagerProxyTarget {
210     /**
211      * @notice ManagerProxy constructor. Invokes constructor of base Manager contract with provided Controller address.
212      * Also, sets the contract ID of the target contract that function calls will be executed on.
213      * @param _controller Address of Controller that this contract will be registered with
214      * @param _targetContractId contract ID of the target contract
215      */
216     constructor(address _controller, bytes32 _targetContractId) public Manager(_controller) {
217         targetContractId = _targetContractId;
218     }
219 
220     /**
221      * @notice Uses delegatecall to execute function calls on this proxy contract's target contract using its own storage context.
222      This fallback function will look up the address of the target contract using the Controller and the target contract ID.
223      It will then use the calldata for a function call as the data payload for a delegatecall on the target contract. The return value
224      of the executed function call will also be returned
225      */
226     function() external payable {
227         address target = controller.getContract(targetContractId);
228         require(
229             target != address(0),
230             "target contract must be registered"
231         );
232 
233         assembly {
234             // Solidity keeps a free memory pointer at position 0x40 in memory
235             let freeMemoryPtrPosition := 0x40
236             // Load the free memory pointer
237             let calldataMemoryOffset := mload(freeMemoryPtrPosition)
238             // Update free memory pointer to after memory space we reserve for calldata
239             mstore(freeMemoryPtrPosition, add(calldataMemoryOffset, calldatasize))
240             // Copy calldata (method signature and params of the call) to memory
241             calldatacopy(calldataMemoryOffset, 0x0, calldatasize)
242 
243             // Call method on target contract using calldata which is loaded into memory
244             let ret := delegatecall(gas, target, calldataMemoryOffset, calldatasize, 0, 0)
245 
246             // Load the free memory pointer
247             let returndataMemoryOffset := mload(freeMemoryPtrPosition)
248             // Update free memory pointer to after memory space we reserve for returndata
249             mstore(freeMemoryPtrPosition, add(returndataMemoryOffset, returndatasize))
250             // Copy returndata (result of the method invoked by the delegatecall) to memory
251             returndatacopy(returndataMemoryOffset, 0x0, returndatasize)
252 
253             switch ret
254             case 0 {
255                 // Method call failed - revert
256                 // Return any error message stored in mem[returndataMemoryOffset..(returndataMemoryOffset + returndatasize)]
257                 revert(returndataMemoryOffset, returndatasize)
258             } default {
259                 // Return result of method call stored in mem[returndataMemoryOffset..(returndataMemoryOffset + returndatasize)]
260                 return(returndataMemoryOffset, returndatasize)
261             }
262         }
263     }
264 }