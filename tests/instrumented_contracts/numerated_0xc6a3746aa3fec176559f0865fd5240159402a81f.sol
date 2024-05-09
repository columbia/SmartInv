1 pragma solidity ^0.4.11;
2 
3 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
4 contract AuthenticationManager {
5     /* Map addresses to admins */
6     mapping (address => bool) adminAddresses;
7 
8     /* Map addresses to account readers */
9     mapping (address => bool) accountReaderAddresses;
10 
11     /* Details of all admins that have ever existed */
12     address[] adminAudit;
13 
14     /* Details of all account readers that have ever existed */
15     address[] accountReaderAudit;
16 
17     /* Fired whenever an admin is added to the contract. */
18     event AdminAdded(address addedBy, address admin);
19 
20     /* Fired whenever an admin is removed from the contract. */
21     event AdminRemoved(address removedBy, address admin);
22 
23     /* Fired whenever an account-reader contract is added. */
24     event AccountReaderAdded(address addedBy, address account);
25 
26     /* Fired whenever an account-reader contract is removed. */
27     event AccountReaderRemoved(address removedBy, address account);
28 
29     /* When this contract is first setup we use the creator as the first admin */    
30     function AuthenticationManager() {
31         /* Set the first admin to be the person creating the contract */
32         adminAddresses[msg.sender] = true;
33         AdminAdded(0, msg.sender);
34         adminAudit.length++;
35         adminAudit[adminAudit.length - 1] = msg.sender;
36     }
37 
38     /* Gets the contract version for validation */
39     function contractVersion() constant returns(uint256) {
40         // Admin contract identifies as 100YYYYMMDDHHMM
41         return 100201707171503;
42     }
43 
44     /* Gets whether or not the specified address is currently an admin */
45     function isCurrentAdmin(address _address) constant returns (bool) {
46         return adminAddresses[_address];
47     }
48 
49     /* Gets whether or not the specified address has ever been an admin */
50     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
51         for (uint256 i = 0; i < adminAudit.length; i++)
52             if (adminAudit[i] == _address)
53                 return true;
54         return false;
55     }
56 
57     /* Gets whether or not the specified address is currently an account reader */
58     function isCurrentAccountReader(address _address) constant returns (bool) {
59         return accountReaderAddresses[_address];
60     }
61 
62     /* Gets whether or not the specified address has ever been an admin */
63     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
64         for (uint256 i = 0; i < accountReaderAudit.length; i++)
65             if (accountReaderAudit[i] == _address)
66                 return true;
67         return false;
68     }
69 
70     /* Adds a user to our list of admins */
71     function addAdmin(address _address) {
72         /* Ensure we're an admin */
73         if (!isCurrentAdmin(msg.sender))
74             throw;
75 
76         // Fail if this account is already admin
77         if (adminAddresses[_address])
78             throw;
79         
80         // Add the user
81         adminAddresses[_address] = true;
82         AdminAdded(msg.sender, _address);
83         adminAudit.length++;
84         adminAudit[adminAudit.length - 1] = _address;
85     }
86 
87     /* Removes a user from our list of admins but keeps them in the history audit */
88     function removeAdmin(address _address) {
89         /* Ensure we're an admin */
90         if (!isCurrentAdmin(msg.sender))
91             throw;
92 
93         /* Don't allow removal of self */
94         if (_address == msg.sender)
95             throw;
96 
97         // Fail if this account is already non-admin
98         if (!adminAddresses[_address])
99             throw;
100 
101         /* Remove this admin user */
102         adminAddresses[_address] = false;
103         AdminRemoved(msg.sender, _address);
104     }
105 
106     /* Adds a user/contract to our list of account readers */
107     function addAccountReader(address _address) {
108         /* Ensure we're an admin */
109         if (!isCurrentAdmin(msg.sender))
110             throw;
111 
112         // Fail if this account is already in the list
113         if (accountReaderAddresses[_address])
114             throw;
115         
116         // Add the user
117         accountReaderAddresses[_address] = true;
118         AccountReaderAdded(msg.sender, _address);
119         accountReaderAudit.length++;
120         accountReaderAudit[adminAudit.length - 1] = _address;
121     }
122 
123     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
124     function removeAccountReader(address _address) {
125         /* Ensure we're an admin */
126         if (!isCurrentAdmin(msg.sender))
127             throw;
128 
129         // Fail if this account is already not in the list
130         if (!accountReaderAddresses[_address])
131             throw;
132 
133         /* Remove this admin user */
134         accountReaderAddresses[_address] = false;
135         AccountReaderRemoved(msg.sender, _address);
136     }
137 }