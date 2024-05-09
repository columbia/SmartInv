1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 interface ERC20 {
28     function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
29     function mintFromICO(address _to, uint256 _amount) external  returns(bool);
30 }
31 
32 contract Ownable {
33     
34     address public owner;
35     
36     constructor() public {
37         owner = msg.sender;
38     }
39     
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 }
45 
46 contract MainSale is Ownable {
47     
48     ERC20 public token;
49     
50     using SafeMath for uint;
51     
52     address public backEndOperator = msg.sender;
53     
54     address team = 0x7DDA135cDAa44Ad3D7D79AAbE562c4cEA9DEB41d; // 25% all
55     
56     address reserve = 0x34bef601666D7b2E719Ff919A04266dD07706a79; // 15% all
57     
58     mapping(address=>bool) public whitelist;
59     
60     mapping(address => uint256) public investedEther;
61     
62     uint256 public startSale = 1537228801; // Tuesday, 18-Sep-18 00:00:01 UTC
63     
64     uint256 public endSale = 1545177599; // Tuesday, 18-Dec-18 23:59:59 UTC
65     
66     uint256 public investors;
67     
68     uint256 public weisRaised;
69     
70     uint256 public dollarRaised; // collected USD
71     
72     uint256 public softCap = 2000000000*1e18; // 20,000,000 USD
73     
74     uint256 public hardCap = 7000000000*1e18; // 70,000,000 USD
75     
76     uint256 public buyPrice; //0.01 USD
77     
78     uint256 public dollarPrice;
79     
80     uint256 public soldTokens;
81     
82     uint256 step1Sum = 3000000*1e18; // 3 mln $
83     
84     uint256 step2Sum = 10000000*1e18; // 10 mln $
85     
86     uint256 step3Sum = 20000000*1e18; // 20 mln $
87     
88     uint256 step4Sum = 30000000*1e18; // 30 mln $
89     
90     
91     event Authorized(address wlCandidate, uint timestamp);
92     
93     event Revoked(address wlCandidate, uint timestamp);
94     
95     event Refund(uint rate, address investor);
96     
97     
98     modifier isUnderHardCap() {
99         require(weisRaised <= hardCap);
100         _;
101     }
102     
103     modifier backEnd() {
104         require(msg.sender == backEndOperator || msg.sender == owner);
105         _;
106     }
107     
108     
109     constructor(uint256 _dollareth) public {
110         dollarPrice = _dollareth;
111         buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent
112         hardCap = 7500000000*buyPrice;
113     }
114     
115     
116     function setToken (ERC20 _token) public onlyOwner {
117         token = _token;
118     }
119     
120     function setDollarRate(uint256 _usdether) public onlyOwner {
121         dollarPrice = _usdether;
122         buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent
123         hardCap = 7500000000*buyPrice;
124     }
125     
126     
127     function setPrice(uint256 newBuyPrice) public onlyOwner {
128         buyPrice = newBuyPrice;
129     }
130     
131     function setStartSale(uint256 newStartSale) public onlyOwner {
132         startSale = newStartSale;
133     }
134     
135     function setEndSale(uint256 newEndSaled) public onlyOwner {
136         endSale = newEndSaled;
137     }
138     
139     function setBackEndAddress(address newBackEndOperator) public onlyOwner {
140         backEndOperator = newBackEndOperator;
141     }
142     
143     /*******************************************************************************
144      * Whitelist's section */
145     
146     function authorize(address wlCandidate) public backEnd {
147         require(wlCandidate != address(0x0));
148         require(!isWhitelisted(wlCandidate));
149         whitelist[wlCandidate] = true;
150         investors++;
151         emit Authorized(wlCandidate, now);
152     }
153     
154     function revoke(address wlCandidate) public  onlyOwner {
155         whitelist[wlCandidate] = false;
156         investors--;
157         emit Revoked(wlCandidate, now);
158     }
159     
160     function isWhitelisted(address wlCandidate) public view returns(bool) {
161         return whitelist[wlCandidate];
162     }
163     
164     /*******************************************************************************
165      * Payable's section */
166     
167     function isMainSale() public constant returns(bool) {
168         return now >= startSale && now <= endSale;
169     }
170     
171     function () public payable isUnderHardCap {
172         require(isMainSale());
173         require(isWhitelisted(msg.sender));
174         require(msg.value >= 10000000000000000);
175         mainSale(msg.sender, msg.value);
176         investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
177     }
178     
179     function mainSale(address _investor, uint256 _value) internal {
180         uint256 tokens = _value.mul(1e18).div(buyPrice);
181         uint256 tokensSum = tokens.mul(discountSum(msg.value)).div(100);
182         uint256 tokensCollect = tokens.mul(discountCollect()).div(100);
183         tokens = tokens.add(tokensSum).add(tokensCollect);
184         token.mintFromICO(_investor, tokens);
185         uint256 tokensFounders = tokens.mul(5).div(12);
186         token.mintFromICO(team, tokensFounders);
187         uint256 tokensDevelopers = tokens.div(4);
188         token.mintFromICO(reserve, tokensDevelopers);
189         weisRaised = weisRaised.add(msg.value);
190         uint256 valueInUSD = msg.value.mul(dollarPrice);
191         dollarRaised = dollarRaised.add(valueInUSD);
192         soldTokens = soldTokens.add(tokens);
193     }
194     
195     
196     function discountSum(uint256 _tokens) pure private returns(uint256) {
197         if(_tokens >= 10000000*1e18) { // > 100k$ = 10,000,000 TAL
198             return 7;
199         }
200         if(_tokens >= 5000000*1e18) { // 50-100k$ = 5,000,000 TAL
201             return 5;
202         }
203         if(_tokens >= 1000000*1e18) { // 10-50k$ = 1,000,000 TAL
204             return 3;
205         } else
206             return 0;
207     }
208     
209     
210     function discountCollect() view private returns(uint256) {
211         // 20% bonus, if collected sum < 3 mln $
212         if(dollarRaised <= step1Sum) {
213             return 20;
214         } // 15% bonus, if collected sum < 10 mln $
215         if(dollarRaised <= step2Sum) {
216             return 15;
217         } // 10% bonus, if collected sum < 20 mln $
218         if(dollarRaised <= step3Sum) {
219             return 10;
220         } // 5% bonus, if collected sum < 30 mln $
221         if(dollarRaised <= step4Sum) {
222             return 5;
223         }
224         return 0;
225     }
226     
227     
228     function mintManual(address _investor, uint256 _value) public onlyOwner {
229         token.mintFromICO(_investor, _value);
230         uint256 tokensFounders = _value.mul(5).div(12);
231         token.mintFromICO(team, tokensFounders);
232         uint256 tokensDevelopers = _value.div(4);
233         token.mintFromICO(reserve, tokensDevelopers);
234     }
235     
236     
237     function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
238         require(amount != 0);
239         require(_to != 0x0);
240         _to.transfer(amount);
241     }
242     
243     
244     function refundSale() public {
245         require(soldTokens < softCap && now > endSale);
246         uint256 rate = investedEther[msg.sender];
247         require(investedEther[msg.sender] >= 0);
248         investedEther[msg.sender] = 0;
249         msg.sender.transfer(rate);
250         weisRaised = weisRaised.sub(rate);
251         emit Refund(rate, msg.sender);
252     }
253 }