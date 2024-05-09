1 pragma solidity 0.4.24;
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
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 interface AccountRegistryInterface {
44   function accountIdForAddress(address _address) public view returns (uint256);
45   function addressBelongsToAccount(address _address) public view returns (bool);
46   function createNewAccount(address _newUser) external;
47   function addAddressToAccount(
48     address _newAddress,
49     address _sender
50     ) external;
51   function removeAddressFromAccount(address _addressToRemove) external;
52 }
53 
54 /**
55  * @title Bloom account registry
56  * @notice Account Registry implements the Bloom ID data structures 
57  * and the low-level account administration functions.
58  * The account administration functions are not publicly accessible.
59  * Account Registry Logic implements the public functions which access the functions in Account Registry.
60  */
61 contract AccountRegistry is Ownable, AccountRegistryInterface{
62 
63   address public accountRegistryLogic;
64 
65   /**
66    * @notice The AccountRegistry constructor configures the account registry logic implementation
67    *  and creates an account for the user who deployed the contract.
68    * @dev The owner is also set as the original registryAdmin, who has the privilege to
69    *  create accounts outside of the normal invitation flow.
70    * @param _accountRegistryLogic Address of deployed Account Registry Logic implementation
71    */
72   constructor(
73     address _accountRegistryLogic
74     ) public {
75     accountRegistryLogic = _accountRegistryLogic;
76   }
77 
78   event AccountRegistryLogicChanged(address oldRegistryLogic, address newRegistryLogic);
79 
80   /**
81    * @dev Zero address not allowed
82    */
83   modifier nonZero(address _address) {
84     require(_address != 0);
85     _;
86   }
87 
88   modifier onlyAccountRegistryLogic() {
89     require(msg.sender == accountRegistryLogic);
90     _;
91   }
92 
93   // Counter to generate unique account Ids
94   uint256 numAccounts;
95   mapping(address => uint256) public accountByAddress;
96 
97   /**
98    * @notice Change the address of the registry logic which has exclusive write control over this contract
99    * @dev Restricted to AccountRegistry owner and new admin address cannot be 0x0
100    * @param _newRegistryLogic Address of new registry logic implementation
101    */
102   function setRegistryLogic(address _newRegistryLogic) public onlyOwner nonZero(_newRegistryLogic) {
103     address _oldRegistryLogic = accountRegistryLogic;
104     accountRegistryLogic = _newRegistryLogic;
105     emit AccountRegistryLogicChanged(_oldRegistryLogic, accountRegistryLogic);
106   }
107 
108   /**
109    * @notice Retreive account ID associated with a user's address
110    * @param _address Address to look up
111    * @return account id as uint256 if exists, otherwise reverts
112    */
113   function accountIdForAddress(address _address) public view returns (uint256) {
114     require(addressBelongsToAccount(_address));
115     return accountByAddress[_address];
116   }
117 
118   /**
119    * @notice Check if an address is associated with any user account
120    * @dev Check if address is associated with any user by cross validating
121    *  the accountByAddress with addressByAccount 
122    * @param _address Address to check
123    * @return true if address has been assigned to user. otherwise reverts
124    */
125   function addressBelongsToAccount(address _address) public view returns (bool) {
126     return accountByAddress[_address] > 0;
127   }
128 
129   /**
130    * @notice Create an account for a user and emit an event
131    * @param _newUser Address of the new user
132    */
133   function createNewAccount(address _newUser) external onlyAccountRegistryLogic nonZero(_newUser) {
134     require(!addressBelongsToAccount(_newUser));
135     numAccounts++;
136     accountByAddress[_newUser] = numAccounts;
137   }
138 
139   /**
140    * @notice Add an address to an existing id 
141    * @param _newAddress Address to add to account
142    * @param _sender User requesting this action
143    */
144   function addAddressToAccount(
145     address _newAddress,
146     address _sender
147     ) external onlyAccountRegistryLogic nonZero(_newAddress) {
148 
149     // check if address belongs to someone else
150     require(!addressBelongsToAccount(_newAddress));
151 
152     accountByAddress[_newAddress] = accountIdForAddress(_sender);
153   }
154 
155   /**
156    * @notice Remove an address from an id
157    * @param _addressToRemove Address to remove from account
158    */
159   function removeAddressFromAccount(
160     address _addressToRemove
161     ) external onlyAccountRegistryLogic {
162     delete accountByAddress[_addressToRemove];
163   }
164 }