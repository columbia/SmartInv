1 pragma solidity ^0.4.25;
2 
3 /**
4  * Math operations with safety checks that throw on overflows.
5  */
6 library SafeMath {
7 
8     function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         require(c / a == b);
14         return c;
15     }
16     
17     function div (uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         // uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return a / b;
22     }
23     
24     function sub (uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         return a - b;
27     }
28 
29     function add (uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         require(c >= a);
32         return c;
33     }
34 
35 }
36 
37 contract ERC20TokenInterface {
38 
39     function totalSupply () external constant returns (uint);
40     function balanceOf (address tokenOwner) external constant returns (uint balance);
41     function transfer (address to, uint tokens) external returns (bool success);
42     function transferFrom (address from, address to, uint tokens) external returns (bool success);
43 
44 }
45 
46 /**
47  * @title Team Vesting
48  * You can check how many tokens you can withdraw from this smart contract by calling
49  * `releasableAmount` function. If you want to withdraw these tokens, create a transaction
50  * to a `release` function, specifying your account address as an argument.
51  */
52 contract PermanentTeamVesting {
53 
54     using SafeMath for uint256;
55 
56     event Released(address beneficiary, uint256 amount);
57 
58     struct Beneficiary {
59         uint256 start;
60         uint256 duration;
61         uint256 cliff;
62         uint256 totalAmount;
63         uint256 releasedAmount;
64     }
65 
66     mapping (address => Beneficiary) public beneficiary;
67     ERC20TokenInterface public token;
68 
69     modifier isVestedAccount (address account) { require(beneficiary[account].start != 0); _; }
70     modifier isNotVestedAccount (address account) { require(beneficiary[account].start == 0); _; }
71 
72     /**
73     * Token vesting.
74     */
75     constructor (ERC20TokenInterface tokenAddress) public {
76         require(tokenAddress != address(0));
77         token = tokenAddress;
78     }
79 
80     /**
81     * Calculates the releaseable amount of tokens at the current time.
82     * @param account Vested account
83     * @return Amount in decimals
84     */
85     function releasableAmount (address account) public view returns (uint256) {
86         return vestedAmount(account).sub(beneficiary[account].releasedAmount);
87     }
88 
89     /**
90     * @notice Transfers available vested tokens to the beneficiary.
91     * @param account Beneficiary account.
92     */
93     function release (address account) public isVestedAccount(account) {
94         uint256 unreleased = releasableAmount(account);
95         require(unreleased > 0);
96         beneficiary[account].releasedAmount = beneficiary[account].releasedAmount.add(unreleased);
97         token.transfer(account, unreleased);
98         emit Released(account, unreleased);
99         if (beneficiary[account].releasedAmount == beneficiary[account].totalAmount) { // When done, clean beneficiary info
100             delete beneficiary[account];
101         }
102     }
103 
104     /**
105      * Allows to vest tokens for beneficiary.
106      */
107     function addBeneficiary (
108         address account,
109         uint256 start,
110         uint256 duration,
111         uint256 cliff,
112         uint256 amount
113     ) public isNotVestedAccount(account) {
114         require(amount != 0 && account != 0x0 && cliff < duration && beneficiary[account].start == 0);
115         require(token.transferFrom(msg.sender, address(this), amount));
116         beneficiary[account] = Beneficiary({
117             start: start,
118             duration: duration,
119             cliff: start.add(cliff),
120             totalAmount: amount,
121             releasedAmount: 0
122         });
123     }
124 
125     /**
126     * @dev Calculates the amount that has already vested.
127     * @param account Vested account
128     * @return Amount in decimals
129     */
130     function vestedAmount (address account) private view returns (uint256) {
131         if (block.timestamp < beneficiary[account].cliff) {
132             return 0;
133         } else if (block.timestamp >= beneficiary[account].start.add(beneficiary[account].duration)) {
134             return beneficiary[account].totalAmount;
135         } else {
136             return beneficiary[account].totalAmount.mul(
137                 block.timestamp.sub(beneficiary[account].start)
138             ).div(beneficiary[account].duration);
139         }
140     }
141 
142 }