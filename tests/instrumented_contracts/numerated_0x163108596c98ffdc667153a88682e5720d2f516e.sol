1 /*
2 
3      (       )    )    )
4      )\ ) ( /( ( /( ( /(     (  (
5     (()/( )\()))\()))\())  ( )\ )\
6      /(_)|(_)\((_)\((_)\  ))((_|(_)
7     (_))  _((_)_((_)_((_)/((_)  _
8     | _ \| || \ \/ / || (_))| || |
9     |  _/| __ |>  <| __ / -_) || |
10     |_|  |_||_/_/\_\_||_\___|_||_|
11 
12     PHXHell - A game of timing and luck.
13       made by ToCsIcK
14 
15     Inspired by EthAnte by TechnicalRise
16 
17 */
18 pragma solidity ^0.4.21;
19 
20 // Contract must implement this interface in order to receive ERC223 tokens
21 contract ERC223ReceivingContract {
22     function tokenFallback(address _from, uint _value, bytes _data) public;
23 }
24 
25 // We only need the signature of the transfer method
26 contract ERC223Interface {
27     function transfer(address _to, uint _value) public returns (bool);
28 }
29 
30 // SafeMath is good
31 library SafeMath {
32     function mul(uint a, uint b) internal pure returns (uint) {
33         uint c = a * b;
34         assert(a == 0 || c / a == b);
35         return c;
36     }
37 
38     function div(uint a, uint b) internal pure returns (uint) {
39         // assert(b > 0); // Solidity automatically throws when dividing by 0
40         uint c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42         return c;
43     }
44 
45     function sub(uint a, uint b) internal pure returns (uint) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     function add(uint a, uint b) internal pure returns (uint) {
51         uint c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 
56     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
57         return a >= b ? a : b;
58     }
59 
60     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
61         return a < b ? a : b;
62     }
63 
64     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a >= b ? a : b;
66     }
67 
68     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a < b ? a : b;
70     }
71 }
72 
73 contract PhxHell is ERC223ReceivingContract {
74     using SafeMath for uint;
75 
76     uint public balance;        // Current balance
77     uint public lastFund;       // Time of last fund
78     address public lastFunder;  // Address of the last person who funded
79     address phxAddress;         // PHX main net address
80 
81     uint constant public stakingRequirement = 5e17;   // 0.5 PHX
82     uint constant public period = 1 hours;
83 
84     // Event to record the end of a game so it can be added to a 'history' page
85     event GameOver(address indexed winner, uint timestamp, uint value);
86 
87     // Takes PHX address as a parameter so you can point at another contract during testing
88     function PhxHell(address _phxAddress)
89         public {
90         phxAddress = _phxAddress;
91     }
92 
93     // Called to force a payout without having to restake
94     function payout()
95         public {
96 
97         // If there's no pending winner, don't do anything
98         if (lastFunder == 0)
99             return;
100 
101         // If timer hasn't expire, don't do anything
102         if (now.sub(lastFund) < period)
103             return;
104 
105         uint amount = balance;
106         balance = 0;
107 
108         // Send the total balance to the last funder
109         ERC223Interface phx = ERC223Interface(phxAddress);
110         phx.transfer(lastFunder, amount);
111 
112         // Fire event
113         GameOver( lastFunder, now, amount );
114 
115         // Reset the winner
116         lastFunder = address(0);
117     }
118 
119     // Called by the ERC223 contract (PHX) when sending tokens to this address
120     function tokenFallback(address _from, uint _value, bytes)
121     public {
122 
123         // Make sure it is PHX we are receiving
124         require(msg.sender == phxAddress);
125 
126         // Make sure it's enough PHX
127         require(_value >= stakingRequirement);
128 
129         // Payout if someone won already
130         payout();
131 
132         // Add to the balance and reset the timer
133         balance = balance.add(_value);
134         lastFund = now;
135         lastFunder = _from;
136     }
137 }