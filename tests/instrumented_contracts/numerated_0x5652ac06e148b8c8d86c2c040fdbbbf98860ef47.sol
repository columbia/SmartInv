1 pragma solidity ^0.4.13;
2 
3 contract DBC {
4 
5     // MODIFIERS
6 
7     modifier pre_cond(bool condition) {
8         require(condition);
9         _;
10     }
11 
12     modifier post_cond(bool condition) {
13         _;
14         assert(condition);
15     }
16 
17     modifier invariant(bool condition) {
18         require(condition);
19         _;
20         assert(condition);
21     }
22 }
23 
24 contract Competition is DBC {
25 
26     // TYPES
27 
28     struct Hopeful { // Someone who wants to succeed or who seems likely to win
29         address fund; // Address of the Melon fund
30         address manager; // Address of the fund manager, as used in the ipfs-frontend
31         address registrant; // Manager (== owner) of above Melon fund
32         bool hasSigned; // Whether initial requirements passed and Hopeful signed Terms and Conditions; Does not mean Hopeful is competing yet
33         address buyinAsset; // Asset (ERC20 Token) spent to take part in competition
34         address payoutAsset; // Asset (usually Melon Token) to be received as prize
35         uint buyinQuantity; // Quantity of buyinAsset spent
36         uint payoutQuantity; // Quantity of payoutAsset received as prize
37         address payoutAddress; // Address to payout in main chain
38         bool isCompeting; // Whether outside oracle verified remaining requirements; If yes Hopeful is taking part in a competition
39         bool isDisqualified; // Whether participant is disqualified
40         uint finalSharePrice; // Performance of Melon fund at competition endTime; Can be changed for any other comparison metric
41         uint finalCompetitionRank; // Rank of Hopeful at end of competition; Calculate by logic as set in terms and conditions
42     }
43 
44     struct HopefulId {
45       uint id; // Actual Hopeful Id
46       bool exists; // Used to check if the mapping exists
47     }
48 
49     // FIELDS
50 
51     // Constant fields
52     // Competition terms and conditions as displayed on https://ipfs.io/ipfs/QmQ7DqjpxmTDbaxcH5qwv8QmGvJY7rhb8UV2QRfCEFBp8V
53     // IPFS hash encoded using http://lenschulwitz.com/base58
54     bytes32 public constant TERMS_AND_CONDITIONS = 0x1A46B45CC849E26BB3159298C3C218EF300D015ED3E23495E77F0E529CE9F69E;
55     uint public MELON_BASE_UNIT = 10 ** 18;
56     // Constructor fields
57     address public oracle; // Information e.g. from Kovan can be passed to contract from this address
58     uint public startTime; // Competition start time in seconds (Temporarily Set)
59     uint public endTime; // Competition end time in seconds
60     uint public maxbuyinQuantity; // Limit amount of deposit to participate in competition
61     uint public maxHopefulsNumber; // Limit number of participate in competition
62     uint public prizeMoneyAsset; // Equivalent to payoutAsset
63     uint public prizeMoneyQuantity; // Total prize money pool
64     address public MELON_ASSET; // Adresss of Melon asset contract
65     ERC20Interface public MELON_CONTRACT; // Melon as ERC20 contract
66     Certifier public CERTIFIER; // Parity KYC verification contract
67     // Methods fields
68     Hopeful[] public hopefuls; // List of all hopefuls, can be externally accessed
69     mapping (address => address) public registeredFundToRegistrants; // For fund address indexed accessing of registrant addresses
70     mapping(address => HopefulId) public registrantToHopefulIds; // For registrant address indexed accessing of hopeful ids
71 
72     //EVENTS
73 
74     event Register(uint withId, address fund, address manager);
75 
76     // PRE, POST, INVARIANT CONDITIONS
77 
78     /// @dev Proofs that terms and conditions have been read and understood
79     /// @param byManager Address of the fund manager, as used in the ipfs-frontend
80     /// @param v ellipitc curve parameter v
81     /// @param r ellipitc curve parameter r
82     /// @param s ellipitc curve parameter s
83     /// @return Whether or not terms and conditions have been read and understood
84     function termsAndConditionsAreSigned(address byManager, uint8 v, bytes32 r, bytes32 s) view returns (bool) {
85         return ecrecover(
86             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
87             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
88             //  it will return rsv (same as geth; where v is [27, 28]).
89             // Note that if you are using ecrecover, v will be either "00" or "01".
90             //  As a result, in order to use this value, you will have to parse it to an
91             //  integer and then add 27. This will result in either a 27 or a 28.
92             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
93             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
94             v,
95             r,
96             s
97         ) == byManager; // Has sender signed TERMS_AND_CONDITIONS
98     }
99 
100     /// @return Whether message sender is oracle or not
101     function isOracle() view returns (bool) { return msg.sender == oracle; }
102 
103     /// @dev Whether message sender is KYC verified through CERTIFIER
104     /// @param x Address to be checked for KYC verification
105     function isKYCVerified(address x) view returns (bool) { return CERTIFIER.certified(x); }
106 
107     // CONSTANT METHODS
108 
109     function getMelonAsset() view returns (address) { return MELON_ASSET; }
110 
111     /// @return Get HopefulId from registrant address
112     function getHopefulId(address x) view returns (uint) { return registrantToHopefulIds[x].id; }
113 
114     /**
115     @notice Returns an array of fund addresses and an associated array of whether competing and whether disqualified
116     @return {
117       "fundAddrs": "Array of addresses of Melon Funds",
118       "fundManagers": "Array of addresses of Melon fund managers, as used in the ipfs-frontend",
119       "areCompeting": "Array of boolean of whether or not fund is competing"
120       "areDisqualified": "Array of boolean of whether or not fund is disqualified"
121     }
122     */
123     function getCompetitionStatusOfHopefuls()
124         view
125         returns(
126             address[] fundAddrs,
127             address[] fundManagers,
128             bool[] areCompeting,
129             bool[] areDisqualified
130         )
131     {
132         for (uint i = 0; i <= hopefuls.length - 1; i++) {
133             fundAddrs[i] = hopefuls[i].fund;
134             fundManagers[i] = hopefuls[i].manager;
135             areCompeting[i] = hopefuls[i].isCompeting;
136             areDisqualified[i] = hopefuls[i].isDisqualified;
137         }
138         return (fundAddrs, fundManagers, areCompeting, areDisqualified);
139     }
140 
141     // NON-CONSTANT METHODS
142 
143     function Competition(
144         address ofMelonAsset,
145         address ofOracle,
146         address ofCertifier,
147         uint ofStartTime,
148         uint ofMaxbuyinQuantity,
149         uint ofMaxHopefulsNumber
150     ) {
151         MELON_ASSET = ofMelonAsset;
152         MELON_CONTRACT = ERC20Interface(MELON_ASSET);
153         oracle = ofOracle;
154         CERTIFIER = Certifier(ofCertifier);
155         startTime = ofStartTime;
156         endTime = startTime + 2 weeks;
157         maxbuyinQuantity = ofMaxbuyinQuantity;
158         maxHopefulsNumber = ofMaxHopefulsNumber;
159     }
160 
161     /// @notice Register to take part in the competition
162     /// @param fund Address of the Melon fund
163     /// @param buyinAsset Asset (ERC20 Token) spent to take part in competition
164     /// @param payoutAsset Asset (usually Melon Token) to be received as prize
165     /// @param buyinQuantity Quantity of buyinAsset spent
166     /// @param v ellipitc curve parameter v
167     /// @param r ellipitc curve parameter r
168     /// @param s ellipitc curve parameter s
169     function registerForCompetition(
170         address fund,
171         address manager,
172         address buyinAsset,
173         address payoutAsset,
174         address payoutAddress,
175         uint buyinQuantity,
176         uint8 v,
177         bytes32 r,
178         bytes32 s
179     )
180         pre_cond(termsAndConditionsAreSigned(manager, v, r, s) && isKYCVerified(msg.sender))
181         pre_cond(registeredFundToRegistrants[fund] == address(0) && registrantToHopefulIds[msg.sender].exists == false)
182     {
183         require(buyinAsset == MELON_ASSET && payoutAsset == MELON_ASSET);
184         require(buyinQuantity <= maxbuyinQuantity && hopefuls.length <= maxHopefulsNumber);
185         registeredFundToRegistrants[fund] = msg.sender;
186         registrantToHopefulIds[msg.sender] = HopefulId({id: hopefuls.length, exists: true});
187         Register(hopefuls.length, fund, msg.sender);
188         hopefuls.push(Hopeful({
189           fund: fund,
190           manager: manager,
191           registrant: msg.sender,
192           hasSigned: true,
193           buyinAsset: buyinAsset,
194           payoutAsset: payoutAsset,
195           payoutAddress: payoutAddress,
196           buyinQuantity: buyinQuantity,
197           payoutQuantity: 0,
198           isCompeting: true,
199           isDisqualified: false,
200           finalSharePrice: 0,
201           finalCompetitionRank: 0
202         }));
203     }
204 
205     /// @notice Disqualify and participant
206     /// @dev Only the oracle can call this function
207     /// @param withId Index of Hopeful to disqualify
208     function disqualifyHopeful(
209         uint withId
210     )
211         pre_cond(isOracle())
212     {
213         hopefuls[withId].isDisqualified = true;
214     }
215 
216     /// @notice Closing oracle service, inputs final stats and triggers payouts
217     /// @dev Only the oracle can call this function
218     /// @param withId Index of Hopeful to be attest for
219     /// @param payoutQuantity Quantity of payoutAsset received as prize
220     /// @param finalSharePrice Performance of Melon fund at competition endTime; Can be changed for any other comparison metric
221     /// @param finalCompetitionRank Rank of Hopeful at end of competition; Calculate by logic as set in terms and conditions
222     function finalizeAndPayoutForHopeful(
223         uint withId,
224         uint payoutQuantity, // Quantity of payoutAsset received as prize
225         uint finalSharePrice, // Performance of Melon fund at competition endTime; Can be changed for any other comparison metric
226         uint finalCompetitionRank // Rank of Hopeful at end of competition; Calculate by logic as set in terms and conditions
227     )
228         pre_cond(isOracle())
229         pre_cond(hopefuls[withId].isDisqualified == false)
230         pre_cond(block.timestamp >= endTime)
231     {
232         hopefuls[withId].finalSharePrice = finalSharePrice;
233         hopefuls[withId].finalCompetitionRank = finalCompetitionRank;
234         hopefuls[withId].payoutQuantity = payoutQuantity;
235         require(MELON_CONTRACT.transfer(hopefuls[withId].registrant, payoutQuantity));
236     }
237 
238     /// @notice Changes certifier contract address
239     /// @dev Only the oracle can call this function
240     /// @param newCertifier Address of the new certifier
241     function changeCertifier(
242         address newCertifier
243     )
244         pre_cond(isOracle())
245     {
246         CERTIFIER = Certifier(newCertifier);
247     }
248 
249 }
250 
251 contract ERC20Interface {
252 
253     // EVENTS
254 
255     event Transfer(address indexed _from, address indexed _to, uint256 _value);
256     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
257 
258     // CONSTANT METHODS
259 
260     function totalSupply() constant returns (uint256 totalSupply) {}
261     function balanceOf(address _owner) constant returns (uint256 balance) {}
262     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
263 
264     // NON-CONSTANT METHODS
265 
266     function transfer(address _to, uint256 _value) returns (bool success) {}
267     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
268     function approve(address _spender, uint256 _value) returns (bool success) {}
269 }
270 
271 contract Owned {
272 	modifier only_owner { if (msg.sender != owner) return; _; }
273 
274 	event NewOwner(address indexed old, address indexed current);
275 
276 	function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
277 
278 	address public owner = msg.sender;
279 }
280 
281 contract Certifier {
282 	event Confirmed(address indexed who);
283 	event Revoked(address indexed who);
284 	function certified(address _who) constant returns (bool);
285 	function get(address _who, string _field) constant returns (bytes32) {}
286 	function getAddress(address _who, string _field) constant returns (address) {}
287 	function getUint(address _who, string _field) constant returns (uint) {}
288 }
289 
290 contract SimpleCertifier is Owned, Certifier {
291 	modifier only_delegate { if (msg.sender != delegate) return; _; }
292 	modifier only_certified(address _who) { if (!certs[_who].active) return; _; }
293 
294 	struct Certification {
295 		bool active;
296 		mapping (string => bytes32) meta;
297 	}
298 
299 	function certify(address _who) only_delegate {
300 		certs[_who].active = true;
301 		Confirmed(_who);
302 	}
303 	function revoke(address _who) only_delegate only_certified(_who) {
304 		certs[_who].active = false;
305 		Revoked(_who);
306 	}
307 	function certified(address _who) constant returns (bool) { return certs[_who].active; }
308 	function get(address _who, string _field) constant returns (bytes32) { return certs[_who].meta[_field]; }
309 	function getAddress(address _who, string _field) constant returns (address) { return address(certs[_who].meta[_field]); }
310 	function getUint(address _who, string _field) constant returns (uint) { return uint(certs[_who].meta[_field]); }
311 	function setDelegate(address _new) only_owner { delegate = _new; }
312 
313 	mapping (address => Certification) certs;
314 	// So that the server posting puzzles doesn't have access to the ETH.
315 	address public delegate = msg.sender;
316 }