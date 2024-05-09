1 pragma solidity ^0.4.15;
2 
3 contract EthereumLottery {
4     function admin() constant returns (address);
5     function needsInitialization() constant returns (bool);
6     function initLottery(uint _jackpot, uint _numTickets, uint _ticketPrice);
7 }
8 
9 contract LotteryAdmin {
10     address public owner;
11     address public admin;
12     address public proposedOwner;
13 
14     address public ethereumLottery;
15 
16     uint public dailyAdminAllowance;
17 
18     uint public lastAllowancePaymentTimestamp;
19     uint public nextProfile;
20 
21     event Deposit(address indexed _from, uint _value);
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     modifier onlyAdminOrOwner {
29         require(msg.sender == owner || msg.sender == admin);
30         _;
31     }
32 
33     function LotteryAdmin(address _ethereumLottery) {
34         owner = msg.sender;
35         admin = msg.sender;
36         ethereumLottery = _ethereumLottery;
37 
38         dailyAdminAllowance = 50 finney;
39     }
40 
41     function () payable {
42         Deposit(msg.sender, msg.value);
43     }
44 
45     function allowsAllowance() constant returns (bool) {
46         return now - lastAllowancePaymentTimestamp >= 24 hours;
47     }
48 
49     function requestAllowance() onlyAdminOrOwner {
50         require(allowsAllowance());
51 
52         lastAllowancePaymentTimestamp = now;
53         admin.transfer(dailyAdminAllowance);
54     }
55 
56     function needsInitialization() constant returns (bool) {
57         if (EthereumLottery(ethereumLottery).admin() != address(this)) {
58             return false;
59         }
60 
61         return EthereumLottery(ethereumLottery).needsInitialization();
62     }
63 
64     function initLottery(uint _nextProfile, uint _jackpot,
65                          uint _numTickets, uint _ticketPrice)
66              onlyAdminOrOwner {
67         nextProfile = _nextProfile;
68         EthereumLottery(ethereumLottery).initLottery(
69             _jackpot, _numTickets, _ticketPrice);
70     }
71 
72     function withdraw(uint _value) onlyOwner {
73         owner.transfer(_value);
74     }
75 
76     function setConfiguration(uint _dailyAdminAllowance) onlyOwner {
77         dailyAdminAllowance = _dailyAdminAllowance;
78     }
79 
80     function setLottery(address _ethereumLottery) onlyOwner {
81         ethereumLottery = _ethereumLottery;
82     }
83 
84     function setAdmin(address _admin) onlyOwner {
85         admin = _admin;
86     }
87 
88     function proposeOwner(address _owner) onlyOwner {
89         proposedOwner = _owner;
90     }
91 
92     function acceptOwnership() {
93         require(proposedOwner != 0);
94         require(msg.sender == proposedOwner);
95         owner = proposedOwner;
96     }
97 
98     function destruct() onlyOwner {
99         selfdestruct(owner);
100     }
101 }