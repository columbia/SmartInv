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
26         owner1 = _address;
27     }
28 
29     function setOwner2(address _address) public onlyOwner {
30         owner2 = _address;
31     }
32 }
33 
34 
35 contract RequiringAuthorization is Owned {
36     Casino public casino;
37     bool public casinoAuthorized;
38     mapping(address => bool) public authorized;
39 
40     modifier onlyAuthorized {
41         require(authorized[msg.sender] || casinoAuthorized && casino.authorized(msg.sender), "Caller is not authorized.");
42         _;
43     }
44 
45     constructor(address _casino) internal {
46         authorized[msg.sender] = true;
47         casino = Casino(_casino);
48         casinoAuthorized = true;
49     }
50 
51     function authorize(address _address) public onlyOwner {
52         authorized[_address] = true;
53     }
54 
55     function deauthorize(address _address) public onlyOwner {
56         authorized[_address] = false;
57     }
58 
59     function authorizeCasino() public onlyOwner {
60         casinoAuthorized = true;
61     }
62 
63     function deauthorizeCasino() public onlyOwner {
64         casinoAuthorized = false;
65     }
66 
67     function setCasino(address _casino) public onlyOwner {
68         casino = Casino(_casino);
69     }
70 }
71 
72 
73 contract WalletController is RequiringAuthorization {
74     address public destination;
75     address public defaultSweeper = address(new DefaultSweeper(address(this)));
76     bool public halted = false;
77 
78     mapping(address => address) public sweepers;
79     mapping(address => bool) public wallets;
80 
81     event EthDeposit(address _from, address _to, uint _amount);
82     event WalletCreated(address _address);
83     event Sweeped(address _from, address _to, address _token, uint _amount);
84 
85     modifier onlyWallet {
86         require(wallets[msg.sender], "Caller must be user wallet.");
87         _;
88     }
89 
90     constructor(address _casino) public RequiringAuthorization(_casino) {
91         destination = msg.sender;
92     }
93 
94     function setDestination(address _destination) public {
95         destination = _destination;
96     }
97 
98     function createWallet() public {
99         address wallet = address(new UserWallet(this));
100         wallets[wallet] = true;
101         emit WalletCreated(wallet);
102     }
103 
104     function createWallets(uint count) public {
105         for (uint i = 0; i < count; i++) {
106             createWallet();
107         }
108     }
109 
110     function addSweeper(address _token, address _sweeper) public onlyOwner {
111         sweepers[_token] = _sweeper;
112     }
113 
114     function halt() public onlyAuthorized {
115         halted = true;
116     }
117 
118     function start() public onlyOwner {
119         halted = false;
120     }
121 
122     function sweeperOf(address _token) public view returns (address) {
123         address sweeper = sweepers[_token];
124         if (sweeper == 0) sweeper = defaultSweeper;
125         return sweeper;
126     }
127 
128     function logEthDeposit(address _from, address _to, uint _amount) public onlyWallet {
129         emit EthDeposit(_from, _to, _amount);
130     }
131 
132     function logSweep(address _from, address _to, address _token, uint _amount) public {
133         emit Sweeped(_from, _to, _token, _amount);
134     }
135 }
136 
137 
138 contract UserWallet {
139     WalletController private controller;
140 
141     constructor (address _controller) public {
142         controller = WalletController(_controller);
143     }
144 
145     function () public payable {
146         controller.logEthDeposit(msg.sender, address(this), msg.value);
147     }
148 
149     function tokenFallback(address _from, uint _value, bytes _data) public pure {
150         (_from);
151         (_value);
152         (_data);
153     }
154 
155     function sweep(address _token, uint _amount) public returns (bool) {
156         (_amount);
157         return controller.sweeperOf(_token).delegatecall(msg.data);
158     }
159 }
160 
161 
162 contract AbstractSweeper {
163     WalletController public controller;
164 
165     constructor (address _controller) public {
166         controller = WalletController(_controller);
167     }
168 
169     function () public { revert("Contract does not accept ETH."); }
170 
171     function sweep(address token, uint amount) public returns (bool);
172 
173     modifier canSweep() {
174         if (!(controller.authorized(msg.sender) || controller.casinoAuthorized() && controller.casino().authorized(msg.sender))) revert("Caller is not authorized to sweep.");
175         if (controller.halted()) revert("Contract is halted.");
176         _;
177     }
178 }
179 
180 
181 contract DefaultSweeper is AbstractSweeper {
182 
183     constructor (address controller) public AbstractSweeper(controller) {}
184 
185     function sweep(address _token, uint _amount) public canSweep returns (bool) {
186         bool success = false;
187         address destination = controller.destination();
188 
189         if (_token != address(0)) {
190             Token token = Token(_token);
191             uint amount = _amount;
192             if (amount > token.balanceOf(this)) {
193                 return false;
194             }
195 
196             success = token.transfer(destination, amount);
197         } else {
198             uint amountInWei = _amount;
199             if (amountInWei > address(this).balance) {
200                 return false;
201             }
202             success = destination.send(amountInWei);
203         }
204 
205         if (success) {
206             controller.logSweep(this, destination, _token, _amount);
207         }
208         return success;
209     }
210 }
211 
212 
213 contract Token {
214     function balanceOf(address a) public pure returns (uint) {
215         (a);
216         return 0;
217     }
218 
219     function transfer(address a, uint val) public pure returns (bool) {
220         (a);
221         (val);
222         return false;
223     }
224 }
225 
226 
227 contract Casino {
228     mapping(address => bool) public authorized;
229 }