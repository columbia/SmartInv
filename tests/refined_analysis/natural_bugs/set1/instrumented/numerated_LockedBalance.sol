1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title Library that handles locked balances efficiently using bit packing.
7  */
8 library LockedBalance {
9   /// @dev Tracks an account's total lockup per expiration time.
10   struct Lockup {
11     uint32 expiration;
12     uint96 totalAmount;
13   }
14 
15   struct Lockups {
16     /// @dev Mapping from key to lockups.
17     /// i) A key represents 2 lockups. The key for a lockup is `index / 2`.
18     ///     For instance, elements with index 25 and 24 would map to the same key.
19     /// ii) The `value` for the `key` is split into two 128bits which are used to store the metadata for a lockup.
20     mapping(uint256 => uint256) lockups;
21   }
22 
23   // Masks used to split a uint256 into two equal pieces which represent two individual Lockups.
24   uint256 private constant last128BitsMask = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
25   uint256 private constant first128BitsMask = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000;
26 
27   // Masks used to retrieve or set the totalAmount value of a single Lockup.
28   uint256 private constant firstAmountBitsMask = 0xFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
29   uint256 private constant secondAmountBitsMask = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000;
30 
31   /**
32    * @notice Clears the lockup at the index.
33    */
34   function del(Lockups storage lockups, uint256 index) internal {
35     unchecked {
36       if (index % 2 == 0) {
37         index /= 2;
38         lockups.lockups[index] = (lockups.lockups[index] & last128BitsMask);
39       } else {
40         index /= 2;
41         lockups.lockups[index] = (lockups.lockups[index] & first128BitsMask);
42       }
43     }
44   }
45 
46   /**
47    * @notice Sets the Lockup at the provided index.
48    */
49   function set(
50     Lockups storage lockups,
51     uint256 index,
52     uint256 expiration,
53     uint256 totalAmount
54   ) internal {
55     unchecked {
56       uint256 lockedBalanceBits = totalAmount | (expiration << 96);
57       if (index % 2 == 0) {
58         // set first 128 bits.
59         index /= 2;
60         lockups.lockups[index] = (lockups.lockups[index] & last128BitsMask) | (lockedBalanceBits << 128);
61       } else {
62         // set last 128 bits.
63         index /= 2;
64         lockups.lockups[index] = (lockups.lockups[index] & first128BitsMask) | lockedBalanceBits;
65       }
66     }
67   }
68 
69   /**
70    * @notice Sets only the totalAmount for a lockup at the index.
71    */
72   function setTotalAmount(
73     Lockups storage lockups,
74     uint256 index,
75     uint256 totalAmount
76   ) internal {
77     unchecked {
78       if (index % 2 == 0) {
79         index /= 2;
80         lockups.lockups[index] = (lockups.lockups[index] & firstAmountBitsMask) | (totalAmount << 128);
81       } else {
82         index /= 2;
83         lockups.lockups[index] = (lockups.lockups[index] & secondAmountBitsMask) | totalAmount;
84       }
85     }
86   }
87 
88   /**
89    * @notice Returns the Lockup at the provided index.
90    * @dev To get the lockup stored in the *first* 128 bits (first slot/lockup):
91    *       - we remove the last 128 bits (done by >> 128)
92    *      To get the lockup stored in the *last* 128 bits (second slot/lockup):
93    *       - we take the last 128 bits (done by % (2**128))
94    *      Once the lockup is obtained:
95    *       - get `expiration` by peaking at the first 32 bits (done by >> 96)
96    *       - get `totalAmount` by peaking at the last 96 bits (done by % (2**96))
97    */
98   function get(Lockups storage lockups, uint256 index) internal view returns (Lockup memory balance) {
99     unchecked {
100       uint256 lockupMetadata = lockups.lockups[index / 2];
101       if (lockupMetadata == 0) {
102         return balance;
103       }
104       uint128 lockedBalanceBits;
105       if (index % 2 == 0) {
106         // use first 128 bits.
107         lockedBalanceBits = uint128(lockupMetadata >> 128);
108       } else {
109         // use last 128 bits.
110         lockedBalanceBits = uint128(lockupMetadata % (2**128));
111       }
112       // unpack the bits to retrieve the Lockup.
113       balance.expiration = uint32(lockedBalanceBits >> 96);
114       balance.totalAmount = uint96(lockedBalanceBits % (2**96));
115     }
116   }
117 }
