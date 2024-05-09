1 pragma solidity ^0.4.21;
2 
3 // ERC20 contract which has the dividend shares of Ethopolis in it 
4 // The old contract had a bug in it, thanks to ccashwell for notifying.
5 // Contact: etherguy@mail.com 
6 // ethopolis.io 
7 // etherguy.surge.sh [if the .io site is up this might be outdated, one of those sites will be up-to-date]
8 // Selling tokens (and buying them) will be online at etherguy.surge.sh/dividends.html and might be moved to the ethopolis site.
9 
10 contract Dividends {
11 
12     string public name = "Ethopolis Shares";      //  token name
13     string public symbol = "EPS";           //  token symbol
14     uint256 public decimals = 18;            //  token digit
15 
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     uint256 public totalSupply = 10000000* (10 ** uint256(decimals));
20     
21     uint256 SellFee = 1250; // max is 10 000
22 
23 
24     address owner = 0x0;
25 
26     modifier isOwner {
27         assert(owner == msg.sender);
28         _;
29     }
30 
31 
32 
33     modifier validAddress {
34         assert(0x0 != msg.sender);
35         _;
36     }
37 
38     function Dividends() public {
39         owner = msg.sender;
40 
41 
42         // PREMINED TOKENS 
43         
44         // EG
45         balanceOf[ address(0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58)] =  8000000* (10 ** uint256(decimals));// was: TokenSupply - 400000;
46         // HE
47         balanceOf[ address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285)] = 200000* (10 ** uint256(decimals));
48         // PG
49         balanceOf[ address(0x26581d1983ced8955C170eB4d3222DCd3845a092)] = 200000* (10 ** uint256(decimals));
50 
51         // BOUGHT tokens in the OLD contract         
52         balanceOf[ address(0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0)] = 97000* (10 ** uint256(decimals));
53         balanceOf[ address(0x4f0d861281161f39c62B790995fb1e7a0B81B07b)] = 199800* (10 ** uint256(decimals));
54         balanceOf[ address(0x36E058332aE39efaD2315776B9c844E30d07388B)] =  20000* (10 ** uint256(decimals));
55         balanceOf[ address(0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c)] =  40000* (10 ** uint256(decimals));
56         balanceOf[ address(0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF)] =  20000* (10 ** uint256(decimals));
57         balanceOf[ address(0x0a3239799518E7F7F339867A4739282014b97Dcf)] = 499000* (10 ** uint256(decimals));
58         balanceOf[ address(0x29A9c76aD091c015C12081A1B201c3ea56884579)] = 600000* (10 ** uint256(decimals));
59         balanceOf[ address(0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C)] = 100000* (10 ** uint256(decimals));
60         balanceOf[ address(0x0982a0bf061f3cec2a004b4d2c802F479099C971)] =  20000* (10 ** uint256(decimals));
61         
62         balanceOf [address(	0xA78EfC3A01CB8f2F47137B97f9546B46275f54a6)] =  3000* (10 ** uint256(decimals));
63         balanceOf [address(	0x522273122b20212FE255875a4737b6F50cc72006)] =  1000* (10 ** uint256(decimals));
64         balanceOf [address(	0xc1c51098ff73f311ECD6E855e858225F531812c4)] =  200* (10 ** uint256(decimals));
65 
66         // Etherscan likes it very much if we emit these events 
67         emit Transfer(0x0, 0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58, 8000000* (10 ** uint256(decimals)));
68         emit Transfer(0x0, 0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285, 200000* (10 ** uint256(decimals)));
69         emit Transfer(0x0, 0x26581d1983ced8955C170eB4d3222DCd3845a092, 200000* (10 ** uint256(decimals)));
70         emit Transfer(0x0, 0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0, 97000* (10 ** uint256(decimals)));
71         emit Transfer(0x0, 0x4f0d861281161f39c62B790995fb1e7a0B81B07b, 199800* (10 ** uint256(decimals)));
72         emit Transfer(0x0, 0x36E058332aE39efaD2315776B9c844E30d07388B, 20000* (10 ** uint256(decimals)));
73         emit Transfer(0x0, 0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c, 40000* (10 ** uint256(decimals)));
74         emit Transfer(0x0, 0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF, 20000* (10 ** uint256(decimals)));
75         emit Transfer(0x0, 0x0a3239799518E7F7F339867A4739282014b97Dcf, 499000* (10 ** uint256(decimals)));
76         emit Transfer(0x0, 0x29A9c76aD091c015C12081A1B201c3ea56884579, 600000* (10 ** uint256(decimals)));
77         emit Transfer(0x0, 0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C, 100000* (10 ** uint256(decimals)));
78         emit Transfer(0x0, 0x0982a0bf061f3cec2a004b4d2c802F479099C971, 20000* (10 ** uint256(decimals)));
79         emit Transfer(0x0, 0xA78EfC3A01CB8f2F47137B97f9546B46275f54a6, 3000* (10 ** uint256(decimals)));
80         emit Transfer(0x0, 0x522273122b20212FE255875a4737b6F50cc72006, 1000* (10 ** uint256(decimals)));
81         emit Transfer(0x0, 0xc1c51098ff73f311ECD6E855e858225F531812c4, 200* (10 ** uint256(decimals)));
82        
83     }
84 
85     function transfer(address _to, uint256 _value)  public validAddress returns (bool success) {
86         require(balanceOf[msg.sender] >= _value);
87         require(balanceOf[_to] + _value >= balanceOf[_to]);
88         // after transfer have enough to pay sell order 
89         require(sub(balanceOf[msg.sender], SellOrders[msg.sender][0]) >= _value);
90         require(msg.sender != _to);
91 
92         uint256 _toBal = balanceOf[_to];
93         uint256 _fromBal = balanceOf[msg.sender];
94         balanceOf[msg.sender] -= _value;
95         balanceOf[_to] += _value;
96         emit Transfer(msg.sender, _to, _value);
97         
98         uint256 _sendFrom = _withdraw(msg.sender, _fromBal, false,0);
99         uint256 _sendTo = _withdraw(_to, _toBal, false, _sendFrom);
100         
101         msg.sender.transfer(_sendFrom);
102         _to.transfer(_sendTo);
103         
104         return true;
105     }
106     
107     // forcetransfer does not do any withdrawals
108     function _forceTransfer(address _from, address _to, uint256  _value) internal validAddress {
109         require(balanceOf[_from] >= _value);
110         require(balanceOf[_to] + _value >= balanceOf[_to]);
111         balanceOf[_from] -= _value;
112         balanceOf[_to] += _value;
113         emit Transfer(_from, _to, _value);
114         
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
118                 // after transfer have enough to pay sell order 
119         require(_from != _to);
120         require(sub(balanceOf[_from], SellOrders[_from][0]) >= _value);
121         require(balanceOf[_to] + _value >= balanceOf[_to]);
122         require(allowance[_from][msg.sender] >= _value);
123         uint256 _toBal = balanceOf[_to];
124         uint256 _fromBal = balanceOf[_from];
125         balanceOf[_to] += _value;
126         balanceOf[_from] -= _value;
127         allowance[_from][msg.sender] -= _value;
128         emit Transfer(_from, _to, _value);
129         
130         // Call withdrawal of old amounts 
131         CancelOrder();
132         uint256 _sendFrom = _withdraw(_from, _fromBal,false,0);
133         uint256 _sendTo = _withdraw(_to, _toBal,false,_sendTo);
134         
135         _from.transfer(_sendFrom);
136         _to.transfer(_sendTo);
137         
138         return true;
139     }
140 
141     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
142         require(_value == 0 || allowance[msg.sender][_spender] == 0);
143         allowance[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function setSymbol(string _symb) public isOwner {
149         symbol = _symb;
150     }
151 
152     function setName(string _name) public isOwner {
153         name = _name;
154     }
155     
156     function newOwner(address who) public isOwner validAddress {
157         owner = who;
158     }
159     
160     function setFee(uint256 fee) public isOwner {
161         require (fee <= 2500);
162         SellFee = fee;
163     }
164 
165 
166 // Market stuff start 
167     
168     mapping(address => uint256[2]) public SellOrders;
169     mapping(address => uint256) public LastBalanceWithdrawn;
170     uint256 TotalOut;
171     
172     function Withdraw() public{
173         _withdraw(msg.sender, balanceOf[msg.sender], true,0);
174     }
175     
176     function ViewSellOrder(address who) public view returns (uint256, uint256){
177         return (SellOrders[who][0], SellOrders[who][1]);
178     }
179     
180     // if dosend is set to false then the calling function MUST send the fees 
181     // subxtra is to handle the "high LastBalanceWithdrawn bug" 
182     // this bug was caused because the Buyer actually gets a too high LastBalanceWithdrawn;
183     // this is a minor bug and could be fixed by adding these funds to the contract (which is usually not a large amount)
184     // if the contract gets a lot of divs live then that should not be an issue because any new withdrawal will set it to a right value 
185     // anyways it is fixed now 
186     function _withdraw(address to, uint256 tkns, bool dosend, uint256 subxtra) internal returns (uint256){
187         // calculate how much wei you get 
188         if (tkns == 0){
189             // ok we just reset the timer then 
190             LastBalanceWithdrawn[msg.sender] = sub(sub(add(address(this).balance, TotalOut),msg.value),subxtra);
191             return 0;
192         }
193         // remove msg.value is exists. if it is nonzero then the call came from Buy, do not include this in balance. 
194         uint256 total_volume_in = address(this).balance + TotalOut - msg.value;
195         // get volume in since last withdrawal; 
196         uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[to]);
197         
198         uint256 Get = (tkns * Delta) / totalSupply;
199         
200         TotalOut = TotalOut + Get;
201         
202         LastBalanceWithdrawn[to] = sub(sub(sub(add(address(this).balance, TotalOut), Get),msg.value),subxtra);
203         
204         emit WithdrawalComplete(to, Get);
205         if (dosend){
206             to.transfer(Get);
207             return 0;
208         }
209         else{//7768
210             return Get;
211         }
212         
213     }
214     
215     function GetDivs(address who) public view returns (uint256){
216          uint256 total_volume_in = address(this).balance + TotalOut;
217          uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[who]);
218          uint256 Get = (balanceOf[who] * Delta) / totalSupply;
219          return (Get);
220     }
221     
222     function CancelOrder() public {
223         _cancelOrder(msg.sender);
224     }
225     
226     function _cancelOrder(address target) internal{
227          SellOrders[target][0] = 0;
228          emit SellOrderCancelled(target);
229     }
230     
231     
232     // the price is per 10^decimals tokens 
233     function PlaceSellOrder(uint256 amount, uint256 price) public {
234         require(price > 0);
235         require(balanceOf[msg.sender] >= amount);
236         SellOrders[msg.sender] = [amount, price];
237         emit SellOrderPlaced(msg.sender, amount, price);
238     }
239 
240     // Safe buy order where user specifies the max amount to buy and the max price; prevents snipers changing their price 
241     function Buy(address target, uint256 maxamount, uint256 maxprice) public payable {
242         require(SellOrders[target][0] > 0);
243         require(SellOrders[target][1] <= maxprice);
244         uint256 price = SellOrders[target][1];
245         uint256 amount_buyable = (mul(msg.value, uint256(10**decimals))) / price; 
246         
247         // decide how much we buy 
248         
249         if (amount_buyable > SellOrders[target][0]){
250             amount_buyable = SellOrders[target][0];
251         }
252         if (amount_buyable > maxamount){
253             amount_buyable = maxamount;
254         }
255         //10000000000000000000,14999999999999
256         //"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",10000000000000000000,14999999999999
257         uint256 total_payment = mul(amount_buyable, price) / (uint256(10 ** decimals));
258         
259         // Let's buy tokens and actually pay, okay?
260         require(amount_buyable > 0 && total_payment > 0); 
261         
262         // From the amount we actually pay, we take exchange fee from it 
263         
264         uint256 Fee = mul(total_payment, SellFee) / 10000;
265         uint256 Left = total_payment - Fee; 
266         
267         uint256 Excess = msg.value - total_payment;
268         
269         uint256 OldTokensSeller = balanceOf[target];
270         uint256 OldTokensBuyer = balanceOf[msg.sender];
271 
272         // Change it in memory 
273         _forceTransfer(target, msg.sender, amount_buyable);
274         
275         // Pay out withdrawals and reset timer
276         // Prevents double withdrawals in same tx
277         
278         // Change sell order 
279         SellOrders[target][0] = sub(SellOrders[target][0],amount_buyable);
280         
281         
282         // start all transfer stuff 
283 
284         uint256 _sendTarget = _withdraw(target, OldTokensSeller, false,0);
285         uint256 _sendBuyer = _withdraw(msg.sender, OldTokensBuyer, false, _sendTarget);
286         
287         // in one transfer saves gas, but its not nice in the etherscan logs 
288         target.transfer(add(Left, _sendTarget));
289         
290         if (add(Excess, _sendBuyer) > 0){
291             msg.sender.transfer(add(Excess,_sendBuyer));
292         }
293         
294         if (Fee > 0){
295             owner.transfer(Fee);
296         }
297      
298         emit SellOrderFilled(msg.sender, target, amount_buyable,  price, Left);
299     }
300 
301 
302     event Transfer(address indexed _from, address indexed _to, uint256 _value);
303     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
304     event SellOrderPlaced(address who, uint256 available, uint256 price);
305     event SellOrderFilled(address buyer, address seller, uint256 tokens, uint256 price, uint256 payment);
306     event SellOrderCancelled(address who);
307     event WithdrawalComplete(address who, uint256 got);
308     
309     
310     // thanks for divs 
311     function() public payable{
312         
313     }
314     
315     // safemath 
316     
317       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318     if (a == 0) {
319       return 0;
320     }
321     uint256 c = a * b;
322     assert(c / a == b);
323     return c;
324   }
325 
326   /**
327   * @dev Integer division of two numbers, truncating the quotient.
328   */
329   function div(uint256 a, uint256 b) internal pure returns (uint256) {
330     // assert(b > 0); // Solidity automatically throws when dividing by 0
331     // uint256 c = a / b;
332     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
333     return a / b;
334   }
335 
336   /**
337   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
338   */
339   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340     assert(b <= a);
341     return a - b;
342   }
343 
344   /**
345   * @dev Adds two numbers, throws on overflow.
346   */
347   function add(uint256 a, uint256 b) internal pure returns (uint256) {
348     uint256 c = a + b;
349     assert(c >= a);
350     return c;
351   }
352 }