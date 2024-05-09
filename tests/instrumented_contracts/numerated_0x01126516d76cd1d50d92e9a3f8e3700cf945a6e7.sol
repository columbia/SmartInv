1 /*
2     xgr_deposits.sol
3     2.0.3
4     
5     Rajci 'iFA' Andor @ ifa@fusionwallet.io
6 */
7 pragma solidity 0.4.18;
8 
9 contract Owned {
10     /* Variables */
11     address public owner = msg.sender;
12     /* Externals */
13     function replaceOwner(address newOwner) external returns(bool success) {
14         require( isOwner() );
15         owner = newOwner;
16         return true;
17     }
18     /* Internals */
19     function isOwner() internal view returns(bool) {
20         return owner == msg.sender;
21     }
22     /* Modifiers */
23     modifier onlyForOwner {
24         require( isOwner() );
25         _;
26     }
27 }
28 
29 contract SafeMath {
30     /* Internals */
31     function safeAdd(uint256 a, uint256 b) internal pure returns(uint256) {
32         if ( b > 0 ) {
33             assert( a + b > a );
34         }
35         return a + b;
36     }
37     function safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
38         if ( b > 0 ) {
39             assert( a - b < a );
40         }
41         return a - b;
42     }
43     function safeMul(uint256 a, uint256 b) internal pure returns(uint256) {
44         uint256 c = a * b;
45         assert(a == 0 || c / a == b);
46         return c;
47     }
48     function safeDiv(uint256 a, uint256 b) internal pure returns(uint256) {
49         return a / b;
50     }
51 }
52 
53 contract TokenDB is SafeMath, Owned {
54     /*
55         This is just an abstract contract with the necessary functions
56     */
57     /* Structures */
58     /* Variables */
59     mapping(address => uint256) public balanceOf;
60     mapping(address => uint256) public lockedBalances;
61     address public tokenAddress;
62     address public depositsAddress;
63     /* Constructor */
64     /* Externals */
65     function openDeposit(address addr, uint256 amount, uint256 end, uint256 interestOnEnd,
66         uint256 interestBeforeEnd, uint256 interestFee, uint256 multiplier, bool closeable) external returns(bool success, uint256 DID) {}
67     function closeDeposit(uint256 DID) external returns (bool success) {}
68     /* Constants */
69     function getDeposit(uint256 UID) public constant returns(address addr, uint256 amount, uint256 start,
70         uint256 end, uint256 interestOnEnd, uint256 interestBeforeEnd, uint256 interestFee, uint256 interestMultiplier, bool closeable, bool valid) {}
71 }
72 
73 contract Token {
74     /*
75         This is just an abstract contract with the necessary functions
76     */
77     function mint(address owner, uint256 value) external returns (bool success) {}
78 }
79 
80 contract Deposits is Owned, SafeMath {
81     /* Structures */
82     struct depositTypes_s {
83         uint256 blockDelay;
84         uint256 baseFunds;
85         uint256 interestRateOnEnd;
86         uint256 interestRateBeforeEnd;
87         uint256 interestFee;
88         bool closeable;
89         bool valid;
90     }
91     struct deposits_s {
92         address addr;
93         uint256 amount;
94         uint256 start;
95         uint256 end;
96         uint256 interestOnEnd;
97         uint256 interestBeforeEnd;
98         uint256 interestFee;
99         uint256 interestMultiplier;
100         bool    closeable;
101         bool    valid;
102     }
103     /* Variables */
104     mapping(uint256 => depositTypes_s) public depositTypes;
105     uint256 public depositTypesCounter;
106     address public tokenAddress;
107     address public databaseAddress;
108     address public founderAddress;
109     uint256 public interestMultiplier = 1e3;
110     /* Constructor */
111     function Deposits(address TokenAddress, address DatabaseAddress, address FounderAddress) {
112         tokenAddress = TokenAddress;
113         databaseAddress = DatabaseAddress;
114         founderAddress = FounderAddress;
115     }
116     /* Externals */
117     function changeDataBaseAddress(address newDatabaseAddress) external onlyForOwner {
118         databaseAddress = newDatabaseAddress;
119     }
120     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
121         tokenAddress = newTokenAddress;
122     }
123     function changeFounderAddresss(address newFounderAddress) external onlyForOwner {
124         founderAddress = newFounderAddress;
125     }
126     function addDepositType(uint256 blockDelay, uint256 baseFunds, uint256 interestRateOnEnd,
127         uint256 interestRateBeforeEnd, uint256 interestFee, bool closeable) external onlyForOwner {
128         depositTypesCounter += 1;
129         uint256 DTID = depositTypesCounter;
130         depositTypes[DTID] = depositTypes_s(
131             blockDelay,
132             baseFunds,
133             interestRateOnEnd,
134             interestRateBeforeEnd,
135             interestFee,
136             closeable,
137             true
138         );
139         EventNewDepositType(
140             DTID,
141             blockDelay,
142             baseFunds,
143             interestRateOnEnd,
144             interestRateBeforeEnd,
145             interestFee,
146             interestMultiplier,
147             closeable
148         );
149     }
150     function rekoveDepositType(uint256 DTID) external onlyForOwner {
151         delete depositTypes[DTID].valid;
152         EventRevokeDepositType(DTID);
153     }
154     function placeDeposit(uint256 amount, uint256 depositType) external checkSelf {
155         require( depositTypes[depositType].valid );
156         require( depositTypes[depositType].baseFunds <= amount );
157         uint256 balance = TokenDB(databaseAddress).balanceOf(msg.sender);
158         uint256 locked = TokenDB(databaseAddress).lockedBalances(msg.sender);
159         require( safeSub(balance, locked) >= amount );
160         var (success, DID) = TokenDB(databaseAddress).openDeposit(
161             msg.sender,
162             amount,
163             safeAdd(block.number, depositTypes[depositType].blockDelay),
164             depositTypes[depositType].interestRateOnEnd,
165             depositTypes[depositType].interestRateBeforeEnd,
166             depositTypes[depositType].interestFee,
167             interestMultiplier,
168             depositTypes[depositType].closeable
169         );
170         require( success );
171         EventNewDeposit(DID, msg.sender);
172     }
173     function closeDeposit(address beneficary, uint256 DID) external checkSelf {
174         address _beneficary = beneficary;
175         if ( _beneficary == 0x00 ) {
176             _beneficary = msg.sender;
177         }
178         var (addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee,
179             interestM, closeable, valid) = TokenDB(databaseAddress).getDeposit(DID);
180         _closeDeposit(_beneficary, DID, deposits_s(addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee, interestM, closeable, valid));
181     }
182     /* Internals */
183     function _closeDeposit(address beneficary, uint256 DID, deposits_s data) internal {
184         require( data.valid && data.addr == msg.sender );
185         var (interest, interestFee) = _calculateInterest(data);
186         if ( interest > 0 ) {
187             require( Token(tokenAddress).mint(beneficary, interest) );
188         }
189         if ( interestFee > 0 ) {
190             require( Token(tokenAddress).mint(founderAddress, interestFee) );
191         }
192         require( TokenDB(databaseAddress).closeDeposit(DID) );
193         EventDepositClosed(DID, msg.sender, beneficary, interest, interestFee);
194     }
195     function _calculateInterest(deposits_s data) internal view returns (uint256 interest, uint256 interestFee) {
196         if ( ! data.valid || data.amount <= 0 || data.end <= data.start || block.number <= data.start ) { return (0, 0); }
197         uint256 rate;
198         uint256 delay;
199         if ( data.end <= block.number ) {
200             rate = data.interestOnEnd;
201             delay = safeSub(data.end, data.start);
202         } else {
203             require( data.closeable );
204             rate = data.interestBeforeEnd;
205             delay = safeSub(block.number, data.start);
206         }
207         if ( rate == 0 ) { return (0, 0); }
208         interest = safeDiv(safeMul(safeDiv(safeDiv(safeMul(data.amount, rate), 100), data.interestMultiplier), delay), safeSub(data.end, data.start));
209         if ( data.interestFee > 0 && interest > 0) {
210             interestFee = safeDiv(safeDiv(safeMul(interest, data.interestFee), 100), data.interestMultiplier);
211         }
212         if ( interestFee > 0 ) {
213             interest = safeSub(interest, interestFee);
214         }
215     }
216     /* Constants */
217     function calculateInterest(uint256 DID) public view returns(uint256, uint256) {
218         var (addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee,
219             interestM, closeable, valid) = TokenDB(databaseAddress).getDeposit(DID);
220         return _calculateInterest(deposits_s(addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee, interestM, closeable, valid));
221     }
222     /* Modifiers */
223     modifier checkSelf {
224         require( TokenDB(databaseAddress).tokenAddress() == tokenAddress );
225         require( TokenDB(databaseAddress).depositsAddress() == address(this) );
226         _;
227     }
228     /* Events */
229     event EventNewDepositType(uint256 indexed DTID, uint256 blockDelay, uint256 baseFunds,
230         uint256 interestRateOnEnd, uint256 interestRateBeforeEnd, uint256 interestFee, uint256 interestMultiplier, bool closeable);
231     event EventRevokeDepositType(uint256 indexed DTID);
232     event EventNewDeposit(uint256 indexed DID, address owner);
233     event EventDepositClosed(uint256 indexed DID, address owner, address beneficary, uint256 interest, uint256 interestFee);
234 }