1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ISimpleCrowdsale.sol
4 
5 interface ISimpleCrowdsale {
6     function getSoftCap() external view returns(uint256);
7     function isContributorInLists(address contributorAddress) external view returns(bool);
8     function processReservationFundContribution(
9         address contributor,
10         uint256 tokenAmount,
11         uint256 tokenBonusAmount
12     ) external payable;
13 }
14 
15 // File: contracts/fund/ICrowdsaleReservationFund.sol
16 
17 /**
18  * @title ICrowdsaleReservationFund
19  * @dev ReservationFund methods used by crowdsale contract
20  */
21 interface ICrowdsaleReservationFund {
22     /**
23      * @dev Check if contributor has transactions
24      */
25     function canCompleteContribution(address contributor) external returns(bool);
26     /**
27      * @dev Complete contribution
28      * @param contributor Contributor`s address
29      */
30     function completeContribution(address contributor) external;
31     /**
32      * @dev Function accepts user`s contributed ether and amount of tokens to issue
33      * @param contributor Contributor wallet address.
34      * @param _tokensToIssue Token amount to issue
35      * @param _bonusTokensToIssue Bonus token amount to issue
36      */
37     function processContribution(address contributor, uint256 _tokensToIssue, uint256 _bonusTokensToIssue) external payable;
38 
39     /**
40      * @dev Function returns current user`s contributed ether amount
41      */
42     function contributionsOf(address contributor) external returns(uint256);
43 
44     /**
45      * @dev Function is called on the end of successful crowdsale
46      */
47     function onCrowdsaleEnd() external;
48 }
49 
50 // File: contracts/math/SafeMath.sol
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 contract SafeMath {
57     /**
58     * @dev constructor
59     */
60     function SafeMath() public {
61     }
62 
63     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a * b;
65         assert(a == 0 || c / a == b);
66         return c;
67     }
68 
69     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a / b;
71         return c;
72     }
73 
74     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
75         assert(a >= b);
76         return a - b;
77     }
78 
79     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         assert(c >= a);
82         return c;
83     }
84 }
85 
86 // File: contracts/ownership/Ownable.sol
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94     address public owner;
95     address public newOwner;
96 
97     event OwnershipTransferred(address previousOwner, address newOwner);
98 
99     /**
100     * @dev The Ownable constructor sets the original `owner` of the contract.
101     */
102     function Ownable(address _owner) public {
103         owner = _owner == address(0) ? msg.sender : _owner;
104     }
105 
106     /**
107     * @dev Throws if called by any account other than the owner.
108     */
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     /**
115     * @dev Allows the current owner to transfer control of the contract to a newOwner.
116     * @param _newOwner The address to transfer ownership to.
117     */
118     function transferOwnership(address _newOwner) public onlyOwner {
119         require(_newOwner != owner);
120         newOwner = _newOwner;
121     }
122 
123     /**
124     * @dev confirm ownership by a new owner
125     */
126     function confirmOwnership() public {
127         require(msg.sender == newOwner);
128         OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130         newOwner = 0x0;
131     }
132 }
133 
134 // File: contracts/ReservationFund.sol
135 
136 contract ReservationFund is ICrowdsaleReservationFund, Ownable, SafeMath {
137     bool public crowdsaleFinished = false;
138 
139     mapping(address => uint256) contributions;
140     mapping(address => uint256) tokensToIssue;
141     mapping(address => uint256) bonusTokensToIssue;
142 
143     ISimpleCrowdsale public crowdsale;
144 
145     event RefundPayment(address contributor, uint256 etherAmount);
146     event TransferToFund(address contributor, uint256 etherAmount);
147     event FinishCrowdsale();
148 
149     function ReservationFund(address _owner) public Ownable(_owner) {
150     }
151 
152     modifier onlyCrowdsale() {
153         require(msg.sender == address(crowdsale));
154         _;
155     }
156 
157     function setCrowdsaleAddress(address crowdsaleAddress) public onlyOwner {
158         require(crowdsale == address(0));
159         crowdsale = ISimpleCrowdsale(crowdsaleAddress);
160     }
161 
162     function onCrowdsaleEnd() external onlyCrowdsale {
163         crowdsaleFinished = true;
164         FinishCrowdsale();
165     }
166 
167 
168     function canCompleteContribution(address contributor) external returns(bool) {
169         if(crowdsaleFinished) {
170             return false;
171         }
172         if(!crowdsale.isContributorInLists(contributor)) {
173             return false;
174         }
175         if(contributions[contributor] == 0) {
176             return false;
177         }
178         return true;
179     }
180 
181     /**
182      * @dev Function to check contributions by address
183      */
184     function contributionsOf(address contributor) external returns(uint256) {
185         return contributions[contributor];
186     }
187 
188     /**
189      * @dev Process crowdsale contribution without whitelist
190      */
191     function processContribution(
192         address contributor,
193         uint256 _tokensToIssue,
194         uint256 _bonusTokensToIssue
195     ) external payable onlyCrowdsale {
196         contributions[contributor] = safeAdd(contributions[contributor], msg.value);
197         tokensToIssue[contributor] = safeAdd(tokensToIssue[contributor], _tokensToIssue);
198         bonusTokensToIssue[contributor] = safeAdd(bonusTokensToIssue[contributor], _bonusTokensToIssue);
199     }
200 
201     /**
202      * @dev Complete contribution after if user is whitelisted
203      */
204     function completeContribution(address contributor) external {
205         require(!crowdsaleFinished);
206         require(crowdsale.isContributorInLists(contributor));
207         require(contributions[contributor] > 0);
208 
209         uint256 etherAmount = contributions[contributor];
210         uint256 tokenAmount = tokensToIssue[contributor];
211         uint256 tokenBonusAmount = bonusTokensToIssue[contributor];
212 
213         contributions[contributor] = 0;
214         tokensToIssue[contributor] = 0;
215         bonusTokensToIssue[contributor] = 0;
216 
217         crowdsale.processReservationFundContribution.value(etherAmount)(contributor, tokenAmount, tokenBonusAmount);
218         TransferToFund(contributor, etherAmount);
219     }
220 
221     /**
222      * @dev Refund payments if crowdsale is finalized
223      */
224     function refundPayment(address contributor) public {
225         require(crowdsaleFinished);
226         require(contributions[contributor] > 0 || tokensToIssue[contributor] > 0);
227         uint256 amountToRefund = contributions[contributor];
228 
229         contributions[contributor] = 0;
230         tokensToIssue[contributor] = 0;
231         bonusTokensToIssue[contributor] = 0;
232 
233         contributor.transfer(amountToRefund);
234         RefundPayment(contributor, amountToRefund);
235     }
236 }