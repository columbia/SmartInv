1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         
10         c = a * b;
11         assert(c / a == b);
12         return c; 
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a / b;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract BasicTokenERC20 {  
32     using SafeMath for uint256;
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35     
36     mapping(address => uint256) balances;
37     mapping (address => mapping (address => uint256)) internal allowed;
38     mapping (uint8 => mapping (address => uint256)) internal whitelist;
39 
40     uint256 totalSupply_;
41     address public owner_;
42     
43     constructor() public {
44         owner_ = msg.sender;
45     }
46 
47     function totalSupply() public view returns (uint256) {
48         return totalSupply_;
49     }
50 
51     function balanceOf(address owner) public view returns (uint256) {
52         return balances[owner];
53     }
54 
55     function transfer(address to, uint256 value) public returns (bool) {
56         require(to != address(0));
57         require(value <= balances[msg.sender]);
58 
59         balances[msg.sender] = balances[msg.sender].sub(value);
60         balances[to] = balances[to].add(value);
61         emit Transfer(msg.sender, to, value);
62         return true;
63     } 
64     
65     function transferFrom(address from, address to, uint256 value) public returns (bool){
66         require(to != address(0));
67         require(value <= balances[from]);
68         require(value <= allowed[from][msg.sender]);
69 
70         balances[from] = balances[from].sub(value);
71         balances[to] = balances[to].add(value);
72         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
73         emit Transfer(from, to, value);
74         return true;
75     }
76 
77     function approve(address spender, uint256 value) public returns (bool) {
78         allowed[msg.sender][spender] = value;
79         emit Approval(msg.sender, spender, value);
80         return true;
81     }
82 
83     function allowance(address owner, address spender) public view returns (uint256){
84         return allowed[owner][spender];
85     }
86 
87     modifier onlyOwner() {
88         require(msg.sender == owner_);
89         _;
90     }
91 
92     function addWhiteList(uint8 whiteListType, address investor, uint256 value) public onlyOwner returns (bool){
93         whitelist[whiteListType][investor] = value;
94         return true;
95     }
96 
97     function removeFromWhiteList(uint8 whiteListType, address investor) public onlyOwner returns (bool){
98         whitelist[whiteListType][investor] = 0;
99         return true;
100     }
101 }
102 
103 contract KeowContract is BasicTokenERC20 {    
104 
105     string public constant name = "KeowToken"; 
106     string public constant symbol = "KEOW";
107     uint public decimals = 18; 
108     uint256 public milion = 1000000;
109     event TestLog(address indexed from, address indexed to, uint256 value, uint8 state);
110     //// 1 billion tokkens KEOW
111     uint256 public INITIAL_SUPPLY = 1000 * milion * (uint256(10) ** decimals);
112     //// exchange in 1 eth = 30000 KEOW
113     uint256 public exchangeETH = 30000;
114     //// limit min ethsale
115     uint256 public limitClosedSale = 100 * (uint256(10) ** decimals);
116     uint256 public limitPreSale = 25 * (uint256(10) ** decimals);
117     
118     /// address of wallet
119     address public ecoSystemWallet;
120     address public marketWallet;
121     address public contributorsWallet;
122     address public companyWallet;
123     address public closedSaleWallet;
124     address public preSaleWallet;
125     address public firstStageWallet;
126     address public secondStageWallet;
127 
128     uint256 public investors = 0;
129     address public currentWallet;    
130 
131     /// 0 - Not start/ pause
132     /// 1 - closed sale
133     /// 2 - presale
134     /// 3 - sale1
135     /// 4 - sale2
136     /// 9 - end    
137     uint8 public state = 0;
138         
139     constructor(address w0, address w1, address w2, address w3, address w4, address w5, address w6, address w7) public {        
140         totalSupply_ = INITIAL_SUPPLY;
141 
142         uint256 esoSystemValue = 20 * milion * (uint256(10) ** decimals);
143         ecoSystemWallet = w0;    
144         balances[ecoSystemWallet] = esoSystemValue;
145         emit Transfer(owner_, ecoSystemWallet, esoSystemValue);
146 
147         uint256 marketValue = 50 * milion * (uint256(10) ** decimals);
148         marketWallet = w1;
149         balances[marketWallet] = marketValue;
150         emit Transfer(owner_, marketWallet, marketValue);
151 
152         uint256 contributorsValue = 100 * milion * (uint256(10) ** decimals);
153         contributorsWallet = w2;
154         balances[contributorsWallet] = contributorsValue;
155         emit Transfer(owner_, contributorsWallet, contributorsValue);
156 
157         uint256 companyValue = 230 * milion * (uint256(10) ** decimals);
158         companyWallet = w3;
159         balances[companyWallet] = companyValue;
160         emit Transfer(owner_, companyWallet, companyValue);
161         
162         uint256 closedSaleValue = 50 * milion * (uint256(10) ** decimals);
163         closedSaleWallet = w4;
164         balances[closedSaleWallet] = closedSaleValue;
165         emit Transfer(owner_, closedSaleWallet, closedSaleValue);
166 
167         uint256 preSaleValue = 50 * milion * (uint256(10) ** decimals);
168         preSaleWallet = w5;
169         balances[preSaleWallet] = preSaleValue;
170         emit Transfer(owner_, preSaleWallet, preSaleValue);
171 
172         uint256 firstStageValue = 250 * milion * (uint256(10) ** decimals);
173         firstStageWallet = w6;
174         balances[firstStageWallet] = firstStageValue;
175         emit Transfer(owner_, firstStageWallet, firstStageValue);
176 
177         uint256 secondStageValue = 250 * milion * (uint256(10) ** decimals);
178         secondStageWallet = w7; 
179         balances[secondStageWallet] = secondStageValue;
180         emit Transfer(owner_, secondStageWallet, secondStageValue);
181     }    
182 
183     function () public payable {
184         require(state > 0);
185         require(state < 9);
186         require(msg.sender != 0x0);
187         require(msg.value != 0);
188         uint256 limit = getMinLimit();
189         
190         require(msg.value >= limit);
191         address beneficiary = msg.sender;
192         require(whitelist[state][beneficiary] >= msg.value);
193         
194         uint256 weiAmount = msg.value;
195         uint256 tokens = weiAmount.mul(exchangeETH);
196         require(balances[currentWallet] >= tokens);
197         
198         balances[currentWallet] = balances[currentWallet].sub(tokens);
199         balances[beneficiary] = balances[beneficiary].add(tokens); 
200         
201         emit Transfer(currentWallet, beneficiary, tokens);
202         
203         whitelist[state][beneficiary] = 0;
204         investors++;        
205     }
206     
207     function getMinLimit () public view returns (uint256) {        
208         if (state == 0) {
209             return 0;
210         }
211         
212         if (state == 1) {
213             return limitClosedSale;
214         }
215         
216         if (state == 2) {
217             return limitPreSale;
218         }
219         
220         return 1;
221     }
222 
223     function updateExchangeRate(uint256 updateExchange) public onlyOwner {
224         exchangeETH = updateExchange;
225     }
226 
227     function withdraw(uint value) public onlyOwner {
228         require(value > 0);
229         require(companyWallet != 0x0);        
230         companyWallet.transfer(value);
231     }
232 
233     function startCloseSalePhase() public onlyOwner { 
234         currentWallet = closedSaleWallet;      
235         state = 1;
236     }
237 
238     function startPreSalePhase() public onlyOwner {        
239         currentWallet = preSaleWallet;
240         state = 2;
241     }
242 
243     function startSale1Phase() public onlyOwner {        
244         currentWallet = firstStageWallet;
245         state = 3;
246     }
247 
248     function startSale2Phase() public onlyOwner {        
249         currentWallet = secondStageWallet;
250         state = 4;
251     }    
252 
253     function stopSale() public onlyOwner {        
254         currentWallet = 0;
255         state = 0;
256     }    
257 
258     function endSale () public onlyOwner {
259         currentWallet = 0;
260         state = 9;
261     }        
262 }