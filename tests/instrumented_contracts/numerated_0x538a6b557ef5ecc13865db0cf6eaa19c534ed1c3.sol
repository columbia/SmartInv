1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Interface {
30     // Get the total token supply
31     function totalSupply() public constant returns (uint256 supply);
32 
33     // Get the account balance of another account with address _owner
34     function balanceOf(address _owner) public constant returns (uint256 balance);
35 
36     // Send _value amount of tokens to address _to
37     function transfer(address _to, uint256 _value) public returns (bool success);
38 
39     // Send _value amount of tokens from address _from to address _to
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41 
42     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
43     // If this function is called again it overwrites the current allowance with _value.
44     // this function is required for some DEX functionality
45     function approve(address _spender, uint256 _value) public returns (bool success);
46 
47     // Returns the amount which _spender is still allowed to withdraw from _owner
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 
50     // Triggered when tokens are transferred.
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52 
53     // Triggered whenever approve(address _spender, uint256 _value) is called.
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56    
57 contract Token is ERC20Interface {
58     
59     using SafeMath for uint;
60     
61     string public constant symbol = "LNC";
62     string public constant name = "Linker Coin";
63     uint8 public constant decimals = 18;
64     uint256 _totalSupply = 500000000000000000000000000;
65     
66     //AML & KYC
67     mapping (address => bool) public frozenAccount;
68     event FrozenFunds(address target, bool frozen);
69   
70     // Linker coin has  5*10^25 units, each unit has 10^18  minimum fractions which are called 
71     // Owner of this contract
72     address public owner;
73 
74     // Balances for each account
75     mapping(address => uint256) balances;
76 
77     // Owner of account approves the transfer of an amount to another account
78     mapping(address => mapping (address => uint256)) allowed;
79 
80     // Functions with this modifier can only be executed by the owner
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85     
86     function IsFreezedAccount(address _addr) public constant returns (bool) {
87         return frozenAccount[_addr];
88     }
89 
90     // Constructor
91     function Token() public {
92         owner = msg.sender;
93         balances[owner] = _totalSupply;
94     }
95 
96     function totalSupply() public constant returns (uint256 supply) {
97         supply = _totalSupply;
98     }
99 
100     // What is the balance of a particular account?
101     function balanceOf(address _owner) public constant returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     // Transfer the balance from owner's account to another account
106     function transfer(address _to, uint256 _value) public returns (bool success)
107     {
108         if (_to != 0x0  // Prevent transfer to 0x0 address.
109             && IsFreezedAccount(msg.sender) == false
110             && balances[msg.sender] >= _value 
111             && _value > 0
112             && balances[_to] + _value > balances[_to]) {
113             balances[msg.sender] = balances[msg.sender].sub(_value);
114             balances[_to] = balances[_to].add(_value);
115             Transfer(msg.sender, _to, _value);
116             return true;
117         } else {
118             return false;
119         }
120     }
121 
122     // Send _value amount of tokens from address _from to address _to
123     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
124     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
125     // fees in sub-currencies; the command should fail unless the _from account has
126     // deliberately authorized the sender of the message via some mechanism; we propose
127     // these standardized APIs for approval:
128     function transferFrom(address _from,address _to, uint256 _value) public returns (bool success) {
129         if (_to != 0x0  // Prevent transfer to 0x0 address.
130             && IsFreezedAccount(_from) == false
131             && balances[_from] >= _value
132             && allowed[_from][msg.sender] >= _value
133             && _value > 0
134             && balances[_to] + _value > balances[_to]) {
135             balances[_from] = balances[_from].sub(_value);
136             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137             balances[_to] = balances[_to].add(_value);
138             Transfer(_from, _to, _value);
139             return true;
140         } else {
141             return false;
142         }
143     }
144 
145      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
146     // If this function is called again it overwrites the current allowance with _value.
147     function approve(address _spender, uint256 _value) public returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152     
153     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
154         return allowed[_owner][_spender];
155     }
156     
157     function FreezeAccount(address target, bool freeze) onlyOwner public {
158         frozenAccount[target] = freeze;
159         FrozenFunds(target, freeze);
160     }
161 }
162  
163 contract MyToken is Token {
164     
165     //LP Setup lp:liquidity provider
166     
167     uint8 public constant decimalOfPrice = 10;  // LNC/ETH
168     uint256 public constant multiplierOfPrice = 10000000000;
169     uint256 public constant multiplier = 1000000000000000000;
170     uint256 public lpAskPrice = 100000000000; //LP sell price
171     uint256 public lpBidPrice = 1; //LP buy price
172     uint256 public lpAskVolume = 0; //LP sell volume
173     uint256 public lpBidVolume = 0; //LP buy volume
174     uint256 public lpMaxVolume = 1000000000000000000000000; //the deafult maximum volume of the liquididty provider is 10000 LNC
175     
176     //LP Para
177     uint256 public edgePerPosition = 1; // (lpTargetPosition - lpPosition) / edgePerPosition = the penalty of missmatched position
178     uint256 public lpTargetPosition;
179     uint256 public lpFeeBp = 10; // lpFeeBp is basis point of fee collected by LP
180     
181     bool public isLpStart = false;
182     bool public isBurn = false;
183     
184     function MyToken() public {
185         balances[msg.sender] = _totalSupply;
186         lpTargetPosition = 200000000000000000000000000;
187     }
188     
189     event Burn(address indexed from, uint256 value);
190     function burn(uint256 _value) onlyOwner public returns (bool success) {
191         if (isBurn == true)
192         {
193             balances[msg.sender] = balances[msg.sender].sub(_value);
194             _totalSupply = _totalSupply.sub(_value);
195             Burn(msg.sender, _value);
196             return true;
197         }
198         else{
199             return false;
200         }
201     }
202     
203     event SetBurnStart(bool _isBurnStart);
204     function setBurnStart(bool _isBurnStart) onlyOwner public {
205         isBurn = _isBurnStart;
206     }
207 
208     //Owner will be Lp 
209     event SetPrices(uint256 _lpBidPrice, uint256 _lpAskPrice, uint256 _lpBidVolume, uint256 _lpAskVolume);
210     function setPrices(uint256 _lpBidPrice, uint256 _lpAskPrice, uint256 _lpBidVolume, uint256 _lpAskVolume) onlyOwner public{
211         require(_lpBidPrice < _lpAskPrice);
212         require(_lpBidVolume <= lpMaxVolume);
213         require(_lpAskVolume <= lpMaxVolume);
214         lpBidPrice = _lpBidPrice;
215         lpAskPrice = _lpAskPrice;
216         lpBidVolume = _lpBidVolume;
217         lpAskVolume = _lpAskVolume;
218         SetPrices(_lpBidPrice, _lpAskPrice, _lpBidVolume, _lpAskVolume);
219     }
220     
221     event SetLpMaxVolume(uint256 _lpMaxVolume);
222     function setLpMaxVolume(uint256 _lpMaxVolume) onlyOwner public {
223         require(_lpMaxVolume < 1000000000000000000000000);
224         lpMaxVolume = _lpMaxVolume;
225         if (lpMaxVolume < lpBidVolume){
226             lpBidVolume = lpMaxVolume;
227         }
228         if (lpMaxVolume < lpAskVolume){
229             lpAskVolume = lpMaxVolume;
230         }
231         SetLpMaxVolume(_lpMaxVolume);
232     }
233     
234     event SetEdgePerPosition(uint256 _edgePerPosition);
235     function setEdgePerPosition(uint256 _edgePerPosition) onlyOwner public {
236         //require(_edgePerPosition < 100000000000000000000000000000);
237         edgePerPosition = _edgePerPosition;
238         SetEdgePerPosition(_edgePerPosition);
239     }
240     
241     event SetLPTargetPostion(uint256 _lpTargetPositionn);
242     function setLPTargetPostion(uint256 _lpTargetPosition) onlyOwner public {
243         require(_lpTargetPosition <totalSupply() );
244         lpTargetPosition = _lpTargetPosition;
245         SetLPTargetPostion(_lpTargetPosition);
246     }
247     
248     event SetLpFee(uint256 _lpFeeBp);
249     function setLpFee(uint256 _lpFeeBp) onlyOwner public {
250         require(_lpFeeBp <= 100);
251         lpFeeBp = _lpFeeBp;
252         SetLpFee(lpFeeBp);
253     }
254     
255     event SetLpIsStart(bool _isLpStart);
256     function setLpIsStart(bool _isLpStart) onlyOwner public {
257         isLpStart = _isLpStart;
258     }
259     
260     function getLpBidPrice()public constant returns (uint256)
261     { 
262         uint256 lpPosition = balanceOf(owner);
263             
264         if (lpTargetPosition >= lpPosition)
265         {
266             return lpBidPrice;
267         }
268         else
269         {
270             return lpBidPrice.sub((((lpPosition.sub(lpTargetPosition)).div(multiplier)).mul(edgePerPosition)).div(multiplierOfPrice));
271         }
272     }
273     
274     function getLpAskPrice()public constant returns (uint256)
275     {
276         uint256 lpPosition = balanceOf(owner);
277             
278         if (lpTargetPosition <= lpPosition)
279         {
280             return lpAskPrice;
281         }
282         else
283         {
284             return lpAskPrice.add((((lpTargetPosition.sub(lpPosition)).div(multiplier)).mul(edgePerPosition)).div(multiplierOfPrice));
285         }
286     }
287     
288     function getLpIsWorking(int minSpeadBp) public constant returns (bool )
289     {
290         if (isLpStart == false)
291             return false;
292          
293         if (lpAskVolume == 0 || lpBidVolume == 0)
294         {
295             return false;
296         }
297         
298         int256 bidPrice = int256(getLpBidPrice());
299         int256 askPrice = int256(getLpAskPrice());
300         
301         if (askPrice - bidPrice > minSpeadBp * (bidPrice + askPrice) / 2 / 10000)
302         {
303             return false;
304         }
305         
306         return true;
307     }
308     
309     function getAmountOfLinkerBuy(uint256 etherAmountOfSell) public constant returns (uint256)
310     {
311         return ((( multiplierOfPrice.mul(etherAmountOfSell) ).div(getLpAskPrice())).mul(uint256(10000).sub(lpFeeBp))).div(uint256(10000));
312     }
313     
314     function getAmountOfEtherSell(uint256 linkerAmountOfBuy) public constant returns (uint256)
315     {
316         return (((getLpBidPrice().mul(linkerAmountOfBuy)).div(multiplierOfPrice)).mul(uint256(10000).sub(lpFeeBp))).div(uint256(10000));
317     }
318     
319     function () public payable {
320     }
321     
322     function buy() public payable returns (uint256){
323         require (getLpIsWorking(500));                      // Check Whether Lp Bid and Ask spread is less than 5%
324         uint256 amount = getAmountOfLinkerBuy(msg.value);   // calculates the amount of buy from customer 
325         require(balances[owner] >= amount);                  // checks if it has enough to sell
326         balances[msg.sender] = balances[msg.sender].add(amount);                     // adds the amount to buyer's balance
327         balances[owner] = balances[owner].sub(amount);                           // subtracts amount from seller's balance
328         lpAskVolume = lpAskVolume.sub(amount);
329         Transfer(owner, msg.sender, amount);                 // execute an event reflecting the chang               // ends function and returns
330         return amount;                                    
331     }
332     
333     function sell(uint256 amount)public returns (uint256) {    
334         require (getLpIsWorking(500));
335         require (balances[msg.sender] >= amount);           // checks if the sender has enough to sell
336         balances[owner] = balances[owner].add(amount);                           // adds the amount to owner's balance
337         balances[msg.sender] = balances[msg.sender].sub(amount);                     // subtracts the amount from seller's balance
338         lpBidVolume = lpBidVolume.sub(amount);
339         uint256 linkerSendAmount = getAmountOfEtherSell(amount);
340         
341         msg.sender.transfer(linkerSendAmount);         // sends ether to the seller: it's important to do this last to prevent recursion attacks
342         Transfer(msg.sender, this, linkerSendAmount);       // executes an event reflecting on the change
343         return linkerSendAmount;                                   // ends function and returns
344     }
345     
346     function transferEther(uint256 amount) onlyOwner public{
347         msg.sender.transfer(amount);
348         Transfer(msg.sender, this, amount);
349     }
350 }