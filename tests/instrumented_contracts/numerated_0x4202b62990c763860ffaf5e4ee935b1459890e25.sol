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
12     address public owner1;
13     address public owner2;
14 
15     modifier onlyOwner {
16         require(msg.sender != address(0));
17         require(msg.sender == owner1 || msg.sender == owner2, "Only owner.");
18         _;
19     }
20 
21     constructor() internal {
22         owner1 = msg.sender;
23     }
24 
25     function setOwner1(address _address) public onlyOwner {
26         require(_address != address(0));
27         owner1 = _address;
28     }
29 
30     function setOwner2(address _address) public onlyOwner {
31         require(_address != address(0));
32         owner2 = _address;
33     }
34 }
35 
36 
37 contract RequiringAuthorization is Owned {
38     Casino public casino;
39     bool public casinoAuthorized;
40     mapping(address => bool) public authorized;
41 
42     modifier onlyAuthorized {
43         require(authorized[msg.sender] || casinoAuthorized && casino.authorized(msg.sender), "Caller is not authorized.");
44         _;
45     }
46 
47     constructor(address _casino) internal {
48         authorized[msg.sender] = true;
49         casino = Casino(_casino);
50         casinoAuthorized = true;
51     }
52 
53     function authorize(address _address) public onlyOwner {
54         authorized[_address] = true;
55     }
56 
57     function deauthorize(address _address) public onlyOwner {
58         authorized[_address] = false;
59     }
60 
61     function authorizeCasino() public onlyOwner {
62         casinoAuthorized = true;
63     }
64 
65     function deauthorizeCasino() public onlyOwner {
66         casinoAuthorized = false;
67     }
68 
69     function setCasino(address _casino) public onlyOwner {
70         casino = Casino(_casino);
71     }
72 }
73 
74 
75 contract WalletController is RequiringAuthorization {
76     address public destination;
77     address public defaultSweeper = address(new DefaultSweeper(address(this)));
78     bool public halted = false;
79 
80     mapping(address => address) public sweepers;
81     mapping(address => bool) public wallets;
82 
83     event EthDeposit(address _from, address _to, uint _amount);
84     event WalletCreated(address _address);
85     event Sweeped(address _from, address _to, address _token, uint _amount);
86 
87     modifier onlyWallet {
88         require(wallets[msg.sender], "Caller must be user wallet.");
89         _;
90     }
91 
92     constructor(address _casino) public RequiringAuthorization(_casino) {
93         destination = msg.sender;
94     }
95 
96     function setDestination(address _destination) public onlyOwner {
97         destination = _destination;
98     }
99 
100     function createWallet() public {
101         address wallet = address(new UserWallet(this));
102         wallets[wallet] = true;
103         emit WalletCreated(wallet);
104     }
105 
106     function createWallets(uint count) public {
107         for (uint i = 0; i < count; i++) {
108             createWallet();
109         }
110     }
111 
112     function addSweeper(address _token, address _sweeper) public onlyOwner {
113         sweepers[_token] = _sweeper;
114     }
115 
116     function halt() public onlyAuthorized {
117         halted = true;
118     }
119 
120     function start() public onlyOwner {
121         halted = false;
122     }
123 
124     function sweeperOf(address _token) public view returns (address) {
125         address sweeper = sweepers[_token];
126         if (sweeper == 0) sweeper = defaultSweeper;
127         return sweeper;
128     }
129 
130     function logEthDeposit(address _from, address _to, uint _amount) public onlyWallet {
131         emit EthDeposit(_from, _to, _amount);
132     }
133 
134     function logSweep(address _from, address _to, address _token, uint _amount) public {
135         emit Sweeped(_from, _to, _token, _amount);
136     }
137 }
138 
139 
140 contract UserWallet {
141     WalletController private controller;
142 
143     constructor (address _controller) public {
144         controller = WalletController(_controller);
145     }
146 
147     function () public payable {
148         controller.logEthDeposit(msg.sender, address(this), msg.value);
149     }
150 
151     function tokenFallback(address _from, uint _value, bytes _data) public pure {
152         (_from);
153         (_value);
154         (_data);
155     }
156 
157     function sweep(address _token, uint _amount) public returns (bool) {
158         (_amount);
159         return controller.sweeperOf(_token).delegatecall(msg.data);
160     }
161 }
162 
163 
164 contract AbstractSweeper {
165     WalletController public controller;
166 
167     constructor (address _controller) public {
168         controller = WalletController(_controller);
169     }
170 
171     function () public { revert("Contract does not accept ETH."); }
172 
173     function sweep(address token, uint amount) public returns (bool);
174 
175     modifier canSweep() {
176         if (!(controller.authorized(msg.sender) || controller.casinoAuthorized() && controller.casino().authorized(msg.sender))) revert("Caller is not authorized to sweep.");
177         if (controller.halted()) revert("Contract is halted.");
178         _;
179     }
180 }
181 
182 
183 contract DefaultSweeper is AbstractSweeper {
184 
185     constructor (address controller) public AbstractSweeper(controller) {}
186 
187     function sweep(address _token, uint _amount) public canSweep returns (bool) {
188         bool success = false;
189         address destination = controller.destination();
190 
191         if (_token != address(0)) {
192             Token token = Token(_token);
193             uint amount = _amount;
194             if (amount > token.balanceOf(this)) {
195                 return false;
196             }
197 
198             success = token.transfer(destination, amount);
199         } else {
200             uint amountInWei = _amount;
201             if (amountInWei > address(this).balance) {
202                 return false;
203             }
204             success = destination.send(amountInWei);
205         }
206 
207         if (success) {
208             controller.logSweep(this, destination, _token, _amount);
209         }
210         return success;
211     }
212 }
213 
214 
215 contract Token {
216     function balanceOf(address a) public pure returns (uint) {
217         (a);
218         return 0;
219     }
220 
221     function transfer(address a, uint val) public pure returns (bool) {
222         (a);
223         (val);
224         return false;
225     }
226 }
227 
228 
229 contract Casino {
230     mapping(address => bool) public authorized;
231 }