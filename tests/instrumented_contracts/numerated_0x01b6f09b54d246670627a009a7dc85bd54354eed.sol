1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 
24 contract Ownable {
25     address public owner;
26     function Ownable() {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);  
32         _;
33     }
34 
35     function transferOwnership(address newOwner) onlyOwner {
36         if (newOwner != address(0)) {
37             owner = newOwner;
38         }
39     }
40 }
41 
42 /**
43  * Ethereum Request for comments #20
44  * Интерфейс стандарта токенов
45  * https://github.com/ethereum/EIPs/issues/20
46  */
47 contract ERC20 {
48     uint256 public totalSupply;
49 
50     // Возвращает баланс адреса
51     function balanceOf(address _owner) constant returns (uint balance);
52     
53     // Отправляет токены _value на адрес _to
54     function transfer(address _to, uint _value) returns (bool success);
55     
56     // Отправляет токены _value с адреса _from на адрес _to
57     function transferFrom(address _from, address _to, uint _value) returns (bool success);
58     
59     // Позволяет адресу _spender снимать <= _value с вашего аккаунта
60     function approve(address _spender, uint _value) returns (bool success);
61     
62     // Возвращает сколько _spender может снимать с вашего аккаунта
63     function allowance(address _owner, address _spender) constant returns (uint remaining);
64     event Transfer(address indexed _from, address indexed _to, uint _value);
65     event Approval(address indexed _owner, address indexed _spender, uint _value);
66 }
67 contract RelestToken is ERC20, Ownable {
68     using SafeMath for uint256;
69     string public name = "Relest";
70     string public symbol = "REST";
71     uint256 public decimals = 8;
72     uint public ethRaised = 0;
73     address wallet = 0xC487f60b6fA6d7CC1e51908b383385CbfC6c30B5;
74 
75     uint256 public minEth = 1 ether / 10;
76     uint256 public priceRate = 1000; // 1 ETH = 1000 RST
77     uint256 step1Price = 1500;
78     uint256 step2Price = 1300;
79     uint256 step3Price = 1150;
80     
81     uint256 minPriceRate = 1000;
82     uint256 public ethGoal = 1000 ether;
83 
84     uint256 public startPreICOTimestamp = 1502287200; // 09.08.2017 14:00 (GMT)
85     uint256 public endPreICOTimestamp = 1502632800; // 13.08.2017 14:00 (GMT)
86 
87     uint256 public startICOTimestamp = 1505743200; // 18.09.2017 14:00 (GMT)
88     uint256 step1End = 1505750400; // 18.09.2017 16:00 (GMT)
89     uint256 step2End = 1505829600; // 19.09.2017 14:00 (GMT)
90     uint256 step3End = 1506348000; // 25.09.2017 14:00 (GMT)
91     uint256 public endICOTimestamp = 1506952800; // 02.10.2017 14:00 (GMT)
92 
93     bool public preSaleGoalReached = false; // true if ethGoal is reached
94     bool public preSaleStarted = false;
95     bool public preSaleEnded = false;
96     bool public SaleStarted = false;
97     bool public SaleEnded = false;
98     bool public isFinalized = false;
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 
103     event TokenPurchase(address indexed sender, address indexed beneficiary, uint ethAmount, uint tokenAmount);
104     event Mint(address indexed to, uint256 amount);
105     event Bounty(address indexed to, uint256 amount);
106 
107     // MODIFIERS
108     
109     modifier validPurchase() {
110         assert(msg.value >= minEth && msg.sender != 0x0);
111         _;
112     }
113     modifier onlyPayloadSize(uint size) {
114         require(msg.data.length >= size + 4);
115         _;
116     }
117 
118     function RelestToken() {
119         owner = msg.sender;
120     }
121 
122     function balanceOf(address _owner) constant returns (uint balance) {
123         return balances[_owner];
124     }
125 
126     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
127         require(preSaleEnded && SaleEnded);
128         require(_to != 0x0 && _value > 0 && balances[msg.sender] >= _value && 
129             balances[_to] + _value > balances[_to]);
130         balances[_to] += _value;
131         balances[msg.sender] -= _value;
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
136         require(preSaleEnded && SaleEnded);
137         require(_to != 0x0 && _value > 0 && balances[msg.sender] >= _value && 
138             balances[_to] + _value > balances[_to] && allowed[_from][msg.sender] >= _value);
139         balances[_to] += _value;
140         balances[_from] -= _value;
141         allowed[_from][msg.sender] -= _value;
142         Transfer(_from, _to, _value);
143         return true;
144     }
145     function approve(address _spender, uint _value) returns (bool success) {
146         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152         return allowed[_owner][_spender];
153     }
154     function () payable {
155         buyTokens(msg.sender);
156     }
157     function checkPeriod() returns (bool) {
158     	bool within = false;
159         if(now > startPreICOTimestamp && now < endPreICOTimestamp && !preSaleGoalReached) { // pre-ICO
160             preSaleStarted = true;
161             preSaleEnded = false;
162             SaleStarted = false;
163             SaleEnded = false;
164             within = true;
165         } else if(now > startICOTimestamp && now < endICOTimestamp) { // ICO
166             SaleStarted = true;
167             SaleEnded = false;
168             preSaleEnded = true;
169             within = true;
170         } else if(now > endICOTimestamp) { // after ICO
171             preSaleEnded = true;
172             SaleEnded = true;
173         } else if(now < startPreICOTimestamp) { // before pre-ICO
174             preSaleStarted = false;
175             preSaleEnded = false;
176             SaleStarted = false;
177             SaleEnded = false;
178         }else { // between pre-ICO and ICO
179         	preSaleStarted = true;
180         	preSaleEnded = true;
181         	SaleStarted = false;
182         	SaleEnded = false;
183         }
184         return within;
185     }
186     function buyTokens(address beneficiary) payable validPurchase {
187     	assert(checkPeriod());
188         uint256 ethAmount = msg.value;
189         if(preSaleStarted && !preSaleEnded) {
190             priceRate = 2000;
191         }
192         if(SaleStarted && !SaleEnded) {
193             if(now >= startICOTimestamp && now <= step1End) {
194                 priceRate = step1Price;
195             }
196             else if(now > step1End && now <= step2End) {
197                 priceRate = step2Price;
198             }
199             else if(now > step2End && now <= step3End) {
200                 priceRate = step3Price;
201             }
202             else {
203                 priceRate = minPriceRate;
204             }
205         }
206         uint256 tokenAmount = ethAmount.mul(priceRate);
207         tokenAmount = tokenAmount.div(1e10);
208         ethRaised = ethRaised.add(ethAmount);
209         mint(beneficiary, tokenAmount);
210         TokenPurchase(msg.sender, beneficiary, ethAmount, tokenAmount);
211         wallet.transfer(msg.value);
212         if(preSaleStarted && !preSaleEnded && ethRaised >= ethGoal) {
213             preSaleEnded = true;
214             preSaleGoalReached = true;
215         }
216     }
217 
218     function finalize() onlyOwner {
219         require(now > endICOTimestamp && SaleEnded && !isFinalized);
220         uint256 tokensLeft = (totalSupply * 30) / 70; // rest 30% of tokens
221         Bounty(wallet, tokensLeft);
222         mint(wallet, tokensLeft);
223         isFinalized = true;
224     }
225 
226     function mint(address receiver, uint256 _amount) returns (bool success){
227         totalSupply = totalSupply.add(_amount);
228         balances[receiver] = balances[receiver].add(_amount);
229         Mint(receiver, _amount);
230         return true;
231     }
232 }
233 // ¯\_(ツ)_/¯