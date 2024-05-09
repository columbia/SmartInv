1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/interfaces/IWhitelistable.sol
78 
79 pragma solidity 0.5.4;
80 
81 
82 interface IWhitelistable {
83     event Whitelisted(address account);
84     event Unwhitelisted(address account);
85 
86     function isWhitelisted(address account) external returns (bool);
87     function whitelist(address account) external;
88     function unwhitelist(address account) external;
89     function isModerator(address account) external view returns (bool);
90     function renounceModerator() external;
91 }
92 
93 // File: openzeppelin-solidity/contracts/access/Roles.sol
94 
95 pragma solidity ^0.5.2;
96 
97 /**
98  * @title Roles
99  * @dev Library for managing addresses assigned to a Role.
100  */
101 library Roles {
102     struct Role {
103         mapping (address => bool) bearer;
104     }
105 
106     /**
107      * @dev give an account access to this role
108      */
109     function add(Role storage role, address account) internal {
110         require(account != address(0));
111         require(!has(role, account));
112 
113         role.bearer[account] = true;
114     }
115 
116     /**
117      * @dev remove an account's access to this role
118      */
119     function remove(Role storage role, address account) internal {
120         require(account != address(0));
121         require(has(role, account));
122 
123         role.bearer[account] = false;
124     }
125 
126     /**
127      * @dev check if an account has this role
128      * @return bool
129      */
130     function has(Role storage role, address account) internal view returns (bool) {
131         require(account != address(0));
132         return role.bearer[account];
133     }
134 }
135 
136 // File: contracts/roles/ModeratorRole.sol
137 
138 pragma solidity 0.5.4;
139 
140 
141 
142 // @notice Moderators are able to modify whitelists and transfer permissions in Moderator contracts.
143 contract ModeratorRole {
144     using Roles for Roles.Role;
145 
146     event ModeratorAdded(address indexed account);
147     event ModeratorRemoved(address indexed account);
148 
149     Roles.Role internal _moderators;
150 
151     modifier onlyModerator() {
152         require(isModerator(msg.sender), "Only Moderators can execute this function.");
153         _;
154     }
155 
156     constructor() internal {
157         _addModerator(msg.sender);
158     }
159 
160     function isModerator(address account) public view returns (bool) {
161         return _moderators.has(account);
162     }
163 
164     function addModerator(address account) public onlyModerator {
165         _addModerator(account);
166     }
167 
168     function renounceModerator() public {
169         _removeModerator(msg.sender);
170     }    
171 
172     function _addModerator(address account) internal {
173         _moderators.add(account);
174         emit ModeratorAdded(account);
175     }    
176 
177     function _removeModerator(address account) internal {
178         _moderators.remove(account);
179         emit ModeratorRemoved(account);
180     }
181 }
182 
183 // File: contracts/rewards/BatchWhitelister.sol
184 
185 pragma solidity 0.5.4;
186 
187 
188 
189 
190 
191 /**
192  * @notice Enables batching transactions for Rewards whitelisting
193  */
194 contract BatchWhitelister is ModeratorRole, Ownable {
195   event BatchWhitelisted(address indexed from, uint accounts);
196   event BatchUnwhitelisted(address indexed from, uint accounts);
197 
198   IWhitelistable public rewards; // The contract which implements IWhitelistable
199 
200   constructor(IWhitelistable _contract) public {
201       rewards = _contract;
202   }
203 
204   function batchWhitelist(address[] memory accounts) public onlyModerator {
205     bool isModerator = rewards.isModerator(address(this));
206     require(isModerator, 'This contract is not a moderator.');
207 
208     emit BatchWhitelisted(msg.sender, accounts.length);
209     for (uint i = 0; i < accounts.length; i++) {
210       rewards.whitelist(accounts[i]);
211     }
212   }
213 
214   function batchUnwhitelist(address[] memory accounts) public onlyModerator {
215     bool isModerator = rewards.isModerator(address(this));
216     require(isModerator, 'This contract is not a moderator.');
217 
218     emit BatchUnwhitelisted(msg.sender, accounts.length);
219     for (uint i = 0; i < accounts.length; i++) {
220       rewards.unwhitelist(accounts[i]);
221     }
222   }
223 
224   function disconnect() public onlyOwner {
225     rewards.renounceModerator();
226   }
227 }