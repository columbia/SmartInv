1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  */
6 library SafeMath {
7 
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 interface ERC20 {
34     function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
35     function mintFromICO(address _to, uint256 _amount) external  returns(bool);
36 }
37 /**
38  * @title Ownable
39  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address newOwner) public onlyOwner {
59         require(newOwner != address(0));
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62     }
63 }
64 
65 contract GlowSale is Ownable {
66 
67     ERC20 public token;
68 
69     using SafeMath for uint;
70 
71     address public backEndOperator = msg.sender;
72     address founders = 0x2ed2de73f7aB776A6DB15A30ad7CB8f337CF499D; // 30% - основантели проекта
73     address bounty = 0x7a3B004E8A68BCD6C5D0c3936D2f582Acb89E5DD; // 10% - для баунти программы
74     address reserve = 0xd9DADf245d04fB1566e7330be591445Ad9953476; // 10% - для резерва
75 
76     mapping(address=>bool) public whitelist;
77 
78     uint256 public startPreSale = now; //1529020801; // Thursday, 15-Jun-18 00:00:01 UTC
79     uint256 public endPreSale = 1535759999; // Friday, 31-Aug-18 23:59:59 UTC
80     uint256 public startMainSale = 1538352001; // Monday, 01-Oct-18 00:00:01 UTC
81     uint256 public endMainSale = 1554076799; // Sunday, 31-Mar-19 23:59:59 UTC
82 
83     uint256 public investors; // общее количество инвесторов
84     uint256 public weisRaised; // - общее количество эфира собранное в период сейла
85 
86     uint256 hardCapPreSale = 3200000*1e6; //  3 200 000 tokens
87     uint256 hardCapSale = 15000000*1e6; // 15 000 000 tokens
88 
89     uint256 public preSalePrice; // 0.50 $ - цена токена на предварительной распродаже
90     uint256 public MainSalePrice; //1.00 $ - цена токена на основной распродаже
91     uint256 public dollarPrice; // цена Ether к USD
92 
93     uint256 public soldTokensPreSale; // 3 200 000 - количество проданных на предварительной расопродаже токенов
94     uint256 public soldTokensSale; // 36 400 000 - количество проданных на основной распродаже токенов
95 
96     event Finalized();
97     event Authorized(address wlCandidate, uint timestamp);
98     event Revoked(address wlCandidate, uint timestamp);
99 
100     modifier isUnderHardCap() {
101         require(weisRaised <= hardCapSale);
102         _;
103     }
104 
105     modifier backEnd() {
106         require(msg.sender == backEndOperator || msg.sender == owner);
107         _;
108     }
109     // конструктор контракта
110     constructor(uint256 _dollareth) public {
111         dollarPrice = _dollareth;
112         preSalePrice = (1e18/dollarPrice)/2; // 16 знаков потому что 1 цент !!!!!!!!!!!!
113         MainSalePrice = 1e18/dollarPrice;
114     }
115     // авторизация токена/ или изменение адреса
116     function setToken (ERC20 _token) public onlyOwner {
117         token = _token;
118     }
119     // изменение цены Ether к USD
120     function setDollarRate(uint256 _usdether) public onlyOwner {
121         dollarPrice = _usdether;
122         preSalePrice = (1e18/dollarPrice)/2; // 16 знаков потому что 1 цент !!!!!!!!!!!!
123         MainSalePrice = 1e18/dollarPrice;
124     }
125     // изменение даты начала предварительной распродажи
126     function setStartPreSale(uint256 newStartPreSale) public onlyOwner {
127         startPreSale = newStartPreSale;
128     }
129     // изменение даты окончания предварительной распродажи
130     function setEndPreSale(uint256 newEndPreSaled) public onlyOwner {
131         endPreSale = newEndPreSaled;
132     }
133     // изменение даты начала основной распродажи
134     function setStartSale(uint256 newStartSale) public onlyOwner {
135         startMainSale = newStartSale;
136     }
137     // изменение даты окончания основной распродажи
138     function setEndSale(uint256 newEndSaled) public onlyOwner {
139         endMainSale = newEndSaled;
140     }
141     // Изменение адреса оператора бекэнда
142     function setBackEndAddress(address newBackEndOperator) public onlyOwner {
143         backEndOperator = newBackEndOperator;
144     }
145 
146     /*******************************************************************************
147      * Whitelist's section
148      */
149     // с сайта backEndOperator авторизует инвестора
150     function authorize(address wlCandidate) public backEnd  {
151 
152         require(wlCandidate != address(0x0));
153         require(!isWhitelisted(wlCandidate));
154         whitelist[wlCandidate] = true;
155         investors++;
156         emit Authorized(wlCandidate, now);
157     }
158     // отмена авторизации инвестора в WL(только владелец контракта)
159     function revoke(address wlCandidate) public  onlyOwner {
160         whitelist[wlCandidate] = false;
161         investors--;
162         emit Revoked(wlCandidate, now);
163     }
164     // проверка на нахождение адреса инвестора в WL
165     function isWhitelisted(address wlCandidate) internal view returns(bool) {
166         return whitelist[wlCandidate];
167     }
168     /*******************************************************************************
169      * Payable's section
170      */
171 
172     function isPreSale() public constant returns(bool) {
173         return now >= startPreSale && now <= endPreSale;
174     }
175 
176     function isMainSale() public constant returns(bool) {
177         return now >= startMainSale && now <= endMainSale;
178     }
179     // callback функция контракта
180     function () public payable //isUnderHardCap
181     {
182         require(isWhitelisted(msg.sender));
183 
184         if(isPreSale()) {
185             preSale(msg.sender, msg.value);
186         }
187 
188         else if (isMainSale()) {
189             mainSale(msg.sender, msg.value);
190         }
191 
192         else {
193             revert();
194         }
195     }
196 
197     // выпуск токенов в период предварительной распродажи
198     function preSale(address _investor, uint256 _value) internal {
199 
200         uint256 tokens = _value.mul(1e6).div(preSalePrice); // 1e18*1e18/
201 
202         token.mintFromICO(_investor, tokens);
203 
204         uint256 tokensFounders = tokens.mul(3).div(5); // 3/5
205         token.mintFromICO(founders, tokensFounders);
206 
207         uint256 tokensBoynty = tokens.div(5); // 1/5
208         token.mintFromICO(bounty, tokensBoynty);
209 
210         uint256 tokenReserve = tokens.div(5); // 1/5
211         token.mintFromICO(reserve, tokenReserve);
212 
213         weisRaised = weisRaised.add(msg.value);
214         soldTokensPreSale = soldTokensPreSale.add(tokens);
215 
216         require(soldTokensPreSale <= hardCapPreSale);
217     }
218 
219     // выпуск токенов в период основной распродажи
220     function mainSale(address _investor, uint256 _value) internal {
221         uint256 tokens = _value.mul(1e6).div(MainSalePrice); // 1e18*1e18/
222 
223         token.mintFromICO(_investor, tokens);
224 
225         uint256 tokensFounders = tokens.mul(3).div(5); //3/5
226         token.mintFromICO(founders, tokensFounders);
227 
228         uint256 tokensBoynty = tokens.div(5); // 1/5
229         token.mintFromICO(bounty, tokensBoynty);
230 
231         uint256 tokenReserve = tokens.div(5); // 1/5
232         token.mintFromICO(reserve, tokenReserve);
233 
234         weisRaised = weisRaised.add(msg.value);
235         soldTokensSale = soldTokensSale.add(tokens);
236 
237         require(soldTokensSale <= hardCapSale);
238     }
239 
240     // Функция отправки токенов получателям в ручном режиме(только владелец контракта)
241     function mintManual(address _recipient, uint256 _value) public backEnd {
242         token.mintFromICO(_recipient, _value);
243 
244         uint256 tokensFounders = _value.mul(3).div(5);  // 3/5
245         token.mintFromICO(founders, tokensFounders);
246 
247         uint256 tokensBoynty = _value.div(5);  // 1/5
248         token.mintFromICO(bounty, tokensBoynty);
249 
250         uint256 tokenReserve = _value.div(5); // 1/5
251         token.mintFromICO(reserve, tokenReserve);
252         soldTokensSale = soldTokensSale.add(_value);
253         //require(soldTokensPreSale <= hardCapPreSale);
254         //require(soldTokensSale <= hardCapSale);
255     }
256 
257     // Отправка эфира с контракта
258     function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
259         _to.transfer(amount);
260     }
261 }