1 pragma solidity ^0.4.21;
2 
3 contract BlackjackTipJar {
4 
5     address public pitboss;
6     uint256 public deployedOn;
7 
8     uint8 public dealer_cut = 95; // percent
9     uint256 public overflow_upper = 0.25 ether;
10     uint256 public overflow_lower = 0.15 ether;
11 
12     mapping(address => uint256) public bankrolls;
13     mapping(address => address) public beneficiaries;
14     
15     event Deposit(address indexed _dealer, address indexed _from, uint256 _value);
16     event Cashout(address indexed _dealer, address indexed _to, uint256 _value);
17     event Overflow(address indexed _dealer, uint256 _value);
18 
19     modifier auth() {
20       require(msg.sender == pitboss);
21       _;
22     }
23 
24     function BlackjackTipJar() public payable {
25       pitboss = msg.sender;
26       deployedOn = block.number;
27       bankrolls[pitboss] = msg.value;
28     }
29 
30     function () public payable {
31       bankrolls[pitboss] += msg.value;
32       emit Deposit(pitboss, msg.sender, msg.value);
33     }
34 
35 
36     // To be called by players
37     function deposit(address dealer) public payable {
38       bankrolls[dealer] = bankrolls[dealer] + msg.value;
39       emit Deposit(dealer, msg.sender, msg.value);
40     }
41 
42 
43     // To be called by dealers
44     function cashout(address winner, uint256 amount) public {
45 
46       uint256 dealerBankroll = bankrolls[msg.sender];
47       uint256 value = amount;
48       if (value > dealerBankroll) {
49         value = dealerBankroll;
50       }
51 
52       bankrolls[msg.sender] -= value;
53       winner.transfer(value);
54       emit Cashout(msg.sender, winner, value);
55 
56       // Has our cup runneth over? Let us collect our profits
57       dealerBankroll = bankrolls[msg.sender];
58       if (dealerBankroll > overflow_upper) {
59 
60         uint256 overflow_amt = dealerBankroll - overflow_lower;
61         bankrolls[msg.sender] -= overflow_amt;
62 
63         value = overflow_amt;
64         if (msg.sender != pitboss) {
65           value = overflow_amt * dealer_cut / 100;
66           pitboss.transfer(overflow_amt - value);
67         }
68 
69         address beneficiary = msg.sender;
70         address sender_beneficiary = beneficiaries[msg.sender];
71         if (sender_beneficiary > 0) { beneficiary = sender_beneficiary; }
72 
73         beneficiary.transfer(value);
74         emit Overflow(msg.sender, value);
75 
76       }
77     }
78 
79     // To be called by dealers
80     function setBeneficiary(address beneficiary) public {
81       beneficiaries[msg.sender] = beneficiary;
82     }
83 
84     // To be called by the pitboss
85     function setDealerCut(uint8 cut) public auth {
86       require(cut <= 100 && cut >= 1);
87       dealer_cut = cut;
88     }
89 
90     // To be called by the pitboss
91     function setOverflowBounds(uint256 upper, uint256 lower) public auth {
92       require(lower > 0 && upper > lower);
93       overflow_upper = upper;
94       overflow_lower = lower;
95     }
96 
97     function kill() public auth {
98       selfdestruct(pitboss);
99     }
100 
101 }