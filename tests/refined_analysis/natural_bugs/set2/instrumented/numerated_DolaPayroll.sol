1 pragma solidity ^0.7.3;
2 
3 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 contract DolaPayroll {
7     using SafeERC20 for IERC20;
8 
9     mapping(address => Recipient) public recipients;
10 
11     address public constant treasuryAddress = 0x926dF14a23BE491164dCF93f4c468A50ef659D5B;
12     address public constant governance = 0x926dF14a23BE491164dCF93f4c468A50ef659D5B;
13     IERC20 public constant DOLA = IERC20(0x865377367054516e17014CcdED1e7d814EDC9ce4);
14     
15     uint256 public yearlyPeriod = 365 days;
16     address public fundingCommittee = 0x77C64eEF5F4781Dd6e9405a8a77D80567CFD37E0;
17 
18     struct Recipient {
19         uint256 lastClaim;
20         uint256 ratePerSecond;
21         uint256 startTime;
22     }
23 
24     event NewRecipient(address recipient, uint256 amount);
25     event RecipientRemoved(address recipient, uint256 amount);
26     event AmountWithdrawn(address recipient, uint256 amount);
27     event UpdatedFundingCommittee(address from, address to);
28 
29     constructor() public {}
30 
31     /**
32      * @notice Add a new salary recipient. No notion of stop time. payment can be cancelled by committee or governance at any future time
33      * @param _newRecipient new recipient of salary
34      * @param _yearlyAmount monthly salary
35      */
36     function addRecipient(address _newRecipient, uint256 _yearlyAmount) external {
37         require(msg.sender == governance || msg.sender == fundingCommittee, "DolaPayroll::addRecipient: only governance or funding committee!");
38         require(recipients[_newRecipient].ratePerSecond == 0, "DolaPayroll::addRecipient: recipient already exists!");
39         require(_newRecipient != address(0), "DolaPayroll::addRecipient: zero address!");
40         require(_newRecipient != address(this), "DolaPayroll::addRecipient: recipient can't be this contract");
41         require(_yearlyAmount > 0, "DolaPayroll::addRecipient: amount must be greater than 0");
42         // ensure amount is gte to month period else, payment rate per second will be 0
43         require(_yearlyAmount >= yearlyPeriod, "DolaPayroll:addRecipient: amount too low for month period!");
44 
45         // no notion of end time so using month period, which gov or committee can update. rate per second is calculated on monthly basis
46         uint256 amountPerSecond = _div256(_yearlyAmount, yearlyPeriod);
47 
48         recipients[_newRecipient] = Recipient({
49             lastClaim: 0,
50             ratePerSecond: amountPerSecond,
51             startTime: block.timestamp
52         });
53 
54         emit NewRecipient(_newRecipient, _yearlyAmount);
55     }
56 
57     /**
58      * @notice Remove recipient from receiving salary
59      * @param _recipient recipient to whom it may concern
60      */
61     function removeRecipient(address _recipient) external {
62         require(msg.sender == governance || msg.sender == fundingCommittee || msg.sender == _recipient, "DolaPayroll::removeRecipient: only governance or funding committee");
63         require(recipients[_recipient].ratePerSecond != 0, "DolaPayroll::removeRecipient: recipient does not exist!");
64 
65         // calculate remaining balances and delete recipient entry from recipients mapping, then transfer remaining dola to recipient
66         Recipient memory recipient = recipients[_recipient];
67         uint256 delta = _delta(_recipient);
68         uint256 amount;
69         if (delta > 0) {
70             // transfer remaining unclaimed to recipient
71             amount = _balanceOf(_recipient, delta);
72             DOLA.safeTransferFrom(treasuryAddress, _recipient, amount);
73         }
74 
75         delete recipients[_recipient];
76         emit RecipientRemoved(_recipient, amount);
77     }
78 
79     /**
80     * @notice withdraw salary
81     */
82     function withdraw() external {
83         require(recipients[msg.sender].ratePerSecond != 0, "DolaPayroll::withdraw: not a recipient!");
84         uint256 delta = _delta(msg.sender);
85         require(delta > 0, "DolayPayroll::withdraw: not enough time elapsed!");
86         
87         Recipient storage recipient = recipients[msg.sender];
88         recipient.lastClaim = block.timestamp;
89         uint256 amount = _balanceOf(msg.sender, delta);
90         DOLA.safeTransferFrom(treasuryAddress, msg.sender, amount);
91 
92         emit AmountWithdrawn(msg.sender, amount);
93     }
94 
95     function _delta(address _recipient) internal view returns (uint256) {
96         Recipient memory recipient = recipients[_recipient];
97         if (recipient.startTime >= block.timestamp) return 0;
98         uint256 delta;
99         if (recipient.lastClaim == 0) {
100             delta = _sub256(block.timestamp, recipient.startTime);
101         } else {
102             delta = _sub256(block.timestamp, recipient.lastClaim);
103         }
104         return delta;
105     }
106 
107     /**
108      * @notice Update funding committee
109      * @param _newFundingCommittee The new funding committee address
110      */
111     function updateFundingCommittee(address _newFundingCommittee) external {
112         require(msg.sender == governance, "DolaPayroll::updateFundingCommittee: only governance!");
113         require(_newFundingCommittee != address(0), "DolaPayroll::updateFundingCommittee: address 0!");
114         require(_newFundingCommittee != address(this), "DolaPayroll::updateFundingCommittee: payroll address");
115 
116         address from = fundingCommittee;
117         fundingCommittee = _newFundingCommittee;
118         emit UpdatedFundingCommittee(from, _newFundingCommittee);
119     }
120 
121     /**
122      * @notice check balance of salary recipient at current block time
123      * @param _recipient address of salary recipient
124      */
125     function balanceOf(address _recipient) external view returns (uint256) {
126         uint256 delta = _delta(_recipient);
127         if (delta == 0) return 0;
128 
129         return _balanceOf(_recipient, delta);
130     }
131 
132     // avoid recalculating delta
133     function _balanceOf(address _recipient, uint256 delta) internal view returns (uint256) {
134         Recipient memory recipient = recipients[_recipient];
135         return _mul256(recipient.ratePerSecond, delta);
136     }
137 
138     function _mul256(uint256 a, uint256 b) internal pure returns (uint256) {
139         if (a == 0) {
140             return 0;
141         }
142         uint256 c = a * b;
143         require(c / a == b, "multiplication overflow");
144         return c;
145     }
146 
147     function _div256(uint256 a, uint256 b) internal pure returns (uint256) {
148         require(b != 0, "division by 0");
149         uint256 c = a / b;
150         return c;
151     }
152 
153     function _add256(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "addition overflow");
156         return c;
157     }
158 
159     function _sub256(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(b <= a, "subtraction underflow");
161         uint256 c = a - b;
162         return c;
163     }
164 }
