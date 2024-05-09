1 pragma solidity 0.4.25;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     constructor() internal {
13         owner = msg.sender;
14     }
15 
16     function setOwner(address _address) public onlyOwner {
17         owner = _address;
18     }
19 }
20 
21 
22 contract RequiringAuthorization is Owned {
23     mapping(address => bool) public authorized;
24 
25     modifier onlyAuthorized {
26         require(authorized[msg.sender]);
27         _;
28     }
29 
30     constructor() internal {
31         authorized[msg.sender] = true;
32     }
33 
34     function authorize(address _address) public onlyOwner {
35         authorized[_address] = true;
36     }
37 
38     function deauthorize(address _address) public onlyOwner {
39         authorized[_address] = false;
40     }
41 }
42 
43 
44 contract WalletController is RequiringAuthorization {
45     address public destination;
46     address public defaultSweeper = address(new DefaultSweeper(address(this)));
47 
48     mapping(address => address) public sweepers;
49 
50     event EthDeposit(address _from, address _to, uint _amount);
51     event WalletCreated(address _address);
52     event Sweeped(address _from, address _to, address _token, uint _amount);
53 
54     constructor() public {
55         owner = msg.sender;
56         destination = msg.sender;
57     }
58 
59     function setDestination(address _destination) public {
60         destination = _destination;
61     }
62 
63     function createWallet() public onlyAuthorized {
64         address wallet = address(new UserWallet(this));
65         emit WalletCreated(wallet);
66     }
67 
68     function addSweeper(address _token, address _sweeper) public onlyOwner {
69         sweepers[_token] = _sweeper;
70     }
71 
72     function sweeperOf(address _token) public view returns (address) {
73         address sweeper = sweepers[_token];
74         if (sweeper == 0) sweeper = defaultSweeper;
75         return sweeper;
76     }
77 
78     function logEthDeposit(address _from, address _to, uint _amount) public {
79         emit EthDeposit(_from, _to, _amount);
80     }
81 
82     function logSweep(address _from, address _to, address _token, uint _amount) public {
83         emit Sweeped(_from, _to, _token, _amount);
84     }
85 }
86 
87 
88 contract UserWallet {
89     WalletController private controller;
90 
91     constructor (address _controller) public {
92         controller = WalletController(_controller);
93     }
94 
95     function () public payable {
96         controller.logEthDeposit(msg.sender, address(this), msg.value);
97     }
98 
99     function tokenFallback(address _from, uint _value, bytes _data) public pure {
100         (_from);
101         (_value);
102         (_data);
103     }
104 
105     function sweep(address _token, uint _amount) public returns (bool) {
106         (_amount);
107         return controller.sweeperOf(_token).delegatecall(msg.data);
108     }
109 }
110 
111 
112 contract AbstractSweeper {
113     WalletController public controller;
114 
115     constructor (address _controller) public {
116         controller = WalletController(_controller);
117     }
118 
119     function () public { revert(); }
120 
121     function sweep(address token, uint amount) public returns (bool);
122 
123     modifier canSweep() {
124         if (!controller.authorized(msg.sender)) revert();
125         _;
126     }
127 }
128 
129 
130 contract DefaultSweeper is AbstractSweeper {
131 
132     constructor (address controller) public AbstractSweeper(controller) {}
133 
134     function sweep(address _token, uint _amount) public canSweep returns (bool) {
135         bool success = false;
136         address destination = controller.destination();
137 
138         if (_token != address(0)) {
139             Token token = Token(_token);
140             uint amount = _amount;
141             if (amount > token.balanceOf(this)) {
142                 return false;
143             }
144 
145             success = token.transfer(destination, amount);
146         } else {
147             uint amountInWei = _amount;
148             if (amountInWei > address(this).balance) {
149                 return false;
150             }
151             success = destination.send(amountInWei);
152         }
153 
154         if (success) {
155             controller.logSweep(this, destination, _token, _amount);
156         }
157         return success;
158     }
159 }
160 
161 
162 contract Token {
163     function balanceOf(address a) public pure returns (uint) {
164         (a);
165         return 0;
166     }
167 
168     function transfer(address a, uint val) public pure returns (bool) {
169         (a);
170         (val);
171         return false;
172     }
173 }