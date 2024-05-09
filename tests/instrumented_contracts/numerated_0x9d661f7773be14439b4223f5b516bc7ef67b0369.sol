1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 contract IRegistry {
29     function add(address who) public;
30 }
31 
32 
33 contract IUniswapExchange {
34     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 timestamp) public payable returns (uint256);
35 }
36 
37 
38 contract IGovernance {
39     function proposeWithFeeRecipient(address feeRecipient, address target, bytes memory data) public returns (uint);
40     function proposalFee() public view returns (uint);
41 }
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Unsigned math operations with safety checks that revert on error
47  */
48 library SafeMath {
49     /**
50     * @dev Multiplies two unsigned integers, reverts on overflow.
51     */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath::mul: Integer overflow");
62 
63         return c;
64     }
65 
66     /**
67     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
68     */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0, "SafeMath::div: Invalid divisor zero");
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     /**
79     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80     */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a, "SafeMath::sub: Integer underflow");
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89     * @dev Adds two unsigned integers, reverts on overflow.
90     */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath::add: Integer overflow");
94 
95         return c;
96     }
97 
98     /**
99     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
100     * reverts when dividing by zero.
101     */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0, "SafeMath::mod: Invalid divisor zero");
104         return a % b;
105     }
106 }
107 
108 
109 /**
110  * @title HumanityApplicant
111  * @dev Convenient interface for applying to the Humanity registry.
112  */
113 contract HumanityApplicant {
114     using SafeMath for uint;
115 
116     IGovernance public governance;
117     IRegistry public registry;
118     IERC20 public humanity;
119 
120     constructor(IGovernance _governance, IRegistry _registry, IERC20 _humanity) public {
121         governance = _governance;
122         registry = _registry;
123         humanity = _humanity;
124         humanity.approve(address(governance), uint(-1));
125     }
126 
127     function applyFor(address who) public returns (uint) {
128         uint fee = governance.proposalFee();
129         uint balance = humanity.balanceOf(address(this));
130         if (fee > balance) {
131             require(humanity.transferFrom(msg.sender, address(this), fee.sub(balance)), "HumanityApplicant::applyFor: Transfer failed");
132         }
133         bytes memory data = abi.encodeWithSelector(registry.add.selector, who);
134         return governance.proposeWithFeeRecipient(msg.sender, address(registry), data);
135     }
136 
137 }
138 
139 
140 /**
141  * @title PayableHumanityApplicant
142  * @dev Convenient interface for applying to the Humanity registry using Ether.
143  */
144 contract PayableHumanityApplicant is HumanityApplicant {
145 
146     IUniswapExchange public exchange;
147 
148     constructor(IGovernance _governance, IRegistry _registry, IERC20 _humanity, IUniswapExchange _exchange) public
149         HumanityApplicant(_governance, _registry, _humanity)
150     {
151         exchange = _exchange;
152     }
153 
154     function () external payable {}
155 
156     function applyWithEtherFor(address who) public payable returns (uint) {
157         // Exchange Ether for Humanity tokens
158         uint fee = governance.proposalFee();
159         exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp);
160 
161         // Apply to the registry
162         uint proposalId = applyFor(who);
163 
164         // Refund any remaining balance
165         msg.sender.send(address(this).balance);
166 
167         return proposalId;
168     }
169 
170 }
171 
172 
173 /**
174  * @title TwitterHumanityApplicant
175  * @dev Convenient interface for applying to the Humanity registry using Twitter as proof of identity.
176  */
177 contract TwitterHumanityApplicant is PayableHumanityApplicant {
178 
179     event Apply(uint indexed proposalId, address indexed applicant, string username);
180 
181     constructor(
182         IGovernance _governance,
183         IRegistry _registry,
184         IERC20 _humanity,
185         IUniswapExchange _exchange
186     ) public
187         PayableHumanityApplicant(_governance, _registry, _humanity, _exchange) {}
188 
189     function applyWithTwitter(string memory username) public returns (uint) {
190         return applyWithTwitterFor(msg.sender, username);
191     }
192 
193     function applyWithTwitterFor(address who, string memory username) public returns (uint) {
194         uint proposalId = applyFor(who);
195         emit Apply(proposalId, who, username);
196         return proposalId;
197     }
198 
199     function applyWithTwitterUsingEther(string memory username) public payable returns (uint) {
200         return applyWithTwitterUsingEtherFor(msg.sender, username);
201     }
202 
203     function applyWithTwitterUsingEtherFor(address who, string memory username) public payable returns (uint) {
204         uint proposalId = applyWithEtherFor(who);
205         emit Apply(proposalId, who, username);
206         return proposalId;
207     }
208 
209 }