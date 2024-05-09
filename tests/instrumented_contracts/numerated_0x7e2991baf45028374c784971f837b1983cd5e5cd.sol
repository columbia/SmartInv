1 pragma solidity ^0.5.2;
2 
3 contract ERC20TokenInterface {
4 
5     function totalSupply () external view returns (uint);
6     function balanceOf (address tokenOwner) external view returns (uint balance);
7     function transfer (address to, uint tokens) external returns (bool success);
8     function transferFrom (address from, address to, uint tokens) external returns (bool success);
9 
10 }
11 
12 library SafeMath {
13 
14     function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         require(c / a == b);
20         return c;
21     }
22     
23     function div (uint256 a, uint256 b) internal pure returns (uint256) {
24         return a / b;
25     }
26     
27     function sub (uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a);
29         return a - b;
30     }
31 
32     function add (uint256 a, uint256 b) internal pure returns (uint256 c) {
33         c = a + b;
34         require(c >= a);
35         return c;
36     }
37 
38 }
39 
40 /**
41  * @title Permanent, linearly-distributed vesting with cliff for specified token.
42  * Vested accounts can check how many tokens they can withdraw from this smart contract by calling
43  * `releasableAmount` function. If they want to withdraw these tokens, they create a transaction
44  * to a `release` function, specifying the account to release tokens from as an argument.
45  */
46 contract CliffTokenVesting {
47 
48     using SafeMath for uint256;
49 
50     event Released(address beneficiary, uint256 amount);
51 
52     /**
53      * Vesting records.
54      */
55     struct Beneficiary {
56         uint256 start;
57         uint256 duration;
58         uint256 cliff;
59         uint256 totalAmount;
60         uint256 releasedAmount;
61     }
62     mapping (address => Beneficiary) public beneficiary;
63 
64     /**
65      * Token address.
66      */
67     ERC20TokenInterface public token;
68 
69     uint256 public nonce = 696523;
70 
71     /**
72      * Whether an account was vested.
73      */
74     modifier isVestedAccount (address account) { require(beneficiary[account].start != 0); _; }
75 
76     /**
77     * Cliff vesting for specific token.
78     */
79     constructor (ERC20TokenInterface tokenAddress) public {
80         require(tokenAddress != ERC20TokenInterface(0x0));
81         token = tokenAddress;
82     }
83 
84     /**
85     * Calculates the releaseable amount of tokens at the current time.
86     * @param account Vested account.
87     * @return Withdrawable amount in decimals.
88     */
89     function releasableAmount (address account) public view returns (uint256) {
90         return vestedAmount(account).sub(beneficiary[account].releasedAmount);
91     }
92 
93     /**
94     * Transfers available vested tokens to the beneficiary.
95     * @notice The transaction fails if releasable amount = 0, or tokens for `account` are not vested.
96     * @param account Beneficiary account.
97     */
98     function release (address account) public isVestedAccount(account) {
99         uint256 unreleased = releasableAmount(account);
100         require(unreleased > 0);
101         beneficiary[account].releasedAmount = beneficiary[account].releasedAmount.add(unreleased);
102         token.transfer(account, unreleased);
103         emit Released(account, unreleased);
104         if (beneficiary[account].releasedAmount == beneficiary[account].totalAmount) { // When done, clean beneficiary info
105             delete beneficiary[account];
106         }
107     }
108 
109     /**
110      * Allows to vest tokens for beneficiary.
111      * @notice Tokens for vesting will be withdrawn from `msg.sender`'s account. Sender must first approve this amount
112      * for the smart contract.
113      * @param account Account to vest tokens for.
114      * @param start The absolute date of vesting start in unix seconds.
115      * @param duration Duration of vesting in seconds.
116      * @param cliff Cliff duration in seconds.
117      * @param amount How much tokens in decimals to withdraw.
118      */
119     function addBeneficiary (
120         address account,
121         uint256 start,
122         uint256 duration,
123         uint256 cliff,
124         uint256 amount
125     ) public {
126         require(amount != 0 && start != 0 && account != address(0x0) && cliff < duration && beneficiary[account].start == 0);
127         require(token.transferFrom(msg.sender, address(this), amount));
128         beneficiary[account] = Beneficiary({
129             start: start,
130             duration: duration,
131             cliff: start.add(cliff),
132             totalAmount: amount,
133             releasedAmount: 0
134         });
135     }
136 
137     /**
138     * Calculates the amount that is vested.
139     * @param account Vested account.
140     * @return Amount in decimals.
141     */
142     function vestedAmount (address account) private view returns (uint256) {
143         if (block.timestamp < beneficiary[account].cliff) {
144             return 0;
145         } else if (block.timestamp >= beneficiary[account].start.add(beneficiary[account].duration)) {
146             return beneficiary[account].totalAmount;
147         } else {
148             return beneficiary[account].totalAmount.mul(
149                 block.timestamp.sub(beneficiary[account].start)
150             ).div(beneficiary[account].duration);
151         }
152     }
153 
154 }