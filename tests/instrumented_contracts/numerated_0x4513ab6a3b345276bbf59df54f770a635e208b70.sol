1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, reverts on overflow.
7     */
8     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (_a == 0) {
13             return 0;
14         }
15 
16         uint256 c = _a * _b;
17         require(c / _a == _b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         require(_b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = _a / _b;
28         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
37         require(_b <= _a);
38         uint256 c = _a - _b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two numbers, reverts on overflow.
45     */
46     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract FiftyFifty{
64     using SafeMath for uint; // using SafeMath
65     //rate to 0.125 ETH.  0.125:1, 0.250:2, 0.500:4, 1.00:8, 2.00:16, 4.00:32, 8.00: 64, 16.00:128, 32.00:256, 64.00:512
66     uint[11] betValues = [0.125 ether, 0.250 ether, 0.500 ether, 1.00 ether, 2.00 ether, 4.00 ether, 8.00 ether, 16.00 ether, 32.00 ether, 64.00 ether];
67     // return value is 95 % of two people.
68     uint[11] returnValues = [0.2375 ether, 0.475 ether, 0.950 ether, 1.90 ether, 3.80 ether, 7.60 ether, 15.20 ether, 30.40 ether, 60.80 ether, 121.60 ether];
69     // jackpot value is 4 % of total value
70     uint[11] jackpotValues = [0.05 ether, 0.010 ether, 0.020 ether, 0.04 ether, 0.08 ether, 0.16 ether, 0.32 ether, 0.64 ether, 1.28 ether, 2.56 ether];
71     // fee 1 %
72     uint[11] fees = [0.0025 ether, 0.005 ether, 0.010 ether, 0.020 ether, 0.040 ether, 0.080 ether, 0.16 ether, 0.32 ether, 0.64 ether, 1.28 ether];
73     uint roundNumber; // number of round that jackpot is paid
74     mapping(uint => uint) jackpot;
75     //round -> betValue -> user address
76     mapping(uint => mapping(uint => address[])) roundToBetValueToUsers;
77     //round -> betValue -> totalBet
78     mapping(uint => mapping(uint => uint)) roundToBetValueToTotalBet;
79     //round -> totalBet
80     mapping(uint => uint) public roundToTotalBet;
81     // current user who bet for the value
82     mapping(uint => address) currentUser;
83     address owner;
84     uint ownerDeposit;
85 
86     // Event
87     event Jackpot(address indexed _user, uint _value, uint indexed _round, uint _now);
88     event Bet(address indexed _winner,address indexed _user,uint _bet, uint _payBack, uint _now);
89 
90 
91     constructor() public {
92         owner = msg.sender;
93         roundNumber = 1;
94     }
95 
96     modifier onlyOwner () {
97         require(msg.sender == owner);
98         _;
99     }
100 
101     function changeOwner(address _owner) external onlyOwner{
102         owner = _owner;
103     }
104 
105     // fallback function that
106 
107     function() public payable {
108         // check if msg.value is equal to specified amount of value.
109         uint valueNumber = checkValue(msg.value);
110         /**
111             jackpot starts when block hash % 10000 < 0
112         */
113         uint randJackpot = (uint(blockhash(block.number - 1)) + roundNumber) % 10000;
114         if(jackpot[roundNumber] != 0 && randJackpot <= 1){
115             // Random number that is under contract total bet amount
116             uint randJackpotBetValue = uint(blockhash(block.number - 1)) % roundToTotalBet[roundNumber];
117             //betNum
118             uint betNum=0;
119             uint addBetValue = 0;
120             // Loop until addBetValue exceeds randJackpotBetValue
121             while(randJackpotBetValue > addBetValue){
122                 // Select bet number which is equal to
123                 addBetValue += roundToBetValueToTotalBet[roundNumber][betNum];
124                 betNum++;
125             }
126             //  betNum.sub(1)のindexに含まれているuserの数未満のランダム番号を生成する
127             uint randJackpotUser = uint(blockhash(block.number - 1)) % roundToBetValueToUsers[roundNumber][betNum.sub(1)].length;
128             address user = roundToBetValueToUsers[roundNumber][valueNumber][randJackpotUser];
129             uint jp = jackpot[roundNumber];
130             user.transfer(jp);
131             emit Jackpot(user, jp, roundNumber, now);
132             roundNumber = roundNumber.add(1);
133         }
134         if(currentUser[valueNumber] == address(0)){
135             //when current user does not exists
136             currentUser[valueNumber] = msg.sender;
137             emit Bet(address(0), msg.sender, betValues[valueNumber], 0, now);
138         }else{
139             // when current user exists
140             uint rand = uint(blockhash(block.number-1)) % 2;
141             ownerDeposit = ownerDeposit.add(fees[valueNumber]);
142             if(rand == 0){
143                 // When the first user win
144                 currentUser[valueNumber].transfer(returnValues[valueNumber]);
145                 emit Bet(currentUser[valueNumber], msg.sender, betValues[valueNumber], returnValues[valueNumber], now);
146             }else{
147                 // When the last user win
148                 msg.sender.transfer(returnValues[valueNumber]);
149                 emit Bet(msg.sender, msg.sender, betValues[valueNumber], returnValues[valueNumber], now);
150             }
151             // delete current user
152             delete currentUser[valueNumber];
153         }
154         // common in each contracts
155         jackpot[roundNumber] = jackpot[roundNumber].add(jackpotValues[valueNumber]);
156         roundToBetValueToUsers[roundNumber][valueNumber].push(currentUser[valueNumber]);
157         roundToTotalBet[roundNumber] = roundToTotalBet[roundNumber].add(betValues[valueNumber]);
158         roundToBetValueToTotalBet[roundNumber][valueNumber] = roundToBetValueToTotalBet[roundNumber][valueNumber].add(betValues[valueNumber]);
159     }
160 
161     /**
162         @param sendValue is ETH that is sent to this contract.
163         @return num is index that represent value that is sent.
164     */
165     function checkValue(uint sendValue) internal view returns(uint) {
166         /**
167             Check sendValue is match prepared values. Revert if sendValue doesn't match any values.
168         */
169         uint num = 0;
170         while (sendValue != betValues[num]){
171             if(num == 11){
172                 revert();
173             }
174             num++;
175         }
176         return num;
177     }
178 
179     function roundToBetValueToUsersLength(uint _roundNum, uint _betNum) public view returns(uint){
180         return roundToBetValueToUsers[_roundNum][_betNum].length;
181     }
182 
183     function withdrawDeposit() public onlyOwner{
184         owner.transfer(ownerDeposit);
185         ownerDeposit = 0;
186     }
187 
188     function currentJackpot() public view  returns(uint){
189         return jackpot[roundNumber];
190     }
191 
192 }