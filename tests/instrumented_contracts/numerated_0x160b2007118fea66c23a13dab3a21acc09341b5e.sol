1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 interface ERC20 {
28   function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
29   function mintFromICO(address _to, uint256 _amount) external  returns(bool);
30 }
31 
32 contract Ownable {
33   
34   address public owner;
35   
36   constructor() public {
37     owner = msg.sender;
38   }
39   
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 }
45 
46 contract CloseSale is Ownable {
47   
48   ERC20 public token;
49   
50   using SafeMath for uint;
51   
52   address public backEndOperator = msg.sender;
53   
54   address team = 0x7DDA135cDAa44Ad3D7D79AAbE562c4cEA9DEB41d; // 25% all
55   
56   address reserve = 0x34bef601666D7b2E719Ff919A04266dD07706a79; // 15% all
57   
58   mapping(address=>bool) public whitelist;
59   
60   uint256 public startCloseSale = 1527638401; // Wednesday, 30-May-18 00:00:01 UTC
61   
62   uint256 public endCloseSale = 1537228799; // Monday, 17-Sep-18 23:59:59 UTC
63   
64   uint256 public investors;
65   
66   uint256 public weisRaised;
67   
68   uint256 public dollarRaised;
69   
70   uint256 public buyPrice; //0.01 USD
71   
72   uint256 public dollarPrice;
73   
74   uint256 public soldTokens;
75   
76   event Authorized(address wlCandidate, uint timestamp);
77   
78   event Revoked(address wlCandidate, uint timestamp);
79   
80   
81   modifier backEnd() {
82     require(msg.sender == backEndOperator || msg.sender == owner);
83     _;
84   }
85   
86   
87   constructor(uint256 _dollareth) public {
88     dollarPrice = _dollareth;
89     buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent
90   }
91   
92   
93   function setToken (ERC20 _token) public onlyOwner {
94     token = _token;
95   }
96   
97   function setDollarRate(uint256 _usdether) public onlyOwner {
98     dollarPrice = _usdether;
99     buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent
100   }
101   
102   function setPrice(uint256 newBuyPrice) public onlyOwner {
103     buyPrice = newBuyPrice;
104   }
105   
106   function setStartSale(uint256 newStartCloseSale) public onlyOwner {
107     startCloseSale = newStartCloseSale;
108   }
109   
110   function setEndSale(uint256 newEndCloseSaled) public onlyOwner {
111     endCloseSale = newEndCloseSaled;
112   }
113   
114   function setBackEndAddress(address newBackEndOperator) public onlyOwner {
115     backEndOperator = newBackEndOperator;
116   }
117   
118   /*******************************************************************************
119    * Whitelist's section */
120   
121   
122   function authorize(address wlCandidate) public backEnd  {
123     require(wlCandidate != address(0x0));
124     require(!isWhitelisted(wlCandidate));
125     whitelist[wlCandidate] = true;
126     investors++;
127     emit Authorized(wlCandidate, now);
128   }
129   
130   
131   function revoke(address wlCandidate) public  onlyOwner {
132     whitelist[wlCandidate] = false;
133     investors--;
134     emit Revoked(wlCandidate, now);
135   }
136   
137   
138   function isWhitelisted(address wlCandidate) public view returns(bool) {
139     return whitelist[wlCandidate];
140   }
141   
142   /*******************************************************************************
143    * Payable's section */
144   
145   
146   function isCloseSale() public constant returns(bool) {
147     return now >= startCloseSale && now <= endCloseSale;
148   }
149   
150   
151   function () public payable {
152     require(isCloseSale());
153     require(isWhitelisted(msg.sender));
154     closeSale(msg.sender, msg.value);
155   }
156   
157   
158   function closeSale(address _investor, uint256 _value) internal {
159     uint256 tokens = _value.mul(1e18).div(buyPrice);
160     token.mintFromICO(_investor, tokens);
161     
162     uint256 tokensFounders = tokens.mul(5).div(12);
163     token.mintFromICO(team, tokensFounders);
164     
165     uint256 tokensDevelopers = tokens.div(4);
166     token.mintFromICO(reserve, tokensDevelopers);
167     
168     weisRaised = weisRaised.add(msg.value);
169     uint256 valueInUSD = msg.value.mul(dollarPrice);
170     dollarRaised = dollarRaised.add(valueInUSD);
171     soldTokens = soldTokens.add(tokens);
172   }
173   
174   
175   function mintManual(address _investor, uint256 _value) public onlyOwner {
176     token.mintFromICO(_investor, _value);
177     uint256 tokensFounders = _value.mul(5).div(12);
178     token.mintFromICO(team, tokensFounders);
179     uint256 tokensDevelopers = _value.div(4);
180     token.mintFromICO(reserve, tokensDevelopers);
181   }
182   
183   
184   function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
185     require(amount != 0);
186     require(_to != 0x0);
187     _to.transfer(amount);
188   }
189 }