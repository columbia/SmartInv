1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30     interface ERC20 {
31         function transfer(address _beneficiary, uint256 _tokenAmount) external returns (bool);
32         function transferFromICO(address _to, uint256 _value) external returns(bool);
33     }
34 
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipRenounced(address indexed previousOwner);
40   event OwnershipTransferred(
41     address indexed previousOwner,
42     address indexed newOwner
43   );
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to relinquish control of the contract.
64    * @notice Renouncing to ownership will leave the contract without an owner.
65    * It will not be possible to call the functions with the `onlyOwner`
66    * modifier anymore.
67    */
68   function renounceOwnership() public onlyOwner {
69     emit OwnershipRenounced(owner);
70     owner = address(0);
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param _newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address _newOwner) public onlyOwner {
78     _transferOwnership(_newOwner);
79   }
80 
81   /**
82    * @dev Transfers control of the contract to a newOwner.
83    * @param _newOwner The address to transfer ownership to.
84    */
85   function _transferOwnership(address _newOwner) internal {
86     require(_newOwner != address(0));
87     emit OwnershipTransferred(owner, _newOwner);
88     owner = _newOwner;
89   }
90 }
91 
92 contract MainSale is Ownable {
93 
94     using SafeMath for uint;
95 
96     ERC20 public token;
97     
98     address reserve = 0x611200beabeac749071b30db84d17ec205654463;
99     address promouters = 0x2632d043ac8bbbad07c7dabd326ade3ca4f6b53e;
100     address bounty = 0xff5a1984fade92bfb0e5fd7986186d432545b834;
101 
102     uint256 public constant decimals = 18;
103     uint256 constant dec = 10**decimals;
104 
105     mapping(address=>bool) whitelist;
106 
107     uint256 public startCloseSale = now; // start // 1.07.2018 10:00 UTC
108     uint256 public endCloseSale = 1532987999; // Monday, 30-Jul-18 23:59:59 UTC-2
109 
110     uint256 public startStage1 = 1532988001; // Tuesday, 31-Jul-18 00:00:01 UTC-2
111     uint256 public endStage1 = 1533074399; // Tuesday, 31-Jul-18 23:59:59 UTC-2
112 
113     uint256 public startStage2 = 1533074400; // Wednesday, 01-Aug-18 00:00:00 UTC-2
114     uint256 public endStage2 = 1533679199; // Tuesday, 07-Aug-18 23:59:59 UTC-2
115 
116     uint256 public startStage3 = 1533679200; // Wednesday, 08-Aug-18 00:00:00 UTC-2 
117     uint256 public endStage3 = 1535752799; // Friday, 31-Aug-18 23:59:59 UTC-2
118 
119     uint256 public buyPrice = 920000000000000000; // 0.92 Ether
120     
121     uint256 public ethUSD;
122 
123     uint256 public weisRaised = 0;
124 
125     string public stageNow = "NoSale";
126     
127     event Authorized(address wlCandidate, uint timestamp);
128     event Revoked(address wlCandidate, uint timestamp);
129 
130     constructor() public {}
131 
132     function setToken (ERC20 _token) public onlyOwner {
133         token = _token;
134     }
135     
136     /*******************************************************************************
137      * Whitelist's section
138      */
139     function authorize(address wlCandidate) public onlyOwner  {
140         require(wlCandidate != address(0x0));
141         require(!isWhitelisted(wlCandidate));
142         whitelist[wlCandidate] = true;
143         emit Authorized(wlCandidate, now);
144     }
145 
146     function revoke(address wlCandidate) public  onlyOwner {
147         whitelist[wlCandidate] = false;
148         emit Revoked(wlCandidate, now);
149     }
150 
151     function isWhitelisted(address wlCandidate) public view returns(bool) {
152         return whitelist[wlCandidate];
153     }
154     
155     /*******************************************************************************
156      * Setter's Section
157      */
158 
159     function setStartCloseSale(uint256 newStartSale) public onlyOwner {
160         startCloseSale = newStartSale;
161     }
162 
163     function setEndCloseSale(uint256 newEndSale) public onlyOwner{
164         endCloseSale = newEndSale;
165     }
166 
167     function setStartStage1(uint256 newsetStage2) public onlyOwner{
168         startStage1 = newsetStage2;
169     }
170 
171     function setEndStage1(uint256 newsetStage3) public onlyOwner{
172         endStage1 = newsetStage3;
173     }
174 
175     function setStartStage2(uint256 newsetStage4) public onlyOwner{
176         startStage2 = newsetStage4;
177     }
178 
179     function setEndStage2(uint256 newsetStage5) public onlyOwner{
180         endStage2 = newsetStage5;
181     }
182 
183     function setStartStage3(uint256 newsetStage5) public onlyOwner{
184         startStage3 = newsetStage5;
185     }
186 
187     function setEndStage3(uint256 newsetStage5) public onlyOwner{
188         endStage3 = newsetStage5;
189     }
190 
191     function setPrices(uint256 newPrice) public onlyOwner {
192         buyPrice = newPrice;
193     }
194     
195     function setETHUSD(uint256 _ethUSD) public onlyOwner { 
196         ethUSD = _ethUSD;
197     
198     
199     }
200     
201     /*******************************************************************************
202      * Payable Section
203      */
204     function ()  public payable {
205         
206         require(msg.value >= (1*1e18/ethUSD*100));
207 
208         if (now >= startCloseSale || now <= endCloseSale) {
209             require(isWhitelisted(msg.sender));
210             closeSale(msg.sender, msg.value);
211             stageNow = "Close Sale for Whitelist's members";
212             
213         } else if (now >= startStage1 || now <= endStage1) {
214             sale1(msg.sender, msg.value);
215             stageNow = "Stage 1";
216 
217         } else if (now >= startStage2 || now <= endStage2) {
218             sale2(msg.sender, msg.value);
219              stageNow = "Stage 2";
220 
221         } else if (now >= startStage3 || now <= endStage3) {
222             sale3(msg.sender, msg.value);
223              stageNow = "Stage 3";
224 
225         } else {
226             stageNow = "No Sale";
227             revert();
228         } 
229     }
230     
231     // issue token in a period of closed sales
232     function closeSale(address _investor, uint256 _value) internal {
233 
234         uint256 tokens = _value.mul(1e18).div(buyPrice); // 68%
235         uint256 bonusTokens = tokens.mul(30).div(100); // + 30% per stage
236         tokens = tokens.add(bonusTokens); 
237         token.transferFromICO(_investor, tokens);
238         weisRaised = weisRaised.add(msg.value);
239 
240         uint256 tokensReserve = tokens.mul(15).div(68); // 15 %
241         token.transferFromICO(reserve, tokensReserve);
242 
243         uint256 tokensBoynty = tokens.div(34); // 2 %
244         token.transferFromICO(bounty, tokensBoynty);
245 
246         uint256 tokensPromo = tokens.mul(15).div(68); // 15%
247         token.transferFromICO(promouters, tokensPromo);
248     }
249     
250     // the issue of tokens in period 1 sales
251     function sale1(address _investor, uint256 _value) internal {
252 
253         uint256 tokens = _value.mul(1e18).div(buyPrice); // 66% 
254 
255         uint256 bonusTokens = tokens.mul(10).div(100); // + 10% per stage
256         tokens = tokens.add(bonusTokens); // 66 %
257 
258         token.transferFromICO(_investor, tokens);
259 
260         uint256 tokensReserve = tokens.mul(5).div(22); // 15 %
261         token.transferFromICO(reserve, tokensReserve);
262 
263         uint256 tokensBoynty = tokens.mul(2).div(33); // 4 %
264         token.transferFromICO(bounty, tokensBoynty);
265 
266         uint256 tokensPromo = tokens.mul(5).div(22); // 15%
267         token.transferFromICO(promouters, tokensPromo);
268 
269         weisRaised = weisRaised.add(msg.value);
270     }
271     
272     // the issue of tokens in period 2 sales
273     function sale2(address _investor, uint256 _value) internal {
274 
275         uint256 tokens = _value.mul(1e18).div(buyPrice); // 64 %
276 
277         uint256 bonusTokens = tokens.mul(5).div(100); // + 5% 
278         tokens = tokens.add(bonusTokens);
279 
280         token.transferFromICO(_investor, tokens);
281 
282         uint256 tokensReserve = tokens.mul(15).div(64); // 15 %
283         token.transferFromICO(reserve, tokensReserve);
284 
285         uint256 tokensBoynty = tokens.mul(3).div(32); // 6 %
286         token.transferFromICO(bounty, tokensBoynty);
287 
288         uint256 tokensPromo = tokens.mul(15).div(64); // 15%
289         token.transferFromICO(promouters, tokensPromo);
290 
291         weisRaised = weisRaised.add(msg.value);
292     }
293 
294     // the issue of tokens in period 3 sales
295     function sale3(address _investor, uint256 _value) internal {
296 
297         uint256 tokens = _value.mul(1e18).div(buyPrice); // 62 %
298         token.transferFromICO(_investor, tokens);
299 
300         uint256 tokensReserve = tokens.mul(15).div(62); // 15 %
301         token.transferFromICO(reserve, tokensReserve);
302 
303         uint256 tokensBoynty = tokens.mul(4).div(31); // 8 %
304         token.transferFromICO(bounty, tokensBoynty);
305 
306         uint256 tokensPromo = tokens.mul(15).div(62); // 15%
307         token.transferFromICO(promouters, tokensPromo);
308 
309         weisRaised = weisRaised.add(msg.value);
310     }
311 
312     /*******************************************************************************
313      * Manual Management
314      */
315     function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
316         _to.transfer(amount);
317     }
318 }