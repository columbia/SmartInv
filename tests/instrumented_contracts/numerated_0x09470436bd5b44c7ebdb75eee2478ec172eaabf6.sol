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
45         balanceOf[msg.sender] =  8000000* (10 ** uint256(decimals));// was: TokenSupply - 400000;
46         // HE
47         balanceOf[address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285)] = 200000* (10 ** uint256(decimals));
48         // PG
49         balanceOf[address(0x26581d1983ced8955C170eB4d3222DCd3845a092)] = 200000* (10 ** uint256(decimals));
50 
51         // BOUGHT tokens in the OLD contract         
52         balanceOf[address(0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0)] = 100000* (10 ** uint256(decimals));
53         balanceOf[address(0x4f0d861281161f39c62B790995fb1e7a0B81B07b)] = 200000* (10 ** uint256(decimals));
54         balanceOf[address(0x36E058332aE39efaD2315776B9c844E30d07388B)] =  20000* (10 ** uint256(decimals));
55         balanceOf[address(0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c)] =  40000* (10 ** uint256(decimals));
56         balanceOf[address(0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF)] =  20000* (10 ** uint256(decimals));
57         balanceOf[address(0x0a3239799518E7F7F339867A4739282014b97Dcf)] = 500000* (10 ** uint256(decimals));
58         balanceOf[address(0x29A9c76aD091c015C12081A1B201c3ea56884579)] = 600000* (10 ** uint256(decimals));
59         balanceOf[address(0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C)] = 100000* (10 ** uint256(decimals));
60         balanceOf[address(0x0982a0bf061f3cec2a004b4d2c802F479099C971)] =  20000* (10 ** uint256(decimals));
61 
62         // Etherscan likes it very much if we emit these events 
63         emit Transfer(0x0, msg.sender, 8000000* (10 ** uint256(decimals)));
64         emit Transfer(0x0, 0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285, 200000* (10 ** uint256(decimals)));
65         emit Transfer(0x0, 0x26581d1983ced8955C170eB4d3222DCd3845a092, 200000* (10 ** uint256(decimals)));
66         emit Transfer(0x0, 0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0, 100000* (10 ** uint256(decimals)));
67         emit Transfer(0x0, 0x4f0d861281161f39c62B790995fb1e7a0B81B07b, 200000* (10 ** uint256(decimals)));
68         emit Transfer(0x0, 0x36E058332aE39efaD2315776B9c844E30d07388B, 20000* (10 ** uint256(decimals)));
69         emit Transfer(0x0, 0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c, 40000* (10 ** uint256(decimals)));
70         emit Transfer(0x0, 0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF, 20000* (10 ** uint256(decimals)));
71         emit Transfer(0x0, 0x0a3239799518E7F7F339867A4739282014b97Dcf, 500000* (10 ** uint256(decimals)));
72         emit Transfer(0x0, 0x29A9c76aD091c015C12081A1B201c3ea56884579, 600000* (10 ** uint256(decimals)));
73         emit Transfer(0x0, 0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C, 100000* (10 ** uint256(decimals)));
74         emit Transfer(0x0, 0x0982a0bf061f3cec2a004b4d2c802F479099C971, 20000* (10 ** uint256(decimals)));
75        
76     }
77 
78     function transfer(address _to, uint256 _value)  public validAddress returns (bool success) {
79         require(balanceOf[msg.sender] >= _value);
80         require(balanceOf[_to] + _value >= balanceOf[_to]);
81         // after transfer have enough to pay sell order 
82         require(sub(balanceOf[msg.sender], SellOrders[msg.sender][0]) >= _value);
83         require(msg.sender != _to);
84 
85         uint256 _toBal = balanceOf[_to];
86         uint256 _fromBal = balanceOf[msg.sender];
87         balanceOf[msg.sender] -= _value;
88         balanceOf[_to] += _value;
89         emit Transfer(msg.sender, _to, _value);
90         
91         uint256 _sendFrom = _withdraw(msg.sender, _fromBal, false);
92         uint256 _sendTo = _withdraw(_to, _toBal, false);
93         
94         msg.sender.transfer(_sendFrom);
95         _to.transfer(_sendTo);
96         
97         return true;
98     }
99     
100     // forcetransfer does not do any withdrawals
101     function _forceTransfer(address _from, address _to, uint256  _value) internal validAddress {
102         require(balanceOf[_from] >= _value);
103         require(balanceOf[_to] + _value >= balanceOf[_to]);
104         balanceOf[_from] -= _value;
105         balanceOf[_to] += _value;
106         emit Transfer(_from, _to, _value);
107         
108     }
109 
110     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
111                 // after transfer have enough to pay sell order 
112         require(_from != _to);
113         require(sub(balanceOf[_from], SellOrders[_from][0]) >= _value);
114         require(balanceOf[_to] + _value >= balanceOf[_to]);
115         require(allowance[_from][msg.sender] >= _value);
116         uint256 _toBal = balanceOf[_to];
117         uint256 _fromBal = balanceOf[_from];
118         balanceOf[_to] += _value;
119         balanceOf[_from] -= _value;
120         allowance[_from][msg.sender] -= _value;
121         emit Transfer(_from, _to, _value);
122         
123         // Call withdrawal of old amounts 
124         CancelOrder();
125         uint256 _sendFrom = _withdraw(_from, _fromBal,false);
126         uint256 _sendTo = _withdraw(_to, _toBal,false);
127         
128         _from.transfer(_sendFrom);
129         _to.transfer(_sendTo);
130         
131         return true;
132     }
133 
134     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
135         require(_value == 0 || allowance[msg.sender][_spender] == 0);
136         allowance[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     function setSymbol(string _symb) public isOwner {
142         symbol = _symb;
143     }
144 
145     function setName(string _name) public isOwner {
146         name = _name;
147     }
148     
149     function newOwner(address who) public isOwner validAddress {
150         owner = who;
151     }
152     
153     function setFee(uint256 fee) public isOwner {
154         require (fee <= 2500);
155         SellFee = fee;
156     }
157 
158 
159 // Market stuff start 
160     
161     mapping(address => uint256[2]) public SellOrders;
162     mapping(address => uint256) public LastBalanceWithdrawn;
163     uint256 TotalOut;
164     
165     function Withdraw() public{
166         _withdraw(msg.sender, balanceOf[msg.sender], true);
167     }
168     
169     function ViewSellOrder(address who) public view returns (uint256, uint256){
170         return (SellOrders[who][0], SellOrders[who][1]);
171     }
172     
173     // if dosend is set to false then the calling function MUST send the fees 
174     function _withdraw(address to, uint256 tkns, bool dosend) internal returns (uint256){
175         // calculate how much wei you get 
176         if (tkns == 0){
177             // ok we just reset the timer then 
178             LastBalanceWithdrawn[msg.sender] = sub(add(address(this).balance, TotalOut),msg.value);
179             return;
180         }
181         // remove msg.value is exists. if it is nonzero then the call came from Buy, do not include this in balance. 
182         uint256 total_volume_in = address(this).balance + TotalOut - msg.value;
183         // get volume in since last withdrawal; 
184         uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[to]);
185         
186         uint256 Get = (tkns * Delta) / totalSupply;
187         
188         TotalOut = TotalOut + Get;
189         
190         LastBalanceWithdrawn[to] = sub(sub(add(address(this).balance, TotalOut), Get),msg.value);
191         
192         emit WithdrawalComplete(to, Get);
193         if (dosend){
194             to.transfer(Get);
195             return 0;
196         }
197         else{
198             return Get;
199         }
200         
201     }
202     
203     function GetDivs(address who) public view returns (uint256){
204          uint256 total_volume_in = address(this).balance + TotalOut;
205          uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[who]);
206          uint256 Get = (balanceOf[who] * Delta) / totalSupply;
207          return (Get);
208     }
209     
210     function CancelOrder() public {
211         _cancelOrder(msg.sender);
212     }
213     
214     function _cancelOrder(address target) internal{
215          SellOrders[target][0] = 0;
216          emit SellOrderCancelled(target);
217     }
218     
219     
220     // the price is per 10^decimals tokens 
221     function PlaceSellOrder(uint256 amount, uint256 price) public {
222         require(price > 0);
223         require(balanceOf[msg.sender] >= amount);
224         SellOrders[msg.sender] = [amount, price];
225         emit SellOrderPlaced(msg.sender, amount, price);
226     }
227 
228     // Safe buy order where user specifies the max amount to buy and the max price; prevents snipers changing their price 
229     function Buy(address target, uint256 maxamount, uint256 maxprice) public payable {
230         require(SellOrders[target][0] > 0);
231         require(SellOrders[target][1] <= maxprice);
232         uint256 price = SellOrders[target][1];
233         uint256 amount_buyable = (mul(msg.value, uint256(10**decimals))) / price; 
234         
235         // decide how much we buy 
236         
237         if (amount_buyable > SellOrders[target][0]){
238             amount_buyable = SellOrders[target][0];
239         }
240         if (amount_buyable > maxamount){
241             amount_buyable = maxamount;
242         }
243         //10000000000000000000,1000
244         //"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",10000000000000000000,1000
245         uint256 total_payment = mul(amount_buyable, price) / (uint256(10 ** decimals));
246         
247         // Let's buy tokens and actually pay, okay?
248         require(amount_buyable > 0 && total_payment > 0); 
249         
250         // From the amount we actually pay, we take exchange fee from it 
251         
252         uint256 Fee = mul(total_payment, SellFee) / 10000;
253         uint256 Left = total_payment - Fee; 
254         
255         uint256 Excess = msg.value - total_payment;
256         
257         uint256 OldTokensSeller = balanceOf[target];
258         uint256 OldTokensBuyer = balanceOf[msg.sender];
259 
260         // Change it in memory 
261         _forceTransfer(target, msg.sender, amount_buyable);
262         
263         // Pay out withdrawals and reset timer
264         // Prevents double withdrawals in same tx
265         
266         // Change sell order 
267         SellOrders[target][0] = sub(SellOrders[target][0],amount_buyable);
268         
269         
270         // start all transfer stuff 
271 
272         uint256 _sendTarget = _withdraw(target, OldTokensSeller, false);
273         uint256 _sendBuyer = _withdraw(msg.sender, OldTokensBuyer, false );
274         
275         // in one transfer saves gas, but its not nice in the etherscan logs 
276         target.transfer(add(Left, _sendTarget));
277         
278         if (add(Excess, _sendBuyer) > 0){
279             msg.sender.transfer(add(Excess,_sendBuyer));
280         }
281         
282         if (Fee > 0){
283             owner.transfer(Fee);
284         }
285      
286         emit SellOrderFilled(msg.sender, target, amount_buyable,  price, Left);
287     }
288 
289 
290     event Transfer(address indexed _from, address indexed _to, uint256 _value);
291     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
292     event SellOrderPlaced(address who, uint256 available, uint256 price);
293     event SellOrderFilled(address buyer, address seller, uint256 tokens, uint256 price, uint256 payment);
294     event SellOrderCancelled(address who);
295     event WithdrawalComplete(address who, uint256 got);
296     
297     
298     // thanks for divs 
299     function() public payable{
300         
301     }
302     
303     // safemath 
304     
305       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306     if (a == 0) {
307       return 0;
308     }
309     uint256 c = a * b;
310     assert(c / a == b);
311     return c;
312   }
313 
314   /**
315   * @dev Integer division of two numbers, truncating the quotient.
316   */
317   function div(uint256 a, uint256 b) internal pure returns (uint256) {
318     // assert(b > 0); // Solidity automatically throws when dividing by 0
319     // uint256 c = a / b;
320     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
321     return a / b;
322   }
323 
324   /**
325   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
326   */
327   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
328     assert(b <= a);
329     return a - b;
330   }
331 
332   /**
333   * @dev Adds two numbers, throws on overflow.
334   */
335   function add(uint256 a, uint256 b) internal pure returns (uint256) {
336     uint256 c = a + b;
337     assert(c >= a);
338     return c;
339   }
340 }