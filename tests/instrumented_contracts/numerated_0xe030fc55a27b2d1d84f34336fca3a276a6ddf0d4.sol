1 /**
2  * Allows to create contracts which would be able to receive ETH and tokens.
3  * Contract will help to detect ETH deposits faster.
4  * Contract idea was borrowed from Bittrex.
5  * */
6 
7 pragma solidity 0.4.25;
8 
9 
10 contract Owned {
11     address public owner;
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     constructor() internal {
19         owner = msg.sender;
20     }
21 
22     function setOwner(address _address) public onlyOwner {
23         owner = _address;
24     }
25 }
26 
27 
28 contract RequiringAuthorization is Owned {
29     mapping(address => bool) public authorized;
30 
31     modifier onlyAuthorized {
32         require(authorized[msg.sender]);
33         _;
34     }
35 
36     constructor() internal {
37         authorized[msg.sender] = true;
38     }
39 
40     function authorize(address _address) public onlyOwner {
41         authorized[_address] = true;
42     }
43 
44     function deauthorize(address _address) public onlyOwner {
45         authorized[_address] = false;
46     }
47 }
48 
49 
50 contract WalletController is RequiringAuthorization {
51     address public destination;
52     address public defaultSweeper = address(new DefaultSweeper(address(this)));
53 
54     mapping(address => address) public sweepers;
55 
56     event EthDeposit(address _from, address _to, uint _amount);
57     event WalletCreated(address _address);
58     event Sweeped(address _from, address _to, address _token, uint _amount);
59 
60     constructor() public {
61         owner = msg.sender;
62         destination = msg.sender;
63     }
64 
65     function setDestination(address _destination) public {
66         destination = _destination;
67     }
68 
69     function createWallet() public onlyAuthorized {
70         address wallet = address(new UserWallet(this));
71         emit WalletCreated(wallet);
72     }
73 
74     function createWallets(uint count) public onlyAuthorized {
75         for (uint i = 0; i < count; i++) {
76             createWallet();
77         }
78     }
79 
80     function addSweeper(address _token, address _sweeper) public onlyOwner {
81         sweepers[_token] = _sweeper;
82     }
83 
84     function sweeperOf(address _token) public view returns (address) {
85         address sweeper = sweepers[_token];
86         if (sweeper == 0) sweeper = defaultSweeper;
87         return sweeper;
88     }
89 
90     function logEthDeposit(address _from, address _to, uint _amount) public {
91         emit EthDeposit(_from, _to, _amount);
92     }
93 
94     function logSweep(address _from, address _to, address _token, uint _amount) public {
95         emit Sweeped(_from, _to, _token, _amount);
96     }
97 }
98 
99 
100 contract UserWallet {
101     WalletController private controller;
102 
103     constructor (address _controller) public {
104         controller = WalletController(_controller);
105     }
106 
107     function () public payable {
108         controller.logEthDeposit(msg.sender, address(this), msg.value);
109     }
110 
111     function tokenFallback(address _from, uint _value, bytes _data) public pure {
112         (_from);
113         (_value);
114         (_data);
115     }
116 
117     function sweep(address _token, uint _amount) public returns (bool) {
118         (_amount);
119         return controller.sweeperOf(_token).delegatecall(msg.data);
120     }
121 }
122 
123 
124 contract AbstractSweeper {
125     WalletController public controller;
126 
127     constructor (address _controller) public {
128         controller = WalletController(_controller);
129     }
130 
131     function () public { revert(); }
132 
133     function sweep(address token, uint amount) public returns (bool);
134 
135     modifier canSweep() {
136         if (!controller.authorized(msg.sender)) revert();
137         _;
138     }
139 }
140 
141 
142 contract DefaultSweeper is AbstractSweeper {
143 
144     constructor (address controller) public AbstractSweeper(controller) {}
145 
146     function sweep(address _token, uint _amount) public canSweep returns (bool) {
147         bool success = false;
148         address destination = controller.destination();
149 
150         if (_token != address(0)) {
151             Token token = Token(_token);
152             uint amount = _amount;
153             if (amount > token.balanceOf(this)) {
154                 return false;
155             }
156 
157             success = token.transfer(destination, amount);
158         } else {
159             uint amountInWei = _amount;
160             if (amountInWei > address(this).balance) {
161                 return false;
162             }
163             success = destination.send(amountInWei);
164         }
165 
166         if (success) {
167             controller.logSweep(this, destination, _token, _amount);
168         }
169         return success;
170     }
171 }
172 
173 
174 contract Token {
175     function balanceOf(address a) public pure returns (uint) {
176         (a);
177         return 0;
178     }
179 
180     function transfer(address a, uint val) public pure returns (bool) {
181         (a);
182         (val);
183         return false;
184     }
185 }