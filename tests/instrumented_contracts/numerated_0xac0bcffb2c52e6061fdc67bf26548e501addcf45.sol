1 pragma solidity ^0.4.18;
2 
3 contract BCSToken {
4     
5     function BCSToken() internal {}
6     function transfer(address _to, uint256 _value) public {}
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
8 
9 }
10 
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return a / b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract investment{
58     using SafeMath for uint;
59     
60     address public owner;
61     mapping (address => uint) private amount;
62     mapping (address => uint) private day;
63     mapping (address => uint) private dateDeposit;
64     mapping (address => uint) private rewardPerYear;
65     mapping (address => uint) private outcome;
66     
67     struct a{
68         uint aday;
69         uint adateDeposit;
70         uint aamount;
71     }
72     BCSToken dc;
73     function investment(address _t) public {
74         dc = BCSToken(_t);
75         owner = msg.sender;
76     }
77     function Datenow () public view returns (uint timeNow){
78         return block.timestamp;
79     }
80     
81     
82     function calculate(address _user) private returns (bool status) {
83         uint _amount =amount[_user];
84         uint _day =day[_user];
85         uint _rewardPerYear = 1000;
86 
87 
88         if(_day == 90 && _amount >= SafeMath.mul(1000000,10**8)){
89             _rewardPerYear = 180;
90         }else if(_day == 60 && _amount >= SafeMath.mul(1000000,10**8)){
91             _rewardPerYear = 160;
92         }else if(_day == 90 && _amount >= SafeMath.mul(800000,10**8)){
93             _rewardPerYear = 140;
94         }else if(_day == 60 && _amount >= SafeMath.mul(800000,10**8)){
95             _rewardPerYear = 120;
96         }else if(_day == 90 && _amount >= SafeMath.mul(500000,10**8)){
97             _rewardPerYear = 100;
98         }else if(_day == 60 && _amount >= SafeMath.mul(500000,10**8)){
99             _rewardPerYear = 80;
100         }else if(_day == 90 && _amount >= SafeMath.mul(300000,10**8)){
101             _rewardPerYear = 60;
102         }else if(_day == 60 && _amount >= SafeMath.mul(300000,10**8)){
103             _rewardPerYear = 40;
104         }else if(_day == 30 && _amount >= SafeMath.mul(50001,10**8)){
105             _rewardPerYear = 15;
106         }else if(_day == 60 && _amount >= SafeMath.mul(50001,10**8)){ 
107             _rewardPerYear = 25;
108         }else if(_day == 90 && _amount >= SafeMath.mul(50001,10**8)){
109             _rewardPerYear = 45;
110         }else if(_day == 30 && _amount >= SafeMath.mul(10001,10**8)){
111             _rewardPerYear = 5;
112         }else if(_day == 60 && _amount >= SafeMath.mul(10001,10**8)){
113             _rewardPerYear = 15;
114         }else if(_day == 90 && _amount >= SafeMath.mul(10001,10**8)){
115             _rewardPerYear = 25;
116         }else{
117             return false;
118         }
119         
120         rewardPerYear[_user]=_rewardPerYear;
121         outcome[_user] = SafeMath.add((SafeMath.div(SafeMath.mul(SafeMath.mul((_amount), rewardPerYear[_user]), _day), 365000)), _amount);
122         return true;
123     }
124     
125     function _withdraw(address _user) private returns (bool result){
126         
127         require(timeLeft(_user) == 0);
128         dc.transfer(_user, outcome[_user]);
129         amount[_user] = 0;
130         day[_user] = 0;
131         dateDeposit[_user] = 0;
132         rewardPerYear[_user] = 0;
133         outcome[_user] = 0;
134         return true;
135     }
136     
137     function timeLeft(address _user) view private returns (uint result){
138         
139         uint temp = SafeMath.add(SafeMath.mul(SafeMath.mul(SafeMath.mul(60,60),24),day[_user]),dateDeposit[_user]); // for mainnet (day-month)
140         if(now >= temp){
141             return 0;
142         }else{
143             return SafeMath.sub(temp,now);
144         }
145     }
146     
147     function deposit(uint _amount, uint _day) public returns (bool result){
148         require(amount[msg.sender]==0);
149         require(( _day == 90 || _day == 60 || _day == 30));
150         require(_amount >= SafeMath.mul(10001,10**8));
151         dc.transferFrom(msg.sender, this, _amount);
152         amount[msg.sender] = _amount;
153         day[msg.sender] = _day;
154         dateDeposit[msg.sender] = now;
155         calculate(msg.sender);
156         return true;
157     }
158     function withdraw(address _user) public returns (bool result) {
159         require(owner == msg.sender);
160         return _withdraw(_user);
161         
162     }
163     
164     function withdraw() public returns (bool result){
165         return _withdraw(msg.sender);
166     }
167     
168     function info(address _user) public view returns (uint principle, uint secondLeft, uint annualized, uint returnInvestment, uint packetDay, uint timestampDeposit){
169         return (amount[_user],timeLeft(_user),rewardPerYear[_user],outcome[_user],day[_user],dateDeposit[_user] );
170     }
171 
172 }