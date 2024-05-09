1 pragma solidity 0.4.19;
2 
3 /*
4  * Aethia egg giveaway.
5  *
6  * Every day, for a period of seven days, starting February 2nd 12:00:00 UTC,
7  * this contract is allowed to distribute a maximum of one-hundred-and-twenty
8  * (120) common Ethergotchi eggs, for a total of 820 eggs.
9  *
10  * These 120 eggs are divided over the four (4) slots of six (6) hours that
11  * make up each day. Every six hours, thirty (30) common Ethergotchi eggs are
12  * available for free (excluding the gas cost of a transaction).
13  *
14  * Eggs that remain at the end of a time slot are not transferred to the next
15  * time slot.
16  */
17 contract EggGiveaway {
18 
19     /*
20      * The start and end dates respectively convert to the following
21      * timestamps:
22      *  START_DATE  => February 2nd, 12:00:00 UTC
23      *  END_DATE    => February 9th, 11:59:59 UTC
24      */
25     uint256 constant START_DATE = 1517572800;
26     uint256 constant END_DATE = 1518177600;
27 
28     /*
29      * The amount of seconds within a single time slot.
30      *
31      * This is set to a total of six hours:
32      *      6 x 60 x 60 = 21600
33      */
34     uint16 constant SLOT_DURATION_IN_SECONDS = 21600;
35 
36     /*
37      * Remaining free eggs per time slot.
38      *
39      * The structure is as follows:
40      * {
41      *  0   => 30,  February 2nd, 12:00:00 UTC until February 2nd, 17:59:59 UTC
42      *  1   => 30,  February 2nd, 18:00:00 UTC until February 2nd, 23:59:59 UTC
43      *  2   => 30,  February 3rd, 00:00:00 UTC until February 3rd, 05:59:59 UTC
44      *  3   => 30,  February 3rd, 06:00:00 UTC until February 3rd, 11:59:59 UTC
45      *  4   => 30,  February 3rd, 12:00:00 UTC until February 3rd, 17:59:59 UTC
46      *  5   => 30,  February 3rd, 18:00:00 UTC until February 3rd, 23:59:59 UTC
47      *  6   => 30,  February 4th, 00:00:00 UTC until February 4th, 05:59:59 UTC
48      *  7   => 30,  February 4th, 06:00:00 UTC until February 4th, 11:59:59 UTC
49      *  8   => 30,  February 4th, 12:00:00 UTC until February 4th, 17:59:59 UTC
50      *  9   => 30,  February 4th, 18:00:00 UTC until February 4th, 23:59:59 UTC
51      *  10  => 30,  February 5th, 00:00:00 UTC until February 5th, 05:59:59 UTC
52      *  11  => 30,  February 5th, 06:00:00 UTC until February 5th, 11:59:59 UTC
53      *  12  => 30,  February 5th, 12:00:00 UTC until February 5th, 17:59:59 UTC
54      *  13  => 30,  February 5th, 18:00:00 UTC until February 5th, 23:59:59 UTC
55      *  14  => 30,  February 6th, 00:00:00 UTC until February 6th, 05:59:59 UTC
56      *  15  => 30,  February 6th, 06:00:00 UTC until February 6th, 11:59:59 UTC
57      *  16  => 30,  February 6th, 12:00:00 UTC until February 6th, 17:59:59 UTC
58      *  17  => 30,  February 6th, 18:00:00 UTC until February 6th, 23:59:59 UTC
59      *  18  => 30,  February 7th, 00:00:00 UTC until February 7th, 05:59:59 UTC
60      *  19  => 30,  February 7th, 06:00:00 UTC until February 7th, 11:59:59 UTC
61      *  20  => 30,  February 7th, 12:00:00 UTC until February 7th, 17:59:59 UTC
62      *  21  => 30,  February 7th, 18:00:00 UTC until February 7th, 23:59:59 UTC
63      *  22  => 30,  February 8th, 00:00:00 UTC until February 8th, 05:59:59 UTC
64      *  23  => 30,  February 8th, 06:00:00 UTC until February 8th, 11:59:59 UTC
65      *  24  => 30,  February 8th, 12:00:00 UTC until February 8th, 17:59:59 UTC
66      *  25  => 30,  February 8th, 18:00:00 UTC until February 8th, 23:59:59 UTC
67      *  26  => 30,  February 9th, 00:00:00 UTC until February 8th, 05:59:59 UTC
68      *  27  => 30,  February 9th, 06:00:00 UTC until February 8th, 11:59:59 UTC
69      * }
70      */
71     mapping (uint8 => uint8) remainingFreeEggs;
72 
73     /*
74      * Egg owners
75      *
76      * This is a mapping containing all owners of free eggs. While this does
77      * not prevent people from using multiple addresses to acquire multiple
78      * eggs, it does increase the difficulty slightly.
79      */
80     mapping (address => bool) eggOwners;
81 
82     /*
83      * Store egg retrieval event on the blockchain.
84      *
85      * For audit and logging purposes, all acquisitions of Ethergotchi eggs are
86      * logged by acquirer and acquisition date.
87      */
88     event LogEggAcquisition(address indexed _acquirer, uint256 indexed _date);
89 
90     /*
91      * The contract constructor.
92      * 
93      * This generates all available free eggs per time slot by calculating the
94      * total amount of seconds within the entire giveaway period, and the number
95      * of time slots within this period.
96      *
97      * Each time slot is then assigned thirty (30) eggs.
98      */
99     function EggGiveaway() public {
100         uint256 secondsInGiveawayPeriod = END_DATE - START_DATE;
101         uint8 timeSlotCount = uint8(
102             secondsInGiveawayPeriod / SLOT_DURATION_IN_SECONDS
103         );
104 
105         for (uint8 i = 0; i < timeSlotCount; i++) {
106             remainingFreeEggs[i] = 30;
107         }
108     }
109 
110     /*
111      * Acquire free egg from the egg giveaway contract.
112      *
113      * To acquire an egg, a few conditions have to be met:
114      *  1. The sender is not allowed to send Ether. The game is free to play.
115      *  2. The transaction must occur within the giveaway period, as specified
116      *     at the top of this file.
117      *  3. The sender must not already have acquired a free egg.
118      *  4. There must be an availability of at least one (1) for the time slot
119      *     the transaction occurs in.
120      */
121     function acquireFreeEgg() payable external {
122         require(msg.value == 0);
123         require(START_DATE <= now && now < END_DATE);
124         require(eggOwners[msg.sender] == false);
125 
126         uint8 currentTimeSlot = getTimeSlot(now);
127 
128         require(remainingFreeEggs[currentTimeSlot] > 0);
129 
130         remainingFreeEggs[currentTimeSlot] -= 1;
131         eggOwners[msg.sender] = true;
132 
133         LogEggAcquisition(msg.sender, now);
134     }
135 
136     /*
137      * Fallback payable method.
138      *
139      * This is in the case someone calls the contract without specifying the
140      * correct method to call. This method will ensure the failure of a
141      * transaction that was wrongfully executed.
142      */
143     function () payable external {
144         revert();
145     }
146 
147     /*
148      * Calculates the time slot corresponding to the given UNIX timestamp.
149      *
150      * The time slot is calculated by subtracting the current date and time in
151      * seconds from the contract starting date and time in seconds. This is then
152      * divided by the number of seconds within a time slot, and floored, to get
153      * the correct time slot.
154      */
155     function getTimeSlot(uint256 _timestamp) private pure returns (uint8) {
156         uint256 secondsSinceGiveawayStart = _timestamp - START_DATE;
157         
158         return uint8(secondsSinceGiveawayStart / SLOT_DURATION_IN_SECONDS);
159     }
160 }