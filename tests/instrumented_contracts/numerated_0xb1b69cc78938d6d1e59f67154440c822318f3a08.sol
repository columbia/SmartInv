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
46 contract PermanentTeamVestingFactory {
47 
48     event NewPermanentTeamVestingCreated(address tokenAddress, address recurringBillingContract);
49 
50     function newPermanentTeamVesting (address tokenAddress) public returns (address recurringBillingContractAddress) {
51         PermanentTeamVesting c = new PermanentTeamVesting(ERC20TokenInterface(tokenAddress));
52         emit NewPermanentTeamVestingCreated(tokenAddress, c);
53         return c;
54     }
55 
56 }
57 
58 /**
59  * @title Team Vesting
60  * Vesting smart contract for DreamTeam members.
61  * You can check how many tokens you can withdraw from this smart contract by calling
62  * `releasableAmount` function. If you want to withdraw these tokens, create a transaction
63  * to a `release` function, specifying your account address as an argument.
64  */
65 contract PermanentTeamVesting {
66 
67     using SafeMath for uint256;
68 
69     event Released(address beneficiary, uint256 amount);
70 
71     struct Beneficiary {
72         uint256 start;
73         uint256 duration;
74         uint256 cliff;
75         uint256 totalAmount;
76         uint256 releasedAmount;
77     }
78 
79     mapping (address => Beneficiary) public beneficiary;
80     ERC20TokenInterface public token;
81 
82     modifier isVestedAccount (address account) { require(beneficiary[account].start != 0); _; }
83     modifier isNotVestedAccount (address account) { require(beneficiary[account].start == 0); _; }
84 
85     /**
86     * Token vesting.
87     */
88     constructor (ERC20TokenInterface tokenAddress) public {
89         require(tokenAddress != address(0));
90         token = tokenAddress;
91     }
92 
93     /**
94     * Calculates the releaseable amount of tokens at the current time.
95     * @param account Vested account
96     * @return Amount in decimals
97     */
98     function releasableAmount (address account) public view returns (uint256) {
99         return vestedAmount(account).sub(beneficiary[account].releasedAmount);
100     }
101 
102     /**
103     * @notice Transfers available vested tokens to the beneficiary.
104     * @param account Beneficiary account.
105     */
106     function release (address account) public isVestedAccount(account) {
107         uint256 unreleased = releasableAmount(account);
108         require(unreleased > 0);
109         beneficiary[account].releasedAmount = beneficiary[account].releasedAmount.add(unreleased);
110         token.transfer(account, unreleased);
111         emit Released(account, unreleased);
112         if (beneficiary[account].releasedAmount == beneficiary[account].totalAmount) { // When done, clean beneficiary info
113             delete beneficiary[account];
114         }
115     }
116 
117     /**
118      * Allows to vest tokens for beneficiary.
119      */
120     function addBeneficiary (
121         address account,
122         uint256 start,
123         uint256 duration,
124         uint256 cliff,
125         uint256 amount
126     ) public isNotVestedAccount(account) {
127         require(amount != 0 && account != 0x0 && cliff < duration && beneficiary[account].start == 0);
128         require(token.transferFrom(msg.sender, address(this), amount));
129         beneficiary[account] = Beneficiary({
130             start: start,
131             duration: duration,
132             cliff: start.add(cliff),
133             totalAmount: amount,
134             releasedAmount: 0
135         });
136     }
137 
138     /**
139     * @dev Calculates the amount that has already vested.
140     * @param account Vested account
141     * @return Amount in decimals
142     */
143     function vestedAmount (address account) private view returns (uint256) {
144         if (block.timestamp < beneficiary[account].cliff) {
145             return 0;
146         } else if (block.timestamp >= beneficiary[account].start.add(beneficiary[account].duration)) {
147             return beneficiary[account].totalAmount;
148         } else {
149             return beneficiary[account].totalAmount.mul(
150                 block.timestamp.sub(beneficiary[account].start)
151             ).div(beneficiary[account].duration);
152         }
153     }
154 
155 }