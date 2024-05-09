1 contract Ambi {
2     function getNodeAddress(bytes32) constant returns (address);
3     function addNode(bytes32, address) external returns (bool);
4     function hasRelation(bytes32, bytes32, address) constant returns (bool);
5 }
6 
7 contract AmbiEnabled {
8     Ambi ambiC;
9     bytes32 public name;
10 
11     modifier checkAccess(bytes32 _role) {
12         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
13             _
14         }
15     }
16     
17     function getAddress(bytes32 _name) constant returns (address) {
18         return ambiC.getNodeAddress(_name);
19     }
20 
21     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
22         if(address(ambiC) != 0x0){
23             return false;
24         }
25         Ambi ambiContract = Ambi(_ambi);
26         if(ambiContract.getNodeAddress(_name)!=address(this)) {
27             bool isNode = ambiContract.addNode(_name, address(this));
28             if (!isNode){
29                 return false;
30             }   
31         }
32         name = _name;
33         ambiC = ambiContract;
34         return true;
35     }
36 
37     function remove() checkAccess("owner") {
38         suicide(msg.sender);
39     }
40 }
41 
42 contract ElcoinDb {
43     address owner;
44     address caller;
45 
46     event Transaction(bytes32 indexed hash, address indexed from, address indexed to, uint time, uint amount);
47 
48     modifier checkOwner() { _ }
49     modifier checkCaller() { _ }
50     mapping (address => uint) public balances;
51 
52     function ElcoinDb(address pCaller) {
53         owner = msg.sender;
54         caller = pCaller;
55     }
56 
57     function getOwner() constant returns (address rv) {
58         return owner;
59     }
60 
61     function getCaller() constant returns (address rv) {
62         return caller;
63     }
64 
65     function setCaller(address pCaller) checkOwner() returns (bool _success) {
66         caller = pCaller;
67 
68         return true;
69     }
70 
71     function setOwner(address pOwner) checkOwner() returns (bool _success) {
72         owner = pOwner;
73 
74         return true;
75     }
76 
77     function getBalance(address addr) constant returns(uint balance) {
78         return balances[addr];
79     }
80 
81     function deposit(address addr, uint amount, bytes32 hash, uint time) checkCaller() returns (bool res) {
82         balances[addr] += amount;
83         Transaction(hash, 0, addr, time, amount);
84 
85         return true;
86     }
87 
88     function withdraw(address addr, uint amount, bytes32 hash, uint time) checkCaller() returns (bool res) {
89         uint oldBalance = balances[addr];
90         if (oldBalance >= amount) {
91             balances[addr] = oldBalance - amount;
92             Transaction(hash, addr, 0, time, amount);
93             return true;
94         }
95 
96         return false;
97     }
98 }
99 
100 contract ElcoinInterface {
101     function rewardTo(address _to, uint _amount) returns (bool);
102 }
103 
104 contract PotRewards is AmbiEnabled {
105 
106     event Reward(address indexed beneficiary, uint indexed round, uint value, uint position);
107 
108     struct Transaction {
109         address from;
110         uint amount;
111     }
112 
113     uint public round = 0;
114     uint public counter = 0;            //counts each transaction
115     Transaction[] public transactions;  //records details of txns participating in next auction round
116 
117     //parameters
118     uint public periodicity;        //how often does an auction happen (ie. each 10000 tx)
119     uint8 public auctionSize;       //how many transactions participate in auction
120     uint public prize;              //total amount of prize for each round
121     uint public minTx;              //transactions less than this amount will not be counted
122     uint public startTime;          //starting at startTime to calculate double rewards
123 
124     ElcoinInterface public elcoin;  //contract to do rewardTo calls
125 
126     function configure(uint _periodicity, uint8 _auctionSize, uint _prize, uint _minTx, uint _counter, uint _startTime) checkAccess("owner") returns (bool) {
127         if (_auctionSize > _periodicity || _prize == 0 || _auctionSize > 255) {
128             return false;
129         }
130         periodicity = _periodicity;
131         auctionSize = _auctionSize;
132         prize = _prize;
133         minTx = _minTx;
134         counter = _counter;
135         startTime = _startTime;
136         elcoin = ElcoinInterface(getAddress("elcoin"));
137         return true;
138     }
139 
140     function transfer(address _from, address _to, uint _amount) checkAccess("elcoin") {
141         if (startTime > now || periodicity == 0 || auctionSize == 0 || prize == 0) {
142             return;
143         }
144         counter++;
145         if (_amount >= minTx && counter > periodicity - auctionSize) {
146             transactions.push(Transaction(_from, _amount));
147         }
148 
149         if (counter >= periodicity) {
150             _prepareAndSendReward();
151             counter = 0;
152             round++;
153             delete transactions;
154         }
155     }
156 
157     mapping(uint => mapping(address => uint)) public prizes;
158 
159     function _prepareAndSendReward() internal {
160         uint amount = 0;
161         address[] memory winners = new address[](auctionSize);
162         uint winnerPosition = 0;
163         for (uint8 i = 0; i < transactions.length; i++) {
164             if (transactions[i].amount == amount) {
165                 winners[winnerPosition++] = transactions[i].from;
166             }
167             if (transactions[i].amount > amount) {
168                 amount = transactions[i].amount;
169                 winnerPosition = 0;
170                 winners[winnerPosition++] = transactions[i].from;
171             }
172         }
173         if (winnerPosition == 0) {
174             return;
175         }
176         address[] memory uniqueWinners = new address[](winnerPosition);
177         uint uniqueWinnerPosition = 0;
178         uint currentPrize = _is360thDay() ? prize*2 : prize;
179         uint reward = currentPrize / winnerPosition;
180         for (uint8 position = 0; position < winnerPosition; position++) {
181             address winner = winners[position];
182             if (prizes[round][winner] == 0) {
183                 uniqueWinners[uniqueWinnerPosition++] = winner;
184             }
185             prizes[round][winner] += reward;
186         }
187         for (position = 0; position < uniqueWinnerPosition; position++) {
188             winner = uniqueWinners[position];
189             uint winnerReward = prizes[round][winner];
190             if (elcoin.rewardTo(winner, winnerReward)) {
191                 Reward(winner, round, winnerReward, position);
192             }
193         }
194     }
195 
196     function _is360thDay() internal constant returns(bool) {
197         if (startTime > now) {
198             return false;
199         }
200 
201         return (((now - startTime) / 1 days) + 1) % 360 == 0;
202     }
203 }