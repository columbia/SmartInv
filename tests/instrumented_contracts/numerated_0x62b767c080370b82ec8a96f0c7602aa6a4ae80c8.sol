1 pragma solidity ^0.5.0;
2 
3 
4 library Roles {
5     struct Role {
6         mapping (address => bool) bearer;
7     }
8 
9     
10     function add(Role storage role, address account) internal {
11         require(!has(role, account), "Roles: account already has role");
12         role.bearer[account] = true;
13     }
14 
15     
16     function remove(Role storage role, address account) internal {
17         require(has(role, account), "Roles: account does not have role");
18         role.bearer[account] = false;
19     }
20 
21     
22     function has(Role storage role, address account) internal view returns (bool) {
23         require(account != address(0), "Roles: account is the zero address");
24         return role.bearer[account];
25     }
26 }
27 
28 contract WhitelistAdminRole {
29     using Roles for Roles.Role;
30 
31     event WhitelistAdminAdded(address indexed account);
32     event WhitelistAdminRemoved(address indexed account);
33 
34     Roles.Role private _whitelistAdmins;
35 
36     constructor () internal {
37         _addWhitelistAdmin(msg.sender);
38     }
39 
40     modifier onlyWhitelistAdmin() {
41         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
42         _;
43     }
44 
45     function isWhitelistAdmin(address account) public view returns (bool) {
46         return _whitelistAdmins.has(account);
47     }
48 
49     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
50         _addWhitelistAdmin(account);
51     }
52 
53     function renounceWhitelistAdmin() public {
54         _removeWhitelistAdmin(msg.sender);
55     }
56 
57     function _addWhitelistAdmin(address account) internal {
58         _whitelistAdmins.add(account);
59         emit WhitelistAdminAdded(account);
60     }
61 
62     function _removeWhitelistAdmin(address account) internal {
63         _whitelistAdmins.remove(account);
64         emit WhitelistAdminRemoved(account);
65     }
66 }
67 
68 contract AltiMates is WhitelistAdminRole {
69 
70   struct ATContract {
71     string refNo;
72     string stock;
73     uint256 startDate;
74     uint256 endDate;
75     uint256 spotPrice;
76     uint256 spRate;
77     uint256 koRate;
78     uint256 kiRate;
79   }
80 
81   mapping(address => ATContract) public contracts;
82 
83   constructor() public {
84   }
85 
86   function subscribe(address from, string calldata _refNo, string calldata _stock, uint256 _startDate, uint256 _endDate,
87     uint256 _spotPrice, uint256 _spRate, uint256 _koRate, uint256 _kiRate) external onlyWhitelistAdmin {
88     ATContract memory ctr  = ATContract(_refNo, _stock, _startDate, _endDate, _spotPrice, _spRate, _koRate, _kiRate);
89     contracts[from] = ctr;
90   }
91 }