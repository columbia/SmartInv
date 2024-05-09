1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4   function balanceOf(address who) constant returns (uint);
5   function allowance(address owner, address spender) constant returns (uint);
6 
7   function transfer(address to, uint value) returns (bool ok);
8   function transferFrom(address from, address to, uint value) returns (bool ok);
9   function approve(address spender, uint value) returns (bool ok);
10   event Transfer(address indexed from, address indexed to, uint value);
11   event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 //Safe math
15 contract SafeMath {
16   function safeMul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function safeDiv(uint a, uint b) internal returns (uint) {
23     assert(b > 0);
24     uint c = a / b;
25     assert(a == b * c + a % b);
26     return c;
27   }
28 
29   function safeSub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function safeAdd(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c>=a && c>=b);
37     return c;
38   }
39 
40   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a >= b ? a : b;
42   }
43 
44   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a < b ? a : b;
46   }
47 
48   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a >= b ? a : b;
50   }
51 
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55 
56 }
57 
58 contract StandardToken is ERC20, SafeMath {
59 
60   /* Token supply got increased and a new owner received these tokens */
61   event Minted(address receiver, uint amount);
62 
63   /* Actual balances of token holders */
64   mapping(address => uint) balances;
65 
66   /* approve() allowances */
67   mapping (address => mapping (address => uint)) allowed;
68 
69   /* Interface declaration */
70   function isToken() public constant returns (bool Yes) {
71     return true;
72   }
73 
74   function transfer(address _to, uint _value) returns (bool success) {
75     balances[msg.sender] = safeSub(balances[msg.sender], _value);
76     balances[_to] = safeAdd(balances[_to], _value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
82     uint _allowance = allowed[_from][msg.sender];
83 
84     balances[_to] = safeAdd(balances[_to], _value);
85     balances[_from] = safeSub(balances[_from], _value);
86     allowed[_from][msg.sender] = safeSub(_allowance, _value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _address) constant returns (uint balance) {
92     return balances[_address];
93   }
94 
95   function approve(address _spender, uint _value) returns (bool success) {
96 
97     // To change the approve amount you first have to reduce the addresses`
98     //  allowance to zero by calling `approve(_spender, 0)` if it is not
99     //  already 0 to mitigate the race condition described here:
100     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
102 
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) constant returns (uint remaining) {
109     return allowed[_owner][_spender];
110   }
111 
112 }
113 
114 contract CBZToken is StandardToken {
115 
116     string public name = "CryptoBazar Token";
117     string public symbol = "CBZ";
118     uint8 public decimals = 8;
119     uint256 public totalSupply = 1000000000 * (10 ** uint256(decimals));//Crowdsale supply
120 	uint public sellPrice = 1000000000000000 wei;//Tokens are sold for this manual price, rather than predefined price.
121     
122     //Addresses that are allowed to transfer tokens
123     mapping (address => bool) public allowedTransfer;
124 	
125 	//Technical variables to store states
126 	bool public TransferAllowed = true;//Token transfers are blocked
127     bool public CrowdsalePaused = false; //Whether the Crowdsale is now suspended (true or false)
128 	
129     //Technical variables to store statistical data
130 	uint public StatsEthereumRaised = 0 wei;//Total Ethereum raised
131 	uint public StatsSold = 0;//Sold tokens amount
132 	uint public StatsMinted = 0;//Minted tokens amount
133 	uint public StatsTotal = 0;//Overall tokens amount
134 
135     //Event logs
136     event Buy(address indexed sender, uint eth, uint tokens);//Tokens purchased
137     event Mint(address indexed from, uint tokens);// This notifies clients about the amount minted
138     event Burn(address indexed from, uint tokens);// This notifies clients about the amount burnt
139     event PriceChanged(string _text, uint _tokenPrice);//Manual token price
140     
141     address public owner = 0x0;//Admin actions
142     address public minter = 0x0;//Minter tokens
143     address public wallet = 0x0;//Wallet to receive ETH
144  
145 function CBZToken(address _owner, address _minter, address _wallet) payable {
146     
147       owner = _owner;
148       minter = _minter;
149       wallet = _wallet;
150     
151       balances[owner] = 0;
152       balances[minter] = 0;
153       balances[wallet] = 0;
154     
155       allowedTransfer[owner] = true;
156       allowedTransfer[minter] = true;
157       allowedTransfer[wallet] = true;
158     }
159     
160     modifier onlyOwner() {
161         require(msg.sender == owner);
162         _;
163     }
164     
165     modifier onlyMinter() {
166         require(msg.sender == minter);
167         _;
168     }
169 
170     //Transaction received - run the purchase function
171     function() payable {
172         buy();
173     }
174     
175     //See the current token price in wei (https://etherconverter.online to convert to other units, such as ETH)
176     function price() constant returns (uint) {
177         return sellPrice;
178     }
179     
180     //Manually set the token price (in wei - https://etherconverter.online)
181     function setTokenPrice(uint _tokenPrice) external onlyOwner {
182         sellPrice = _tokenPrice;
183         PriceChanged("New price is ", _tokenPrice);
184     }
185      
186     //Allow or prohibit token transfers
187     function setTransferAllowance(bool _allowance) external onlyOwner {
188         TransferAllowed = _allowance;
189     }
190     
191     //Temporarily suspend token sale
192     function eventPause(bool _pause) external onlyOwner {
193         CrowdsalePaused = _pause;
194     }
195     
196     // Send `_amount` of tokens to `_target`
197     function mintTokens(address _target, uint _amount) onlyMinter external returns (bool) {
198         require(_amount > 0);//Number of tokens must be greater than 0
199         require(safeAdd(StatsTotal, _amount) <= totalSupply);//The amount of tokens cannot be greater than Total supply
200         balances[_target] = safeAdd(balances[_target], _amount);
201         StatsMinted = safeAdd(StatsMinted, _amount);//Update number of tokens minted
202         StatsTotal = safeAdd(StatsTotal, _amount);//Update total number of tokens
203         Transfer(0, this, _amount);
204         Transfer(this, _target, _amount);
205         Mint(_target, _amount);
206         return true;
207     }
208     
209     // Decrease user balance
210     function decreaseTokens(address _target, uint _amount) onlyMinter external returns (bool) {
211         require(_amount > 0);//Number of tokens must be greater than 0
212         balances[_target] = safeSub(balances[_target], _amount);
213         StatsMinted = safeSub(StatsMinted, _amount);//Update number of tokens minted
214         StatsTotal = safeSub(StatsTotal, _amount);//Update total number of tokens
215         Transfer(_target, 0, _amount);
216         Burn(_target, _amount);
217         return true;
218     }
219     
220     // Allow `_target` make token tranfers
221     function allowTransfer(address _target, bool _allow) external onlyOwner {
222         allowedTransfer[_target] = _allow;
223     }
224 
225     //The function of buying tokens on Crowdsale
226     function buy() public payable returns(bool) {
227 
228         require(msg.sender != owner);//The founder cannot buy tokens
229         require(msg.sender != minter);//The minter cannot buy tokens
230         require(msg.sender != wallet);//The wallet address cannot buy tokens
231         require(!CrowdsalePaused);//Purchase permitted if Crowdsale is paused
232         require(msg.value >= price());//The amount received in wei must be greater than the cost of 1 token
233 
234         uint tokens = msg.value/price();//Number of tokens to be received by the buyer
235         require(tokens > 0);//Number of tokens must be greater than 0
236         
237         require(safeAdd(StatsTotal, tokens) <= totalSupply);//The amount of tokens cannot be greater than Total supply
238         
239         wallet.transfer(msg.value);//Send received ETH to the fundraising purse
240         
241         //Crediting of tokens to the buyer
242         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
243         StatsSold = safeAdd(StatsSold, tokens);//Update number of tokens sold
244         StatsTotal = safeAdd(StatsTotal, tokens);//Update total number of tokens
245         Transfer(0, this, tokens);
246         Transfer(this, msg.sender, tokens);
247         
248         StatsEthereumRaised = safeAdd(StatsEthereumRaised, msg.value);//Update total ETH collected
249         
250         //Record event logs to the blockchain
251         Buy(msg.sender, msg.value, tokens);
252 
253         return true;
254     }
255     
256     function transfer(address _to, uint _value) returns (bool success) {
257         
258         //Forbid token transfers
259         if(!TransferAllowed){
260             require(allowedTransfer[msg.sender]);
261         }
262         
263     return super.transfer(_to, _value);
264     }
265 
266     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
267         
268         //Forbid token transfers
269         if(!TransferAllowed){
270             require(allowedTransfer[msg.sender]);
271         }
272         
273         return super.transferFrom(_from, _to, _value);
274     }
275 
276     //Change owner
277     function changeOwner(address _to) external onlyOwner() {
278         balances[_to] = balances[owner];
279         balances[owner] = 0;
280         owner = _to;
281     }
282 
283     //Change minter
284     function changeMinter(address _to) external onlyOwner() {
285         balances[_to] = balances[minter];
286         balances[minter] = 0;
287         minter = _to;
288     }
289 
290     //Change wallet
291     function changeWallet(address _to) external onlyOwner() {
292         balances[_to] = balances[wallet];
293         balances[wallet] = 0;
294         wallet = _to;
295     }
296 }