1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8     /**
9     * @dev constructor
10     */
11     function SafeMath() public {
12     }
13 
14     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a / b;
22         return c;
23     }
24 
25     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(a >= b);
27         return a - b;
28     }
29 
30     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51     * account.
52     */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     /**
58     * @dev Throws if called by any account other than the owner.
59     */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66     * @dev Allows the current owner to transfer control of the contract to a newOwner.
67     * @param _newOwner The address to transfer ownership to.
68     */
69     function transferOwnership(address _newOwner) public onlyOwner {
70         require(_newOwner != owner);
71         newOwner = _newOwner;
72     }
73 
74     /**
75     * @dev confirm ownership by a new owner
76     */
77     function confirmOwnership() public {
78         require(msg.sender == newOwner);
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = 0x0;
82     }
83 }
84 
85 /**
86  * @title Pausable
87  * @dev Base contract which allows children to implement an emergency stop mechanism.
88  */
89 contract Pausable is Ownable {
90     event Pause();
91     event Unpause();
92 
93     bool public paused = false;
94 
95 
96     /**
97      * @dev Modifier to make a function callable only when the contract is not paused.
98      */
99     modifier whenNotPaused() {
100         require(!paused);
101         _;
102     }
103 
104     /**
105      * @dev Modifier to make a function callable only when the contract is paused.
106      */
107     modifier whenPaused() {
108         require(paused);
109         _;
110     }
111 
112     /**
113      * @dev called by the owner to pause, triggers stopped state
114      */
115     function pause() onlyOwner whenNotPaused public {
116         paused = true;
117         Pause();
118     }
119 
120     /**
121      * @dev called by the owner to unpause, returns to normal state
122      */
123     function unpause() onlyOwner whenPaused public {
124         paused = false;
125         Unpause();
126     }
127 }
128 
129 contract TheAbyssCrowdsale is Ownable, SafeMath, Pausable {
130     mapping (address => uint256) public balances;
131 
132     uint256 public constant TOKEN_PRICE_NUM = 2500;
133     uint256 public constant TOKEN_PRICE_DENOM = 1;
134 
135     uint256 public constant PRESALE_ETHER_MIN_CONTRIB = 0.01 ether;
136     uint256 public constant SALE_ETHER_MIN_CONTRIB = 0.1 ether;
137 
138     uint256 public constant PRESALE_CAP = 10000 ether;
139     uint256 public constant HARD_CAP = 100000 ether;
140 
141     uint256 public constant PRESALE_START_TIME = 1413609200;
142     uint256 public constant PRESALE_END_TIME = 1514764740;
143 
144     uint256 public constant SALE_START_TIME = 1515510000;
145     uint256 public constant SALE_END_TIME = 1518739140;
146 
147     uint256 public totalEtherContributed = 0;
148     uint256 public totalTokensToSupply = 0;
149     address public wallet = 0x0;
150 
151     uint256 public bonusWindow1EndTime = 0;
152     uint256 public bonusWindow2EndTime = 0;
153     uint256 public bonusWindow3EndTime = 0;  
154 
155     event LogContribution(address indexed contributor, uint256 amountWei, uint256 tokenAmount, uint256 tokenBonus, uint256 timestamp);
156 
157     modifier checkContribution() {
158         require(
159             (now >= PRESALE_START_TIME && now < PRESALE_END_TIME && msg.value >= PRESALE_ETHER_MIN_CONTRIB) ||
160             (now >= SALE_START_TIME && now < SALE_END_TIME && msg.value >= SALE_ETHER_MIN_CONTRIB)
161         );
162         _;
163     }
164 
165     modifier checkCap() {
166         require(
167             (now >= PRESALE_START_TIME && now < PRESALE_END_TIME && safeAdd(totalEtherContributed, msg.value) <= PRESALE_CAP) ||
168             (now >= SALE_START_TIME && now < SALE_END_TIME && safeAdd(totalEtherContributed, msg.value) <= HARD_CAP)
169         );
170         _;
171     }
172 
173     function TheAbyssCrowdsale(address _wallet) public {
174         require(_wallet != address(0));
175 
176         wallet = _wallet;
177 
178         bonusWindow1EndTime = SALE_START_TIME + 1 days;
179         bonusWindow2EndTime = SALE_START_TIME + 4 days;
180         bonusWindow3EndTime = SALE_START_TIME + 20 days;
181     }
182 
183     function getBonus() internal constant returns (uint256, uint256) {
184         uint256 numerator = 0;
185         uint256 denominator = 100;
186 
187         if(now >= PRESALE_START_TIME && now < PRESALE_END_TIME) {
188             numerator = 25;
189         } else if(now >= SALE_START_TIME && now < SALE_END_TIME) {
190             if(now < bonusWindow1EndTime) {
191                 numerator = 15;
192             } else if(now < bonusWindow2EndTime) {
193                 numerator = 10;
194             } else if(now < bonusWindow3EndTime) {
195                 numerator = 5;
196             } else {
197                 numerator = 0;
198             }
199         }
200         return (numerator, denominator);
201     }
202 
203     function () payable public {
204         processContribution();
205     }
206 
207     function processContribution() private whenNotPaused checkContribution checkCap {
208         uint256 bonusNum = 0;
209         uint256 bonusDenom = 100;
210         (bonusNum, bonusDenom) = getBonus();
211         uint256 tokenBonusAmount = 0;
212         uint256 tokenAmount = safeDiv(safeMul(msg.value, TOKEN_PRICE_NUM), TOKEN_PRICE_DENOM);
213 
214         if(bonusNum > 0) {
215             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
216         }
217 
218         uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);
219         balances[msg.sender] = safeAdd(balances[msg.sender], tokenTotalAmount);
220 
221         totalEtherContributed = safeAdd(totalEtherContributed, msg.value);
222         totalTokensToSupply = safeAdd(totalTokensToSupply, tokenTotalAmount);
223         LogContribution(msg.sender, msg.value, tokenAmount, tokenBonusAmount, now);
224     }
225 
226     function transferFunds() public onlyOwner {
227         wallet.transfer(this.balance);
228     }
229 }