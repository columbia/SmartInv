1 pragma solidity 0.4.19;
2 
3 
4 contract InterfaceDeusETH {
5     bool public gameOver;
6     bool public gameOverByUser;
7     function totalSupply() public view returns (uint256);
8     function livingSupply() public view returns (uint256);
9     function getState(uint256 _id) public returns (uint256);
10     function getHolder(uint256 _id) public returns (address);
11 }
12 
13 
14 contract FundsKeeper {
15     using SafeMath for uint256;
16     InterfaceDeusETH private lottery = InterfaceDeusETH(0x0);
17     bool public started = false;
18 
19     // address of tokens
20     address public deuseth;
21 
22     uint256 public weiReceived;
23 
24     // address of team
25     address public owner;
26     bool public salarySent = false;
27 
28     uint256 public totalPayments = 0;
29 
30     mapping(uint256 => bool) public payments;
31 
32     event Bank(uint256 indexed _sum, uint256 indexed _add);
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function FundsKeeper(address _owner) public {
40         require(_owner != address(0));
41         owner = _owner;
42     }
43 
44     function () external payable {
45         weiReceive();
46     }
47 
48     function getGain(uint256 _id) public {
49         require((lottery.gameOver() && salarySent) || lottery.gameOverByUser());
50         require(lottery.getHolder(_id) == msg.sender);
51         require(lottery.getState(_id) == 1); //living token only
52         require(payments[_id] == false);
53 
54         address winner = msg.sender;
55 
56         uint256 gain = calcGain();
57         require(gain != 0);
58         require(this.balance >= gain);
59 
60         totalPayments = totalPayments.add(gain);
61         payments[_id] = true;
62 
63         winner.transfer(gain);
64     }
65 
66     function setLottery(address _lottery) public onlyOwner {
67         require(!started);
68         lottery = InterfaceDeusETH(_lottery);
69         deuseth = _lottery;
70         started = true;
71     }
72 
73     function getTeamSalary() public onlyOwner {
74         require(!salarySent);
75         require(msg.sender == owner);
76         require(lottery.gameOver());
77         salarySent = true;
78         weiReceived = this.balance;
79         uint256 salary = weiReceived/10;
80         weiReceived = weiReceived.sub(salary);
81         owner.transfer(salary);
82     }
83 
84     function weiReceive() internal {
85         Bank(this.balance, msg.value);
86     }
87 
88     function calcGain() internal returns (uint256) {
89         if (lottery.gameOverByUser() && (weiReceived == 0)) {
90             weiReceived = this.balance;
91         }
92         return weiReceived/lottery.livingSupply();
93     }
94 }
95 
96 
97 library SafeMath {
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a * b;
100         assert(a == 0 || c / a == b);
101         return c;
102     }
103 
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a / b;
106         return c;
107     }
108 
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         assert(b <= a);
111         return a - b;
112     }
113 
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         assert(c >= a);
117         return c;
118     }
119 }