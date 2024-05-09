1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 }
45 
46 contract Statable {
47     uint8 public state; // { 0 = pre event , 1 = during event, 2 = post event, 3 = refunding
48     modifier requireState(uint8 _state) {
49         require(state == _state);
50         _;
51     }
52 }
53 
54 contract Fighter is Ownable, Statable {
55     using SafeMath for uint256;
56     uint256 public minBetAmount = 0;
57 
58     string name;
59 
60     constructor(string contractName, uint256 _minBetAmount) public {
61         name = contractName;
62         minBetAmount = _minBetAmount;
63         state = 0;
64     }
65 
66     function changeState(uint8 _state) public onlyOwner {
67         state = _state;
68     }
69 
70     function getAddress() public view returns (address) {
71         return address(this);
72     }
73 
74     function() public payable requireState(0) {
75         require(msg.value >= minBetAmount);
76         MasterFighter(address(owner)).addBet(msg.value, msg.sender);
77     }
78 
79     function transferMoneyToOwner() public onlyOwner requireState(1) {
80         if (address(this).balance > 0) {
81             MasterFighter(address(owner)).deposit.value(address(this).balance)();
82         }
83     }
84 
85 }
86 
87 contract MasterFighter is Ownable, Statable {
88     using SafeMath for uint256;
89 
90     uint256 public percentRake = 5;
91     uint256 public constant minBetAmount = 0.01 ether;
92 
93     bool public hasWithdrawnRake = false;
94 
95     address winningFighter;
96 
97     address[] public fighterAddressess;
98 
99     struct Bet {
100         uint256 stake;
101         bool withdrawn;
102     }
103 
104     mapping(address => mapping(address => Bet)) public bets;
105     mapping(address => address[]) public bettersForFighter;
106     mapping(address => uint256) public totalForFighter;
107 
108     uint256 public amount;
109 
110     event StateChanged(uint8 _state);
111     event ReceivedMoney(address _betterAddress, address _fighterAddress, uint256 _stake);
112 
113     function deposit() public payable requireState(1) {
114     }
115 
116     constructor() public {
117         state = 0;
118         addFighter(new Fighter("Khabib", minBetAmount));
119         addFighter(new Fighter("McGregor", minBetAmount));
120     }
121 
122     function getTotalBettersForFighter(address _address) external view returns (uint256) {
123         return bettersForFighter[_address].length;
124     }
125 
126     function startEvent() external onlyOwner requireState(0) {
127         state = 1;
128         for (uint8 i = 0; i < fighterAddressess.length; i++) {
129             Fighter(fighterAddressess[i]).changeState(state);
130             Fighter(fighterAddressess[i]).transferMoneyToOwner();
131         }
132         emit StateChanged(state);
133     }
134 
135     function refundEverybody() external onlyOwner requireState(1) {
136         state = 3;
137         emit StateChanged(state);
138     }
139 
140     function addFighter(address _address) private requireState(0) {
141         fighterAddressess.push(Fighter(_address));
142     }
143 
144     function checkValidFighter(address _address) private view returns (bool) {
145         for (uint8 i = 0; i < fighterAddressess.length; i++) {
146             if (_address == fighterAddressess[i]) {
147                 return true;
148             }
149         }
150         return false;
151     }
152 
153     function addBet(uint256 _stake, address _betterAddress) external {
154         require(checkValidFighter(msg.sender));
155         if (bets[msg.sender][_betterAddress].stake > 0) {
156             bets[msg.sender][_betterAddress].stake = bets[msg.sender][_betterAddress].stake.add(_stake);
157         } else {
158             bettersForFighter[msg.sender].push(_betterAddress);
159             bets[msg.sender][_betterAddress] = Bet(_stake, false);
160         }
161         amount = amount.add(_stake);
162         totalForFighter[msg.sender] = totalForFighter[msg.sender].add(_stake);
163         emit ReceivedMoney(_betterAddress, msg.sender, _stake);
164     }
165 
166     function totalWagered() public constant returns (uint256) {
167         return amount;
168     }
169 
170     function totalRake() public constant returns (uint256) {
171         return totalWagered().mul(percentRake).div(100);
172     }
173 
174     function totalPrizePool() public constant returns (uint256) {
175         return totalWagered().sub(totalRake());
176     }
177 
178     function declareWininingFighter(address _fighterAddress) external onlyOwner requireState(1) {
179         require(checkValidFighter(_fighterAddress));
180         state = 2;
181         winningFighter = _fighterAddress;
182         emit StateChanged(state);
183     }
184 
185     function withdrawRake() external onlyOwner requireState(2) {
186         require(!hasWithdrawnRake);
187         hasWithdrawnRake = true;
188         owner.transfer(totalRake());
189     }
190 
191     function withdraw(address _betterAddress) public requireState(2) {
192         require(bets[winningFighter][_betterAddress].stake > 0);
193         require(!bets[winningFighter][_betterAddress].withdrawn);
194         address(_betterAddress).transfer(totalPrizePool().mul(bets[winningFighter][_betterAddress].stake).div(totalForFighter[winningFighter]));
195         bets[winningFighter][_betterAddress].withdrawn = true;
196     }
197 
198     function refund(address _betterAddress) external requireState(3) {
199         uint256 stake = 0;
200         for (uint8 i = 0; i < fighterAddressess.length; i++) {
201             if (bets[fighterAddressess[i]][_betterAddress].stake > 0 && !bets[fighterAddressess[i]][_betterAddress].withdrawn) {
202                 bets[fighterAddressess[i]][_betterAddress].withdrawn = true;
203                 stake = stake.add(bets[fighterAddressess[i]][_betterAddress].stake);
204             }
205         }
206         if (stake > 0) {
207             address(_betterAddress).transfer(stake);
208         }
209     }
210 
211 }