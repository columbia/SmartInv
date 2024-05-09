1 pragma solidity ^0.4.11;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6 function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
7 uint256 z = x + y;
8       assert((z >= x) && (z >= y));
9       return z;
10     }
11 
12     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
13       assert(x >= y);
14       uint256 z = x - y;
15       return z;
16     }
17 
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19       uint256 z = x * y;
20       assert((x == 0)||(z/x == y));
21       return z;
22     }
23 
24 }
25 
26 
27 contract EvenCoin is SafeMath {
28 
29     // metadata
30     string public constant name = "EvenCoin";
31     string public constant symbol = "EVN";
32     uint256 public constant decimals = 18;
33     string public version = "1.0";
34 
35     // contracts
36     address public founder;      // deposit address for ETH for EvenCoin
37     // crowdsale parameters
38     bool public isFinalized;              // switched to true in operational state
39     bool public saleStarted; //switched to true during ICO
40     uint public firstWeek;
41     uint public secondWeek;
42     uint public thirdWeek;
43     uint256 public soldCoins;
44     uint256 public totalGenesisAddresses;
45     uint256 public currentGenesisAddresses;
46     uint256 public initialSupplyPerAddress;
47     uint256 public initialBlockCount;
48     uint256 private minedBlocks;
49     uint256 public rewardPerBlockPerAddress;
50     uint256 private availableAmount;
51     uint256 private availableBalance;
52     uint256 private totalMaxAvailableAmount;
53     uint256 public constant founderFund = 5 * (10**6) * 10**decimals;   // 12.5m EvenCoin reserved for Owners
54     uint256 public constant preMinedFund = 10 * (10**6) * 10**decimals;   // 12.5m EvenCoin reserved for Promotion, Exchange etc.
55     uint256 public tokenExchangeRate = 2000; //  EvenCoin tokens per 1 ETH
56     mapping (address => uint256) balances;
57     mapping (address => bool) public genesisAddress;
58 
59 
60     // events
61     event CreateEVN(address indexed _to, uint256 _value);
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63 
64     // constructor
65     function EvenCoin()
66     {
67       isFinalized = false;                   //controls pre through crowdsale state
68       saleStarted = false;
69       soldCoins = 0;
70       founder = '0x9e8De5BE5B046D2c85db22324260D624E0ddadF4';
71       initialSupplyPerAddress = 21250 * 10**decimals;
72       rewardPerBlockPerAddress = 898444106206663;
73       totalGenesisAddresses = 4000;
74       currentGenesisAddresses = 0;
75       initialBlockCount = 0;
76       balances[founder] = founderFund;    // Deposit tokens for Owners
77       CreateEVN(founder, founderFund);  // logs Owners deposit
78 
79 
80 
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function currentEthBlock() constant returns (uint256 blockNumber)
88     {
89     	return block.number;
90     }
91 
92     function currentBlock() constant returns (uint256 blockNumber)
93     {
94       if(initialBlockCount == 0){
95         return 0;
96       }
97       else{
98       return block.number - initialBlockCount;
99     }
100     }
101 
102     function setGenesisAddressArray(address[] _address) public returns (bool success)
103     {
104       if(initialBlockCount == 0) throw;
105       uint256 tempGenesisAddresses = currentGenesisAddresses + _address.length;
106       if (tempGenesisAddresses <= totalGenesisAddresses )
107     	{
108     		if (msg.sender == founder)
109     		{
110           currentGenesisAddresses = currentGenesisAddresses + _address.length;
111     			for (uint i = 0; i < _address.length; i++)
112     			{
113     				balances[_address[i]] = initialSupplyPerAddress;
114     				genesisAddress[_address[i]] = true;
115     			}
116     			return true;
117     		}
118     	}
119     	return false;
120     }
121 
122     function availableBalanceOf(address _address) constant returns (uint256 Balance)
123     {
124     	if (genesisAddress[_address])
125     	{
126     		minedBlocks = block.number - initialBlockCount;
127         if(minedBlocks % 2 != 0){
128           minedBlocks = minedBlocks - 1;
129         }
130 
131     		if (minedBlocks >= 23652000) return balances[_address];
132     		  availableAmount = rewardPerBlockPerAddress*minedBlocks;
133     		  totalMaxAvailableAmount = initialSupplyPerAddress - availableAmount;
134           availableBalance = balances[_address] - totalMaxAvailableAmount;
135           return availableBalance;
136     	}
137     	else {
138     		return balances[_address];
139       }
140     }
141 
142     function totalSupply() constant returns (uint256 totalSupply)
143     {
144       if (initialBlockCount != 0)
145       {
146       minedBlocks = block.number - initialBlockCount;
147       if(minedBlocks % 2 != 0){
148         minedBlocks = minedBlocks - 1;
149       }
150     	availableAmount = rewardPerBlockPerAddress*minedBlocks;
151     }
152     else{
153       availableAmount = 0;
154     }
155     	return availableAmount*totalGenesisAddresses+founderFund+preMinedFund;
156     }
157 
158     function maxTotalSupply() constant returns (uint256 maxSupply)
159     {
160     	return initialSupplyPerAddress*totalGenesisAddresses+founderFund+preMinedFund;
161     }
162 
163     function transfer(address _to, uint256 _value)
164     {
165       if (genesisAddress[_to]) throw;
166 
167       if (balances[msg.sender] < _value) throw;
168 
169       if (balances[_to] + _value < balances[_to]) throw;
170 
171       if (genesisAddress[msg.sender])
172       {
173     	   minedBlocks = block.number - initialBlockCount;
174          if(minedBlocks % 2 != 0){
175            minedBlocks = minedBlocks - 1;
176          }
177     	    if (minedBlocks < 23652000)
178     	     {
179     		       availableAmount = rewardPerBlockPerAddress*minedBlocks;
180     		       totalMaxAvailableAmount = initialSupplyPerAddress - availableAmount;
181     		       availableBalance = balances[msg.sender] - totalMaxAvailableAmount;
182     		       if (_value > availableBalance) throw;
183     	     }
184       }
185       balances[msg.sender] -= _value;
186       balances[_to] += _value;
187       Transfer(msg.sender, _to, _value);
188     }
189 
190     /// @dev Accepts ether and creates new EVN tokens.
191     function () payable {
192       //bool isPreSale = true;
193       if (isFinalized) throw;
194       if (!saleStarted) throw;
195       if (msg.value == 0) throw;
196       //change exchange rate based on duration
197       if (now > firstWeek && now < secondWeek){
198         tokenExchangeRate = 1500;
199       }
200       else if (now > secondWeek && now < thirdWeek){
201         tokenExchangeRate = 1000;
202       }
203       else if (now > thirdWeek){
204         tokenExchangeRate = 500;
205       }
206       //create tokens
207       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
208       uint256 checkedSupply = safeAdd(soldCoins, tokens);
209 
210       // return money if something goes wrong
211       if (preMinedFund < checkedSupply) throw;  // odd fractions won't be found
212       soldCoins = checkedSupply;
213       //All good. start the transfer
214       balances[msg.sender] += tokens;  // safeAdd not needed
215       CreateEVN(msg.sender, tokens);  // logs token creation
216     }
217 
218     /// EvenCoin Ends the funding period and sends the ETH home
219     function finalize() external {
220       if (isFinalized) throw;
221       if (msg.sender != founder) throw; // locks finalize to the ultimate ETH owner
222       if (soldCoins < preMinedFund){
223         uint256 remainingTokens = safeSubtract(preMinedFund, soldCoins);
224         uint256 checkedSupply = safeAdd(soldCoins, remainingTokens);
225         if (preMinedFund < checkedSupply) throw;
226         soldCoins = checkedSupply;
227         balances[msg.sender] += remainingTokens;
228         CreateEVN(msg.sender, remainingTokens);
229       }
230       // move to operational
231       if(!founder.send(this.balance)) throw;
232       isFinalized = true;  // send the eth to EvenCoin
233       if (block.number % 2 != 0){
234         initialBlockCount = safeAdd(block.number, 1);
235       }
236       else{
237         initialBlockCount = block.number;
238       }
239     }
240 
241     function startSale() external {
242       if(saleStarted) throw;
243       if (msg.sender != founder) throw; // locks start sale to the ultimate ETH owner
244       firstWeek = now + 1 weeks; //sets duration of first cutoff
245       secondWeek = firstWeek + 1 weeks; //sets duration of second cutoff
246       thirdWeek = secondWeek + 1 weeks; //sets duration of third cutoff
247       saleStarted = true; //start the sale
248     }
249 
250 
251 }