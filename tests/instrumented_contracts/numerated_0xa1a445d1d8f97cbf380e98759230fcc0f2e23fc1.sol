1 pragma solidity ^0.5.0;
2 
3 
4 contract DSProxyInterface {
5     function execute(bytes memory _code, bytes memory _data) public payable returns (address, bytes32);
6 
7     function execute(address _target, bytes memory _data) public payable returns (bytes32);
8 
9     function setCache(address _cacheAddr) public payable returns (bool);
10 
11     function owner() public returns (address);
12 }
13 
14 contract ProxyRegistryInterface {
15     function proxies(address _owner) public view returns(DSProxyInterface);
16     function build(address) public returns (address);
17 }
18 
19 contract DSMath {
20     function add(uint x, uint y) internal pure returns (uint z) {
21         require((z = x + y) >= x);
22     }
23     function sub(uint x, uint y) internal pure returns (uint z) {
24         require((z = x - y) <= x);
25     }
26     function mul(uint x, uint y) internal pure returns (uint z) {
27         require(y == 0 || (z = x * y) / y == x);
28     }
29 
30     function min(uint x, uint y) internal pure returns (uint z) {
31         return x <= y ? x : y;
32     }
33     function max(uint x, uint y) internal pure returns (uint z) {
34         return x >= y ? x : y;
35     }
36     function imin(int x, int y) internal pure returns (int z) {
37         return x <= y ? x : y;
38     }
39     function imax(int x, int y) internal pure returns (int z) {
40         return x >= y ? x : y;
41     }
42 
43     uint constant WAD = 10 ** 18;
44     uint constant RAY = 10 ** 27;
45 
46     function wmul(uint x, uint y) internal pure returns (uint z) {
47         z = add(mul(x, y), WAD / 2) / WAD;
48     }
49     function rmul(uint x, uint y) internal pure returns (uint z) {
50         z = add(mul(x, y), RAY / 2) / RAY;
51     }
52     function wdiv(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, WAD), y / 2) / y;
54     }
55     function rdiv(uint x, uint y) internal pure returns (uint z) {
56         z = add(mul(x, RAY), y / 2) / y;
57     }
58 
59     // This famous algorithm is called "exponentiation by squaring"
60     // and calculates x^n with x as fixed-point and n as regular unsigned.
61     //
62     // It's O(log n), instead of O(n) for naive repeated multiplication.
63     //
64     // These facts are why it works:
65     //
66     //  If n is even, then x^n = (x^2)^(n/2).
67     //  If n is odd,  then x^n = x * x^(n-1),
68     //   and applying the equation for even x gives
69     //    x^n = x * (x^2)^((n-1) / 2).
70     //
71     //  Also, EVM division is flooring and
72     //    floor[(n-1) / 2] = floor[n / 2].
73     //
74     function rpow(uint x, uint n) internal pure returns (uint z) {
75         z = n % 2 != 0 ? x : RAY;
76 
77         for (n /= 2; n != 0; n /= 2) {
78             x = rmul(x, x);
79 
80             if (n % 2 != 0) {
81                 z = rmul(z, x);
82             }
83         }
84     }
85 }
86 
87 contract DSAuthEvents {
88     event LogSetAuthority (address indexed authority);
89     event LogSetOwner     (address indexed owner);
90 }
91 
92 
93 contract DSAuthority {
94     function canCall(
95         address src, address dst, bytes4 sig
96     ) public view returns (bool);
97 }
98 
99 contract DSAuth is DSAuthEvents {
100     DSAuthority  public  authority;
101     address      public  owner;
102 
103     constructor() public {
104         owner = msg.sender;
105         emit LogSetOwner(msg.sender);
106     }
107 
108     function setOwner(address owner_)
109         public
110         auth
111     {
112         owner = owner_;
113         emit LogSetOwner(owner);
114     }
115 
116     function setAuthority(DSAuthority authority_)
117         public
118         auth
119     {
120         authority = authority_;
121         emit LogSetAuthority(address(authority));
122     }
123 
124     modifier auth {
125         require(isAuthorized(msg.sender, msg.sig));
126         _;
127     }
128 
129     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
130         if (src == address(this)) {
131             return true;
132         } else if (src == owner) {
133             return true;
134         } else if (authority == DSAuthority(0)) {
135             return false;
136         } else {
137             return authority.canCall(src, address(this), sig);
138         }
139     }
140 }
141 
142 contract TokenInterface {
143     function allowance(address, address) public returns (uint);
144     function balanceOf(address) public returns (uint);
145     function approve(address, uint) public;
146     function transfer(address, uint) public returns (bool);
147     function transferFrom(address, address, uint) public returns (bool);
148     function deposit() public payable;
149     function withdraw(uint) public;
150 }
151 
152 contract PipInterface {
153     function read() public returns (bytes32);
154 }
155 
156 contract PepInterface {
157     function peek() public returns (bytes32, bool);
158 }
159 
160 contract VoxInterface {
161     function par() public returns (uint);
162 }
163 
164 contract TubInterface {
165     event LogNewCup(address indexed lad, bytes32 cup);
166 
167     function open() public returns (bytes32);
168     function join(uint) public;
169     function exit(uint) public;
170     function lock(bytes32, uint) public;
171     function free(bytes32, uint) public;
172     function draw(bytes32, uint) public;
173     function wipe(bytes32, uint) public;
174     function give(bytes32, address) public;
175     function shut(bytes32) public;
176     function bite(bytes32) public;
177     function cups(bytes32) public returns (address, uint, uint, uint);
178     function gem() public returns (TokenInterface);
179     function gov() public returns (TokenInterface);
180     function skr() public returns (TokenInterface);
181     function sai() public returns (TokenInterface);
182     function vox() public returns (VoxInterface);
183     function ask(uint) public returns (uint);
184     function mat() public returns (uint);
185     function chi() public returns (uint);
186     function ink(bytes32) public returns (uint);
187     function tab(bytes32) public returns (uint);
188     function rap(bytes32) public returns (uint);
189     function per() public returns (uint);
190     function pip() public returns (PipInterface);
191     function pep() public returns (PepInterface);
192     function tag() public returns (uint);
193     function drip() public;
194     function lad(bytes32 cup) public view returns (address);
195 }
196 
197 
198 /// @title Marketplace keeps track of all the CDPs and implements the buy logic through MarketplaceProxy
199 contract Marketplace is DSAuth, DSMath {
200 
201     struct SaleItem {
202         address payable owner;
203         address payable proxy;
204         uint discount;
205         bool active;
206     }
207  
208     mapping (bytes32 => SaleItem) public items;
209     mapping (bytes32 => uint) public itemPos;
210     bytes32[] public itemsArr;
211 
212     address public marketplaceProxy;
213 
214     // 2 decimal percision when defining the disocunt value
215     uint public fee = 100; //1% fee
216 
217     // KOVAN
218     // ProxyRegistryInterface public registry = ProxyRegistryInterface(0x64A436ae831C1672AE81F674CAb8B6775df3475C);
219     // TubInterface public tub = TubInterface(0xa71937147b55Deb8a530C7229C442Fd3F31b7db2);
220     
221     // MAINNET
222     ProxyRegistryInterface public registry = ProxyRegistryInterface(0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4);
223     TubInterface public tub = TubInterface(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
224 
225     event OnSale(bytes32 indexed cup, address indexed proxy, address owner, uint discount);
226 
227     event Bought(bytes32 indexed cup, address indexed newLad, address indexed oldProxy,
228                 address oldOwner, uint discount);
229 
230     constructor(address _marketplaceProxy) public {
231         marketplaceProxy = _marketplaceProxy;
232     }
233 
234     /// @notice User calls this method to put a CDP on sale which he must own
235     /// @dev Must be called by DSProxy contract in order to authorize for sale
236     /// @param _cup Id of the CDP that is being put on sale
237     /// @param _discount Discount of the original value, goes from 0 - 99% with 2 decimal percision
238     function putOnSale(bytes32 _cup, uint _discount) public {
239         require(isOwner(msg.sender, _cup), "msg.sender must be proxy which owns the cup");
240         require(_discount < 10000 && _discount > 100, "can't have 100% discount and must be over 1%");
241         require(tub.ink(_cup) > 0 && tub.tab(_cup) > 0, "must have collateral and debt to put on sale");
242         require(!isOnSale(_cup), "can't put a cdp on sale twice");
243 
244         address payable owner = address(uint160(DSProxyInterface(msg.sender).owner()));
245 
246         items[_cup] = SaleItem({
247             discount: _discount,
248             proxy: msg.sender,
249             owner: owner,
250             active: true
251         });
252 
253         itemsArr.push(_cup);
254         itemPos[_cup] = itemsArr.length - 1;
255 
256         emit OnSale(_cup, msg.sender, owner, _discount);
257     }
258 
259     /// @notice Any user can call this method to buy a CDP
260     /// @dev This will fail if the CDP owner was changed
261     /// @param _cup Id of the CDP you want to buy
262     function buy(bytes32 _cup, address _newOwner) public payable {
263         SaleItem storage item = items[_cup];
264 
265         require(item.active == true, "Check if cup is on sale");
266         require(item.proxy == tub.lad(_cup), "The owner must stay the same");
267 
268         uint cdpPrice;
269         uint feeAmount;
270 
271         (cdpPrice, feeAmount) = getCdpPrice(_cup);
272 
273         require(msg.value >= cdpPrice, "Check if enough ether is sent for this cup");
274 
275         item.active = false;
276 
277         // give the cup to the buyer, him becoming the lad that owns the cup
278         DSProxyInterface(item.proxy).execute(marketplaceProxy, 
279             abi.encodeWithSignature("give(bytes32,address)", _cup, _newOwner));
280 
281         item.owner.transfer(sub(cdpPrice, feeAmount)); // transfer money to the seller
282 
283         emit Bought(_cup, msg.sender, item.proxy, item.owner, item.discount);
284 
285         removeItem(_cup);
286 
287     }
288 
289     /// @notice Remove the CDP from the marketplace
290     /// @param _cup Id of the CDP
291     function cancel(bytes32 _cup) public {
292         require(isOwner(msg.sender, _cup), "msg.sender must proxy which owns the cup");
293         require(isOnSale(_cup), "only cancel cdps that are on sale");
294         
295         removeItem(_cup);
296     }
297 
298     /// @notice A only owner functon which withdraws Eth balance
299     function withdraw() public auth {
300         msg.sender.transfer(address(this).balance);
301     }
302 
303     /// @notice Calculates the price of the CDP given the discount and the fee
304     /// @param _cup Id of the CDP
305     /// @return It returns the price of the CDP and the amount needed for the contracts fee
306     function getCdpPrice(bytes32 _cup) public returns(uint, uint) {
307         SaleItem memory item = items[_cup];
308 
309         uint collateral = rmul(tub.ink(_cup), tub.per()); // collateral in Eth
310         uint govFee = wdiv(rmul(tub.tab(_cup), rdiv(tub.rap(_cup), tub.tab(_cup))), uint(tub.pip().read()));
311         uint debt = add(govFee, wdiv(tub.tab(_cup), uint(tub.pip().read()))); // debt in Eth
312 
313         uint difference = 0;
314 
315         if (item.discount > fee) {
316             difference = sub(item.discount, fee);
317         } else {
318             difference = item.discount;
319         }
320 
321         uint cdpPrice = mul(sub(collateral, debt), (sub(10000, difference))) / 10000;
322         uint feeAmount = mul(sub(collateral, debt), fee) / 10000;
323 
324         return (cdpPrice, feeAmount);
325     }
326 
327     /// @notice Used by front to fetch what is on sale
328     /// @return Returns all CDP ids that are on sale and are not closed
329     function getItemsOnSale() public view returns(bytes32[] memory arr) {
330         uint n = 0;
331 
332         arr = new bytes32[](itemsArr.length);
333         for (uint i = 0; i < itemsArr.length; ++i) {
334             if (tub.lad(itemsArr[i]) != address(0)) {
335                 arr[n] = itemsArr[i];
336                 n++;
337             }
338         }
339 
340     }
341 
342     /// @notice Helper method to check if a CDP is on sale
343     /// @return True|False depending if it is on sale
344     function isOnSale(bytes32 _cup) public view returns (bool) {
345         return items[_cup].active;
346     }
347 
348     function removeItem(bytes32 _cup) internal {
349         delete items[_cup];
350 
351         uint index = itemPos[_cup];
352         itemsArr[index] = itemsArr[itemsArr.length - 1];
353 
354         itemPos[_cup] = 0;
355         itemPos[itemsArr[itemsArr.length - 1]] = index;
356 
357         itemsArr.length--;
358     }
359 
360     function isOwner(address _owner, bytes32 _cup) internal view returns(bool) {         
361         require(tub.lad(_cup) == _owner);
362 
363         return true;
364     }
365 
366 }