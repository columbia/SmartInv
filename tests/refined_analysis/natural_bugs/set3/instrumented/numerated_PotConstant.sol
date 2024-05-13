1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 library PotConstant {
5     enum PotState {
6         Opened,
7         Closed,
8         Cooked
9     }
10 
11     struct PotInfo {
12         uint potId;
13         PotState state;
14         uint supplyCurrent;
15         uint supplyDonation;
16         uint supplyInUSD;
17         uint rewards;
18         uint rewardsInUSD;
19         uint minAmount;
20         uint maxAmount;
21         uint avgOdds;
22         uint startedAt;
23     }
24 
25     struct PotInfoMe {
26         uint wTime;
27         uint wCount;
28         uint wValue;
29         uint odds;
30         uint available;
31         uint lastParticipatedPot;
32         uint depositedAt;
33     }
34 
35     struct PotHistory {
36         uint potId;
37         uint users;
38         uint rewardPerWinner;
39         uint date;
40         address[] winners;
41     }
42 }
