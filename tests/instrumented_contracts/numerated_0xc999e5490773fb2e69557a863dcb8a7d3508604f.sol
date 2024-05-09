1 // https://github.com/librasai/SaiContest_Gaia
2 pragma solidity ^0.4.21;
3 
4 contract SaiContest_Gaia {
5 	address public owner;
6 	uint public start;      // starting date
7 	uint public last_roll;  // starting date for week round (7 days)
8 	uint public last_jack;   // starting date for jackpot round (30 days)
9 	address public week_winner; // current winner-of-week (wins the one has sent a biggest value in one transaction)
10 	address public jack_winner; // current winner-of-jackpot (the one with most transactions wins)
11 	uint public week_max;   // biggest value has been sent in a current week round
12 	uint public jack_max;   // most number of transactions was made by one sender in a current jackpot round
13 	uint public jack_pot;   // size of current jackpot
14 	uint public jack_nonce; // current nonce (number of jackpot round)
15 	struct JVal {
16         	uint nonce;
17         	uint64 count;
18 	}
19 	mapping (address => JVal) public jacks; // storing current jackpot participants (in this jackpot round) and their transactions count
20 
21 	uint public constant min_payment= 1 finney; // size of minimal payment can be accepted
22 	
23 	function SaiContest_Gaia() public {
24 		owner = msg.sender;		
25 		start = now;
26 		last_roll = now;
27 		last_jack = now;
28 		jack_nonce = 1;
29 	}
30 
31 	function kill(address addr) public { 
32 	    if (msg.sender == owner && now > start + 1 years){
33 	        selfdestruct(addr);
34 	    }
35 	}
36 	
37 	function getBalance() public view returns (uint bal) {
38 	    bal = address(this).balance;
39 	}
40 
41 	function () public payable{
42 	    Paid(msg.value);
43 	}
44 	
45 	function Paid(uint value) private {
46 	    uint WeekPay;
47 	    uint JackPay;
48 	    uint oPay;
49 	    uint CurBal;
50 	    uint JackPot;
51 	    uint CurNonce;
52 	    address WeekWinner;
53 	    address JackWinner;
54 	    uint64 JackValCount;
55 	    uint JackValNonce;
56 	    
57 	    require(value >= min_payment);
58 	    oPay = value * 5 / 100; // 5% to owner
59 	    CurBal = address(this).balance - oPay;
60 	    JackPot = jack_pot;
61 
62 	    if (now > last_roll + 7 days) {
63 	        WeekPay = CurBal - JackPot;
64 	        WeekWinner = week_winner;
65 	        last_roll = now;
66 	        week_max = value;
67 	        week_winner = msg.sender;
68 	    } else {
69 	        if (value > week_max) {
70     	        week_winner = msg.sender;
71 	            week_max = value;
72 	        }
73 	    }
74 	    if (now > last_jack + 30 days) {
75 	        JackWinner = jack_winner;
76 	        if (JackPot > CurBal) {
77 	            JackPay = CurBal;
78 	        } else {
79 	            JackPay = JackPot;
80 	        }
81     	    jack_pot = value * 10 / 100; // 10% to jackpot
82 	        jack_winner = msg.sender;
83 	        jack_max = 1;
84 	        CurNonce = jack_nonce + 1; 
85 	        jacks[msg.sender].nonce = CurNonce;
86 	        jacks[msg.sender].count = 1;
87 	        jack_nonce = CurNonce;
88 	    } else {
89     	    jack_pot = JackPot + value * 10 / 100; // 10% to jackpot
90 	        CurNonce = jack_nonce; 
91 	        JackValNonce = jacks[msg.sender].nonce;
92 	        JackValCount = jacks[msg.sender].count;
93 	        if (JackValNonce < CurNonce) {
94 	            jacks[msg.sender].nonce = CurNonce;
95 	            jacks[msg.sender].count = 1;
96     	        if (jack_max == 0) {
97         	        jack_winner = msg.sender;
98     	            jack_max = 1;
99     	        }
100 	        } else {
101 	            JackValCount = JackValCount + 1;
102 	            jacks[msg.sender].count = JackValCount;
103     	        if (JackValCount > jack_max) {
104         	        jack_winner = msg.sender;
105     	            jack_max = JackValCount;
106     	        }
107 	        }
108 	        
109 	    }
110 
111 	    owner.transfer(oPay);
112 	    if (WeekPay > 0) {
113 	        WeekWinner.transfer(WeekPay);
114 	    }
115 	    if (JackPay > 0) {
116 	        JackWinner.transfer(JackPay);
117 	    }
118 	}
119 }