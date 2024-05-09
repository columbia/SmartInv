1 /**
2  * Invictus Capital - Address Whitelist
3  * https://invictuscapital.com
4  * MIT License - https://github.com/invictuscapital/smartcontracts/
5  * Uses code from the OpenZeppelin project
6  */
7 
8  
9 // File: contracts/openzeppelin-solidity/contracts/ownership/Ownable.sol
10 
11 pragma solidity ^0.5.6;
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25      * account.
26      */
27     constructor () internal {
28         _owner = msg.sender;
29         emit OwnershipTransferred(address(0), _owner);
30     }
31 
32     /**
33      * @return the address of the owner.
34      */
35     function owner() public view returns (address) {
36         return _owner;
37     }
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(isOwner());
44         _;
45     }
46 
47     /**
48      * @return true if `msg.sender` is the owner of the contract.
49      */
50     function isOwner() public view returns (bool) {
51         return msg.sender == _owner;
52     }
53 
54     /**
55      * @dev Allows the current owner to relinquish control of the contract.
56      * @notice Renouncing to ownership will leave the contract without an owner.
57      * It will not be possible to call the functions with the `onlyOwner`
58      * modifier anymore.
59      */
60     function renounceOwnership() public onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      */
77     function _transferOwnership(address newOwner) internal {
78         require(newOwner != address(0));
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 }
83 
84 // File: contracts/openzeppelin-solidity/contracts/access/Roles.sol
85 
86 pragma solidity ^0.5.6;
87 
88 /**
89  * @title Roles
90  * @dev Library for managing addresses assigned to a Role.
91  */
92 library Roles {
93     struct Role {
94         mapping (address => bool) bearer;
95     }
96 
97     /**
98      * @dev give an account access to this role
99      */
100     function add(Role storage role, address account) internal {
101         require(account != address(0));
102         require(!has(role, account));
103 
104         role.bearer[account] = true;
105     }
106 
107     /**
108      * @dev remove an account's access to this role
109      */
110     function remove(Role storage role, address account) internal {
111         require(account != address(0));
112         require(has(role, account));
113 
114         role.bearer[account] = false;
115     }
116 
117     /**
118      * @dev check if an account has this role
119      * @return bool
120      */
121     function has(Role storage role, address account) internal view returns (bool) {
122         require(account != address(0));
123         return role.bearer[account];
124     }
125 }
126 
127 // File: contracts/openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
128 
129 pragma solidity ^0.5.6;
130 
131 /**
132  * @title WhitelistAdminRole
133  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
134  */
135 contract WhitelistAdminRole {
136     using Roles for Roles.Role;
137 
138     event WhitelistAdminAdded(address indexed account);
139     event WhitelistAdminRemoved(address indexed account);
140 
141     Roles.Role private _whitelistAdmins;
142 
143     constructor () internal {
144         _addWhitelistAdmin(msg.sender);
145     }
146 
147     modifier onlyWhitelistAdmin() {
148         require(isWhitelistAdmin(msg.sender));
149         _;
150     }
151 
152     function isWhitelistAdmin(address account) public view returns (bool) {
153         return _whitelistAdmins.has(account);
154     }
155 
156     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
157         _addWhitelistAdmin(account);
158     }
159 
160     function renounceWhitelistAdmin() public {
161         _removeWhitelistAdmin(msg.sender);
162     }
163 
164     function _addWhitelistAdmin(address account) internal {
165         _whitelistAdmins.add(account);
166         emit WhitelistAdminAdded(account);
167     }
168 
169     function _removeWhitelistAdmin(address account) internal {
170         _whitelistAdmins.remove(account);
171         emit WhitelistAdminRemoved(account);
172     }
173 }
174 
175 // File: contracts/openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
176 
177 pragma solidity ^0.5.6;
178 
179 /**
180  * @title WhitelistedRole
181  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
182  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
183  * it), and not Whitelisteds themselves.
184  */
185 contract WhitelistedRole is WhitelistAdminRole {
186     using Roles for Roles.Role;
187 
188     event WhitelistedAdded(address indexed account);
189     event WhitelistedRemoved(address indexed account);
190 
191     Roles.Role private _whitelisteds;
192 
193     modifier onlyWhitelisted() {
194         require(isWhitelisted(msg.sender));
195         _;
196     }
197 
198     function isWhitelisted(address account) public view returns (bool) {
199         return _whitelisteds.has(account);
200     }
201 
202     function addWhitelisted(address account) public onlyWhitelistAdmin {
203         _addWhitelisted(account);
204     }
205 
206     function removeWhitelisted(address account) public onlyWhitelistAdmin {
207         _removeWhitelisted(account);
208     }
209 
210     function renounceWhitelisted() public {
211         _removeWhitelisted(msg.sender);
212     }
213 
214     function _addWhitelisted(address account) internal {
215         _whitelisteds.add(account);
216         emit WhitelistedAdded(account);
217     }
218 
219     function _removeWhitelisted(address account) internal {
220         _whitelisteds.remove(account);
221         emit WhitelistedRemoved(account);
222     }
223 }
224 
225 // File: contracts/InvictusWhitelist.sol
226 
227 pragma solidity ^0.5.6;
228 
229 /**
230  * Manages whitelisted addresses.
231  *
232  */
233 contract InvictusWhitelist is Ownable, WhitelistedRole {
234     constructor ()
235         WhitelistedRole() public {
236     }
237 
238     /// @dev override to support legacy name
239     function verifyParticipant(address participant) public onlyWhitelistAdmin {
240         if (!isWhitelisted(participant)) {
241             addWhitelisted(participant);
242         }
243     }
244 
245     /// Allow the owner to remove a whitelistAdmin
246     function removeWhitelistAdmin(address account) public onlyOwner {
247         require(account != msg.sender, "Use renounceWhitelistAdmin");
248         _removeWhitelistAdmin(account);
249     }
250 }