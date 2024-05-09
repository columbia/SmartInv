1 pragma solidity ^0.4.10;
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
40         if (amount > token.balanceOf(this)) {
41             return false;
42         }
43 
44         address destination = controller.destination();
45 
46 	// Because sweep is called with delegatecall, this typically
47 	// comes from the UserWallet.
48         bool success = token.transfer(destination, amount); 
49         if (success) { 
50             controller.logSweep(this, _token, _amount);
51         } 
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
82     event LogNewWallet(address receiver);
83     event LogSweep(address from, address token, uint amount);
84     
85     modifier onlyOwner() {
86         if (msg.sender != owner) throw; 
87         _;
88     }
89 
90     modifier onlyAuthorizedCaller() {
91         if (msg.sender != authorizedCaller) throw; 
92         _;
93     }
94 
95     modifier onlyAdmins() {
96         if (msg.sender != authorizedCaller && msg.sender != owner) throw; 
97         _;
98     }
99 
100     function Controller() 
101     {
102         owner = msg.sender;
103         destination = msg.sender;
104         authorizedCaller = msg.sender;
105     }
106 
107     function changeAuthorizedCaller(address _newCaller) onlyOwner {
108         authorizedCaller = _newCaller;
109     }
110 
111     function changeDestination(address _dest) onlyOwner {
112         destination = _dest;
113     }
114 
115     function changeOwner(address _owner) onlyOwner {
116         owner = _owner;
117     }
118 
119     function makeWallet() onlyAdmins returns (address wallet)  {
120         wallet = address(new UserWallet(this));
121         LogNewWallet(wallet);
122     }
123 
124     //assuming halt because caller is compromised
125     //so let caller stop for speed, only owner can restart
126 
127     function halt() onlyAdmins {
128         halted = true;
129     }
130 
131     function start() onlyOwner {
132         halted = false;
133     }
134 
135     //***********
136     //SweeperList
137     //***********
138     address public defaultSweeper = address(new DefaultSweeper(this));
139     mapping (address => address) sweepers;
140 
141     function addSweeper(address _token, address _sweeper) onlyOwner {
142         sweepers[_token] = _sweeper;
143     }
144 
145     function sweeperOf(address _token) returns (address) {
146         address sweeper = sweepers[_token];
147         if (sweeper == 0) sweeper = defaultSweeper;
148         return sweeper;
149     }
150 
151     function logSweep(address from, address token, uint amount) {
152         LogSweep(from, token, amount);
153     }
154 }