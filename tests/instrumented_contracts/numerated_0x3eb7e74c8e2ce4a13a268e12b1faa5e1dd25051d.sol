1 pragma solidity ^0.4.23;
2 
3 /*** @title SafeMath
4  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol */
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 interface ERC20 {
33     function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
34     function mintFromICO(address _to, uint256 _amount) external  returns(bool);
35     function isWhitelisted(address wlCandidate) external returns(bool);
36 }
37 /**
38  * @title Ownable
39  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
40  */
41 contract Ownable {
42     address public owner;
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 }
53 
54 /**
55  * @title CrowdSale
56  * @dev https://github.com/
57  */
58 contract OneStageMainSale is Ownable {
59 
60     ERC20 public token;
61     
62     ERC20 public authorize;
63     
64     using SafeMath for uint;
65 
66     address public backEndOperator = msg.sender;
67     address team = 0x7eDE8260e573d3A3dDfc058f19309DF5a1f7397E; // 33% - team и ранние инвесторы проекта
68     address bounty = 0x0cdb839B52404d49417C8Ded6c3E2157A06CdD37; // 2% - для баунти программы
69     address reserve = 0xC032D3fCA001b73e8cC3be0B75772329395caA49; // 5%  - для резерва
70 
71     mapping(address=>bool) public whitelist;
72 
73     mapping(address => uint256) public investedEther;
74 
75     uint256 public start1StageSale = 1539561601; // Monday, 15-Oct-18 00:00:01 UTC
76     uint256 public end1StageSale = 1542326399; // Thursday, 15-Nov-18 23:59:59 UTC
77 
78     uint256 public investors; // общее количество инвесторов
79     uint256 public weisRaised; // общее колиество собранных Ether
80 
81     uint256 public softCap1Stage = 1000000*1e18; // $2,600,000 = 1,000,000 INM
82     uint256 public hardCap1Stage = 1700000*1e18; // 1,700,000 INM = $4,420,000 USD
83 
84     uint256 public buyPrice; // 2.6 USD 
85     uint256 public dollarPrice; // Ether by USD
86 
87     uint256 public soldTokens; // solded tokens - > 1,700,000 INM
88 
89     event Authorized(address wlCandidate, uint timestamp);
90     event Revoked(address wlCandidate, uint timestamp);
91     event UpdateDollar(uint256 time, uint256 _rate);
92 
93     modifier backEnd() {
94         require(msg.sender == backEndOperator || msg.sender == owner);
95         _;
96     }
97 
98     // конструктор контракта
99     constructor(ERC20 _token, ERC20 _authorize, uint256 usdETH) public {
100         token = _token;
101         authorize = _authorize;
102         dollarPrice = usdETH;
103         buyPrice = (1e17/dollarPrice)*26; // 2.60 usd
104     }
105 
106     // изменение даты начала предварительной распродажи
107     function setStartOneSale(uint256 newStart1Sale) public onlyOwner {
108         start1StageSale = newStart1Sale;
109     }
110 
111     // изменение даты окончания предварительной распродажи
112     function setEndOneSale(uint256 newEnd1Sale) public onlyOwner {
113         end1StageSale = newEnd1Sale;
114     }
115 
116     // Изменение адреса оператора бекэнда
117     function setBackEndAddress(address newBackEndOperator) public onlyOwner {
118         backEndOperator = newBackEndOperator;
119     }
120 
121     // Изменение курса доллра к эфиру
122     function setBuyPrice(uint256 _dollar) public backEnd {
123         dollarPrice = _dollar;
124         buyPrice = (1e17/dollarPrice)*26; // 2.60 usd
125         emit UpdateDollar(now, dollarPrice);
126     }
127 
128 
129     /*******************************************************************************
130      * Payable's section
131      */
132 
133     function isOneStageSale() public constant returns(bool) {
134         return now >= start1StageSale && now <= end1StageSale;
135     }
136 
137     // callback функция контракта
138     function () public payable {
139         require(authorize.isWhitelisted(msg.sender));
140         require(isOneStageSale());
141         require(msg.value >= 19*buyPrice); // ~ 50 USD
142         SaleOneStage(msg.sender, msg.value);
143         require(soldTokens<=hardCap1Stage);
144         investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
145     }
146 
147     // выпуск токенов в период предварительной распродажи
148     function SaleOneStage(address _investor, uint256 _value) internal {
149         uint256 tokens = _value.mul(1e18).div(buyPrice);
150         uint256 tokensByDate = tokens.div(10);
151         uint256 bonusSumTokens = tokens.mul(bonusSum(tokens)).div(100);
152         tokens = tokens.add(tokensByDate).add(bonusSumTokens); // 60%
153         token.mintFromICO(_investor, tokens);
154         soldTokens = soldTokens.add(tokens);
155 
156         uint256 tokensTeam = tokens.mul(11).div(20); // 33 %
157         token.mintFromICO(team, tokensTeam);
158 
159         uint256 tokensBoynty = tokens.div(30); // 2 %
160         token.mintFromICO(bounty, tokensBoynty);
161 
162         uint256 tokensReserve = tokens.div(12);  // 5 %
163         token.mintFromICO(reserve, tokensReserve);
164 
165         weisRaised = weisRaised.add(_value);
166     }
167 
168     function bonusSum(uint256 _amount) pure private returns(uint256) {
169         if (_amount > 76923*1e18) { // 200k+	10% INMCoin
170             return 10;
171         } else if (_amount > 19230*1e18) { // 50k - 200k	7% INMCoin
172             return 7;
173         } else if (_amount > 7692*1e18) { // 20k - 50k	5% INMCoin
174             return 5;
175         } else if (_amount > 1923*1e18) { // 5k - 20k	3% INMCoin
176             return 3;
177         } else {
178             return 0;
179         }
180     }
181 
182     // Отправка эфира с контракта
183     function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
184         _to.transfer(amount);
185     }
186 
187     /*******************************************************************************
188      * Refundable
189      */
190     function refund1ICO() public {
191         require(soldTokens < softCap1Stage && now > end1StageSale);
192         uint rate = investedEther[msg.sender];
193         require(investedEther[msg.sender] >= 0);
194         investedEther[msg.sender] = 0;
195         msg.sender.transfer(rate);
196         weisRaised = weisRaised.sub(rate);
197     }
198 }