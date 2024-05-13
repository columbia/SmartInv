1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 interface IRevest {
6     event FNFTTimeLockMinted(
7         address indexed asset,
8         address indexed from,
9         uint indexed fnftId,
10         uint endTime,
11         uint[] quantities,
12         FNFTConfig fnftConfig
13     );
14 
15     event FNFTValueLockMinted(
16         address indexed primaryAsset,
17         address indexed from,
18         uint indexed fnftId,
19         address compareTo,
20         address oracleDispatch,
21         uint[] quantities,
22         FNFTConfig fnftConfig
23     );
24 
25     event FNFTAddressLockMinted(
26         address indexed asset,
27         address indexed from,
28         uint indexed fnftId,
29         address trigger,
30         uint[] quantities,
31         FNFTConfig fnftConfig
32     );
33 
34     event FNFTWithdrawn(
35         address indexed from,
36         uint indexed fnftId,
37         uint indexed quantity
38     );
39 
40     event FNFTSplit(
41         address indexed from,
42         uint[] indexed newFNFTId,
43         uint[] indexed proportions,
44         uint quantity
45     );
46 
47     event FNFTUnlocked(
48         address indexed from,
49         uint indexed fnftId
50     );
51 
52     event FNFTMaturityExtended(
53         address indexed from,
54         uint indexed fnftId,
55         uint indexed newExtendedTime
56     );
57 
58     event FNFTAddionalDeposited(
59         address indexed from,
60         uint indexed newFNFTId,
61         uint indexed quantity,
62         uint amount
63     );
64 
65     struct FNFTConfig {
66         address asset; // The token being stored
67         address pipeToContract; // Indicates if FNFT will pipe to another contract
68         uint depositAmount; // How many tokens
69         uint depositMul; // Deposit multiplier
70         uint split; // Number of splits remaining
71         uint depositStopTime; //
72         bool maturityExtension; // Maturity extensions remaining
73         bool isMulti; //
74         bool nontransferrable; // False by default (transferrable) //
75     }
76 
77     // Refers to the global balance for an ERC20, encompassing possibly many FNFTs
78     struct TokenTracker {
79         uint lastBalance;
80         uint lastMul;
81     }
82 
83     enum LockType {
84         DoesNotExist,
85         TimeLock,
86         ValueLock,
87         AddressLock
88     }
89 
90     struct LockParam {
91         address addressLock;
92         uint timeLockExpiry;
93         LockType lockType;
94         ValueLock valueLock;
95     }
96 
97     struct Lock {
98         address addressLock;
99         LockType lockType;
100         ValueLock valueLock;
101         uint timeLockExpiry;
102         uint creationTime;
103         bool unlocked;
104     }
105 
106     struct ValueLock {
107         address asset;
108         address compareTo;
109         address oracle;
110         uint unlockValue;
111         bool unlockRisingEdge;
112     }
113 
114     function mintTimeLock(
115         uint endTime,
116         address[] memory recipients,
117         uint[] memory quantities,
118         IRevest.FNFTConfig memory fnftConfig
119     ) external payable returns (uint);
120 
121     function mintValueLock(
122         address primaryAsset,
123         address compareTo,
124         uint unlockValue,
125         bool unlockRisingEdge,
126         address oracleDispatch,
127         address[] memory recipients,
128         uint[] memory quantities,
129         IRevest.FNFTConfig memory fnftConfig
130     ) external payable returns (uint);
131 
132     function mintAddressLock(
133         address trigger,
134         bytes memory arguments,
135         address[] memory recipients,
136         uint[] memory quantities,
137         IRevest.FNFTConfig memory fnftConfig
138     ) external payable returns (uint);
139 
140     function withdrawFNFT(uint tokenUID, uint quantity) external;
141 
142     function unlockFNFT(uint tokenUID) external;
143 
144     function splitFNFT(
145         uint fnftId,
146         uint[] memory proportions,
147         uint quantity
148     ) external returns (uint[] memory newFNFTIds);
149 
150     function depositAdditionalToFNFT(
151         uint fnftId,
152         uint amount,
153         uint quantity
154     ) external returns (uint);
155 
156     function setFlatWeiFee(uint wethFee) external;
157 
158     function setERC20Fee(uint erc20) external;
159 
160     function getFlatWeiFee() external returns (uint);
161 
162     function getERC20Fee() external returns (uint);
163 
164 
165 }
