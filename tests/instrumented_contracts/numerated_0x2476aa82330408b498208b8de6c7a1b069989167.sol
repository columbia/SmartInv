1 /*! wem.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
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
45         owner = newOwner;
46         OwnershipTransferred(owner, newOwner);
47     }
48 }
49 
50 contract Withdrawable is Ownable {
51     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
52         require(_to != address(0));
53         require(this.balance >= _value);
54 
55         _to.transfer(_value);
56 
57         return true;
58     }
59 
60     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
61         require(_to != address(0));
62 
63         return _token.call('transfer', _to, _value);
64     }
65 }
66 
67 contract Pausable is Ownable {
68     bool public paused = false;
69 
70     event Pause();
71     event Unpause();
72 
73     modifier whenNotPaused() { require(!paused); _; }
74     modifier whenPaused() { require(paused); _; }
75 
76     function pause() onlyOwner whenNotPaused public {
77         paused = true;
78         Pause();
79     }
80 
81     function unpause() onlyOwner whenPaused public {
82         paused = false;
83         Unpause();
84     }
85 }
86 
87 contract ERC20 {
88     uint256 public totalSupply;
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 
93     function balanceOf(address who) public view returns(uint256);
94     function transfer(address to, uint256 value) public returns(bool);
95     function transferFrom(address from, address to, uint256 value) public returns(bool);
96     function allowance(address owner, address spender) public view returns(uint256);
97     function approve(address spender, uint256 value) public returns(bool);
98 }
99 
100 contract ERC223 is ERC20 {
101     function transfer(address to, uint256 value, bytes data) public returns(bool);
102 }
103 
104 contract ERC223Receiving {
105     function tokenFallback(address from, uint256 value, bytes data) external;
106 }
107 
108 contract StandardToken is ERC223 {
109     using SafeMath for uint256;
110 
111     string public name;
112     string public symbol;
113     uint8 public decimals;
114 
115     mapping(address => uint256) balances;
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
119         name = _name;
120         symbol = _symbol;
121         decimals = _decimals;
122     }
123 
124     function balanceOf(address _owner) public view returns(uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function _transfer(address _to, uint256 _value, bytes _data) private returns(bool) {
129         require(_to != address(0));
130         require(_value <= balances[msg.sender]);
131 
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         
135         bool is_contract = false;
136         assembly {
137             is_contract := not(iszero(extcodesize(_to)))
138         }
139 
140         if(is_contract) {
141             ERC223Receiving receiver = ERC223Receiving(_to);
142             receiver.tokenFallback(msg.sender, _value, _data);
143             //receiver.call('tokenFallback', msg.sender, _value, _data);
144         }
145 
146         Transfer(msg.sender, _to, _value);
147 
148         return true;
149     }
150 
151     function transfer(address _to, uint256 _value) public returns(bool) {
152         bytes memory empty;
153         return _transfer(_to, _value, empty);
154     }
155 
156     function transfer(address _to, uint256 _value, bytes _data) public returns(bool) {
157         return _transfer(_to, _value, _data);
158     }
159     
160     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
161         require(_to.length == _value.length);
162 
163         for(uint i = 0; i < _to.length; i++) {
164             transfer(_to[i], _value[i]);
165         }
166 
167         return true;
168     }
169 
170     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
171         require(_to != address(0));
172         require(_value <= balances[_from]);
173         require(_value <= allowed[_from][msg.sender]);
174 
175         balances[_from] = balances[_from].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178 
179         Transfer(_from, _to, _value);
180 
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) public view returns(uint256) {
185         return allowed[_owner][_spender];
186     }
187 
188     function approve(address _spender, uint256 _value) public returns(bool) {
189         allowed[msg.sender][_spender] = _value;
190 
191         Approval(msg.sender, _spender, _value);
192 
193         return true;
194     }
195 
196     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
197         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198 
199         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200 
201         return true;
202     }
203 
204     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
205         uint oldValue = allowed[msg.sender][_spender];
206 
207         if(_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212 
213         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 
215         return true;
216     }
217 }
218 
219 contract MintableToken is StandardToken, Ownable {
220     event Mint(address indexed to, uint256 amount);
221     event MintFinished();
222 
223     bool public mintingFinished = false;
224 
225     modifier canMint() { require(!mintingFinished); _; }
226 
227     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
228         totalSupply = totalSupply.add(_amount);
229         balances[_to] = balances[_to].add(_amount);
230 
231         Mint(_to, _amount);
232         Transfer(address(0), _to, _amount);
233 
234         return true;
235     }
236 
237     function finishMinting() onlyOwner canMint public returns(bool) {
238         mintingFinished = true;
239 
240         MintFinished();
241 
242         return true;
243     }
244 }
245 
246 contract CappedToken is MintableToken {
247     uint256 public cap;
248 
249     function CappedToken(uint256 _cap) public {
250         require(_cap > 0);
251         cap = _cap;
252     }
253 
254     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
255         require(totalSupply.add(_amount) <= cap);
256 
257         return super.mint(_to, _amount);
258     }
259 }
260 
261 contract BurnableToken is StandardToken {
262     event Burn(address indexed burner, uint256 value);
263 
264     function burn(uint256 _value) public {
265         require(_value <= balances[msg.sender]);
266 
267         address burner = msg.sender;
268 
269         balances[burner] = balances[burner].sub(_value);
270         totalSupply = totalSupply.sub(_value);
271 
272         Burn(burner, _value);
273     }
274 }
275 
276 /*
277     Полное название токена: Wind Energy Mining
278     Сокращенное: WEM 
279     Эмиссия: 34 000 000
280 
281     PreICO  нет
282     SetTokenRate нет
283     Refund нет
284 
285     Цена фиксирована:
286     1 ETH = 1000 WEM
287 
288     ICO
289     на продажу токенов: 30 600 000
290     Даты проведения: 20.03.2018 - 20.05.2018
291 
292     После окончания ICO нераскупленные токены передаются бенефициару
293 
294     Дополнительная информация:
295     Бонусы - при приобретении 1000 и более токенов WEM покупатель дополнительно получает  5% от приобретенного количества бесплатно.
296     Обратный выкуп токенов WEM будет производиться по фиксированной цене 0,0015 ETH за один WEM, начиная с 01.03.2019 до конца 2020 года.
297 
298     ---- En -----
299 
300     Token name: Wind Energy Mining
301     Symbol: WEM 
302     Emission: 34,000,000
303 
304     PreICO - no
305     SetTokenRate – no
306     Refund - no
307 
308     Fixed price:
309     1 ETH = 1,000 WEM
310 
311     ICO
312     Tokens to be sold: 30,600,000
313     ICO period: 20.03.2018 - 20.05.2018
314 
315     After the ICO, all unsold tokens will be sent to a beneficiary. 
316 
317     Additional information:
318     Bonuses – when purchasing 1,000 and more WEM tokens, a buyer additionally receives 5% from the number of tokens purchased.
319     WEM buyback will take place beginning on 01.03.2019 until the end of 2020, at a fixed price of 0.0015 ETH for 1 WEM.
320 */
321 
322 contract Token is CappedToken, BurnableToken, Withdrawable {
323     function Token() CappedToken(34000000 * 1 ether) StandardToken("Wind Energy Mining", "WEM", 18) public {
324         
325     }
326 }
327 
328 contract Crowdsale is Withdrawable, Pausable {
329     using SafeMath for uint;
330 
331     Token public token;
332     address public beneficiary = 0x16DEfd1C28006c117845509e4daec7Bc6DC40F50;
333 
334     uint public priceTokenWei = 0.001 ether;
335     uint public priceTokenSellWei = 0.0015 ether;
336     uint public tokensForSale = 30600000 * 1 ether;
337     
338     uint public purchaseStartTime = 1521147600;
339     uint public purchaseEndTime = 1526763600;
340     uint public sellStartTime = 1551387600;
341     uint public sellEndTime = 1609448400;
342 
343     uint public tokensSold;
344     uint public tokensSell;
345     uint public collectedWei;
346     uint public sellWei;
347 
348     bool public crowdsaleClosed = false;
349 
350     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
351     event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
352     event AccrueEther(address indexed holder, uint256 etherAmount);
353     event CrowdsaleClose();
354 
355     function Crowdsale() public {
356         token = new Token();
357     }
358 
359     function() payable public {
360         purchase();
361     }
362 
363     function tokenFallback(address _from, uint256 _value, bytes _data) whenNotPaused external {
364         require(msg.sender == address(token));
365         require(now >= sellStartTime && now < sellEndTime);
366 
367         uint sum = _value.mul(priceTokenSellWei).div(1 ether);
368 
369         tokensSell = tokensSell.add(_value);
370         sellWei = sellWei.add(sum);
371 
372         _from.transfer(sum);
373 
374         Sell(_from, _value, sum);
375     }
376 
377     function purchase() whenNotPaused payable public {
378         require(!crowdsaleClosed);
379         require(now >= purchaseStartTime && now < purchaseEndTime);
380         require(msg.value >= 0.001 ether);
381         require(tokensSold < tokensForSale);
382 
383         uint sum = msg.value;
384         uint amount = sum.mul(1 ether).div(priceTokenWei);
385         uint retSum = 0;
386         
387         if(tokensSold.add(amount) > tokensForSale) {
388             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
389             retSum = retAmount.mul(priceTokenWei).div(1 ether);
390 
391             amount = amount.sub(retAmount);
392             sum = sum.sub(retSum);
393         }
394 
395         if(amount >= 1000 ether) {
396             amount = amount.add(amount.div(100).mul(5));
397         }
398 
399         tokensSold = tokensSold.add(amount);
400         collectedWei = collectedWei.add(sum);
401 
402         beneficiary.transfer(sum);
403         token.mint(msg.sender, amount);
404 
405         if(retSum > 0) {
406             msg.sender.transfer(retSum);
407         }
408 
409         Purchase(msg.sender, amount, sum);
410     }
411 
412     function accrueEther() payable public {
413         AccrueEther(msg.sender, msg.value);
414     }
415 
416     function closeCrowdsale() onlyOwner public {
417         require(!crowdsaleClosed);
418         
419         token.mint(beneficiary, token.cap() - token.totalSupply());
420         token.finishMinting();
421         token.transferOwnership(beneficiary);
422 
423         crowdsaleClosed = true;
424 
425         CrowdsaleClose();
426     }
427 }