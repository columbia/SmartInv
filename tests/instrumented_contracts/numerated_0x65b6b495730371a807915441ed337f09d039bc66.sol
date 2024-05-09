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
20     address public deusETH;
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
57 
58         require(gain != 0);
59         require(this.balance >= gain);
60 
61         totalPayments = totalPayments.add(gain);
62         payments[_id] = true;
63 
64         winner.transfer(gain);
65     }
66 
67     function setLottery(address _lottery) public onlyOwner {
68         require(!started);
69         lottery = InterfaceDeusETH(_lottery);
70         deusETH = _lottery;
71         started = true;
72     }
73 
74     function getTeamSalary() public onlyOwner {
75         require(!salarySent);
76         require(lottery.gameOver());
77         require(!lottery.gameOverByUser());
78         salarySent = true;
79         weiReceived = this.balance;
80         uint256 salary = weiReceived/10;
81         weiReceived = weiReceived.sub(salary);
82         owner.transfer(salary);
83     }
84 
85     function weiReceive() internal {
86         Bank(this.balance, msg.value);
87     }
88 
89     function calcGain() internal returns (uint256) {
90         if (lottery.gameOverByUser() && (weiReceived == 0)) {
91             weiReceived = this.balance;
92         }
93         return weiReceived/lottery.livingSupply();
94     }
95 }
96 
97 
98 library SafeMath {
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a * b;
101         assert(a == 0 || c / a == b);
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a / b;
107         return c;
108     }
109 
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         assert(b <= a);
112         return a - b;
113     }
114 
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         assert(c >= a);
118         return c;
119     }
120 }