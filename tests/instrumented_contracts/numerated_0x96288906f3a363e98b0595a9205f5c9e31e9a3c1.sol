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
16     InterfaceDeusETH public deusETH = InterfaceDeusETH(0x0);
17     bool public started = false;
18 
19     uint256 public weiReceived;
20 
21     // address of team
22     address public owner;
23     bool public salarySent = false;
24 
25     uint256 public totalPayments = 0;
26 
27     mapping(uint256 => bool) public payments;
28 
29     event Bank(uint256 indexed _sum, uint256 indexed _add);
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function FundsKeeper(address _owner) public {
37         require(_owner != address(0));
38         owner = _owner;
39     }
40 
41     function () external payable {
42         weiReceive();
43     }
44 
45     function getGain(uint256 _id) public {
46         require((deusETH.gameOver() && salarySent) || deusETH.gameOverByUser());
47         require(deusETH.getHolder(_id) == msg.sender);
48         require(deusETH.getState(_id) == 1); //living token only
49         require(payments[_id] == false);
50 
51         address winner = msg.sender;
52 
53         uint256 gain = calcGain();
54 
55         require(gain != 0);
56         require(this.balance >= gain);
57 
58         totalPayments = totalPayments.add(gain);
59         payments[_id] = true;
60 
61         winner.transfer(gain);
62     }
63 
64     function setLottery(address _deusETH) public onlyOwner {
65         require(!started);
66         deusETH = InterfaceDeusETH(_deusETH);
67         started = true;
68     }
69 
70     function getTeamSalary() public onlyOwner returns (bool) {
71         require(!salarySent);
72         require(deusETH.gameOver());
73         require(!deusETH.gameOverByUser());
74         salarySent = true;
75         weiReceived = this.balance;
76         uint256 salary = weiReceived/10;
77         weiReceived = weiReceived.sub(salary);
78         owner.transfer(salary);
79         return true;
80     }
81 
82     function changeLottery(address _deusETH) onlyOwner public {
83         deusETH = InterfaceDeusETH(_deusETH);
84     }
85 
86     function checkPayments(uint _id) public view returns (bool) {
87         return payments[_id];
88     }
89 
90     function changeOwner(address _newOwner) public onlyOwner returns (bool) {
91         require(_newOwner != address(0));
92         owner = _newOwner;
93         return true;
94     }
95 
96     function weiReceive() internal {
97         Bank(this.balance, msg.value);
98     }
99 
100     function calcGain() internal returns (uint256) {
101         if (deusETH.gameOverByUser() && (weiReceived == 0)) {
102             weiReceived = this.balance;
103         }
104         return weiReceived/deusETH.livingSupply();
105     }
106 }
107 
108 
109 library SafeMath {
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a * b;
112         assert(a == 0 || c / a == b);
113         return c;
114     }
115 
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a / b;
118         return c;
119     }
120 
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         assert(b <= a);
123         return a - b;
124     }
125 
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         assert(c >= a);
129         return c;
130     }
131 }