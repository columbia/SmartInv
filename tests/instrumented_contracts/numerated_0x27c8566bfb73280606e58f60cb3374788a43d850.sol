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
138 
139 /* The transparency relayer contract is responsible for keeping an immutable ledger of account balances that can be audited at a later time .*/
140 contract TransparencyRelayer {
141     /* Represents what SIFT administration report the fund as being worth at a snapshot moment in time. */
142     struct FundValueRepresentation {
143         uint256 usdValue;
144         uint256 etherEquivalent;
145         uint256 suppliedTimestamp;
146         uint256 blockTimestamp;
147     }
148 
149     /* Represents a published balance of a particular account at a moment in time. */
150     struct AccountBalanceRepresentation {
151         string accountType; /* Bitcoin, USD, etc. */
152         string accountIssuer; /* Kraken, Bank of America, etc. */
153         uint256 balance; /* Rounded to appropriate for balance - i.e. full USD or full BTC */
154         string accountReference; /* Could be crypto address, bank account number, etc. */
155         string validationUrl; /* Some validation URL - i.e. base64 encoded notary */
156         uint256 suppliedTimestamp;
157         uint256 blockTimestamp;
158     }
159 
160     /* An array defining all the fund values as supplied by SIFT over the time of the contract. */
161     FundValueRepresentation[] public fundValues;
162     
163     /* An array defining the history of account balances over time. */
164     AccountBalanceRepresentation[] public accountBalances;
165 
166     /* Defines the admin contract we interface with for credentails. */
167     AuthenticationManager authenticationManager;
168 
169     /* Fired when the fund value is updated by an administrator. */
170     event FundValue(uint256 usdValue, uint256 etherEquivalent, uint256 suppliedTimestamp, uint256 blockTimestamp);
171 
172     /* Fired when an account balance is being supplied in some confirmed form for future validation on the blockchain. */
173     event AccountBalance(string accountType, string accountIssuer, uint256 balance, string accountReference, string validationUrl, uint256 timestamp, uint256 blockTimestamp);
174 
175     /* This modifier allows a method to only be called by current admins */
176     modifier adminOnly {
177         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
178         _;
179     }
180 
181     /* Create our contract and specify the location of other addresses */
182     function TransparencyRelayer(address _authenticationManagerAddress) {
183         /* Setup access to our other contracts and validate their versions */
184         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
185         if (authenticationManager.contractVersion() != 100201707171503)
186             throw;
187     }
188 
189     /* Gets the contract version for validation */
190     function contractVersion() constant returns(uint256) {
191         /* Transparency contract identifies as 200YYYYMMDDHHMM */
192         return 200201707071127;
193     }
194 
195     /* Returns how many fund values are present in the market. */
196     function fundValueCount() constant returns (uint256 _count) {
197         _count = fundValues.length;
198     }
199 
200     /* Returns how account balances are present in the market. */
201     function accountBalanceCount() constant returns (uint256 _count) {
202         _count = accountBalances.length;
203     }
204 
205     /* Defines the current value of the funds assets in USD and ETHER */
206     function fundValuePublish(uint256 _usdTotalFund, uint256 _etherTotalFund, uint256 _definedTimestamp) adminOnly {
207         /* Store values */
208         fundValues.length++;
209         fundValues[fundValues.length - 1] = FundValueRepresentation(_usdTotalFund, _etherTotalFund, _definedTimestamp, now);
210 
211         /* Audit this */
212         FundValue(_usdTotalFund, _etherTotalFund, _definedTimestamp, now);
213     }
214 
215     function accountBalancePublish(string _accountType, string _accountIssuer, uint256 _balance, string _accountReference, string _validationUrl, uint256 _timestamp) adminOnly {
216         /* Store values */
217         accountBalances.length++;
218         accountBalances[accountBalances.length - 1] = AccountBalanceRepresentation(_accountType, _accountIssuer, _balance, _accountReference, _validationUrl, _timestamp, now);
219 
220         /* Audit this */
221         AccountBalance(_accountType, _accountIssuer, _balance, _accountReference, _validationUrl, _timestamp, now);
222     }
223 }