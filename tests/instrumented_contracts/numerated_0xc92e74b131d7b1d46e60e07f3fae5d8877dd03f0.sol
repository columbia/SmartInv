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
388 contract Minereum { 
389 string public name; 
390 string public symbol; 
391 uint8 public decimals; 
392 
393 event Transfer(address indexed from, address indexed to, uint256 value);
394 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
395 event LogStakeHolderSends(address indexed to, uint balance, uint amountToSend);
396 event LogFailedStakeHolderSends(address indexed to, uint balance, uint amountToSend);
397 event TokenCreation(address indexed from, address contractAdd);
398 event TokenCreationICO(address indexed from, address  contractAdd);
399 event StakeTransfer(address indexed from, address indexed to, uint256 value);
400 
401 publicCalls public pc;
402 publicArrays public pa;
403 genesisCalls public gn;
404 normalAddress public na;
405 stakes public st;
406 stakeBuys public stb;
407 genesisBuys public gnb;
408 tokenService public tks;
409 baseTransfers public bst;
410 
411 address public updaterAddress = 0x0000000000000000000000000000000000000000;
412 function setUpdater() public {if (updaterAddress == 0x0000000000000000000000000000000000000000) updaterAddress = msg.sender; else revert();}
413 address public payoutOwner = 0x0000000000000000000000000000000000000000;
414 bool public payoutBlocked = false;
415 address payable public secondaryPayoutAddress = 0x0000000000000000000000000000000000000000;
416 
417 constructor(address _publicCallsAddress, address _publicArraysAddress, address _genesisCallsAddress, address _normalAddressAddress,
418  address _stakesAddress, address _stakesBuysAddress,address _genesisBuysAddress, address _tokenServiceAddress, address _baseTransfersAddress) public {
419 name = "Minereum"; 
420 symbol = "MNE"; 
421 decimals = 8; 
422 setUpdater();
423 pc = publicCalls(_publicCallsAddress);
424 pc.setOwnerMain();
425 pa = publicArrays(_publicArraysAddress);
426 pa.setOwnerMain();
427 gn = genesisCalls(_genesisCallsAddress);
428 gn.setOwnerMain();
429 na = normalAddress(_normalAddressAddress);
430 na.setOwnerMain();
431 st = stakes(_stakesAddress);
432 st.setOwnerMain();
433 stb = stakeBuys(_stakesBuysAddress);
434 stb.setOwnerMain();
435 gnb = genesisBuys(_genesisBuysAddress);
436 gnb.setOwnerMain();
437 tks = tokenService(_tokenServiceAddress);
438 tks.setOwnerMain();
439 bst = baseTransfers(_baseTransfersAddress);
440 bst.setOwnerMain();
441 pc.initialBlockCountSet(block.number);
442 pc.overallSupplySet(0);
443 pc.genesisSalesCountSet(0);
444 pc.genesisSalesPriceCountSet(0);
445 pc.genesisTransfersCountSet(0);
446 pc.setupRunningSet(true);
447 pc.genesisCallerAddressSet(0x0000000000000000000000000000000000000000);
448 }
449 
450 function reloadGenesis(address _address) public { if (msg.sender == updaterAddress)	{gn = genesisCalls(_address); gn.setOwnerMain(); } else revert();}
451 function reloadNormalAddress(address _address) public { if (msg.sender == updaterAddress)	{na = normalAddress(_address); na.setOwnerMain(); } else revert();}
452 function reloadStakes(address _address) public { if (msg.sender == updaterAddress)	{st = stakes(_address); st.setOwnerMain(); } else revert();}
453 function reloadStakeBuys(address _address) public { if (msg.sender == updaterAddress)	{stb = stakeBuys(_address); stb.setOwnerMain(); } else revert();}
454 function reloadGenesisBuys(address _address) public { if (msg.sender == updaterAddress)	{gnb = genesisBuys(_address); gnb.setOwnerMain(); } else revert();}
455 function reloadTokenService(address _address) public { if (msg.sender == updaterAddress)	{tks = tokenService(_address); tks.setOwnerMain(); } else revert();}
456 function reloadPublicCalls(address _address, uint code) public { if (!(code == 1234)) revert();  if (msg.sender == updaterAddress)	{pc = publicCalls(_address); pc.setOwnerMain();} else revert();}
457 function reloadPublicArrays(address _address, uint code) public { if (!(code == 1234)) revert();  if (msg.sender == updaterAddress)	{pa = publicArrays(_address); pa.setOwnerMain();} else revert();}
458 
459 function setPayoutOwner() public
460 {
461 	if(payoutOwner == 0x0000000000000000000000000000000000000000)
462 		payoutOwner = msg.sender;
463 	else
464 		revert();
465 }
466 
467 function setSecondaryPayoutAddress(address payable _address) public
468 {
469 	if(msg.sender == payoutOwner)
470 		secondaryPayoutAddress = _address;
471 	else
472 		revert();
473 }
474 
475 
476 
477 function SetBlockPayouts(bool toBlock) public
478 {
479 	if(msg.sender == payoutOwner)
480 	{
481 		payoutBlocked = toBlock;
482 	}
483 }
484 
485 
486 function currentEthBlock() public view returns (uint256 blockNumber) 
487 {
488 	return block.number;
489 }
490 
491 function currentBlock() public view returns (uint256 blockNumber)
492 {
493 	return block.number - pc.initialBlockCount();
494 }
495 
496 function availableBalanceOf(address _address) public view returns (uint256 Balance)
497 {
498 	return gn.availableBalanceOf(_address);
499 }
500 
501 function totalSupply() public view returns (uint256 TotalSupply)
502 {	
503 	return bst.totalSupply();
504 }
505 
506 function transfer(address _to, uint256 _value)  public { 
507 if (_to == address(this)) revert('if (_to == address(this))');
508 bst.transfer(msg.sender, _to, _value);
509 emit Transfer(msg.sender, _to, _value); 
510 }
511 
512 function transferFrom(
513         address _from,
514         address _to,
515         uint256 _amount
516 ) public returns (bool success) {
517 		bool result = bst.transferFrom(msg.sender, _from, _to, _amount);
518         emit Transfer(_from, _to, _amount);
519         return result;    
520 }
521 
522 function approve(address _spender, uint256 _amount) public returns (bool success) {
523     pc.allowedSet(msg.sender,_spender, _amount);
524     emit Approval(msg.sender, _spender, _amount);
525     return true;
526 }
527 
528 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
529     return pc.allowed(_owner,_spender);
530 }
531 
532 function balanceOf(address _address) public view returns (uint256 balance) {
533 	return gn.balanceOf(_address);
534 }
535 
536 function stakeBalanceOf(address _address) public view returns (uint256 balance) {
537 	return pc.stakeBalances(_address);
538 }
539 
540 function TransferGenesis(address _to) public {
541 	if (_to == address(this)) revert('if (_to == address(this))');	
542 	gn.TransferGenesis(msg.sender, _to);
543 	emit Transfer(msg.sender, _to, balanceOf(_to));	
544 }
545 
546 function SetGenesisForSale(uint256 weiPrice) public {	
547 	gn.SetGenesisForSale(msg.sender, weiPrice);
548 }
549 
550 function AllowReceiveGenesisTransfers() public { 
551 	gn.AllowReceiveGenesisTransfers(msg.sender);
552 }
553 
554 function RemoveAllowReceiveGenesisTransfers() public { 
555 	gn.RemoveAllowReceiveGenesisTransfers(msg.sender);
556 }
557 
558 function RemoveGenesisAddressFromSale() public { 
559 	gn.RemoveGenesisAddressFromSale(msg.sender);
560 }
561 
562 function AllowAddressToDestroyGenesis(address _address) public  { 
563 	gn.AllowAddressToDestroyGenesis(msg.sender, _address);
564 }
565 
566 function RemoveAllowAddressToDestroyGenesis() public { 
567 	gn.RemoveAllowAddressToDestroyGenesis(msg.sender);
568 }
569 
570 function UpgradeToLevel2FromLevel1() public payable {
571 	gn.UpgradeToLevel2FromLevel1(msg.sender, msg.value);
572 }
573 
574 function UpgradeToLevel3FromLevel1() public payable {
575 	gn.UpgradeToLevel3FromLevel1(msg.sender, msg.value);
576 }
577 
578 function UpgradeToLevel3FromLevel2() public payable {
579 	gn.UpgradeToLevel3FromLevel2(msg.sender, msg.value);
580 }
581 
582 function UpgradeToLevel3FromDev() public {
583 	gn.UpgradeToLevel3FromDev(msg.sender);
584 }
585 
586 function UpgradeOthersToLevel2FromLevel1(address[] memory _addresses) public payable {
587 	uint count = _addresses.length;
588 	if (msg.value != (pc.ethFeeToUpgradeToLevel2()*count)) revert('(msg.value != pc.ethFeeToUpgradeToLevel2()*count)');
589 	uint i = 0;
590 	while (i < count)
591 	{
592 		gn.UpgradeToLevel2FromLevel1(_addresses[i], pc.ethFeeToUpgradeToLevel2());
593 		i++;
594 	}
595 }
596 
597 function UpgradeOthersToLevel3FromLevel1(address[] memory _addresses) public payable {
598 	uint count = _addresses.length;
599 	if (msg.value != ((pc.ethFeeToUpgradeToLevel2() + pc.ethFeeToUpgradeToLevel3())*count)) revert('(weiValue != ((msg.value + pc.ethFeeToUpgradeToLevel3())*count))');
600 	uint i = 0;
601 	while (i < count)
602 	{
603 		gn.UpgradeToLevel3FromLevel1(_addresses[i], (pc.ethFeeToUpgradeToLevel2() + pc.ethFeeToUpgradeToLevel3()));
604 		i++;
605 	}
606 }
607 
608 function UpgradeOthersToLevel3FromLevel2(address[] memory _addresses) public payable {
609 	uint count = _addresses.length;
610 	if (msg.value != (pc.ethFeeToUpgradeToLevel3()*count)) revert('(msg.value != (pc.ethFeeToUpgradeToLevel3()*count))');
611 	uint i = 0;
612 	while (i < count)
613 	{
614 		gn.UpgradeToLevel3FromLevel2(_addresses[i], pc.ethFeeToUpgradeToLevel3());
615 		i++;
616 	}
617 }
618 
619 function UpgradeOthersToLevel3FromDev(address[] memory _addresses) public {
620 	uint count = _addresses.length;	
621 	uint i = 0;
622 	while (i < count)
623 	{
624 		gn.UpgradeToLevel3FromDev(_addresses[i]);
625 		i++;
626 	}
627 }
628 
629 function BuyGenesisAddress(address payable _address) public payable
630 {
631 	if (gn.isGenesisAddressLevel1(_address))
632 		BuyGenesisLevel1FromNormal(_address);
633 	else if (gn.isGenesisAddressLevel2(_address))
634 		BuyGenesisLevel2FromNormal(_address);
635 	else if (gn.isGenesisAddressLevel3(_address))
636 		BuyGenesisLevel3FromNormal(_address);
637 	else
638 		revert('Address not for sale');
639 }
640 
641 function SetNormalAddressForSale(uint256 weiPricePerMNE) public {	
642 	na.SetNormalAddressForSale(msg.sender, weiPricePerMNE);
643 }
644 
645 function RemoveNormalAddressFromSale() public
646 {
647 	na.RemoveNormalAddressFromSale(msg.sender);
648 }
649 
650 function BuyNormalAddress(address payable _address) public payable{
651 	uint256 feesToPayToSeller = na.BuyNormalAddress(msg.sender, address(_address), msg.value);				
652 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');
653 	emit Transfer(_address, msg.sender, balanceOf(_address));	
654 }
655 
656 function setBalanceNormalAddress(address _address, uint256 _balance) public
657 {
658 	na.setBalanceNormalAddress(msg.sender, _address, _balance);
659 	emit Transfer(address(this), _address, _balance); 
660 }
661 
662 function ContractTransferAllFundsOut() public
663 {
664 	//in case of hack, funds can be transfered out to another addresses and transferred to the stake holders from there
665 	if (payoutBlocked)
666 		if(!secondaryPayoutAddress.send(address(this).balance)) revert();
667 }
668 
669 function PayoutStakeHolders(uint minId, uint maxId) public {
670 	require(msg.sender == tx.origin); //For security reasons this line is to prevent smart contract calls
671 	if (payoutBlocked) revert('Payouts Blocked'); //In case of hack, payouts can be blocked
672 	uint contractBalance = address(this).balance;
673 	if (!(contractBalance > 0)) revert('(!(contractBalance > 0))');
674 	uint i;
675 	uint max;
676 	
677 	if (minId > 0 && maxId >0)
678 	{
679 		i = minId;
680 		max = maxId;
681 	}
682 	else
683 	{
684 		i = 0;
685 		max = pa.stakeHoldersListLength();
686 	}
687 
688 	while (i < max)
689 	{
690 		address payable add = payable(pa.stakeHoldersList(i));
691 		uint balance = pc.stakeBalances(add);
692 		uint amountToSend = contractBalance * balance / pc.stakeDecimals();
693 		if (amountToSend > 0)
694 		{
695 			if (!add.send(amountToSend))
696 				emit LogFailedStakeHolderSends(add, balance, amountToSend);
697 			else
698 			{
699 				pc.totalPaidStakeHoldersSet(pc.totalPaidStakeHolders() + amountToSend);
700 				emit LogStakeHolderSends(add, balance, amountToSend);	
701 			}			
702 		}
703 		i++;
704 	}
705 }
706 
707 function stopSetup() public returns (bool success)
708 {
709 	return bst.stopSetup(msg.sender);
710 }
711 
712 function BurnTokens(uint256 mneToBurn) public returns (bool success) {	
713 	gn.BurnTokens(msg.sender, mneToBurn);
714 	emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, mneToBurn);
715 	return true;
716 }
717 
718 function SetStakeForSale(uint256 priceInWei) public
719 {	
720 	st.SetStakeForSale(msg.sender, priceInWei);
721 }
722 
723 function RemoveStakeFromSale() public {
724 	st.RemoveStakeFromSale(msg.sender);
725 }
726 
727 function StakeTransferMNE(address _to, uint256 _value) public {
728 	if (_to == address(this)) revert('if (_to == address(this))');
729 	BurnTokens(st.StakeTransferMNE(msg.sender, _to, _value));
730 	emit StakeTransfer(msg.sender, _to, _value); 
731 }
732 
733 function BurnGenesisAddresses(address[] memory _genesisAddressesToBurn) public
734 {
735 	gn.BurnGenesisAddresses(msg.sender, _genesisAddressesToBurn);
736 	uint i = 0;	
737 	while(i < _genesisAddressesToBurn.length)
738 	{
739 		emit Transfer(_genesisAddressesToBurn[i], 0x0000000000000000000000000000000000000000, balanceOf(_genesisAddressesToBurn[i]));
740 		i++;
741 	}
742 }
743 
744 function StakeTransferGenesis(address _to, uint256 _value, address[] memory _genesisAddressesToBurn) public {
745 	if (_to == address(this)) revert('if (_to == address(this))');
746 	uint i = 0;	
747 	while(i < _genesisAddressesToBurn.length)
748 	{
749 		emit Transfer(_genesisAddressesToBurn[i], 0x0000000000000000000000000000000000000000, balanceOf(_genesisAddressesToBurn[i]));
750 		i++;
751 	}
752 	st.StakeTransferGenesis(msg.sender, _to, _value, _genesisAddressesToBurn);	
753 	emit StakeTransfer(msg.sender, _to, _value); 
754 }
755 
756 function setBalanceStakes(address _address, uint256 balance) public {
757 	st.setBalanceStakes(msg.sender, _address, balance);
758 }
759 
760 function BuyGenesisLevel1FromNormal(address payable _address) public payable {
761 	uint256 feesToPayToSeller = gnb.BuyGenesisLevel1FromNormal(msg.sender, address(_address), msg.value);
762 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');	
763 	emit Transfer(_address, msg.sender, balanceOf(msg.sender));		
764 }
765 
766 function BuyGenesisLevel2FromNormal(address payable _address) public payable{
767 	uint256 feesToPayToSeller = gnb.BuyGenesisLevel2FromNormal(msg.sender, address(_address), msg.value);	
768 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');
769 	emit Transfer(_address, msg.sender, balanceOf(msg.sender));
770 }
771 
772 function BuyGenesisLevel3FromNormal(address payable _address) public payable{
773 	uint256 feesToPayToSeller = gnb.BuyGenesisLevel3FromNormal(msg.sender, address(_address), msg.value);	
774 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');	
775 	emit Transfer(_address, msg.sender, balanceOf(msg.sender));
776 }
777 
778 function BuyStakeMNE(address payable _address) public payable {
779 	uint256 balanceToSend = pc.stakeBalances(_address);
780 	(uint256 mneToBurn, uint256 feesToPayToSeller) = stb.BuyStakeMNE(msg.sender, address(_address), msg.value);
781 	BurnTokens(mneToBurn);
782 	if(!_address.send(feesToPayToSeller)) revert('(!_address.send(feesToPayToSeller))');	
783 	emit StakeTransfer(_address, msg.sender, balanceToSend); 
784 }
785 
786 function BuyStakeGenesis(address payable _address, address[] memory _genesisAddressesToBurn) public payable {
787 	uint256 balanceToSend = pc.stakeBalances(_address);
788 	uint i = 0;
789 	while(i < _genesisAddressesToBurn.length)
790 	{
791 		emit Transfer(_genesisAddressesToBurn[i], 0x0000000000000000000000000000000000000000, balanceOf(_genesisAddressesToBurn[i]));
792 		i++;
793 	}
794 	uint256 feesToPayToSeller = stb.BuyStakeGenesis(msg.sender, address(_address), _genesisAddressesToBurn, msg.value);
795 	if(!_address.send(feesToPayToSeller)) revert();		
796 	emit StakeTransfer(_address, msg.sender, balanceToSend); 
797 }
798 
799 function CreateToken() public payable {
800 	(uint256 _mneToBurn, address tokenAdderss) = tks.CreateToken(msg.sender, msg.value);
801 	BurnTokens(_mneToBurn);
802 	emit TokenCreation(msg.sender, tokenAdderss);
803 }
804 
805 function CreateTokenICO() public payable {
806 	(uint256 _mneToBurn, address tokenAdderss) = tks.CreateTokenICO(msg.sender, msg.value);
807 	BurnTokens(_mneToBurn);
808 	emit TokenCreationICO(msg.sender, tokenAdderss);
809 }
810 
811 function isAnyGenesisAddress(address _address) public view returns (bool success) {
812 	return gn.isAnyGenesisAddress(_address);
813 }
814 
815 function isGenesisAddressLevel1(address _address) public view returns (bool success) {
816 	return gn.isGenesisAddressLevel1(_address);
817 }
818 
819 function isGenesisAddressLevel2(address _address) public view returns (bool success) {
820 	return gn.isGenesisAddressLevel2(_address);
821 }
822 
823 function isGenesisAddressLevel3(address _address) public view returns (bool success) {
824 	return gn.isGenesisAddressLevel3(_address);
825 }
826 
827 function isGenesisAddressLevel2Or3(address _address) public view returns (bool success) {
828 	return gn.isGenesisAddressLevel2Or3(_address);
829 }
830 
831 function registerGenesisAddresses(address[] memory _addressList) public {
832 	uint i = 0;
833 	if (pc.setupRunning() && msg.sender == pc.genesisCallerAddress())
834 	{
835 		while(i < _addressList.length)
836 		{
837 			emit Transfer(address(this), _addressList[i], pc.genesisSupplyPerAddress());
838 			i++;
839 		}
840 	}
841 	else 
842 	{
843 		revert();
844 	}
845 }
846 
847 function ethFeeToUpgradeToLevel2Set(uint256 _ethFeeToUpgradeToLevel2) public {pc.ethFeeToUpgradeToLevel2Set(msg.sender, _ethFeeToUpgradeToLevel2);}
848 function ethFeeToUpgradeToLevel3Set(uint256 _ethFeeToUpgradeToLevel3) public {pc.ethFeeToUpgradeToLevel3Set(msg.sender, _ethFeeToUpgradeToLevel3);}
849 function ethFeeToBuyLevel1Set(uint256 _ethFeeToBuyLevel1) public {pc.ethFeeToBuyLevel1Set(msg.sender, _ethFeeToBuyLevel1);}
850 function ethFeeForSellerLevel1Set(uint256 _ethFeeForSellerLevel1) public {pc.ethFeeForSellerLevel1Set(msg.sender, _ethFeeForSellerLevel1);}
851 function ethFeeForTokenSet(uint256 _ethFeeForToken) public {pc.ethFeeForTokenSet(msg.sender, _ethFeeForToken);}
852 function ethFeeForTokenICOSet(uint256 _ethFeeForTokenICO) public {pc.ethFeeForTokenICOSet(msg.sender, _ethFeeForTokenICO);}
853 function ethPercentFeeGenesisExchangeSet(uint256 _ethPercentFeeGenesisExchange) public {pc.ethPercentFeeGenesisExchangeSet(msg.sender, _ethPercentFeeGenesisExchange);}
854 function ethPercentFeeNormalExchangeSet(uint256 _ethPercentFeeNormalExchange) public {pc.ethPercentFeeNormalExchangeSet(msg.sender, _ethPercentFeeNormalExchange);}
855 function ethPercentStakeExchangeSet(uint256 _ethPercentStakeExchange) public {pc.ethPercentStakeExchangeSet(msg.sender, _ethPercentStakeExchange);}
856 function amountOfGenesisToBuyStakesSet(uint256 _amountOfGenesisToBuyStakes) public {pc.amountOfGenesisToBuyStakesSet(msg.sender, _amountOfGenesisToBuyStakes);}
857 function amountOfMNEToBuyStakesSet(uint256 _amountOfMNEToBuyStakes) public {pc.amountOfMNEToBuyStakesSet(msg.sender, _amountOfMNEToBuyStakes);}
858 function amountOfMNEForTokenSet(uint256 _amountOfMNEForToken) public {pc.amountOfMNEForTokenSet(msg.sender, _amountOfMNEForToken);}
859 function amountOfMNEForTokenICOSet(uint256 _amountOfMNEForTokenICO) public {pc.amountOfMNEForTokenICOSet(msg.sender, _amountOfMNEForTokenICO);}
860 function amountOfMNEToTransferStakesSet(uint256 _amountOfMNEToTransferStakes) public {pc.amountOfMNEToTransferStakesSet(msg.sender, _amountOfMNEToTransferStakes);}
861 function amountOfGenesisToTransferStakesSet(uint256 _amountOfGenesisToTransferStakes) public {pc.amountOfGenesisToTransferStakesSet(msg.sender, _amountOfGenesisToTransferStakes);}
862 function stakeDecimalsSet(uint256 _stakeDecimals) public {pc.stakeDecimalsSet(msg.sender, _stakeDecimals);}
863 }