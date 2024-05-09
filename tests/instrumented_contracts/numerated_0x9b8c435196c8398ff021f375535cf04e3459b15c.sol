1 pragma solidity ^0.4.11;
2 
3 // Minimum version requirement
4 
5 
6 
7 contract MPY {
8 
9   function getSupply() constant returns (uint256);
10 
11   /// Return address balance of tokens
12   function balanceOf(address _owner) constant returns (uint256);
13 
14 }
15 
16 
17 
18 contract MatchPay {
19     /* @title Master contract. MatchPay
20        @param msg.sender owner address
21     */
22 
23     struct dividend_right {
24       uint _total_owed;
25       uint _period;
26     }
27 
28     uint genesis_date;
29     uint current_period;
30 
31     address master;
32     MPY token;
33 
34     bool is_payday ;
35     uint dividends;
36     mapping (address => dividend_right) dividends_redeemed;
37 
38     // -------------------------------------------------------------------------------------------
39 
40     // Only owner modifier
41     modifier only_owner_once(address _who) { require(_who == master && token == address(0)); _; }
42 
43     // Is window open (first month after each genesis anniversary)
44     modifier is_window_open() { require( (now - genesis_date) % 31536000 <= 2592000); _; }
45 
46     // Is window close
47     modifier is_window_close() { require( (now - genesis_date) % 31536000 > 2592000); _; }
48 
49     // -------------------------------------------------------------------------------------------
50 
51     event Created(address indexed _who, address indexed _to_whom, address indexed _contract_address);
52 
53     // -------------------------------------------------------------------------------------------
54 
55 
56     function MatchPay() {
57       master = msg.sender;
58       genesis_date = now;
59       current_period = 0;
60       is_payday = false;
61     }
62 
63 
64     // Sets token address (MPY)
65     function setTokenAddress(address _MPYAddress) only_owner_once(msg.sender) returns (bool) {
66       token = MPY(_MPYAddress);
67 
68       return true;
69     }
70 
71 
72     // Redeem dividends
73     function redeem(uint _amount) is_window_open() returns (bool) {
74       // If payday isn't flagged, flag it and freeze the dividends
75       if (!is_payday) {
76         is_payday = true;
77         dividends = this.balance;
78       }
79 
80       // Check balance of sender and total balance
81       uint256 tokenBalance = token.balanceOf(msg.sender);
82       if (tokenBalance == 0) return false;
83       uint256 tokenSupply = token.getSupply();
84 
85       // Reset amount owed if necessary
86       if (dividends_redeemed[msg.sender]._period != current_period) {
87         dividends_redeemed[msg.sender]._total_owed = 0;
88         dividends_redeemed[msg.sender]._period = current_period;
89       }
90 
91       // Add _amount to total owed
92       dividends_redeemed[msg.sender]._total_owed += _amount;
93 
94       // If proposed amount is viable, then give it to the owner
95       if (dividends_redeemed[msg.sender]._total_owed * tokenSupply <= dividends * tokenBalance) {
96         if (!msg.sender.send(_amount)) {
97           dividends_redeemed[msg.sender]._total_owed -= _amount;
98           return false;
99         }
100       }
101 
102       return true;
103     }
104 
105 
106     // Redeem dividends
107     function switch_period() is_window_close() returns (bool) {
108       // If payday is flagged, unflag it and reset the dividends
109       if (is_payday) {
110         is_payday = false;
111         dividends = 0;
112         current_period += 1;
113         return true;
114       } else {
115         return false;
116       }
117     }
118 
119 
120     // Collect fees
121     function() payable {}
122 }