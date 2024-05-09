1 pragma solidity ^0.4.11;
2 
3 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
4 contract AuthenticationManager {
5    
6     /* Map addresses to admins */
7     mapping (address => bool) adminAddresses;
8 
9     /* Map addresses to account readers */
10     mapping (address => bool) accountReaderAddresses;
11 
12     /* Map addresses to account minters */
13     mapping (address => bool) accountMinterAddresses;
14 
15     /* Details of all admins that have ever existed */
16     address[] adminAudit;
17 
18     /* Details of all account readers that have ever existed */
19     address[] accountReaderAudit;
20 
21     /* Details of all account minters that have ever existed */
22     address[] accountMinterAudit;
23 
24     /* Fired whenever an admin is added to the contract. */
25     event AdminAdded(address addedBy, address admin);
26 
27     /* Fired whenever an admin is removed from the contract. */
28     event AdminRemoved(address removedBy, address admin);
29 
30     /* Fired whenever an account-reader contract is added. */
31     event AccountReaderAdded(address addedBy, address account);
32 
33     /* Fired whenever an account-reader contract is removed. */
34     event AccountReaderRemoved(address removedBy, address account);
35 
36     /* Fired whenever an account-minter contract is added. */
37     event AccountMinterAdded(address addedBy, address account);
38 
39     /* Fired whenever an account-minter contract is removed. */
40     event AccountMinterRemoved(address removedBy, address account);
41 
42     /* When this contract is first setup we use the creator as the first admin */    
43     function AuthenticationManager() {
44         /* Set the first admin to be the person creating the contract */
45         adminAddresses[msg.sender] = true;
46         AdminAdded(0, msg.sender);
47         adminAudit.length++;
48         adminAudit[adminAudit.length - 1] = msg.sender;
49     }
50 
51     /* Gets whether or not the specified address is currently an admin */
52     function isCurrentAdmin(address _address) constant returns (bool) {
53         return adminAddresses[_address];
54     }
55 
56     /* Gets whether or not the specified address has ever been an admin */
57     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
58         for (uint256 i = 0; i < adminAudit.length; i++)
59             if (adminAudit[i] == _address)
60                 return true;
61         return false;
62     }
63 
64     /* Gets whether or not the specified address is currently an account reader */
65     function isCurrentAccountReader(address _address) constant returns (bool) {
66         return accountReaderAddresses[_address];
67     }
68 
69     /* Gets whether or not the specified address has ever been an admin */
70     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
71         for (uint256 i = 0; i < accountReaderAudit.length; i++)
72             if (accountReaderAudit[i] == _address)
73                 return true;
74         return false;
75     }
76 
77     /* Gets whether or not the specified address is currently an account minter */
78     function isCurrentAccountMinter(address _address) constant returns (bool) {
79         return accountMinterAddresses[_address];
80     }
81 
82     /* Gets whether or not the specified address has ever been an admin */
83     function isCurrentOrPastAccountMinter(address _address) constant returns (bool) {
84         for (uint256 i = 0; i < accountMinterAudit.length; i++)
85             if (accountMinterAudit[i] == _address)
86                 return true;
87         return false;
88     }
89 
90     /* Adds a user to our list of admins */
91     function addAdmin(address _address) {
92         /* Ensure we're an admin */
93         if (!isCurrentAdmin(msg.sender))
94             throw;
95 
96         // Fail if this account is already admin
97         if (adminAddresses[_address])
98             throw;
99         
100         // Add the user
101         adminAddresses[_address] = true;
102         AdminAdded(msg.sender, _address);
103         adminAudit.length++;
104         adminAudit[adminAudit.length - 1] = _address;
105 
106     }
107 
108     /* Removes a user from our list of admins but keeps them in the history audit */
109     function removeAdmin(address _address) {
110         /* Ensure we're an admin */
111         if (!isCurrentAdmin(msg.sender))
112             throw;
113 
114         /* Don't allow removal of self */
115         if (_address == msg.sender)
116             throw;
117 
118         // Fail if this account is already non-admin
119         if (!adminAddresses[_address])
120             throw;
121 
122         /* Remove this admin user */
123         adminAddresses[_address] = false;
124         AdminRemoved(msg.sender, _address);
125     }
126 
127     /* Adds a user/contract to our list of account readers */
128     function addAccountReader(address _address) {
129         /* Ensure we're an admin */
130         if (!isCurrentAdmin(msg.sender))
131             throw;
132 
133         // Fail if this account is already in the list
134         if (accountReaderAddresses[_address])
135             throw;
136         
137         // Add the account reader
138         accountReaderAddresses[_address] = true;
139         AccountReaderAdded(msg.sender, _address);
140         accountReaderAudit.length++;
141         accountReaderAudit[accountReaderAudit.length - 1] = _address;
142     }
143 
144     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
145     function removeAccountReader(address _address) {
146         /* Ensure we're an admin */
147         if (!isCurrentAdmin(msg.sender))
148             throw;
149 
150         // Fail if this account is already not in the list
151         if (!accountReaderAddresses[_address])
152             throw;
153 
154         /* Remove this account reader */
155         accountReaderAddresses[_address] = false;
156         AccountReaderRemoved(msg.sender, _address);
157     }
158 
159     /* Add a contract to our list of account minters */
160     function addAccountMinter(address _address) {
161         /* Ensure we're an admin */
162         if (!isCurrentAdmin(msg.sender))
163             throw;
164 
165         // Fail if this account is already in the list
166         if (accountMinterAddresses[_address])
167             throw;
168         
169         // Add the minter
170         accountMinterAddresses[_address] = true;
171         AccountMinterAdded(msg.sender, _address);
172         accountMinterAudit.length++;
173         accountMinterAudit[accountMinterAudit.length - 1] = _address;
174     }
175 
176     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
177     function removeAccountMinter(address _address) {
178         /* Ensure we're an admin */
179         if (!isCurrentAdmin(msg.sender))
180             throw;
181 
182         // Fail if this account is already not in the list
183         if (!accountMinterAddresses[_address])
184             throw;
185 
186         /* Remove this minter account */
187         accountMinterAddresses[_address] = false;
188         AccountMinterRemoved(msg.sender, _address);
189     }
190 }
191 
192 /* The TokenValue Relayer contract is responsible to keep a track of token value that can be audited at a later time. */
193 contract TokenValueRelayer {
194 
195     /* Represents the value of the token at a particular moment in time. */
196     struct TokenValueRepresentation {
197         uint256 value;
198         string currency;
199         uint256 timestamp;
200     }
201 
202     /* An array defining all the token values in history. */
203     TokenValueRepresentation[] public values;
204     
205     /* Defines the admin contract we interface with for credentails. */
206     AuthenticationManager authenticationManager;
207 
208     /* Fired when the token value is updated by an admin. */
209     event TokenValue(uint256 value, string currency, uint256 timestamp);
210 
211     /* This modifier allows a method to only be called by current admins */
212     modifier adminOnly {
213         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
214         _;
215     }
216 
217     /* Create our contract and specify the location of other addresses. */
218     function TokenValueRelayer(address _authenticationManagerAddress) {
219         /* Setup access to our other contracts and validate their versions */
220         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
221     }
222 
223     /* Returns how many token values are present in the history. */
224     function tokenValueCount() constant returns (uint256 _count) {
225         _count = values.length;
226     }
227 
228     /* Defines the current value of the token. */
229     function tokenValuePublish(uint256 _value, string _currency, uint256 _timestamp) adminOnly {
230         values.length++;
231         values[values.length - 1] = TokenValueRepresentation(_value, _currency,_timestamp);
232 
233         /* Audit this */
234         TokenValue(_value, _currency, _timestamp);
235     }
236 }