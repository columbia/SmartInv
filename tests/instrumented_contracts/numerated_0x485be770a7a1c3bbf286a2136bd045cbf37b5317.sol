1 // File: contracts\ownership\Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be applied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 /**
80  * @title Roles
81  * @dev Library for managing addresses assigned to a Role.
82  */
83 library Roles {
84     struct Role {
85         mapping (address => bool) bearer;
86     }
87 
88     /**
89      * @dev Give an account access to this role.
90      */
91     function add(Role storage role, address account) internal {
92         require(!has(role, account), "Roles: account already has role");
93         role.bearer[account] = true;
94     }
95 
96     /**
97      * @dev Remove an account's access to this role.
98      */
99     function remove(Role storage role, address account) internal {
100         require(has(role, account), "Roles: account does not have role");
101         role.bearer[account] = false;
102     }
103 
104     /**
105      * @dev Check if an account has this role.
106      * @return bool
107      */
108     function has(Role storage role, address account) internal view returns (bool) {
109         require(account != address(0), "Roles: account is the zero address");
110         return role.bearer[account];
111     }
112 }
113 
114 contract IssuerRole is Ownable {
115     using Roles for Roles.Role;
116 
117     event IssuerAdded(address indexed account);
118     event IssuerRemoved(address indexed account);
119 
120     Roles.Role private _issuers;
121 
122     constructor () internal {
123         _addIssuer(msg.sender);
124     }
125 
126     modifier onlyIssuer() {
127         require(isIssuer(msg.sender), "IssuerRole: caller does not have the issuer role");
128         _;
129     }
130 
131     function isIssuer(address account) public view returns (bool) {
132         return _issuers.has(account);
133     }
134 
135     function addIssuer(address account) public onlyOwner {
136         _addIssuer(account);
137     }
138 
139     function removeIssuer(address account) public onlyOwner {
140         _removeIssuer(account);
141     }
142 
143     function renounceIssuer() public {
144         _removeIssuer(msg.sender);
145     }
146 
147     function _addIssuer(address account) internal {
148         _issuers.add(account);
149         emit IssuerAdded(account);
150     }
151 
152     function _removeIssuer(address account) internal {
153         _issuers.remove(account);
154         emit IssuerRemoved(account);
155     }
156 }
157 
158 contract PostCert is Ownable, IssuerRole {
159     event Posted(bytes32 hash);
160     // Need state
161     event CertState(bytes32 indexed certHash, uint state);
162 
163     function Post(bytes32 hash, uint state) public onlyIssuer {
164         // TODO
165         emit Posted(hash);
166         emit CertState(hash,state);
167     }
168 
169     function setState(bytes32 hash, uint state) public onlyIssuer {
170         emit CertState(hash,state);
171     }
172 }