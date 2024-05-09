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
170 
171     modifier canMint() { require(!mintingFinished); _; }
172 
173     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {
174         totalSupply = totalSupply.add(_amount);
175         balances[_to] = balances[_to].add(_amount);
176 
177         Mint(_to, _amount);
178         Transfer(address(0), _to, _amount);
179 
180         return true;
181     }
182 
183     function finishMinting() onlyOwner public returns(bool success) {
184         mintingFinished = true;
185 
186         MintFinished();
187 
188         return true;
189     }
190 }
191 
192 /*
193     ICO Bloomzed Token
194     - Эмиссия токенов ограничена (всего 100 000 000 токенов, токены выпускаются во время ICO и PreICO)
195     - Цена токена фиксированная: 1 ETH = 500 токенов
196     - Токенов на продажу 50 000 000 (50%)
197     - 50 000 000 (50%) токенов передается команде во время создания токена
198     - Бонусы на PreICO: +50% токенов
199     - Бонусы на ICO: +25% первый день, +20% с 2 по 3 день, +15% с 4 по 5 день, +10% с 6 по 7 день, +7% с 8 по 9 день, +5% с 10 по 11 день
200     - Бонусы на ICO: +3% при покупке >= 3 000 токенов, +5% при покупке > 5 000 токенов, +7% при покупке > 10 000 токенов, +10% при покупке > 15 000 токенов
201     - Бонусы расчитываются на начальную сумму, бонусы сумируются
202     - Минимальная и максимальная сумма покупки: 0.5 ETH и 10000 ETH
203     - Средства от покупки токенов передаются бенефициару
204     - Crowdsale ограничен по времени
205     - Закрытие Crowdsale происходит с помощью функции "withdraw()", минтинг закрывается, управление токеном передаются бенефициару
206 */
207 contract Token is BurnableToken, MintableToken {
208     string public name = "Bloomzed Token";
209     string public symbol = "BZT";
210     uint256 public decimals = 18;
211 
212     function Token() {
213         mint(0x3c64B86cEE4E60EDdA517521b46Ac74134442058, 50000000 * 1 ether);       // Command mint
214     }
215 }
216 
217 contract Crowdsale is Pausable {
218     using SafeMath for uint;
219 
220     Token public token;
221     address public beneficiary = 0x86fABfdBB9B5BFDbec3975aECdDee54b28bDeA45;        // Beneficiary
222     address public manager = 0xD9e4a8fCb4357Dfd14861Bc9E4170e43C14062A4;            // Manager
223 
224     uint public collectedWei;
225     uint public tokensSold;
226 
227     uint public priceTokenWei = 1 ether / 500;
228 
229     uint public piTokensForSale = 5000000 * 1 ether;                                // Amount tokens for sale on PreICO
230     uint public tokensForSale = 50000000 * 1 ether;                                 // Amount tokens for sale
231 
232     uint public piStartTime = 1513674000;                                           // Date start   19.12.2017 12:00 +03
233     uint public piEndTime = 1514278800;                                             // Date end     26.12.2017 12:00 +03
234     uint public startTime = 1516179600;                                             // Date start   17.01.2018 12:00 +03
235     uint public endTime = 1518858000;                                               // Date end     17.02.2018 12:00 +03
236     bool public crowdsaleFinished = false;
237 
238     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
239     event Withdraw();
240 
241     modifier onlyManager() { require(msg.sender == manager); _; }
242 
243     function Crowdsale() {
244         token = new Token();
245     }
246 
247     function() payable {
248         purchase();
249     }
250     
251     function purchase() whenNotPaused payable {
252         require(!crowdsaleFinished);
253         require((now >= piStartTime && now < piEndTime && tokensSold < piTokensForSale) || (now >= startTime && now < endTime));
254         require(tokensSold < tokensForSale);
255         require(msg.value >= 0.5 * 1 ether && msg.value <= 10000 * 1 ether);
256 
257         uint sum = msg.value;
258         uint amount = sum.div(priceTokenWei).mul(1 ether);
259         uint retSum = 0;
260 
261         // ICO
262         if(now > piEndTime) {
263             uint bonus = 0;
264 
265             // Day bonus
266             if(tokensSold.add(amount) < piTokensForSale) {
267                 bonus.add(
268                     now < startTime + 1 days ? 25
269                         : (now < startTime + 3 days ? 20
270                             : (now < startTime + 5 days ? 15
271                                 : (now < startTime + 7 days ? 10
272                                     : (now < startTime + 9 days ? 7
273                                         : (now < startTime + 11 days ? 5 : 0
274                 ))))));
275 
276                 // Amount bonus
277                 if(amount >= 3000 * 1 ether) {
278                     bonus.add(
279                         amount > 15000 * 1 ether ? 10 : 
280                             (amount > 10000 * 1 ether ? 7 : 
281                                 (amount > 5000 * 1 ether ? 5 : 3
282                     )));
283                 }
284             }
285 
286             if(bonus > 0) {
287                 amount = amount.add(amount.div(100).mul(bonus));
288             }
289 
290             if(tokensSold.add(amount) > piTokensForSale) {
291                 uint retAmount = tokensSold.add(amount).sub(piTokensForSale);
292                 retSum = retAmount.mul(price).div(1 ether);
293 
294                 amount = amount.sub(retAmount);
295                 sum = sum.sub(retSum);
296             }
297         }
298         // PreICO
299         else {
300             uint price = priceTokenWei.mul(100).div(150);
301             amount = sum.div(price).mul(1 ether);
302             
303             if(tokensSold.add(amount) > piTokensForSale) {
304                 retAmount = tokensSold.add(amount).sub(piTokensForSale);
305                 retSum = retAmount.mul(price).div(1 ether);
306 
307                 amount = amount.sub(retAmount);
308                 sum = sum.sub(retSum);
309             }
310         }
311 
312         tokensSold = tokensSold.add(amount);
313         collectedWei = collectedWei.add(sum);
314 
315         beneficiary.transfer(sum);
316         token.mint(msg.sender, amount);
317 
318         if(retSum > 0) {
319             msg.sender.transfer(retSum);
320         }
321 
322         NewContribution(msg.sender, amount, sum);
323     }
324 
325     function externalPurchase(address _to, uint _value) whenNotPaused onlyManager {
326         require(!crowdsaleFinished);
327         require(tokensSold < tokensForSale);
328 
329         uint amount = _value.mul(1 ether);
330 
331         tokensSold = tokensSold.add(amount);
332 
333         token.mint(_to, amount);
334 
335         NewContribution(_to, amount, 0);
336     }
337 
338     function withdraw() onlyOwner {
339         require(!crowdsaleFinished);
340         
341         token.finishMinting();
342         token.transferOwnership(beneficiary);
343 
344         crowdsaleFinished = true;
345 
346         Withdraw();
347     }
348 }