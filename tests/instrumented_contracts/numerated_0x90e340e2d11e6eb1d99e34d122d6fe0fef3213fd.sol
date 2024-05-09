1 pragma solidity ^0.6.0;
2 contract publicCalls { 
3 
4 address public ownerMain = 0x0000000000000000000000000000000000000000;
5 address public ownerGenesis = 0x0000000000000000000000000000000000000000;
6 address public ownerStakes = 0x0000000000000000000000000000000000000000;
7 address public ownerNormalAddress = 0x0000000000000000000000000000000000000000;
8 address public ownerGenesisBuys = 0x0000000000000000000000000000000000000000;
9 address public ownerStakeBuys = 0x0000000000000000000000000000000000000000;
10 address public ownerTokenService = 0x0000000000000000000000000000000000000000;
11 address public ownerBaseTransfers = 0x0000000000000000000000000000000000000000;
12 address public external1 = 0x0000000000000000000000000000000000000000;
13 uint256 public genesisSupplyPerAddress = 32000 * 100000000;
14 uint256 public constant maxBlocks = 100000000;
15 uint256 public genesisRewardPerBlock = genesisSupplyPerAddress / maxBlocks;
16 uint256 public initialBlockCount;
17 address public genesisCallerAddress;
18 uint256 public overallSupply;
19 uint256 public genesisSalesCount;
20 uint256 public genesisSalesPriceCount;
21 uint256 public genesisTransfersCount;
22 bool public setupRunning = true;
23 uint256 public genesisAddressCount;
24 uint256 public ethFeeToUpgradeToLevel2 = 50000000000000;
25 uint256 public ethFeeToUpgradeToLevel3 = 100000000000000;
26 uint256 public ethFeeToBuyLevel1 = 150000000000000;
27 uint256 public ethFeeForSellerLevel1 = 50000000000000;
28 uint256 public ethFeeForToken = 0;
29 uint256 public ethFeeForTokenICO = 0;
30 uint256 public ethPercentFeeGenesisExchange = 10;
31 uint256 public ethPercentFeeNormalExchange = 10;
32 uint256 public ethPercentStakeExchange = 10;
33 uint256 public level2ActivationsFromLevel1Count = 0;
34 uint256 public level3ActivationsFromLevel1Count = 0;
35 uint256 public level3ActivationsFromLevel2Count = 0;
36 uint256 public level3ActivationsFromDevCount = 0;
37 uint256 public amountOfGenesisToBuyStakes = 5;
38 uint256 public amountOfMNEToBuyStakes = 1000 * 100000000;
39 uint256 public amountOfMNEForToken = 2000 * 100000000;
40 uint256 public amountOfMNEForTokenICO = 5000 * 100000000;
41 uint256 public amountOfMNEToTransferStakes = 500 * 100000000;
42 uint256 public amountOfGenesisToTransferStakes = 3;
43 
44 uint256 public tokenWithoutICOCount = 0;
45 uint256 public tokenICOCount = 0;
46 uint256 public buyStakeMNECount = 0;
47 uint256 public stakeMneBurnCount = 0;
48 uint256 public stakeHoldersImported = 0;
49 uint256 public NormalBalanceImported = 0;
50 uint256 public NormalImportedAmountCount = 0;
51 uint256 public NormalAddressSalesCount = 0;
52 uint256 public NormalAddressSalesPriceCount = 0;
53 uint256 public NormalAddressSalesMNECount = 0;
54 uint256 public NormalAddressFeeCount = 0;
55 uint256 public GenesisDestroyCountStake = 0;
56 uint256 public GenesisDestroyed = 0;
57 uint256 public GenesisDestroyAmountCount = 0;
58 uint256 public transferStakeGenesisCount = 0;
59 uint256 public buyStakeGenesisCount = 0;
60 uint256 public stakeMneTransferBurnCount = 0;
61 uint256 public transferStakeMNECount = 0;
62 uint256 public mneBurned = 0;
63 uint256 public totalPaidStakeHolders = 0;
64 uint256 public stakeDecimals = 1000000000000000;
65 
66 mapping (address => uint256) public balances; 
67 mapping (address => uint256) public stakeBalances; 
68 mapping (address => uint8) public isGenesisAddress; 
69 mapping (address => uint256) public genesisBuyPrice;
70 mapping (address => uint) public genesisAddressesForSaleLevel1Index;
71 mapping (address => uint) public genesisAddressesForSaleLevel2Index;
72 mapping (address => uint) public genesisAddressesForSaleLevel3Index;
73 mapping (address => uint) public normalAddressesForSaleIndex;
74 mapping (address => uint) public stakesForSaleIndex;
75 mapping (address => address[]) public tokenCreated;
76 mapping (address => address[]) public tokenICOCreated;
77 mapping (address => uint) public stakeHoldersListIndex;
78 mapping (address => uint256) public stakeBuyPrice;
79 mapping (address => mapping (address => uint256)) public allowed;
80 mapping (address => uint256) public initialBlockCountPerAddress;
81 mapping (address => uint256) public genesisInitialSupply;
82 mapping (address => bool) public allowReceiveGenesisTransfers;
83 mapping (address => bool) public isGenesisAddressForSale;
84 mapping (address => address) public allowAddressToDestroyGenesis;
85 mapping (address => bool) public isNormalAddressForSale;
86 mapping (address => uint256) public NormalAddressBuyPricePerMNE;
87 
88 function tokenCreatedGet(address _address) public view returns (address[] memory _contracts)
89 {
90 	return tokenCreated[_address];
91 }
92 
93 function tokenICOCreatedGet(address _address) public view returns (address[] memory _contracts)
94 {
95 	return tokenICOCreated[_address];
96 }
97 
98 address public updaterAddress = 0x0000000000000000000000000000000000000000;
99 function setUpdater() public {if (updaterAddress == 0x0000000000000000000000000000000000000000) updaterAddress = msg.sender; else revert();}
100 function updaterSetOwnerMain(address _address) public {if (tx.origin == updaterAddress) ownerMain = _address; else revert();}
101 function updaterSetOwnerGenesis(address _address) public {if (tx.origin == updaterAddress) ownerGenesis = _address; else revert();}
102 function updaterSetOwnerStakes(address _address) public {if (tx.origin == updaterAddress) ownerStakes = _address; else revert();}
103 function updaterSetOwnerNormalAddress(address _address) public {if (tx.origin == updaterAddress) ownerNormalAddress = _address; else revert();}
104 function updaterSetOwnerGenesisBuys(address _address) public {if (tx.origin == updaterAddress) ownerGenesisBuys = _address; else revert();}
105 function updaterSetOwnerStakeBuys(address _address) public {if (tx.origin == updaterAddress) ownerStakeBuys = _address; else revert();}
106 function updaterSetOwnerTokenService(address _address) public {if (tx.origin == updaterAddress) ownerTokenService = _address; else revert();}
107 function updaterSetOwnerBaseTransfers(address _address) public {if (tx.origin == updaterAddress) ownerBaseTransfers = _address; else revert();}
108 
109 function setOwnerBaseTransfers() public {
110 	if (tx.origin == updaterAddress)
111 		ownerBaseTransfers = msg.sender;
112 	else
113 		revert();
114 }
115 
116 function setOwnerMain() public {
117 	if (tx.origin == updaterAddress)
118 		ownerMain = msg.sender;
119 	else
120 		revert();
121 }
122 
123 function setOwnerGenesis() public {
124 	if (tx.origin == updaterAddress)
125 		ownerGenesis = msg.sender;
126 	else
127 		revert();
128 }
129 
130 function setOwnerStakes() public {
131 	if (tx.origin == updaterAddress)
132 		ownerStakes = msg.sender;
133 	else
134 		revert();
135 }
136 
137 function setOwnerNormalAddress() public {
138 	if (tx.origin == updaterAddress)
139 		ownerNormalAddress = msg.sender;
140 	else
141 		revert();
142 }
143 
144 function setOwnerGenesisBuys() public {
145 	if (tx.origin == updaterAddress)
146 		ownerGenesisBuys = msg.sender;
147 	else
148 		revert();
149 }
150 
151 function setOwnerStakeBuys() public {
152 	if (tx.origin == updaterAddress)
153 		ownerStakeBuys = msg.sender;
154 	else
155 		revert();
156 }
157 
158 function setOwnerTokenService() public {
159 	if (tx.origin == updaterAddress)
160 		ownerTokenService = msg.sender;
161 	else
162 		revert();
163 }
164 
165 function setOwnerExternal1() public {
166 	if (tx.origin == updaterAddress)
167 		external1 = msg.sender;	
168 	else
169 		revert();
170 }
171 
172 modifier onlyOwner(){
173     require(msg.sender == ownerMain || msg.sender == ownerGenesis || msg.sender == ownerStakes || msg.sender == ownerNormalAddress || msg.sender == ownerGenesisBuys || msg.sender == ownerStakeBuys || msg.sender == ownerTokenService || msg.sender == ownerBaseTransfers || msg.sender == external1);
174      _;
175 }
176 
177 constructor() public
178 {
179 	setUpdater();
180 }
181 
182 function setGenesisAddressArrayDirect(address[] memory _addressList) public {
183 	if (setupRunning && msg.sender == genesisCallerAddress)
184 	{
185 		uint i = 0;
186 		while (i < _addressList.length)
187 		{
188 			isGenesisAddress[_addressList[i]] = 1;
189 			genesisAddressCount++;			
190 			i++;
191 		}
192 	}
193 	else
194 	{
195 		revert();
196 	}
197 }
198 
199 function setGenesisAddressDevArrayDirect(address[] memory _addressList) public {
200 	if (setupRunning && msg.sender == genesisCallerAddress)
201 	{
202 		uint i = 0;
203 		while (i < _addressList.length)
204 		{
205 			isGenesisAddress[_addressList[i]] = 4;
206 			genesisAddressCount++;
207 			i++;
208 		}
209 	}
210 	else
211 	{
212 		revert();
213 	}
214 }
215 
216 function setBalanceNormalAddressDirect(address _address, uint256 balance) public {
217 	if (setupRunning && msg.sender == genesisCallerAddress)
218 	{
219 		if (isGenesisAddress[_address] > 0)
220 		{
221 			isGenesisAddress[_address] = 0;
222 			genesisAddressCount--;
223 		}
224 		
225 		balances[_address] = balance;
226 		NormalBalanceImported++;
227 		NormalImportedAmountCount += balance;
228 	}
229 	else
230 	{
231 		revert();
232 	}
233 }
234 
235 function setGenesisCallerAddressDirect() public returns (bool success)
236 {
237 	if (genesisCallerAddress != 0x0000000000000000000000000000000000000000) return false;
238 	
239 	genesisCallerAddress = msg.sender;
240 	
241 	return true;
242 }
243 
244 function initialBlockCountSet(uint256 _initialBlockCount) public onlyOwner {initialBlockCount = _initialBlockCount;}
245 function genesisCallerAddressSet(address _genesisCallerAddress) public onlyOwner {genesisCallerAddress = _genesisCallerAddress;}
246 function overallSupplySet(uint256 _overallSupply) public onlyOwner {overallSupply = _overallSupply;}
247 function genesisSalesCountSet(uint256 _genesisSalesCount) public onlyOwner {genesisSalesCount = _genesisSalesCount;}
248 function genesisSalesPriceCountSet(uint256 _genesisSalesPriceCount) public onlyOwner {genesisSalesPriceCount = _genesisSalesPriceCount;}
249 function genesisTransfersCountSet(uint256 _genesisTransfersCount) public onlyOwner {genesisTransfersCount = _genesisTransfersCount;}
250 function setupRunningSet(bool _setupRunning) public onlyOwner {setupRunning = _setupRunning;}
251 function genesisAddressCountSet(uint256 _genesisAddressCount) public onlyOwner {genesisAddressCount = _genesisAddressCount;}
252 
253 function ethFeeToUpgradeToLevel2Set(address _from, uint256 _ethFeeToUpgradeToLevel2) public onlyOwner {if (_from == genesisCallerAddress) ethFeeToUpgradeToLevel2 = _ethFeeToUpgradeToLevel2; else revert();}
254 function ethFeeToUpgradeToLevel3Set(address _from, uint256 _ethFeeToUpgradeToLevel3) public onlyOwner {if (_from == genesisCallerAddress)ethFeeToUpgradeToLevel3 = _ethFeeToUpgradeToLevel3; else revert();}
255 function ethFeeToBuyLevel1Set(address _from, uint256 _ethFeeToBuyLevel1) public onlyOwner {if (_from == genesisCallerAddress) ethFeeToBuyLevel1 = _ethFeeToBuyLevel1; else revert();}
256 function ethFeeForSellerLevel1Set(address _from, uint256 _ethFeeForSellerLevel1) public onlyOwner {if (_from == genesisCallerAddress) ethFeeForSellerLevel1 = _ethFeeForSellerLevel1; else revert();}
257 function ethFeeForTokenSet(address _from, uint256 _ethFeeForToken) public onlyOwner {if (_from == genesisCallerAddress) ethFeeForToken = _ethFeeForToken; else revert();}
258 function ethFeeForTokenICOSet(address _from, uint256 _ethFeeForTokenICO) public onlyOwner {if (_from == genesisCallerAddress) ethFeeForTokenICO = _ethFeeForTokenICO; else revert();}
259 function ethPercentFeeGenesisExchangeSet(address _from, uint256 _ethPercentFeeGenesisExchange) public onlyOwner {if (_from == genesisCallerAddress) ethPercentFeeGenesisExchange = _ethPercentFeeGenesisExchange; else revert();}
260 function ethPercentFeeNormalExchangeSet(address _from, uint256 _ethPercentFeeNormalExchange) public onlyOwner {if (_from == genesisCallerAddress) ethPercentFeeNormalExchange = _ethPercentFeeNormalExchange; else revert();}
261 function ethPercentStakeExchangeSet(address _from, uint256 _ethPercentStakeExchange) public onlyOwner {if (_from == genesisCallerAddress) ethPercentStakeExchange = _ethPercentStakeExchange; else revert();}
262 function amountOfGenesisToBuyStakesSet(address _from, uint256 _amountOfGenesisToBuyStakes) public onlyOwner {if (_from == genesisCallerAddress) amountOfGenesisToBuyStakes = _amountOfGenesisToBuyStakes; else revert();}
263 function amountOfMNEToBuyStakesSet(address _from, uint256 _amountOfMNEToBuyStakes) public onlyOwner {if (_from == genesisCallerAddress) amountOfMNEToBuyStakes = _amountOfMNEToBuyStakes; else revert();}
264 function amountOfMNEForTokenSet(address _from, uint256 _amountOfMNEForToken) public onlyOwner {if (_from == genesisCallerAddress) amountOfMNEForToken = _amountOfMNEForToken; else revert();}
265 function amountOfMNEForTokenICOSet(address _from, uint256 _amountOfMNEForTokenICO) public onlyOwner {if (_from == genesisCallerAddress) amountOfMNEForTokenICO = _amountOfMNEForTokenICO; else revert();}
266 function amountOfMNEToTransferStakesSet(address _from, uint256 _amountOfMNEToTransferStakes) public onlyOwner {if (_from == genesisCallerAddress) amountOfMNEToTransferStakes = _amountOfMNEToTransferStakes; else revert();}
267 function amountOfGenesisToTransferStakesSet(address _from, uint256 _amountOfGenesisToTransferStakes) public onlyOwner {if (_from == genesisCallerAddress) amountOfGenesisToTransferStakes = _amountOfGenesisToTransferStakes; else revert();}
268 function stakeDecimalsSet(address _from, uint256 _stakeDecimals) public onlyOwner {if (_from == genesisCallerAddress) {stakeDecimals = _stakeDecimals;} else revert();}
269 
270 function level2ActivationsFromLevel1CountSet(uint256 _level2ActivationsFromLevel1Count) public onlyOwner {level2ActivationsFromLevel1Count = _level2ActivationsFromLevel1Count;}
271 function level3ActivationsFromLevel1CountSet(uint256 _level3ActivationsFromLevel1Count) public onlyOwner {level3ActivationsFromLevel1Count = _level3ActivationsFromLevel1Count;}
272 function level3ActivationsFromLevel2CountSet(uint256 _level3ActivationsFromLevel2Count) public onlyOwner {level3ActivationsFromLevel2Count = _level3ActivationsFromLevel2Count;}
273 function level3ActivationsFromDevCountSet(uint256 _level3ActivationsFromDevCount) public onlyOwner {level3ActivationsFromDevCount = _level3ActivationsFromDevCount;}
274 function buyStakeMNECountSet(uint256 _buyStakeMNECount) public onlyOwner {buyStakeMNECount = _buyStakeMNECount;}
275 function tokenWithoutICOCountSet(uint256 _tokenWithoutICOCount) public onlyOwner {tokenWithoutICOCount = _tokenWithoutICOCount;}
276 function tokenICOCountSet(uint256 _tokenICOCount) public onlyOwner {tokenICOCount = _tokenICOCount;}
277 function stakeMneBurnCountSet(uint256 _stakeMneBurnCount) public onlyOwner {stakeMneBurnCount = _stakeMneBurnCount;}
278 function stakeHoldersImportedSet(uint256 _stakeHoldersImported) public onlyOwner {stakeHoldersImported = _stakeHoldersImported;}
279 function NormalBalanceImportedSet(uint256 _NormalBalanceImported) public onlyOwner {NormalBalanceImported = _NormalBalanceImported;}
280 function NormalImportedAmountCountSet(uint256 _NormalImportedAmountCount) public onlyOwner {NormalImportedAmountCount = _NormalImportedAmountCount;}
281 function NormalAddressSalesCountSet(uint256 _NormalAddressSalesCount) public onlyOwner {NormalAddressSalesCount = _NormalAddressSalesCount;}
282 function NormalAddressSalesPriceCountSet(uint256 _NormalAddressSalesPriceCount) public onlyOwner {NormalAddressSalesPriceCount = _NormalAddressSalesPriceCount;}
283 function NormalAddressSalesMNECountSet(uint256 _NormalAddressSalesMNECount) public onlyOwner {NormalAddressSalesMNECount = _NormalAddressSalesMNECount;}
284 function NormalAddressFeeCountSet(uint256 _NormalAddressFeeCount) public onlyOwner {NormalAddressFeeCount = _NormalAddressFeeCount;}
285 function GenesisDestroyCountStakeSet(uint256 _GenesisDestroyCountStake) public onlyOwner {GenesisDestroyCountStake = _GenesisDestroyCountStake;}
286 function GenesisDestroyedSet(uint256 _GenesisDestroyed) public onlyOwner {GenesisDestroyed = _GenesisDestroyed;}
287 function GenesisDestroyAmountCountSet(uint256 _GenesisDestroyAmountCount) public onlyOwner {GenesisDestroyAmountCount = _GenesisDestroyAmountCount;}
288 function transferStakeGenesisCountSet(uint256 _transferStakeGenesisCount) public onlyOwner {transferStakeGenesisCount = _transferStakeGenesisCount;}
289 function buyStakeGenesisCountSet(uint256 _buyStakeGenesisCount) public onlyOwner {buyStakeGenesisCount = _buyStakeGenesisCount;}
290 function stakeMneTransferBurnCountSet(uint256 _stakeMneTransferBurnCount) public onlyOwner {stakeMneTransferBurnCount = _stakeMneTransferBurnCount;}
291 function transferStakeMNECountSet(uint256 _transferStakeMNECount) public onlyOwner {transferStakeMNECount = _transferStakeMNECount;}
292 function mneBurnedSet(uint256 _mneBurned) public onlyOwner {mneBurned = _mneBurned;}
293 function totalPaidStakeHoldersSet(uint256 _totalPaidStakeHolders) public onlyOwner {totalPaidStakeHolders = _totalPaidStakeHolders;}
294 function balancesSet(address _address,uint256 _balances) public onlyOwner {balances[_address] = _balances;}
295 function stakeBalancesSet(address _address,uint256 _stakeBalances) public onlyOwner {stakeBalances[_address] = _stakeBalances;}
296 function isGenesisAddressSet(address _address,uint8 _isGenesisAddress) public onlyOwner {isGenesisAddress[_address] = _isGenesisAddress;}
297 function genesisBuyPriceSet(address _address,uint256 _genesisBuyPrice) public onlyOwner {genesisBuyPrice[_address] = _genesisBuyPrice;}
298 function genesisAddressesForSaleLevel1IndexSet(address _address,uint _genesisAddressesForSaleLevel1Index) public onlyOwner {genesisAddressesForSaleLevel1Index[_address] = _genesisAddressesForSaleLevel1Index;}
299 function genesisAddressesForSaleLevel2IndexSet(address _address,uint _genesisAddressesForSaleLevel2Index) public onlyOwner {genesisAddressesForSaleLevel2Index[_address] = _genesisAddressesForSaleLevel2Index;}
300 function genesisAddressesForSaleLevel3IndexSet(address _address,uint _genesisAddressesForSaleLevel3Index) public onlyOwner {genesisAddressesForSaleLevel3Index[_address] = _genesisAddressesForSaleLevel3Index;}
301 function normalAddressesForSaleIndexSet(address _address,uint _normalAddressesForSaleIndex) public onlyOwner {normalAddressesForSaleIndex[_address] = _normalAddressesForSaleIndex;}
302 function stakesForSaleIndexSet(address _address,uint _stakesForSaleIndex) public onlyOwner {stakesForSaleIndex[_address] = _stakesForSaleIndex;}
303 function tokenCreatedSet(address _address,address _tokenCreated) public onlyOwner {tokenCreated	[_address].push( _tokenCreated);}			
304 function tokenICOCreatedSet(address _address,address _tokenICOCreated) public onlyOwner {tokenICOCreated	[_address].push( _tokenICOCreated);}			
305 function stakeHoldersListIndexSet(address _address,uint _stakeHoldersListIndex) public onlyOwner {stakeHoldersListIndex[_address] = _stakeHoldersListIndex;}
306 function stakeBuyPriceSet(address _address,uint256 _stakeBuyPrice) public onlyOwner {stakeBuyPrice[_address] = _stakeBuyPrice;}
307 function initialBlockCountPerAddressSet(address _address,uint256 _initialBlockCountPerAddress) public onlyOwner {initialBlockCountPerAddress[_address] = _initialBlockCountPerAddress;}
308 function genesisInitialSupplySet(address _address,uint256 _genesisInitialSupply) public onlyOwner {genesisInitialSupply[_address] = _genesisInitialSupply;}
309 function allowReceiveGenesisTransfersSet(address _address,bool _allowReceiveGenesisTransfers) public onlyOwner {allowReceiveGenesisTransfers[_address] = _allowReceiveGenesisTransfers;}
310 function isGenesisAddressForSaleSet(address _address,bool _isGenesisAddressForSale) public onlyOwner {isGenesisAddressForSale[_address] = _isGenesisAddressForSale;}
311 function allowAddressToDestroyGenesisSet(address _address,address _allowAddressToDestroyGenesis) public onlyOwner {allowAddressToDestroyGenesis[_address] = _allowAddressToDestroyGenesis;}
312 function isNormalAddressForSaleSet(address _address,bool _isNormalAddressForSale) public onlyOwner {isNormalAddressForSale[_address] = _isNormalAddressForSale;}
313 function NormalAddressBuyPricePerMNESet(address _address,uint256 _NormalAddressBuyPricePerMNE) public onlyOwner {NormalAddressBuyPricePerMNE[_address] = _NormalAddressBuyPricePerMNE;}
314 function allowedSet(address _address,address _spender, uint256 _amount) public onlyOwner { allowed[_address][_spender] = _amount; }
315 }