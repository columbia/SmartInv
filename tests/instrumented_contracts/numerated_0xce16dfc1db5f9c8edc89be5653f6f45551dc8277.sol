1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal constant returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Owned {
31     address public owner;
32 
33     address public newOwner;
34 
35     function Owned() public payable {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(owner == msg.sender);
41         _;
42     }
43 
44     function changeOwner(address _owner) onlyOwner public {
45         require(_owner != 0);
46         newOwner = _owner;
47     }
48 
49     function confirmOwner() public {
50         require(newOwner == msg.sender);
51         owner = newOwner;
52         delete newOwner;
53     }
54 }
55 
56 contract Blocked {
57     uint public blockedUntil;
58 
59     modifier unblocked {
60         require(now > blockedUntil);
61         _;
62     }
63 }
64 
65 contract ERC20Basic {
66     uint256 public totalSupply;
67 
68     function balanceOf(address who) constant public returns (uint256);
69 
70     function transfer(address to, uint256 value) public returns (bool);
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 contract ERC20 is ERC20Basic {
76     function allowance(address owner, address spender) constant public returns (uint256);
77 
78     function transferFrom(address from, address to, uint256 value) public returns (bool);
79 
80     function approve(address spender, uint256 value) public returns (bool);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 contract PayloadSize {
86     // Fix for the ERC20 short address attack
87     modifier onlyPayloadSize(uint size) {
88         require(msg.data.length >= size + 4);
89         _;
90     }
91 }
92 
93 contract BasicToken is ERC20Basic, Blocked, PayloadSize {
94 
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) balances;
98 
99     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function balanceOf(address _owner) constant public returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110 }
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114     mapping (address => mapping (address => uint256)) allowed;
115 
116     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {
117         var _allowance = allowed[_from][msg.sender];
118 
119         balances[_to] = balances[_to].add(_value);
120         balances[_from] = balances[_from].sub(_value);
121         allowed[_from][msg.sender] = _allowance.sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
127 
128         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
129 
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138 
139 }
140 
141 contract BurnableToken is StandardToken {
142 
143     event Burn(address indexed burner, uint256 value);
144 
145     function burn(uint256 _value) unblocked public {
146         require(_value > 0);
147         require(_value <= balances[msg.sender]);
148         // no need to require value <= totalSupply, since that would imply the
149         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
150 
151         address burner = msg.sender;
152         balances[burner] = balances[burner].sub(_value);
153         totalSupply = totalSupply.sub(_value);
154         Burn(burner, _value);
155     }
156 }
157 
158 contract PreNTFToken is BurnableToken, Owned {
159 
160     string public constant name = "PreNTF Token";
161 
162     string public constant symbol = "PreNTF";
163 
164     uint32 public constant decimals = 18;
165 
166     function PreNTFToken(uint256 initialSupply, uint unblockTime) public {
167         totalSupply = initialSupply;
168         balances[owner] = initialSupply;
169         blockedUntil = unblockTime;
170     }
171 
172     function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 }
179 
180 contract Crowdsale is Owned, PayloadSize {
181 
182     using SafeMath for uint256;
183 
184     struct AmountData {
185         bool exists;
186         uint256 value;
187     }
188 
189     // Date of start pre-ICO
190     uint public constant preICOstartTime =    1512597600; // start at Thursday, December 7, 2017 12:00:00 AM EET
191     uint public constant preICOendTime =      1517436000; // end at   Thursday, February 1, 2018 12:00:00 AM EET
192     uint public constant blockUntil =         1525122000; // tokens are blocked until Tuesday, May 1, 2018 12:00:00 AM EET
193 
194     uint256 public constant maxTokenAmount = 3375000 * 10**18; // max tokens amount
195 
196     uint256 public constant bountyTokenAmount = 375000 * 10**18;
197     uint256 public givenBountyTokens = 0;
198 
199     PreNTFToken public token;
200 
201     uint256 public leftTokens = 0;
202 
203     uint256 public totalAmount = 0;
204     uint public transactionCounter = 0;
205 
206     uint256 public constant tokenPrice = 3 * 10**15; // token price in ether
207 
208     uint256 public minAmountForDeal = 9 ether;
209 
210     mapping (uint => AmountData) public amountsByCurrency;
211 
212     mapping (address => uint256) public bountyTokensToAddress;
213 
214     modifier canBuy() {
215         require(!isFinished());
216         require(now >= preICOstartTime);
217         _;
218     }
219 
220     modifier minPayment() {
221         require(msg.value >= minAmountForDeal);
222         _;
223     }
224 
225     // Fix for the ERC20 short address attack
226     modifier onlyPayloadSize(uint size) {
227         require(msg.data.length >= size + 4);
228         _;
229     }
230 
231     function Crowdsale() public {
232         token = new PreNTFToken(maxTokenAmount, blockUntil);
233         leftTokens = maxTokenAmount - bountyTokenAmount;
234         // init currency in Crowdsale.
235         AmountData storage btcAmountData = amountsByCurrency[0];
236         btcAmountData.exists = true;
237         AmountData storage bccAmountData = amountsByCurrency[1];
238         bccAmountData.exists = true;
239         AmountData storage ltcAmountData = amountsByCurrency[2];
240         ltcAmountData.exists = true;
241         AmountData storage dashAmountData = amountsByCurrency[3];
242         dashAmountData.exists = true;
243     }
244 
245     function isFinished() public constant returns (bool) {
246         return now > preICOendTime || leftTokens == 0;
247     }
248 
249     function() external canBuy minPayment payable {
250         uint256 amount = msg.value;
251         uint256 givenTokens = amount.mul(1 ether).div(tokenPrice);
252         uint256 providedTokens = transferTokensTo(msg.sender, givenTokens);
253         transactionCounter = transactionCounter + 1;
254 
255         if (givenTokens > providedTokens) {
256             uint256 needAmount = providedTokens.mul(tokenPrice).div(1 ether);
257             require(amount > needAmount);
258             require(msg.sender.call.gas(3000000).value(amount - needAmount)());
259             amount = needAmount;
260         }
261         totalAmount = totalAmount.add(amount);
262     }
263 
264     function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external canBuy onlyOwner returns (uint256) {
265         AmountData memory tempAmountData = amountsByCurrency[currency];
266         require(tempAmountData.exists);
267         AmountData storage amountData = amountsByCurrency[currency];
268         amountData.value = amountData.value.add(amount);
269         uint256 value = transferTokensTo(to, givenTokens);
270         transactionCounter = transactionCounter + 1;
271         return value;
272     }
273 
274     function addCurrency(uint currency) external onlyOwner {
275         AmountData storage amountData = amountsByCurrency[currency];
276         amountData.exists = true;
277     }
278 
279     function transferTokensTo(address to, uint256 givenTokens) private returns (uint256) {
280         var providedTokens = givenTokens;
281         if (givenTokens > leftTokens) {
282             providedTokens = leftTokens;
283         }
284         leftTokens = leftTokens.sub(providedTokens);
285         require(token.manualTransfer(to, providedTokens));
286         return providedTokens;
287     }
288 
289     function finishCrowdsale() external {
290         require(isFinished());
291         if (leftTokens > 0) {
292             token.burn(leftTokens);
293             leftTokens = 0;
294         }
295     }
296 
297     function takeBountyTokens() external returns (bool){
298         require(isFinished());
299         uint256 allowance = bountyTokensToAddress[msg.sender];
300         require(allowance > 0);
301         bountyTokensToAddress[msg.sender] = 0;
302         require(token.manualTransfer(msg.sender, allowance));
303         return true;
304     }
305 
306     function giveTokensTo(address holder, uint256 amount) external onlyPayloadSize(2 * 32) onlyOwner returns (bool) {
307         require(bountyTokenAmount >= givenBountyTokens.add(amount));
308         bountyTokensToAddress[holder] = bountyTokensToAddress[holder].add(amount);
309         givenBountyTokens = givenBountyTokens.add(amount);
310         return true;
311     }
312 
313     function getAmountByCurrency(uint index) external returns (uint256) {
314         AmountData memory tempAmountData = amountsByCurrency[index];
315         return tempAmountData.value;
316     }
317 
318     function withdraw() external onlyOwner {
319         require(msg.sender.call.gas(3000000).value(this.balance)());
320     }
321 
322     function setAmountForDeal(uint256 value) external onlyOwner {
323         minAmountForDeal = value;
324     }
325 
326     function withdrawAmount(uint256 amount) external onlyOwner {
327         uint256 givenAmount = amount;
328         if (this.balance < amount) {
329             givenAmount = this.balance;
330         }
331         require(msg.sender.call.gas(3000000).value(givenAmount)());
332     }
333 }