1 pragma solidity 0.5.4;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 contract Ownable {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     constructor () internal {
52         _owner = msg.sender;
53         emit OwnershipTransferred(address(0), _owner);
54     }
55 
56     /**
57      * @return the address of the owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(isOwner());
68         _;
69     }
70 
71     /**
72      * @return true if `msg.sender` is the owner of the contract.
73      */
74     function isOwner() public view returns (bool) {
75         return msg.sender == _owner;
76     }
77 
78     /**
79      * @dev Allows the current owner to relinquish control of the contract.
80      * @notice Renouncing to ownership will leave the contract without an owner.
81      * It will not be possible to call the functions with the `onlyOwner`
82      * modifier anymore.
83      */
84     function renounceOwnership() public onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers control of the contract to a newOwner.
99      * @param newOwner The address to transfer ownership to.
100      */
101     function _transferOwnership(address newOwner) internal {
102         require(newOwner != address(0));
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 contract RBAC {
109   using Roles for Roles.Role;
110 
111   mapping (string => Roles.Role) private roles;
112 
113   event RoleAdded(address indexed operator, string role);
114   event RoleRemoved(address indexed operator, string role);
115 
116   /**
117    * @dev reverts if addr does not have role
118    * @param _operator address
119    * @param _role the name of the role
120    * // reverts
121    */
122   function checkRole(address _operator, string memory _role)
123     public
124     view
125   {
126     require(roles[_role].has(_operator), "_operator does not have _role");
127   }
128 
129   /**
130    * @dev determine if addr has role
131    * @param _operator address
132    * @param _role the name of the role
133    * @return bool
134    */
135   function hasRole(address _operator, string memory _role)
136     public
137     view
138     returns (bool)
139   {
140     return roles[_role].has(_operator);
141   }
142 
143   /**
144    * @dev add a role to an address
145    * @param _operator address
146    * @param _role the name of the role
147    */
148   function addRole(address _operator, string memory _role)
149     internal
150   {
151     roles[_role].add(_operator);
152     emit RoleAdded(_operator, _role);
153   }
154 
155   /**
156    * @dev remove a role from an address
157    * @param _operator address
158    * @param _role the name of the role
159    */
160   function removeRole(address _operator, string memory _role)
161     internal
162   {
163     roles[_role].remove(_operator);
164     emit RoleRemoved(_operator, _role);
165   }
166 
167   /**
168    * @dev modifier to scope access to a single role (uses msg.sender as addr)
169    * @param _role the name of the role
170    * // reverts
171    */
172   modifier onlyRole(string memory _role)
173   {
174     checkRole(msg.sender, _role);
175     _;
176   }
177 }
178 
179 contract Curators is Ownable, RBAC {
180   function grantPermission(address _operator, string memory _permission) public onlyOwner {
181     addRole(_operator, _permission);
182   }
183 
184   function revokePermission(address _operator, string memory _permission) public onlyOwner {
185     removeRole(_operator, _permission);
186   }
187 
188   function grantPermissionBatch(address[] memory _operators, string memory _permission) public onlyOwner {
189     for (uint256 i = 0; i < _operators.length; i++) {
190       addRole(_operators[i], _permission);
191     }
192   }
193 
194   function revokePermissionBatch(address[] memory _operators, string memory _permission) public onlyOwner {
195     for (uint256 i = 0; i < _operators.length; i++) {
196       removeRole(_operators[i], _permission);
197     }
198   }
199 }