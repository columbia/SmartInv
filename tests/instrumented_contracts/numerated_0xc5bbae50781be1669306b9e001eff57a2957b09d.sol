1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Gifto Token by Gifto Limited.
5 // An ERC20 standard
6 //
7 // author: Gifto Team
8 // Contact: datwhnguyen@gmail.com
9 
10 contract ERC20Interface {
11     // Get the total token supply
12     function totalSupply() public constant returns (uint256 _totalSupply);
13  
14     // Get the account balance of another account with address _owner
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16  
17     // Send _value amount of tokens to address _to
18     function transfer(address _to, uint256 _value) public returns (bool success);
19     
20     // transfer _value amount of token approved by address _from
21     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
22 
23     // approve an address with _value amount of tokens
24     function approve(address _spender, uint256 _value) public returns (bool success);
25 
26     // get remaining token approved by _owner to _spender
27     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
28   
29     // Triggered when tokens are transferred.
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31  
32     // Triggered whenever approve(address _spender, uint256 _value) is called.
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35  
36 contract Gifto is ERC20Interface {
37     uint256 public constant decimals = 5;
38 
39     string public constant symbol = "GTO";
40     string public constant name = "Gifto";
41 
42     bool public _selling = true;//initial selling
43     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 Gifto
44     uint256 public _originalBuyPrice = 43 * 10**7; // original buy 1ETH = 4300 Gifto = 43 * 10**7 unit
45 
46     // Owner of this contract
47     address public owner;
48  
49     // Balances Gifto for each account
50     mapping(address => uint256) private balances;
51     
52     // Owner of account approves the transfer of an amount to another account
53     mapping(address => mapping (address => uint256)) private allowed;
54 
55     // List of approved investors
56     mapping(address => bool) private approvedInvestorList;
57     
58     // deposit
59     mapping(address => uint256) private deposit;
60     
61     // icoPercent
62     uint256 public _icoPercent = 10;
63     
64     // _icoSupply is the avalable unit. Initially, it is _totalSupply
65     uint256 public _icoSupply = _totalSupply * _icoPercent / 100;
66     
67     // minimum buy 0.3 ETH
68     uint256 public _minimumBuy = 3 * 10 ** 17;
69     
70     // maximum buy 25 ETH
71     uint256 public _maximumBuy = 25 * 10 ** 18;
72 
73     // totalTokenSold
74     uint256 public totalTokenSold = 0;
75     
76     // tradable
77     bool public tradable = false;
78     
79     /**
80      * Functions with this modifier can only be executed by the owner
81      */
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     /**
88      * Functions with this modifier check on sale status
89      * Only allow sale if _selling is on
90      */
91     modifier onSale() {
92         require(_selling);
93         _;
94     }
95     
96     /**
97      * Functions with this modifier check the validity of address is investor
98      */
99     modifier validInvestor() {
100         require(approvedInvestorList[msg.sender]);
101         _;
102     }
103     
104     /**
105      * Functions with this modifier check the validity of msg value
106      * value must greater than equal minimumBuyPrice
107      * total deposit must less than equal maximumBuyPrice
108      */
109     modifier validValue(){
110         // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice
111         require ( (msg.value >= _minimumBuy) &&
112                 ( (deposit[msg.sender] + msg.value) <= _maximumBuy) );
113         _;
114     }
115     
116     /**
117      * 
118      */
119     modifier isTradable(){
120         require(tradable == true || msg.sender == owner);
121         _;
122     }
123 
124     /// @dev Fallback function allows to buy ether.
125     function()
126         public
127         payable {
128         buyGifto();
129     }
130     
131     /// @dev buy function allows to buy ether. for using optional data
132     function buyGifto()
133         public
134         payable
135         onSale
136         validValue
137         validInvestor {
138         uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;
139         require(balances[owner] >= requestedUnits);
140         // prepare transfer data
141         balances[owner] -= requestedUnits;
142         balances[msg.sender] += requestedUnits;
143         
144         // increase total deposit amount
145         deposit[msg.sender] += msg.value;
146         
147         // check total and auto turnOffSale
148         totalTokenSold += requestedUnits;
149         if (totalTokenSold >= _icoSupply){
150             _selling = false;
151         }
152         
153         // submit transfer
154         Transfer(owner, msg.sender, requestedUnits);
155         owner.transfer(msg.value);
156     }
157 
158     /// @dev Constructor
159     function Gifto() 
160         public {
161         owner = msg.sender;
162         setBuyPrice(_originalBuyPrice);
163         balances[owner] = _totalSupply;
164         Transfer(0x0, owner, _totalSupply);
165     }
166     
167     /// @dev Gets totalSupply
168     /// @return Total supply
169     function totalSupply()
170         public 
171         constant 
172         returns (uint256) {
173         return _totalSupply;
174     }
175     
176     /// @dev Enables sale 
177     function turnOnSale() onlyOwner 
178         public {
179         _selling = true;
180     }
181 
182     /// @dev Disables sale
183     function turnOffSale() onlyOwner 
184         public {
185         _selling = false;
186     }
187     
188     function turnOnTradable() 
189         public
190         onlyOwner{
191         tradable = true;
192     }
193     
194     /// @dev set new icoPercent
195     /// @param newIcoPercent new value of icoPercent
196     function setIcoPercent(uint256 newIcoPercent)
197         public 
198         onlyOwner {
199         _icoPercent = newIcoPercent;
200         _icoSupply = _totalSupply * _icoPercent / 100;
201     }
202     
203     /// @dev set new _maximumBuy
204     /// @param newMaximumBuy new value of _maximumBuy
205     function setMaximumBuy(uint256 newMaximumBuy)
206         public 
207         onlyOwner {
208         _maximumBuy = newMaximumBuy;
209     }
210 
211     /// @dev Updates buy price (owner ONLY)
212     /// @param newBuyPrice New buy price (in unit)
213     function setBuyPrice(uint256 newBuyPrice) 
214         onlyOwner 
215         public {
216         require(newBuyPrice>0);
217         _originalBuyPrice = newBuyPrice; // 3000 Gifto = 3000 00000 unit
218         // control _maximumBuy_USD = 10,000 USD, Gifto price is 0.1USD
219         // maximumBuy_Gifto = 100,000 Gifto = 100,000,00000 unit
220         // 3000 Gifto = 1ETH => maximumETH = 100,000,00000 / _originalBuyPrice
221         // 100,000,00000/3000 0000 ~ 33ETH => change to wei
222         _maximumBuy = 10**18 * 10000000000 /_originalBuyPrice;
223     }
224         
225     /// @dev Gets account's balance
226     /// @param _addr Address of the account
227     /// @return Account balance
228     function balanceOf(address _addr) 
229         public
230         constant 
231         returns (uint256) {
232         return balances[_addr];
233     }
234     
235     /// @dev check address is approved investor
236     /// @param _addr address
237     function isApprovedInvestor(address _addr)
238         public
239         constant
240         returns (bool) {
241         return approvedInvestorList[_addr];
242     }
243     
244     /// @dev get ETH deposit
245     /// @param _addr address get deposit
246     /// @return amount deposit of an buyer
247     function getDeposit(address _addr)
248         public
249         constant
250         returns(uint256){
251         return deposit[_addr];
252 }
253     
254     /// @dev Adds list of new investors to the investors list and approve all
255     /// @param newInvestorList Array of new investors addresses to be added
256     function addInvestorList(address[] newInvestorList)
257         onlyOwner
258         public {
259         for (uint256 i = 0; i < newInvestorList.length; i++){
260             approvedInvestorList[newInvestorList[i]] = true;
261         }
262     }
263 
264     /// @dev Removes list of investors from list
265     /// @param investorList Array of addresses of investors to be removed
266     function removeInvestorList(address[] investorList)
267         onlyOwner
268         public {
269         for (uint256 i = 0; i < investorList.length; i++){
270             approvedInvestorList[investorList[i]] = false;
271         }
272     }
273  
274     /// @dev Transfers the balance from msg.sender to an account
275     /// @param _to Recipient address
276     /// @param _amount Transfered amount in unit
277     /// @return Transfer status
278     function transfer(address _to, uint256 _amount)
279         public 
280         isTradable
281         returns (bool) {
282         // if sender's balance has enough unit and amount >= 0, 
283         //      and the sum is not overflow,
284         // then do transfer 
285         if ( (balances[msg.sender] >= _amount) &&
286              (_amount >= 0) && 
287              (balances[_to] + _amount > balances[_to]) ) {  
288 
289             balances[msg.sender] -= _amount;
290             balances[_to] += _amount;
291             Transfer(msg.sender, _to, _amount);
292             return true;
293         } else {
294             return false;
295         }
296     }
297      
298     // Send _value amount of tokens from address _from to address _to
299     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
300     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
301     // fees in sub-currencies; the command should fail unless the _from account has
302     // deliberately authorized the sender of the message via some mechanism; we propose
303     // these standardized APIs for approval:
304     function transferFrom(
305         address _from,
306         address _to,
307         uint256 _amount
308     )
309     public
310     isTradable
311     returns (bool success) {
312         if (balances[_from] >= _amount
313             && allowed[_from][msg.sender] >= _amount
314             && _amount > 0
315             && balances[_to] + _amount > balances[_to]) {
316             balances[_from] -= _amount;
317             allowed[_from][msg.sender] -= _amount;
318             balances[_to] += _amount;
319             Transfer(_from, _to, _amount);
320             return true;
321         } else {
322             return false;
323         }
324     }
325     
326     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
327     // If this function is called again it overwrites the current allowance with _value.
328     function approve(address _spender, uint256 _amount) 
329         public
330         isTradable
331         returns (bool success) {
332         allowed[msg.sender][_spender] = _amount;
333         Approval(msg.sender, _spender, _amount);
334         return true;
335     }
336     
337     // get allowance
338     function allowance(address _owner, address _spender) 
339         public
340         constant 
341         returns (uint256 remaining) {
342         return allowed[_owner][_spender];
343     }
344     
345     /// @dev Withdraws Ether in contract (Owner only)
346     /// @return Status of withdrawal
347     function withdraw() onlyOwner 
348         public 
349         returns (bool) {
350         return owner.send(this.balance);
351     }
352 }