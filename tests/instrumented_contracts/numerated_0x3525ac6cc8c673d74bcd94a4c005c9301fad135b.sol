1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract RBAC {
58   using Roles for Roles.Role;
59 
60   mapping (string => Roles.Role) private roles;
61 
62   event RoleAdded(address addr, string roleName);
63   event RoleRemoved(address addr, string roleName);
64 
65   /**
66    * @dev reverts if addr does not have role
67    * @param addr address
68    * @param roleName the name of the role
69    * // reverts
70    */
71   function checkRole(address addr, string roleName)
72     view
73     public
74   {
75     roles[roleName].check(addr);
76   }
77 
78   /**
79    * @dev determine if addr has role
80    * @param addr address
81    * @param roleName the name of the role
82    * @return bool
83    */
84   function hasRole(address addr, string roleName)
85     view
86     public
87     returns (bool)
88   {
89     return roles[roleName].has(addr);
90   }
91 
92   /**
93    * @dev add a role to an address
94    * @param addr address
95    * @param roleName the name of the role
96    */
97   function addRole(address addr, string roleName)
98     internal
99   {
100     roles[roleName].add(addr);
101     emit RoleAdded(addr, roleName);
102   }
103 
104   /**
105    * @dev remove a role from an address
106    * @param addr address
107    * @param roleName the name of the role
108    */
109   function removeRole(address addr, string roleName)
110     internal
111   {
112     roles[roleName].remove(addr);
113     emit RoleRemoved(addr, roleName);
114   }
115 
116   /**
117    * @dev modifier to scope access to a single role (uses msg.sender as addr)
118    * @param roleName the name of the role
119    * // reverts
120    */
121   modifier onlyRole(string roleName)
122   {
123     checkRole(msg.sender, roleName);
124     _;
125   }
126 
127   /**
128    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
129    * @param roleNames the names of the roles to scope access to
130    * // reverts
131    *
132    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
133    *  see: https://github.com/ethereum/solidity/issues/2467
134    */
135   // modifier onlyRoles(string[] roleNames) {
136   //     bool hasAnyRole = false;
137   //     for (uint8 i = 0; i < roleNames.length; i++) {
138   //         if (hasRole(msg.sender, roleNames[i])) {
139   //             hasAnyRole = true;
140   //             break;
141   //         }
142   //     }
143 
144   //     require(hasAnyRole);
145 
146   //     _;
147   // }
148 }
149 
150 library Roles {
151   struct Role {
152     mapping (address => bool) bearer;
153   }
154 
155   /**
156    * @dev give an address access to this role
157    */
158   function add(Role storage role, address addr)
159     internal
160   {
161     role.bearer[addr] = true;
162   }
163 
164   /**
165    * @dev remove an address' access to this role
166    */
167   function remove(Role storage role, address addr)
168     internal
169   {
170     role.bearer[addr] = false;
171   }
172 
173   /**
174    * @dev check if an address has this role
175    * // reverts
176    */
177   function check(Role storage role, address addr)
178     view
179     internal
180   {
181     require(has(role, addr));
182   }
183 
184   /**
185    * @dev check if an address has this role
186    * @return bool
187    */
188   function has(Role storage role, address addr)
189     view
190     internal
191     returns (bool)
192   {
193     return role.bearer[addr];
194   }
195 }
196 
197 contract Staff is Ownable, RBAC {
198 
199 	string public constant ROLE_STAFF = "staff";
200 
201 	function addStaff(address _staff) public onlyOwner {
202 		addRole(_staff, ROLE_STAFF);
203 	}
204 
205 	function removeStaff(address _staff) public onlyOwner {
206 		removeRole(_staff, ROLE_STAFF);
207 	}
208 
209 	function isStaff(address _staff) view public returns (bool) {
210 		return hasRole(_staff, ROLE_STAFF);
211 	}
212 }