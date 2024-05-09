1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
45 
46 pragma solidity ^0.5.0;
47 
48 
49 /**
50  * @title WhitelistAdminRole
51  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
52  */
53 contract WhitelistAdminRole {
54     using Roles for Roles.Role;
55 
56     event WhitelistAdminAdded(address indexed account);
57     event WhitelistAdminRemoved(address indexed account);
58 
59     Roles.Role private _whitelistAdmins;
60 
61     constructor () internal {
62         _addWhitelistAdmin(msg.sender);
63     }
64 
65     modifier onlyWhitelistAdmin() {
66         require(isWhitelistAdmin(msg.sender));
67         _;
68     }
69 
70     function isWhitelistAdmin(address account) public view returns (bool) {
71         return _whitelistAdmins.has(account);
72     }
73 
74     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
75         _addWhitelistAdmin(account);
76     }
77 
78     function renounceWhitelistAdmin() public {
79         _removeWhitelistAdmin(msg.sender);
80     }
81 
82     function _addWhitelistAdmin(address account) internal {
83         _whitelistAdmins.add(account);
84         emit WhitelistAdminAdded(account);
85     }
86 
87     function _removeWhitelistAdmin(address account) internal {
88         _whitelistAdmins.remove(account);
89         emit WhitelistAdminRemoved(account);
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
94 
95 pragma solidity ^0.5.0;
96 
97 
98 
99 /**
100  * @title WhitelistedRole
101  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
102  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
103  * it), and not Whitelisteds themselves.
104  */
105 contract WhitelistedRole is WhitelistAdminRole {
106     using Roles for Roles.Role;
107 
108     event WhitelistedAdded(address indexed account);
109     event WhitelistedRemoved(address indexed account);
110 
111     Roles.Role private _whitelisteds;
112 
113     modifier onlyWhitelisted() {
114         require(isWhitelisted(msg.sender));
115         _;
116     }
117 
118     function isWhitelisted(address account) public view returns (bool) {
119         return _whitelisteds.has(account);
120     }
121 
122     function addWhitelisted(address account) public onlyWhitelistAdmin {
123         _addWhitelisted(account);
124     }
125 
126     function removeWhitelisted(address account) public onlyWhitelistAdmin {
127         _removeWhitelisted(account);
128     }
129 
130     function renounceWhitelisted() public {
131         _removeWhitelisted(msg.sender);
132     }
133 
134     function _addWhitelisted(address account) internal {
135         _whitelisteds.add(account);
136         emit WhitelistedAdded(account);
137     }
138 
139     function _removeWhitelisted(address account) internal {
140         _whitelisteds.remove(account);
141         emit WhitelistedRemoved(account);
142     }
143 }
144 
145 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
146 
147 pragma solidity ^0.5.0;
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     /**
160      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161      * account.
162      */
163     constructor () internal {
164         _owner = msg.sender;
165         emit OwnershipTransferred(address(0), _owner);
166     }
167 
168     /**
169      * @return the address of the owner.
170      */
171     function owner() public view returns (address) {
172         return _owner;
173     }
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyOwner() {
179         require(isOwner());
180         _;
181     }
182 
183     /**
184      * @return true if `msg.sender` is the owner of the contract.
185      */
186     function isOwner() public view returns (bool) {
187         return msg.sender == _owner;
188     }
189 
190     /**
191      * @dev Allows the current owner to relinquish control of the contract.
192      * @notice Renouncing to ownership will leave the contract without an owner.
193      * It will not be possible to call the functions with the `onlyOwner`
194      * modifier anymore.
195      */
196     function renounceOwnership() public onlyOwner {
197         emit OwnershipTransferred(_owner, address(0));
198         _owner = address(0);
199     }
200 
201     /**
202      * @dev Allows the current owner to transfer control of the contract to a newOwner.
203      * @param newOwner The address to transfer ownership to.
204      */
205     function transferOwnership(address newOwner) public onlyOwner {
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers control of the contract to a newOwner.
211      * @param newOwner The address to transfer ownership to.
212      */
213     function _transferOwnership(address newOwner) internal {
214         require(newOwner != address(0));
215         emit OwnershipTransferred(_owner, newOwner);
216         _owner = newOwner;
217     }
218 }
219 
220 // File: contracts/whitelist/IWhitelist.sol
221 
222 pragma solidity ^0.5.0;
223 
224 contract IWhitelist {
225     function isWhitelisted(address account) public view returns (bool);
226 }
227 
228 // File: contracts/whitelist/Whitelist.sol
229 
230 pragma solidity ^0.5.0;
231 
232 
233 
234 
235 
236 contract Whitelist is IWhitelist, WhitelistedRole, Ownable {
237     // Only allow the contract owner to add whitelist admins.
238     function addWhitelistAdmin(address account) public onlyOwner {
239         _addWhitelistAdmin(account);
240     }
241 
242     // Only allow the contract owner to remove whitelist admins.
243     function removeWhitelistAdmin(address account) public onlyOwner {
244         _removeWhitelistAdmin(account);
245     }
246 
247     function batchAddWhitelisted(address[] calldata accounts) external onlyWhitelistAdmin {
248         for (uint i = 0; i < accounts.length; ++i) {
249             _addWhitelisted(accounts[i]);
250         }
251     }
252 }