1 /**
2  * Allows to create contracts which would be able to receive ETH and tokens.
3  * Contract will help to detect ETH deposits faster.
4  * Contract idea was borrowed from Bittrex.
5  * Version: 2
6  * */
7 
8 pragma solidity 0.4.25;
9 
10 
11 contract Owned {
12     address public owner;
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     constructor() internal {
20         owner = msg.sender;
21     }
22 
23     function setOwner(address _address) public onlyOwner {
24         owner = _address;
25     }
26 }
27 
28 
29 contract RequiringAuthorization is Owned {
30     Casino public casino;
31     bool public casinoAuthorized;
32     mapping(address => bool) public authorized;
33 
34     modifier onlyAuthorized {
35         require(authorized[msg.sender] || casinoAuthorized && casino.authorized(msg.sender));
36         _;
37     }
38 
39     constructor(address _casino) internal {
40         authorized[msg.sender] = true;
41         casino = Casino(_casino);
42         casinoAuthorized = true;
43     }
44 
45     function authorize(address _address) public onlyOwner {
46         authorized[_address] = true;
47     }
48 
49     function deauthorize(address _address) public onlyOwner {
50         authorized[_address] = false;
51     }
52 
53     function authorizeCasino() public onlyOwner {
54         casinoAuthorized = true;
55     }
56 
57     function deauthorizeCasino() public onlyOwner {
58         casinoAuthorized = false;
59     }
60 
61     function setCasino(address _casino) public onlyOwner {
62         casino = Casino(_casino);
63     }
64 }
65 
66 
67 contract WalletController is RequiringAuthorization {
68     address public destination;
69     address public defaultSweeper = address(new DefaultSweeper(address(this)));
70     bool public halted = false;
71 
72     mapping(address => address) public sweepers;
73     mapping(address => bool) public wallets;
74 
75     event EthDeposit(address _from, address _to, uint _amount);
76     event WalletCreated(address _address);
77     event Sweeped(address _from, address _to, address _token, uint _amount);
78 
79     modifier onlyWallet {
80         require(wallets[msg.sender]);
81         _;
82     }
83 
84     constructor(address _casino) public RequiringAuthorization(_casino) {
85         owner = msg.sender;
86         destination = msg.sender;
87     }
88 
89     function setDestination(address _destination) public {
90         destination = _destination;
91     }
92 
93     function createWallet() public {
94         address wallet = address(new UserWallet(this));
95         wallets[wallet] = true;
96         emit WalletCreated(wallet);
97     }
98 
99     function createWallets(uint count) public {
100         for (uint i = 0; i < count; i++) {
101             createWallet();
102         }
103     }
104 
105     function addSweeper(address _token, address _sweeper) public onlyOwner {
106         sweepers[_token] = _sweeper;
107     }
108 
109     function halt() public onlyAuthorized {
110         halted = true;
111     }
112 
113     function start() public onlyOwner {
114         halted = false;
115     }
116 
117     function sweeperOf(address _token) public view returns (address) {
118         address sweeper = sweepers[_token];
119         if (sweeper == 0) sweeper = defaultSweeper;
120         return sweeper;
121     }
122 
123     function logEthDeposit(address _from, address _to, uint _amount) public onlyWallet {
124         emit EthDeposit(_from, _to, _amount);
125     }
126 
127     function logSweep(address _from, address _to, address _token, uint _amount) public onlyWallet {
128         emit Sweeped(_from, _to, _token, _amount);
129     }
130 }
131 
132 
133 contract UserWallet {
134     WalletController private controller;
135 
136     constructor (address _controller) public {
137         controller = WalletController(_controller);
138     }
139 
140     function () public payable {
141         controller.logEthDeposit(msg.sender, address(this), msg.value);
142     }
143 
144     function tokenFallback(address _from, uint _value, bytes _data) public pure {
145         (_from);
146         (_value);
147         (_data);
148     }
149 
150     function sweep(address _token, uint _amount) public returns (bool) {
151         (_amount);
152         return controller.sweeperOf(_token).delegatecall(msg.data);
153     }
154 }
155 
156 
157 contract AbstractSweeper {
158     WalletController public controller;
159 
160     constructor (address _controller) public {
161         controller = WalletController(_controller);
162     }
163 
164     function () public { revert(); }
165 
166     function sweep(address token, uint amount) public returns (bool);
167 
168     modifier canSweep() {
169         if (!controller.authorized(msg.sender)) revert();
170         if (controller.halted()) revert();
171         _;
172     }
173 }
174 
175 
176 contract DefaultSweeper is AbstractSweeper {
177 
178     constructor (address controller) public AbstractSweeper(controller) {}
179 
180     function sweep(address _token, uint _amount) public canSweep returns (bool) {
181         bool success = false;
182         address destination = controller.destination();
183 
184         if (_token != address(0)) {
185             Token token = Token(_token);
186             uint amount = _amount;
187             if (amount > token.balanceOf(this)) {
188                 return false;
189             }
190 
191             success = token.transfer(destination, amount);
192         } else {
193             uint amountInWei = _amount;
194             if (amountInWei > address(this).balance) {
195                 return false;
196             }
197             success = destination.send(amountInWei);
198         }
199 
200         if (success) {
201             controller.logSweep(this, destination, _token, _amount);
202         }
203         return success;
204     }
205 }
206 
207 
208 contract Token {
209     function balanceOf(address a) public pure returns (uint) {
210         (a);
211         return 0;
212     }
213 
214     function transfer(address a, uint val) public pure returns (bool) {
215         (a);
216         (val);
217         return false;
218     }
219 }
220 
221 
222 contract Casino {
223     mapping(address => bool) public authorized;
224 }