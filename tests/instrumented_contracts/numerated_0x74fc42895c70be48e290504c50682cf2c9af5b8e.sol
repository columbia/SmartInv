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
164     ICO Блэк-рок
165     - Эмиссия токенов ограничена (всего 10 000 000 токенов, токены не сгорают)
166     - Цена токена фиксированная: 1 ETH = 3000 токенов
167     - Минимальная и максимальная сумма покупки: 0.001 ETH и 100 ETH
168     - Токенов на продажу на PreICO 2 000 000
169     - Средства от покупки токенов лежат на контракте
170     - Crowdsale ограничен по времени
171     - Закрытие Crowdsale происходит с помощью функции `withdraw()`
172     - `withdraw(false)` успешное завершение компании: управление токеном, не раскупленные токены и средства на контракте передаются бенефициару
173     - `withdraw(true)` компания завершилась неудачей: управление токеном и не раскупленные токены передаются бенефициару, открывается возможность забрать вложенные средства `refund()`
174     - Вкладчик может забрать свои средства вызовом функции `refund()` после неудачного завершение компании `withdraw(true)`
175 */
176 contract Token is BurnableToken, Ownable {
177     string public name = "RealStart Token";
178     string public symbol = "RST";
179     uint256 public decimals = 18;
180     
181     uint256 public INITIAL_SUPPLY = 10000000 * 1 ether;                             // Amount tokens
182 
183     function Token() {
184         totalSupply = INITIAL_SUPPLY;
185         balances[msg.sender] = INITIAL_SUPPLY;
186     }
187 }
188 
189 contract Crowdsale is Pausable {
190     using SafeMath for uint;
191 
192     Token public token;
193     address public beneficiary = 0xe97be260bB25d84860592524E5086C07c3cb3C0c;        // Beneficiary
194 
195     uint public collectedWei;
196     uint public refundedWei;
197     uint public tokensSold;
198 
199     uint public tokensForSale = 2000000 * 1 ether;                                 // Amount tokens for sale
200     uint public priceTokenWei = 1 ether / 2000;
201     uint public priceTokenWeiPreICO = 333333333333333; // 1 ether / 3000;
202 
203     uint public startTime = 1513299600;                                             
204     uint public endTime = 1517360399;                                               
205     bool public crowdsaleFinished = false;
206     bool public refundOpen = false;
207 
208     mapping(address => uint256) saleBalances; 
209 
210     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
211     event Refunded(address indexed holder, uint256 etherAmount);
212     event Withdraw();
213 
214     function Crowdsale() {
215         token = new Token();
216     }
217 
218     function() payable {
219         purchase();
220     }
221     
222     /// @dev Test purchase: new Crowdsale(); $0.purchase()(10); new $0.token.Token(); $2.balanceOf(@0) == 2e+22
223     /// @dev Test min purchase: new Crowdsale(); !$0.purchase()(0.0009); $0.purchase()(0.001)
224     /// @dev Test max purchase: new Crowdsale(); !$0.purchase()(10001); $0.purchase()(10000)
225     function purchase() whenNotPaused payable {
226         require(!crowdsaleFinished);
227         require(now >= startTime && now < endTime);
228         require(tokensSold < tokensForSale);
229         require(msg.value >= 0.001 * 1 ether && msg.value <= 100 * 1 ether);
230 
231         uint sum = msg.value;
232         uint amount = sum.div(priceTokenWeiPreICO).mul(1 ether);
233         uint retSum = 0;
234         
235         if(tokensSold.add(amount) > tokensForSale) {
236             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
237             retSum = retAmount.mul(priceTokenWeiPreICO).div(1 ether);
238 
239             amount = amount.sub(retAmount);
240             sum = sum.sub(retSum);
241         }
242 
243         tokensSold = tokensSold.add(amount);
244         collectedWei = collectedWei.add(sum);
245         saleBalances[msg.sender] = saleBalances[msg.sender].add(sum);
246 
247         token.transfer(msg.sender, amount);
248 
249         if(retSum > 0) {
250             msg.sender.transfer(retSum);
251         }
252 
253         NewContribution(msg.sender, amount, sum);
254     }
255 
256     /// @dev Test withdraw: new Crowdsale(); $0.purchase()(1000); $0.purchase()(1000)[1]; $0.withdraw(false); new $0.token.Token(); $4.owner() == @5
257     function withdraw(bool refund) onlyOwner {
258         require(!crowdsaleFinished);
259 
260         if(token.balanceOf(this) > 0) {
261             token.transfer(beneficiary, token.balanceOf(this));
262         }
263 
264         if(refund && tokensSold < tokensForSale) {
265             refundOpen = true;
266         }
267         else {
268             beneficiary.transfer(this.balance);
269         }
270         
271         token.transferOwnership(beneficiary);
272         crowdsaleFinished = true;
273 
274         Withdraw();
275     }
276     
277     function refund() {
278         require(crowdsaleFinished);
279         require(refundOpen);
280         require(saleBalances[msg.sender] > 0);
281 
282         uint sum = saleBalances[msg.sender];
283 
284         saleBalances[msg.sender] = 0;
285         refundedWei = refundedWei.add(sum);
286 
287         msg.sender.transfer(sum);
288         
289         Refunded(msg.sender, sum);
290     }
291 }