1 /*
2 Corporation SmartContract.
3 developed by: cryptonomica.net, 2016
4 
5 used sources:
6 https://www.ethereum.org/token // example of the token standart
7 https://github.com/ethereum/EIPs/issues/20 // token standart description
8 https://www.ethereum.org/dao // voting example
9 */
10 
11 /*
12 How to deploy (estimated: 1,641,268 gas):
13 1) For development: use https://ethereum.github.io/browser-solidity/
14 2) For testing on Testnet: Open the default ('Mist') wallet (if you are only testing, go to the menu develop > network > testnet), go to the Contracts tab and then press deploy contract, and on the solidity code box, paste the code above.
15 3) For prodaction, like in 2) but on Main Network.
16 To verify your deployed smartcontract source code for public go to:
17 https://etherscan.io/verifyContract
18 */
19 
20 // 'interface':
21 //  this is expected from another contract,
22 //  if it wants to spend tokens (shares) of behalf of the token owner
23 //  in our contract
24 //  f.e.: a 'multisig' SmartContract for transfering shares from seller
25 //  to buyer
26 contract tokenRecipient {
27     function receiveApproval(address _from,     // sharehoder
28                              uint256 _value,    // number of shares
29                              address _share,    // - will be this contract
30                              bytes _extraData); //
31 }
32 
33 contract Corporation {
34 
35     /* Standard public variables of the token */
36     string public standard = 'Token 0.1';
37     string public name;
38     string public symbol;
39     uint8 public decimals;
40     uint256 public totalSupply;
41 
42     /* ------------------- Corporate Stock Ledger ---------- */
43     // Shares, shareholders, balances ect.
44 
45     // list of all sharehoders (represented by Ethereum accounts)
46     // in this Corporation's history, # is ID
47     address[] public shareholder;
48     // this helps to find address by ID without loop
49     mapping (address => uint256) public shareholderID;
50     // list of adresses, that who currently own at least share
51     // not public, use getCurrentShareholders()
52     address[] activeShareholdersArray;
53     // balances:
54     mapping (address => uint256) public balanceOf;
55     // shares that have to be managed by external contract
56     mapping (address => mapping (address => uint256)) public allowance;
57 
58     /*  --------------- Constructor --------- */
59     // Initializes contract with initial supply tokens to the creator of the contract
60     function Corporation () { // - truffle compiles only no args Constructor
61         uint256 initialSupply = 12000; // shares quantity, constant
62         balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
63         totalSupply = initialSupply;  // Update total supply
64         name = "shares"; //tokenName; // Set the name for display purposes
65         symbol = "sh"; // tokenSymbol; // Set the symbol for display purposes
66         decimals = 0; // Amount of decimals for display purposes
67 
68         // -- start corporate stock ledger
69         shareholderID[this] = shareholder.push(this)-1; // # 0
70         shareholderID[msg.sender] = shareholder.push(msg.sender)-1; // #1
71         activeShareholdersArray.push(msg.sender); // add to active shareholders
72     }
73 
74     /* --------------- Shares management ------ */
75 
76     // This generates a public event on the blockchain that will notify clients. In 'Mist' SmartContract page enable 'Watch contract events'
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     function getCurrentShareholders() returns (address[]){
80         delete activeShareholdersArray;
81         for (uint256 i=0; i < shareholder.length; i++){
82             if (balanceOf[shareholder[i]] > 0){
83                 activeShareholdersArray.push(shareholder[i]);
84             }
85             } return activeShareholdersArray;
86         }
87 
88     /*  -- can be used to transfer shares to new contract
89     together with getCurrentShareholders() */
90     function getBalanceByAdress(address _address) returns (uint256) {
91         return balanceOf[_address];
92     }
93 
94     function getMyShareholderID() returns (uint256) {
95         return shareholderID[msg.sender];
96     }
97 
98     function getShareholderAdressByID(uint256 _id) returns (address){
99         return shareholder[_id];
100     }
101 
102     function getMyShares() returns (uint256) {
103         return balanceOf[msg.sender];
104     }
105 
106 
107     /* ---- Transfer shares to another adress ----
108     (shareholder's address calls this)
109     */
110     function transfer(address _to, uint256 _value) {
111         // check arguments:
112         if (_value < 1) throw;
113         if (this == _to) throw; // do not send shares to contract itself;
114         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
115 
116         // make transaction
117         balanceOf[msg.sender] -= _value; // Subtract from the sender
118         balanceOf[_to] += _value;       // Add the same to the recipient
119 
120         // if new address, add it to shareholders history (stock ledger):
121         if (shareholderID[_to] == 0){ // ----------- check if works
122             shareholderID[_to] = shareholder.push(_to)-1;
123         }
124 
125         // Notify anyone listening that this transfer took place
126         Transfer(msg.sender, _to, _value);
127     }
128 
129     /* Allow another contract to spend some shares in your behalf
130     (shareholder calls this) */
131     function approveAndCall(address _spender, // another contract's adress
132                             uint256 _value, // number of shares
133                             bytes _extraData) // data for another contract
134     returns (bool success) {
135         // msg.sender - account owner who gives allowance
136         // _spender   - address of another contract
137         // it writes in "allowance" that this owner allows another
138         // contract (_spender) to spend thi amont (_value) of shares
139         // in his behalf
140         allowance[msg.sender][_spender] = _value;
141         // 'spender' is another contract that implements code
142         //  prescribed in 'shareRecipient' above
143         tokenRecipient spender = tokenRecipient(_spender);
144         // this contract calls 'receiveApproval' function
145         // of another contract to send information about
146         // allowance
147         spender.receiveApproval(msg.sender, // shares owner
148                                 _value,     // number of shares
149                                 this,       // this contract's adress
150                                 _extraData);// data from shares owner
151         return true;
152     }
153 
154     /* this function can be called from another contract, after it
155     have allowance to transfer shares in behalf of sharehoder  */
156     function transferFrom(address _from,
157                           address _to,
158                           uint256 _value)
159     returns (bool success) {
160 
161         // Check arguments:
162         // should one share or more
163         if (_value < 1) throw;
164         // do not send shares to this contract itself;
165         if (this == _to) throw;
166         // Check if the sender has enough
167         if (balanceOf[_from] < _value) throw;
168 
169         // Check allowance
170         if (_value > allowance[_from][msg.sender]) throw;
171 
172         // if transfer to new address -- add him to ledger
173         if (shareholderID[_to] == 0){
174             shareholderID[_to] = shareholder.push(_to)-1; // push function returns the new length
175         }
176 
177         // Subtract from the sender
178         balanceOf[_from] -= _value;
179         // Add the same to the recipient
180         balanceOf[_to] += _value;
181 
182         // Change allowances correspondingly
183         allowance[_from][msg.sender] -= _value;
184         // Notify anyone listening that this transfer took place
185         Transfer(_from, _to, _value);
186 
187         return true;
188     }
189 
190     /* This unnamed function is called whenever someone tries to send ether to it */
191     function () {
192         throw;     // Prevents accidental sending of ether
193     }
194 
195     /*  --------- Voting  --------------  */
196     // we only count 'yes' votes, not voting 'yes'
197     // considered as voting 'no' (as stated in Bylaws)
198 
199     // each proposal should contain it's text
200     // index of text in this array is a proposal ID
201     string[] public proposalText;
202     // proposalID => (shareholder => "if already voted for this proposal")
203     mapping (uint256 => mapping (address => bool)) voted;
204     // proposalID => addresses voted 'yes'
205     // exact number of votes according to shares will be counted
206     // after deadline
207     mapping (uint256 => address[]) public votes;
208     // proposalID => deadline
209     mapping (uint256 => uint256) public deadline;
210     // proposalID => final 'yes' votes
211     mapping (uint256 => uint256) public results;
212     // proposals of every shareholder
213     mapping (address => uint256[]) public proposalsByShareholder;
214 
215 
216     event ProposalAdded(uint256 proposalID,
217                         address initiator,
218                         string description,
219                         uint256 deadline);
220 
221     event VotingFinished(uint256 proposalID, uint256 votes);
222 
223     function makeNewProposal(string _proposalDescription,
224                              uint256 _debatingPeriodInMinutes)
225     returns (uint256){
226         // only shareholder with one or more shares can make a proposal
227         // !!!! can be more then one share required
228         if (balanceOf[msg.sender] < 1) throw;
229 
230         uint256 id = proposalText.push(_proposalDescription)-1;
231         deadline[id] = now + _debatingPeriodInMinutes * 1 minutes;
232 
233         // add to proposals of this shareholder:
234         proposalsByShareholder[msg.sender].push(id);
235 
236         // initiator always votes 'yes'
237         votes[id].push(msg.sender);
238         voted[id][msg.sender] = true;
239 
240         ProposalAdded(id, msg.sender, _proposalDescription, deadline[id]);
241 
242         return id; // returns proposal id
243     }
244 
245     function getMyProposals() returns (uint256[]){
246         return proposalsByShareholder[msg.sender];
247     }
248 
249     function voteForProposal(uint256 _proposalID) returns (string) {
250 
251         // if no shares currently owned - no right to vote
252         if (balanceOf[msg.sender] < 1) return "no shares, vote not accepted";
253 
254         // if already voted - throw, else voting can be spammed
255         if (voted[_proposalID][msg.sender]){
256             return "already voted, vote not accepted";
257         }
258 
259         // no votes after deadline
260         if (now > deadline[_proposalID] ){
261             return "vote not accepted after deadline";
262         }
263 
264         // add to list of voted 'yes'
265         votes[_proposalID].push(msg.sender);
266         voted[_proposalID][msg.sender] = true;
267         return "vote accepted";
268     }
269 
270     // to count votes this transaction should be started manually
271     // from _any_ Ethereum address after deadline
272     function countVotes(uint256 _proposalID) returns (uint256){
273 
274         // if not after deadline - throw
275         if (now < deadline[_proposalID]) throw;
276 
277         // if already counted return result;
278         if (results[_proposalID] > 0) return results[_proposalID];
279 
280         // else should count results and store in public variable
281         uint256 result = 0;
282         for (uint256 i = 0; i < votes[_proposalID].length; i++){
283 
284             address voter = votes[_proposalID][i];
285             result = result + balanceOf[voter];
286         }
287 
288         // Log and notify anyone listening that this voting finished
289         // with 'result' - number of 'yes' votes
290         VotingFinished(_proposalID, result);
291 
292         return result;
293     }
294 
295 }