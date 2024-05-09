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
117 contract KnowYourCustomer is CustodianUpgradeable {
118 
119     enum Status {
120         none,
121         passed,
122         suspended
123     }
124 
125     struct Customer {
126         Status status;
127         mapping(string => string) fields;
128     }
129     
130     event ProviderAuthorized(address indexed _provider, string _name);
131     event ProviderRemoved(address indexed _provider, string _name);
132     event CustomerApproved(address indexed _customer, address indexed _provider);
133     event CustomerSuspended(address indexed _customer, address indexed _provider);
134     event CustomerFieldSet(address indexed _customer, address indexed _field, string _name);
135 
136     mapping(address => bool) private providers;
137     mapping(address => Customer) private customers;
138 
139     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
140         customers[_custodian].status = Status.passed;
141         customers[_custodian].fields["type"] = "custodian";
142         emit CustomerApproved(_custodian, msg.sender);
143         emit CustomerFieldSet(_custodian, msg.sender, "type");
144     }
145 
146     function providerAuthorize(address _provider, string calldata name) external onlyCustodian {
147         require(providers[_provider] == false, "provider must not exist");
148         providers[_provider] = true;
149         // cc:II. Manage Providers#2;Provider becomes authorized in contract;1;
150         emit ProviderAuthorized(_provider, name);
151     }
152 
153     function providerRemove(address _provider, string calldata name) external onlyCustodian {
154         require(providers[_provider] == true, "provider must exist");
155         delete providers[_provider];
156         emit ProviderRemoved(_provider, name);
157     }
158 
159     function hasWritePermissions(address _provider) external view returns (bool) {
160         return _provider == custodian || providers[_provider] == true;
161     }
162 
163     function getCustomerStatus(address _customer) external view returns (Status) {
164         return customers[_customer].status;
165     }
166 
167     function getCustomerField(address _customer, string calldata _field) external view returns (string memory) {
168         return customers[_customer].fields[_field];
169     }
170 
171     function approveCustomer(address _customer) external onlyAuthorized {
172         Status status = customers[_customer].status;
173         require(status != Status.passed, "customer must not be approved before");
174         customers[_customer].status = Status.passed;
175         // cc:III. Manage Customers#2;Customer becomes approved in contract;1;
176         emit CustomerApproved(_customer, msg.sender);
177     }
178 
179     function setCustomerField(address _customer, string calldata _field, string calldata _value) external onlyAuthorized {
180         Status status = customers[_customer].status;
181         require(status != Status.none, "customer must have a set status");
182         customers[_customer].fields[_field] = _value;
183         emit CustomerFieldSet(_customer, msg.sender, _field);
184     }
185 
186     function suspendCustomer(address _customer) external onlyAuthorized {
187         Status status = customers[_customer].status;
188         require(status != Status.suspended, "customer must be not suspended");
189         customers[_customer].status = Status.suspended;
190         emit CustomerSuspended(_customer, msg.sender);
191     }
192 
193     modifier onlyAuthorized() {
194         require(msg.sender == custodian || providers[msg.sender] == true);
195         _;
196     }
197 }