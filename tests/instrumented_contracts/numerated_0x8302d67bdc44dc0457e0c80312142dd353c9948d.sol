1 pragma solidity ^0.4.13;
2 
3 contract EthereumLottery {
4     function admin() constant returns (address);
5     function needsInitialization() constant returns (bool);
6     function initLottery(uint _jackpot, uint _numTickets,
7                          uint _ticketPrice, int _durationInBlocks) payable;
8     function needsFinalization() constant returns (bool);
9     function finalizeLottery(uint _steps);
10 }
11 
12 contract LotteryAdmin {
13     address public owner;
14     address public admin;
15     address public proposedOwner;
16 
17     address public ethereumLottery;
18 
19     uint public dailyAdminAllowance;
20     uint public maximumJackpot;
21     int public minimumDurationInBlocks;
22 
23     uint public lastAllowancePaymentTimestamp;
24     uint public nextProfile;
25 
26     event Deposit(address indexed _from, uint _value);
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     modifier onlyAdminOrOwner {
34         require(msg.sender == owner || msg.sender == admin);
35         _;
36     }
37 
38     function LotteryAdmin(address _ethereumLottery) {
39         owner = msg.sender;
40         admin = msg.sender;
41         ethereumLottery = _ethereumLottery;
42 
43         dailyAdminAllowance = 50 finney;
44         maximumJackpot = 100 ether;
45         minimumDurationInBlocks = 6;
46     }
47 
48     function () payable {
49         Deposit(msg.sender, msg.value);
50     }
51 
52     function allowsAllowance() constant returns (bool) {
53         return now - lastAllowancePaymentTimestamp >= 24 hours;
54     }
55 
56     function requestAllowance() onlyAdminOrOwner {
57         require(allowsAllowance());
58 
59         lastAllowancePaymentTimestamp = now;
60         admin.transfer(dailyAdminAllowance);
61     }
62 
63     function needsAdministration() constant returns (bool) {
64         if (EthereumLottery(ethereumLottery).admin() != address(this)) {
65             return false;
66         }
67 
68         return EthereumLottery(ethereumLottery).needsFinalization();
69     }
70 
71     function administrate(uint _steps) onlyAdminOrOwner {
72         EthereumLottery(ethereumLottery).finalizeLottery(_steps);
73     }
74 
75     function needsInitialization() constant returns (bool) {
76         if (EthereumLottery(ethereumLottery).admin() != address(this)) {
77             return false;
78         }
79 
80         return EthereumLottery(ethereumLottery).needsInitialization();
81     }
82 
83     function initLottery(uint _nextProfile,
84                          uint _jackpot, uint _numTickets,
85                          uint _ticketPrice, int _durationInBlocks)
86              onlyAdminOrOwner {
87         require(_jackpot <= maximumJackpot);
88         require(_durationInBlocks >= minimumDurationInBlocks);
89 
90         nextProfile = _nextProfile;
91         EthereumLottery(ethereumLottery).initLottery.value(_jackpot)(
92             _jackpot, _numTickets, _ticketPrice, _durationInBlocks);
93     }
94 
95     function withdraw(uint _value) onlyOwner {
96         owner.transfer(_value);
97     }
98 
99     function setConfiguration(uint _dailyAdminAllowance,
100                               uint _maximumJackpot,
101                               int _minimumDurationInBlocks)
102              onlyOwner {
103         dailyAdminAllowance = _dailyAdminAllowance;
104         maximumJackpot = _maximumJackpot;
105         minimumDurationInBlocks = _minimumDurationInBlocks;
106     }
107 
108     function setLottery(address _ethereumLottery) onlyOwner {
109         ethereumLottery = _ethereumLottery;
110     }
111 
112     function setAdmin(address _admin) onlyOwner {
113         admin = _admin;
114     }
115 
116     function proposeOwner(address _owner) onlyOwner {
117         proposedOwner = _owner;
118     }
119 
120     function acceptOwnership() {
121         require(proposedOwner != 0);
122         require(msg.sender == proposedOwner);
123         owner = proposedOwner;
124     }
125 
126     function destruct() onlyOwner {
127         selfdestruct(owner);
128     }
129 }