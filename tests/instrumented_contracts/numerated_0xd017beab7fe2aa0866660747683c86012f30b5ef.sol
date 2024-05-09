1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title BetexStorage
46  */
47 contract BetexStorage is Ownable {
48 
49     // minimum funding to get volume bonus	
50     uint256 public constant VOLUME_BONUS_CONDITION = 50 ether;
51 
52     // minimum funding to get volume extra bonus	
53     uint256 public constant VOLUME_EXTRA_BONUS_CONDITION = 100 ether;
54 
55     // extra bonus amount during first bonus round, %
56     uint256 public constant FIRST_VOLUME_EXTRA_BONUS = 20;
57 
58     // extra bonus amount during second bonus round, %
59     uint256 public constant SECOND_VOLUME_EXTRA_BONUS = 10;
60 
61     // bonus amount during first bonus round, %
62     uint256 public constant FIRST_VOLUME_BONUS = 10;
63 
64     // bonus amount during second bonus round, %
65     uint256 public constant SECOND_VOLUME_BONUS = 5;
66 
67     // oraclize funding order
68     struct Order {
69         address beneficiary;
70         uint256 funds;
71         uint256 bonus;
72         uint256 rate;
73     }
74 
75     // oraclize funding orders
76     mapping (bytes32 => Order) public orders;
77 
78     // oraclize orders for unsold tokens allocation
79     mapping (bytes32 => bool) public unsoldAllocationOrders;
80 
81     // addresses allowed to buy tokens
82     mapping (address => bool) public whitelist;
83 
84     // funded
85     mapping (address => bool) public funded;
86 
87     // funders
88     address[] public funders;
89     
90     // pre ico funders
91     address[] public preICOFunders;
92 
93     // tokens to allocate before ico sale starts
94     mapping (address => uint256) public preICOBalances;
95 
96     // is preICO data initialized
97     bool public preICODataInitialized;
98 
99 
100     /**
101      * @dev Constructor
102      */  
103     function BetexStorage() public {
104 
105         // pre sale round 1
106         preICOFunders.push(0x233Fd2B3d7a0924Fe1Bb0dd7FA168eEF8C522E65);
107         preICOBalances[0x233Fd2B3d7a0924Fe1Bb0dd7FA168eEF8C522E65] = 15000000000000000000000;
108         preICOFunders.push(0x2712ba56cB3Cf8783693c8a1796F70ABa57132b1);
109         preICOBalances[0x2712ba56cB3Cf8783693c8a1796F70ABa57132b1] = 15000000000000000000000;
110         preICOFunders.push(0x6f3DDfb726eA637e125C4fbf6694B940711478f4);
111         preICOBalances[0x6f3DDfb726eA637e125C4fbf6694B940711478f4] = 15000000000000000000000;
112         preICOFunders.push(0xAf7Ff6f381684707001d517Bf83C4a3538f9C82a);
113         preICOBalances[0xAf7Ff6f381684707001d517Bf83C4a3538f9C82a] = 22548265874120000000000;
114         preICOFunders.push(0x51219a9330c196b8bd7fA0737C8e0db53c1ad628);
115         preICOBalances[0x51219a9330c196b8bd7fA0737C8e0db53c1ad628] = 32145215844400000000000;
116         preICOFunders.push(0xA2D42D689769f7BA32712f27B09606fFD8F3b699);
117         preICOBalances[0xA2D42D689769f7BA32712f27B09606fFD8F3b699] = 15000000000000000000000;
118         preICOFunders.push(0xB7C9D3AAbF44296232538B8b184F274B57003994);
119         preICOBalances[0xB7C9D3AAbF44296232538B8b184F274B57003994] = 20000000000000000000000;
120         preICOFunders.push(0x58667a170F53b809CA9143c1CeEa00D2Df866577);
121         preICOBalances[0x58667a170F53b809CA9143c1CeEa00D2Df866577] = 184526257787000000000000;
122         preICOFunders.push(0x0D4b2A1a47b1059d622C033c2a58F2F651010553);
123         preICOBalances[0x0D4b2A1a47b1059d622C033c2a58F2F651010553] = 17845264771100000000000;
124         preICOFunders.push(0x982F59497026473d2227f5dd02cdf6fdCF237AE0);
125         preICOBalances[0x982F59497026473d2227f5dd02cdf6fdCF237AE0] = 31358989521120000000000;
126         preICOFunders.push(0x250d540EFeabA7b5C0407A955Fd76217590dbc37);
127         preICOBalances[0x250d540EFeabA7b5C0407A955Fd76217590dbc37] = 15000000000000000000000;
128         preICOFunders.push(0x2Cde7768B7d5dcb12c5b5572daEf3F7B855c8685);
129         preICOBalances[0x2Cde7768B7d5dcb12c5b5572daEf3F7B855c8685] = 17500000000000000000000;
130         preICOFunders.push(0x89777c2a4C1843a99B2fF481a4CEF67f5d7A1387);
131         preICOBalances[0x89777c2a4C1843a99B2fF481a4CEF67f5d7A1387] = 15000000000000000000000;
132         preICOFunders.push(0x63699D4d309e48e8B575BE771700570A828dC655);
133         preICOBalances[0x63699D4d309e48e8B575BE771700570A828dC655] = 15000000000000000000000;
134         preICOFunders.push(0x9bc92E0da2e4aC174b8E33D7c74b5009563a8e2A);
135         preICOBalances[0x9bc92E0da2e4aC174b8E33D7c74b5009563a8e2A] = 21542365440880000000000;
136         preICOFunders.push(0xA1CA632CF8Fb3a965c84668e09e3BEdb3567F35D);
137         preICOBalances[0xA1CA632CF8Fb3a965c84668e09e3BEdb3567F35D] = 15000000000000000000000;
138         preICOFunders.push(0x1DCeF74ddD26c82f34B300E027b5CaA4eC4F8C83);
139         preICOBalances[0x1DCeF74ddD26c82f34B300E027b5CaA4eC4F8C83] = 15000000000000000000000;
140         preICOFunders.push(0x51B7Bf4B7C1E89cfe7C09938Ad0096F9dFFCA4B7);
141         preICOBalances[0x51B7Bf4B7C1E89cfe7C09938Ad0096F9dFFCA4B7] = 17533640761380000000000;
142 
143         // pre sale round 2 
144         preICOFunders.push(0xD2Cdc0905877ee3b7d08220D783bd042de825AEb);
145         preICOBalances[0xD2Cdc0905877ee3b7d08220D783bd042de825AEb] = 5000000000000000000000;
146         preICOFunders.push(0x3b217081702AF670e2c2fD25FD7da882620a68E8);
147         preICOBalances[0x3b217081702AF670e2c2fD25FD7da882620a68E8] = 7415245400000000000000;
148         preICOFunders.push(0xbA860D4B9423bF6b517B29c395A49fe80Da758E3);
149         preICOBalances[0xbA860D4B9423bF6b517B29c395A49fe80Da758E3] = 5000000000000000000000;
150         preICOFunders.push(0xF64b80DdfB860C0D1bEb760fd9fC663c4D5C4dC3);
151         preICOBalances[0xF64b80DdfB860C0D1bEb760fd9fC663c4D5C4dC3] = 75000000000000000000000;
152         preICOFunders.push(0x396D5A35B5f41D7cafCCF9BeF225c274d2c7B6E2);
153         preICOBalances[0x396D5A35B5f41D7cafCCF9BeF225c274d2c7B6E2] = 74589245777000000000000;
154         preICOFunders.push(0x4d61A4aD175E96139Ae8c5d951327e3f6Cc3f764);
155         preICOBalances[0x4d61A4aD175E96139Ae8c5d951327e3f6Cc3f764] = 5000000000000000000000;
156         preICOFunders.push(0x4B490F6A49C17657A5508B8Bf8F1D7f5aAD8c921);
157         preICOBalances[0x4B490F6A49C17657A5508B8Bf8F1D7f5aAD8c921] = 200000000000000000000000;
158         preICOFunders.push(0xC943038f2f1dd1faC6E10B82039C14bd20ff1F8E);
159         preICOBalances[0xC943038f2f1dd1faC6E10B82039C14bd20ff1F8E] = 174522545811300000000000;
160         preICOFunders.push(0xBa87D63A8C4Ed665b6881BaCe4A225a07c418F22);
161         preICOBalances[0xBa87D63A8C4Ed665b6881BaCe4A225a07c418F22] = 5000000000000000000000;
162         preICOFunders.push(0x753846c0467cF320BcDA9f1C67fF86dF39b1438c);
163         preICOBalances[0x753846c0467cF320BcDA9f1C67fF86dF39b1438c] = 5000000000000000000000;
164         preICOFunders.push(0x3773bBB1adDF9D642D5bbFaafa13b0690Fb33460);
165         preICOBalances[0x3773bBB1adDF9D642D5bbFaafa13b0690Fb33460] = 5000000000000000000000;
166         preICOFunders.push(0x456Cf70345cbF483779166af117B40938B8F0A9c);
167         preICOBalances[0x456Cf70345cbF483779166af117B40938B8F0A9c] = 50000000000000000000000;
168         preICOFunders.push(0x662AE260D736F041Db66c34617d5fB22eC0cC2Ee);
169         preICOBalances[0x662AE260D736F041Db66c34617d5fB22eC0cC2Ee] = 40000000000000000000000;
170         preICOFunders.push(0xEa7e647F167AdAa4df52AF630A873a1379f68E3F);
171         preICOBalances[0xEa7e647F167AdAa4df52AF630A873a1379f68E3F] = 40000000000000000000000;
172         preICOFunders.push(0x352913f3F7CA96530180b93C18C86f38b3F0c429);
173         preICOBalances[0x352913f3F7CA96530180b93C18C86f38b3F0c429] = 45458265454000000000000;
174         preICOFunders.push(0xB21bf8391a6500ED210Af96d125867124261f4d4);
175         preICOBalances[0xB21bf8391a6500ED210Af96d125867124261f4d4] = 5000000000000000000000;
176         preICOFunders.push(0xDecBd29B42c66f90679D2CB34e73E571F447f6c5);
177         preICOBalances[0xDecBd29B42c66f90679D2CB34e73E571F447f6c5] = 7500000000000000000000;
178         preICOFunders.push(0xE36106a0DC0F07e87f7194694631511317909b8B);
179         preICOBalances[0xE36106a0DC0F07e87f7194694631511317909b8B] = 5000000000000000000000;
180         preICOFunders.push(0xe9114cd97E0Ee4fe349D3F57d0C9710E18581b69);
181         preICOBalances[0xe9114cd97E0Ee4fe349D3F57d0C9710E18581b69] = 40000000000000000000000;
182         preICOFunders.push(0xC73996ce45752B9AE4e85EDDf056Aa9aaCaAD4A2);
183         preICOBalances[0xC73996ce45752B9AE4e85EDDf056Aa9aaCaAD4A2] = 100000000000000000000000;
184         preICOFunders.push(0x6C1407d9984Dc2cE33456b67acAaEC78c1784673);
185         preICOBalances[0x6C1407d9984Dc2cE33456b67acAaEC78c1784673] = 5000000000000000000000;
186         preICOFunders.push(0x987e93429004CA9fa2A42604658B99Bb5A574f01);
187         preICOBalances[0x987e93429004CA9fa2A42604658B99Bb5A574f01] = 124354548881022000000000;
188         preICOFunders.push(0x4c3B81B5f9f9c7efa03bE39218E6760E8D2A1609);
189         preICOBalances[0x4c3B81B5f9f9c7efa03bE39218E6760E8D2A1609] = 5000000000000000000000;
190         preICOFunders.push(0x33fA8cd89B151458Cb147ecC497e469f2c1D38eA);
191         preICOBalances[0x33fA8cd89B151458Cb147ecC497e469f2c1D38eA] = 60000000000000000000000;
192 
193         // main sale (01-31 of Marh)
194         preICOFunders.push(0x9AfA1204afCf48AB4302F246Ef4BE5C1D733a751);
195         preICOBalances[0x9AfA1204afCf48AB4302F246Ef4BE5C1D733a751] = 154551417972192330000000;
196     }
197 
198     /**
199      * @dev Add a new address to the funders
200      * @param _funder funder's address
201      */
202     function addFunder(address _funder) public onlyOwner {
203         if (!funded[_funder]) {
204             funders.push(_funder);
205             funded[_funder] = true;
206         }
207     }
208    
209     /**
210      * @return true if address is a funder address
211      * @param _funder funder's address
212      */
213     function isFunder(address _funder) public view returns(bool) {
214         return funded[_funder];
215     }
216 
217     /**
218      * @return funders count
219      */
220     function getFundersCount() public view returns(uint256) {
221         return funders.length;
222     }
223 
224     /**
225      * @return number of preICO funders count
226      */
227     function getPreICOFundersCount() public view returns(uint256) {
228         return preICOFunders.length;
229     }
230 
231     /**
232      * @dev Add a new oraclize funding order
233      * @param _orderId oraclize order id
234      * @param _beneficiary who'll get the tokens
235      * @param _funds paid wei amount
236      * @param _bonus bonus amount
237      */
238     function addOrder(
239         bytes32 _orderId, 
240         address _beneficiary, 
241         uint256 _funds, 
242         uint256 _bonus
243     )
244         public 
245         onlyOwner 
246     {
247         orders[_orderId].beneficiary = _beneficiary;
248         orders[_orderId].funds = _funds;
249         orders[_orderId].bonus = _bonus;
250     }
251 
252     /**
253      * @dev Get oraclize funding order by order id
254      * @param _orderId oraclize order id
255      * @return beneficiaty address, paid funds amount and bonus amount 
256      */
257     function getOrder(bytes32 _orderId) 
258         public 
259         view 
260         returns(address, uint256, uint256)
261     {
262         address _beneficiary = orders[_orderId].beneficiary;
263         uint256 _funds = orders[_orderId].funds;
264         uint256 _bonus = orders[_orderId].bonus;
265 
266         return (_beneficiary, _funds, _bonus);
267     }
268 
269     /**
270      * @dev Set eth/usd rate for the specified oraclize order
271      * @param _orderId oraclize order id
272      * @param _rate eth/usd rate
273      */
274     function setRateForOrder(bytes32 _orderId, uint256 _rate) public onlyOwner {
275         orders[_orderId].rate = _rate;
276     }
277 
278     /**
279      * @dev Add a new oraclize unsold tokens allocation order
280      * @param _orderId oraclize order id
281      */
282     function addUnsoldAllocationOrder(bytes32 _orderId) public onlyOwner {
283         unsoldAllocationOrders[_orderId] = true;
284     }
285 
286     /**
287      * @dev Whitelist the address
288      * @param _address address to be whitelisted
289      */
290     function addToWhitelist(address _address) public onlyOwner {
291         whitelist[_address] = true;
292     }
293 
294     /**
295      * @dev Check if address is whitelisted
296      * @param _address address that needs to be verified
297      * @return true if address is whitelisted
298      */
299     function isWhitelisted(address _address) public view returns(bool) {
300         return whitelist[_address];
301     }
302 
303     /**
304      * @dev Get bonus amount for token purchase
305      * @param _funds amount of the funds
306      * @param _bonusChangeTime bonus change time
307      * @return corresponding bonus value
308      */
309     function getBonus(uint256 _funds, uint256 _bonusChangeTime) public view returns(uint256) {
310         
311         if (_funds < VOLUME_BONUS_CONDITION)
312             return 0;
313 
314         if (now < _bonusChangeTime) { // solium-disable-line security/no-block-members
315             if (_funds >= VOLUME_EXTRA_BONUS_CONDITION)
316                 return FIRST_VOLUME_EXTRA_BONUS;
317             else 
318                 return FIRST_VOLUME_BONUS;
319         } else {
320             if (_funds >= VOLUME_EXTRA_BONUS_CONDITION)
321                 return SECOND_VOLUME_EXTRA_BONUS;
322             else
323                 return SECOND_VOLUME_BONUS;
324         }
325         return 0;
326     }
327 }