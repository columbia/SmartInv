1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 library Errors {
5     /**
6      * @dev Zero address specified
7      */
8     error ZeroAddress();
9 
10     /**
11      * @dev Zero amount specified
12      */
13     error ZeroAmount();
14 
15     /**
16      * @dev Invalid fee specified
17      */
18     error InvalidFee();
19 
20     /**
21      * @dev Invalid max fee specified
22      */
23     error InvalidMaxFee();
24 
25     /**
26      * @dev Zero multiplier used
27      */
28     error ZeroMultiplier();
29 
30     /**
31      * @dev ETH deposit is paused
32      */
33     error DepositingEtherPaused();
34 
35     /**
36      * @dev ETH deposit is not paused
37      */
38     error DepositingEtherNotPaused();
39 
40     /**
41      * @dev Contract is paused
42      */
43     error Paused();
44 
45     /**
46      * @dev Contract is not paused
47      */
48     error NotPaused();
49 
50     /**
51      * @dev Validator not yet dissolved
52      */
53     error NotDissolved();
54 
55     /**
56      * @dev Validator not yet withdrawable
57      */
58     error NotWithdrawable();
59 
60     /**
61      * @dev Validator has been previously used before
62      */
63     error NoUsedValidator();
64 
65     /**
66      * @dev Not oracle adapter
67      */
68     error NotOracleAdapter();
69 
70     /**
71      * @dev Not reward recipient
72      */
73     error NotRewardRecipient();
74 
75     /**
76      * @dev Exceeding max value
77      */
78     error ExceedsMax();
79 
80     /**
81      * @dev No rewards available
82      */
83     error NoRewards();
84 
85     /**
86      * @dev Not PirexEth
87      */
88     error NotPirexEth();
89 
90     /**
91      * @dev Not minter
92      */
93     error NotMinter();
94 
95     /**
96      * @dev Not burner
97      */
98     error NotBurner();
99 
100     /**
101      * @dev Empty string
102      */
103     error EmptyString();
104 
105     /**
106      * @dev Validator is Not Staking
107      */
108     error ValidatorNotStaking();
109 
110     /**
111      * @dev not enough buffer
112      */
113     error NotEnoughBuffer();
114 
115     /**
116      * @dev validator queue empty
117      */
118     error ValidatorQueueEmpty();
119 
120     /**
121      * @dev out of bounds
122      */
123     error OutOfBounds();
124 
125     /**
126      * @dev cannot trigger validator exit
127      */
128     error NoValidatorExit();
129 
130     /**
131      * @dev cannot initiate redemption partially
132      */
133     error NoPartialInitiateRedemption();
134 
135     /**
136      * @dev not enough validators
137      */
138     error NotEnoughValidators();
139 
140     /**
141      * @dev not enough ETH
142      */
143     error NotEnoughETH();
144 
145     /**
146      * @dev max processed count is invalid (< 1)
147      */
148     error InvalidMaxProcessedCount();
149 
150     /**
151      * @dev fromIndex and toIndex are invalid
152      */
153     error InvalidIndexRanges();
154 
155     /**
156      * @dev ETH is not allowed
157      */
158     error NoETHAllowed();
159 
160     /**
161      * @dev ETH is not passed
162      */
163     error NoETH();
164 
165     /**
166      * @dev validator status is neither dissolved nor slashed
167      */
168     error StatusNotDissolvedOrSlashed();
169 
170     /**
171      * @dev validator status is neither withdrawable nor staking
172      */
173     error StatusNotWithdrawableOrStaking();
174 
175     /**
176      * @dev account is not approved
177      */
178     error AccountNotApproved();
179 
180     /**
181      * @dev invalid token specified
182      */
183     error InvalidToken();
184 
185     /**
186      * @dev not same as deposit size
187      */
188     error InvalidAmount();
189 
190     /**
191      * @dev contract not recognised
192      */
193     error UnrecorgnisedContract();
194 
195     /**
196      * @dev empty array
197      */
198     error EmptyArray();
199 
200     /**
201      * @dev arrays length mismatch
202      */
203     error MismatchedArrayLengths();
204 }
