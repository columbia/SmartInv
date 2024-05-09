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
20     uint public maximumAdminBalance;
21     uint public maximumJackpot;
22     int public minimumDurationInBlocks;
23 
24     uint public lastAllowancePaymentTimestamp;
25     uint public nextProfile;
26 
27     event Deposit(address indexed _from, uint _value);
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     modifier onlyAdminOrOwner {
35         require(msg.sender == owner || msg.sender == admin);
36         _;
37     }
38 
39     function LotteryAdmin(address _ethereumLottery) {
40         owner = msg.sender;
41         admin = msg.sender;
42         ethereumLottery = _ethereumLottery;
43 
44         dailyAdminAllowance = 50 finney;
45         maximumAdminBalance = 1 ether;
46         maximumJackpot = 100 ether;
47         minimumDurationInBlocks = 60;
48     }
49 
50     function () payable {
51         Deposit(msg.sender, msg.value);
52     }
53 
54     function needsAllowancePayment() constant returns (bool) {
55         return now - lastAllowancePaymentTimestamp >= 24 hours &&
56                admin.balance < maximumAdminBalance;
57     }
58 
59     function needsAdministration() constant returns (bool) {
60         if (EthereumLottery(ethereumLottery).admin() != address(this)) {
61             return false;
62         }
63 
64         return needsAllowancePayment() ||
65                EthereumLottery(ethereumLottery).needsFinalization();
66     }
67 
68     function administrate(uint _steps) onlyAdminOrOwner {
69         if (needsAllowancePayment()) {
70             lastAllowancePaymentTimestamp = now;
71             admin.transfer(dailyAdminAllowance);
72         } else {
73             EthereumLottery(ethereumLottery).finalizeLottery(_steps);
74         }
75     }
76 
77     function needsInitialization() constant returns (bool) {
78         if (EthereumLottery(ethereumLottery).admin() != address(this)) {
79             return false;
80         }
81 
82         return EthereumLottery(ethereumLottery).needsInitialization();
83     }
84 
85     function initLottery(uint _nextProfile,
86                          uint _jackpot, uint _numTickets,
87                          uint _ticketPrice, int _durationInBlocks)
88              onlyAdminOrOwner {
89         require(_jackpot <= maximumJackpot);
90         require(_durationInBlocks >= minimumDurationInBlocks);
91 
92         nextProfile = _nextProfile;
93         EthereumLottery(ethereumLottery).initLottery.value(_jackpot)(
94             _jackpot, _numTickets, _ticketPrice, _durationInBlocks);
95     }
96 
97     function withdraw(uint _value) onlyOwner {
98         owner.transfer(_value);
99     }
100 
101     function setConfiguration(uint _dailyAdminAllowance,
102                               uint _maximumAdminBalance,
103                               uint _maximumJackpot,
104                               int _minimumDurationInBlocks)
105              onlyOwner {
106         dailyAdminAllowance = _dailyAdminAllowance;
107         maximumAdminBalance = _maximumAdminBalance;
108         maximumJackpot = _maximumJackpot;
109         minimumDurationInBlocks = _minimumDurationInBlocks;
110     }
111 
112     function setLottery(address _ethereumLottery) onlyOwner {
113         ethereumLottery = _ethereumLottery;
114     }
115 
116     function setAdmin(address _admin) onlyOwner {
117         admin = _admin;
118     }
119 
120     function proposeOwner(address _owner) onlyOwner {
121         proposedOwner = _owner;
122     }
123 
124     function acceptOwnership() {
125         require(proposedOwner != 0);
126         require(msg.sender == proposedOwner);
127         owner = proposedOwner;
128     }
129 
130     function destruct() onlyOwner {
131         selfdestruct(owner);
132     }
133 }