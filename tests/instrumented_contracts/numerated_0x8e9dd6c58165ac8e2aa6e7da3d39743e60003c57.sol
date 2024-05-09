1 pragma solidity ^0.4.4;
2 
3 //copyright 2017 NewAlchemy
4 //Written by Dennis Peterson
5 
6 contract AbstractSweeper {
7     //abstract:
8     function sweep(address token, uint amount) returns (bool);
9 
10     //concrete:
11     function () { throw; }
12 
13     Controller controller;
14 
15     function AbstractSweeper(address _controller) {
16         controller = Controller(_controller);
17     }
18 
19     modifier canSweep() {
20         if (msg.sender != controller.authorizedCaller() && msg.sender != controller.owner()) throw;
21         if (controller.halted()) throw;
22         _;
23     }
24 }
25 
26 contract Token {
27     function balanceOf(address a) returns (uint) {return 0;}
28     function transfer(address a, uint val) returns (bool) {return false;}
29 }
30 
31 contract DefaultSweeper is AbstractSweeper {
32     function DefaultSweeper(address controller) 
33              AbstractSweeper(controller) {}
34 
35     function sweep(address _token, uint _amount)  
36     canSweep
37     returns (bool) {
38         Token token = Token(_token);
39         uint amount = _amount;
40         if (amount > token.balanceOf(this)) amount = token.balanceOf(this);
41 
42         address destination = controller.destination();
43 
44 	// Because sweep is called with delegatecall, this typically
45 	// comes from the UserWallet.
46         bool success = token.transfer(destination, amount); 
47         if (success) { 
48             controller.logSweep(this, _token, _amount);
49         } else { 
50 	    controller.logFailedSweep(msg.sender, _token, _amount);
51 	}
52         return success;
53     }
54 }
55 
56 contract UserWallet {
57     AbstractSweeperList c;
58     function UserWallet(address _sweeperlist) {
59         c = AbstractSweeperList(_sweeperlist);
60     }
61 
62     function sweep(address _token, uint _amount) 
63     returns (bool) {
64         return c.sweeperOf(_token).delegatecall(msg.data);
65     }
66 }
67 
68 contract AbstractSweeperList {
69     function sweeperOf(address _token) returns (address);
70 }
71 
72 contract Controller is AbstractSweeperList {
73     address public owner;
74     address public authorizedCaller;
75 
76     //destination defaults to same as owner
77     //but is separate to allow never exposing cold storage
78     address public destination; 
79 
80     bool public halted;
81 
82     event LogNewWallet(uint _customer, address receiver);
83     event LogSweep(address from, address token, uint amount);
84     event LogFailedSweep(address from, address token, uint amount);
85     
86     modifier onlyOwner() {
87         if (msg.sender != owner) throw; 
88         _;
89     }
90 
91     modifier onlyAuthorizedCaller() {
92         if (msg.sender != authorizedCaller) throw; 
93         _;
94     }
95 
96     modifier onlyAdmins() {
97         if (msg.sender != authorizedCaller && msg.sender != owner) throw; 
98         _;
99     }
100 
101     function Controller() 
102     {
103         owner = msg.sender;
104         destination = msg.sender;
105         authorizedCaller = msg.sender;
106     }
107 
108     function changeAuthorizedCaller(address _newCaller) onlyOwner {
109         authorizedCaller = _newCaller;
110     }
111 
112     function changeDestination(address _dest) onlyOwner {
113         destination = _dest;
114     }
115 
116     function changeOwner(address _owner) onlyOwner {
117         owner = _owner;
118     }
119 
120     function makeWallet(uint _customer) onlyAdmins returns (address wallet)  {
121         wallet = address(new UserWallet(this));
122         LogNewWallet(_customer, wallet);
123     }
124 
125     //assuming halt because caller is compromised
126     //so let caller stop for speed, only owner can restart
127 
128     function halt() onlyAdmins {
129         halted = true;
130     }
131 
132     function start() onlyOwner {
133         halted = false;
134     }
135 
136     //***********
137     //SweeperList
138     //***********
139     address public defaultSweeper = address(new DefaultSweeper(this));
140     mapping (address => address) sweepers;
141 
142     function addSweeper(address _token, address _sweeper) onlyOwner {
143         sweepers[_token] = _sweeper;
144     }
145 
146     function sweeperOf(address _token) returns (address) {
147         address sweeper = sweepers[_token];
148         if (sweeper == 0) sweeper = defaultSweeper;
149         return sweeper;
150     }
151 
152     function logSweep(address from, address token, uint amount) {
153         LogSweep(from, token, amount);
154     }
155     function logFailedSweep(address from, address token, uint amount) {
156         LogFailedSweep(from, token, amount);
157     }
158 }