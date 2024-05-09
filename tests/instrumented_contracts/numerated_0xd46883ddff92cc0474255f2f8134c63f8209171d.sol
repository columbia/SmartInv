1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/OwnableUpdated.sol
4 
5 /**
6  * @title Ownable
7  * @notice Implementation by OpenZeppelin
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
11  */
12 contract OwnableUpdated {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     constructor () internal {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /**
27      * @return the address of the owner.
28      */
29     function owner() public view returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(isOwner());
38         _;
39     }
40 
41     /**
42      * @return true if `msg.sender` is the owner of the contract.
43      */
44     function isOwner() public view returns (bool) {
45         return msg.sender == _owner;
46     }
47 
48     /**
49      * @dev Allows the current owner to relinquish control of the contract.
50      * @notice Renouncing to ownership will leave the contract without an owner.
51      * It will not be possible to call the functions with the `onlyOwner`
52      * modifier anymore.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 // File: contracts/Foundation.sol
79 
80 /**
81  * @title Foundation contract.
82  * @author Talao, Polynomial.
83  */
84 contract Foundation is OwnableUpdated {
85 
86     // Registered foundation factories.
87     mapping(address => bool) public factories;
88 
89     // Owners (EOA) to contract addresses relationships.
90     mapping(address => address) public ownersToContracts;
91 
92     // Contract addresses to owners relationships.
93     mapping(address => address) public contractsToOwners;
94 
95     // Index of known contract addresses.
96     address[] private contractsIndex;
97 
98     // Members (EOA) to contract addresses relationships.
99     // In a Partnership.sol inherited contract, this allows us to create a
100     // modifier for most read functions in this contract that will authorize
101     // any account associated with an authorized Partnership contract.
102     mapping(address => address) public membersToContracts;
103 
104     // Index of known members for each contract.
105     // These are EOAs that were added once, even if removed now.
106     mapping(address => address[]) public contractsToKnownMembersIndexes;
107 
108     // Events for factories.
109     event FactoryAdded(address _factory);
110     event FactoryRemoved(address _factory);
111 
112     /**
113      * @dev Add a factory.
114      */
115     function addFactory(address _factory) external onlyOwner {
116         factories[_factory] = true;
117         emit FactoryAdded(_factory);
118     }
119 
120     /**
121      * @dev Remove a factory.
122      */
123     function removeFactory(address _factory) external onlyOwner {
124         factories[_factory] = false;
125         emit FactoryRemoved(_factory);
126     }
127 
128     /**
129      * @dev Modifier for factories.
130      */
131     modifier onlyFactory() {
132         require(
133             factories[msg.sender],
134             "You are not a factory"
135         );
136         _;
137     }
138 
139     /**
140      * @dev Set initial owner of a contract.
141      */
142     function setInitialOwnerInFoundation(
143         address _contract,
144         address _account
145     )
146         external
147         onlyFactory
148     {
149         require(
150             contractsToOwners[_contract] == address(0),
151             "Contract already has owner"
152         );
153         require(
154             ownersToContracts[_account] == address(0),
155             "Account already has contract"
156         );
157         contractsToOwners[_contract] = _account;
158         contractsIndex.push(_contract);
159         ownersToContracts[_account] = _contract;
160         membersToContracts[_account] = _contract;
161     }
162 
163     /**
164      * @dev Transfer a contract to another account.
165      */
166     function transferOwnershipInFoundation(
167         address _contract,
168         address _newAccount
169     )
170         external
171     {
172         require(
173             (
174                 ownersToContracts[msg.sender] == _contract &&
175                 contractsToOwners[_contract] == msg.sender
176             ),
177             "You are not the owner"
178         );
179         ownersToContracts[msg.sender] = address(0);
180         membersToContracts[msg.sender] = address(0);
181         ownersToContracts[_newAccount] = _contract;
182         membersToContracts[_newAccount] = _contract;
183         contractsToOwners[_contract] = _newAccount;
184         // Remark: we do not update the contracts members.
185         // It's the new owner's responsability to remove members, if needed.
186     }
187 
188     /**
189      * @dev Allows the current owner to relinquish control of the contract.
190      * This is called through the contract.
191      */
192     function renounceOwnershipInFoundation() external returns (bool success) {
193         // Remove members.
194         delete(contractsToKnownMembersIndexes[msg.sender]);
195         // Free the EOA, so he can become owner of a new contract.
196         delete(ownersToContracts[contractsToOwners[msg.sender]]);
197         // Assign the contract to no one.
198         delete(contractsToOwners[msg.sender]);
199         // Return.
200         success = true;
201     }
202 
203     /**
204      * @dev Add a member EOA to a contract.
205      */
206     function addMember(address _member) external {
207         require(
208             ownersToContracts[msg.sender] != address(0),
209             "You own no contract"
210         );
211         require(
212             membersToContracts[_member] == address(0),
213             "Address is already member of a contract"
214         );
215         membersToContracts[_member] = ownersToContracts[msg.sender];
216         contractsToKnownMembersIndexes[ownersToContracts[msg.sender]].push(_member);
217     }
218 
219     /**
220      * @dev Remove a member EOA to a contract.
221      */
222     function removeMember(address _member) external {
223         require(
224             ownersToContracts[msg.sender] != address(0),
225             "You own no contract"
226         );
227         require(
228             membersToContracts[_member] == ownersToContracts[msg.sender],
229             "Address is not member of this contract"
230         );
231         membersToContracts[_member] = address(0);
232         contractsToKnownMembersIndexes[ownersToContracts[msg.sender]].push(_member);
233     }
234 
235     /**
236      * @dev Getter for contractsIndex.
237      * The automatic getter can not return array.
238      */
239     function getContractsIndex()
240         external
241         onlyOwner
242         view
243         returns (address[])
244     {
245         return contractsIndex;
246     }
247 
248     /**
249      * @dev Prevents accidental sending of ether.
250      */
251     function() public {
252         revert("Prevent accidental sending of ether");
253     }
254 }