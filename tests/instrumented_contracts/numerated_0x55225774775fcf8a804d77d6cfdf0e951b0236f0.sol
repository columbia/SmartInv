1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     modifier onlyOwner() { require(msg.sender == owner); _; }
33 
34     function Ownable() {
35         owner = msg.sender;
36     }
37 
38     function transferOwnership(address newOwner) onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 }
44 
45 contract Pausable is Ownable {
46     bool public paused = false;
47 
48     event Pause();
49     event Unpause();
50 
51     modifier whenNotPaused() { require(!paused); _; }
52     modifier whenPaused() { require(paused); _; }
53 
54     function pause() onlyOwner whenNotPaused {
55         paused = true;
56         Pause();
57     }
58     
59     function unpause() onlyOwner whenPaused {
60         paused = false;
61         Unpause();
62     }
63 }
64 
65 contract ERC20 {
66     uint256 public totalSupply;
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 
71     function balanceOf(address who) constant returns (uint256);
72     function transfer(address to, uint256 value) returns (bool);
73     function transferFrom(address from, address to, uint256 value) returns (bool);
74     function allowance(address owner, address spender) constant returns (uint256);
75     function approve(address spender, uint256 value) returns (bool);
76 }
77 
78 contract StandardToken is ERC20 {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82     mapping(address => mapping(address => uint256)) allowed;
83 
84     function balanceOf(address _owner) constant returns(uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function transfer(address _to, uint256 _value) returns(bool success) {
89         require(_to != address(0));
90 
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93 
94         Transfer(msg.sender, _to, _value);
95 
96         return true;
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
100         require(_to != address(0));
101 
102         var _allowance = allowed[_from][msg.sender];
103 
104         balances[_from] = balances[_from].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         allowed[_from][msg.sender] = _allowance.sub(_value);
107 
108         Transfer(_from, _to, _value);
109 
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     function approve(address _spender, uint256 _value) returns(bool success) {
118         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
119 
120         allowed[msg.sender][_spender] = _value;
121 
122         Approval(msg.sender, _spender, _value);
123 
124         return true;
125     }
126 
127     function increaseApproval(address _spender, uint _addedValue) returns(bool success) {
128         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
129 
130         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131 
132         return true;
133     }
134 
135     function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {
136         uint oldValue = allowed[msg.sender][_spender];
137 
138         if(_subtractedValue > oldValue) {
139             allowed[msg.sender][_spender] = 0;
140         } else {
141             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142         }
143 
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         
146         return true;
147     }
148 }
149 
150 contract BurnableToken is StandardToken {
151     event Burn(address indexed burner, uint256 value);
152 
153     function burn(uint256 _value) public {
154         require(_value > 0);
155 
156         address burner = msg.sender;
157         balances[burner] = balances[burner].sub(_value);
158         totalSupply = totalSupply.sub(_value);
159         Burn(burner, _value);
160     }
161 }
162 
163 /*
164     ICO Алтын
165     - Эмиссия токенов ограничена (всего 100 000 000 токенов)
166     - На Crowdsale продаются 22 000 000 токенов в 4 этапа, каждый этап ограничен по кол-ву токенов, цена токена на каждом этапе своя
167     - Нижная граница сборов 300 000 USD (граница никак не ограничивают контракт)
168     - Верхная граница сборов 5 500 000 USD (если граница достигнута токены больше не продаются, контракт дает сдачу если сумма больше)
169     - ICO ограничено по времени дата начала 17.10.2017 продолжительность 45 дней.
170     - Цена эфира 1 ETH = 300 USD, минимальная сумма инвестиций 0.03 USD
171     - Закрытие ICO происходит с помощью функции "withdraw()", управление токеном передаются бенефициару, не раскупленные токены сгорают, токены не участвующие в продаже отправляются бенефициару
172 */
173 
174 contract ALTToken is BurnableToken, Ownable {
175     string public name = "Altyn Token";
176     string public symbol = "ALT";
177     uint256 public decimals = 18;
178     
179     uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;                                        // Amount tokens
180 
181     function ALTToken() {
182         totalSupply = INITIAL_SUPPLY;
183         balances[msg.sender] = INITIAL_SUPPLY;
184     }
185 }
186 
187 contract ALTCrowdsale is Pausable {
188     using SafeMath for uint;
189 
190     struct Step {
191         uint priceUSD;
192         uint amountTokens;
193     }
194 
195     ALTToken public token;
196     address public beneficiary = 0x9df0be686E12ccdbE46D4177442878bf8636E89f;                    // Beneficiary
197 
198     uint public collected;
199     uint public collectedUSD;
200     uint public tokensSold;
201     uint public maxTokensSold = 22000000 * 1 ether;                                             // Tokens for sale
202 
203     uint public priceETH = 300;                                                                 // Ether price USD
204     uint public softCapUSD = 300000;                                                            // Soft cap USD
205     uint public softCap = softCapUSD / priceETH * 1 ether;
206     uint public hardCapUSD = 5500000;                                                           // Hard cap USD
207     uint public hardCap = hardCapUSD / priceETH * 1 ether;
208 
209     Step[] steps;
210 
211     uint public startTime = 1508225824;                                                         // Date start 01.10.2017 00:00 +0
212     uint public endTime = startTime + 45 days;                                                  // Date end +45 days
213     bool public crowdsaleFinished = false;
214 
215     event SoftCapReached(uint256 etherAmount);
216     event HardCapReached(uint256 etherAmount);
217     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
218     event Withdraw();
219 
220     modifier onlyAfter(uint time) { require(now > time); _; }
221     modifier onlyBefore(uint time) {  require(now < time);  _; }
222 
223     function ALTCrowdsale() {
224         token = new ALTToken();
225 
226         steps.push(Step(15, 2000000));                                                          // Step 1: 0.15$; 2 000 000 ALT tokens
227         steps.push(Step(20, 5000000));                                                          // Step 2: 0.20$; +3 000 000 ALT tokens
228         steps.push(Step(25, 15000000));                                                         // Step 3: 0.25$; +10 000 000 ALT tokens
229         steps.push(Step(30, 22000000));                                                         // Step 4: 0.30$; +7 000 000 ALT tokens
230     }
231 
232     function() payable {
233         purchase();
234     }
235     
236     function purchase() onlyAfter(startTime) onlyBefore(endTime) whenNotPaused payable {
237         require(!crowdsaleFinished);
238         require(msg.value >= 0.001 * 1 ether && msg.value <= 10000 * 1 ether);
239         require(tokensSold < maxTokensSold);
240 
241         uint amount = 0;
242         uint sum = 0;
243         for(uint i = 0; i < steps.length; i++) {
244             if(tokensSold.add(amount) < steps[i].amountTokens * 1 ether) {
245                 uint avail = (steps[i].amountTokens * 1 ether) - tokensSold.add(amount);
246                 uint nece = (msg.value - sum) * priceETH / steps[i].priceUSD * 100;
247                 uint buy = nece;
248 
249                 if(buy > avail) buy = avail;
250                 
251                 amount += buy;
252                 sum += buy / (priceETH / steps[i].priceUSD * 100);
253 
254                 if(buy == nece) break;
255             }
256         }
257         
258         require(tokensSold.add(amount) <= maxTokensSold);
259 
260         if(collected < softCap && collected.add(sum) >= softCap) {
261             SoftCapReached(collected.add(sum));
262         }
263 
264         collected = collected.add(sum);
265         collectedUSD = collected * priceETH / 1 ether;
266         tokensSold = tokensSold.add(amount);
267         
268         require(token.transfer(msg.sender, amount));
269         if(sum < msg.value) require(msg.sender.send(msg.value - sum));
270 
271         NewContribution(msg.sender, amount, sum);
272 
273         if(collected >= hardCap) {
274             HardCapReached(collected);
275         }
276     }
277 
278     function withdraw() onlyOwner {
279         require(!crowdsaleFinished);
280 
281         beneficiary.transfer(collected);
282 
283         if(tokensSold < maxTokensSold) token.burn(maxTokensSold - tokensSold);
284         token.transfer(beneficiary, token.balanceOf(this));
285         
286         token.transferOwnership(beneficiary);
287 
288         crowdsaleFinished = true;
289 
290         Withdraw();
291     }
292 }