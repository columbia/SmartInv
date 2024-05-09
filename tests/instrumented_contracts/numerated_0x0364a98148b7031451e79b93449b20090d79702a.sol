1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Devery Contracts - The Monolithic Registry
5 //
6 // Deployed to Ropsten Testnet at 0x654f4a3e3B7573D6b4bB7201AB70d718961765CD
7 //
8 // Enjoy.
9 //
10 // (c) BokkyPooBah / Bok Consulting Pty Ltd for Devery 2017. The MIT Licence.
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // ERC Token Standard #20 Interface
16 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
17 // ----------------------------------------------------------------------------
18 contract ERC20Interface {
19     function totalSupply() public constant returns (uint);
20     function balanceOf(address tokenOwner) public constant returns (uint balance);
21     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
22     function transfer(address to, uint tokens) public returns (bool success);
23     function approve(address spender, uint tokens) public returns (bool success);
24     function transferFrom(address from, address to, uint tokens) public returns (bool success);
25 
26     event Transfer(address indexed from, address indexed to, uint tokens);
27     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // Owned contract
33 // ----------------------------------------------------------------------------
34 contract Owned {
35 
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function Owned() public {
47         owner = msg.sender;
48     }
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = 0x0;
57     }
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Administrators
63 // ----------------------------------------------------------------------------
64 contract Admined is Owned {
65 
66     mapping (address => bool) public admins;
67 
68     event AdminAdded(address addr);
69     event AdminRemoved(address addr);
70 
71     modifier onlyAdmin() {
72         require(isAdmin(msg.sender));
73         _;
74     }
75 
76     function isAdmin(address addr) public constant returns (bool) {
77         return (admins[addr] || owner == addr);
78     }
79     function addAdmin(address addr) public onlyOwner {
80         require(!admins[addr] && addr != owner);
81         admins[addr] = true;
82         AdminAdded(addr);
83     }
84     function removeAdmin(address addr) public onlyOwner {
85         require(admins[addr]);
86         delete admins[addr];
87         AdminRemoved(addr);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // Devery Registry
94 // ----------------------------------------------------------------------------
95 contract DeveryRegistry is Admined {
96 
97     struct App {
98         address appAccount;
99         string appName;
100         address feeAccount;
101         uint fee;
102         bool active;
103     }
104     struct Brand {
105         address brandAccount;
106         address appAccount;
107         string brandName;
108         bool active;
109     }
110     struct Product {
111         address productAccount;
112         address brandAccount;
113         string description;
114         string details;
115         uint year;
116         string origin;
117         bool active;
118     }
119 
120     ERC20Interface public token; 
121     address public feeAccount;
122     uint public fee;
123     mapping(address => App) public apps;
124     mapping(address => Brand) public brands;
125     mapping(address => Product) public products;
126     mapping(address => mapping(address => bool)) permissions;
127     mapping(bytes32 => address) markings;
128     address[] public appAccounts;
129     address[] public brandAccounts;
130     address[] public productAccounts;
131 
132     event TokenUpdated(address indexed oldToken, address indexed newToken);
133     event FeeUpdated(address indexed oldFeeAccount, address indexed newFeeAccount, uint oldFee, uint newFee);
134     event AppAdded(address indexed appAccount, string appName, address feeAccount, uint fee, bool active);
135     event AppUpdated(address indexed appAccount, string appName, address feeAccount, uint fee, bool active);
136     event BrandAdded(address indexed brandAccount, address indexed appAccount, string brandName, bool active);
137     event BrandUpdated(address indexed brandAccount, address indexed appAccount, string brandName, bool active);
138     event ProductAdded(address indexed productAccount, address indexed brandAccount, address indexed appAccount, string description, bool active);
139     event ProductUpdated(address indexed productAccount, address indexed brandAccount, address indexed appAccount, string description, bool active);
140     event Permissioned(address indexed marker, address indexed brandAccount, bool permission);
141     event Marked(address indexed marker, address indexed productAccount, address appFeeAccount, address feeAccount, uint appFee, uint fee, bytes32 itemHash);
142 
143 
144     // ------------------------------------------------------------------------
145     // Token, fee account and fee
146     // ------------------------------------------------------------------------
147     function setToken(address _token) public onlyAdmin {
148         TokenUpdated(address(token), _token);
149         token = ERC20Interface(_token);
150     }
151     function setFee(address _feeAccount, uint _fee) public onlyAdmin {
152         FeeUpdated(feeAccount, _feeAccount, fee, _fee);
153         feeAccount = _feeAccount;
154         fee = _fee;
155     }
156 
157     // ------------------------------------------------------------------------
158     // Account can add itself as an App account
159     // ------------------------------------------------------------------------
160     function addApp(string appName, address _feeAccount, uint _fee) public {
161         App storage e = apps[msg.sender];
162         require(e.appAccount == address(0));
163         apps[msg.sender] = App({
164             appAccount: msg.sender,
165             appName: appName,
166             feeAccount: _feeAccount,
167             fee: _fee,
168             active: true
169         });
170         appAccounts.push(msg.sender);
171         AppAdded(msg.sender, appName, _feeAccount, _fee, true);
172     }
173     function updateApp(string appName, address _feeAccount, uint _fee, bool active) public {
174         App storage e = apps[msg.sender];
175         require(msg.sender == e.appAccount);
176         e.appName = appName;
177         e.feeAccount = _feeAccount;
178         e.fee = _fee;
179         e.active = active;
180         AppUpdated(msg.sender, appName, _feeAccount, _fee, active);
181     }
182     function getApp(address appAccount) public constant returns (App app) {
183         app = apps[appAccount];
184     }
185     function getAppData(address appAccount) public constant returns (address _feeAccount, uint _fee, bool active) {
186         App storage e = apps[appAccount];
187         _feeAccount = e.feeAccount;
188         _fee = e.fee;
189         active = e.active;
190     }
191     function appAccountsLength() public constant returns (uint) {
192         return appAccounts.length;
193     }
194 
195     // ------------------------------------------------------------------------
196     // App account can add Brand account
197     // ------------------------------------------------------------------------
198     function addBrand(address brandAccount, string brandName) public {
199         App storage app = apps[msg.sender];
200         require(app.appAccount != address(0));
201         Brand storage brand = brands[brandAccount];
202         require(brand.brandAccount == address(0));
203         brands[brandAccount] = Brand({
204             brandAccount: brandAccount,
205             appAccount: msg.sender,
206             brandName: brandName,
207             active: true
208         });
209         brandAccounts.push(brandAccount);
210         BrandAdded(brandAccount, msg.sender, brandName, true);
211     }
212     function updateBrand(address brandAccount, string brandName, bool active) public {
213         Brand storage brand = brands[brandAccount];
214         require(brand.appAccount == msg.sender);
215         brand.brandName = brandName;
216         brand.active = active;
217         BrandUpdated(brandAccount, msg.sender, brandName, active);
218     }
219     function getBrand(address brandAccount) public constant returns (Brand brand) {
220         brand = brands[brandAccount];
221     }
222     function getBrandData(address brandAccount) public constant returns (address appAccount, address appFeeAccount, bool active) {
223         Brand storage brand = brands[brandAccount];
224         require(brand.appAccount != address(0));
225         App storage app = apps[brand.appAccount];
226         require(app.appAccount != address(0));
227         appAccount = app.appAccount;
228         appFeeAccount = app.feeAccount;
229         active = app.active && brand.active;
230     }
231     function brandAccountsLength() public constant returns (uint) {
232         return brandAccounts.length;
233     }
234 
235     // ------------------------------------------------------------------------
236     // Brand account can add Product account
237     // ------------------------------------------------------------------------
238     function addProduct(address productAccount, string description, string details, uint year, string origin) public {
239         Brand storage brand = brands[msg.sender];
240         require(brand.brandAccount != address(0));
241         App storage app = apps[brand.appAccount];
242         require(app.appAccount != address(0));
243         Product storage product = products[productAccount];
244         require(product.productAccount == address(0));
245         products[productAccount] = Product({
246             productAccount: productAccount,
247             brandAccount: msg.sender,
248             description: description,
249             details: details,
250             year: year,
251             origin: origin,
252             active: true
253         });
254         productAccounts.push(productAccount);
255         ProductAdded(productAccount, msg.sender, app.appAccount, description, true);
256     }
257     function updateProduct(address productAccount, string description, string details, uint year, string origin, bool active) public {
258         Product storage product = products[productAccount];
259         require(product.brandAccount == msg.sender);
260         Brand storage brand = brands[msg.sender];
261         require(brand.brandAccount == msg.sender);
262         App storage app = apps[brand.appAccount];
263         product.description = description;
264         product.details = details;
265         product.year = year;
266         product.origin = origin;
267         product.active = active;
268         ProductUpdated(productAccount, product.brandAccount, app.appAccount, description, active);
269     }
270     function getProduct(address productAccount) public constant returns (Product product) {
271         product = products[productAccount];
272     }
273     function getProductData(address productAccount) public constant returns (address brandAccount, address appAccount, address appFeeAccount, bool active) {
274         Product storage product = products[productAccount];
275         require(product.brandAccount != address(0));
276         Brand storage brand = brands[brandAccount];
277         require(brand.appAccount != address(0));
278         App storage app = apps[brand.appAccount];
279         require(app.appAccount != address(0));
280         brandAccount = product.brandAccount;
281         appAccount = app.appAccount;
282         appFeeAccount = app.feeAccount;
283         active = app.active && brand.active && brand.active;
284     }
285     function productAccountsLength() public constant returns (uint) {
286         return productAccounts.length;
287     }
288 
289     // ------------------------------------------------------------------------
290     // Brand account can permission accounts as markers
291     // ------------------------------------------------------------------------
292     function permissionMarker(address marker, bool permission) public {
293         Brand storage brand = brands[msg.sender];
294         require(brand.brandAccount != address(0));
295         permissions[marker][msg.sender] = permission;
296         Permissioned(marker, msg.sender, permission);
297     }
298 
299     // ------------------------------------------------------------------------
300     // Compute item hash from the public key
301     // ------------------------------------------------------------------------
302     function addressHash(address item) public pure returns (bytes32 hash) {
303         hash = keccak256(item);
304     }
305 
306     // ------------------------------------------------------------------------
307     // Markers can add [productAccount, sha3(itemPublicKey)]
308     // ------------------------------------------------------------------------
309     function mark(address productAccount, bytes32 itemHash) public {
310         Product storage product = products[productAccount];
311         require(product.brandAccount != address(0) && product.active);
312         Brand storage brand = brands[product.brandAccount];
313         require(brand.brandAccount != address(0) && brand.active);
314         App storage app = apps[brand.appAccount];
315         require(app.appAccount != address(0) && app.active);
316         bool permissioned = permissions[msg.sender][brand.brandAccount];
317         require(permissioned);
318         markings[itemHash] = productAccount;
319         Marked(msg.sender, productAccount, app.feeAccount, feeAccount, app.fee, fee, itemHash);
320         if (app.fee > 0) {
321             token.transferFrom(brand.brandAccount, app.feeAccount, app.fee);
322         }
323         if (fee > 0) {
324             token.transferFrom(brand.brandAccount, feeAccount, fee);
325         }
326     }
327 
328     // ------------------------------------------------------------------------
329     // Check itemPublicKey has been registered
330     // ------------------------------------------------------------------------
331     function check(address item) public constant returns (address productAccount, address brandAccount, address appAccount) {
332         bytes32 hash = keccak256(item);
333         productAccount = markings[hash];
334         // require(productAccount != address(0));
335         Product storage product = products[productAccount];
336         // require(product.brandAccount != address(0));
337         Brand storage brand = brands[product.brandAccount];
338         // require(brand.brandAccount != address(0));
339         brandAccount = product.brandAccount;
340         appAccount = brand.appAccount;
341     }
342 }