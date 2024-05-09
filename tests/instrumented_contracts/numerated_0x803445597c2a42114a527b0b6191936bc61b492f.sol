1 pragma solidity ^0.5.0;
2 /**
3  * @title IERC165
4  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
5  */
6 interface IERC165 {
7     /**
8      * @notice Query if a contract implements an interface
9      * @param interfaceId The interface identifier, as specified in ERC-165
10      * @dev Interface identification is specified in ERC-165. This function
11      * uses less than 30,000 gas.
12      */
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 /**
16  * @title ERC721 Non-Fungible Token Standard basic interface
17  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
18  */
19 contract IERC721 is IERC165 {
20     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
21     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
22     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
23 
24     function setup() public;
25 
26     function balanceOf(address owner) public view returns (uint256 balance);
27     function ownerOf(uint256 tokenId) public view returns (address owner);
28 
29     function approve(address to, uint256 tokenId) public;
30     function getApproved(uint256 tokenId) public view returns (address operator);
31 
32     function setApprovalForAll(address operator, bool _approved) public;
33     function isApprovedForAll(address owner, address operator) public view returns (bool);
34 
35     function transferFrom(address from, address to, uint256 tokenId) public;
36     function safeTransferFrom(address from, address to, uint256 tokenId) public;
37 
38     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
39 }
40 /**
41  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
42  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
43  */
44 contract IERC721Metadata is IERC721 {
45     function name() external view returns (string memory);
46     function symbol() external view returns (string memory);
47     function tokenURI(uint256 tokenId) external view returns (string memory);
48 }
49 /**
50  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
51  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
52  */
53 contract IERC721Enumerable is IERC721 {
54     function totalSupply() public view returns (uint256);
55     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
56 
57     function tokenByIndex(uint256 index) public view returns (uint256);
58 }
59 /**
60  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
61  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
62  */
63 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
64     // solhint-disable-previous-line no-empty-blocks
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Unsigned math operations with safety checks that revert on error
70  */
71 library SafeMath {
72     /**
73      * @dev Multiplies two unsigned integers, reverts on overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b);
85 
86         return c;
87     }
88 
89     /**
90      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
91      */
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Solidity only automatically asserts when dividing by 0
94         require(b > 0);
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97 
98         return c;
99     }
100 
101     /**
102      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b <= a);
106         uint256 c = a - b;
107 
108         return c;
109     }
110 
111     /**
112      * @dev Adds two unsigned integers, reverts on overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a);
117 
118         return c;
119     }
120 
121     /**
122      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
123      * reverts when dividing by zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b != 0);
127         return a % b;
128     }
129 }
130 contract VitalikSteward {
131     
132     /*
133     This smart contract collects patronage from current owner through a Harberger tax model and 
134     takes stewardship of the asset token if the patron can't pay anymore.
135 
136     Harberger Tax (COST): 
137     - Asset is always on sale.
138     - You have to have a price set.
139     - Tax (Patronage) is paid to maintain ownership.
140     - Steward maints control over ERC721.
141     */
142     using SafeMath for uint256;
143     
144     uint256 public price; //in wei
145     IERC721Full public assetToken; // ERC721 NFT.
146     
147     uint256 public totalCollected; // all patronage ever collected
148     uint256 public currentCollected; // amount currently collected for patron  
149     uint256 public timeLastCollected; // 
150     uint256 public deposit;
151 
152     address payable public organization; // non-profit organization
153     uint256 public organizationFund;
154     
155     mapping (address => bool) public patrons;
156     mapping (address => uint256) public timeHeld;
157 
158     uint256 public timeAcquired;
159     
160     // 30% patronage
161     uint256 patronageNumerator = 300000000000;
162     uint256 patronageDenominator = 1000000000000;
163 
164     enum StewardState { Foreclosed, Owned }
165     StewardState public state;
166 
167     constructor(address payable _organization, address _assetToken) public {
168         assetToken = IERC721Full(_assetToken);
169         assetToken.setup();
170         organization = _organization;
171         state = StewardState.Foreclosed;
172     } 
173 
174     event LogBuy(address indexed owner, uint256 indexed price);
175     event LogPriceChange(uint256 indexed newPrice);
176     event LogForeclosure(address indexed prevOwner);
177     event LogCollection(uint256 indexed collected);
178     
179     modifier onlyPatron() {
180         require(msg.sender == assetToken.ownerOf(42), "Not patron");
181         _;
182     }
183 
184     modifier onlyReceivingOrganization() {
185         require(msg.sender == organization, "Not organization");
186         _;
187     }
188 
189     modifier collectPatronage() {
190        _collectPatronage(); 
191        _;
192     }
193 
194     function changeReceivingOrganization(address payable _newReceivingOrganization) public onlyReceivingOrganization {
195         organization = _newReceivingOrganization;
196     }
197 
198     /* public view functions */
199     function patronageOwed() public view returns (uint256 patronageDue) {
200         return price.mul(now.sub(timeLastCollected)).mul(patronageNumerator)
201             .div(patronageDenominator).div(365 days);
202     }
203 
204     function patronageOwedWithTimestamp() public view returns (uint256 patronageDue, uint256 timestamp) {
205         return (patronageOwed(), now);
206     }
207 
208     function foreclosed() public view returns (bool) {
209         // returns whether it is in foreclosed state or not
210         // depending on whether deposit covers patronage due
211         // useful helper function when price should be zero, but contract doesn't reflect it yet.
212         uint256 collection = patronageOwed();
213         if(collection >= deposit) {
214             return true;
215         } else {
216             return false;
217         }
218     }
219 
220     // same function as above, basically
221     function depositAbleToWithdraw() public view returns (uint256) {
222         uint256 collection = patronageOwed();
223         if(collection >= deposit) {
224             return 0;
225         } else {
226             return deposit.sub(collection);
227         }
228     }
229 
230     /*
231     now + deposit/patronage per second 
232     now + depositAbleToWithdraw/(price*nume/denom/365).
233     */
234     function foreclosureTime() public view returns (uint256) {
235         // patronage per second
236         uint256 pps = price.mul(patronageNumerator).div(patronageDenominator).div(365 days);
237         return now + depositAbleToWithdraw().div(pps); // zero division if price is zero.
238     }
239 
240     /* actions */
241     function _collectPatronage() public {
242         // determine patronage to pay
243         if (state == StewardState.Owned) {
244             uint256 collection = patronageOwed();
245             
246             // should foreclose and stake stewardship
247             if (collection >= deposit) {
248                 // up to when was it actually paid for?
249                 timeLastCollected = timeLastCollected.add(((now.sub(timeLastCollected)).mul(deposit).div(collection)));
250                 collection = deposit; // take what's left.
251 
252                 _foreclose();
253             } else  {
254                 // just a normal collection
255                 timeLastCollected = now;
256                 currentCollected = currentCollected.add(collection);
257             }
258             
259             deposit = deposit.sub(collection);
260             totalCollected = totalCollected.add(collection);
261             organizationFund = organizationFund.add(collection);
262             emit LogCollection(collection);
263         }
264     }
265     
266     // note: anyone can deposit
267     function depositWei() public payable collectPatronage {
268         require(state != StewardState.Foreclosed, "Foreclosed");
269         deposit = deposit.add(msg.value);
270     }
271     
272     function buy(uint256 _newPrice) public payable collectPatronage {
273         require(_newPrice > 0, "Price is zero");
274         require(msg.value > price, "Not enough"); // >, coz need to have at least something for deposit
275         address currentOwner = assetToken.ownerOf(42);
276 
277         if (state == StewardState.Owned) {
278             uint256 totalToPayBack = price;
279             if(deposit > 0) {
280                 totalToPayBack = totalToPayBack.add(deposit);
281             }  
282     
283             // pay previous owner their price + deposit back.
284             address payable payableCurrentOwner = address(uint160(currentOwner));
285             payableCurrentOwner.transfer(totalToPayBack);
286         } else if(state == StewardState.Foreclosed) {
287             state = StewardState.Owned;
288             timeLastCollected = now;
289         }
290         
291         deposit = msg.value.sub(price);
292         transferAssetTokenTo(currentOwner, msg.sender, _newPrice);
293         emit LogBuy(msg.sender, _newPrice);
294     }
295 
296     function changePrice(uint256 _newPrice) public onlyPatron collectPatronage {
297         require(state != StewardState.Foreclosed, "Foreclosed");
298         require(_newPrice != 0, "Incorrect Price");
299         
300         price = _newPrice;
301         emit LogPriceChange(price);
302     }
303     
304     function withdrawDeposit(uint256 _wei) public onlyPatron collectPatronage returns (uint256) {
305         _withdrawDeposit(_wei);
306     }
307 
308     function withdrawOrganizationFunds() public {
309         require(msg.sender == organization, "Not organization");
310         organization.transfer(organizationFund);
311         organizationFund = 0;
312     }
313 
314     function exit() public onlyPatron collectPatronage {
315         _withdrawDeposit(deposit);
316     }
317 
318     /* internal */
319 
320     function _withdrawDeposit(uint256 _wei) internal {
321         // note: can withdraw whole deposit, which puts it in immediate to be foreclosed state.
322         require(deposit >= _wei, 'Withdrawing too much');
323 
324         deposit = deposit.sub(_wei);
325         msg.sender.transfer(_wei); // msg.sender == patron
326 
327         if(deposit == 0) {
328             _foreclose();
329         }
330     }
331 
332     function _foreclose() internal {
333         // become steward of assetToken (aka foreclose)
334         address currentOwner = assetToken.ownerOf(42);
335         transferAssetTokenTo(currentOwner, address(this), 0);
336         state = StewardState.Foreclosed;
337         currentCollected = 0;
338 
339         emit LogForeclosure(currentOwner);
340     }
341 
342     function transferAssetTokenTo(address _currentOwner, address _newOwner, uint256 _newPrice) internal {
343         // note: it would also tabulate time held in stewardship by smart contract
344         timeHeld[_currentOwner] = timeHeld[_currentOwner].add((timeLastCollected.sub(timeAcquired)));
345         
346         assetToken.transferFrom(_currentOwner, _newOwner, 42);
347 
348         price = _newPrice;
349         timeAcquired = now;
350         patrons[_newOwner] = true;
351     }
352 }