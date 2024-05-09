1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    */
37   function renounceOwnership() public onlyOwner {
38     emit OwnershipRenounced(owner);
39     owner = address(0);
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param _newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address _newOwner) public onlyOwner {
47     _transferOwnership(_newOwner);
48   }
49 
50   /**
51    * @dev Transfers control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function _transferOwnership(address _newOwner) internal {
55     require(_newOwner != address(0));
56     emit OwnershipTransferred(owner, _newOwner);
57     owner = _newOwner;
58   }
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
72     // benefit is lost if 'b' is also tested.
73     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74     if (a == 0) {
75       return 0;
76     }
77 
78     c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     // uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return a / b;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 
112 
113 contract Token {
114     function balanceOf(address _owner) public constant returns (uint256);
115 }
116 
117 contract FactoryData is Ownable {
118     using SafeMath for uint256;
119     struct CP {
120         string refNumber;
121         string name;
122         mapping(address => bool) factories;
123     }
124 
125     uint256 blocksquareFee = 20;
126     uint256 networkReserveFundFee = 50;
127     uint256 cpFee = 15;
128     uint256 firstBuyersFee = 15;
129 
130     /* Mappings */
131     mapping(address => mapping(address => bool)) whitelisted;
132     mapping(string => address) countryFactory;
133     mapping(address => bool) memberOfBS;
134     mapping(address => uint256) requiredBST;
135     mapping(address => CP) CPs;
136     mapping(address => address) noFeeTransfersAccounts;
137     mapping(address => bool) prestigeAddress;
138     Token BST;
139 
140     /**
141     * Constructor function
142     *
143     * Initializes contract.
144     **/
145     constructor() public {
146         memberOfBS[msg.sender] = true;
147         owner = msg.sender;
148         BST = Token(0x509A38b7a1cC0dcd83Aa9d06214663D9eC7c7F4a);
149     }
150 
151     /**
152     * Add factory
153     *
154     * Owner can add factory for country
155     *
156     * @param _country Name of country
157     * @param _factory Address of factory
158     **/
159     function addFactory(string _country, address _factory) public onlyOwner {
160         countryFactory[_country] = _factory;
161     }
162 
163     /**
164     * @dev add member to blocksquare group
165     * @param _member Address of member to add
166     **/
167     function addMemberToBS(address _member) public onlyOwner {
168         memberOfBS[_member] = true;
169     }
170 
171     /**
172     * @dev add new certified partner
173     * @param _cp Wallet address of certified partner
174     * @param _refNumber Reference number of certified partner
175     * @param _name Name of certified partner
176     **/
177     function createCP(address _cp, string _refNumber, string _name) public onlyOwner {
178         CP memory cp = CP(_refNumber, _name);
179         CPs[_cp] = cp;
180     }
181 
182     /**
183     * @dev add allowance to create buildings in country to certified partner
184     * @param _cp Wallet address of certified partner
185     * @param _factory Factory address
186     **/
187     function addFactoryToCP(address _cp, address _factory) public onlyOwner {
188         CP storage cp = CPs[_cp];
189         cp.factories[_factory] = true;
190     }
191 
192     /**
193     * @dev remove allowance to create buildings in country from certified partner
194     * @param _cp Wallet address of certified partner
195     * @param _factory Factory address
196     **/
197     function removeCP(address _cp, address _factory) public onlyOwner {
198         CP storage cp = CPs[_cp];
199         cp.factories[_factory] = false;
200     }
201 
202     /**
203     * @dev connect two addresses so that they can send BSPT without fee
204     * @param _from First address
205     * @param _to Second address
206     **/
207     function addNoFeeAddress(address[] _from, address[] _to) public onlyOwner {
208         require(_from.length == _to.length);
209         for (uint256 i = 0; i < _from.length; i++) {
210             noFeeTransfersAccounts[_from[i]] = _to[i];
211             noFeeTransfersAccounts[_to[i]] = _from[i];
212         }
213     }
214 
215     /**
216     * @dev change BTS requirement for buying BSPT
217     * @param _factory Address of factory
218     * @param _amount Amount of required tokens
219     **/
220     function changeBSTRequirement(address _factory, uint256 _amount) public onlyOwner {
221         requiredBST[_factory] = _amount * 10 ** 18;
222     }
223 
224     /**
225     * @dev add addresses to whitelist for factory
226     * @param _factory Address of factory
227     * @param _addresses Array of addresses to whitelist
228     **/
229     function addToWhitelist(address _factory, address[] _addresses) public onlyOwner {
230         for (uint256 i = 0; i < _addresses.length; i++) {
231             whitelisted[_factory][_addresses[i]] = true;
232         }
233     }
234 
235     /**
236     * @dev remove address from whitelist
237     * @param _factory Address of factory
238     * @param _user Address of user
239     **/
240     function removeFromWhitelist(address _factory, address _user) public onlyOwner {
241         whitelisted[_factory][_user] = false;
242     }
243 
244     function changeFees(uint256 _network, uint256 _blocksquare, uint256 _cp, uint256 _firstBuyers) public onlyOwner {
245         require(_network.add(_blocksquare).add(_cp).add(_firstBuyers) == 100);
246         blocksquareFee = _network;
247         networkReserveFundFee = _blocksquare;
248         cpFee = _cp;
249         firstBuyersFee = _firstBuyers;
250     }
251 
252     function changePrestige(address _owner) public onlyOwner {
253         prestigeAddress[_owner] = !prestigeAddress[_owner];
254     }
255 
256     /**
257     * @dev check if address is whitelisted for factory
258     * @param _factory Address of factory
259     * @param _user Address of user
260     * @return True if user is whitelisted for given factory, false instead
261     **/
262     function isWhitelisted(address _factory, address _user) public constant returns (bool) {
263         return whitelisted[_factory][_user];
264     }
265 
266     /**
267     * @dev get factory address for given country
268     * @param _country Name of country
269     * @return Address of factory
270     **/
271     function getFactoryForCountry(string _country) public constant returns (address) {
272         return countryFactory[_country];
273     }
274 
275     /**
276     * @dev check if address is member of Blocksquare
277     * @param _member Address of member
278     * @return True if member is member of Blocksquare, false instead
279     **/
280     function isBS(address _member) public constant returns (bool) {
281         return memberOfBS[_member];
282     }
283 
284     /**
285     * @dev check if address has enough BST to buy BSPT
286     * @param _factory Address of factory
287     * @param _address Address of BST owner
288     * @return True if address has enough BST, false instead
289     **/
290     function hasEnoughBST(address _factory, address _address) constant public returns (bool) {
291         return BST.balanceOf(_address) >= requiredBST[_factory];
292     }
293 
294     /**
295     * @dev amount of BST required to buy BSPT
296     * @param _factory Address of factory
297     * @return Amount of BST required
298     **/
299     function amountOfBSTRequired(address _factory) constant public returns (uint256) {
300         return requiredBST[_factory];
301     }
302 
303     /**
304     * @dev check if certified partner can create new building in factory
305     * @param _cp Wallet address of certified partner
306     * @param _factory Factory address
307     * @return True if certified partner can create buildings, false instead
308     **/
309     function canCPCreateInFactory(address _cp, address _factory) constant public returns (bool) {
310         return CPs[_cp].factories[_factory];
311     }
312 
313     /**
314     * @dev get info about certified partner
315     * @param _cp Wallet address of certified partner
316     * @return Certified partner's reference number and name
317     **/
318     function getCP(address _cp) constant public returns (string, string) {
319         return (CPs[_cp].refNumber, CPs[_cp].name);
320     }
321 
322     /**
323     * @dev check if two address can send BSPT without fee;
324     * @param _from From address
325     * @param _to To address
326     * @return True if addresses can send BSPT without fee between them, false instead
327     **/
328     function canMakeNoFeeTransfer(address _from, address _to) constant public returns (bool) {
329         return noFeeTransfersAccounts[_from] == _to;
330     }
331 
332     function getNetworkFee() public constant returns (uint256) {
333         return networkReserveFundFee;
334     }
335 
336     function getBlocksquareFee() public constant returns (uint256) {
337         return blocksquareFee;
338     }
339 
340     function getCPFee() public constant returns (uint256) {
341         return cpFee;
342     }
343 
344     function getFirstBuyersFee() public constant returns (uint256) {
345         return firstBuyersFee;
346     }
347 
348     function hasPrestige(address _owner) public constant returns(bool) {
349         return prestigeAddress[_owner];
350     }
351 }