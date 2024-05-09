1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36     address public owner;
37     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 }
47 
48 /**
49  * @title Crowdsale
50  * @dev Crowdsale is a base contract for managing a token crowdsale.
51  * Crowdsales have a start and end timestamps, where investors can make
52  * token purchases. Funds collected are forwarded to a wallet
53  * as they arrive.
54  */
55 contract Crowdsale is Ownable {
56     using SafeMath for uint256;
57     // address where funds are collected
58     address public wallet;
59 
60     // amount of raised money in wei
61     uint256 public weiRaised;
62 
63     uint256 public tokenAllocated;
64 
65     uint256 public hardCap = 60000 ether;
66 
67     constructor (address _wallet) public {
68         require(_wallet != address(0));
69         wallet = _wallet;
70     }
71 }
72 
73 interface IContractErc20Token {
74     function transfer(address _to, uint256 _value) external returns (bool success);
75     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
76 
77     function balanceOf(address _owner) external constant returns (uint256 balance);
78     function mint(address _to, uint256 _amount, address _owner) external returns (bool);
79 }
80 
81 
82 contract CryptoCasherCrowdsale is Ownable, Crowdsale {
83     using SafeMath for uint256;
84 
85     IContractErc20Token public tokenContract;
86 
87     mapping (address => uint256) public deposited;
88     mapping(address => bool) public whitelist;
89     // List of admins
90     mapping (address => bool) public contractAdmins;
91     mapping (address => uint256) public paidTokens;
92     uint8 constant decimals = 18;
93 
94     uint256 fundForSale = 525 * 10**5 * (10 ** uint256(decimals));
95 
96     address addressFundNonKYCReserv = 0x7AEcFB881B6Ff010E4b7fb582C562aa3FCCb2170;
97     address addressFundBlchainReferal = 0x2F9092Fe1dACafF1165b080BfF3afFa6165e339a;
98 
99     uint256[] discount  = [200, 150, 75, 50, 25, 10];
100 
101     uint256 weiMinSale = 0.1 ether;
102 
103     uint256 priceToken = 714;
104 
105     uint256 public countInvestor;
106     uint256 percentReferal = 5;
107 
108     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
109     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event NonWhitelistPurchase(address indexed _buyer, uint256 _tokens);
112     event HardCapReached();
113 
114     constructor (address _owner, address _wallet) public
115     Crowdsale(_wallet)
116     {
117         uint256 fundAdvisors = 6 * 10**6 * (10 ** uint256(decimals));
118         uint256 fundBountyRefferal = 525 * 10**4 * (10 ** uint256(decimals));
119         uint256 fundTeam = 1125 * 10**4 * (10 ** 18);
120 
121         require(_owner != address(0));
122         require(_wallet != address(0));
123         owner = _owner;
124         //owner = msg.sender; //for test's
125 
126         tokenAllocated = tokenAllocated.add(fundAdvisors).add(fundBountyRefferal).add(fundTeam);
127     }
128 
129     function setContractErc20Token(address _addressContract) public {
130         require(_addressContract != address(0));
131         tokenContract = IContractErc20Token(_addressContract);
132     }
133 
134     // fallback function can be used to buy tokens
135     function() payable public {
136         buyTokens(msg.sender);
137     }
138 
139     function setPriceToken(uint256 _newPrice) public onlyOwner {
140         require(_newPrice > 0);
141         priceToken = _newPrice;
142     }
143 
144     // low level token purchase function
145     function buyTokens(address _investor) public payable returns (uint256){
146         require(_investor != address(0));
147         uint256 weiAmount = msg.value;
148         uint256 tokens = validPurchaseTokens(weiAmount);
149         if (tokens == 0) {revert();}
150         weiRaised = weiRaised.add(weiAmount);
151         tokenAllocated = tokenAllocated.add(tokens);
152         if(whitelist[_investor]) {
153             tokenContract.mint(_investor, tokens, owner);
154         } else {
155             tokenContract.mint(addressFundNonKYCReserv, tokens, owner);
156             paidTokens[_investor] = paidTokens[_investor].add(tokens);
157             emit NonWhitelistPurchase(_investor, tokens);
158         }
159         emit TokenPurchase(_investor, weiAmount, tokens);
160         if (deposited[_investor] == 0) {
161             countInvestor = countInvestor.add(1);
162         }
163         deposit(_investor);
164         checkReferalLink(tokens);
165         wallet.transfer(weiAmount);
166         return tokens;
167     }
168 
169     function getTotalAmountOfTokens(uint256 _weiAmount) internal view returns (uint256) {
170         uint256 currentDate = now;
171         uint256 currentPeriod = getPeriod(currentDate);
172         uint256 amountOfTokens = 0;
173         if(0 <= currentPeriod && currentPeriod < 7 && _weiAmount >= weiMinSale){
174             amountOfTokens = _weiAmount.mul(priceToken).mul(discount[currentPeriod] + 1000).div(1000);
175         }
176         return amountOfTokens;
177     }
178 
179     function getPeriod(uint256 _currentDate) public pure returns (uint) {
180         //1538488800 - Tuesday, 2. October 2018 14:00:00 GMT && 1538499600 - Tuesday, 2. October 2018 17:00:00 GMT
181         if( 1538488800 <= _currentDate && _currentDate <= 1538499600){
182             return 0;
183         }
184         //1538499601  - Tuesday, 2. October 2018 17:00:01 GMT GMT && 1541167200 - Friday, 2. November 2018 14:00:00 GMT
185         if( 1538499601  <= _currentDate && _currentDate <= 1541167200){
186             return 1;
187         }
188 
189         //1541167201 - Friday, 2. November 2018 14:00:01 GMT && 1543759200 - Sunday, 2. December 2018 14:00:00 GMT
190         if( 1541167201 <= _currentDate && _currentDate <= 1543759200){
191             return 2;
192         }
193         //1543759201 - Sunday, 2. December 2018 14:00:01 GMT && 1546437600 - Wednesday, 2. January 2019 14:00:00 GMT
194         if( 1543759201 <= _currentDate && _currentDate <= 1546437600){
195             return 3;
196         }
197         //1546437601 - Wednesday, 2. January 2019 14:00:01 GMT && 1549116000 - Saturday, 2. February 2019 14:00:00 GMT
198         if( 1546437601 <= _currentDate && _currentDate <= 1549116000){
199             return 4;
200         }
201         //1549116001 - Saturday, 2. February 2019 14:00:01 GMT && 1551535200 - Saturday, 2. March 2019 14:00:00
202         if( 1549116001 <= _currentDate && _currentDate <= 1551535200){
203             return 5;
204         }
205 
206         return 10;
207     }
208 
209     function deposit(address investor) internal {
210         deposited[investor] = deposited[investor].add(msg.value);
211     }
212 
213     function checkReferalLink(uint256 _amountToken) internal returns(uint256 _refererTokens) {
214         _refererTokens = 0;
215         if(msg.data.length == 20) {
216             address referer = bytesToAddress(bytes(msg.data));
217             require(referer != msg.sender);
218             _refererTokens = _amountToken.mul(percentReferal).div(100);
219             if(tokenContract.balanceOf(addressFundBlchainReferal) >= _refererTokens.mul(2)) {
220                 tokenContract.mint(referer, _refererTokens, addressFundBlchainReferal);
221                 tokenContract.mint(msg.sender, _refererTokens, addressFundBlchainReferal);
222             }
223         }
224     }
225 
226     function bytesToAddress(bytes source) internal pure returns(address) {
227         uint result;
228         uint mul = 1;
229         for(uint i = 20; i > 0; i--) {
230             result += uint8(source[i-1])*mul;
231             mul = mul*256;
232         }
233         return address(result);
234     }
235 
236     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
237         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
238         if (tokenAllocated.add(addTokens) > fundForSale) {
239             emit TokenLimitReached(tokenAllocated, addTokens);
240             return 0;
241         }
242         if (weiRaised.add(_weiAmount) > hardCap) {
243             emit HardCapReached();
244             return 0;
245         }
246         return addTokens;
247     }
248 
249     /**
250     * @dev Add an contract admin
251     */
252     function setContractAdmin(address _admin, bool _isAdmin) external onlyOwner {
253         require(_admin != address(0));
254         contractAdmins[_admin] = _isAdmin;
255     }
256 
257     /**
258     * @dev Adds single address to whitelist.
259     * @param _beneficiary Address to be added to the whitelist
260     */
261     function addToWhitelist(address _beneficiary) external onlyOwnerOrAnyAdmin {
262         whitelist[_beneficiary] = true;
263     }
264 
265     /**
266      * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
267      * @param _beneficiaries Addresses to be added to the whitelist
268      */
269     function addManyToWhitelist(address[] _beneficiaries) external onlyOwnerOrAnyAdmin {
270         require(_beneficiaries.length < 101);
271         for (uint256 i = 0; i < _beneficiaries.length; i++) {
272             whitelist[_beneficiaries[i]] = true;
273         }
274     }
275 
276     /**
277      * @dev Removes single address from whitelist.
278      * @param _beneficiary Address to be removed to the whitelist
279      */
280     function removeFromWhitelist(address _beneficiary) external onlyOwnerOrAnyAdmin {
281         whitelist[_beneficiary] = false;
282     }
283 
284     modifier onlyOwnerOrAnyAdmin() {
285         require(msg.sender == owner || contractAdmins[msg.sender]);
286         _;
287     }
288 
289     /**
290      * Peterson's Law Protection
291      * Claim tokens
292      */
293     function claimTokens(address _token) public onlyOwner {
294         if (_token == 0x0) {
295             owner.transfer(address(this).balance);
296             return;
297         }
298 
299         uint256 balance = tokenContract.balanceOf(this);
300         tokenContract.transfer(owner, balance);
301         emit Transfer(_token, owner, balance);
302     }
303 
304     modifier onlyFundNonKYCReserv() {
305         require(msg.sender == addressFundNonKYCReserv);
306         _;
307     }
308 
309     function batchTransferPaidTokens(address[] _recipients, uint256[] _values) external onlyFundNonKYCReserv returns (bool) {
310         require( _recipients.length > 0 && _recipients.length == _values.length);
311         uint256 total = 0;
312         for(uint i = 0; i < _values.length; i++){
313             total = total.add(_values[i]);
314         }
315         require(total <= tokenContract.balanceOf(msg.sender));
316         for(uint j = 0; j < _recipients.length; j++){
317             require(0 <= _values[j]);
318             require(_values[j] <= paidTokens[_recipients[j]]);
319             paidTokens[_recipients[j]].sub(_values[j]);
320             tokenContract.transferFrom(addressFundNonKYCReserv, _recipients[j], _values[j]);
321             emit Transfer(msg.sender, _recipients[j], _values[j]);
322         }
323         return true;
324     }
325 
326     function balanceOf(address _owner) public view returns (uint256) {
327         require(_owner != address(0));
328         return tokenContract.balanceOf(_owner);
329     }
330 
331     function balanceOfNonKYC(address _owner) public view returns (uint256) {
332         require(_owner != address(0));
333         return paidTokens[_owner];
334     }
335 }