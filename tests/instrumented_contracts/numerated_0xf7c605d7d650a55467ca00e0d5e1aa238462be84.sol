1 pragma solidity ^0.5.3;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to transfer control of the contract to a newOwner.
41      * @param newOwner The address to transfer ownership to.
42      */
43     function transferOwnership(address newOwner) public onlyOwner {
44         _transferOwnership(newOwner);
45     }
46 
47     /**
48      * @dev Transfers control of the contract to a newOwner.
49      * @param newOwner The address to transfer ownership to.
50      */
51     function _transferOwnership(address newOwner) internal {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(_owner, newOwner);
54         _owner = newOwner;
55     }
56 }
57 
58 contract Approvable is Ownable {
59     mapping(address => bool) private _approvedAddress;
60 
61 
62     modifier onlyApproved() {
63         require(isApproved());
64         _;
65     }
66 
67     function isApproved() public view returns(bool) {
68         return _approvedAddress[msg.sender] || isOwner();
69     }
70 
71     function approveAddress(address _address) public onlyOwner {
72         _approvedAddress[_address] = true;
73     }
74 
75     function revokeApproval(address _address) public onlyOwner {
76         _approvedAddress[_address] = false;
77     }
78 }
79 
80 contract StoringCreationMeta {
81     uint public creationBlock;
82     uint public creationTime;
83 
84     constructor() internal {
85         creationBlock = block.number;
86         creationTime = block.timestamp;
87     }
88 }
89 
90 contract UserRoles is StoringCreationMeta, Approvable {
91     struct Roles {
92         uint[] list;
93         mapping(uint => uint) position;
94     }
95     mapping(address => Roles) userRoles;
96 
97     event RolesChanged(address indexed user, uint[] roles);
98     // Known roles:
99     // 1    - can create events
100 
101     function setRole(address _user, uint _role) public onlyApproved {
102         _setRole(userRoles[_user], _role);
103         emit RolesChanged(_user, userRoles[_user].list);
104     }
105 
106     function setRoles(address _user, uint[] memory _roles) public onlyApproved {
107         for(uint i = 0; i < _roles.length; ++i) {
108             _setRole(userRoles[_user], _roles[i]);
109         }
110         emit RolesChanged(_user, userRoles[_user].list);
111     }
112 
113     function setRoleForUsers(address[] memory _users, uint _role) public onlyApproved {
114         for(uint i = 0; i < _users.length; ++i) {
115             _setRole(userRoles[_users[i]], _role);
116             emit RolesChanged(_users[i], userRoles[_users[i]].list);
117         }
118     }
119 
120     function _setRole(Roles storage _roles, uint _role) private {
121         if (_roles.position[_role] != 0) {
122             // Already has role
123             return;
124         } else {
125             _roles.list.push(_role);
126             _roles.position[_role] = _roles.list.length;
127         }
128     }
129 
130     function removeRole(address _user, uint _role) public onlyApproved {
131         _removeRole(userRoles[_user], _role);
132         emit RolesChanged(_user, userRoles[_user].list);
133     }
134 
135     function removeRoles(address _user, uint[] memory _roles) public onlyApproved {
136         for(uint i = 0; i < _roles.length; ++i) {
137             _removeRole(userRoles[_user], _roles[i]);
138         }
139         emit RolesChanged(_user, userRoles[_user].list);
140     }
141 
142     function _removeRole(Roles storage _roles, uint _role) private {
143         if (_roles.position[_role] == 0) {
144             // Role not present
145             return;
146         }
147 
148         uint nIndex = _roles.position[_role] - 1;
149         uint lastIndex = _roles.list.length  - 1;
150         uint lastItem = _roles.list[lastIndex];
151 
152         _roles.list[nIndex] = lastItem;
153         _roles.position[lastItem] = nIndex + 1;
154         _roles.position[_role] = 0;
155 
156         _roles.list.pop();
157     }
158 
159     function hasRole(address _user, uint _role) public view returns(bool) {
160         return userRoles[_user].position[_role] != 0;
161     }
162 
163     function hasAnyRole(address _user, uint[] memory _roles) public view returns(bool) {
164         for(uint i = 0; i < _roles.length; ++i) {
165             if(hasRole(_user, _roles[i])) {
166                 return true;
167             }
168         }
169         return false;
170     }
171 
172     function getUserRoles(address _user) public view returns(uint[] memory) {
173         return userRoles[_user].list;
174     }
175 
176     function clearUserRoles(address _user) public onlyApproved {
177         Roles storage _roles = userRoles[_user];
178 
179         for(uint i = 0; i < _roles.list.length; ++i) {
180             _roles.position[_roles.list[i]] = 0;
181         }
182 
183         delete _roles.list;
184     }
185 }