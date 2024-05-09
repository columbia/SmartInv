1 pragma solidity 0.4.12;
2 
3 contract AbstractSweeper {
4     function sweep(address token, uint amount) returns (bool);
5 
6     function () { throw; }
7 
8     BitslerController controller;
9 
10     function AbstractSweeper(address _controller) {
11         controller = BitslerController(_controller);
12     }
13 
14     modifier canSweep() {
15         if (msg.sender != controller.authorizedCaller() && msg.sender != controller.owner() && msg.sender != controller.dev()) throw;
16         if (controller.halted()) throw;
17         _;
18     }
19 }
20 
21 contract Token {
22     function balanceOf(address a) returns (uint) {
23         (a);
24         return 0;
25     }
26 
27     function transfer(address a, uint val) returns (bool) {
28         (a);
29         (val);
30         return false;
31     }
32 }
33 
34 contract DefaultSweeper is AbstractSweeper {
35     function DefaultSweeper(address controller)
36              AbstractSweeper(controller) {}
37 
38     function sweep(address _token, uint _amount)
39     canSweep
40     returns (bool) {
41         bool success = false;
42         address destination = controller.destination();
43 
44         if (_token != address(0)) {
45             Token token = Token(_token);
46             uint amount = _amount;
47             if (amount > token.balanceOf(this)) {
48                 return false;
49             }
50             token.transfer(destination, amount);
51             success = true;
52         }
53         else {
54             uint amountInWei = _amount;
55             if (amountInWei > this.balance) {
56                 return false;
57             }
58 
59             success = destination.send(amountInWei);
60         }
61 
62         if (success) {
63             controller.logSweep(this, destination, _token, _amount);
64         }
65         return success;
66     }
67 }
68 
69 contract UserWallet {
70     AbstractSweeperList sweeperList;
71     function UserWallet(address _sweeperlist) {
72         sweeperList = AbstractSweeperList(_sweeperlist);
73     }
74 
75     function () public payable { }
76 
77     function tokenFallback(address _from, uint _value, bytes _data) {
78         (_from);
79         (_value);
80         (_data);
81      }
82 
83     function sweep(address _token, uint _amount)
84     returns (bool) {
85         (_amount);
86         return sweeperList.sweeperOf(_token).delegatecall(msg.data);
87     }
88 }
89 
90 contract AbstractSweeperList {
91     function sweeperOf(address _token) returns (address);
92 }
93 
94 contract BitslerController is AbstractSweeperList {
95     address public owner;
96     address public authorizedCaller;
97     address public dev = 0x4c1C78a66a3F5C0E4D1DacAeE0608816FCA0C461;
98     address public destination;
99 
100     bool public halted;
101 
102     event LogNewWallet(address receiver);
103     event LogSweep(address indexed from, address indexed to, address indexed token, uint amount);
104     
105     modifier onlyOwner() {
106         if (msg.sender != owner) throw; 
107         _;
108     }
109 
110     modifier onlyAdmins() {
111         if (msg.sender != authorizedCaller && msg.sender != owner && msg.sender != dev) throw; 
112         _;
113     }
114 
115     function BitslerController() 
116     {
117         owner = msg.sender;
118         destination = msg.sender;
119         authorizedCaller = msg.sender;
120     }
121 
122     function changeAuthorizedCaller(address _newCaller) onlyOwner {
123         authorizedCaller = _newCaller;
124     }
125 
126     function changeDestination(address _dest) onlyOwner {
127         destination = _dest;
128     }
129 
130     function changeOwner(address _owner) onlyOwner {
131         owner = _owner;
132     }
133 
134     function makeWallet() onlyAdmins returns (address wallet)  {
135         wallet = address(new UserWallet(this));
136         LogNewWallet(wallet);
137     }
138 
139     function halt() onlyAdmins {
140         halted = true;
141     }
142 
143     function start() onlyOwner {
144         halted = false;
145     }
146 
147     address public defaultSweeper = address(new DefaultSweeper(this));
148     mapping (address => address) sweepers;
149 
150     function addSweeper(address _token, address _sweeper) onlyOwner {
151         sweepers[_token] = _sweeper;
152     }
153 
154     function sweeperOf(address _token) returns (address) {
155         address sweeper = sweepers[_token];
156         if (sweeper == 0) sweeper = defaultSweeper;
157         return sweeper;
158     }
159 
160     function logSweep(address from, address to, address token, uint amount) {
161         LogSweep(from, to, token, amount);
162     }
163 }