1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
6 import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
7 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
8 import "./interfaces/IRevest.sol";
9 import "./interfaces/ILockManager.sol";
10 import "./interfaces/IOracleDispatch.sol";
11 import "./lib/uniswap/IUniswapV2Pair.sol";
12 import "./utils/RevestAccessControl.sol";
13 import "./interfaces/IAddressLock.sol";
14 import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
15 
16 
17 contract LockManager is ILockManager, ReentrancyGuard, AccessControlEnumerable, RevestAccessControl {
18 
19     using ERC165Checker for address;
20 
21     bytes4 public constant ADDRESS_LOCK_INTERFACE_ID = type(IAddressLock).interfaceId;
22     uint public numLocks = 0; // We increment this to get the lockId for each new lock created
23     mapping(uint => uint) public override fnftIdToLockId;
24     mapping(uint => IRevest.Lock) public locks; // maps lockId to locks
25 
26     constructor(address provider) RevestAccessControl(provider) {}
27 
28     /**
29      * We access all lock properties by calling this method and then extracting data from the underlying struct
30      * No need to write specialized getters for each portion
31      */
32     function fnftIdToLock(uint fnftId) public view override returns (IRevest.Lock memory) {
33         return locks[fnftIdToLockId[fnftId]];
34     }
35 
36     function getLock(uint lockId) external view override returns (IRevest.Lock memory) {
37         return locks[lockId];
38     }
39 
40     /**
41      * Use this when splitting an FNFT so both parts can point to the same lock without creating new ones.
42      */
43     function pointFNFTToLock(uint fnftId, uint lockId) external override onlyRevest {
44         fnftIdToLockId[fnftId] = lockId;
45     }
46 
47     function createLock(uint fnftId, IRevest.LockParam memory lock) external override onlyRevest returns (uint) {
48         // Extensive validation on creation
49         require(lock.lockType != IRevest.LockType.DoesNotExist, "E058");
50         IRevest.Lock storage newLock = locks[numLocks];
51         newLock.lockType = lock.lockType;
52         newLock.creationTime = block.timestamp;
53         if(lock.lockType == IRevest.LockType.TimeLock) {
54             require(lock.timeLockExpiry > block.timestamp, "E002");
55             newLock.timeLockExpiry = lock.timeLockExpiry;
56         }
57         else if (lock.lockType == IRevest.LockType.ValueLock) {
58             require(lock.valueLock.unlockValue > 0, "E003");
59             require(lock.valueLock.compareTo != address(0) && lock.valueLock.asset != address(0), "E004");
60             // Begin validation code to ensure this is actually keyed to a proper oracle
61             IOracleDispatch oracle = IOracleDispatch(lock.valueLock.oracle);
62             bool oraclePresent = oracle.getPairHasOracle(lock.valueLock.asset, lock.valueLock.compareTo);
63             // If the oracle is not present, attempt to initialize it
64             if(!oraclePresent && oracle.oracleNeedsInitialization(lock.valueLock.asset, lock.valueLock.compareTo)) {
65                 oraclePresent = oracle.initializeOracle(lock.valueLock.asset, lock.valueLock.compareTo);
66             }
67             require(oraclePresent, "E049");
68             newLock.valueLock = lock.valueLock;
69         }
70         else if (lock.lockType == IRevest.LockType.AddressLock) {
71             require(lock.addressLock != address(0), "E004");
72             newLock.addressLock = lock.addressLock;
73         }
74         else {
75             require(false, "Invalid type");
76         }
77         fnftIdToLockId[fnftId] = numLocks;
78         numLocks += 1;
79         return numLocks - 1;
80     }
81 
82     /**
83      * @dev Sets the maturity of an address or value lock to mature – can only be called from main contract
84      * if address, only if it is called by the address given permissions to
85      * if value, only if value is correct for unlocking
86      * lockId - the ID of the FNFT to unlock
87      * @return true if the caller is valid and the lock has been unlocked, false otherwise
88      */
89     function unlockFNFT(uint fnftId, address sender) external override onlyRevestController returns (bool) {
90         uint lockId = fnftIdToLockId[fnftId];
91         IRevest.Lock storage lock = locks[lockId];
92         IRevest.LockType typeLock = lock.lockType;
93         if (typeLock == IRevest.LockType.TimeLock) {
94             if(!lock.unlocked && lock.timeLockExpiry <= block.timestamp) {
95                 lock.unlocked = true;
96                 lock.timeLockExpiry = 0;
97             }
98         }
99         else if (typeLock == IRevest.LockType.ValueLock) {
100             bool unlockState;
101             address oracleAdd = lock.valueLock.oracle;
102             if(getLockMaturity(fnftId)) {
103                 unlockState = true;
104             } else {
105                 IOracleDispatch oracle = IOracleDispatch(oracleAdd);
106                 unlockState = oracle.updateOracle(lock.valueLock.asset, lock.valueLock.compareTo) &&
107                                 getLockMaturity(fnftId);
108             }
109             if(unlockState && oracleAdd != address(0)) {
110                 lock.unlocked = true;
111                 lock.valueLock.oracle = address(0);
112                 lock.valueLock.asset = address(0);
113                 lock.valueLock.compareTo = address(0);
114                 lock.valueLock.unlockValue = 0;
115                 lock.valueLock.unlockRisingEdge = false;
116             }
117 
118         }
119         else if (typeLock == IRevest.LockType.AddressLock) {
120             address addLock = lock.addressLock;
121             if (!lock.unlocked && (sender == addLock ||
122                     (addLock.supportsInterface(ADDRESS_LOCK_INTERFACE_ID) && IAddressLock(addLock).isUnlockable(fnftId, lockId)))
123                 ) {
124                 lock.unlocked = true;
125                 lock.addressLock = address(0);
126             }
127         }
128         return lock.unlocked;
129     }
130 
131     /**
132      * Return whether a lock of any type is mature. Use this for all locktypes.
133      */
134     function getLockMaturity(uint fnftId) public view override returns (bool) {
135         IRevest.Lock memory lock = locks[fnftIdToLockId[fnftId]];
136         if (lock.lockType == IRevest.LockType.TimeLock) {
137             return lock.unlocked || lock.timeLockExpiry < block.timestamp;
138         }
139         else if (lock.lockType == IRevest.LockType.ValueLock) {
140             return lock.unlocked || getValueLockMaturity(fnftId);
141         }
142         else if (lock.lockType == IRevest.LockType.AddressLock) {
143             return lock.unlocked || (lock.addressLock.supportsInterface(ADDRESS_LOCK_INTERFACE_ID) &&
144                                         IAddressLock(lock.addressLock).isUnlockable(fnftId, fnftIdToLockId[fnftId]));
145         }
146         else {
147             revert("E050");
148         }
149     }
150 
151     function lockTypes(uint tokenId) external view override returns (IRevest.LockType) {
152         return fnftIdToLock(tokenId).lockType;
153     }
154 
155     // Should only read whether the current state is mature based on oracle calls and unlock lists
156     // If oracle update tells us that it remains immature, we revert everything
157     function getValueLockMaturity(uint fnftId) internal view returns (bool) {
158         IRevest.Lock memory lock = fnftIdToLock(fnftId);
159         IOracleDispatch oracle = IOracleDispatch(lock.valueLock.oracle);
160 
161         uint currentValue = oracle.getValueOfAsset(lock.valueLock.asset, lock.valueLock.compareTo, lock.valueLock.unlockRisingEdge);
162         // Perform comparison
163 
164         if (lock.valueLock.unlockRisingEdge) {
165             return currentValue >= lock.valueLock.unlockValue;
166         } else {
167             // Only mature if current value less than unlock value
168             return currentValue < lock.valueLock.unlockValue;
169         }
170     }
171 
172 }
