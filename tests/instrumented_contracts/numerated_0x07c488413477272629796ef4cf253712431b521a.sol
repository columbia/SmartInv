1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract SRNTPriceOracleBasic {
47   uint256 public SRNT_per_ETH;
48 }
49 
50 contract Escrow {
51   using SafeMath for uint256;
52 
53   address public party_a;
54   address public party_b;
55   address constant serenity_wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;
56   address constant burn_address = 0x0000000000000000000000000000000000000001;
57   ERC20Basic constant SRNT_token = ERC20Basic(0xBC7942054F77b82e8A71aCE170E4B00ebAe67eB6);
58   SRNTPriceOracleBasic constant SRNT_price_oracle = SRNTPriceOracleBasic(0xae5D95379487d047101C4912BddC6942090E5D17);
59 
60   uint256 public withdrawal_party_a_gets;
61   uint256 public withdrawal_party_b_gets;
62   address public withdrawal_last_voter;
63 
64   event Deposit(uint256 amount);
65   event WithdrawalRequest(address requester, uint256 party_a_gets, uint256 party_b_gets);
66   event Withdrawal(uint256 party_a_gets, uint256 party_b_gets);
67 
68   constructor (address new_party_a, address new_party_b) public {
69     party_a = new_party_a;
70     party_b = new_party_b;
71   }
72 
73   function () external payable {
74     // New deposit - take commission and issue an event
75     uint256 fee = msg.value.div(100);
76     uint256 srnt_balance = SRNT_token.balanceOf(address(this));
77     uint256 fee_paid_by_srnt = srnt_balance.div(SRNT_price_oracle.SRNT_per_ETH());
78     if (fee_paid_by_srnt < fee) {  // Burn all SRNT, deduct from fee
79       if (fee_paid_by_srnt > 0) {
80         fee = fee.sub(fee_paid_by_srnt);
81         SRNT_token.transfer(burn_address, srnt_balance);
82       }
83       serenity_wallet.transfer(fee);
84       emit Deposit(msg.value.sub(fee));
85     } else {  // There's more SRNT available than needed. Burn a part of it.
86       SRNT_token.transfer(burn_address, fee.mul(SRNT_price_oracle.SRNT_per_ETH()));
87       emit Deposit(msg.value);
88     }
89   }
90 
91   function request_withdrawal(uint256 party_a_gets, uint256 party_b_gets) external {
92     require(msg.sender != withdrawal_last_voter);  // You can't vote twice
93     require((msg.sender == party_a) || (msg.sender == party_b) || (msg.sender == serenity_wallet));
94     require(party_a_gets.add(party_b_gets) <= address(this).balance);
95 
96     withdrawal_last_voter = msg.sender;
97 
98     emit WithdrawalRequest(msg.sender, party_a_gets, party_b_gets);
99 
100     if ((withdrawal_party_a_gets == party_a_gets) && (withdrawal_party_b_gets == party_b_gets)) {  // We have consensus
101       delete withdrawal_party_a_gets;
102       delete withdrawal_party_b_gets;
103       delete withdrawal_last_voter;
104       if (party_a_gets > 0) {
105         party_a.transfer(party_a_gets);
106       }
107       if (party_b_gets > 0) {
108         party_b.transfer(party_b_gets);
109       }
110       emit Withdrawal(party_a_gets, party_b_gets);
111     } else {
112       withdrawal_party_a_gets = party_a_gets;
113       withdrawal_party_b_gets = party_b_gets;
114     }
115   }
116 
117 }