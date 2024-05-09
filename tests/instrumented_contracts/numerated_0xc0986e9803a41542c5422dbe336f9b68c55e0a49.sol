1 pragma solidity ^0.5.0;
2 
3 contract DSProxyInterface {
4     function execute(bytes memory _code, bytes memory _data) public payable returns (address, bytes32);
5 
6     function execute(address _target, bytes memory _data) public payable returns (bytes32);
7 
8     function setCache(address _cacheAddr) public payable returns (bool);
9 
10     function owner() public returns (address);
11 }
12 
13 contract DSMath {
14     function add(uint x, uint y) internal pure returns (uint z) {
15         require((z = x + y) >= x);
16     }
17     function sub(uint x, uint y) internal pure returns (uint z) {
18         require((z = x - y) <= x);
19     }
20     function mul(uint x, uint y) internal pure returns (uint z) {
21         require(y == 0 || (z = x * y) / y == x);
22     }
23 
24     function min(uint x, uint y) internal pure returns (uint z) {
25         return x <= y ? x : y;
26     }
27     function max(uint x, uint y) internal pure returns (uint z) {
28         return x >= y ? x : y;
29     }
30     function imin(int x, int y) internal pure returns (int z) {
31         return x <= y ? x : y;
32     }
33     function imax(int x, int y) internal pure returns (int z) {
34         return x >= y ? x : y;
35     }
36 
37     uint constant WAD = 10 ** 18;
38     uint constant RAY = 10 ** 27;
39 
40     function wmul(uint x, uint y) internal pure returns (uint z) {
41         z = add(mul(x, y), WAD / 2) / WAD;
42     }
43     function rmul(uint x, uint y) internal pure returns (uint z) {
44         z = add(mul(x, y), RAY / 2) / RAY;
45     }
46     function wdiv(uint x, uint y) internal pure returns (uint z) {
47         z = add(mul(x, WAD), y / 2) / y;
48     }
49     function rdiv(uint x, uint y) internal pure returns (uint z) {
50         z = add(mul(x, RAY), y / 2) / y;
51     }
52 
53     // This famous algorithm is called "exponentiation by squaring"
54     // and calculates x^n with x as fixed-point and n as regular unsigned.
55     //
56     // It's O(log n), instead of O(n) for naive repeated multiplication.
57     //
58     // These facts are why it works:
59     //
60     //  If n is even, then x^n = (x^2)^(n/2).
61     //  If n is odd,  then x^n = x * x^(n-1),
62     //   and applying the equation for even x gives
63     //    x^n = x * (x^2)^((n-1) / 2).
64     //
65     //  Also, EVM division is flooring and
66     //    floor[(n-1) / 2] = floor[n / 2].
67     //
68     function rpow(uint x, uint n) internal pure returns (uint z) {
69         z = n % 2 != 0 ? x : RAY;
70 
71         for (n /= 2; n != 0; n /= 2) {
72             x = rmul(x, x);
73 
74             if (n % 2 != 0) {
75                 z = rmul(z, x);
76             }
77         }
78     }
79 }
80 
81 contract DSAuthority {
82     function canCall(
83         address src, address dst, bytes4 sig
84     ) public view returns (bool);
85 }
86 
87 contract DSAuthEvents {
88     event LogSetAuthority (address indexed authority);
89     event LogSetOwner     (address indexed owner);
90 }
91 
92 contract DSAuth is DSAuthEvents {
93     DSAuthority  public  authority;
94     address      public  owner;
95 
96     constructor() public {
97         owner = msg.sender;
98         emit LogSetOwner(msg.sender);
99     }
100 
101     function setOwner(address owner_)
102         public
103         auth
104     {
105         owner = owner_;
106         emit LogSetOwner(owner);
107     }
108 
109     function setAuthority(DSAuthority authority_)
110         public
111         auth
112     {
113         authority = authority_;
114         emit LogSetAuthority(address(authority));
115     }
116 
117     modifier auth {
118         require(isAuthorized(msg.sender, msg.sig));
119         _;
120     }
121 
122     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
123         if (src == address(this)) {
124             return true;
125         } else if (src == owner) {
126             return true;
127         } else if (authority == DSAuthority(0)) {
128             return false;
129         } else {
130             return authority.canCall(src, address(this), sig);
131         }
132     }
133 }
134 
135 contract TokenInterface {
136     function allowance(address, address) public returns (uint);
137     function balanceOf(address) public returns (uint);
138     function approve(address, uint) public;
139     function transfer(address, uint) public returns (bool);
140     function transferFrom(address, address, uint) public returns (bool);
141     function deposit() public payable;
142     function withdraw(uint) public;
143 }
144 
145 contract PipInterface {
146     function read() public returns (bytes32);
147 }
148 
149 contract PepInterface {
150     function peek() public returns (bytes32, bool);
151 }
152 
153 contract VoxInterface {
154     function par() public returns (uint);
155 }
156 
157 contract TubInterface {
158     event LogNewCup(address indexed lad, bytes32 cup);
159 
160     function open() public returns (bytes32);
161     function join(uint) public;
162     function exit(uint) public;
163     function lock(bytes32, uint) public;
164     function free(bytes32, uint) public;
165     function draw(bytes32, uint) public;
166     function wipe(bytes32, uint) public;
167     function give(bytes32, address) public;
168     function shut(bytes32) public;
169     function bite(bytes32) public;
170     function cups(bytes32) public returns (address, uint, uint, uint);
171     function gem() public returns (TokenInterface);
172     function gov() public returns (TokenInterface);
173     function skr() public returns (TokenInterface);
174     function sai() public returns (TokenInterface);
175     function vox() public returns (VoxInterface);
176     function ask(uint) public returns (uint);
177     function mat() public returns (uint);
178     function chi() public returns (uint);
179     function ink(bytes32) public returns (uint);
180     function tab(bytes32) public returns (uint);
181     function rap(bytes32) public returns (uint);
182     function per() public returns (uint);
183     function pip() public returns (PipInterface);
184     function pep() public returns (PepInterface);
185     function tag() public returns (uint);
186     function drip() public;
187     function lad(bytes32 cup) public view returns (address);
188 }
189 
190 contract ProxyRegistryInterface {
191     function proxies(address _owner) public view returns(DSProxyInterface);
192     function build(address) public returns (address);
193 }
194 
195 /// @title Marketplace keeps track of all the CDPs and implements the buy logic through MarketplaceProxy
196 contract Marketplace is DSAuth, DSMath {
197 
198     struct SaleItem {
199         address payable owner;
200         address payable proxy;
201         uint discount;
202         bool active;
203     }
204  
205     mapping (bytes32 => SaleItem) public items;
206     mapping (bytes32 => uint) public itemPos;
207     bytes32[] public itemsArr;
208 
209     address public marketplaceProxy;
210 
211     // 2 decimal percision when defining the disocunt value
212     uint public fee = 100; //1% fee
213 
214     // KOVAN
215     // ProxyRegistryInterface public registry = ProxyRegistryInterface(0x64A436ae831C1672AE81F674CAb8B6775df3475C);
216     // TubInterface public tub = TubInterface(0xa71937147b55Deb8a530C7229C442Fd3F31b7db2);
217     
218     // MAINNET
219     ProxyRegistryInterface public registry = ProxyRegistryInterface(0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4);
220     TubInterface public tub = TubInterface(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
221 
222     event OnSale(bytes32 indexed cup, address indexed proxy, address owner, uint discount);
223 
224     event Bought(bytes32 indexed cup, address indexed newLad, address indexed oldProxy,
225                 address oldOwner, uint discount);
226 
227     constructor(address _marketplaceProxy) public {
228         marketplaceProxy = _marketplaceProxy;
229     }
230 
231     /// @notice User calls this method to put a CDP on sale which he must own
232     /// @dev Must be called by DSProxy contract in order to authorize for sale
233     /// @param _cup Id of the CDP that is being put on sale
234     /// @param _discount Discount of the original value, goes from 0 - 99% with 2 decimal percision
235     function putOnSale(bytes32 _cup, uint _discount) public {
236         require(isOwner(msg.sender, _cup), "msg.sender must be proxy which owns the cup");
237         require(_discount < 10000 && _discount > 100, "can't have 100% discount and must be over 1%");
238         require(tub.ink(_cup) > 0 && tub.tab(_cup) > 0, "must have collateral and debt to put on sale");
239         require(!isOnSale(_cup), "can't put a cdp on sale twice");
240 
241         address payable owner = address(uint160(DSProxyInterface(msg.sender).owner()));
242 
243         items[_cup] = SaleItem({
244             discount: _discount,
245             proxy: msg.sender,
246             owner: owner,
247             active: true
248         });
249 
250         itemsArr.push(_cup);
251         itemPos[_cup] = itemsArr.length - 1;
252 
253         emit OnSale(_cup, msg.sender, owner, _discount);
254     }
255 
256     /// @notice Any user can call this method to buy a CDP
257     /// @dev This will fail if the CDP owner was changed
258     /// @param _cup Id of the CDP you want to buy
259     function buy(bytes32 _cup, address _newOwner) public payable {
260         SaleItem storage item = items[_cup];
261 
262         require(item.active == true, "Check if cup is on sale");
263         require(item.proxy == tub.lad(_cup), "The owner must stay the same");
264 
265         uint cdpPrice;
266         uint feeAmount;
267 
268         (cdpPrice, feeAmount) = getCdpPrice(_cup);
269 
270         require(msg.value >= cdpPrice, "Check if enough ether is sent for this cup");
271 
272         item.active = false;
273 
274         // give the cup to the buyer, him becoming the lad that owns the cup
275         DSProxyInterface(item.proxy).execute(marketplaceProxy, 
276             abi.encodeWithSignature("give(bytes32,address)", _cup, _newOwner));
277 
278         item.owner.transfer(sub(cdpPrice, feeAmount)); // transfer money to the seller
279         
280         msg.sender.transfer(sub(msg.value, cdpPrice));
281 
282         emit Bought(_cup, msg.sender, item.proxy, item.owner, item.discount);
283 
284         removeItem(_cup);
285 
286     }
287 
288     /// @notice Remove the CDP from the marketplace
289     /// @param _cup Id of the CDP
290     function cancel(bytes32 _cup) public {
291         require(isOwner(msg.sender, _cup), "msg.sender must proxy which owns the cup");
292         require(isOnSale(_cup), "only cancel cdps that are on sale");
293         
294         removeItem(_cup);
295     }
296 
297     /// @notice A only owner functon which withdraws Eth balance
298     function withdraw() public auth {
299         msg.sender.transfer(address(this).balance);
300     }
301 
302     /// @notice Calculates the price of the CDP given the discount and the fee
303     /// @param _cup Id of the CDP
304     /// @return It returns the price of the CDP and the amount needed for the contracts fee
305     function getCdpPrice(bytes32 _cup) public returns(uint, uint) {
306         SaleItem memory item = items[_cup];
307 
308         uint collateral = rmul(tub.ink(_cup), tub.per()); // collateral in Eth
309         uint govFee = wdiv(rmul(tub.tab(_cup), rdiv(tub.rap(_cup), tub.tab(_cup))), uint(tub.pip().read()));
310         uint debt = add(govFee, wdiv(tub.tab(_cup), uint(tub.pip().read()))); // debt in Eth
311 
312         uint difference = 0;
313 
314         if (item.discount > fee) {
315             difference = sub(item.discount, fee);
316         } else {
317             difference = item.discount;
318         }
319 
320         uint cdpPrice = mul(sub(collateral, debt), (sub(10000, difference))) / 10000;
321         uint feeAmount = mul(sub(collateral, debt), fee) / 10000;
322 
323         return (cdpPrice, feeAmount);
324     }
325 
326     /// @notice Used by front to fetch what is on sale
327     /// @return Returns all CDP ids that are on sale and are not closed
328     function getItemsOnSale() public view returns(bytes32[] memory arr) {
329         uint n = 0;
330 
331         arr = new bytes32[](itemsArr.length);
332         for (uint i = 0; i < itemsArr.length; ++i) {
333             if (tub.lad(itemsArr[i]) != address(0)) {
334                 arr[n] = itemsArr[i];
335                 n++;
336             }
337         }
338 
339     }
340 
341     /// @notice Helper method to check if a CDP is on sale
342     /// @return True|False depending if it is on sale
343     function isOnSale(bytes32 _cup) public view returns (bool) {
344         return items[_cup].active;
345     }
346 
347     function removeItem(bytes32 _cup) internal {
348         delete items[_cup];
349 
350         uint index = itemPos[_cup];
351         itemsArr[index] = itemsArr[itemsArr.length - 1];
352 
353         itemPos[_cup] = 0;
354         itemPos[itemsArr[itemsArr.length - 1]] = index;
355 
356         itemsArr.length--;
357     }
358 
359     function isOwner(address _owner, bytes32 _cup) internal view returns(bool) {         
360         require(tub.lad(_cup) == _owner);
361 
362         return true;
363     }
364 
365 }