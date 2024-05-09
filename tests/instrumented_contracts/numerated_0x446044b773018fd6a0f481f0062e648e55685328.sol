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
35   function isWhitelisted(address wlCandidate) external returns(bool);
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
62   ERC20 public authorize;
63 
64   using SafeMath for uint;
65 
66   address public backEndOperator = msg.sender;
67 
68   address team = 0xe56E60dE6d2649d9Cd0c82cb1f9d00365f07BA92; // 10 % - founders
69 
70   address bounty = 0x5731340239D8105F9F4e436021Ad29D3098AB6f8; // 2 % - bounty
71 
72 
73   mapping(address => uint256) public investedEther;
74 
75 
76   uint256 public startPreSale = 1539561600; // Monday, 15 October 2018 г., 0:00:00
77 
78   uint256 public endPreSale = 1542240000; // Thursday, 15 November 2018 г., 0:00:00
79 
80 
81   uint256 stage1Sale = startPreSale + 2 days; // 0- 2  days
82 
83   uint256 stage2Sale = startPreSale + 10 days; // 3 - 10 days
84 
85   uint256 stage3Sale = startPreSale + 18 days; // 11 - 18  days
86 
87   uint256 stage4Sale = startPreSale + 26 days; // 19 - 26 days
88 
89   uint256 stage5Sale = startPreSale + 31 days; // 27 - 31  days
90 
91   uint256 public weisRaised;
92 
93   uint256 public buyPrice; // 1 USD
94 
95   uint256 public dollarPrice;
96 
97   uint256 public soldTokensPreSale;
98 
99   uint256 public softcapPreSale = 4200000*1e18; // 4,200,000 VIONcoin
100 
101   uint256 public hardCapPreSale = 34200000*1e18; // 34,200,000 VIONcoin
102 
103   event UpdateDollar(uint256 time, uint256 _rate);
104 
105   event Refund(uint256 sum, address investor);
106 
107 
108 
109   modifier backEnd() {
110     require(msg.sender == backEndOperator || msg.sender == owner);
111     _;
112   }
113 
114 
115   constructor(ERC20 _token,ERC20 _authorize, uint256 usdETH) public {
116     token = _token;
117     authorize = _authorize;
118     dollarPrice = usdETH;
119     buyPrice = (1e18/dollarPrice).div(10); // 0.1 usd
120   }
121 
122 
123   function setStartPreSale(uint256 newStartPreSale) public onlyOwner {
124     startPreSale = newStartPreSale;
125   }
126 
127   function setEndPreSale(uint256 newEndPreSale) public onlyOwner {
128     endPreSale = newEndPreSale;
129   }
130 
131   function setBackEndAddress(address newBackEndOperator) public onlyOwner {
132     backEndOperator = newBackEndOperator;
133   }
134 
135   function setBuyPrice(uint256 _dollar) public backEnd {
136     dollarPrice = _dollar;
137     buyPrice = (1e18/dollarPrice).div(10); // 0.1 usd
138     emit UpdateDollar(now, dollarPrice);
139   }
140 
141 
142   /*******************************************************************************
143    * Payable's section */
144 
145   function isPreSale() public constant returns(bool) {
146     return now >= startPreSale && now <= endPreSale;
147   }
148 
149 
150   function () public payable {
151     require(authorize.isWhitelisted(msg.sender));
152     require(isPreSale());
153     preSale(msg.sender, msg.value);
154     require(soldTokensPreSale<=hardCapPreSale);
155     investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
156   }
157 
158 
159   function preSale(address _investor, uint256 _value) internal {
160     uint256 tokens = _value.mul(1e18).div(buyPrice);
161     uint256 tokensByDate = tokens.mul(bonusDate()).div(100);
162     tokens = tokens.add(tokensByDate);
163     token.mintFromICO(_investor, tokens);
164     soldTokensPreSale = soldTokensPreSale.add(tokens); // only sold
165 
166     uint256 tokensTeam = tokens.mul(10).div(44); // 20 %
167     token.mintFromICO(team, tokensTeam);
168 
169     uint256 tokensBoynty = tokens.mul(3).div(200); // 1.5 %
170     token.mintFromICO(bounty, tokensBoynty);
171 
172     weisRaised = weisRaised.add(_value);
173   }
174 
175 
176   function bonusDate() private view returns (uint256){
177     if (now > startPreSale && now < stage1Sale) {  // 0 - 2 days preSale
178       return 50;
179     }
180     else if (now > stage1Sale && now < stage2Sale) { // 3 - 10 days preSale
181       return 40;
182     }
183     else if (now > stage2Sale && now < stage3Sale) { // 11 - 18 days preSale
184       return 33;
185     }
186     else if (now > stage3Sale && now < stage4Sale) { // 19 - 26 days preSale
187       return 30;
188     }
189     else if (now > stage4Sale && now < stage5Sale) { // 27 - 31 days preSale
190       return 25;
191     }
192 
193     else {
194       return 0;
195     }
196   }
197 
198   function mintManual(address receiver, uint256 _tokens) public backEnd {
199     token.mintFromICO(receiver, _tokens);
200     soldTokensPreSale = soldTokensPreSale.add(_tokens);
201 
202     uint256 tokensTeam = _tokens.mul(10).div(44); // 20 %
203     token.mintFromICO(team, tokensTeam);
204 
205     uint256 tokensBoynty = _tokens.mul(3).div(200); // 1.5 %
206     token.mintFromICO(bounty, tokensBoynty);
207   }
208 
209 
210   function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
211     _to.transfer(amount);
212   }
213 
214 
215   function refundPreSale() public {
216     require(soldTokensPreSale < softcapPreSale && now > endPreSale);
217     uint256 rate = investedEther[msg.sender];
218     require(investedEther[msg.sender] >= 0);
219     investedEther[msg.sender] = 0;
220     msg.sender.transfer(rate);
221     weisRaised = weisRaised.sub(rate);
222     emit Refund(rate, msg.sender);
223   }
224 }