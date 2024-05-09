1 pragma solidity ^0.4.18;
2 contract Artemine { 
3 
4 string public name; 
5 string public symbol; 
6 uint8 public decimals; 
7 uint256 initialBlockCount;
8 uint256 totalGenesisAddresses;
9 address genesisCallerAddress;
10 uint256 availableAmount;
11 uint256 availableBalance;
12 uint256 minedBlocks;
13 uint256 totalMaxAvailableAmount;
14 uint256 publicMiningReward;
15 uint256 publicMiningSupply;
16 uint256 overallSupply;
17 uint256 genesisSalesCount;
18 uint256 genesisSalesPriceCount;
19 uint256 genesisTransfersCount;
20 uint256 publicMineCallsCount;
21 bool setupRunning;
22 uint256 constant maxBlocks = 100000000;
23 
24 mapping (address => uint256) balances; 
25 mapping (address => bool) isGenesisAddress; 
26 mapping (address => uint256) genesisRewardPerBlock;
27 mapping (address => uint256) genesisInitialSupply;
28 mapping (address => uint256) genesisBuyPrice;
29 mapping (address => mapping (address => uint256)) allowed;
30 
31 event Transfer(address indexed from, address indexed to, uint256 value);
32 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 event GenesisAddressTransfer(address indexed from, address indexed to, uint256 supply);
34 event GenesisAddressSale(address indexed from, address indexed to, uint256 price, uint256 supply);
35 event GenesisBuyPriceHistory(address indexed from, uint256 price);
36 event PublicMined(address indexed to, uint256 amount);
37 
38 function Artemine() { 
39 name = "Artemine"; 
40 symbol = "ARTE"; 
41 decimals = 18; 
42 initialBlockCount = block.number;
43 publicMiningReward = 32000000000000;
44 totalGenesisAddresses = 0;
45 publicMiningSupply = 0;
46 overallSupply = 0;
47 genesisSalesCount = 0;
48 genesisSalesPriceCount = 0;
49 publicMineCallsCount = 0;
50 genesisTransfersCount = 0;
51 setupRunning = true;
52 genesisCallerAddress = 0x0000000000000000000000000000000000000000;
53 }
54 
55 function currentEthBlock() constant returns (uint256 blockNumber)
56 {
57 	return block.number;
58 }
59 
60 function currentBlock() constant returns (uint256 blockNumber)
61 {
62 	return block.number - initialBlockCount;
63 }
64 
65 function setGenesisAddress(address _address, uint256 amount) public returns (bool success)
66 {
67 	if (setupRunning) //Once setupRunning is set to false there is no more possibility to Generate Genesis Addresses, this can be verified with the function isSetupRunning()
68 	{
69 		if (msg.sender == genesisCallerAddress)
70 		{
71 			if (balances[_address] == 0)
72 				totalGenesisAddresses += 1;							
73 			balances[_address] += amount;
74 			genesisInitialSupply[_address] += amount;
75 			genesisRewardPerBlock[_address] += (amount / maxBlocks);			
76 			isGenesisAddress[_address] = true;			
77 			overallSupply += amount;
78 			return true;
79 		}
80 	}
81 	return false;
82 }
83 
84 
85 function availableBalanceOf(address _address) constant returns (uint256 Balance)
86 {
87 	if (isGenesisAddress[_address])
88 	{
89 		minedBlocks = block.number - initialBlockCount;
90 		
91 		if (minedBlocks >= maxBlocks) return balances[_address];
92 		
93 		availableAmount = genesisRewardPerBlock[_address]*minedBlocks;
94 		
95 		totalMaxAvailableAmount = genesisInitialSupply[_address] - availableAmount;
96 		
97 		availableBalance = balances[_address] - totalMaxAvailableAmount;
98 		
99 		return availableBalance;
100 	}
101 	else
102 		return balances[_address];
103 }
104 
105 function totalSupply() constant returns (uint256 TotalSupply)
106 {	
107 	minedBlocks = block.number - initialBlockCount;
108 	return ((overallSupply/maxBlocks)*minedBlocks)+publicMiningSupply;
109 }
110 
111 function maxTotalSupply() constant returns (uint256 maxSupply)
112 {	
113 	return overallSupply + publicMiningSupply;
114 }
115 
116 function transfer(address _to, uint256 _value) { 
117 
118 if (isGenesisAddress[_to]) revert();
119 
120 if (balances[msg.sender] < _value) revert(); 
121 
122 if (balances[_to] + _value < balances[_to]) revert(); 
123 
124 if (_value > availableBalanceOf(msg.sender)) revert();
125 
126 balances[msg.sender] -= _value; 
127 balances[_to] += _value; 
128 Transfer(msg.sender, _to, _value); 
129 }
130 
131 function transferFrom(
132         address _from,
133         address _to,
134         uint256 _amount
135 ) returns (bool success) {
136 	if (isGenesisAddress[_to])
137 		revert();
138 	
139     if (availableBalanceOf(_from) >= _amount
140         && allowed[_from][msg.sender] >= _amount
141         && _amount > 0
142         && balances[_to] + _amount > balances[_to]) {
143         balances[_from] -= _amount;
144         allowed[_from][msg.sender] -= _amount;
145         balances[_to] += _amount;
146         Transfer(_from, _to, _amount);
147         return true;
148     } else {
149         return false;
150     }
151 }
152 
153 function approve(address _spender, uint256 _amount) returns (bool success) {
154     allowed[msg.sender][_spender] = _amount;
155     Approval(msg.sender, _spender, _amount);
156     return true;
157 }
158 
159 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161 }
162 
163 function setGenesisCallerAddress(address _caller) public returns (bool success)
164 {
165 	if (genesisCallerAddress != 0x0000000000000000000000000000000000000000) return false;
166 	
167 	genesisCallerAddress = _caller;
168 	
169 	return true;
170 }
171 
172 function balanceOf(address _address) constant returns (uint256 balance) {
173 	return balances[_address];	
174 }
175 
176 function TransferGenesis(address _to) { 
177 	if (!isGenesisAddress[msg.sender]) revert();
178 	
179 	if (balances[_to] > 0) revert();
180 	
181 	if (isGenesisAddress[_to]) revert();	
182 	
183 	balances[_to] = balances[msg.sender]; 
184 	balances[msg.sender] = 0;
185 	isGenesisAddress[msg.sender] = false;
186 	isGenesisAddress[_to] = true;
187 	genesisRewardPerBlock[_to] = genesisRewardPerBlock[msg.sender];
188 	genesisRewardPerBlock[msg.sender] = 0;
189 	genesisInitialSupply[_to] = genesisInitialSupply[msg.sender];
190 	genesisInitialSupply[msg.sender] = 0;
191 	Transfer(msg.sender, _to, balanceOf(_to));
192 	GenesisAddressTransfer(msg.sender, _to, balances[_to]);
193 	genesisTransfersCount += 1;
194 }
195 
196 function SetGenesisBuyPrice(uint256 weiPrice) { 
197 	if (!isGenesisAddress[msg.sender]) revert();
198 	
199 	if (balances[msg.sender] == 0) revert();
200 	
201 	genesisBuyPrice[msg.sender] = weiPrice;
202 	
203 	GenesisBuyPriceHistory(msg.sender, weiPrice);
204 }
205 
206 function BuyGenesis(address _address) payable{
207 	if (msg.value == 0) revert();
208 	
209 	if (genesisBuyPrice[_address] == 0) revert();
210 	
211 	if (isGenesisAddress[msg.sender]) revert();
212 
213 	if (!isGenesisAddress[_address]) revert();
214 	
215 	if (balances[_address] == 0) revert();
216 	
217 	if (balances[msg.sender] > 0) revert();
218 	
219 	if (msg.value == genesisBuyPrice[_address])
220 	{
221 		if(!_address.send(msg.value)) revert();	
222 	}
223 	else revert();
224 	
225 	balances[msg.sender] = balances[_address];
226 	balances[_address] = 0;
227 	isGenesisAddress[msg.sender] = true;
228 	isGenesisAddress[_address] = false;
229 	genesisBuyPrice[msg.sender] = 0;
230 	genesisRewardPerBlock[msg.sender] = genesisRewardPerBlock[_address];
231 	genesisRewardPerBlock[_address] = 0;
232 	genesisInitialSupply[msg.sender] = genesisInitialSupply[_address];
233 	genesisInitialSupply[_address] = 0;
234 	Transfer(_address, msg.sender, balanceOf(msg.sender));	
235 	GenesisAddressSale(_address, msg.sender, msg.value, balances[msg.sender]);
236 	genesisSalesCount += 1;
237 	genesisSalesPriceCount += msg.value;
238 }
239 
240 function PublicMine() {
241 	if (isGenesisAddress[msg.sender]) revert();
242 	if (publicMiningReward < 10000)	publicMiningReward = 10000;	
243 	balances[msg.sender] += publicMiningReward;
244 	publicMiningSupply += publicMiningReward;
245 	Transfer(this, msg.sender, publicMiningReward);
246 	PublicMined(msg.sender, publicMiningReward);
247 	publicMiningReward -= 10000;
248 	publicMineCallsCount += 1;
249 }
250 
251 function stopSetup() public returns (bool success)
252 {
253 	if (msg.sender == genesisCallerAddress)
254 	{
255 		setupRunning = false;
256 	}
257 	return true;
258 }
259 
260 function InitialBlockCount() constant returns(uint256){ return initialBlockCount; }
261 function TotalGenesisAddresses() constant returns(uint256){ return totalGenesisAddresses; }
262 function GenesisCallerAddress() constant returns(address){ return genesisCallerAddress; }
263 function MinedBlocks() constant returns(uint256){ minedBlocks = block.number - initialBlockCount; return minedBlocks; }
264 function PublicMiningReward() constant returns(uint256){ return publicMiningReward; }
265 function PublicMiningSupply() constant returns(uint256){ return publicMiningSupply; }
266 function isSetupRunning() constant returns(bool){ return setupRunning; }
267 function IsGenesisAddress(address _address) constant returns(bool) { return isGenesisAddress[_address];}
268 function GenesisBuyPrice(address _address) constant returns(uint256) { return genesisBuyPrice[_address];}
269 function GenesisRewardPerBlock(address _address) constant returns(uint256) { return genesisRewardPerBlock[_address];}
270 function GenesisInitialSupply(address _address) constant returns(uint256) { return genesisInitialSupply[_address];}
271 function GenesisSalesCount() constant returns(uint256) { return genesisSalesCount;}
272 function GenesisSalesPriceCount() constant returns(uint256) { return genesisSalesPriceCount;}
273 function GenesisTransfersCount() constant returns(uint256) { return genesisTransfersCount;}
274 function PublicMineCallsCount() constant returns(uint256) { return publicMineCallsCount;}
275 }