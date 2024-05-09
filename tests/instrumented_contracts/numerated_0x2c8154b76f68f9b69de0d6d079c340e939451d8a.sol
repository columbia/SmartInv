1 pragma solidity ^0.4.24;
2 
3 /*** @title SafeMath
4  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol */
5 library SafeMath {
6   
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) {
9       return 0;
10     }
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15   
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a / b;
18   }
19   
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24   
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 interface ERC20 {
33   function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
34   function mintFromICO(address _to, uint256 _amount) external  returns(bool);
35   function buyTokenICO(address _investor, uint256 _value) external  returns(bool);
36 }
37 
38 /**
39  * @title Ownable
40  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol */
41 contract Ownable {
42   address public owner;
43   
44   constructor() public {
45     owner = msg.sender;
46   }
47   
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 }
53 
54 /**
55  * @title MainCrowdSale
56  * @dev https://github.com/elephant-marketing/*/
57 
58 contract MainSale is Ownable {
59   
60   ERC20 public token;
61   
62   ERC20 public BuyBackContract;
63   
64   using SafeMath for uint;
65   
66   address public backEndOperator = msg.sender;
67   
68   address team = 0x550cBC2C3Ac03f8f1d950FEf755Cd664fc498036; // 10 % - founders
69   
70   address bounty = 0x8118317911B0De31502aC978e1dD38e9EeE92538; // 2 % - bounty
71   
72   
73   mapping(address=>bool) public whitelist;
74   
75   mapping(address => uint256) public investedEther;
76   
77   mapping(address => uint8) public typeOfInvestors;
78   
79   
80   uint256 public startMainSale = 1539561600; // Monday, 15-Oct-18 00:00:00 UTC
81   
82   uint256 public endMainSale = 1544831999; // Friday, 14-Dec-18 23:59:59 UTC
83   
84   
85   uint256 public stage1Sale = startMainSale + 14 days; // 0- 7  days
86   
87   uint256 public stage2Sale = startMainSale + 28 days; // 8 - 14 days
88   
89   uint256 public stage3Sale = startMainSale + 42 days; // 15 - 21  days
90   
91   
92   uint256 public investors;
93   
94   uint256 public weisRaised;
95   
96   uint256 public buyPrice; // 1 USD
97   
98   uint256 public dollarPrice;
99   
100   uint256 public soldTokensMainSale;
101   
102   uint256 public softcapMainSale = 18500000*1e18; // 18,500,000 ANG - !!! в зачет пойдут бонусные
103   
104   uint256 public hardCapMainSale = 103500000*1e18; // 103,500,000 ANG - !!! в зачет пойдут бонусные
105   
106   
107   event Authorized(address wlCandidate, uint timestamp, uint8 investorType);
108   
109   event Revoked(address wlCandidate, uint timestamp);
110   
111   event UpdateDollar(uint256 time, uint256 _rate);
112   
113   event Refund(uint256 sum, address investor);
114   
115   
116   
117   modifier backEnd() {
118     require(msg.sender == backEndOperator || msg.sender == owner);
119     _;
120   }
121   
122   
123   constructor(ERC20 _token, uint256 usdETH) public {
124     token = _token;
125     dollarPrice = usdETH;
126     buyPrice = (1e18/dollarPrice); // 1 usd
127   }
128   
129   
130   function setStartMainSale(uint256 newStartMainSale) public onlyOwner {
131     startMainSale = newStartMainSale;
132   }
133   
134   function setEndMainSale(uint256 newEndMainSale) public onlyOwner {
135     endMainSale = newEndMainSale;
136   }
137   
138   function setBackEndAddress(address newBackEndOperator) public onlyOwner {
139     backEndOperator = newBackEndOperator;
140   }
141   
142   function setBuyBackAddress(ERC20 newBuyBackAddress) public onlyOwner {
143     BuyBackContract = newBuyBackAddress;
144   }
145   
146   function setBuyPrice(uint256 _dollar) public onlyOwner {
147     dollarPrice = _dollar;
148     buyPrice = (1e18/dollarPrice); // 1 usd
149     emit UpdateDollar(now, dollarPrice);
150   }
151   
152   /*******************************************************************************
153    * Whitelist's section */
154   
155   function authorize(address wlCandidate, uint8 investorType) public backEnd  {
156     require(wlCandidate != address(0x0));
157     require(!isWhitelisted(wlCandidate));
158     require(investors == 1 || investorType == 2);
159     
160     whitelist[wlCandidate] = true;
161     investors++;
162     
163     if (investorType == 1) {
164       typeOfInvestors[wlCandidate] = 1;
165     } else {
166       typeOfInvestors[wlCandidate] = 2;
167     }
168     emit Authorized(wlCandidate, now, investorType);
169   }
170   
171   
172   function revoke(address wlCandidate) public  onlyOwner {
173     whitelist[wlCandidate] = false;
174     investors--;
175     emit Revoked(wlCandidate, now);
176   }
177   
178   
179   function isWhitelisted(address wlCandidate) internal view returns(bool) {
180     return whitelist[wlCandidate];
181   }
182   
183   
184   /*******************************************************************************
185    * Payable's section */
186   
187   function isMainSale() public constant returns(bool) {
188     return now >= startMainSale && now <= endMainSale;
189   }
190   
191   
192   function () public payable {
193     require(isWhitelisted(msg.sender));
194     require(isMainSale());
195     mainSale(msg.sender, msg.value);
196     require(soldTokensMainSale<=hardCapMainSale);
197     investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
198   }
199   
200   
201   function mainSale(address _investor, uint256 _value) internal {
202     uint256 tokens = _value.mul(1e18).div(buyPrice);
203     uint256 tokensByDate = tokens.mul(bonusDate()).div(100);
204     tokens = tokens.add(tokensByDate);
205     token.mintFromICO(_investor, tokens);
206     BuyBackContract.buyTokenICO(_investor, tokens);//Set count token for periods ICO
207     soldTokensMainSale = soldTokensMainSale.add(tokens); // only sold
208 	 
209     uint256 tokensTeam = tokens.mul(5).div(44); // 10 %
210     token.mintFromICO(team, tokensTeam);
211     
212     uint256 tokensBoynty = tokens.div(44); // 2 %
213     token.mintFromICO(bounty, tokensBoynty);
214     
215     weisRaised = weisRaised.add(_value);
216   }
217   
218   
219   function bonusDate() private view returns (uint256){
220     if (now > startMainSale && now < stage1Sale) {  // 0 - 14 days preSale
221       return 30;
222     }
223     else if (now > stage1Sale && now < stage2Sale) { // 15 - 28 days preSale
224       return 20;
225     }
226     else if (now > stage2Sale && now < stage3Sale) { // 29 - 42 days preSale
227       return 10;
228     }
229     else if (now > stage3Sale && now < endMainSale) { // 43 - endSale
230       return 6;
231     }
232     
233     else {
234       return 0;
235     }
236   }
237   
238   
239   function mintManual(address receiver, uint256 _tokens) public backEnd {
240     token.mintFromICO(receiver, _tokens);
241     soldTokensMainSale = soldTokensMainSale.add(_tokens);
242     BuyBackContract.buyTokenICO(receiver, _tokens);//Set count token for periods ICO
243 	 
244     uint256 tokensTeam = _tokens.mul(5).div(44); // 10 %
245     token.mintFromICO(team, tokensTeam);
246     
247     uint256 tokensBoynty = _tokens.div(44); // 2 %
248     token.mintFromICO(bounty, tokensBoynty);
249   }
250   
251   
252   function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
253     _to.transfer(amount);
254   }
255   
256   
257   function refundPreSale() public {
258     require(soldTokensMainSale < soldTokensMainSale && now > endMainSale);
259     uint256 rate = investedEther[msg.sender];
260     require(investedEther[msg.sender] >= 0);
261     investedEther[msg.sender] = 0;
262     msg.sender.transfer(rate);
263     weisRaised = weisRaised.sub(rate);
264     emit Refund(rate, msg.sender);
265   }
266 }