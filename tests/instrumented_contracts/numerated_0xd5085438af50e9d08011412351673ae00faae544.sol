1 pragma solidity ^0.4.0;
2 
3 
4 //Dapp at http://www.staticoin.com
5 //https://github.com/genkifs/staticoin
6 
7 /** @title owned. */
8 contract owned  {
9   address owner;
10   function owned() {
11     owner = msg.sender;
12   }
13   function changeOwner(address newOwner) onlyOwner {
14     owner = newOwner;
15   }
16   modifier onlyOwner() {
17     require(msg.sender==owner); 
18     _;
19   }
20 }
21 
22 /** @title I_Pricer. */
23 contract I_Pricer {
24     uint128 public lastPrice;
25     I_minter public mint;
26     string public sURL;
27     mapping (bytes32 => uint) RevTransaction;
28     function __callback(bytes32 myid, string result) {}
29     function queryCost() constant returns (uint128 _value) {}
30     function QuickPrice() payable {}
31     function requestPrice(uint _actionID) payable returns (uint _TrasID) {}
32     function collectFee() returns(bool) {}
33     function () {
34         //if ether is sent to this address, send it back.
35         revert();
36     }
37 }
38     
39 
40 /** @title I_coin. */
41 contract I_coin {
42 
43     event EventClear();
44 
45 	I_minter public mint;
46     string public name;                   //fancy name: eg Simon Bucks
47     uint8 public decimals=18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
48     string public symbol;                 //An identifier: eg SBX
49     string public version = '';       //human 0.1 standard. Just an arbitrary versioning scheme.
50 	
51     function mintCoin(address target, uint256 mintedAmount) returns (bool success) {}
52     function meltCoin(address target, uint256 meltedAmount) returns (bool success) {}
53     function approveAndCall(address _spender, uint256 _value, bytes _extraData){}
54 
55     function setMinter(address _minter) {}   
56 	function increaseApproval (address _spender, uint256 _addedValue) returns (bool success) {}    
57 	function decreaseApproval (address _spender, uint256 _subtractedValue) 	returns (bool success) {} 
58 
59     // @param _owner The address from which the balance will be retrieved
60     // @return The balance
61     function balanceOf(address _owner) constant returns (uint256 balance) {}    
62 
63 
64     // @notice send `_value` token to `_to` from `msg.sender`
65     // @param _to The address of the recipient
66     // @param _value The amount of token to be transferred
67     // @return Whether the transfer was successful or not
68     function transfer(address _to, uint256 _value) returns (bool success) {}
69 
70 
71     // @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
72     // @param _from The address of the sender
73     // @param _to The address of the recipient
74     // @param _value The amount of token to be transferred
75     // @return Whether the transfer was successful or not
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
77 
78     // @notice `msg.sender` approves `_addr` to spend `_value` tokens
79     // @param _spender The address of the account able to transfer the tokens
80     // @param _value The amount of wei to be approved for transfer
81     // @return Whether the approval was successful or not
82     function approve(address _spender, uint256 _value) returns (bool success) {}
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 	
87 	// @param _owner The address of the account owning tokens
88     // @param _spender The address of the account able to transfer the tokens
89     // @return Amount of remaining tokens allowed to spent
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
91 	
92 	mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94 
95 	// @return total amount of tokens
96     uint256 public totalSupply;
97 }
98 
99 /** @title I_minter. */
100 contract I_minter { 
101     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
102     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
103     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
104     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
105     event EventBankrupt();
106     
107 	uint128 public PendingETH; 
108     uint public TransCompleted;
109 	
110     function Leverage() constant returns (uint128)  {}
111     function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) constant returns (uint128 price)  {}
112     function RiskPrice(uint128 _currentPrice) constant returns (uint128 price)  {}     
113     function PriceReturn(uint _TransID,uint128 _Price) {}
114 	function StaticEthAvailable() public constant returns (uint128 StaticEthAvailable) {}
115     function NewStatic() external payable returns (uint _TransID)  {}
116     function NewStaticAdr(address _Risk) external payable returns (uint _TransID)  {}
117     function NewRisk() external payable returns (uint _TransID)  {}
118     function NewRiskAdr(address _Risk) external payable returns (uint _TransID)  {}
119     function RetRisk(uint128 _Quantity) external payable returns (uint _TransID)  {}
120     function RetStatic(uint128 _Quantity) external payable returns (uint _TransID)  {}
121     function Strike() constant returns (uint128)  {}
122 }
123 
124 contract StaticoinSummary is owned{
125 
126     function StaticoinSummary(){}
127 
128 	address[] public mints;
129 	address[] public staticoins; 
130 	address[] public riskcoins;
131 	address[] public pricers;
132 
133     function SetAddresses(address[] _mints, address[] _staticoins, address[] _riskcoins,  address[] _pricers) onlyOwner external {
134 		require(_mints.length > 0);
135 		require(_staticoins.length == _mints.length);
136         require(_riskcoins.length == _mints.length);
137 		require(_pricers.length == _mints.length);
138 		mints=_mints;
139 		staticoins=_staticoins;
140 		riskcoins=_riskcoins;
141 		pricers=_pricers;
142 	}
143 
144 	function balancesStaticoin() view public returns (uint[]) {
145 		return balances(msg.sender, staticoins);
146 	}
147 
148 	function balancesStaticoin(address user) view public returns (uint[]) {
149 		return balances(user, staticoins);
150 	}
151 
152 	function balancesRiskcoins() view public returns (uint[]) {
153 		return balances(msg.sender, riskcoins);
154 	}
155 	
156 	function balancesRiskcoins(address user) view public returns (uint[]) {
157 		return balances(user, riskcoins);
158 	}
159 	
160     function balances(address user,  address[] _coins) view public returns (uint[]) {
161         require(_coins.length > 0);
162         uint[] memory balances = new uint[](_coins.length);
163 
164         //as this is a call() function, we don't really care about gas cost, just dont make the array too large
165         for(uint i = 0; i< _coins.length; i++){ 
166             I_coin coin = I_coin(_coins[i]);
167             balances[i] = coin.balanceOf(user);
168         }    
169         return balances;
170     }
171   
172     function Totalbalance() view public returns (uint) {
173 		return Totalbalance(mints);
174 	}  
175     
176     function Totalbalance(address[] _mints) view public returns (uint) {
177         require(_mints.length > 0);
178         uint balance;
179 
180         //as this is a call() function, we don't really care about gas cost, just dont make the array too large
181         for(uint i = 0; i< _mints.length; i++){ 
182             I_minter coin = I_minter(_mints[i]);
183             balance += coin.balance;
184         }    
185         return balance;
186     }
187 
188 	function totalStaticoinSupplys() view public returns (uint[]) {
189 		return totalSupplys(staticoins);
190 	}
191 	
192 	function totalriskcoinsSupplys() view public returns (uint[]) {
193 		return totalSupplys(riskcoins);
194 	}
195 	
196     function totalSupplys(address[] _coins) view public returns (uint[]) {
197         require(_coins.length > 0);
198         uint[] memory totalSupplys = new uint[](_coins.length);
199 
200         for(uint i = 0; i< _coins.length; i++){
201             I_coin coin = I_coin(_coins[i]);
202             totalSupplys[i] = coin.totalSupply();
203         }    
204         return totalSupplys;
205     }
206  
207     function Leverages() view public returns (uint128[]) {
208 		return Leverages(mints);
209 	}
210  
211     function Leverages(address[] _mints) view public returns (uint128[]) {
212         require(_mints.length > 0);
213         uint128[] memory Leverages = new uint128[](_mints.length);
214 
215         for(uint i = 0; i< _mints.length; i++){
216             I_minter mint = I_minter(_mints[i]);
217             Leverages[i] = mint.Leverage();
218         }    
219         return Leverages;
220     }
221 
222     function Strikes() view public returns (uint128[]) {
223 		return Strikes(mints);
224 	}
225 	
226     function Strikes(address[] _mints) view public returns (uint128[]) {
227         require(_mints.length > 0);
228         uint128[] memory Strikes = new uint128[](_mints.length);
229 
230         for(uint i = 0; i< _mints.length; i++){
231             I_minter mint = I_minter(_mints[i]);
232             Strikes[i] = mint.Strike();
233         }    
234         return Strikes;
235     }   
236     
237 	function StaticEthAvailables() view public returns (uint128[]) {
238 		return StaticEthAvailables(mints);
239 	}
240 	
241     function StaticEthAvailables(address[] _mints) view public returns (uint128[]) {
242         require(_mints.length > 0);
243         uint128[] memory StaticEthAvailables = new uint128[](_mints.length);
244 
245         for(uint i = 0; i< _mints.length; i++){
246             I_minter mint = I_minter(_mints[i]);
247             StaticEthAvailables[i] = mint.StaticEthAvailable();
248         }    
249         return StaticEthAvailables;
250     }
251 
252     function PendingETHs() view public returns (uint128[]) {
253 		return PendingETHs(mints);
254 	}
255 	
256     function PendingETHs(address[] _mints) view public returns (uint128[]) {
257         require(_mints.length > 0);
258         uint128[] memory PendingETHs = new uint128[](_mints.length);
259 
260         for(uint i = 0; i< _mints.length; i++){
261             I_minter mint = I_minter(_mints[i]);
262             PendingETHs[i] = mint.PendingETH();
263         }    
264         return PendingETHs;
265     }
266 
267 	function RiskPrices(uint128[] prices) view public returns (uint[]) {
268 		return RiskPrices(mints,prices);
269 	}
270 	
271     function RiskPrices(address[] _mints, uint128[] prices) view public returns (uint[]) {
272         require(_mints.length > 0);
273         require(_mints.length == prices.length);
274         uint[] memory RiskPrices = new uint[](_mints.length);
275 
276         for(uint i = 0; i< _mints.length; i++){
277             I_minter mint = I_minter(_mints[i]);
278             RiskPrices[i] = mint.RiskPrice(prices[i]);
279         }    
280         return RiskPrices;
281     }
282  
283     function TransCompleteds() view public returns (uint[]) {
284 		return TransCompleteds(mints);
285 	}
286 
287     function TransCompleteds(address[] _mints) view public returns (uint[]) {
288         require(_mints.length > 0);
289         uint[] memory TransCompleteds = new uint[](_mints.length);
290 
291         for(uint i = 0; i< _mints.length; i++){
292             I_minter mint = I_minter(_mints[i]);
293             TransCompleteds[i] = mint.TransCompleted();
294         }    
295         return TransCompleteds;
296     }
297     
298     function queryCost() view public returns (uint[]) {
299         return queryCost(pricers);
300     }
301 
302     function queryCost(address[] _pricers) view public returns (uint[]) {
303         require(_pricers.length > 0);
304         uint[] memory queryCosts = new uint[](_pricers.length);
305 
306         for(uint i = 0; i< _pricers.length; i++){
307             I_Pricer Pricer = I_Pricer(_pricers[i]);
308             queryCosts[i] = Pricer.queryCost();
309         }    
310         return queryCosts;
311     }
312     
313     function TotalFee() view returns(uint) {
314         return TotalFee(pricers);
315     }
316 
317 	function TotalFee(address[] _pricers) view returns(uint) {
318 		uint size = (_pricers.length);
319 		uint fee;
320 		for(uint i = 0; i< size; i++){
321 			I_Pricer pricer = I_Pricer(_pricers[i]);
322 			fee += pricer.balance;
323 		}
324 		return fee;
325 	}
326 
327 	function collectFee() onlyOwner returns(bool) {
328 		return collectFee(pricers);
329 	}
330 	
331 	function collectFee(address[] _pricers) onlyOwner returns(bool) {
332 		uint size = (_pricers.length);
333 		bool ans = true;
334 		for(uint i = 0; i< size; i++){
335 			I_Pricer pricer = I_Pricer(_pricers[i]);
336 			ans = ans && pricer.collectFee();
337 		}
338 		return ans;
339 	}
340 
341     function Summary(address user, uint128[] _prices) view public returns (uint[]){
342 		return Summary(user, mints, staticoins, riskcoins, _prices);
343 	}
344     
345     function Summary(address user, address[] _mints, address[] _staticoins, address[] _riskcoins, uint128[] _prices) view public returns (uint[]) {
346         uint size = (_mints.length);
347 		require(size > 0);
348         require(_staticoins.length == size);
349         require(_riskcoins.length == size);
350         require(_prices.length == size);
351         uint step = 11;
352         uint[] memory Summarys = new uint[](size*step+1);
353         I_Pricer pricer = I_Pricer(pricers[0]);
354 		Summarys[0] = pricer.queryCost(); //can only pass in 4 arrays to the function.  This now assumes that all pricers have the same query cost
355 
356         for(uint i = 0; i< size; i++){
357             I_coin staticoin = I_coin(_staticoins[i]);
358             I_coin riskcoin = I_coin(_riskcoins[i]);
359             I_minter mint = I_minter(_mints[i]);
360             Summarys[i*step+1]  = staticoin.balanceOf(user);
361             Summarys[i*step+2]  = riskcoin.balanceOf(user);
362             Summarys[i*step+3]  = staticoin.totalSupply();
363             Summarys[i*step+4]  = riskcoin.totalSupply();
364             Summarys[i*step+5]  = mint.Leverage();
365             Summarys[i*step+6]  = mint.Strike();
366             Summarys[i*step+7]  = mint.StaticEthAvailable();
367             Summarys[i*step+8]  = mint.PendingETH();
368             Summarys[i*step+9]  = mint.RiskPrice(_prices[i]);
369             Summarys[i*step+10]  = mint.TransCompleted();
370             Summarys[i*step+11] = mint.balance;
371         }    
372         return Summarys;
373     }
374 	
375 	function () {
376         revert();
377     }
378 
379 }