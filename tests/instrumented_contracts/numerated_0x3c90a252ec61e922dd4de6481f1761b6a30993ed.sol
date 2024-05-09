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
163 contract MintableToken is StandardToken, Ownable {
164     event Mint(address indexed to, uint256 amount);
165     event MintFinished();
166 
167     bool public mintingFinished = false;
168 
169     modifier canMint() { require(!mintingFinished); _; }
170 
171     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {
172         totalSupply = totalSupply.add(_amount);
173         balances[_to] = balances[_to].add(_amount);
174 
175         Mint(_to, _amount);
176         Transfer(address(0), _to, _amount);
177 
178         return true;
179     }
180 
181     function finishMinting() onlyOwner public returns(bool success) {
182         mintingFinished = true;
183 
184         MintFinished();
185 
186         return true;
187     }
188 }
189 
190 contract RewardToken is StandardToken, Ownable {
191     struct Payment {
192         uint time;
193         uint amount;
194         uint total;
195     }
196 
197     Payment[] public repayments;
198     mapping(address => Payment[]) public rewards;
199 
200     event Repayment(uint256 amount);
201     event Reward(address indexed to, uint256 amount);
202 
203     function repayment(uint amount) onlyOwner {
204         require(amount >= 1000);
205 
206         repayments.push(Payment({time : now, amount : amount * 1 ether, total : totalSupply}));
207 
208         Repayment(amount * 1 ether);
209     }
210 
211     function _reward(address _to) private returns(bool) {
212         if(rewards[_to].length < repayments.length) {
213             uint sum = 0;
214             for(uint i = rewards[_to].length; i < repayments.length; i++) {
215                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / repayments[i].total) : 0;
216                 rewards[_to].push(Payment({time : now, amount : amount, total : repayments[i].total}));
217                 sum += amount;
218             }
219 
220             if(sum > 0) {
221                 totalSupply = totalSupply.add(sum);
222                 balances[_to] = balances[_to].add(sum);
223                 
224                 Reward(_to, sum);
225             }
226 
227             return true;
228         }
229         return false;
230     }
231 
232     function reward() returns(bool) {
233         return _reward(msg.sender);
234     }
235 
236     function transfer(address _to, uint256 _value) returns(bool) {
237         _reward(msg.sender);
238         _reward(_to);
239         return super.transfer(_to, _value);
240     }
241 
242     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
243         _reward(_from);
244         _reward(_to);
245         return super.transferFrom(_from, _to, _value);
246     }
247 }
248 
249 /*
250     ICO Mining Data Center Coin
251     - Эмиссия токенов не ограниченна (токены можно сжигать)
252     - Цена токена на PreICO фиксированная: 1 ETH = 634 токенов
253     - Цена токена на ICO фиксированная: 1 ETH = 317 токенов
254     - Минимальная и максимальная сумма покупки: 0.001 ETH и 100 ETH
255     - Цена эфира фиксированная 1 ETH = 300 USD
256     - Верхная сумма сборов 22 000 000 USD (свыше токены не продаются, сдача не дается, предел можно преодолеть)
257     - Средства от покупки токенов сразу передаются бенефициару
258     - Crowdsale ограничен по времени
259     - Закрытие Crowdsale происходит с помощью функции `withdraw()`: управление токеном передаются бенефициару, выпуск токенов завершается
260     - На Token могут быть начислены дивиденды в виде токенов функцией `repayment(amount)` где amount - кол-во токенов
261     - Чтобы забрать дивиденды держателю токенов необходимо вызвать у Token функцию `reward()`
262 */
263 contract Token is RewardToken, MintableToken, BurnableToken {
264     string public name = "Mining Data Center Coin";
265     string public symbol = "MDCC";
266     uint256 public decimals = 18;
267 
268     function Token() {
269     }
270 }
271 
272 contract Crowdsale is Pausable {
273     using SafeMath for uint;
274 
275     Token public token;
276     address public beneficiary = 0x7cE9A678A78Dca8555269bA39036098aeA68b819;        // Beneficiary
277 
278     uint public collectedWei;
279     uint public tokensSold;
280 
281     uint public piStartTime = 1512162000;                                           // Date start   Sat Dec 02 2017 00:00:00 GMT+0300 (Калининградское время (зима))
282     uint public piEndTime = 1514753999;                                             // Date end     Sun Dec 31 2017 23:59:59 GMT+0300 (Калининградское время (зима))
283     uint public startTime = 1516006800;                                             // Date start   Mon Jan 15 2018 12:00:00 GMT+0300 (Калининградское время (зима))
284     uint public endTime = 1518685200;                                               // Date end     Thu Feb 15 2018 12:00:00 GMT+0300 (Калининградское время (зима))
285     bool public crowdsaleFinished = false;
286 
287     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
288     event Withdraw();
289 
290     function Crowdsale() {
291         token = new Token();
292     }
293 
294     function() payable {
295         purchase();
296     }
297     
298     function purchase() whenNotPaused payable {
299         require(!crowdsaleFinished);
300         require((now >= piStartTime && now < piEndTime) || (now >= startTime && now < endTime));
301         require(msg.value >= 0.001 * 1 ether && msg.value <= 100 * 1 ether);
302         require(collectedWei.mul(350) < 22000000 * 1 ether);
303 
304         uint sum = msg.value;
305         uint amount = sum.mul(now < piEndTime ? 634 : 317);
306 
307         tokensSold = tokensSold.add(amount);
308         collectedWei = collectedWei.add(sum);
309 
310         token.mint(msg.sender, amount);
311         beneficiary.transfer(sum);
312 
313         NewContribution(msg.sender, amount, sum);
314     }
315 
316     function withdraw() onlyOwner {
317         require(!crowdsaleFinished);
318 
319         token.finishMinting();
320         token.transferOwnership(beneficiary);
321 
322         crowdsaleFinished = true;
323 
324         Withdraw();
325     }
326 }