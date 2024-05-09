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
157 
158         balances[burner] = balances[burner].sub(_value);
159         totalSupply = totalSupply.sub(_value);
160 
161         Burn(burner, _value);
162     }
163 }
164 
165 contract MintableToken is StandardToken, Ownable {
166     event Mint(address indexed to, uint256 amount);
167     event MintFinished();
168 
169     bool public mintingFinished = false;
170     uint public MAX_SUPPLY;
171 
172     modifier canMint() { require(!mintingFinished); _; }
173 
174     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {
175         require(totalSupply.add(_amount) <= MAX_SUPPLY);
176 
177         totalSupply = totalSupply.add(_amount);
178         balances[_to] = balances[_to].add(_amount);
179 
180         Mint(_to, _amount);
181         Transfer(address(0), _to, _amount);
182 
183         return true;
184     }
185 
186     function finishMinting() onlyOwner public returns(bool success) {
187         mintingFinished = true;
188 
189         MintFinished();
190 
191         return true;
192     }
193 }
194 
195 /*
196     ICO S Token
197     - Эмиссия токенов ограничена (всего 85 600 000 токенов, токены выпускаются во время ICO и PreICO)
198     - Цена токена фиксированная: 1 ETH = 1250 токенов
199     - Бонусы на PreICO: +40% первые 3 дня, +30% с 4 по 6 день, +20% с 7 по 9 день 
200     - Минимальная и максимальная сумма покупки: 0.001 ETH и 10000 ETH
201     - Токенов на продажу 42 800 000 (50%)
202     - 42 800 000 (50%) токенов передается команде во время создания токена
203     - Средства от покупки токенов передаются бенефициару
204     - Crowdsale ограничен по времени
205     - Закрытие Crowdsale происходит с помощью функции `withdraw()`: управление токеном передаётся бенефициару
206     - После завершения ICO и PreICO владелец должен вызвать `finishMinting()` у токена чтобы закрыть выпуск токенов
207 */
208 
209 contract Token is BurnableToken, MintableToken {
210     string public name = "S Token";
211     string public symbol = "SKK";
212     uint256 public decimals = 18;
213 
214     function Token() {
215         MAX_SUPPLY = 85600000 * 1 ether;                                            // Maximum amount tokens
216         mint(0x17D0b1A81f186bfA186b5841F21FC3207Be2Af7C, 42800000 * 1 ether);       // Command mint
217     }
218 }
219 
220 contract Crowdsale is Pausable {
221     using SafeMath for uint;
222 
223     Token public token;
224     address public beneficiary = 0x17D0b1A81f186bfA186b5841F21FC3207Be2Af7C;        // Beneficiary
225 
226     uint public collectedWei;
227     uint public tokensSold;
228 
229     uint public tokensForSale = 42800000 * 1 ether;                                 // Amount tokens for sale
230     uint public priceTokenWei = 1 ether / 1250;
231 
232     uint public startTime = 1513252800;                                             // Date start   14.12.2017 12:00 +0
233     uint public endTime = 1514030400;                                               // Date end     23.12.2017 12:00 +0
234     bool public crowdsaleFinished = false;
235 
236     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
237     event Withdraw();
238 
239     function Crowdsale() {
240         token = new Token();
241     }
242 
243     function() payable {
244         purchase();
245     }
246     
247     function purchase() whenNotPaused payable {
248         require(!crowdsaleFinished);
249         require(now >= startTime && now < endTime);
250         require(tokensSold < tokensForSale);
251         require(msg.value >= 0.08 * 1 ether && msg.value <= 100 * 1 ether);
252 
253         uint sum = msg.value;
254         uint price = priceTokenWei.mul(100).div(
255             now < startTime + 3 days ? 140
256                 : (now < startTime + 6 days ? 130
257                     : (now < startTime + 9 days ? 120 : 100))
258         );
259         uint amount = sum.div(price).mul(1 ether);
260         uint retSum = 0;
261         
262         if(tokensSold.add(amount) > tokensForSale) {
263             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
264             retSum = retAmount.mul(price).div(1 ether);
265 
266             amount = amount.sub(retAmount);
267             sum = sum.sub(retSum);
268         }
269 
270         tokensSold = tokensSold.add(amount);
271         collectedWei = collectedWei.add(sum);
272 
273         beneficiary.transfer(sum);
274         token.mint(msg.sender, amount);
275 
276         if(retSum > 0) {
277             msg.sender.transfer(retSum);
278         }
279 
280         NewContribution(msg.sender, amount, sum);
281     }
282 
283     function withdraw() onlyOwner {
284         require(!crowdsaleFinished);
285         
286         token.transferOwnership(beneficiary);
287         crowdsaleFinished = true;
288 
289         Withdraw();
290     }
291 }