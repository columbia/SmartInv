1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
32 contract AuthenticationManager {
33     /* Map addresses to admins */
34     mapping (address => bool) adminAddresses;
35 
36     /* Map addresses to account readers */
37     mapping (address => bool) accountReaderAddresses;
38 
39     /* Details of all admins that have ever existed */
40     address[] adminAudit;
41 
42     /* Details of all account readers that have ever existed */
43     address[] accountReaderAudit;
44 
45     /* Fired whenever an admin is added to the contract. */
46     event AdminAdded(address addedBy, address admin);
47 
48     /* Fired whenever an admin is removed from the contract. */
49     event AdminRemoved(address removedBy, address admin);
50 
51     /* Fired whenever an account-reader contract is added. */
52     event AccountReaderAdded(address addedBy, address account);
53 
54     /* Fired whenever an account-reader contract is removed. */
55     event AccountReaderRemoved(address removedBy, address account);
56 
57     /* When this contract is first setup we use the creator as the first admin */    
58     function AuthenticationManager() {
59         /* Set the first admin to be the person creating the contract */
60         adminAddresses[msg.sender] = true;
61         AdminAdded(0, msg.sender);
62         adminAudit.length++;
63         adminAudit[adminAudit.length - 1] = msg.sender;
64     }
65 
66     /* Gets the contract version for validation */
67     function contractVersion() constant returns(uint256) {
68         // Admin contract identifies as 100YYYYMMDDHHMM
69         return 100201707171503;
70     }
71 
72     /* Gets whether or not the specified address is currently an admin */
73     function isCurrentAdmin(address _address) constant returns (bool) {
74         return adminAddresses[_address];
75     }
76 
77     /* Gets whether or not the specified address has ever been an admin */
78     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
79         for (uint256 i = 0; i < adminAudit.length; i++)
80             if (adminAudit[i] == _address)
81                 return true;
82         return false;
83     }
84 
85     /* Gets whether or not the specified address is currently an account reader */
86     function isCurrentAccountReader(address _address) constant returns (bool) {
87         return accountReaderAddresses[_address];
88     }
89 
90     /* Gets whether or not the specified address has ever been an admin */
91     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
92         for (uint256 i = 0; i < accountReaderAudit.length; i++)
93             if (accountReaderAudit[i] == _address)
94                 return true;
95         return false;
96     }
97 
98     /* Adds a user to our list of admins */
99     function addAdmin(address _address) {
100         /* Ensure we're an admin */
101         if (!isCurrentAdmin(msg.sender))
102             throw;
103 
104         // Fail if this account is already admin
105         if (adminAddresses[_address])
106             throw;
107         
108         // Add the user
109         adminAddresses[_address] = true;
110         AdminAdded(msg.sender, _address);
111         adminAudit.length++;
112         adminAudit[adminAudit.length - 1] = _address;
113     }
114 
115     /* Removes a user from our list of admins but keeps them in the history audit */
116     function removeAdmin(address _address) {
117         /* Ensure we're an admin */
118         if (!isCurrentAdmin(msg.sender))
119             throw;
120 
121         /* Don't allow removal of self */
122         if (_address == msg.sender)
123             throw;
124 
125         // Fail if this account is already non-admin
126         if (!adminAddresses[_address])
127             throw;
128 
129         /* Remove this admin user */
130         adminAddresses[_address] = false;
131         AdminRemoved(msg.sender, _address);
132     }
133 
134     /* Adds a user/contract to our list of account readers */
135     function addAccountReader(address _address) {
136         /* Ensure we're an admin */
137         if (!isCurrentAdmin(msg.sender))
138             throw;
139 
140         // Fail if this account is already in the list
141         if (accountReaderAddresses[_address])
142             throw;
143         
144         // Add the user
145         accountReaderAddresses[_address] = true;
146         AccountReaderAdded(msg.sender, _address);
147         accountReaderAudit.length++;
148         accountReaderAudit[adminAudit.length - 1] = _address;
149     }
150 
151     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
152     function removeAccountReader(address _address) {
153         /* Ensure we're an admin */
154         if (!isCurrentAdmin(msg.sender))
155             throw;
156 
157         // Fail if this account is already not in the list
158         if (!accountReaderAddresses[_address])
159             throw;
160 
161         /* Remove this admin user */
162         accountReaderAddresses[_address] = false;
163         AccountReaderRemoved(msg.sender, _address);
164     }
165 }
166 contract VotingBase {
167     using SafeMath for uint256;
168 
169     /* Map all our our balances for issued tokens */
170     mapping (address => uint256) public voteCount;
171 
172     /* List of all token holders */
173     address[] public voterAddresses;
174 
175     /* Defines the admin contract we interface with for credentails. */
176     AuthenticationManager internal authenticationManager;
177 
178     /* Unix epoch voting starts at */
179     uint256 public voteStartTime;
180 
181     /* Unix epoch voting ends at */
182     uint256 public voteEndTime;
183 
184     /* This modifier allows a method to only be called by current admins */
185     modifier adminOnly {
186         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
187         _;
188     }
189 
190     function setVoterCount(uint256 _count) adminOnly {
191         // Forbid after voting has started
192         if (now >= voteStartTime)
193             throw;
194 
195         /* Clear existing voter count */
196         for (uint256 i = 0; i < voterAddresses.length; i++) {
197             address voter = voterAddresses[i];
198             voteCount[voter] = 0;
199         }
200 
201         /* Set the count accordingly */
202         voterAddresses.length = _count;
203     }
204 
205     function setVoter(uint256 _position, address _voter, uint256 _voteCount) adminOnly {
206         // Forbid after voting has started
207         if (now >= voteStartTime)
208             throw;
209 
210         if (_position >= voterAddresses.length)
211             throw;
212             
213         voterAddresses[_position] = _voter;
214         voteCount[_voter] = _voteCount;
215     }
216 }
217 
218 contract VoteSvp001 is VotingBase {
219     using SafeMath for uint256;
220 
221     /* Votes for SVP001-01.  0 = not votes, 1 = Yes, 2 = No */
222      mapping (address => uint256) vote01;
223      uint256 public vote01YesCount;
224      uint256 public vote01NoCount;
225 
226     /* Votes for SVP001-02.  0 = not votes, 1 = Yes, 2 = No */
227      mapping (address => uint256) vote02;
228      uint256 public vote02YesCount;
229      uint256 public vote02NoCount;
230 
231     /* Create our contract with references to other contracts as required. */
232     function VoteSvp001(address _authenticationManagerAddress, uint256 _voteStartTime, uint256 _voteEndTime) {
233         /* Setup access to our other contracts and validate their versions */
234         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
235         if (authenticationManager.contractVersion() != 100201707171503)
236             throw;
237 
238         /* Store start/end times */
239         if (_voteStartTime >= _voteEndTime)
240             throw;
241         voteStartTime = _voteStartTime;
242         voteEndTime = _voteEndTime;
243     }
244 
245      function voteSvp01(bool vote) {
246         // Forbid outside of voting period
247         if (now < voteStartTime || now > voteEndTime)
248             throw;
249 
250          /* Ensure they have voting rights first */
251          uint256 voteWeight = voteCount[msg.sender];
252          if (voteWeight == 0)
253             throw;
254         
255         /* Set their vote */
256         uint256 existingVote = vote01[msg.sender];
257         uint256 newVote = vote ? 1 : 2;
258         if (newVote == existingVote)
259             /* No change so just return */
260             return;
261         vote01[msg.sender] = newVote;
262 
263         /* If they had voted previous first decrement previous vote count */
264         if (existingVote == 1)
265             vote01YesCount -= voteWeight;
266         else if (existingVote == 2)
267             vote01NoCount -= voteWeight;
268         if (vote)
269             vote01YesCount += voteWeight;
270         else
271             vote01NoCount += voteWeight;
272      }
273 
274      function voteSvp02(bool vote) {
275         // Forbid outside of voting period
276         if (now < voteStartTime || now > voteEndTime)
277             throw;
278 
279          /* Ensure they have voting rights first */
280          uint256 voteWeight = voteCount[msg.sender];
281          if (voteWeight == 0)
282             throw;
283         
284         /* Set their vote */
285         uint256 existingVote = vote02[msg.sender];
286         uint256 newVote = vote ? 1 : 2;
287         if (newVote == existingVote)
288             /* No change so just return */
289             return;
290         vote02[msg.sender] = newVote;
291 
292         /* If they had voted previous first decrement previous vote count */
293         if (existingVote == 1)
294             vote02YesCount -= voteWeight;
295         else if (existingVote == 2)
296             vote02NoCount -= voteWeight;
297         if (vote)
298             vote02YesCount += voteWeight;
299         else
300             vote02NoCount += voteWeight;
301      }
302 }