1 pragma solidity ^0.4.20;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract Ownable {
26     address public owner;
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28     modifier onlyOwner() { require(msg.sender == owner); _; }
29     function Ownable() public {
30         owner = msg.sender;
31     }
32     function transferOwnership(address newOwner) public onlyOwner {
33         require(newOwner != address(0));
34         owner = newOwner;
35         emit OwnershipTransferred(owner, newOwner);
36     }
37 }
38 
39 contract Pausable is Ownable {
40     bool public paused = false;
41     event Pause();
42     event Unpause();
43     modifier whenNotPaused() { require(!paused); _; }
44     modifier whenPaused() { require(paused); _; }
45     function pause() onlyOwner whenNotPaused public {
46         paused = true;
47         emit Pause();
48     }
49     function unpause() onlyOwner whenPaused public {
50         paused = false;
51         emit Unpause();
52     }
53 }
54 
55 contract ERC20 {
56     uint256 public totalSupply;
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59     function balanceOf(address who) public view returns(uint256);
60     function transfer(address to, uint256 value) public returns(bool);
61     function transferFrom(address from, address to, uint256 value) public returns(bool);
62     function allowance(address owner, address spender) public view returns(uint256);
63     function approve(address spender, uint256 value) public returns(bool);
64 }
65 
66 contract StandardToken is ERC20 {
67     using SafeMath for uint256;
68     string public name;
69     string public symbol;
70     uint8 public decimals;
71     mapping(address => uint256) balances;
72     mapping (address => mapping (address => uint256)) internal allowed;
73     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
74         name = _name;
75         symbol = _symbol;
76         decimals = _decimals;
77 }
78 
79 function balanceOf(address _owner) public view returns(uint256 balance) {
80         return balances[_owner];
81 }
82 
83 function transfer(address _to, uint256 _value) public returns(bool) {
84         require(_to != address(0));
85         require(_value <= balances[msg.sender]);
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         emit Transfer(msg.sender, _to, _value);
89         return true;
90 }
91 function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
92         require(_to.length == _value.length);
93         for(uint i = 0; i < _to.length; i++) {
94             transfer(_to[i], _value[i]);
95         }
96         return true;
97 }
98     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
99         require(_to != address(0));
100         require(_value <= balances[_from]);
101         require(_value <= allowed[_from][msg.sender]);
102         balances[_from] = balances[_from].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender) public view returns(uint256) {
110         return allowed[_owner][_spender];
111     }
112 
113     function approve(address _spender, uint256 _value) public returns(bool) {
114         allowed[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
120         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
121         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122         return true;
123     }
124 
125     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
126         uint oldValue = allowed[msg.sender][_spender];
127         if(_subtractedValue > oldValue) {
128             allowed[msg.sender][_spender] = 0;
129         } else {
130             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131         }
132         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133         return true;
134     }
135 }
136 
137 contract MintableToken is StandardToken, Ownable {
138     event Mint(address indexed to, uint256 amount);
139     event MintFinished();
140     bool public mintingFinished = false;
141     modifier canMint(){require(!mintingFinished); _;}
142 
143     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
144         totalSupply = totalSupply.add(_amount);
145         balances[_to] = balances[_to].add(_amount);
146         emit Mint(_to, _amount);
147         emit Transfer(address(0), _to, _amount);
148         return true;
149     }
150     function finishMinting() onlyOwner canMint public returns(bool) {
151         mintingFinished = true;
152         emit MintFinished();
153         return true;
154     }
155 }
156 
157 contract CappedToken is MintableToken {
158     uint256 public cap;
159 
160     function CappedToken(uint256 _cap) public {
161         require(_cap > 0);
162         cap = _cap;
163     }
164 
165     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
166         require(totalSupply.add(_amount) <= cap);
167 
168         return super.mint(_to, _amount);
169     }
170 }
171 
172 contract BurnableToken is StandardToken {
173     event Burn(address indexed burner, uint256 value);
174 
175     function burn(uint256 _value) public {
176         require(_value <= balances[msg.sender]);
177         address burner = msg.sender;
178         balances[burner] = balances[burner].sub(_value);
179         totalSupply = totalSupply.sub(_value);
180         emit Burn(burner, _value);
181     }
182 }
183 
184 contract RewardToken is StandardToken, Ownable {
185     struct Payment {
186         uint time;
187         uint amount;
188     }
189 
190     Payment[] public repayments;
191     mapping(address => Payment[]) public rewards;
192 
193     event Reward(address indexed to, uint256 amount);
194 
195     function repayment() onlyOwner payable public {
196         require(msg.value >= 0.01 * 1 ether);
197 
198         repayments.push(Payment({time : now, amount : msg.value}));
199     }
200 
201     function _reward(address _to) private returns(bool) {
202         if(rewards[_to].length < repayments.length) {
203             uint sum = 0;
204             for(uint i = rewards[_to].length; i < repayments.length; i++) {
205                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply) : 0;
206                 rewards[_to].push(Payment({time : now, amount : amount}));
207                 sum += amount;
208             }
209             if(sum > 0) {
210                 _to.transfer(sum);
211                 emit Reward(_to, sum);
212             }
213             return true;
214         }
215         return false;
216     }
217     function reward() public returns(bool) {
218         return _reward(msg.sender);
219     }
220 
221     function transfer(address _to, uint256 _value) public returns(bool) {
222         _reward(msg.sender);
223         _reward(_to);
224         return super.transfer(_to, _value);
225     }
226 
227     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
228         _reward(msg.sender);
229         for(uint i = 0; i < _to.length; i++) {
230             _reward(_to[i]);
231         }
232 
233         return super.multiTransfer(_to, _value);
234     }
235 
236     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
237         _reward(_from);
238         _reward(_to);
239         return super.transferFrom(_from, _to, _value);
240     }
241 }
242 
243 contract Token is CappedToken, BurnableToken, RewardToken {
244     function Token() CappedToken(10000 * 1 ether) StandardToken("CRYPTtesttt", "CRYPTtesttt", 18) public {
245         
246     }
247 }
248 contract Crowdsale is Pausable {
249     using SafeMath for uint;
250 
251     Token public token;
252     address public beneficiary = 0x8320449742D5094A410B75171c72328afDBBb70b; // Кошелек компании
253     address public bountyP = 0x1b640aD9909eAc9efc9D686909EE2D28702836BE;     // Кошелёк для Бонусов
254 	
255     uint public collectedWei; // Собранные Веи
256     uint public refundedWei; 
257     uint private tokensSold; // Проданное количество Токенов
258 	uint private tokensForSale = 4500 * 1 ether; // Токены на продажу
259     uint public SoldToken = tokensSold / 1 ether;
260     uint public SaleToken = tokensForSale / 1 ether;
261 	
262     //uint public priceTokenWei = 7142857142857142; 
263     uint private priceTokenWei = 12690355329949;  // 1 токен равен 0,01$ (1eth = 788$)
264     string public TokenPriceETH = "0.000013";  // Стоимость токена 
265     //uint public bonusPercent = 0; // Бонусная часть
266     uint private Sb = 1 ether; // Цифры после запятой 18
267     uint private oSb = Sb * 5000; // Токены для Владельца 
268     uint private BountyCRYPT = Sb * 500; // Токены для Баунти-компании  
269     uint private PRTC = Sb * 1000; // PreICO количество токенов для продажи 
270     
271 	string public IcoStatus = "PreIco";
272 
273     bool public crowdsaleClosed = false;
274     bool public crowdsaleRefund = false;
275 	
276     mapping(address => uint256) public purchaseBalances; 
277     event Rurchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
278     event Refund(address indexed holder, uint256 etherAmount); // Возврат Средств
279     event CrowdsaleClose();
280     event CrowdsaleRefund();
281 	
282 	
283 	
284     function Crowdsale() public {
285      token = new Token();
286 	 
287 	/*Отправляем владельцу  и на Баунти кошелйк*/
288 	 emit Rurchase(beneficiary, oSb, 0);
289 	 token.mint(beneficiary, oSb);
290      emit Rurchase(bountyP, BountyCRYPT, 0); // Баунти
291 	 token.mint(bountyP, BountyCRYPT); 
292     }
293     function() payable public {
294      purchase();
295     }
296     function setTokenRate(uint _value, string _newpriceeth) onlyOwner whenPaused public {
297         require(!crowdsaleClosed);
298         priceTokenWei =  _value;
299         TokenPriceETH = _newpriceeth;
300         
301     }
302 	function purchase() whenNotPaused payable public {
303         require(!crowdsaleClosed);
304         require(tokensSold < tokensForSale);
305         require(msg.value >= 0.000013 ether);    // Минимальное количество Эфиров для покупки 
306         uint sum = msg.value;         // Сумма на которую хочет купить Токены
307         uint amount = sum.mul(1 ether).div(priceTokenWei);
308         uint retSum = 0;
309     if(tokensSold.add(amount) > tokensForSale) {
310             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
311             retSum = retAmount.mul(priceTokenWei).div(1 ether);
312             amount = amount.sub(retAmount);
313             sum = sum.sub(retSum);
314         }
315         tokensSold = tokensSold.add(amount);
316         collectedWei = collectedWei.add(sum);
317         purchaseBalances[msg.sender] = purchaseBalances[msg.sender].add(sum);
318         token.mint(msg.sender, amount);
319         if(retSum > 0) {
320             msg.sender.transfer(retSum);
321         }
322 		/*Меняем статус ICO*/
323 		if(tokensSold > PRTC){
324 			if(tokensForSale == tokensSold){
325 				IcoStatus = "The End :D";
326 			}else{
327 				IcoStatus = "ICO";
328 			}
329 		}
330         emit Rurchase(msg.sender, amount, sum);
331     }
332     function refund() public {
333         require(crowdsaleRefund);
334         require(purchaseBalances[msg.sender] > 0);
335         uint sum = purchaseBalances[msg.sender]; // Cсумма отправителя
336         purchaseBalances[msg.sender] = 0;
337         refundedWei = refundedWei.add(sum);
338         msg.sender.transfer(sum);   
339         emit Refund(msg.sender, sum);
340     }
341     function closeCrowdsale() onlyOwner public {
342         require(!crowdsaleClosed);
343         beneficiary.transfer(address(this).balance);
344         token.mint(beneficiary, token.cap().sub(token.totalSupply()));
345         token.transferOwnership(beneficiary);
346         crowdsaleClosed = true;
347         emit CrowdsaleClose();
348     }
349     function refundCrowdsale() onlyOwner public {
350         require(!crowdsaleClosed);
351         crowdsaleRefund = true;
352         crowdsaleClosed = true;
353         emit CrowdsaleRefund();
354     }
355 }