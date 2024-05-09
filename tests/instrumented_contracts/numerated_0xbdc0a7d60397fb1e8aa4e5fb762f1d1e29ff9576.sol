1 pragma solidity ^0.4.24;
2 
3 contract AbstractSweeper {
4     function sweepAll(address token) public returns (bool);
5 
6     function() public { revert(); }
7 
8     Controller controller;
9 
10     constructor(address _controller) public {
11         controller = Controller(_controller);
12     }
13 
14     modifier canSweep() {
15         if(msg.sender != controller.authorizedCaller() && msg.sender != controller.owner()){ revert(); }
16         if(controller.halted()){ revert(); }
17         _;
18     }
19 }
20 
21 contract Token {
22     function balanceOf(address a) public pure returns (uint) {
23         (a);
24         return 0;
25     }
26 
27     function transfer(address a, uint val) public pure returns (bool) {
28         (a);
29         (val);
30         return false;
31     }
32 }
33 
34 contract DefaultSweeper is AbstractSweeper {
35     constructor(address controller) AbstractSweeper(controller) public { }
36 
37     function sweepAll(address _token) public canSweep returns (bool) {
38         bool success = false;
39         address destination = controller.destination();
40 
41         if(_token != address(0)){
42             Token token = Token(_token);
43             success = token.transfer(destination, token.balanceOf(this));
44         }else{
45             success = destination.send(address(this).balance);
46         }
47         return success;
48     }
49 }
50 
51 contract UserWallet {
52     AbstractSweeperList sweeperList;
53     constructor(address _sweeperlist) public {
54         sweeperList = AbstractSweeperList(_sweeperlist);
55     }
56 
57     function() public payable { }
58 
59     function tokenFallback(address _from, uint _value, bytes _data) public pure {
60         (_from);
61         (_value);
62         (_data);
63     }
64 
65     function sweepAll(address _token) public returns (bool) {
66         return sweeperList.sweeperOf(_token).delegatecall(msg.data);
67     }
68 }
69 
70 contract AbstractSweeperList {
71     function sweeperOf(address _token) public returns (address);
72 }
73 
74 contract Controller is AbstractSweeperList {
75     address public owner;
76     address public authorizedCaller;
77 
78     address public destination;
79 
80     bool public halted;
81 
82     event NewWalletCreated(address receiver);
83 
84     modifier onlyOwner() {
85         if(msg.sender != owner){ revert(); }
86         _;
87     }
88 
89     modifier onlyAuthorizedCaller() {
90         if(msg.sender != authorizedCaller){ revert(); }
91         _;
92     }
93 
94     modifier onlyAdmins() {
95         if(msg.sender != authorizedCaller && msg.sender != owner){ revert(); } 
96         _;
97     }
98 
99     constructor() public {
100         owner = msg.sender;
101         destination = msg.sender;
102         authorizedCaller = msg.sender;
103     }
104 
105     function setAuthorizedCaller(address _newCaller) public onlyOwner {
106         authorizedCaller = _newCaller;
107     }
108 
109     function setDestination(address _dest) public onlyOwner {
110         destination = _dest;
111     }
112 
113     function setOwner(address _owner) public onlyOwner {
114         owner = _owner;
115     }
116 
117     function newWallet() public onlyAdmins returns (address wallet)  {
118         wallet = address(new UserWallet(this));
119         emit NewWalletCreated(wallet);
120     }
121 
122     function halt() public onlyAdmins {
123         halted = true;
124     }
125 
126     function start() public onlyOwner {
127         halted = false;
128     }
129 
130     address public defaultSweeper = address(new DefaultSweeper(this));
131     mapping (address => address) sweepers;
132 
133     function addSweeper(address _token, address _sweeper) public onlyOwner {
134         sweepers[_token] = _sweeper;
135     }
136 
137     function sweeperOf(address _token) public returns (address) {
138         address sweeper = sweepers[_token];
139         if(sweeper == 0){ sweeper = defaultSweeper; }
140         return sweeper;
141     }
142 }