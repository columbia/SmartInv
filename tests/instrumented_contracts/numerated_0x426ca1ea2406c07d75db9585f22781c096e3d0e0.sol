1 pragma solidity ^0.6.0;
2 
3 interface publicCalls {
4   function GenesisDestroyAmountCount (  ) external view returns ( uint256 );
5   function GenesisDestroyAmountCountSet ( uint256 _GenesisDestroyAmountCount ) external;
6   function GenesisDestroyCountStake (  ) external view returns ( uint256 );
7   function GenesisDestroyCountStakeSet ( uint256 _GenesisDestroyCountStake ) external;
8   function GenesisDestroyed (  ) external view returns ( uint256 );
9   function GenesisDestroyedSet ( uint256 _GenesisDestroyed ) external;
10   function NormalAddressBuyPricePerMNE ( address ) external view returns ( uint256 );
11   function NormalAddressBuyPricePerMNESet ( address _address, uint256 _NormalAddressBuyPricePerMNE ) external;
12   function NormalAddressFeeCount (  ) external view returns ( uint256 );
13   function NormalAddressFeeCountSet ( uint256 _NormalAddressFeeCount ) external;
14   function NormalAddressSalesCount (  ) external view returns ( uint256 );
15   function NormalAddressSalesCountSet ( uint256 _NormalAddressSalesCount ) external;
16   function NormalAddressSalesPriceCount (  ) external view returns ( uint256 );
17   function NormalAddressSalesPriceCountSet ( uint256 _NormalAddressSalesPriceCount ) external;
18   function NormalBalanceImported (  ) external view returns ( uint256 );
19   function NormalBalanceImportedSet ( uint256 _NormalBalanceImported ) external;
20   function NormalImportedAmountCount (  ) external view returns ( uint256 );
21   function NormalImportedAmountCountSet ( uint256 _NormalImportedAmountCount ) external;
22   function allowAddressToDestroyGenesis ( address ) external view returns ( address );
23   function allowAddressToDestroyGenesisSet ( address _address, address _allowAddressToDestroyGenesis ) external;
24   function allowReceiveGenesisTransfers ( address ) external view returns ( bool );
25   function allowReceiveGenesisTransfersSet ( address _address, bool _allowReceiveGenesisTransfers ) external;
26   function allowed ( address, address ) external view returns ( uint256 );
27   function allowedSet ( address _address, address _spender, uint256 _amount ) external;
28   function amountOfGenesisToBuyStakes (  ) external view returns ( uint256 );
29   function amountOfGenesisToBuyStakesSet ( address _from, uint256 _amountOfGenesisToBuyStakes ) external;
30   function amountOfGenesisToTransferStakes (  ) external view returns ( uint256 );
31   function amountOfGenesisToTransferStakesSet ( address _from, uint256 _amountOfGenesisToTransferStakes ) external;
32   function amountOfMNEForToken (  ) external view returns ( uint256 );
33   function amountOfMNEForTokenICO (  ) external view returns ( uint256 );
34   function amountOfMNEForTokenICOSet ( address _from, uint256 _amountOfMNEForTokenICO ) external;
35   function amountOfMNEForTokenSet ( address _from, uint256 _amountOfMNEForToken ) external;
36   function amountOfMNEToBuyStakes (  ) external view returns ( uint256 );
37   function amountOfMNEToBuyStakesSet ( address _from, uint256 _amountOfMNEToBuyStakes ) external;
38   function amountOfMNEToTransferStakes (  ) external view returns ( uint256 );
39   function amountOfMNEToTransferStakesSet ( address _from, uint256 _amountOfMNEToTransferStakes ) external;
40   function availableBalance (  ) external view returns ( uint256 );
41   function availableBalanceSet ( uint256 _availableBalance ) external;
42   function balances ( address ) external view returns ( uint256 );
43   function balancesSet ( address _address, uint256 _balances ) external;
44   function buyStakeGenesisCount (  ) external view returns ( uint256 );
45   function buyStakeGenesisCountSet ( uint256 _buyStakeGenesisCount ) external;
46   function buyStakeMNECount (  ) external view returns ( uint256 );
47   function buyStakeMNECountSet ( uint256 _buyStakeMNECount ) external;
48   function ethFeeForSellerLevel1 (  ) external view returns ( uint256 );
49   function ethFeeForSellerLevel1Set ( address _from, uint256 _ethFeeForSellerLevel1 ) external;
50   function ethFeeForToken (  ) external view returns ( uint256 );
51   function ethFeeForTokenICO (  ) external view returns ( uint256 );
52   function ethFeeForTokenICOSet ( address _from, uint256 _ethFeeForTokenICO ) external;
53   function ethFeeForTokenSet ( address _from, uint256 _ethFeeForToken ) external;
54   function ethFeeToBuyLevel1 (  ) external view returns ( uint256 );
55   function ethFeeToBuyLevel1Set ( address _from, uint256 _ethFeeToBuyLevel1 ) external;
56   function ethFeeToUpgradeToLevel2 (  ) external view returns ( uint256 );
57   function ethFeeToUpgradeToLevel2Set ( address _from, uint256 _ethFeeToUpgradeToLevel2 ) external;
58   function ethFeeToUpgradeToLevel3 (  ) external view returns ( uint256 );
59   function ethFeeToUpgradeToLevel3Set ( address _from, uint256 _ethFeeToUpgradeToLevel3 ) external;
60   function ethPercentFeeGenesisExchange (  ) external view returns ( uint256 );
61   function ethPercentFeeGenesisExchangeSet ( address _from, uint256 _ethPercentFeeGenesisExchange ) external;
62   function ethPercentFeeNormalExchange (  ) external view returns ( uint256 );
63   function ethPercentFeeNormalExchangeSet ( address _from, uint256 _ethPercentFeeNormalExchange ) external;
64   function ethPercentStakeExchange (  ) external view returns ( uint256 );
65   function ethPercentStakeExchangeSet ( address _from, uint256 _ethPercentStakeExchange ) external;
66   function genesisAddressCount (  ) external view returns ( uint256 );
67   function genesisAddressCountSet ( uint256 _genesisAddressCount ) external;
68   function genesisAddressesForSaleLevel1Index ( address ) external view returns ( uint256 );
69   function genesisAddressesForSaleLevel1IndexSet ( address _address, uint256 _genesisAddressesForSaleLevel1Index ) external;
70   function genesisAddressesForSaleLevel2Index ( address ) external view returns ( uint256 );
71   function genesisAddressesForSaleLevel2IndexSet ( address _address, uint256 _genesisAddressesForSaleLevel2Index ) external;
72   function genesisAddressesForSaleLevel3Index ( address ) external view returns ( uint256 );
73   function genesisAddressesForSaleLevel3IndexSet ( address _address, uint256 _genesisAddressesForSaleLevel3Index ) external;
74   function genesisBuyPrice ( address ) external view returns ( uint256 );
75   function genesisBuyPriceSet ( address _address, uint256 _genesisBuyPrice ) external;
76   function genesisCallerAddress (  ) external view returns ( address );
77   function genesisCallerAddressSet ( address _genesisCallerAddress ) external;
78   function genesisInitialSupply ( address ) external view returns ( uint256 );
79   function genesisInitialSupplySet ( address _address, uint256 _genesisInitialSupply ) external;
80   function genesisRewardPerBlock (  ) external view returns ( uint256 );
81   function genesisSalesCount (  ) external view returns ( uint256 );
82   function genesisSalesCountSet ( uint256 _genesisSalesCount ) external;
83   function genesisSalesPriceCount (  ) external view returns ( uint256 );
84   function genesisSalesPriceCountSet ( uint256 _genesisSalesPriceCount ) external;
85   function genesisSupplyPerAddress (  ) external view returns ( uint256 );
86   function genesisTransfersCount (  ) external view returns ( uint256 );
87   function genesisTransfersCountSet ( uint256 _genesisTransfersCount ) external;
88   function initialBlockCount (  ) external view returns ( uint256 );
89   function initialBlockCountPerAddress ( address ) external view returns ( uint256 );
90   function initialBlockCountPerAddressSet ( address _address, uint256 _initialBlockCountPerAddress ) external;
91   function initialBlockCountSet ( uint256 _initialBlockCount ) external;
92   function isGenesisAddress ( address ) external view returns ( uint8 );
93   function isGenesisAddressForSale ( address ) external view returns ( bool );
94   function isGenesisAddressForSaleSet ( address _address, bool _isGenesisAddressForSale ) external;
95   function isGenesisAddressSet ( address _address, uint8 _isGenesisAddress ) external;
96   function isNormalAddressForSale ( address ) external view returns ( bool );
97   function isNormalAddressForSaleSet ( address _address, bool _isNormalAddressForSale ) external;
98   function level2ActivationsFromLevel1Count (  ) external view returns ( uint256 );
99   function level2ActivationsFromLevel1CountSet ( uint256 _level2ActivationsFromLevel1Count ) external;
100   function level3ActivationsFromDevCount (  ) external view returns ( uint256 );
101   function level3ActivationsFromDevCountSet ( uint256 _level3ActivationsFromDevCount ) external;
102   function level3ActivationsFromLevel1Count (  ) external view returns ( uint256 );
103   function level3ActivationsFromLevel1CountSet ( uint256 _level3ActivationsFromLevel1Count ) external;
104   function level3ActivationsFromLevel2Count (  ) external view returns ( uint256 );
105   function level3ActivationsFromLevel2CountSet ( uint256 _level3ActivationsFromLevel2Count ) external;
106   function maxBlocks (  ) external view returns ( uint256 );
107   function mneBurned (  ) external view returns ( uint256 );
108   function mneBurnedSet ( uint256 _mneBurned ) external;
109   function normalAddressesForSaleIndex ( address ) external view returns ( uint256 );
110   function normalAddressesForSaleIndexSet ( address _address, uint256 _normalAddressesForSaleIndex ) external;
111   function overallSupply (  ) external view returns ( uint256 );
112   function overallSupplySet ( uint256 _overallSupply ) external;
113   function ownerGenesis (  ) external view returns ( address );
114   function ownerGenesisBuys (  ) external view returns ( address );
115   function ownerMain (  ) external view returns ( address );
116   function ownerNormalAddress (  ) external view returns ( address );
117   function ownerStakeBuys (  ) external view returns ( address );
118   function ownerStakes (  ) external view returns ( address );
119   function ownerTokenService (  ) external view returns ( address );
120   function setOwnerGenesis (  ) external;
121   function setOwnerGenesisBuys (  ) external;
122   function setOwnerMain (  ) external;
123   function setOwnerNormalAddress (  ) external;
124   function setOwnerStakeBuys (  ) external;
125   function setOwnerStakes (  ) external;
126   function setOwnerTokenService (  ) external;
127   function setupRunning (  ) external view returns ( bool );
128   function setupRunningSet ( bool _setupRunning ) external;
129   function stakeBalances ( address ) external view returns ( uint256 );
130   function stakeBalancesSet ( address _address, uint256 _stakeBalances ) external;
131   function stakeBuyPrice ( address ) external view returns ( uint256 );
132   function stakeBuyPriceSet ( address _address, uint256 _stakeBuyPrice ) external;
133   function stakeDecimals (  ) external view returns ( uint256 );
134   function stakeDecimalsSet ( address _from, uint256 _stakeDecimals ) external;
135   function stakeHoldersImported (  ) external view returns ( uint256 );
136   function stakeHoldersImportedSet ( uint256 _stakeHoldersImported ) external;
137   function stakeHoldersListIndex ( address ) external view returns ( uint256 );
138   function stakeHoldersListIndexSet ( address _address, uint256 _stakeHoldersListIndex ) external;
139   function stakeMneBurnCount (  ) external view returns ( uint256 );
140   function stakeMneBurnCountSet ( uint256 _stakeMneBurnCount ) external;
141   function stakeMneTransferBurnCount (  ) external view returns ( uint256 );
142   function stakeMneTransferBurnCountSet ( uint256 _stakeMneTransferBurnCount ) external;
143   function stakesForSaleIndex ( address ) external view returns ( uint256 );
144   function stakesForSaleIndexSet ( address _address, uint256 _stakesForSaleIndex ) external;
145   function tokenCreated ( address, uint256 ) external view returns ( address );
146   function tokenCreatedSet ( address _address, address _tokenCreated ) external;
147   function tokenICOCreated ( address, uint256 ) external view returns ( address );
148   function tokenICOCreatedSet ( address _address, address _tokenICOCreated ) external;
149   function totalMaxAvailableAmount (  ) external view returns ( uint256 );
150   function totalMaxAvailableAmountSet ( uint256 _totalMaxAvailableAmount ) external;
151   function totalPaidStakeHolders (  ) external view returns ( uint256 );
152   function totalPaidStakeHoldersSet ( uint256 _totalPaidStakeHolders ) external;
153   function transferStakeGenesisCount (  ) external view returns ( uint256 );
154   function transferStakeGenesisCountSet ( uint256 _transferStakeGenesisCount ) external;
155   function transferStakeMNECount (  ) external view returns ( uint256 );
156   function transferStakeMNECountSet ( uint256 _transferStakeMNECount ) external;
157 }
158 
159 interface publicArrays {  
160   function Level1TradeHistoryAmountETH ( uint256 ) external view returns ( uint256 );
161   function Level1TradeHistoryAmountETHFee ( uint256 ) external view returns ( uint256 );
162   function Level1TradeHistoryAmountETHFeeLength (  ) external view returns ( uint256 len );
163   function Level1TradeHistoryAmountETHFeeSet ( uint256 _Level1TradeHistoryAmountETHFee ) external;
164   function Level1TradeHistoryAmountETHLength (  ) external view returns ( uint256 len );
165   function Level1TradeHistoryAmountETHSet ( uint256 _Level1TradeHistoryAmountETH ) external;
166   function Level1TradeHistoryAmountMNE ( uint256 ) external view returns ( uint256 );
167   function Level1TradeHistoryAmountMNELength (  ) external view returns ( uint256 len );
168   function Level1TradeHistoryAmountMNESet ( uint256 _Level1TradeHistoryAmountMNE ) external;
169   function Level1TradeHistoryBuyer ( uint256 ) external view returns ( address );
170   function Level1TradeHistoryBuyerLength (  ) external view returns ( uint256 len );
171   function Level1TradeHistoryBuyerSet ( address _Level1TradeHistoryBuyer ) external;
172   function Level1TradeHistoryDate ( uint256 ) external view returns ( uint256 );
173   function Level1TradeHistoryDateLength (  ) external view returns ( uint256 len );
174   function Level1TradeHistoryDateSet ( uint256 _Level1TradeHistoryDate ) external;
175   function Level1TradeHistorySeller ( uint256 ) external view returns ( address );
176   function Level1TradeHistorySellerLength (  ) external view returns ( uint256 len );
177   function Level1TradeHistorySellerSet ( address _Level1TradeHistorySeller ) external;
178   function Level2TradeHistoryAmountETH ( uint256 ) external view returns ( uint256 );
179   function Level2TradeHistoryAmountETHFee ( uint256 ) external view returns ( uint256 );
180   function Level2TradeHistoryAmountETHFeeLength (  ) external view returns ( uint256 len );
181   function Level2TradeHistoryAmountETHFeeSet ( uint256 _Level2TradeHistoryAmountETHFee ) external;
182   function Level2TradeHistoryAmountETHLength (  ) external view returns ( uint256 len );
183   function Level2TradeHistoryAmountETHSet ( uint256 _Level2TradeHistoryAmountETH ) external;
184   function Level2TradeHistoryAmountMNE ( uint256 ) external view returns ( uint256 );
185   function Level2TradeHistoryAmountMNELength (  ) external view returns ( uint256 len );
186   function Level2TradeHistoryAmountMNESet ( uint256 _Level2TradeHistoryAmountMNE ) external;
187   function Level2TradeHistoryAvailableAmountMNE ( uint256 ) external view returns ( uint256 );
188   function Level2TradeHistoryAvailableAmountMNELength (  ) external view returns ( uint256 len );
189   function Level2TradeHistoryAvailableAmountMNESet ( uint256 _Level2TradeHistoryAvailableAmountMNE ) external;
190   function Level2TradeHistoryBuyer ( uint256 ) external view returns ( address );
191   function Level2TradeHistoryBuyerLength (  ) external view returns ( uint256 len );
192   function Level2TradeHistoryBuyerSet ( address _Level2TradeHistoryBuyer ) external;
193   function Level2TradeHistoryDate ( uint256 ) external view returns ( uint256 );
194   function Level2TradeHistoryDateLength (  ) external view returns ( uint256 len );
195   function Level2TradeHistoryDateSet ( uint256 _Level2TradeHistoryDate ) external;
196   function Level2TradeHistorySeller ( uint256 ) external view returns ( address );
197   function Level2TradeHistorySellerLength (  ) external view returns ( uint256 len );
198   function Level2TradeHistorySellerSet ( address _Level2TradeHistorySeller ) external;
199   function Level3TradeHistoryAmountETH ( uint256 ) external view returns ( uint256 );
200   function Level3TradeHistoryAmountETHFee ( uint256 ) external view returns ( uint256 );
201   function Level3TradeHistoryAmountETHFeeLength (  ) external view returns ( uint256 len );
202   function Level3TradeHistoryAmountETHFeeSet ( uint256 _Level3TradeHistoryAmountETHFee ) external;
203   function Level3TradeHistoryAmountETHLength (  ) external view returns ( uint256 len );
204   function Level3TradeHistoryAmountETHSet ( uint256 _Level3TradeHistoryAmountETH ) external;
205   function Level3TradeHistoryAmountMNE ( uint256 ) external view returns ( uint256 );
206   function Level3TradeHistoryAmountMNELength (  ) external view returns ( uint256 len );
207   function Level3TradeHistoryAmountMNESet ( uint256 _Level3TradeHistoryAmountMNE ) external;
208   function Level3TradeHistoryAvailableAmountMNE ( uint256 ) external view returns ( uint256 );
209   function Level3TradeHistoryAvailableAmountMNELength (  ) external view returns ( uint256 len );
210   function Level3TradeHistoryAvailableAmountMNESet ( uint256 _Level3TradeHistoryAvailableAmountMNE ) external;
211   function Level3TradeHistoryBuyer ( uint256 ) external view returns ( address );
212   function Level3TradeHistoryBuyerLength (  ) external view returns ( uint256 len );
213   function Level3TradeHistoryBuyerSet ( address _Level3TradeHistoryBuyer ) external;
214   function Level3TradeHistoryDate ( uint256 ) external view returns ( uint256 );
215   function Level3TradeHistoryDateLength (  ) external view returns ( uint256 len );
216   function Level3TradeHistoryDateSet ( uint256 _Level3TradeHistoryDate ) external;
217   function Level3TradeHistorySeller ( uint256 ) external view returns ( address );
218   function Level3TradeHistorySellerLength (  ) external view returns ( uint256 len );
219   function Level3TradeHistorySellerSet ( address _Level3TradeHistorySeller ) external;
220   function MNETradeHistoryAmountETH ( uint256 ) external view returns ( uint256 );
221   function MNETradeHistoryAmountETHFee ( uint256 ) external view returns ( uint256 );
222   function MNETradeHistoryAmountETHFeeLength (  ) external view returns ( uint256 len );
223   function MNETradeHistoryAmountETHFeeSet ( uint256 _MNETradeHistoryAmountETHFee ) external;
224   function MNETradeHistoryAmountETHLength (  ) external view returns ( uint256 len );
225   function MNETradeHistoryAmountETHSet ( uint256 _MNETradeHistoryAmountETH ) external;
226   function MNETradeHistoryAmountMNE ( uint256 ) external view returns ( uint256 );
227   function MNETradeHistoryAmountMNELength (  ) external view returns ( uint256 len );
228   function MNETradeHistoryAmountMNESet ( uint256 _MNETradeHistoryAmountMNE ) external;
229   function MNETradeHistoryBuyer ( uint256 ) external view returns ( address );
230   function MNETradeHistoryBuyerLength (  ) external view returns ( uint256 len );
231   function MNETradeHistoryBuyerSet ( address _MNETradeHistoryBuyer ) external;
232   function MNETradeHistoryDate ( uint256 ) external view returns ( uint256 );
233   function MNETradeHistoryDateLength (  ) external view returns ( uint256 len );
234   function MNETradeHistoryDateSet ( uint256 _MNETradeHistoryDate ) external;
235   function MNETradeHistorySeller ( uint256 ) external view returns ( address );
236   function MNETradeHistorySellerLength (  ) external view returns ( uint256 len );
237   function MNETradeHistorySellerSet ( address _MNETradeHistorySeller ) external;
238   function StakeTradeHistoryBuyer ( uint256 ) external view returns ( address );
239   function StakeTradeHistoryBuyerLength (  ) external view returns ( uint256 len );
240   function StakeTradeHistoryBuyerSet ( address _StakeTradeHistoryBuyer ) external;
241   function StakeTradeHistoryDate ( uint256 ) external view returns ( uint256 );
242   function StakeTradeHistoryDateLength (  ) external view returns ( uint256 len );
243   function StakeTradeHistoryDateSet ( uint256 _StakeTradeHistoryDate ) external;
244   function StakeTradeHistoryETHFee ( uint256 ) external view returns ( uint256 );
245   function StakeTradeHistoryETHFeeLength (  ) external view returns ( uint256 len );
246   function StakeTradeHistoryETHFeeSet ( uint256 _StakeTradeHistoryETHFee ) external;
247   function StakeTradeHistoryETHPrice ( uint256 ) external view returns ( uint256 );
248   function StakeTradeHistoryETHPriceLength (  ) external view returns ( uint256 len );
249   function StakeTradeHistoryETHPriceSet ( uint256 _StakeTradeHistoryETHPrice ) external;
250   function StakeTradeHistoryMNEGenesisBurned ( uint256 ) external view returns ( uint256 );
251   function StakeTradeHistoryMNEGenesisBurnedLength (  ) external view returns ( uint256 len );
252   function StakeTradeHistoryMNEGenesisBurnedSet ( uint256 _StakeTradeHistoryMNEGenesisBurned ) external;
253   function StakeTradeHistorySeller ( uint256 ) external view returns ( address );
254   function StakeTradeHistorySellerLength (  ) external view returns ( uint256 len );
255   function StakeTradeHistorySellerSet ( address _StakeTradeHistorySeller ) external;
256   function StakeTradeHistoryStakeAmount ( uint256 ) external view returns ( uint256 );
257   function StakeTradeHistoryStakeAmountLength (  ) external view returns ( uint256 len );
258   function StakeTradeHistoryStakeAmountSet ( uint256 _StakeTradeHistoryStakeAmount ) external;
259   function deleteGenesisAddressesForSaleLevel1 (  ) external;
260   function deleteGenesisAddressesForSaleLevel2 (  ) external;
261   function deleteGenesisAddressesForSaleLevel3 (  ) external;
262   function deleteNormalAddressesForSale (  ) external;
263   function deleteStakeHoldersList (  ) external;
264   function deleteStakesForSale (  ) external;
265   function genesisAddressesForSaleLevel1 ( uint256 ) external view returns ( address );
266   function genesisAddressesForSaleLevel1Length (  ) external view returns ( uint256 len );
267   function genesisAddressesForSaleLevel1Set ( address _genesisAddressesForSaleLevel1 ) external;
268   function genesisAddressesForSaleLevel1SetAt ( uint256 i, address _address ) external;
269   function genesisAddressesForSaleLevel2 ( uint256 ) external view returns ( address );
270   function genesisAddressesForSaleLevel2Length (  ) external view returns ( uint256 len );
271   function genesisAddressesForSaleLevel2Set ( address _genesisAddressesForSaleLevel2 ) external;
272   function genesisAddressesForSaleLevel2SetAt ( uint256 i, address _address ) external;
273   function genesisAddressesForSaleLevel3 ( uint256 ) external view returns ( address );
274   function genesisAddressesForSaleLevel3Length (  ) external view returns ( uint256 len );
275   function genesisAddressesForSaleLevel3Set ( address _genesisAddressesForSaleLevel3 ) external;
276   function genesisAddressesForSaleLevel3SetAt ( uint256 i, address _address ) external;
277   function normalAddressesForSale ( uint256 ) external view returns ( address );
278   function normalAddressesForSaleLength (  ) external view returns ( uint256 len );
279   function normalAddressesForSaleSet ( address _normalAddressesForSale ) external;
280   function normalAddressesForSaleSetAt ( uint256 i, address _address ) external;
281   function ownerGenesis (  ) external view returns ( address );
282   function ownerGenesisBuys (  ) external view returns ( address );
283   function ownerMain (  ) external view returns ( address );
284   function ownerNormalAddress (  ) external view returns ( address );
285   function ownerStakeBuys (  ) external view returns ( address );
286   function ownerStakes (  ) external view returns ( address );
287   function setOwnerGenesis (  ) external;
288   function setOwnerGenesisBuys (  ) external;
289   function setOwnerMain (  ) external;
290   function setOwnerNormalAddress (  ) external;
291   function setOwnerStakeBuys (  ) external;
292   function setOwnerStakes (  ) external;
293   function stakeHoldersList ( uint256 ) external view returns ( address );
294   function stakeHoldersListAt ( uint256 i, address _address ) external;
295   function stakeHoldersListLength (  ) external view returns ( uint256 len );
296   function stakeHoldersListSet ( address _stakeHoldersList ) external;
297   function stakesForSale ( uint256 ) external view returns ( address );
298   function stakesForSaleLength (  ) external view returns ( uint256 len );
299   function stakesForSaleSet ( address _stakesForSale ) external;
300   function stakesForSaleSetAt ( uint256 i, address _address ) external;
301 }
302 
303 interface genesisCalls {
304   function AllowAddressToDestroyGenesis ( address _from, address _address ) external;
305   function AllowReceiveGenesisTransfers ( address _from ) external;
306   function BurnTokens ( address _from, uint256 mneToBurn ) external returns ( bool success );
307   function RemoveAllowAddressToDestroyGenesis ( address _from ) external;
308   function RemoveAllowReceiveGenesisTransfers ( address _from ) external;
309   function RemoveGenesisAddressFromSale ( address _from ) external;
310   function SetGenesisForSale ( address _from, uint256 weiPrice ) external;
311   function TransferGenesis ( address _from, address _to ) external;
312   function UpgradeToLevel2FromLevel1 ( address _address, uint256 weiValue ) external;
313   function UpgradeToLevel3FromDev ( address _address ) external;
314   function UpgradeToLevel3FromLevel1 ( address _address, uint256 weiValue ) external;
315   function UpgradeToLevel3FromLevel2 ( address _address, uint256 weiValue ) external;
316   function availableBalanceOf ( address _address ) external view returns ( uint256 Balance );
317   function balanceOf ( address _address ) external view returns ( uint256 balance );
318   function deleteAddressFromGenesisSaleList ( address _address ) external;
319   function isAnyGenesisAddress ( address _address ) external view returns ( bool success );
320   function isGenesisAddressLevel1 ( address _address ) external view returns ( bool success );
321   function isGenesisAddressLevel2 ( address _address ) external view returns ( bool success );
322   function isGenesisAddressLevel2Or3 ( address _address ) external view returns ( bool success );
323   function isGenesisAddressLevel3 ( address _address ) external view returns ( bool success );
324   function ownerGenesis (  ) external view returns ( address );
325   function ownerGenesisBuys (  ) external view returns ( address );
326   function ownerMain (  ) external view returns ( address );
327   function ownerNormalAddress (  ) external view returns ( address );
328   function ownerStakeBuys (  ) external view returns ( address );
329   function ownerStakes (  ) external view returns ( address );
330   function setGenesisCallerAddress ( address _caller ) external returns ( bool success );
331   function setOwnerGenesisBuys (  ) external;
332   function setOwnerMain (  ) external;
333   function setOwnerNormalAddress (  ) external;
334   function setOwnerStakeBuys (  ) external;
335   function setOwnerStakes (  ) external;
336   function BurnGenesisAddresses ( address _from, address[] calldata _genesisAddressesToBurn ) external;
337 }
338 
339 interface normalAddress {
340   function BuyNormalAddress ( address _from, address _address, uint256 _msgvalue ) external returns ( uint256 _totalToSend );
341   function RemoveNormalAddressFromSale ( address _address ) external;
342   function setBalanceNormalAddress ( address _from, address _address, uint256 balance ) external;
343   function SetNormalAddressForSale ( address _from, uint256 weiPricePerMNE ) external;
344   function setOwnerMain (  ) external;
345   function ownerMain (  ) external view returns ( address );
346 }
347 
348 interface stakes {
349   function RemoveStakeFromSale ( address _from ) external;
350   function SetStakeForSale ( address _from, uint256 priceInWei ) external;
351   function StakeTransferGenesis ( address _from, address _to, uint256 _value, address[] calldata _genesisAddressesToBurn ) external;
352   function StakeTransferMNE ( address _from, address _to, uint256 _value ) external returns ( uint256 _mneToBurn );
353   function ownerMain (  ) external view returns ( address );
354   function setBalanceStakes ( address _from, address _address, uint256 balance ) external;
355   function setOwnerMain (  ) external;
356 }
357 
358 interface stakeBuys {
359   function BuyStakeGenesis ( address _from, address _address, address[] calldata _genesisAddressesToBurn, uint256 _msgvalue ) external returns ( uint256 _feesToPayToSeller );
360   function BuyStakeMNE ( address _from, address _address, uint256 _msgvalue ) external returns ( uint256 _mneToBurn, uint256 _feesToPayToSeller );
361   function ownerMain (  ) external view returns ( address );
362   function setOwnerMain (  ) external;
363 }
364 
365 interface genesisBuys {
366   function BuyGenesisLevel1FromNormal ( address _from, address _address, uint256 _msgvalue ) external returns ( uint256 _totalToSend );
367   function BuyGenesisLevel2FromNormal ( address _from, address _address, uint256 _msgvalue ) external returns ( uint256 _totalToSend );
368   function BuyGenesisLevel3FromNormal ( address _from, address _address, uint256 _msgvalue ) external returns ( uint256 _totalToSend );
369   function ownerMain (  ) external view returns ( address );
370   function setOwnerMain (  ) external;
371 }
372 
373 interface tokenService {
374   function CreateToken ( address _from, uint256 _msgvalue ) external returns ( uint256 _mneToBurn, address _contract );
375   function CreateTokenICO ( address _from, uint256 _msgvalue ) external returns ( uint256 _mneToBurn, address _contract );
376   function ownerMain (  ) external view returns ( address );
377   function setOwnerMain (  ) external;
378 }
379 
380 interface baseTransfers {
381 	function setOwnerMain (  ) external;
382 	function transfer ( address _from, address _to, uint256 _value ) external;
383 	function transferFrom ( address _sender, address _from, address _to, uint256 _amount ) external returns ( bool success );
384 	function stopSetup ( address _from ) external returns ( bool success );
385 	function totalSupply (  ) external view returns ( uint256 TotalSupply );
386 }
387 
388 interface mneStaking {
389 	function startStaking(address _sender, uint256 _amountToStake, address[] calldata _addressList, uint256[] calldata uintList) external;
390 }
391 
392 interface luckyDraw {
393 	function BuyTickets(address _sender, uint256[] calldata _max) payable external returns ( uint256 );
394 }
395 
396 interface externalService {
397 	function externalFunction(address _sender, address[] calldata _addressList, uint256[] calldata _uintList) payable external returns ( uint256 );
398 }
399 
400 interface externalReceiver {
401 	function externalFunction(address _sender, uint256 _mneAmount, address[] calldata _addressList, uint256[] calldata _uintList) payable external;
402 }
403 
404 contract Minereum { 
405 string public name; 
406 string public symbol; 
407 uint8 public decimals; 
408 
409 event Transfer(address indexed from, address indexed to, uint256 value);
410 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
411 event LogStakeHolderSends(address indexed to, uint balance, uint amountToSend);
412 event LogFailedStakeHolderSends(address indexed to, uint balance, uint amountToSend);
413 event TokenCreation(address indexed from, address contractAdd);
414 event TokenCreationICO(address indexed from, address  contractAdd);
415 event StakeTransfer(address indexed from, address indexed to, uint256 value);
416 
417 publicCalls public pc;
418 publicArrays public pa;
419 genesisCalls public gn;
420 normalAddress public na;
421 stakes public st;
422 stakeBuys public stb;
423 genesisBuys public gnb;
424 tokenService public tks;
425 baseTransfers public bst;
426 mneStaking public mneStk;
427 luckyDraw public lkd;
428 externalService public extS1;
429 externalReceiver public extR1;
430 
431 address public updaterAddress = 0x0000000000000000000000000000000000000000;
432 function setUpdater() public {if (updaterAddress == 0x0000000000000000000000000000000000000000) updaterAddress = msg.sender; else revert();}
433 address public payoutOwner = 0x0000000000000000000000000000000000000000;
434 bool public payoutBlocked = false;
435 address payable public secondaryPayoutAddress = 0x0000000000000000000000000000000000000000;
436 
437 constructor(address _publicCallsAddress, address _publicArraysAddress, address _genesisCallsAddress, address _normalAddressAddress,
438  address _stakesAddress, address _stakesBuysAddress,address _genesisBuysAddress, address _tokenServiceAddress, address _baseTransfersAddress) public {
439 name = "Minereum"; 
440 symbol = "MNE"; 
441 decimals = 8; 
442 setUpdater();
443 pc = publicCalls(_publicCallsAddress);
444 pc.setOwnerMain();
445 pa = publicArrays(_publicArraysAddress);
446 pa.setOwnerMain();
447 gn = genesisCalls(_genesisCallsAddress);
448 gn.setOwnerMain();
449 na = normalAddress(_normalAddressAddress);
450 na.setOwnerMain();
451 st = stakes(_stakesAddress);
452 st.setOwnerMain();
453 stb = stakeBuys(_stakesBuysAddress);
454 stb.setOwnerMain();
455 gnb = genesisBuys(_genesisBuysAddress);
456 gnb.setOwnerMain();
457 tks = tokenService(_tokenServiceAddress);
458 tks.setOwnerMain();
459 bst = baseTransfers(_baseTransfersAddress);
460 bst.setOwnerMain();
461 }
462 
463 function reloadGenesis(address _address) public { if (msg.sender == updaterAddress)	{gn = genesisCalls(_address); gn.setOwnerMain(); } else revert();}
464 function reloadNormalAddress(address _address) public { if (msg.sender == updaterAddress)	{na = normalAddress(_address); na.setOwnerMain(); } else revert();}
465 function reloadStakes(address _address) public { if (msg.sender == updaterAddress)	{st = stakes(_address); st.setOwnerMain(); } else revert();}
466 function reloadStakeBuys(address _address) public { if (msg.sender == updaterAddress)	{stb = stakeBuys(_address); stb.setOwnerMain(); } else revert();}
467 function reloadGenesisBuys(address _address) public { if (msg.sender == updaterAddress)	{gnb = genesisBuys(_address); gnb.setOwnerMain(); } else revert();}
468 function reloadTokenService(address _address) public { if (msg.sender == updaterAddress)	{tks = tokenService(_address); tks.setOwnerMain(); } else revert();}
469 function reloadBaseTransfers(address _address) public { if (msg.sender == updaterAddress)	{bst = baseTransfers(_address); bst.setOwnerMain(); } else revert();}
470 function reloadPublicCalls(address _address, uint code) public { if (!(code == 1234)) revert();  if (msg.sender == updaterAddress)	{pc = publicCalls(_address); pc.setOwnerMain();} else revert();}
471 function reloadPublicArrays(address _address, uint code) public { if (!(code == 1234)) revert();  if (msg.sender == updaterAddress)	{pa = publicArrays(_address); pa.setOwnerMain();} else revert();}
472 function loadMNEStaking(address _address) public { if (msg.sender == updaterAddress)	{mneStk = mneStaking(_address); } else revert();}
473 function loadLuckyDraw(address _address) public { if (msg.sender == updaterAddress)	{lkd = luckyDraw(_address); } else revert();}
474 
475 function externalService1(address _address) public { if (msg.sender == updaterAddress)	{extS1 = externalService(_address); } else revert();}
476 function externalReceiver1(address _address) public { if (msg.sender == updaterAddress)	{extR1 = externalReceiver(_address); } else revert();}
477 
478 
479 function setPayoutOwner() public
480 {
481 	if(payoutOwner == 0x0000000000000000000000000000000000000000)
482 		payoutOwner = msg.sender;
483 	else
484 		revert();
485 }
486 
487 function setSecondaryPayoutAddress(address payable _address) public
488 {
489 	if(msg.sender == payoutOwner)
490 		secondaryPayoutAddress = _address;
491 	else
492 		revert();
493 }
494 
495 function SetBlockPayouts(bool toBlock) public
496 {
497 	if(msg.sender == payoutOwner)
498 	{
499 		payoutBlocked = toBlock;
500 	}
501 }
502 
503 
504 function currentEthBlock() public view returns (uint256 blockNumber) 
505 {
506 	return block.number;
507 }
508 
509 function currentBlock() public view returns (uint256 blockNumber)
510 {
511 	return block.number - pc.initialBlockCount();
512 }
513 
514 function availableBalanceOf(address _address) public view returns (uint256 Balance)
515 {
516 	return gn.availableBalanceOf(_address);
517 }
518 
519 function totalSupply() public view returns (uint256 TotalSupply)
520 {	
521 	return bst.totalSupply();
522 }
523 
524 function transfer(address _to, uint256 _value)  public { 
525 if (_to == address(this)) revert('if (_to == address(this))');
526 bst.transfer(msg.sender, _to, _value);
527 emit Transfer(msg.sender, _to, _value); 
528 }
529 
530 function transferFrom(
531         address _from,
532         address _to,
533         uint256 _amount
534 ) public returns (bool success) {
535 		bool result = bst.transferFrom(msg.sender, _from, _to, _amount);
536         if (result) emit Transfer(_from, _to, _amount);
537         return result;    
538 }
539 
540 function approve(address _spender, uint256 _amount) public returns (bool success) {
541     pc.allowedSet(msg.sender,_spender, _amount);
542     emit Approval(msg.sender, _spender, _amount);
543     return true;
544 }
545 
546 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
547     return pc.allowed(_owner,_spender);
548 }
549 
550 function balanceOf(address _address) public view returns (uint256 balance) {
551 	return gn.balanceOf(_address);
552 }
553 
554 function stakeBalanceOf(address _address) public view returns (uint256 balance) {
555 	return pc.stakeBalances(_address);
556 }
557 
558 function TransferGenesis(address _to) public {
559 	emit Transfer(msg.sender, _to, balanceOf(msg.sender));	
560 	if (_to == address(this)) revert('if (_to == address(this))');	
561 	gn.TransferGenesis(msg.sender, _to);	
562 }
563 
564 function SetGenesisForSale(uint256 weiPrice) public {	
565 	gn.SetGenesisForSale(msg.sender, weiPrice);
566 }
567 
568 function AllowReceiveGenesisTransfers() public { 
569 	gn.AllowReceiveGenesisTransfers(msg.sender);
570 }
571 
572 function RemoveAllowReceiveGenesisTransfers() public { 
573 	gn.RemoveAllowReceiveGenesisTransfers(msg.sender);
574 }
575 
576 function RemoveGenesisAddressFromSale() public { 
577 	gn.RemoveGenesisAddressFromSale(msg.sender);
578 }
579 
580 function AllowAddressToDestroyGenesis(address _address) public  { 
581 	gn.AllowAddressToDestroyGenesis(msg.sender, _address);
582 }
583 
584 function RemoveAllowAddressToDestroyGenesis() public { 
585 	gn.RemoveAllowAddressToDestroyGenesis(msg.sender);
586 }
587 
588 function UpgradeToLevel2FromLevel1() public payable {
589 	gn.UpgradeToLevel2FromLevel1(msg.sender, msg.value);
590 }
591 
592 function UpgradeToLevel3FromLevel1() public payable {
593 	gn.UpgradeToLevel3FromLevel1(msg.sender, msg.value);
594 }
595 
596 function UpgradeToLevel3FromLevel2() public payable {
597 	gn.UpgradeToLevel3FromLevel2(msg.sender, msg.value);
598 }
599 
600 function UpgradeToLevel3FromDev() public {
601 	gn.UpgradeToLevel3FromDev(msg.sender);
602 }
603 
604 function UpgradeOthersToLevel2FromLevel1(address[] memory _addresses) public payable {
605 	uint count = _addresses.length;
606 	if (msg.value != (pc.ethFeeToUpgradeToLevel2()*count)) revert('(msg.value != pc.ethFeeToUpgradeToLevel2()*count)');
607 	uint i = 0;
608 	while (i < count)
609 	{
610 		gn.UpgradeToLevel2FromLevel1(_addresses[i], pc.ethFeeToUpgradeToLevel2());
611 		i++;
612 	}
613 }
614 
615 function UpgradeOthersToLevel3FromLevel1(address[] memory _addresses) public payable {
616 	uint count = _addresses.length;
617 	if (msg.value != ((pc.ethFeeToUpgradeToLevel2() + pc.ethFeeToUpgradeToLevel3())*count)) revert('(weiValue != ((msg.value + pc.ethFeeToUpgradeToLevel3())*count))');
618 	uint i = 0;
619 	while (i < count)
620 	{
621 		gn.UpgradeToLevel3FromLevel1(_addresses[i], (pc.ethFeeToUpgradeToLevel2() + pc.ethFeeToUpgradeToLevel3()));
622 		i++;
623 	}
624 }
625 
626 function UpgradeOthersToLevel3FromLevel2(address[] memory _addresses) public payable {
627 	uint count = _addresses.length;
628 	if (msg.value != (pc.ethFeeToUpgradeToLevel3()*count)) revert('(msg.value != (pc.ethFeeToUpgradeToLevel3()*count))');
629 	uint i = 0;
630 	while (i < count)
631 	{
632 		gn.UpgradeToLevel3FromLevel2(_addresses[i], pc.ethFeeToUpgradeToLevel3());
633 		i++;
634 	}
635 }
636 
637 function UpgradeOthersToLevel3FromDev(address[] memory _addresses) public {
638 	uint count = _addresses.length;	
639 	uint i = 0;
640 	while (i < count)
641 	{
642 		gn.UpgradeToLevel3FromDev(_addresses[i]);
643 		i++;
644 	}
645 }
646 
647 function BuyGenesisAddress(address payable _address) public payable
648 {
649 	if (gn.isGenesisAddressLevel1(_address))
650 		BuyGenesisLevel1FromNormal(_address);
651 	else if (gn.isGenesisAddressLevel2(_address))
652 		BuyGenesisLevel2FromNormal(_address);
653 	else if (gn.isGenesisAddressLevel3(_address))
654 		BuyGenesisLevel3FromNormal(_address);
655 	else
656 		revert('Address not for sale');
657 }
658 
659 function SetNormalAddressForSale(uint256 weiPricePerMNE) public {	
660 	na.SetNormalAddressForSale(msg.sender, weiPricePerMNE);
661 }
662 
663 function RemoveNormalAddressFromSale() public
664 {
665 	na.RemoveNormalAddressFromSale(msg.sender);
666 }
667 
668 function BuyNormalAddress(address payable _address) public payable{
669 	emit Transfer(_address, msg.sender, balanceOf(_address));
670 	uint256 feesToPayToSeller = na.BuyNormalAddress(msg.sender, address(_address), msg.value);				
671 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');		
672 }
673 
674 function setBalanceNormalAddress(address _address, uint256 _balance) public
675 {
676 	na.setBalanceNormalAddress(msg.sender, _address, _balance);
677 	emit Transfer(address(this), _address, _balance); 
678 }
679 
680 function ContractTransferAllFundsOut() public
681 {
682 	//in case of hack, funds can be transfered out to another addresses and transferred to the stake holders from there
683 	if (payoutBlocked)
684 		if(!secondaryPayoutAddress.send(address(this).balance)) revert();
685 }
686 
687 function PayoutStakeHolders() public {
688 	require(msg.sender == tx.origin); //For security reasons this line is to prevent smart contract calls
689 	if (payoutBlocked) revert('Payouts Blocked'); //In case of hack, payouts can be blocked
690 	uint contractBalance = address(this).balance;
691 	if (!(contractBalance > 0)) revert('(!(contractBalance > 0))');
692 	uint i;
693 	uint max;
694 	
695 	i = 0;
696 	max = pa.stakeHoldersListLength();
697 
698 	while (i < max)
699 	{
700 		address payable add = payable(pa.stakeHoldersList(i));
701 		uint balance = pc.stakeBalances(add);
702 		uint amountToSend = contractBalance * balance / pc.stakeDecimals();
703 		if (amountToSend > 0)
704 		{
705 			if (!add.send(amountToSend))
706 				emit LogFailedStakeHolderSends(add, balance, amountToSend);
707 			else
708 			{
709 				pc.totalPaidStakeHoldersSet(pc.totalPaidStakeHolders() + amountToSend);				
710 			}			
711 		}
712 		i++;
713 	}
714 }
715 
716 function stopSetup() public returns (bool success)
717 {
718 	return bst.stopSetup(msg.sender);
719 }
720 
721 function BurnTokens(uint256 mneToBurn) public returns (bool success) {	
722 	gn.BurnTokens(msg.sender, mneToBurn);
723 	emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, mneToBurn);
724 	return true;
725 }
726 
727 function SetStakeForSale(uint256 priceInWei) public
728 {	
729 	st.SetStakeForSale(msg.sender, priceInWei);
730 }
731 
732 function RemoveStakeFromSale() public {
733 	st.RemoveStakeFromSale(msg.sender);
734 }
735 
736 function StakeTransferMNE(address _to, uint256 _value) public {
737 	if (_to == address(this)) revert('if (_to == address(this))');
738 	BurnTokens(st.StakeTransferMNE(msg.sender, _to, _value));
739 	emit StakeTransfer(msg.sender, _to, _value); 
740 }
741 
742 function BurnGenesisAddresses(address[] memory _genesisAddressesToBurn) public
743 {
744 	uint i = 0;	
745 	while(i < _genesisAddressesToBurn.length)
746 	{
747 		emit Transfer(_genesisAddressesToBurn[i], 0x0000000000000000000000000000000000000000, balanceOf(_genesisAddressesToBurn[i]));
748 		i++;
749 	}
750 	gn.BurnGenesisAddresses(msg.sender, _genesisAddressesToBurn);	
751 }
752 
753 function StakeTransferGenesis(address _to, uint256 _value, address[] memory _genesisAddressesToBurn) public {
754 	if (_to == address(this)) revert('if (_to == address(this))');
755 	uint i = 0;	
756 	while(i < _genesisAddressesToBurn.length)
757 	{
758 		emit Transfer(_genesisAddressesToBurn[i], 0x0000000000000000000000000000000000000000, balanceOf(_genesisAddressesToBurn[i]));
759 		i++;
760 	}
761 	st.StakeTransferGenesis(msg.sender, _to, _value, _genesisAddressesToBurn);	
762 	emit StakeTransfer(msg.sender, _to, _value); 
763 }
764 
765 function setBalanceStakes(address _address, uint256 balance) public {
766 	st.setBalanceStakes(msg.sender, _address, balance);
767 }
768 
769 function BuyGenesisLevel1FromNormal(address payable _address) public payable {
770 	emit Transfer(_address, msg.sender, balanceOf(_address));
771 	uint256 feesToPayToSeller = gnb.BuyGenesisLevel1FromNormal(msg.sender, address(_address), msg.value);
772 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');				
773 }
774 
775 function BuyGenesisLevel2FromNormal(address payable _address) public payable{
776 	emit Transfer(_address, msg.sender, balanceOf(_address));
777 	uint256 feesToPayToSeller = gnb.BuyGenesisLevel2FromNormal(msg.sender, address(_address), msg.value);	
778 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');	
779 }
780 
781 function BuyGenesisLevel3FromNormal(address payable _address) public payable{
782 	emit Transfer(_address, msg.sender, balanceOf(_address));
783 	uint256 feesToPayToSeller = gnb.BuyGenesisLevel3FromNormal(msg.sender, address(_address), msg.value);	
784 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');		
785 }
786 
787 function BuyStakeMNE(address payable _address) public payable {
788 	uint256 balanceToSend = pc.stakeBalances(_address);
789 	(uint256 mneToBurn, uint256 feesToPayToSeller) = stb.BuyStakeMNE(msg.sender, address(_address), msg.value);
790 	BurnTokens(mneToBurn);
791 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');	
792 	emit StakeTransfer(_address, msg.sender, balanceToSend); 
793 }
794 
795 function BuyStakeGenesis(address payable _address, address[] memory _genesisAddressesToBurn) public payable {
796 	uint256 balanceToSend = pc.stakeBalances(_address);
797 	uint i = 0;
798 	while(i < _genesisAddressesToBurn.length)
799 	{
800 		emit Transfer(_genesisAddressesToBurn[i], 0x0000000000000000000000000000000000000000, balanceOf(_genesisAddressesToBurn[i]));
801 		i++;
802 	}
803 	uint256 feesToPayToSeller = stb.BuyStakeGenesis(msg.sender, address(_address), _genesisAddressesToBurn, msg.value);
804 	if(!_address.send(feesToPayToSeller)) revert();		
805 	emit StakeTransfer(_address, msg.sender, balanceToSend); 
806 }
807 
808 function CreateToken() public payable {
809 	(uint256 _mneToBurn, address tokenAdderss) = tks.CreateToken(msg.sender, msg.value);
810 	BurnTokens(_mneToBurn);
811 	emit TokenCreation(msg.sender, tokenAdderss);
812 }
813 
814 function CreateTokenICO() public payable {
815 	(uint256 _mneToBurn, address tokenAdderss) = tks.CreateTokenICO(msg.sender, msg.value);
816 	BurnTokens(_mneToBurn);
817 	emit TokenCreationICO(msg.sender, tokenAdderss);
818 }
819 
820 function Payment() public payable {
821 	
822 }
823 
824 function BuyLuckyDrawTickets(uint256[] memory max) public payable {
825 	uint256 _mneToBurn = lkd.BuyTickets.value(msg.value)(msg.sender, max);
826 	if (_mneToBurn > 0) BurnTokens(_mneToBurn);
827 }
828 
829 function Staking(uint256 _amountToStake, address[] memory _addressList, uint256[] memory uintList) public {
830 	if (_amountToStake > 0)
831 	{
832 		bst.transfer(msg.sender, address(mneStk), _amountToStake);
833 		emit Transfer(msg.sender, address(mneStk), _amountToStake); 
834 	}
835 	mneStk.startStaking(msg.sender, _amountToStake, _addressList, uintList);
836 }
837 
838 function isAnyGenesisAddress(address _address) public view returns (bool success) {
839 	return gn.isAnyGenesisAddress(_address);
840 }
841 
842 function isGenesisAddressLevel1(address _address) public view returns (bool success) {
843 	return gn.isGenesisAddressLevel1(_address);
844 }
845 
846 function isGenesisAddressLevel2(address _address) public view returns (bool success) {
847 	return gn.isGenesisAddressLevel2(_address);
848 }
849 
850 function isGenesisAddressLevel3(address _address) public view returns (bool success) {
851 	return gn.isGenesisAddressLevel3(_address);
852 }
853 
854 function isGenesisAddressLevel2Or3(address _address) public view returns (bool success) {
855 	return gn.isGenesisAddressLevel2Or3(_address);
856 }
857 
858 function registerAddresses(address[] memory _addressList) public {
859 	uint i = 0;
860 	if (pc.setupRunning() && msg.sender == pc.genesisCallerAddress())
861 	{
862 		while(i < _addressList.length)
863 		{
864 			emit Transfer(address(this), _addressList[i], gn.balanceOf(_addressList[i]));
865 			i++;
866 		}
867 	}
868 	else 
869 	{
870 		revert();
871 	}
872 }
873 
874 function registerAddressesValue(address[] memory _addressList, uint _value) public {
875 	uint i = 0;
876 	if (pc.setupRunning() && msg.sender == pc.genesisCallerAddress())
877 	{
878 		while(i < _addressList.length)
879 		{
880 			emit Transfer(address(this), _addressList[i], _value);
881 			i++;
882 		}
883 	}
884 	else 
885 	{
886 		revert();
887 	}
888 }
889 
890 function ethFeeToUpgradeToLevel2Set(uint256 _ethFeeToUpgradeToLevel2) public {pc.ethFeeToUpgradeToLevel2Set(msg.sender, _ethFeeToUpgradeToLevel2);}
891 function ethFeeToUpgradeToLevel3Set(uint256 _ethFeeToUpgradeToLevel3) public {pc.ethFeeToUpgradeToLevel3Set(msg.sender, _ethFeeToUpgradeToLevel3);}
892 function ethFeeToBuyLevel1Set(uint256 _ethFeeToBuyLevel1) public {pc.ethFeeToBuyLevel1Set(msg.sender, _ethFeeToBuyLevel1);}
893 function ethFeeForSellerLevel1Set(uint256 _ethFeeForSellerLevel1) public {pc.ethFeeForSellerLevel1Set(msg.sender, _ethFeeForSellerLevel1);}
894 function ethFeeForTokenSet(uint256 _ethFeeForToken) public {pc.ethFeeForTokenSet(msg.sender, _ethFeeForToken);}
895 function ethFeeForTokenICOSet(uint256 _ethFeeForTokenICO) public {pc.ethFeeForTokenICOSet(msg.sender, _ethFeeForTokenICO);}
896 function ethPercentFeeGenesisExchangeSet(uint256 _ethPercentFeeGenesisExchange) public {pc.ethPercentFeeGenesisExchangeSet(msg.sender, _ethPercentFeeGenesisExchange);}
897 function ethPercentFeeNormalExchangeSet(uint256 _ethPercentFeeNormalExchange) public {pc.ethPercentFeeNormalExchangeSet(msg.sender, _ethPercentFeeNormalExchange);}
898 function ethPercentStakeExchangeSet(uint256 _ethPercentStakeExchange) public {pc.ethPercentStakeExchangeSet(msg.sender, _ethPercentStakeExchange);}
899 function amountOfGenesisToBuyStakesSet(uint256 _amountOfGenesisToBuyStakes) public {pc.amountOfGenesisToBuyStakesSet(msg.sender, _amountOfGenesisToBuyStakes);}
900 function amountOfMNEToBuyStakesSet(uint256 _amountOfMNEToBuyStakes) public {pc.amountOfMNEToBuyStakesSet(msg.sender, _amountOfMNEToBuyStakes);}
901 function amountOfMNEForTokenSet(uint256 _amountOfMNEForToken) public {pc.amountOfMNEForTokenSet(msg.sender, _amountOfMNEForToken);}
902 function amountOfMNEForTokenICOSet(uint256 _amountOfMNEForTokenICO) public {pc.amountOfMNEForTokenICOSet(msg.sender, _amountOfMNEForTokenICO);}
903 function amountOfMNEToTransferStakesSet(uint256 _amountOfMNEToTransferStakes) public {pc.amountOfMNEToTransferStakesSet(msg.sender, _amountOfMNEToTransferStakes);}
904 function amountOfGenesisToTransferStakesSet(uint256 _amountOfGenesisToTransferStakes) public {pc.amountOfGenesisToTransferStakesSet(msg.sender, _amountOfGenesisToTransferStakes);}
905 function stakeDecimalsSet(uint256 _stakeDecimals) public {pc.stakeDecimalsSet(msg.sender, _stakeDecimals);}
906 
907 
908 function ServiceFunction1(address[] memory _addressList, uint256[] memory _uintList) public payable {
909 	uint256 _mneToBurn = extS1.externalFunction.value(msg.value)(msg.sender, _addressList, _uintList);
910 	if (_mneToBurn > 0) BurnTokens(_mneToBurn);	
911 }
912 
913 function ReceiverFunction1(uint256 _mneAmount, address[] memory _addressList, uint256[] memory _uintList) public payable {
914 	if (_mneAmount > 0)
915 	{
916 		bst.transfer(msg.sender, address(extR1), _mneAmount);
917 		emit Transfer(msg.sender, address(extR1), _mneAmount); 
918 	}
919 	extR1.externalFunction.value(msg.value)(msg.sender, _mneAmount, _addressList, _uintList);	
920 }
921 }