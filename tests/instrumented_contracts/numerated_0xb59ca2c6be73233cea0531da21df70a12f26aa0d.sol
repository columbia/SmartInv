1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Abstract contract where privileged minting managed by governance
57  */
58 contract MintableTokenStub {
59   address public minter;
60 
61   event Mint(address indexed to, uint256 amount);
62 
63   /**
64    * Constructor function
65    */
66   constructor (
67     address _minter
68   ) public {
69     minter = _minter;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the minter.
74    */
75   modifier onlyMinter() {
76     require(msg.sender == minter);
77     _;
78   }
79 
80   function mint(address _to, uint256 _amount)
81   public
82   onlyMinter
83   returns (bool)
84   {
85     emit Mint(_to, _amount);
86     return true;
87   }
88 
89 }
90 
91 
92 /**
93  * @title Congress contract
94  * @dev The Congress contract allows to execute certain actions (token minting in this case) via majority of votes.
95  * In contrast to traditional Ownable pattern, Congress protects the managed contract (token) against unfair behaviour
96  * of minority (for example, a single founder having one of the project keys has no power to mint the token until
97  * other(s) vote for the operation). Majority formula is voters/2+1. The voters list is formed dynamically through the
98  * voting. Voters can be added if current majority trusts new party. The party can be removed from the voters if it has
99  * been compromised (majority executes untrust operation on it to do this).
100  */
101 contract Congress {
102   using SafeMath for uint256;
103   // the number of active voters
104   uint public voters;
105 
106   // given address is the voter or not
107   mapping(address => bool) public voter;
108 
109   // Each proposal is stored in mapping by its hash (hash of mint arguments)
110   mapping(bytes32 => MintProposal) public mintProposal;
111 
112   // Defines the level of other voters' trust for given address. If majority of current voters
113   // trusts the new member - it becomes the voter
114   mapping(address => TrustRecord) public trustRegistry;
115 
116   // The governed token under Congress's control. Congress has the minter privileges on it.
117   MintableTokenStub public token;
118 
119   // Event on initial token configuration
120   event TokenSet(address voter, address token);
121 
122   // Proposal lifecycle events
123   event MintProposalAdded(
124     bytes32 proposalHash,
125     address to,
126     uint amount,
127     string batchCode
128   );
129 
130   event MintProposalVoted(
131     bytes32 proposalHash,
132     address voter,
133     uint numberOfVotes
134   );
135 
136   event MintProposalExecuted(
137     bytes32 proposalHash,
138     address to,
139     uint amount,
140     string batchCode
141   );
142 
143   // Events emitted on trust claims
144   event TrustSet(address issuer, address subject);
145   event TrustUnset(address issuer, address subject);
146 
147   // Events on adding-deleting voters
148   event VoteGranted(address voter);
149   event VoteRevoked(address voter);
150 
151   // Stores the state of the proposal: executed or not (able to execute only once), number of Votes and
152   // the mapping of voters and their boolean vote. true if voted.
153   struct MintProposal {
154     bool executed;
155     uint numberOfVotes;
156     mapping(address => bool) voted;
157   }
158 
159   // Stores the trust counter and the addresses who trusted the given voter(candidate)
160   struct TrustRecord {
161     uint256 totalTrust;
162     mapping(address => bool) trustedBy;
163   }
164 
165 
166   // Modifier that allows only Voters to vote
167   modifier onlyVoters {
168     require(voter[msg.sender]);
169     _;
170   }
171 
172   /**
173    * Constructor function
174    */
175   constructor () public {
176     voter[msg.sender] = true;
177     voters = 1;
178   }
179 
180   /**
181    * @dev Determine does the given number of votes make majority of voters.
182    * @return true if given number is majority
183    */
184   function isMajority(uint256 votes) public view returns (bool) {
185     return (votes >= voters.div(2).add(1));
186   }
187 
188   /**
189    * @dev Determine how many voters trust given address
190    * @param subject The address of trustee
191    * @return the number of trusted votes
192    */
193   function getTotalTrust(address subject) public view returns (uint256) {
194     return (trustRegistry[subject].totalTrust);
195   }
196 
197   /**
198    * @dev Set the trust claim (msg.sender trusts subject)
199    * @param _subject The trusted address
200    */
201   function trust(address _subject) public onlyVoters {
202     require(msg.sender != _subject);
203     require(token != MintableTokenStub(0));
204     if (!trustRegistry[_subject].trustedBy[msg.sender]) {
205       trustRegistry[_subject].trustedBy[msg.sender] = true;
206       trustRegistry[_subject].totalTrust = trustRegistry[_subject].totalTrust.add(1);
207       emit TrustSet(msg.sender, _subject);
208       if (!voter[_subject] && isMajority(trustRegistry[_subject].totalTrust)) {
209         voter[_subject] = true;
210         voters = voters.add(1);
211         emit VoteGranted(_subject);
212       }
213       return;
214     }
215     revert();
216   }
217 
218   /**
219    * @dev Unset the trust claim (msg.sender now reclaims trust from subject)
220    * @param _subject The address of trustee to revoke trust
221    */
222   function untrust(address _subject) public onlyVoters {
223     require(token != MintableTokenStub(0));
224     if (trustRegistry[_subject].trustedBy[msg.sender]) {
225       trustRegistry[_subject].trustedBy[msg.sender] = false;
226       trustRegistry[_subject].totalTrust = trustRegistry[_subject].totalTrust.sub(1);
227       emit TrustUnset(msg.sender, _subject);
228       if (voter[_subject] && !isMajority(trustRegistry[_subject].totalTrust)) {
229         voter[_subject] = false;
230         // ToDo SafeMath
231         voters = voters.sub(1);
232         emit VoteRevoked(_subject);
233       }
234       return;
235     }
236     revert();
237   }
238 
239   /**
240    * @dev Token and its governance should be locked to each other. Congress should be set as minter in token
241    * @param _token The address of governed token
242    */
243   function setToken(
244     MintableTokenStub _token
245   )
246   public
247   onlyVoters
248   {
249     require(_token != MintableTokenStub(0));
250     require(token == MintableTokenStub(0));
251     token = _token;
252     emit TokenSet(msg.sender, token);
253   }
254 
255   /**
256   * @dev Proxy function to vote and mint tokens
257   * @param to The address that will receive the minted tokens.
258   * @param amount The amount of tokens to mint.
259   * @param batchCode The detailed information on a batch.
260   * @return A boolean that indicates if the operation was successful.
261   */
262   function mint(
263     address to,
264     uint256 amount,
265     string batchCode
266   )
267   public
268   onlyVoters
269   returns (bool)
270   {
271     bytes32 proposalHash = keccak256(abi.encodePacked(to, amount, batchCode));
272     assert(!mintProposal[proposalHash].executed);
273     if (!mintProposal[proposalHash].voted[msg.sender]) {
274       if (mintProposal[proposalHash].numberOfVotes == 0) {
275         emit MintProposalAdded(proposalHash, to, amount, batchCode);
276       }
277       mintProposal[proposalHash].numberOfVotes = mintProposal[proposalHash].numberOfVotes.add(1);
278       mintProposal[proposalHash].voted[msg.sender] = true;
279       emit MintProposalVoted(proposalHash, msg.sender, mintProposal[proposalHash].numberOfVotes);
280     }
281     if (isMajority(mintProposal[proposalHash].numberOfVotes)) {
282       mintProposal[proposalHash].executed = true;
283       token.mint(to, amount);
284       emit MintProposalExecuted(proposalHash, to, amount, batchCode);
285     }
286     return (true);
287   }
288 }