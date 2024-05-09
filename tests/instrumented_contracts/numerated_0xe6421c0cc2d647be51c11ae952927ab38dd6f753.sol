1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 /// @title Named Contract
5 contract NamedContract {
6     /// @notice The name of contract, which can be set once
7     string public name;
8 
9     /// @notice Sets contract name.
10     function setContractName(string memory newName) internal {
11         name = newName;
12     }
13 }
14 
15 contract Ownable {
16     /// @notice Storage position of the owner address
17     /// @dev The address of the current owner is stored in a
18     /// constant pseudorandom slot of the contract storage
19     /// (slot number obtained as a result of hashing a certain message),
20     /// the probability of rewriting which is almost zero
21     bytes32 private constant _ownerPosition = keccak256("owner");
22 
23     /// @notice Storage position of the authorized new owner address
24     bytes32 private constant _authorizedNewOwnerPosition = keccak256("authorizedNewOwner");
25 
26     /// @notice Contract constructor
27     /// @dev Sets msg sender address as owner address
28     constructor() public {
29         bytes32 ownerPosition = _ownerPosition;
30         address owner = msg.sender;
31         assembly {
32             sstore(ownerPosition, owner)
33         }
34     }
35 
36     /// @notice Check that requires msg.sender to be the current owner
37     function requireOwner() internal view {
38         require(
39             msg.sender == getOwner(),
40             "Sender must be owner"
41         );
42     }
43 
44     /// @notice Returns contract owner address
45     function getOwner() public view returns (address owner) {
46         bytes32 ownerPosition = _ownerPosition;
47         assembly {
48             owner := sload(ownerPosition)
49         }
50     }
51 
52     /// @notice Returns authorized new owner address
53     function getAuthorizedNewOwner() public view returns (address newOwner) {
54         bytes32 authorizedNewOwnerPosition = _authorizedNewOwnerPosition;
55         assembly {
56             newOwner := sload(authorizedNewOwnerPosition)
57         }
58     }
59 
60     /**
61      * @notice Authorizes the transfer of ownership to the provided address.
62      * NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership( ).
63      * This authorization may be removed by another call to this function authorizing
64      * the null address.
65      *
66      * @param authorizedAddress The address authorized to become the new owner.
67      */
68     function authorizeOwnershipTransfer(address authorizedAddress) external {
69         requireOwner();
70         bytes32 authorizedNewOwnerPosition = _authorizedNewOwnerPosition;
71         assembly {
72             sstore(authorizedNewOwnerPosition, authorizedAddress)
73         }
74     }
75     
76     /**
77      * @notice Transfers ownership of this contract to the authorizedNewOwner.
78      */
79     function assumeOwnership() external {
80         bytes32 authorizedNewOwnerPosition = _authorizedNewOwnerPosition;
81         address newOwner;
82 
83         assembly {
84             newOwner := sload(authorizedNewOwnerPosition)
85         }
86 
87         require(
88             msg.sender == newOwner,
89             "Only the authorized new owner can accept ownership"
90         );
91         
92         bytes32 ownerPosition = _ownerPosition;
93         address zero = address(0);
94 
95         assembly {
96             sstore(ownerPosition, newOwner)
97             sstore(authorizedNewOwnerPosition, zero)
98         }
99     }
100 }
101 
102 /// @title Upgradeable contract
103 contract Upgradeable is Ownable {
104     /// @notice Storage position of the current implementation address.
105     /// @dev The address of the current implementation is stored in a
106     /// constant pseudorandom slot of the contract proxy contract storage
107     /// (slot number obtained as a result of hashing a certain message),
108     /// the probability of rewriting which is almost zero
109     bytes32 private constant implementationPosition = keccak256(
110         "implementation"
111     );
112 
113     /// @notice Contract constructor
114     /// @dev Calls Ownable contract constructor
115     constructor() public Ownable() {}
116 
117     /// @notice Returns the current implementation contract address
118     function getImplementation() public view returns (address implementation) {
119         bytes32 position = implementationPosition;
120         assembly {
121             implementation := sload(position)
122         }
123     }
124 
125     /// @notice Sets new implementation contract address as current
126     /// @param _newImplementation New implementation contract address
127     function setImplementation(address _newImplementation) public {
128         requireOwner();
129         require(_newImplementation != address(0), "New implementation must have non-zero address");
130         address currentImplementation = getImplementation();
131         require(currentImplementation != _newImplementation, "New implementation must have new address");
132         bytes32 position = implementationPosition;
133         assembly {
134             sstore(position, _newImplementation)
135         }
136     }
137 
138     /// @notice Sets new implementation contract address and call its initializer.
139     /// @dev New implementation call is a low level delegatecall.
140     /// @param _newImplementation the new implementation address.
141     /// @param _newImplementaionCallData represents the msg.data to bet sent through the low level delegatecall.
142     /// This parameter may include the initializer function signature with the needed payload.
143     function setImplementationAndCall(
144         address _newImplementation,
145         bytes calldata _newImplementaionCallData
146     ) external payable {
147         setImplementation(_newImplementation);
148         if (_newImplementaionCallData.length > 0) {
149             (bool success, ) = address(this).call.value(msg.value)(
150                 _newImplementaionCallData
151             );
152             require(success, "Delegatecall has failed");
153         }
154     }
155 }
156 /// @title Upgradeable Registry Contract
157 contract SwipeRegistry is NamedContract, Upgradeable {
158     /// @notice Contract constructor
159     /// @dev Calls Upgradable contract constructor and sets contract name
160     constructor(string memory contractName) public Upgradeable() {
161         setContractName(contractName);
162     }
163     
164     /// @notice Performs a delegatecall to the implementation contract.
165     /// @dev Fallback function allows to perform a delegatecall to the given implementation.
166     /// This function will return whatever the implementation call returns.
167     function() external payable {
168         require(msg.data.length > 0, "Calldata must not be empty");
169         address _impl = getImplementation();
170         assembly {
171             // The pointer to the free memory slot
172             let ptr := mload(0x40)
173             // Copy function signature and arguments from calldata at zero position into memory at pointer position
174             calldatacopy(ptr, 0x0, calldatasize)
175             // Delegatecall method of the implementation contract, returns 0 on error
176             let result := delegatecall(gas, _impl, ptr, calldatasize, 0x0, 0)
177             // Get the size of the last return data
178             let size := returndatasize
179             // Copy the size length of bytes from return data at zero position to pointer position
180             returndatacopy(ptr, 0x0, size)
181             // Depending on result value
182             switch result
183                 case 0 {
184                     // End execution and revert state changes
185                     revert(ptr, size)
186                 }
187                 default {
188                     // Return data with length of size at pointers position
189                     return(ptr, size)
190                 }
191         }
192     }
193 }
194 contract GovernanceEvent {
195     /// @notice An event emitted when initialize
196     event Initialize(
197         address indexed timelockAddress,
198         address indexed stakingAddress,
199         address indexed guardian
200     );
201 
202     event GuardianshipTransferAuthorization(
203         address indexed authorizedAddress
204     );
205 
206     event GuardianUpdate(
207         address indexed oldValue,
208         address indexed newValue
209     );
210 
211     event QuorumVotesUpdate(
212         uint256 indexed oldValue,
213         uint256 indexed newValue
214     );
215 
216     event ProposalThresholdUpdate(
217         uint256 indexed oldValue,
218         uint256 indexed newValue
219     );
220 
221     event ProposalMaxOperationsUpdate(
222         uint256 indexed oldValue,
223         uint256 indexed newValue
224     );
225 
226     event VotingDelayUpdate(
227         uint256 indexed oldValue,
228         uint256 indexed newValue
229     );
230 
231     event VotingPeriodUpdate(
232         uint256 indexed oldValue,
233         uint256 indexed newValue
234     );
235 
236     event ProposalCreation(
237         uint256 indexed id,
238         address indexed proposer,
239         address[] targets,
240         uint256[] values,
241         string[] signatures,
242         bytes[] calldatas,
243         uint256 indexed startBlock,
244         uint256 endBlock,
245         string description
246     );
247 
248     event Vote(
249         address indexed voter,
250         uint256 indexed proposalId,
251         bool indexed support,
252         uint256 votes
253     );
254 
255     event ProposalCancel(
256         uint256 indexed id
257     );
258 
259     event ProposalQueue(
260         uint256 indexed id,
261         uint256 indexed eta
262     );
263 
264     event ProposalExecution(
265         uint256 indexed id
266     );
267 }
268 
269 
270 /// @title Governance Proxy Contract
271 contract GovernanceProxy is SwipeRegistry, GovernanceEvent {
272     /// @notice Contract constructor
273     /// @dev Calls SwipeRegistry contract constructor
274     constructor() public SwipeRegistry("Swipe Governance Proxy") {}
275 }