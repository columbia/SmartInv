1 pragma solidity ^0.4.10;
2 
3 // Copyright 2017 Bittrex
4 
5 contract AbstractSweeper {
6     function sweep(address token, uint amount) returns (bool);
7 
8     function () { throw; }
9 
10     Controller controller;
11 
12     function AbstractSweeper(address _controller) {
13         controller = Controller(_controller);
14     }
15 
16     modifier canSweep() {
17         if (msg.sender != controller.authorizedCaller() && msg.sender != controller.owner()) throw;
18         if (controller.halted()) throw;
19         _;
20     }
21 }
22 
23 contract Token {
24     function balanceOf(address a) returns (uint) {
25         (a);
26         return 0;
27     }
28 
29     function transfer(address a, uint val) returns (bool) {
30         (a);
31         (val);
32         return false;
33     }
34 }
35 
36 contract DefaultSweeper is AbstractSweeper {
37     function DefaultSweeper(address controller)
38              AbstractSweeper(controller) {}
39 
40     function sweep(address _token, uint _amount)
41     canSweep
42     returns (bool) {
43         bool success = false;
44         address destination = controller.destination();
45 
46         if (_token != address(0)) {
47             Token token = Token(_token);
48             uint amount = _amount;
49             if (amount > token.balanceOf(this)) {
50                 return false;
51             }
52 
53             success = token.transfer(destination, amount);
54         }
55         else {
56             uint amountInWei = _amount;
57             if (amountInWei > this.balance) {
58                 return false;
59             }
60 
61             success = destination.send(amountInWei);
62         }
63 
64         if (success) {
65             controller.logSweep(this, destination, _token, _amount);
66         }
67         return success;
68     }
69 }
70 
71 contract UserWallet {
72     AbstractSweeperList sweeperList;
73     function UserWallet(address _sweeperlist) {
74         sweeperList = AbstractSweeperList(_sweeperlist);
75     }
76 
77     function () public payable { }
78 
79     function tokenFallback(address _from, uint _value, bytes _data) {
80         (_from);
81         (_value);
82         (_data);
83      }
84 
85     function sweep(address _token, uint _amount)
86     returns (bool) {
87         (_amount);
88         return sweeperList.sweeperOf(_token).delegatecall(msg.data);
89     }
90 }
91 
92 contract AbstractSweeperList {
93     function sweeperOf(address _token) returns (address);
94 }
95 
96 contract Controller is AbstractSweeperList {
97     address public owner;
98     address public authorizedCaller;
99 
100     address public destination;
101 
102     bool public halted;
103 
104     event LogNewWallet(address receiver);
105     event LogSweep(address indexed from, address indexed to, address indexed token, uint amount);
106     
107     modifier onlyOwner() {
108         if (msg.sender != owner) throw; 
109         _;
110     }
111 
112     modifier onlyAuthorizedCaller() {
113         if (msg.sender != authorizedCaller) throw; 
114         _;
115     }
116 
117     modifier onlyAdmins() {
118         if (msg.sender != authorizedCaller && msg.sender != owner) throw; 
119         _;
120     }
121 
122     function Controller() 
123     {
124         owner = msg.sender;
125         destination = msg.sender;
126         authorizedCaller = msg.sender;
127     }
128 
129     function changeAuthorizedCaller(address _newCaller) onlyOwner {
130         authorizedCaller = _newCaller;
131     }
132 
133     function changeDestination(address _dest) onlyOwner {
134         destination = _dest;
135     }
136 
137     function changeOwner(address _owner) onlyOwner {
138         owner = _owner;
139     }
140 
141     function makeWallet() onlyAdmins returns (address wallet)  {
142         wallet = address(new UserWallet(this));
143         LogNewWallet(wallet);
144     }
145 
146     function halt() onlyAdmins {
147         halted = true;
148     }
149 
150     function start() onlyOwner {
151         halted = false;
152     }
153 
154     address public defaultSweeper = address(new DefaultSweeper(this));
155     mapping (address => address) sweepers;
156 
157     function addSweeper(address _token, address _sweeper) onlyOwner {
158         sweepers[_token] = _sweeper;
159     }
160 
161     function sweeperOf(address _token) returns (address) {
162         address sweeper = sweepers[_token];
163         if (sweeper == 0) sweeper = defaultSweeper;
164         return sweeper;
165     }
166 
167     function logSweep(address from, address to, address token, uint amount) {
168         LogSweep(from, to, token, amount);
169     }
170 }