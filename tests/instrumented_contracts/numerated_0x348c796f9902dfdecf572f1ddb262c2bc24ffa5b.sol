1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) { return 0; }
5         uint256 c = a * b;
6         assert(c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal pure returns(uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 contract Ownable {
24     address public owner;
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26     modifier onlyOwner() { require(msg.sender == owner); _; }
27     function Ownable() public { 
28 	    owner = msg.sender; 
29 		}
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(this));
32         owner = newOwner;
33         emit OwnershipTransferred(owner, newOwner);
34     }
35 }
36 contract ERC20 {
37     uint256 public totalSupply;
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     function balanceOf(address who) public view returns(uint256);
41     function transfer(address to, uint256 value) public returns(bool);
42     function transferFrom(address from, address to, uint256 value) public returns(bool);
43     function allowance(address owner, address spender) public view returns(uint256);
44     function approve(address spender, uint256 value) public returns(bool);
45 }
46 
47 contract StandardToken is ERC20{
48     using SafeMath for uint256;
49     string public name;
50     string public symbol;
51     uint8 public decimals;
52     mapping(address => uint256) public balances;
53     mapping (address => mapping (address => uint256)) internal allowed;
54 	
55 
56 
57 	
58     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
59         name = _name;
60         symbol = _symbol;
61         decimals = _decimals;
62     }
63     function balanceOf(address _owner) public view returns(uint256 balance) {
64         return balances[_owner];
65     }
66 
67 
68 function transfer(address _to, uint256 _value) public returns(bool) {
69         require(_to != address(this));
70         require(_value <= balances[msg.sender]);
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73 		emit Transfer(msg.sender, _to, _value);
74 		return true;
75 }
76 function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
77         require(_to.length == _value.length);
78         for(uint i = 0; i < _to.length; i++) {
79             transfer(_to[i], _value[i]);
80         }
81         return true;
82 }
83 function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
84         require(_to != address(this));
85         require(_value <= balances[_from]);
86         require(_value <= allowed[_from][msg.sender]);
87         balances[_from] = balances[_from].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90         emit Transfer(_from, _to, _value);
91         return true;
92     }
93     function allowance(address _owner, address _spender) public view returns(uint256) {
94         return allowed[_owner][_spender];
95     }
96     function approve(address _spender, uint256 _value) public returns(bool) {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
102         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104         return true;
105     }
106     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
107         uint oldValue = allowed[msg.sender][_spender];
108         if(_subtractedValue > oldValue) {
109             allowed[msg.sender][_spender] = 0;
110         } else {
111             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112         }
113         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 }
117 contract MintableToken is StandardToken, Ownable{
118     event Mint(address indexed to, uint256 amount);
119     event MintFinished();
120     bool public mintingFinished = false;
121     modifier canMint(){require(!mintingFinished); _;}
122     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
123         totalSupply = totalSupply.add(_amount);
124         balances[_to] = balances[_to].add(_amount);
125 		emit Mint(_to, _amount);
126         emit Transfer(address(this), _to, _amount);
127         return true;
128     }
129     function finishMinting() onlyOwner canMint public returns(bool) {
130         mintingFinished = true;
131         emit MintFinished();
132         return true;
133     }
134 }
135 contract CappedToken is MintableToken {
136     uint256 public cap;
137     function CappedToken(uint256 _cap) public {
138         require(_cap > 0);
139         cap = _cap;
140     }
141     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
142         require(totalSupply.add(_amount) <= cap);
143         return super.mint(_to, _amount);
144     }
145 }
146 contract BurnableToken is StandardToken {
147     event Burn(address indexed burner, uint256 value);
148 
149     function burn(uint256 _value) public {
150         require(_value <= balances[msg.sender]);
151         address burner = msg.sender;
152         balances[burner] = balances[burner].sub(_value);
153         totalSupply = totalSupply.sub(_value);
154         emit Burn(burner, _value);
155     }
156 }
157 contract RewardToken is StandardToken, Ownable {
158     struct Payment {
159         uint time;
160         uint amount;
161     }
162     Payment[] public repayments;
163     mapping(address => Payment[]) public rewards;
164 
165     event Reward(address indexed to, uint256 amount);
166 
167     function repayment() onlyOwner payable public {
168         require(msg.value >= 0.00000001 * 1 ether);
169         repayments.push(Payment({time : now, amount : msg.value}));
170     }
171     function _reward(address _to) private returns(bool) {
172         if(rewards[_to].length < repayments.length) {
173             uint sum = 0;
174             for(uint i = rewards[_to].length; i < repayments.length; i++) {
175                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply) : 0;
176                 rewards[_to].push(Payment({time : now, amount : amount}));
177                 sum += amount;
178             }
179             if(sum > 0) {
180                 _to.transfer(sum);
181                 emit Reward(_to, sum);
182             }
183             return true;
184         }
185         return false;
186     }
187     function reward() public returns(bool) {
188         return _reward(msg.sender);
189     }
190     function transfer(address _to, uint256 _value) public returns(bool) {
191         _reward(msg.sender);
192         _reward(_to);
193         return super.transfer(_to, _value);
194     }
195     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
196         _reward(msg.sender);
197         for(uint i = 0; i < _to.length; i++) {
198             _reward(_to[i]);
199         }
200         return super.multiTransfer(_to, _value);
201     }
202     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
203         _reward(_from);
204         _reward(_to);
205         return super.transferFrom(_from, _to, _value);
206     }
207 }
208 contract Token is CappedToken, BurnableToken, RewardToken {
209     function Token() CappedToken(10000000 * 1 ether) StandardToken("JULLAR0805", "JUL0805", 18) public {
210         
211     }
212 }
213 contract Crowdsale is Ownable{
214     using SafeMath for uint;
215     Token public token;
216     address private beneficiary = 0x75E6d4a772DB168f34462a21b64192557ef5c504; // Кошелек компании
217     uint public collectedWei; // Собранные Веи
218     uint private refundedWei; 
219 	
220 
221     string public TokenPriceETH = "0.0000001";  // Стоимость токена 
222 	
223 	uint public tokensSold; // Проданное количество Токенов
224 	uint private tokensDm; // Проданное количество Токенов + Количество покупаемых токенов
225 	uint private tokensForSale = 45 * 1 ether; // Токены на продажу
226     uint public SoldToken;
227     uint public SaleToken = tokensForSale / 1 ether;
228 	uint public StartIcoStage = 0;
229 	// uint public priceTokenWei = 12690355329949;  // 1 токен равен 0,01$ (1eth = 788$)
230     uint public priceTokenWei = 100000000000;  // 0.0000001 ETH за 1 токен
231 	
232     bool public crowdsaleClosed = false;
233     mapping(address => uint256) public purchaseBalances;  // Массив держателей токенов
234     event Rurchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
235     
236     event CrowdsaleClose();
237 	uint256 private oSb = 8000000 * 1 ether;
238     /*Пауза и Старт*/
239 	bool public paused = false;
240 	uint public pausestatus = 1;
241     event Pause();
242     event StartNextIcoStage();
243 	function pause() private {
244         pausestatus = 0;
245 		paused = true;
246         emit Pause();
247     }	
248 	function Crowdsale() public {
249      token = new Token();
250 	 emit Rurchase(beneficiary, oSb, 0);
251 	 token.mint(beneficiary, oSb);
252 	}
253     function() payable public {
254 		if(crowdsaleClosed == false){
255 		       purchase();
256 		}
257     }	
258 	function purchase() payable public {
259 		require(pausestatus != 0);
260         require(!crowdsaleClosed);
261         require(tokensSold < tokensForSale);
262         require(msg.value >= 0.0000001 ether);    // Минимальное количество Эфиров для покупки 
263         uint sum = msg.value;         // Сумма на которую хочет купить Токены
264         uint amount = sum.mul(1 ether).div(priceTokenWei);
265         uint retSum = 0;
266         if(tokensSold.add(amount) > tokensForSale) {
267             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
268             retSum = retAmount.mul(priceTokenWei).div(1 ether);
269             amount = amount.sub(retAmount);
270             sum = sum.sub(retSum);
271         }
272 
273 		tokensSold = tokensSold.add(amount);
274         collectedWei = collectedWei.add(sum);
275         purchaseBalances[msg.sender] = purchaseBalances[msg.sender].add(sum);
276 		token.mint(msg.sender, amount);
277         if(retSum > 0) {
278             msg.sender.transfer(retSum);
279         }		
280 
281         emit Rurchase(msg.sender, amount, sum);
282     }
283 	
284 	function StartNextStage() onlyOwner public {
285         require(!crowdsaleClosed);
286         require(pausestatus != 1);
287 		pausestatus = 1;
288         paused = false;
289         emit StartNextIcoStage(); // Начало этапа ICO 
290     }
291 
292 	
293 	/*Смена этапа и стоимости*/
294 	function NewStage() private {
295 
296 		priceTokenWei = 200000000000; // Новая стоимость Токена 2 раза больше чем на PreICO
297 		TokenPriceETH = "0.0000001";
298 	}
299     function closeCrowdsale() onlyOwner public {
300         require(!crowdsaleClosed);
301         beneficiary.transfer(address(this).balance);
302         token.mint(beneficiary, token.cap().sub(token.totalSupply()));
303         token.transferOwnership(beneficiary);
304         crowdsaleClosed = true;
305         emit CrowdsaleClose();
306     }
307 }