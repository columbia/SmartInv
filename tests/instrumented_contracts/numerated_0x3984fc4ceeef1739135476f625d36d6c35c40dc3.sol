1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 contract IController is Pausable {
89     event SetContractInfo(bytes32 id, address contractAddress, bytes20 gitCommitHash);
90 
91     function setContractInfo(bytes32 _id, address _contractAddress, bytes20 _gitCommitHash) external;
92     function updateController(bytes32 _id, address _controller) external;
93     function getContract(bytes32 _id) public view returns (address);
94 }
95 
96 contract IManager {
97     event SetController(address controller);
98     event ParameterUpdate(string param);
99 
100     function setController(address _controller) external;
101 }
102 
103 contract Manager is IManager {
104     // Controller that contract is registered with
105     IController public controller;
106 
107     // Check if sender is controller
108     modifier onlyController() {
109         require(msg.sender == address(controller));
110         _;
111     }
112 
113     // Check if sender is controller owner
114     modifier onlyControllerOwner() {
115         require(msg.sender == controller.owner());
116         _;
117     }
118 
119     // Check if controller is not paused
120     modifier whenSystemNotPaused() {
121         require(!controller.paused());
122         _;
123     }
124 
125     // Check if controller is paused
126     modifier whenSystemPaused() {
127         require(controller.paused());
128         _;
129     }
130 
131     function Manager(address _controller) public {
132         controller = IController(_controller);
133     }
134 
135     /*
136      * @dev Set controller. Only callable by current controller
137      * @param _controller Controller contract address
138      */
139     function setController(address _controller) external onlyController {
140         controller = IController(_controller);
141 
142         SetController(_controller);
143     }
144 }
145 
146 /**
147  * @title ManagerProxyTarget
148  * @dev The base contract that target contracts used by a proxy contract should inherit from
149  * Note: Both the target contract and the proxy contract (implemented as ManagerProxy) MUST inherit from ManagerProxyTarget in order to guarantee
150  * that both contracts have the same storage layout. Differing storage layouts in a proxy contract and target contract can
151  * potentially break the delegate proxy upgradeability mechanism
152  */
153 contract ManagerProxyTarget is Manager {
154     // Used to look up target contract address in controller's registry
155     bytes32 public targetContractId;
156 }
157 
158 /**
159  * @title ManagerProxy
160  * @dev A proxy contract that uses delegatecall to execute function calls on a target contract using its own storage context.
161  * The target contract is a Manager contract that is registered with the Controller.
162  * Note: Both this proxy contract and its target contract MUST inherit from ManagerProxyTarget in order to guarantee
163  * that both contracts have the same storage layout. Differing storage layouts in a proxy contract and target contract can
164  * potentially break the delegate proxy upgradeability mechanism
165  */
166 contract ManagerProxy is ManagerProxyTarget {
167     /**
168      * @dev ManagerProxy constructor. Invokes constructor of base Manager contract with provided Controller address.
169      * Also, sets the contract ID of the target contract that function calls will be executed on.
170      * @param _controller Address of Controller that this contract will be registered with
171      * @param _targetContractId contract ID of the target contract
172      */
173     function ManagerProxy(address _controller, bytes32 _targetContractId) public Manager(_controller) {
174         targetContractId = _targetContractId;
175     }
176 
177     /**
178      * @dev Uses delegatecall to execute function calls on this proxy contract's target contract using its own storage context.
179      * This fallback function will look up the address of the target contract using the Controller and the target contract ID.
180      * It will then use the calldata for a function call as the data payload for a delegatecall on the target contract. The return value
181      * of the executed function call will also be returned
182      */
183     function() public payable {
184         address target = controller.getContract(targetContractId);
185         // Target contract must be registered
186         require(target > 0);
187 
188         assembly {
189             // Solidity keeps a free memory pointer at position 0x40 in memory
190             let freeMemoryPtrPosition := 0x40
191             // Load the free memory pointer
192             let calldataMemoryOffset := mload(freeMemoryPtrPosition)
193             // Update free memory pointer to after memory space we reserve for calldata
194             mstore(freeMemoryPtrPosition, add(calldataMemoryOffset, calldatasize))
195             // Copy calldata (method signature and params of the call) to memory
196             calldatacopy(calldataMemoryOffset, 0x0, calldatasize)
197 
198             // Call method on target contract using calldata which is loaded into memory
199             let ret := delegatecall(gas, target, calldataMemoryOffset, calldatasize, 0, 0)
200 
201             // Load the free memory pointer
202             let returndataMemoryOffset := mload(freeMemoryPtrPosition)
203             // Update free memory pointer to after memory space we reserve for returndata
204             mstore(freeMemoryPtrPosition, add(returndataMemoryOffset, returndatasize))
205             // Copy returndata (result of the method invoked by the delegatecall) to memory
206             returndatacopy(returndataMemoryOffset, 0x0, returndatasize)
207 
208             switch ret
209             case 0 {
210                 // Method call failed - revert
211                 // Return any error message stored in mem[returndataMemoryOffset..(returndataMemoryOffset + returndatasize)]
212                 revert(returndataMemoryOffset, returndatasize)
213             } default {
214                 // Return result of method call stored in mem[returndataMemoryOffset..(returndataMemoryOffset + returndatasize)]
215                 return(returndataMemoryOffset, returndatasize)
216             }
217         }
218     }
219 }