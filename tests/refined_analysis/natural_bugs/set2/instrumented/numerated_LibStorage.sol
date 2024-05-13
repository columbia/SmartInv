1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "./Types.sol";
6 import "./Constants.sol";
7 
8 library LibStorage {
9 
10     /// @dev Offset for the initial slot in lib storage, gives us this number of storage slots
11     /// available in StorageLayoutV1 and all subsequent storage layouts that inherit from it.
12     uint256 private constant STORAGE_SLOT_BASE = 1000000;
13     /// @dev Set to MAX_TRADED_MARKET_INDEX * 2, Solidity does not allow assigning constants from imported values
14     uint256 private constant NUM_NTOKEN_MARKET_FACTORS = 14;
15     /// @dev Theoretical maximum for MAX_PORTFOLIO_ASSETS, however, we limit this to MAX_TRADED_MARKET_INDEX
16     /// in practice. It is possible to exceed that value during liquidation up to 14 potential assets.
17     uint256 private constant MAX_PORTFOLIO_ASSETS = 16;
18 
19     /// @dev Storage IDs for storage buckets. Each id maps to an internal storage
20     /// slot used for a particular mapping
21     ///     WARNING: APPEND ONLY
22     enum StorageId {
23         Unused,
24         AccountStorage,
25         nTokenContext,
26         nTokenAddress,
27         nTokenDeposit,
28         nTokenInitialization,
29         Balance,
30         Token,
31         SettlementRate,
32         CashGroup,
33         Market,
34         AssetsBitmap,
35         ifCashBitmap,
36         PortfolioArray,
37         nTokenTotalSupply,
38         AssetRate,
39         ExchangeRate
40     }
41 
42     /// @dev Mapping from account to currencyId to it's balance storage for that currency
43     function getBalanceStorage() internal pure
44         returns (mapping(address => mapping(uint256 => BalanceStorage)) storage store)
45     {
46         uint256 slot = _getStorageSlot(StorageId.Balance);
47         assembly { store.slot := slot }
48     }
49 
50     /// @dev Mapping from currency id to a boolean for underlying or asset token to
51     /// the TokenStorage
52     function getTokenStorage() internal pure
53         returns (mapping(uint256 => mapping(bool => TokenStorage)) storage store)
54     {
55         uint256 slot = _getStorageSlot(StorageId.Token);
56         assembly { store.slot := slot }
57     }
58 
59     /// @dev Get the storage slot given a storage ID.
60     /// @param storageId An entry in `StorageId`
61     /// @return slot The storage slot.
62     function _getStorageSlot(StorageId storageId)
63         private
64         pure
65         returns (uint256 slot)
66     {
67         // This should never overflow with a reasonable `STORAGE_SLOT_EXP`
68         // because Solidity will do a range check on `storageId` during the cast.
69         return uint256(storageId) + STORAGE_SLOT_BASE;
70     }
71 } 