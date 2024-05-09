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
55  * @title PreCrowdSale
56  * @dev https://github.com/elephant-marketing/*/
57 
58 contract PreSale is Ownable {
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
77   
78   uint256 public startPreSale = 1535932801; // Monday, 03-Sep-18 00:00:01 UTC
79   
80   uint256 public endPreSale = 1538524799; // Tuesday, 02-Oct-18 23:59:59 UTC
81   
82   
83   uint256 stage1Sale = startPreSale + 7 days; // 0- 7  days
84   
85   uint256 stage2Sale = startPreSale + 14 days; // 8 - 14 days
86   
87   uint256 stage3Sale = startPreSale + 21 days; // 15 - 21  days
88   
89   
90   uint256 public investors;
91   
92   uint256 public weisRaised;
93   
94   uint256 public buyPrice; // 1 USD
95   
96   uint256 public dollarPrice;
97   
98   uint256 public soldTokensPreSale;
99   
100   uint256 public softcapPreSale = 2000000*1e18; // 2,000,000 ANG - !!! в зачет пойдут бонусные
101   
102   uint256 public hardCapPreSale = 13800000*1e18; // 13,800,000 ANG - !!! в зачет пойдут бонусные
103   
104   
105   event Authorized(address wlCandidate, uint timestamp);
106   
107   event Revoked(address wlCandidate, uint timestamp);
108   
109   event UpdateDollar(uint256 time, uint256 _rate);
110   
111   event Refund(uint256 sum, address investor);
112   
113   
114   
115   modifier backEnd() {
116     require(msg.sender == backEndOperator || msg.sender == owner);
117     _;
118   }
119   
120   
121   constructor(ERC20 _token, uint256 usdETH) public {
122     token = _token;
123     dollarPrice = usdETH;
124     buyPrice = (1e18/dollarPrice); // 1 usd
125   }
126   
127   
128   function setStartPreSale(uint256 newStartPreSale) public onlyOwner {
129     startPreSale = newStartPreSale;
130   }
131   
132   function setEndPreSale(uint256 newEndPreSale) public onlyOwner {
133     endPreSale = newEndPreSale;
134   }
135   
136   function setBackEndAddress(address newBackEndOperator) public onlyOwner {
137     backEndOperator = newBackEndOperator;
138   }
139   
140   function setBuyBackAddress(ERC20 newBuyBackAddress) public onlyOwner {
141     BuyBackContract = newBuyBackAddress;
142   }
143   
144   function setBuyPrice(uint256 _dollar) public onlyOwner {
145     dollarPrice = _dollar;
146     buyPrice = (1e18/dollarPrice); // 1 usd
147     emit UpdateDollar(now, dollarPrice);
148   }
149   
150   /*******************************************************************************
151    * Whitelist's section */
152   
153   function authorize(address wlCandidate) public backEnd  {
154     require(wlCandidate != address(0x0));
155     require(!isWhitelisted(wlCandidate));
156     whitelist[wlCandidate] = true;
157     investors++;
158     emit Authorized(wlCandidate, now);
159   }
160   
161   function revoke(address wlCandidate) public  onlyOwner {
162     whitelist[wlCandidate] = false;
163     investors--;
164     emit Revoked(wlCandidate, now);
165   }
166   
167   function isWhitelisted(address wlCandidate) internal view returns(bool) {
168     return whitelist[wlCandidate];
169   }
170   
171   /*******************************************************************************
172    * Payable's section */
173   
174   function isPreSale() public constant returns(bool) {
175     return now >= startPreSale && now <= endPreSale;
176   }
177   
178   
179   function () public payable {
180     require(isWhitelisted(msg.sender));
181     require(isPreSale());
182     preSale(msg.sender, msg.value);
183     require(soldTokensPreSale<=hardCapPreSale);
184     investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
185   }
186   
187   
188   function preSale(address _investor, uint256 _value) internal {
189     uint256 tokens = _value.mul(1e18).div(buyPrice);
190     uint256 tokensByDate = tokens.mul(bonusDate()).div(100);
191     tokens = tokens.add(tokensByDate);
192     token.mintFromICO(_investor, tokens);
193 	
194     BuyBackContract.buyTokenICO(_investor, tokens);//Set count token for periods ICO
195 	
196     soldTokensPreSale = soldTokensPreSale.add(tokens); // only sold
197     
198     uint256 tokensTeam = tokens.mul(5).div(44); // 10 %
199     token.mintFromICO(team, tokensTeam);
200     
201     uint256 tokensBoynty = tokens.div(44); // 2 %
202     token.mintFromICO(bounty, tokensBoynty);
203     
204     weisRaised = weisRaised.add(_value);
205   }
206   
207   
208   function bonusDate() private view returns (uint256){
209     if (now > startPreSale && now < stage1Sale) {  // 0 - 7 days preSale
210       return 72;
211     }
212     else if (now > stage1Sale && now < stage2Sale) { // 8 - 14 days preSale
213       return 60;
214     }
215     else if (now > stage2Sale && now < stage3Sale) { // 15 - 21 days preSale
216       return 50;
217     }
218     else if (now > stage3Sale && now < endPreSale) { // 22 - endSale
219       return 40;
220     }
221     
222     else {
223       return 0;
224     }
225   }
226   
227   function mintManual(address receiver, uint256 _tokens) public backEnd {
228     token.mintFromICO(receiver, _tokens);
229     soldTokensPreSale = soldTokensPreSale.add(_tokens);
230     BuyBackContract.buyTokenICO(receiver, _tokens);//Set count token for periods ICO
231      
232     uint256 tokensTeam = _tokens.mul(5).div(44); // 10 %
233     token.mintFromICO(team, tokensTeam);
234     
235     uint256 tokensBoynty = _tokens.div(44); // 2 %
236     token.mintFromICO(bounty, tokensBoynty);
237   }
238   
239   
240   function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
241     _to.transfer(amount);
242   }
243   
244   
245   function refundPreSale() public {
246     require(soldTokensPreSale < softcapPreSale && now > endPreSale);
247     uint256 rate = investedEther[msg.sender];
248     require(investedEther[msg.sender] >= 0);
249     investedEther[msg.sender] = 0;
250     msg.sender.transfer(rate);
251     weisRaised = weisRaised.sub(rate);
252     emit Refund(rate, msg.sender);
253   }
254 }