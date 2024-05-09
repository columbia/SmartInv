1 pragma solidity ^0.5.1;
2 
3 contract LockRequestable {
4 
5         // MEMBERS
6         /// @notice  the count of all invocations of `generateLockId`.
7         uint256 public lockRequestCount;
8 
9         constructor() public {
10                 lockRequestCount = 0;
11         }
12 
13         // FUNCTIONS
14         /** @notice  Returns a fresh unique identifier.
15             *
16             * @dev the generation scheme uses three components.
17             * First, the blockhash of the previous block.
18             * Second, the deployed address.
19             * Third, the next value of the counter.
20             * This ensure that identifiers are unique across all contracts
21             * following this scheme, and that future identifiers are
22             * unpredictable.
23             *
24             * @return a 32-byte unique identifier.
25             */
26         function generateLockId() internal returns (bytes32 lockId) {
27                 return keccak256(
28                 abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
29                 );
30         }
31 }
32 
33 contract CustodianUpgradeable is LockRequestable {
34 
35         // TYPES
36         /// @dev  The struct type for pending custodian changes.
37         struct CustodianChangeRequest {
38                 address proposedNew;
39         }
40 
41         // MEMBERS
42         /// @dev  The address of the account or contract that acts as the custodian.
43         address public custodian;
44 
45         /// @dev  The map of lock ids to pending custodian changes.
46         mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
47 
48         constructor(address _custodian) public LockRequestable() {
49                 custodian = _custodian;
50         }
51 
52         // MODIFIERS
53         modifier onlyCustodian {
54                 require(msg.sender == custodian);
55                 _;
56         }
57 
58         /** @notice  Requests a change of the custodian associated with this contract.
59             *
60             * @dev  Returns a unique lock id associated with the request.
61             * Anyone can call this function, but confirming the request is authorized
62             * by the custodian.
63             *
64             * @param  _proposedCustodian  The address of the new custodian.
65             * @return  lockId  A unique identifier for this request.
66             */
67         function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
68                 require(_proposedCustodian != address(0));
69 
70                 lockId = generateLockId();
71 
72                 custodianChangeReqs[lockId] = CustodianChangeRequest({
73                         proposedNew: _proposedCustodian
74                 });
75 
76                 emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
77         }
78 
79         /** @notice  Confirms a pending change of the custodian associated with this contract.
80             *
81             * @dev  When called by the current custodian with a lock id associated with a
82             * pending custodian change, the `address custodian` member will be updated with the
83             * requested address.
84             *
85             * @param  _lockId  The identifier of a pending change request.
86             */
87         function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
88                 custodian = getCustodianChangeReq(_lockId);
89 
90                 delete custodianChangeReqs[_lockId];
91 
92                 emit CustodianChangeConfirmed(_lockId, custodian);
93         }
94 
95         // PRIVATE FUNCTIONS
96         function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
97                 CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
98 
99                 // reject ‘null’ results from the map lookup
100                 // this can only be the case if an unknown `_lockId` is received
101                 require(changeRequest.proposedNew != address(0));
102 
103                 return changeRequest.proposedNew;
104         }
105 
106         /// @dev  Emitted by successful `requestCustodianChange` calls.
107         event CustodianChangeRequested(
108                 bytes32 _lockId,
109                 address _msgSender,
110                 address _proposedCustodian
111         );
112 
113         /// @dev Emitted by successful `confirmCustodianChange` calls.
114         event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
115 }
116 
117 contract ServiceRegistry is CustodianUpgradeable {
118     mapping (string => address) services;
119 
120     event ServiceReplaced(string indexed _name, address _oldAddr, address _newAddr);
121 
122     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
123     }
124 
125     function replaceService(string calldata _name, address _newAddr) external onlyCustodian withContract(_newAddr) {
126         address _prevAddr = services[_name];
127         services[_name] = _newAddr;
128         emit ServiceReplaced(_name, _prevAddr, _newAddr);
129     }
130 
131     function getService(string memory _name) public view returns (address) {
132         return services[_name];
133     }
134 
135     modifier withContract(address _addr) {
136         uint length;
137         assembly { length := extcodesize(_addr) }
138         require(length > 0);
139         _;
140     }
141 }