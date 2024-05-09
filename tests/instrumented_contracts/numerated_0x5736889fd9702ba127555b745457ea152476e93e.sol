1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   // function ownerOf(uint256 _tokenId) public view returns (address addr);
12   // function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   // function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   // function transfer(address _to, uint256 _tokenId) public;
16 
17   // event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   // event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 
28 contract DailyEtherToken is ERC721 {
29 
30   /*** EVENTS ***/
31 
32   /// @dev Birth event fired whenever a new token is created
33   event Birth(uint256 tokenId, string name, address owner);
34 
35   /// @dev TokenSold event fired whenever a token is sold
36   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
37 
38   /// @dev Transfer event as defined in ERC721. Ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /*** CONSTANTS ***/
42 
43   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
44   string public constant NAME = "DailyEther"; // solhint-disable-line
45   string public constant SYMBOL = "DailyEtherToken"; // solhint-disable-line
46 
47   uint256 private ticketPrice = 0.2 ether;
48   string private betTitle = "";     // Title of bet
49   uint256 private answerID = 0;     // The correct answer id, set when the bet is closed
50 
51   // A bet can have the following states:
52   // Opened -- Accepting new bets
53   // Locked -- Not accepting new bets, waiting for final results
54   // Closed -- Bet completed, results announced and payout completed for winners
55   bool isLocked = false;
56   bool isClosed = false;
57 
58   /*** STORAGE ***/
59 
60   // Used to implement proper ERC721 implementation
61   mapping (address => uint256) private addressToBetCount;
62 
63   // Holds the number of participants who placed a bet on specific answer
64   mapping (uint256 => uint256) private answerIdToParticipantsCount;
65 
66   // Addresses of the accounts (or contracts) that can execute actions within each roles.
67   address public roleAdminAddress;
68 
69   /*** DATATYPES ***/
70   struct Participant {
71     address user_address;
72     uint256 answer_id;
73   }
74   Participant[] private participants;
75 
76   /*** ACCESS MODIFIERS ***/
77 
78   /// @dev Access modifier for Admin-only
79   modifier onlyAdmin() {
80     require(msg.sender == roleAdminAddress);
81     _;
82   }
83 
84   /*** CONSTRUCTOR ***/
85 
86   function DailyEtherToken() public {
87     roleAdminAddress = msg.sender;
88   }
89 
90   /*** PUBLIC FUNCTIONS ***/
91 
92   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
93   /// @param _to The address to be granted transfer approval. Pass address(0) to
94   ///  clear all approvals.
95   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
96   /// @dev Required for ERC-721 compliance.
97   function approve(
98     address _to,
99     uint256 _tokenId
100   ) public {
101     // Caller must own token.
102     require(false);
103   }
104 
105   /// For querying balance of a particular account
106   /// @param _owner The address for balance query
107   /// @dev Required for ERC-721 compliance.
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return addressToBetCount[_owner];
110   }
111 
112   function implementsERC721() public pure returns (bool) {
113     return true;
114   }
115 
116   /// @dev Required for ERC-721 compliance.
117   function name() public pure returns (string) {
118     return NAME;
119   }
120 
121   function payout(address _to) public onlyAdmin {
122     _payout(_to);
123   }
124 
125 
126   /// @notice Returns all the relevant information about a specific participant.
127   function getParticipant(uint256 _index) public view returns (
128     address participantAddress,
129     uint256 participantAnswerId
130   ) {
131     Participant storage p = participants[_index];
132     participantAddress = p.user_address;
133     participantAnswerId = p.answer_id;
134   }
135 
136 
137   // Called to close the bet. Sets the correct bet answer and sends payouts to
138   // the bet winners
139   function closeBet(uint256 _answerId) public onlyAdmin {
140 
141     // Make sure bet is Locked
142     require(isLocked == true);
143 
144     // Make sure bet was not closed already
145     require(isClosed == false);
146 
147     // Store correct answer id
148     answerID = _answerId;
149 
150     // Calculate total earnings to send winners
151     uint256 totalPrize = uint256(SafeMath.div(SafeMath.mul((ticketPrice * participants.length), 94), 100));
152 
153     // Calculate the prize we need to transfer per winner
154     uint256 paymentPerParticipant = uint256(SafeMath.div(totalPrize, answerIdToParticipantsCount[_answerId]));
155 
156     // Mark contract as closed so we won't close it again
157     isClosed = true;
158 
159     // Transfer the winning amount to each of the winners
160     for(uint i=0; i<participants.length; i++)
161     {
162         if (participants[i].answer_id == _answerId) {
163             if (participants[i].user_address != address(this)) {
164                 participants[i].user_address.transfer(paymentPerParticipant);
165             }
166         }
167     }
168   }
169 
170   // Allows someone to send ether and obtain the token
171   function bet(uint256 _answerId) public payable {
172 
173     // Make sure bet accepts new bets
174     require(isLocked == false);
175 
176     // Answer ID not allowed to be 0, check it is 1 or greater
177     require(_answerId >= 1);
178 
179     // Making sure sent amount is greater than or equal to the sellingPrice
180     require(msg.value >= ticketPrice);
181 
182     // Store new bet
183     Participant memory _p = Participant({
184       user_address: msg.sender,
185       answer_id: _answerId
186     });
187     participants.push(_p);
188 
189     addressToBetCount[msg.sender]++;
190 
191     // Increase the count of participants who placed their bet on this answer
192     answerIdToParticipantsCount[_answerId]++;
193   }
194 
195   // Returns the ticket price for the bet
196   function getTicketPrice() public view returns (uint256 price) {
197     return ticketPrice;
198   }
199 
200   // Returns the bet title
201   function getBetTitle() public view returns (string title) {
202     return betTitle;
203   }
204 
205   /// @dev Assigns a new address to act as the Admin
206   /// @param _newAdmin The address of the new Admin
207   function setAdmin(address _newAdmin) public onlyAdmin {
208     require(_newAdmin != address(0));
209     roleAdminAddress = _newAdmin;
210   }
211 
212   // Inits the bet data
213   function initBet(uint256 _ticketPriceWei, string _betTitle) public onlyAdmin {
214     ticketPrice = _ticketPriceWei;
215     betTitle = _betTitle;
216   }
217 
218   // Called to lock bet, new participants can no longer join
219   function lockBet() public onlyAdmin {
220     isLocked = true;
221   }
222 
223   // Called to lock bet, new participants can no longer join
224   function isBetLocked() public view returns (bool) {
225     return isLocked;
226   }
227 
228   // Called to lock bet, new participants can no longer join
229   function isBetClosed() public view returns (bool) {
230     return isClosed;
231   }
232 
233   /// @dev Required for ERC-721 compliance.
234   function symbol() public pure returns (string) {
235     return SYMBOL;
236   }
237 
238   /// Returns the total of bets in contract
239   function totalSupply() public view returns (uint256 total) {
240     return participants.length;
241   }
242 
243 
244   /*** PRIVATE FUNCTIONS ***/
245 
246   /// For paying out balance on contract
247   function _payout(address _to) private {
248     if (_to == address(0)) {
249       roleAdminAddress.transfer(this.balance);
250     } else {
251       _to.transfer(this.balance);
252     }
253   }
254 
255 }
256 
257 library SafeMath {
258 
259   /**
260   * @dev Multiplies two numbers, throws on overflow.
261   */
262   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263     if (a == 0) {
264       return 0;
265     }
266     uint256 c = a * b;
267     assert(c / a == b);
268     return c;
269   }
270 
271   /**
272   * @dev Integer division of two numbers, truncating the quotient.
273   */
274   function div(uint256 a, uint256 b) internal pure returns (uint256) {
275     // assert(b > 0); // Solidity automatically throws when dividing by 0
276     uint256 c = a / b;
277     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
278     return c;
279   }
280 
281   /**
282   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
283   */
284   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285     assert(b <= a);
286     return a - b;
287   }
288 
289   /**
290   * @dev Adds two numbers, throws on overflow.
291   */
292   function add(uint256 a, uint256 b) internal pure returns (uint256) {
293     uint256 c = a + b;
294     assert(c >= a);
295     return c;
296   }
297 }