1 pragma solidity ^0.4.18;
2 
3 library safemath {
4     function safeMul(uint a, uint b) public pure returns (uint) {
5     if (a == 0) {
6       return 0;
7     }
8     uint c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12     function safeSub(uint a, uint b) public pure returns (uint) {
13     assert(b <= a);
14     return a - b;
15   }
16     function safeAdd(uint a, uint b) public pure returns (uint) {
17     uint c = a + b;
18     assert(c >= a);
19     return c;
20   }
21     function safeDiv(uint256 a, uint256 b) public pure returns (uint256) {
22     uint256 c = a / b;
23     return c;
24     }
25 }
26 
27 contract ContractReceiver {
28     function tokenFallback(address from, uint amount, bytes data) public;
29 }
30 
31 contract SpanToken  {
32     using safemath for uint256;
33     uint256 public _totalsupply;
34     string public constant name = "Span Coin";
35     string public constant symbol = "SPAN";
36     uint8 public constant decimals = 18;
37   
38     uint256 public StartTime;   // start and end timestamps where investments are allowed (both inclusive)
39     uint256 public EndTime ;
40     uint256 public Rate;   // how many token units a buyer gets per msg.value
41     uint256 public currentBonus; 
42     address onlyadmin;
43     address[] admins_array;
44     
45     mapping (address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47     mapping (address => bool) admin_addresses;
48     mapping (address => uint256) public frozenAccount;    
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50     event NewAdmin(address admin);
51     event RemoveAdmin(address admin);    
52 
53     modifier onlyOwner {
54     require(msg.sender == onlyadmin);
55     _;
56     }
57     modifier onlyauthorized {
58         require (admin_addresses[msg.sender] == true || msg.sender == onlyadmin);
59         _;
60     }    
61     modifier notfrozen() {
62      require (frozenAccount[msg.sender] < now );   
63       _;  
64     }
65     function totalSupply() public view returns (uint256 _totalSupply){
66     return _totalsupply;
67     }
68     function getOwner() public view returns(address){
69         return onlyadmin;
70     }
71     function SpanToken(uint256 initialSupply,uint256 _startTime,uint256 _endTime,uint256 _rate,uint256 _currentBonus) public {
72         onlyadmin = msg.sender;
73         admins_array.push(msg.sender);
74         StartTime = _startTime;
75         EndTime = _endTime;
76         Rate = _rate;
77         currentBonus = _currentBonus;
78         _totalsupply = initialSupply * 10 ** uint256(decimals);
79         balances[msg.sender] = _totalsupply;
80     }
81     function transferOwnership(address newOwner) public onlyOwner  {
82     require(newOwner != address(0));
83     OwnershipTransferred(onlyadmin, newOwner);
84     onlyadmin = newOwner;
85   }
86     function ChangeSaleTime(uint256 _startTime, uint256 _endTime, uint256 _currentBonus) onlyOwner public{
87          StartTime = _startTime;
88          EndTime = _endTime;
89          currentBonus = _currentBonus;
90         }
91     function changeRATE(uint256 _rate) onlyOwner public  {
92            Rate = _rate;
93         }
94     function addAdmin(address _address) onlyOwner public {
95         admin_addresses[_address] = true;
96         NewAdmin(_address);
97         admins_array.push(_address);
98     }
99     function removeAdmin(address _address) onlyOwner public {
100         require (_address != msg.sender);
101         admin_addresses[_address] = false;
102         RemoveAdmin(_address);
103     }
104     function withdrawEther() public onlyOwner  {
105 	        onlyadmin.transfer(this.balance);
106         	}    
107 }
108 
109 contract SpanCoin is SpanToken {
110     
111     uint256 public Monthprofitstart;   // start time of profit 
112     uint256 public Monthprofitend;     // end time of profit 
113     uint256 public MonthsProfit;       // Profit made by company
114     uint256 public SharePrice;
115     struct PriceTable{
116         uint256 ProductID;
117         string ProductName;
118         uint256 ProductPrice;
119     }
120     mapping (uint256 => PriceTable) products;
121 
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124     event ContractTransfer(address _to, uint _value, bytes _data);
125     event CoinPurchase(address indexed _to, uint256 _value);
126     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 _value, uint256 amount);
127     event ServicePurchase(address indexed Buyer,uint256 _ProductID, uint256 _price, uint256 _timestamps);
128     event ProfitTransfer(address indexed _to, uint256 _value, uint256 _profit, uint256 _timestamps);
129     event FrozenFunds(address _target, uint256 _timestamps, uint256 _frozento); 
130     event logprofitandshare (uint256 _shareprice, uint256 _profitmade);
131     event RequesProfitFail(address indexed _to, uint256 _value, uint256 _profit, uint256 _timestamps);
132     event AddNewProduct(uint256 _ID, string _name, uint256 _value, address admin);
133     event ProductDeleted(uint256 _ID, address admin);
134     event ProductUpdated(uint256 _ID, string _name, uint256 _value, address admin);
135     event ShopItemSold(address indexed _purchaser, address indexed _Seller, uint indexed ItemID, uint256 _price, uint timestamp);    
136     event ShopFrontEnd(address indexed _purchaser, address indexed _Seller, uint indexed ItemID, uint256 _price, uint timestamp);    
137 
138     function SpanCoin(uint256 initialSupply,uint256 _startTime,uint256 _endTime,uint256 _rate,uint256 _currentBonus)
139      SpanToken(initialSupply,_startTime,_endTime,_rate,_currentBonus) public{
140     }
141     function () public payable{
142          require(msg.value != 0);
143           }
144     function PurchaseToken() public payable{
145         require( msg.value > 0);
146          uint256 tokens = msg.value.safeMul(Rate);
147          uint256 BonusTokens = tokens.safeDiv(100).safeMul(currentBonus);
148       if (now > StartTime && now < EndTime){
149             _transfer(onlyadmin,msg.sender,tokens + BonusTokens);
150         CoinPurchase(msg.sender, tokens + BonusTokens);
151        } else {
152             _transfer(onlyadmin,msg.sender,tokens);
153         CoinPurchase(msg.sender, tokens);
154        }
155         }
156     function buytobeneficiary(address beneficiary) public payable {
157         require(beneficiary != address(0) && msg.value > 0);
158         require(now > StartTime && now < EndTime);
159         uint256 tokentoAmount = msg.value.safeMul(Rate);
160         uint256 bountytoken = tokentoAmount.safeDiv(10);
161         _transfer(onlyadmin, msg.sender, tokentoAmount);
162         _transfer(onlyadmin, beneficiary, bountytoken);
163         TokenPurchase(msg.sender, beneficiary, tokentoAmount, bountytoken);
164     }
165     function payproduct (uint256 _ProductID) public returns (bool){
166         uint256 price = products[_ProductID].ProductPrice;
167        if (balances[msg.sender] >= price && price > 0 ) {
168         _transfer(msg.sender, onlyadmin, price);
169         ServicePurchase(msg.sender, _ProductID, price, now);
170         return true;
171         }else {
172             return false;
173         }
174     }
175             //in case of manual withdrawal
176     function withdrawEther() public onlyOwner  {
177 	        onlyadmin.transfer(this.balance);
178         	}
179     function _transfer(address _from, address _to, uint _value) internal {
180         require(_to != 0x0);
181         require(balances[_from] >= _value);
182         uint previousBalances = balances[_from] + balances[_to];
183         balances[_from] -= _value;
184         balances[_to] += _value;
185         Transfer(_from, _to, _value);
186         assert(balances[_from] + balances[_to] == previousBalances);
187     }      	
188 ///////////////////////////////////////////////     
189 //               ERC23 start Here           //
190 //////////////////////////////////////////////  
191     function transfer(address _to, uint256 _value, bytes _data) notfrozen public returns (bool success) {
192         //filtering if the target is a contract with bytecode inside it
193         if(isContract(_to)) {
194             return transferToContract(_to, _value, _data);
195         } else {
196             return transferToAddress(_to, _value);
197         }
198     }
199     function transfer(address _to, uint256 _value) notfrozen public returns (bool success) {
200         //A standard function transfer similar to ERC20 transfer with no _data
201         if(isContract(_to)) {
202             bytes memory emptyData;
203             return transferToContract(_to, _value, emptyData);
204         } else {
205             return transferToAddress(_to, _value);
206         }
207     }     
208     function isContract(address _addr) public constant returns (bool is_contract) {
209       uint length;
210       assembly { length := extcodesize(_addr) }
211         if(length > 0){
212             return true;
213         }
214         else {
215             return false;
216         }
217     }
218     function transferToAddress(address _to, uint256 _value) notfrozen public returns (bool success) {
219             require (balances[msg.sender] >= _value && _value > 0);
220             balances[msg.sender] -= _value;
221             balances[_to] += _value;
222             Transfer(msg.sender, _to, _value);
223             return true;
224          
225      }
226     function transferToContract(address _to, uint256 _value, bytes _data) notfrozen public returns (bool success) {
227         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
228             balances[msg.sender] -= _value;
229             balances[_to] += _value;
230             ContractReceiver reciever = ContractReceiver(_to);
231             reciever.tokenFallback(msg.sender, _value, _data);
232             Transfer(msg.sender, _to, _value);
233             ContractTransfer(_to, _value, _data);
234             return true;
235         } else {
236             return false;
237         }
238   }
239     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
240         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
241             balances[_to] += _value;
242             balances[_from] -= _value;
243             allowed[_from][msg.sender] -= _value;
244             Transfer(_from, _to, _value);
245             return true;
246         } else { return false; }
247     }
248     function balanceOf(address _owner) public constant returns (uint256 balance) {
249         return balances[_owner];
250     }
251     function approve(address _spender, uint256 _value) public returns (bool success) {
252         allowed[msg.sender][_spender] = _value;
253         Approval(msg.sender, _spender, _value);
254         return true;
255     }
256     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
257       return allowed[_owner][_spender];
258     }
259 ///////////////////////////////////////////////     
260 //     Products management start here       //
261 //////////////////////////////////////////////      
262     function addProduct(uint256 _ProductID, string productName, uint256 productPrice) onlyauthorized public returns (bool success){
263         require(products[_ProductID].ProductID == 0);
264         products[_ProductID] = PriceTable(_ProductID, productName, productPrice);
265         AddNewProduct(_ProductID, productName, productPrice, msg.sender);
266         return true;
267     }
268     function deleteProduct(uint256 _ProductID) onlyauthorized public returns (bool success){
269         delete products[_ProductID];
270         ProductDeleted(_ProductID, msg.sender);
271         return true;
272     }
273     function updateProduct(uint256 _ProductID, string _productName, uint256 _productPrice) onlyauthorized public returns (bool success){
274         require(products[_ProductID].ProductID == _ProductID && _productPrice > 0);
275         products[_ProductID] = PriceTable(_ProductID, _productName, _productPrice);
276         ProductUpdated(_ProductID, _productName, _productPrice, msg.sender);
277         return true;
278     }
279     function getProduct(uint256 _ProductID) public constant returns (uint256 , string , uint256) {
280        return (products[_ProductID].ProductID,
281                products[_ProductID].ProductName,
282                products[_ProductID].ProductPrice);
283     }
284 ///////////////////////////////////////////////     
285 //     Shop management start here           //
286 //////////////////////////////////////////////     
287 
288     function payshop(address _Seller, uint256 price, uint ItemID) public returns (bool sucess){
289        require (balances[msg.sender] >= price && price > 0 );
290         _transfer(msg.sender,_Seller,price);
291         ShopItemSold(msg.sender, _Seller, ItemID, price, now);
292         return true;
293            
294     } 
295     function payshopwithfees(address _Seller, uint256 _value, uint ItemID) public returns (bool sucess){
296         require (balances[msg.sender] >= _value && _value > 0);
297         uint256 priceaftercomm = _value.safeMul(900).safeDiv(1000);
298         uint256 amountofcomm = _value.safeSub(priceaftercomm);
299         _transfer(msg.sender, onlyadmin, amountofcomm);
300         _transfer(msg.sender, _Seller, priceaftercomm);
301         ShopFrontEnd(msg.sender, _Seller, ItemID, _value, now);
302         return true;
303     }     
304 ///////////////////////////////////////////////     
305 //     Devidends Functions start here       //
306 //////////////////////////////////////////////  
307      // Set monthly profit is by contract owner to add company profit made
308      // contract calculate the token value from profit and build interest rate
309      // Shareholder is the request owner 
310      // contract calculate the amount and return the profit value to transfer 
311      // balance in ether will be transfered to share holder
312      // account will be frozen from sending funds to other addresses to prevent fraud and double profit claiming
313      // however spending tokens on website will not be affected
314     function Setmonthlyprofit(uint256 _monthProfit, uint256 _monthProfitStart, uint256 _monthProfitEnd) onlyOwner public {
315         MonthsProfit = _monthProfit;
316         Monthprofitstart = _monthProfitStart;
317         Monthprofitend = _monthProfitEnd;
318         Buildinterest();
319         logprofitandshare(SharePrice, MonthsProfit);
320       }
321     function Buildinterest() internal returns(uint256){
322         if (MonthsProfit == 0) {
323            return 0;}
324     uint256 monthsprofitwei = MonthsProfit.safeMul(1 ether);    // turn the value to 18 digits wei amount
325     uint256 _SharePrice = monthsprofitwei.safeDiv(50000000);            // Set Z amount
326     SharePrice = _SharePrice;
327      assert(SharePrice == _SharePrice);
328     }
329     function Requestprofit() public returns(bool) {
330         require(now > Monthprofitstart && now < Monthprofitend);
331         require (balances[msg.sender] >= 500000E18 && frozenAccount[msg.sender] < now);
332 
333         uint256 actualclaimable = (balances[msg.sender] / 1 ether); 
334         uint256 actualprofit = actualclaimable.safeMul(SharePrice);
335        // uint256 actualprofitaftertxn = actualprofit.safeMul(900).safeDiv(1000);
336         if(actualprofit != 0){
337         msg.sender.transfer(actualprofit);
338         freezeAccount();
339         ProfitTransfer(msg.sender, balances[msg.sender], actualprofit, now);
340         FrozenFunds(msg.sender, now, frozenAccount[msg.sender]);
341         return true;
342         } else{ RequesProfitFail(msg.sender, actualclaimable, actualprofit, now);
343         return false;
344      }
345      }
346     function freezeAccount() internal returns(bool) {
347         frozenAccount[msg.sender] = now + (Monthprofitend - now);
348         return true;
349     }
350     function FORCEfreezeAccount(uint256 frozentime, address target) onlyOwner public returns(bool) {
351         frozenAccount[target] = frozentime;
352         return true;
353     }
354     //reported lost wallet //Critical emergency
355     function BustTokens(address _target, uint256 _amount) onlyOwner public returns (bool){
356         require(balances[_target] > 0);
357         _transfer(_target, onlyadmin, _amount);
358         return true;
359     }
360 }