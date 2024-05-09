1 pragma solidity ^0.4.11;
2 
3 /*******************************************************************************
4  * ERC Token Standard #20 Interface
5  * https://github.com/ethereum/EIPs/issues/20
6  *******************************************************************************/
7 contract ERC20Interface {
8   // Get the total token supply
9   function totalSupply() constant returns (uint256 totalSupply);
10 
11   // Get the account balance of another account with address _owner
12   function balanceOf(address _owner) constant returns (uint256 balance);
13 
14   // Send _value amount of tokens to address _to
15   function transfer(address _to, uint256 _value) returns (bool success);
16 
17   // Send _value amount of tokens from address _from to address _to
18   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
19 
20   // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
21   // If this function is called again it overwrites the current allowance with _value.
22   // this function is required for some DEX functionality.
23   function approve(address _spender, uint256 _value) returns (bool success);
24 
25   // Returns the amount which _spender is still allowed to withdraw from _owner
26   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27 
28   // Triggered when tokens are transferred.
29   event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31   // Triggered whenever approve(address _spender, uint256 _value) is called.
32   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 /*******************************************************************************
36  * AICoin - Smart Contract with token and ballot handling
37  *******************************************************************************/
38 contract AICoin is ERC20Interface {
39 
40   /* ******************************
41    * COIN data / functions
42    * ******************************/
43 
44   /* Token constants */
45   string public constant name = 'AICoin';
46   string public constant symbol = 'XAI';
47   uint8 public constant decimals = 8;
48   string public constant smallestUnit = 'Hofstadter';
49 
50   /* Token internal data */
51   address m_administrator;
52   uint256 m_totalSupply;
53 
54   /* Current balances for each account */
55   mapping(address => uint256) balances;
56 
57   /* Account holder approves the transfer of an amount to another account */
58   mapping(address => mapping (address => uint256)) allowed;
59 
60   /* One-time create function: initialize the supply and set the admin address */
61   function AICoin (uint256 _initialSupply) {
62     m_administrator = msg.sender;
63     m_totalSupply = _initialSupply;
64     balances[msg.sender] = _initialSupply;
65   }
66 
67   /* Get the admin address */
68   function administrator() constant returns (address adminAddress) {
69     return m_administrator;
70   }
71 
72   /* Get the total coin supply */
73   function totalSupply() constant returns (uint256 totalSupply) {
74     return m_totalSupply;
75   }
76 
77   /* Get the balance of a specific account by its address */
78   function balanceOf(address _owner) constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82   /* Transfer an amount from the owner's account to an indicated account */
83   function transfer(address _to, uint256 _amount) returns (bool success) {
84     if (balances[msg.sender] >= _amount
85         && _amount > 0
86         && balances[_to] + _amount > balances[_to]
87         && (! accountHasCurrentVote(msg.sender))) {
88       balances[msg.sender] -= _amount;
89       balances[_to] += _amount;
90       Transfer(msg.sender, _to, _amount);
91       return true;
92     } else {
93       return false;
94     }
95   }
96 
97   /* Send _value amount of tokens from address _from to address _to
98    * The transferFrom method is used for a withdraw workflow, allowing contracts to send
99    * tokens on your behalf, for example to "deposit" to a contract address and/or to charge
100    * fees in sub-currencies; the command should fail unless the _from account has
101    * deliberately authorized the sender of the message via some mechanism; we propose
102    * these standardized APIs for approval:
103    */
104   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
105     if (balances[_from] >= _amount
106         && allowed[_from][msg.sender] >= _amount
107         && _amount > 0
108         && balances[_to] + _amount > balances[_to]
109         && (! accountHasCurrentVote(_from))) {
110       balances[_from] -= _amount;
111       allowed[_from][msg.sender] -= _amount;
112       balances[_to] += _amount;
113       Transfer(_from, _to, _amount);
114       return true;
115     } else {
116       return false;
117     }
118   }
119 
120   /* Pre-authorize an address to withdraw from your account, up to the _value amount.
121    * Doing so (using transferFrom) reduces the remaining authorized amount,
122    * as well as the actual account balance)
123    * Subsequent calls to this function overwrite any existing authorized amount.
124    * Therefore, to cancel an authorization, simply write a zero amount.
125    */
126   function approve(address _spender, uint256 _amount) returns (bool success) {
127     allowed[msg.sender][_spender] = _amount;
128     Approval(msg.sender, _spender, _amount);
129     return true;
130   }
131 
132   /* Get the currently authorized that can be withdrawn by account _spender from account _owner */
133   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134     return allowed[_owner][_spender];
135   }
136 
137   /* ******************************
138    * BALLOT data / functions
139    * ******************************/
140 
141   /* Dev Note: creating a struct that contained a string, uint values and
142    * an array of option structs, etc, would consistently fail.
143    * So the ballot details are held in separate mappings with a common integer
144    * key for each ballot. The IDs are 1-indexed, sequential and contiguous.
145    */
146 
147   /* Basic ballot details: time frame and number of options */
148   struct BallotDetails {
149     uint256 start;
150     uint256 end;
151     uint32 numOptions; // 1-indexed for readability
152     bool sealed;
153   }
154 
155   uint32 public numBallots = 0; // 1-indexed for readability
156   mapping (uint32 => string) public ballotNames;
157   mapping (uint32 => BallotDetails) public ballotDetails;
158   mapping (uint32 => mapping (uint32 => string) ) public ballotOptions;
159 
160   /* Create a new ballot and set the basic details (proposal description, dates)
161    * The ballot still need to have options added and then to be sealed
162    */
163   function adminAddBallot(string _proposal, uint256 _start, uint256 _end) {
164 
165     /* Admin functions must be called by the contract creator. */
166     require(msg.sender == m_administrator);
167 
168     /* Create and store the new ballot objects */
169     numBallots++;
170     uint32 ballotId = numBallots;
171     ballotNames[ballotId] = _proposal;
172     ballotDetails[ballotId] = BallotDetails(_start, _end, 0, false);
173   }
174 
175   /* Create a new ballot and set the basic details (proposal description, dates)
176    * The ballot still need to have options added and then to be sealed
177    */
178   function adminAmendBallot(uint32 _ballotId, string _proposal, uint256 _start, uint256 _end) {
179 
180     /* Admin functions must be called by the contract creator. */
181     require(msg.sender == m_administrator);
182 
183     /* verify that the ballot exists */
184     require(_ballotId > 0 && _ballotId <= numBallots);
185 
186     /* update the ballot object */
187     ballotNames[_ballotId] = _proposal;
188     ballotDetails[_ballotId].start = _start;
189     ballotDetails[_ballotId].end = _end;
190   }
191 
192   /* Add an option to an existing Ballot
193    */
194   function adminAddBallotOption(uint32 _ballotId, string _option) {
195 
196     /* Admin functions must be called by the contract creator. */
197     require(msg.sender == m_administrator);
198 
199     /* verify that the ballot exists */
200     require(_ballotId > 0 && _ballotId <= numBallots);
201 
202     /* cannot change a ballot once it is sealed */
203     if(isBallotSealed(_ballotId)) {
204       revert();
205     }
206 
207     /* store the new ballot option */
208     ballotDetails[_ballotId].numOptions += 1;
209     uint32 optionId = ballotDetails[_ballotId].numOptions;
210     ballotOptions[_ballotId][optionId] = _option;
211   }
212 
213   /* Amend and option in an existing Ballot
214    */
215   function adminEditBallotOption(uint32 _ballotId, uint32 _optionId, string _option) {
216 
217     /* Admin functions must be called by the contract creator. */
218     require(msg.sender == m_administrator);
219 
220     /* verify that the ballot exists */
221     require(_ballotId > 0 && _ballotId <= numBallots);
222 
223     /* cannot change a ballot once it is sealed */
224     if(isBallotSealed(_ballotId)) {
225       revert();
226     }
227 
228     /* validate the ballot option */
229     require(_optionId > 0 && _optionId <= ballotDetails[_ballotId].numOptions);
230 
231     /* update the ballot option */
232     ballotOptions[_ballotId][_optionId] = _option;
233   }
234 
235   /* Seal a ballot - after this the ballot is official and no changes can be made.
236    */
237   function adminSealBallot(uint32 _ballotId) {
238 
239     /* Admin functions must be called by the contract creator. */
240     require(msg.sender == m_administrator);
241 
242     /* verify that the ballot exists */
243     require(_ballotId > 0 && _ballotId <= numBallots);
244 
245     /* cannot change a ballot once it is sealed */
246     if(isBallotSealed(_ballotId)) {
247       revert();
248     }
249 
250     /* set the ballot seal flag */
251     ballotDetails[_ballotId].sealed = true;
252   }
253 
254   /* Function to determine if a ballot is currently in progress, based on its
255    * start and end dates, and that it has been sealed.
256    */
257   function isBallotInProgress(uint32 _ballotId) private constant returns (bool) {
258     return (isBallotSealed(_ballotId)
259             && ballotDetails[_ballotId].start <= now
260             && ballotDetails[_ballotId].end >= now);
261   }
262 
263   /* Function to determine if a ballot has ended, based on its end date */
264   function hasBallotEnded(uint32 _ballotId) private constant returns (bool) {
265     return (ballotDetails[_ballotId].end < now);
266   }
267 
268   /* Function to determine if a ballot has been sealed, which means it has been
269    * authorized by the administrator and can no longer be changed.
270    */
271   function isBallotSealed(uint32 _ballotId) private returns (bool) {
272     return ballotDetails[_ballotId].sealed;
273   }
274 
275   /* ******************************
276    * VOTING data / functions
277    * ******************************/
278 
279   mapping (uint32 => mapping (address => uint256) ) public ballotVoters;
280   mapping (uint32 => mapping (uint32 => uint256) ) public ballotVoteCount;
281 
282   /* function to allow a coin holder add to the vote count of an option in an
283    * active ballot. The votes added equals the balance of the account. Once this is called successfully
284    * the coins cannot be transferred out of the account until the end of the ballot.
285    *
286    * NB: The timing of the start and end of the voting period is determined by
287    * the timestamp of the block in which the transaction is included. As given by
288    * the current Ethereum standard this is *NOT* guaranteed to be accurate to any
289    * given external time source. Therefore, votes should be placed well in advance
290    * of the UTC end time of the Ballot.
291    */
292   function vote(uint32 _ballotId, uint32 _selectedOptionId) {
293 
294     /* verify that the ballot exists */
295     require(_ballotId > 0 && _ballotId <= numBallots);
296 
297     /* Ballot must be in progress in order to vote */
298     require(isBallotInProgress(_ballotId));
299 
300     /* Calculate the balance which which the coin holder has not yet voted, which is the difference between
301      * the current balance for the senders address and the amount they already voted in this ballot.
302      * If the difference is zero, this attempt to vote will fail.
303      */
304     uint256 votableBalance = balanceOf(msg.sender) - ballotVoters[_ballotId][msg.sender];
305     require(votableBalance > 0);
306 
307     /* validate the ballot option */
308     require(_selectedOptionId > 0 && _selectedOptionId <= ballotDetails[_ballotId].numOptions);
309 
310     /* update the vote count and record the voter */
311     ballotVoteCount[_ballotId][_selectedOptionId] += votableBalance;
312     ballotVoters[_ballotId][msg.sender] += votableBalance;
313   }
314 
315   /* function to determine if an address has already voted in a given ballot */
316   function hasAddressVotedInBallot(uint32 _ballotId, address _voter) constant returns (bool hasVoted) {
317     return ballotVoters[_ballotId][_voter] > 0;
318   }
319 
320   /* function to determine if an account has voted in any current ballot */
321   function accountHasCurrentVote(address _voter) constant returns (bool) {
322     for(uint32 id = 1; id <= numBallots; id++) {
323       if (isBallotInProgress(id) && hasAddressVotedInBallot(id, _voter)) {
324         return true;
325       }
326     }
327     return false;
328   }
329 }