1 pragma solidity 0.5.1;
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
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 
39 /**
40  * @title WhitelistAdminRole
41  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
42  */
43 contract WhitelistAdminRole {
44     using Roles for Roles.Role;
45 
46     event WhitelistAdminAdded(address indexed account);
47     event WhitelistAdminRemoved(address indexed account);
48 
49     Roles.Role private _whitelistAdmins;
50 
51     constructor () internal {
52         _addWhitelistAdmin(msg.sender);
53     }
54 
55     modifier onlyWhitelistAdmin() {
56         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
57         _;
58     }
59 
60     function isWhitelistAdmin(address account) public view returns (bool) {
61         return _whitelistAdmins.has(account);
62     }
63 
64     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
65         _addWhitelistAdmin(account);
66     }
67 
68     function renounceWhitelistAdmin() public {
69         _removeWhitelistAdmin(msg.sender);
70     }
71 
72     function _addWhitelistAdmin(address account) internal {
73         _whitelistAdmins.add(account);
74         emit WhitelistAdminAdded(account);
75     }
76 
77     function _removeWhitelistAdmin(address account) internal {
78         _whitelistAdmins.remove(account);
79         emit WhitelistAdminRemoved(account);
80     }
81 }
82 
83 
84 /**
85  * @title IpfsHashRecord
86  * @dev Record IPFS hash to Ethereum contract by emitting log.
87  */
88 contract IpfsHashRecord is WhitelistAdminRole {
89 
90   // eventSig is the first 4 bytes of the Keccak256 hash of event name
91   // auction_bidding: 0x636fe49e
92   // auction_receipt: 0x4997644b
93   // bancor_trading: 0x285a30e1
94   event Recorded (bytes4 indexed eventSig, uint256 indexed createdAt, bytes32 ipfsHash);
95 
96   /**
97    * @dev Write ipfsHash as log
98    */
99   function writeHash(bytes4 _eventSig, bytes32 _ipfsHash) public onlyWhitelistAdmin {
100     emit Recorded(_eventSig, uint256(now), _ipfsHash);
101   }
102 
103   /**
104    * @dev Add admin
105    */
106   function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
107     super.addWhitelistAdmin(account);
108   }
109 
110   /**
111    * @dev Renounce admin
112    */
113   function renounceWhitelistAdmin() public {
114     super.renounceWhitelistAdmin();
115   }
116 
117   /**
118    * @dev Check whether address is admin or not
119    */
120   function isWhitelistAdmin(address account) public view returns (bool) {
121     return super.isWhitelistAdmin(account);
122   }
123 }