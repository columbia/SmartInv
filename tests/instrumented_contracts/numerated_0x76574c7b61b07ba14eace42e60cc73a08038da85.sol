1 /*! all.me.sol | (c) 2017 Develop by BelovITLab, autor my.life.cookie | License: MIT */
2 
3 pragma solidity 0.4.18;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _; }
38 
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 }
49 
50 contract Pausable is Ownable {
51     bool public paused = false;
52 
53     event Pause();
54     event Unpause();
55 
56     modifier whenNotPaused() { require(!paused); _; }
57     modifier whenPaused() { require(paused); _; }
58 
59     function pause() onlyOwner whenNotPaused public {
60         paused = true;
61         Pause();
62     }
63 
64     function unpause() onlyOwner whenPaused public {
65         paused = false;
66         Unpause();
67     }
68 }
69 
70 contract ERC20 {
71     uint256 public totalSupply;
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 
76     function balanceOf(address who) public view returns(uint256);
77     function transfer(address to, uint256 value) public returns(bool);
78     function transferFrom(address from, address to, uint256 value) public returns(bool);
79     function allowance(address owner, address spender) public view returns(uint256);
80     function approve(address spender, uint256 value) public returns(bool);
81 }
82 
83 contract StandardToken is ERC20 {
84     using SafeMath for uint256;
85 
86     mapping(address => uint256) balances;
87     mapping (address => mapping (address => uint256)) internal allowed;
88 
89     function balanceOf(address _owner) public view returns(uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function transfer(address _to, uint256 _value) public returns(bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99 
100         Transfer(msg.sender, _to, _value);
101 
102         return true;
103     }
104     
105     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
106         require(_to.length == _value.length);
107 
108         for(uint i = 0; i < _to.length; i++) {
109             transfer(_to[i], _value[i]);
110         }
111 
112         return true;
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
116         require(_to != address(0));
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123 
124         Transfer(_from, _to, _value);
125 
126         return true;
127     }
128 
129     function allowance(address _owner, address _spender) public view returns(uint256) {
130         return allowed[_owner][_spender];
131     }
132 
133     function approve(address _spender, uint256 _value) public returns(bool) {
134         allowed[msg.sender][_spender] = _value;
135 
136         Approval(msg.sender, _spender, _value);
137 
138         return true;
139     }
140 
141     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143 
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145 
146         return true;
147     }
148 
149     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
150         uint oldValue = allowed[msg.sender][_spender];
151 
152         if(_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         } else {
155             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156         }
157 
158         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159 
160         return true;
161     }
162 }
163 
164 contract MintableToken is StandardToken, Ownable {
165     event Mint(address indexed to, uint256 amount);
166     event MintFinished();
167 
168     bool public mintingFinished = false;
169 
170     modifier canMint() { require(!mintingFinished); _; }
171 
172     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
173         totalSupply = totalSupply.add(_amount);
174         balances[_to] = balances[_to].add(_amount);
175 
176         Mint(_to, _amount);
177         Transfer(address(0), _to, _amount);
178 
179         return true;
180     }
181 
182     function finishMinting() onlyOwner canMint public returns(bool) {
183         mintingFinished = true;
184 
185         MintFinished();
186 
187         return true;
188     }
189 }
190 
191 contract CappedToken is MintableToken {
192     uint256 public cap;
193 
194     function CappedToken(uint256 _cap) public {
195         require(_cap > 0);
196         cap = _cap;
197     }
198 
199     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
200         require(totalSupply.add(_amount) <= cap);
201 
202         return super.mint(_to, _amount);
203     }
204 }
205 
206 contract Manageable is Ownable {
207     mapping(address => bool) public managers;
208 
209     event ManagerAdded(address indexed manager);
210     event ManagerRemoved(address indexed manager);
211 
212     modifier onlyManager() { require(managers[msg.sender]); _; }
213 
214     function addManager(address _manager) onlyOwner public {
215         require(_manager != address(0));
216 
217         managers[_manager] = true;
218 
219         ManagerAdded(_manager);
220     }
221 
222     function removeManager(address _manager) onlyOwner public {
223         require(_manager != address(0));
224 
225         managers[_manager] = false;
226 
227         ManagerRemoved(_manager);
228     }
229 }
230 
231 /*
232     ICO All.me
233     - Эмиссия токенов ограничена (всего 10 000 000 000 токенов, токены выпускаются во время Crowdsale)
234     - Цена токена во время старта: 1 ETH = 200 токенов (цену можно изменить во время ICO)
235     - Минимальная сумма покупки: 0.001 ETH
236     - Токенов на продажу 7 000 000 000
237     - Отправляем бенефициару 3 000 000 000 токенов во время создания токена
238     - Средства от покупки токенов передаются бенефициару
239     - Закрытие Crowdsale происходит с помощью функции `withdraw()`: управление токеном передаётся бенефициару
240     - Измение цены токена происходет функцией `setTokenPrice(_value)`, где `_value` - кол-во токенов покумаемое за 1 Ether, смена стоимости токена доступно только во время паузы администратору, после завершения Crowdsale функция становится недоступной
241 */
242 contract Token is CappedToken {
243     string public name = "ALL.ME";
244     string public symbol = "ME";
245     uint256 public decimals = 18;
246 
247     function Token() CappedToken(10000000000 * 1 ether) public {                    // Maximum amount tokens
248     
249     }
250 }
251 
252 contract Crowdsale is Pausable, Manageable {
253     using SafeMath for uint;
254 
255     Token public token;
256     address public beneficiary = 0x170cAb2d8987643fB689d9047e21bd1A70716e92;        // Beneficiary
257 
258     uint public collectedWei;
259     uint public tokensSold;
260 
261     uint public tokensForSale = 7000000000 * 1 ether;                               // Amount tokens for sale
262     uint public priceTokenWei = 1 ether / 200;                                      // Start token price
263 
264     bool public crowdsaleFinished = false;
265 
266     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
267     event CrowdsaleClose();
268 
269     function Crowdsale() public {
270         token = new Token();
271 
272         token.mint(0xD7e85ce02C4446Aa87E2d155189C28E07C6C06a0, 3000000000 * 1 ether);
273 
274         addManager(0x7Eada7e60bd714d1a38d9ab329b85D0c75334814);                     // Manager
275     }
276 
277     function() payable public {
278         purchase();
279     }
280 
281     function setTokenPrice(uint _value) onlyOwner whenPaused public {
282         require(!crowdsaleFinished);
283         priceTokenWei = 1 ether / _value;
284     }
285     
286     function purchase() whenNotPaused payable public {
287         require(!crowdsaleFinished);
288         require(tokensSold < tokensForSale);
289         require(msg.value >= 0.001 ether);
290 
291         uint sum = msg.value;
292         uint amount = sum.mul(1 ether).div(priceTokenWei);
293         uint retSum = 0;
294         
295         if(tokensSold.add(amount) > tokensForSale) {
296             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
297             retSum = retAmount.mul(priceTokenWei).div(1 ether);
298 
299             amount = amount.sub(retAmount);
300             sum = sum.sub(retSum);
301         }
302 
303         tokensSold = tokensSold.add(amount);
304         collectedWei = collectedWei.add(sum);
305 
306         beneficiary.transfer(sum);
307         token.mint(msg.sender, amount);
308 
309         if(retSum > 0) {
310             msg.sender.transfer(retSum);
311         }
312 
313         NewContribution(msg.sender, amount, sum);
314     }
315 
316     function externalPurchase(address _to, uint _value) whenNotPaused onlyManager public {
317         require(!crowdsaleFinished);
318         require(tokensSold.add(_value) <= tokensForSale);
319 
320         tokensSold = tokensSold.add(_value);
321 
322         token.mint(_to, _value);
323 
324         NewContribution(_to, _value, 0);
325     }
326 
327     function closeCrowdsale() onlyOwner public {
328         require(!crowdsaleFinished);
329         
330         token.transferOwnership(beneficiary);
331 
332         crowdsaleFinished = true;
333 
334         CrowdsaleClose();
335     }
336 
337     function balanceOf(address _owner) public view returns(uint256 balance) {
338         return token.balanceOf(_owner);
339     }
340 }