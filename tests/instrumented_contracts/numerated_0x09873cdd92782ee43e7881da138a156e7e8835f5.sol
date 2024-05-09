1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 
16         uint256 c = a / b;
17 
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35 
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40     function Ownable() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 }
56 
57 
58 contract BurnableToken {
59     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool);
60 
61     function allowance(address _owner, address _spender) public view returns (uint256);
62 
63     function approve(address _spender, uint256 _value) public returns (bool);
64 
65     function balanceOf(address _owner) public view returns (uint256 balance);
66 
67     function burn(uint256 _value) public;
68 
69     ArnaCrowdsale public  crowdsale;
70 
71     function increaseApproval(address _spender, uint _addedValue) public returns (bool);
72 
73     address public owner;
74 
75     function setCrowdsale(ArnaCrowdsale _crowdsale) public;
76 
77     function setTransferable(bool _transferable) public;
78 
79     uint256 public totalSupply;
80 
81     function transfer(address _to, uint256 _value) public returns (bool);
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
84 
85     function transferOwnership(address newOwner) public;
86 
87     bool public transferable;
88 }
89 
90 
91 contract ArnaToken is BurnableToken {
92     string public constant name = "ArnaToken";
93     string public constant symbol = "ARNA";
94     uint8 public constant decimals = 18;
95     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
96 
97     function init() public;
98 
99 }
100 
101 //========================================
102 
103 
104 
105 contract ArnaVault is Ownable {
106     using SafeMath for uint256;
107     ArnaToken token;
108 
109     uint256 amount;
110 
111     uint256 public withdrawn = 0;
112 
113     uint startTime;
114 
115     uint period;
116 
117     uint256 percent;
118 
119     address beneficiary;
120 
121     function ArnaVault(ArnaToken _token, uint _period, uint256 _percent, address _beneficiary) public {
122         token = _token;
123         period = _period;
124         percent = _percent;
125         // 2500 -> 2.5%
126         beneficiary = _beneficiary;
127     }
128 
129     function tokensInVault() public constant returns (uint256){
130         return token.balanceOf(this);
131     }
132 
133     function start() public onlyOwner {
134         assert(token.balanceOf(this) > 0);
135         amount = token.balanceOf(this);
136         startTime = block.timestamp;
137     }
138 
139     function tokensAvailable() public constant returns (uint256){
140         return (((block.timestamp - startTime) / period + 1)
141         * amount * percent / 100000)
142         .sub(withdrawn);
143     }
144 
145     function withdraw() public {
146         assert(msg.sender == beneficiary || msg.sender == owner);
147         assert(tokensAvailable() > 0);
148         token.transfer(beneficiary, tokensAvailable());
149         withdrawn = withdrawn.add(tokensAvailable());
150     }
151 
152 }
153 
154 
155 //========================================
156 
157 contract ArnaCrowdsale is Ownable {
158     using SafeMath for uint256;
159     ArnaControl arnaControl;
160 
161     ArnaToken public token;
162 
163     uint256 public totalRise;
164 
165 
166     function ArnaCrowdsale(ArnaControl _arnaControl, ArnaToken _token) public {
167         arnaControl = _arnaControl;
168         token = _token;
169     }
170 
171     function tokensToSale() public view returns (uint256){
172         return token.balanceOf(this);
173     }
174 
175     function burnUnsold() public onlyOwner returns (uint256){
176         uint256 unsold = token.balanceOf(this);
177         token.burn(unsold);
178         return unsold;
179     }
180 
181     function price() public constant returns (uint256) {
182         return arnaControl.getPrice();
183     }
184 
185     function priceWithBonus() public constant returns (uint256) {
186         return arnaControl.getPriceWithBonus();
187     }
188 
189     function() public payable {
190         uint256 amount = msg.value.mul(1 ether).div(priceWithBonus());
191         assert(token.balanceOf(this) > amount);
192         token.transfer(msg.sender, amount);
193         totalRise = totalRise.add(msg.value);
194     }
195 
196     function sendTokens(address beneficiary, uint256 amount) public onlyOwner {
197         assert(token.balanceOf(this) > amount);
198         token.transfer(beneficiary, amount);
199         totalRise = totalRise.add(amount.mul(priceWithBonus()));
200     }
201 
202     function withdraw() public onlyOwner returns (bool) {
203         return arnaControl.send(this.balance);
204     }
205 
206 }
207 
208 
209 //========================================
210 
211 contract ArnaControl is Ownable {
212     using SafeMath for uint256;
213     ArnaToken public token;
214 
215     ArnaCrowdsale public  crowdsale;
216 
217     ArnaVault public founders;
218 
219     ArnaVault public team;
220 
221     //    ArnaVault public partners;
222 
223     bool public isStarted;
224 
225     bool public isStoped;
226 
227     uint256 constant TO_SALE = 500000000 * (10 ** 18);
228 
229     uint256  price = 0.000266 ether;
230 
231     uint256  priceWithBonus = 0.000266 ether; //  15% => 0.000231304 ether;
232 
233     address public coldWallet;
234 
235     function init(ArnaToken _arnaToken) public onlyOwner {
236         token = _arnaToken;
237         token.init();
238         coldWallet = msg.sender;
239     }
240 
241     function SaleStop() public onlyOwner {
242         assert(isStarted);
243         assert(!isStoped);
244 
245         setTransferable(true);
246 
247         uint256 toBurn = crowdsale.burnUnsold();
248         token.burn(toBurn);
249 
250         uint256 toFounders = thisContactsTokens().div(5);
251         // 100 / 500
252         uint256 toPartners = thisContactsTokens().div(2);
253         // 250 / 500
254         uint256 toTeam = thisContactsTokens().sub(toFounders).sub(toPartners);
255         // 150 / 500
256 
257 
258         founders = new ArnaVault(token, 360 days, 50000, address(0xC041CB562e4C398710dF38eAED539b943641f7b1));
259         token.transfer(founders, toFounders);
260         founders.start();
261 
262         team = new ArnaVault(token, 180 days, 16667, address(0x2ABfE4e1809659ab60eB0053cC799b316afCc556));
263         token.transfer(team, toTeam);
264         team.start();
265 
266         //        partners = new ArnaVault(token, 0, 100000,  0xd6496BBd13ae8C4Bdeea68799F678a1456B62f23);
267         //        token.transfer(partners, thisContactsTokens().div(2));
268         //        partners.start();
269 
270         token.transfer(address(0xd6496BBd13ae8C4Bdeea68799F678a1456B62f23), toPartners);
271 
272 
273         isStarted = false;
274         isStoped = true;
275     }
276 
277     function SaleStart() public onlyOwner {
278         assert(!isStarted);
279         assert(!isStoped);
280         crowdsale = new ArnaCrowdsale(this, token);
281         token.setCrowdsale(crowdsale);
282         token.transfer(crowdsale, TO_SALE);
283         isStarted = true;
284     }
285 
286     function thisContactsTokens() public constant returns (uint256){
287         return token.balanceOf(this);
288     }
289 
290     function getPrice() public constant returns (uint256){
291         return price;
292     }
293 
294     // _newPrice : 266 => 0.000266
295     function setPrice(uint256 _newPrice) public onlyOwner {
296         assert(_newPrice > 0);
297         price = _newPrice * (10 ** 12);
298     }
299 
300     function getPriceWithBonus() public constant returns (uint256){
301         return priceWithBonus;
302     }
303 
304     // _newPrice : 266 => 0.000266
305     function setPriceWithBonus(uint256 _newPrice) public onlyOwner {
306         assert(_newPrice > 0);
307         assert(_newPrice * (10 ** 12) <= price);
308         priceWithBonus = _newPrice * (10 ** 12);
309     }
310 
311 
312     function() public payable {
313         // this for withdraw from ArnaCrowdsale
314     }
315 
316     function setColdWallet(address _coldWallet) public onlyOwner {
317         coldWallet = _coldWallet;
318     }
319 
320     function withdraw() public onlyOwner returns (bool) {
321         if (crowdsale.balance > 0)
322             crowdsale.withdraw();
323         return coldWallet.send(this.balance);
324     }
325 
326     // amount : 12345000 => 12.345000 ARNA = 12345000000000000000;
327     function sendTokens(address beneficiary, uint256 amount) public onlyOwner {
328         crowdsale.sendTokens(beneficiary, amount * (10 ** 12));
329     }
330 
331     function setTransferable(bool _transferable) public onlyOwner {
332         token.setTransferable(_transferable);
333     }
334 
335     //refund if the softcap is not reached
336     function refund(address beneficiary, uint256 amount) public onlyOwner returns(bool){
337         if (crowdsale.balance > 0)
338             crowdsale.withdraw();
339         assert(crowdsale.balance + this.balance >= amount);
340         return beneficiary.send(amount);
341     }
342 }