1 pragma solidity ^0.4.18;
2 
3 /// @title ERC20 interface
4 contract ERC20 {
5     function balanceOf(address guy) public view returns (uint);
6     function transfer(address dst, uint wad) public returns (bool);
7 }
8 
9 /// @title Manages access privileges.
10 contract AccessControl {
11     
12     event accessGranted(address user, uint8 access);
13     
14     // The addresses of the accounts (or contracts) that can execute actions within each roles.
15     mapping(address => mapping(uint8 => bool)) accessRights;
16 
17     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
18     bool public paused = false;
19 
20     /// @dev Grants admin (1) access to deployer of the contract
21     constructor() public {
22         accessRights[msg.sender][1] = true;
23         emit accessGranted(msg.sender, 1);
24     }
25 
26     /// @dev Provides access to a determined transaction
27     /// @param _user - user that will be granted the access right
28     /// @param _transaction - transaction that will be granted to user
29     function grantAccess(address _user, uint8 _transaction) public canAccess(1) {
30         require(_user != address(0));
31         accessRights[_user][_transaction] = true;
32         emit accessGranted(_user, _transaction);
33     }
34 
35     /// @dev Revokes access to a determined transaction
36     /// @param _user - user that will have the access revoked
37     /// @param _transaction - transaction that will be revoked
38     function revokeAccess(address _user, uint8 _transaction) public canAccess(1) {
39         require(_user != address(0));
40         accessRights[_user][_transaction] = false;
41     }
42 
43     /// @dev Check if user has access to a determined transaction
44     /// @param _user - user
45     /// @param _transaction - transaction
46     function hasAccess(address _user, uint8 _transaction) public view returns (bool) {
47         require(_user != address(0));
48         return accessRights[_user][_transaction];
49     }
50 
51     /// @dev Access modifier
52     /// @param _transaction - transaction
53     modifier canAccess(uint8 _transaction) {
54         require(accessRights[msg.sender][_transaction]);
55         _;
56     }
57 
58     /// @dev Drains all Eth
59     function withdrawBalance() external canAccess(2) {
60         msg.sender.transfer(address(this).balance);
61     }
62 
63     /// @dev Drains any ERC20 token accidentally sent to contract
64     function withdrawTokens(address tokenContract) external canAccess(2) {
65         ERC20 tc = ERC20(tokenContract);
66         tc.transfer(msg.sender, tc.balanceOf(this));
67     }
68 
69     /// @dev Modifier to allow actions only when the contract IS NOT paused
70     modifier whenNotPaused() {
71         require(!paused);
72         _;
73     }
74 
75     /// @dev Modifier to allow actions only when the contract IS paused
76     modifier whenPaused {
77         require(paused);
78         _;
79     }
80 
81     /// @dev Called by any "C-level" role to pause the contract. Used only when
82     ///  a bug or exploit is detected and we need to limit damage.
83     function pause() public canAccess(1) whenNotPaused {
84         paused = true;
85     }
86 
87     /// @dev Unpauses the smart contract.
88     function unpause() public canAccess(1) whenPaused {
89         paused = false;
90     }
91 }
92 
93 
94 /// @title Contract BizancioCertificate, prints the certificates
95 contract BizancioCertificate is AccessControl {
96 
97     struct Certificate {
98         string name;
99         string email;
100         string course;
101         string dates;
102         uint16 courseHours;
103         bool valid;
104     }
105     
106     mapping (bytes32 => Certificate) public certificates;
107     event logPrintedCertificate(bytes32 contractAddress, string _name, string email, string _course, string _dates, uint16 _hours);
108 
109     function printCertificate (string _name, string _email, string _course, uint16 _hours, string _dates) public canAccess(3) whenNotPaused returns (bytes32 _certificateAddress) {
110 
111         // creates certificate smart contract
112         bytes32 certificateAddress = keccak256(block.number, now, msg.data);
113 
114         // create certificate data
115         certificates[certificateAddress] = Certificate(_name, _email, _course, _dates, _hours, true);
116         
117         // creates the event, to be used to query all the certificates
118         emit logPrintedCertificate(certificateAddress, _name, _email, _course, _dates, _hours);
119 
120         return certificateAddress;
121     }
122     
123     // @dev Invalidates a deployed certificate
124     function invalidateCertificate(bytes32 _certificateAddress) external canAccess(3) {
125         certificates[_certificateAddress].valid = false;
126     }
127 
128 }