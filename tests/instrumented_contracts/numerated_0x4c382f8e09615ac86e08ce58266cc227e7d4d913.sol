1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4 
5     function totalSupply() constant returns (uint totalSupply);
6 
7     function balanceOf(address _owner) constant returns (uint balance);
8 
9     function transfer(address _to, uint _value) returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint _value) returns (bool success);
12 
13     function approve(address _spender, uint _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns (uint remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20 }
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract SkrillaToken is ERC20 {
49     using SafeMath for uint;
50 
51     string public constant name = "Skrilla";
52     string public constant symbol = "SKR";
53     uint8 public constant decimals = 6;
54     uint256 public totalSupply;
55     //Multiply to get from a SKR to the number of subunits
56     //Note the cast here otherwise solidity uses a uint8
57     uint256 internal constant SUBUNIT_MULTIPLIER = 10 ** uint256(decimals);
58 
59     //Token balances
60     mapping (address => uint256) tokenSaleBalances;
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     mapping (address => uint256) whiteList;
64 
65     //Contract conditions
66     uint256 internal constant SALE_CAP = 600 * 10**6 * SUBUNIT_MULTIPLIER;
67     uint256 internal constant TEAM_TOKENS = 100 * 10**6 * SUBUNIT_MULTIPLIER;
68     uint256 internal constant GROWTH_TOKENS = 300 * 10**6 * SUBUNIT_MULTIPLIER;
69     uint256 internal constant TOTAL_SUPPLY_CAP  = SALE_CAP + TEAM_TOKENS + GROWTH_TOKENS;
70 
71     address internal withdrawAddress;
72 
73     //State values
74     uint256 public ethRaised;
75     
76     address internal owner;
77     address internal growth;
78     address internal team;
79 
80     uint256[7] public saleStageStartDates;
81 
82     //The prices for each stage. The number of tokens a user will receive for 1ETH.
83     uint16[6] public tokens = [3000,2500,0,2400,2200,2000];
84 
85 
86     function tokenSaleBalanceOf(address _owner) public constant returns (uint256 balance) {
87         balance = tokenSaleBalances[_owner];
88     }
89 
90     function getPreSaleStart() public constant returns (uint256) {
91         return saleStageStartDates[0];
92     }
93 
94     function getPreSaleEnd() public constant returns (uint256) {
95         return saleStageStartDates[2];
96     }
97 
98     function getSaleStart() public constant returns (uint256) {
99         return saleStageStartDates[3];
100     }
101 
102     function getSaleEnd() public constant returns (uint256) {
103         return saleStageStartDates[6];
104     }
105 
106     // Tokens per ETH
107     function getCurrentPrice(address _buyer) public constant returns (uint256) {
108         uint256 price = whiteList[_buyer];
109 
110         if (price > 0) {
111             return SUBUNIT_MULTIPLIER.mul(price);
112         } else {
113             uint256 stage = getStage();
114             return SUBUNIT_MULTIPLIER.mul(tokens[stage]);
115         }
116     }
117 
118     function inPreSalePeriod() public constant returns (bool) {
119         return (now >= getPreSaleStart() && now <= getPreSaleEnd());
120     }
121 
122     function inSalePeriod() public constant returns (bool) {
123         return (now >= getSaleStart() && now <= getSaleEnd());
124         //In rounds 1 - 3 period
125     }
126 
127     // Set start date on contract deploy
128     function SkrillaToken(uint256 _preSaleStart, uint256 _saleStart, address _team, address _growth, address _withdrawAddress) {
129 
130         owner = msg.sender;
131 
132         require(owner != _team && owner != _growth);
133         require(_team != _growth);
134         //Ensure there was no overflow
135         require(SALE_CAP / SUBUNIT_MULTIPLIER == 600 * 10**6);
136         require(GROWTH_TOKENS / SUBUNIT_MULTIPLIER == 300 * 10**6);
137         require(TEAM_TOKENS / SUBUNIT_MULTIPLIER == 100 * 10**6);
138 
139         team = _team;
140         growth = _growth;
141         withdrawAddress = _withdrawAddress;
142 
143         tokenSaleBalances[team] = TEAM_TOKENS ;
144         tokenSaleBalances[growth] = GROWTH_TOKENS ;
145 
146         totalSupply = (TEAM_TOKENS + GROWTH_TOKENS);
147 
148         if (_preSaleStart == 0) {
149             _preSaleStart = 1508533200; //Oct 20 2017 9pm
150         }
151 
152         if (_saleStart == 0) {
153             _saleStart = 1510002000; //Nov 6 2017 9pm
154         }
155 
156         uint256 preSaleEnd = _preSaleStart.add(3 days);
157         require(_saleStart > preSaleEnd);
158 
159         saleStageStartDates[0] = _preSaleStart;
160         saleStageStartDates[1] = _preSaleStart.add(1 days);
161         saleStageStartDates[2] = preSaleEnd;
162         saleStageStartDates[3] = _saleStart;
163         saleStageStartDates[4] = _saleStart.add(1 days);
164         saleStageStartDates[5] = _saleStart.add(7 days);
165         saleStageStartDates[6] = _saleStart.add(14 days);
166 
167         ethRaised = 0;
168     }
169 
170     //Move a user's token sale balance into the ERC20 balances mapping.
171     //The user must call this before they can use their tokens as ERC20 tokens.
172     function withdraw() public returns (bool) {
173         require(now > getSaleEnd() + 14 days);
174 
175         uint256 tokenSaleBalance = tokenSaleBalances[msg.sender];
176         balances[msg.sender] = balances[msg.sender].add(tokenSaleBalance);
177         delete tokenSaleBalances[msg.sender];
178         Withdraw(msg.sender, tokenSaleBalance);
179         return true;
180     }
181 
182     function balanceOf(address _owner) public constant returns (uint256 balance) {
183         balance = balances[_owner];
184     }
185 
186     function totalSupply() public constant returns (uint256) {
187         //Although this function shadows the public field removing it causes all the tests to fail.
188         return totalSupply;
189     }
190 
191     function transfer(address _to, uint256 _value) public returns (bool) {
192         require(_to != address(0));
193 
194         balances[msg.sender] = balances[msg.sender].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196 
197         Transfer(msg.sender, _to, _value);
198         return true;
199     }
200 
201     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
202         require(_to != address(0));
203         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
204 
205         balances[_from] = balances[_from].sub(_value);
206         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208 
209         Transfer(_from,_to, _value);
210         return true;
211     }
212 
213     function approve(address _spender, uint256 _amount) public returns (bool success) {
214         //Prevent attack mentioned here: https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit
215         //Requires that the spender can only set the allowance to a non zero amount if the current allowance is 0
216         //This may have backward compatibility issues with older clients.
217         require(allowed[msg.sender][_spender] == 0 || _amount == 0);
218 
219         allowed[msg.sender][_spender] = _amount;
220         Approval(msg.sender, _spender, _amount);
221         return true;
222     }
223 
224     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
225         return allowed[_owner][_spender];
226     }
227 
228     function addToWhitelist(address _buyer, uint256 _price) public onlyOwner {
229         require(_price < 10000);
230         whiteList[_buyer] = _price;
231     }
232 
233     function removeFromWhitelist(address _buyer) public onlyOwner {
234         delete whiteList[_buyer];
235     }
236 
237     // Fallback function can be used to buy tokens
238     function() payable {
239         buyTokens();
240     }
241 
242     // Low level token purchase function
243     function buyTokens() public payable saleHasNotClosed {
244         // No 0 contributions
245         require(msg.value > 0);
246         require(ethRaised.add(msg.value) <= 150000 ether);
247 
248         // Ignore inSalePeriod for whitelisted buyers, just check before saleEnd
249         require(inPreSalePeriod() || inSalePeriod() || (whiteList[msg.sender] > 0));
250 
251         if (inPreSalePeriod()) {
252             require(msg.value >= 10 ether || whiteList[msg.sender] > 0);
253         }
254 
255         // Get price for buyer
256         uint256 price = getCurrentPrice(msg.sender);
257         require (price > 0);
258 
259         uint256 tokenAmount = price.mul(msg.value);
260         tokenAmount = tokenAmount.div(1 ether);
261 
262         require (tokenAmount > 0);
263         require (totalSupply.add(tokenAmount) <= TOTAL_SUPPLY_CAP);
264 
265         totalSupply = totalSupply.add(tokenAmount);
266         ethRaised = ethRaised.add(msg.value);
267         tokenSaleBalances[msg.sender] = tokenSaleBalances[msg.sender].add(tokenAmount);
268 
269         // Raise event
270         Transfer(address(0), msg.sender, tokenAmount);
271         TokenPurchase(msg.sender, msg.value, tokenAmount);
272     }
273 
274     // empty the contract ETH
275     function transferEth() public onlyOwner {
276         require(now > getSaleEnd() + 14 days);
277         withdrawAddress.transfer(this.balance);
278     }
279 
280     modifier onlyOwner() {
281         require(msg.sender == owner);
282         _;
283     }
284 
285     modifier saleHasNotClosed()  {
286         //Sale must not have closed
287         require(now <= getSaleEnd());
288         _;
289     }
290 
291     function getStage() public constant returns (uint256) {
292         for (uint256 i = 1; i < saleStageStartDates.length; i++) {
293             if (now < saleStageStartDates[i]) {
294                 return i - 1;
295             }
296         }
297 
298         return saleStageStartDates.length - 1;
299     }
300 
301     event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _amount);
302     event Transfer(address indexed _from, address indexed _to, uint256 _value);
303     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
304     event Withdraw(address indexed _owner, uint256 _value);
305 }