1 /**
2  * verified by 3esmit
3 */
4 
5 /**
6  * Allows to create contracts which would be able to receive ETH and tokens.
7  * Contract will help to detect ETH deposits faster.
8  * Contract idea was borrowed from Bittrex.
9  * Version: 2
10  * */
11 
12 pragma solidity 0.4.25;
13 
14 
15 contract Owned {
16     address public owner1;
17     address public owner2;
18 
19     modifier onlyOwner {
20         require(msg.sender != address(0));
21         require(msg.sender == owner1 || msg.sender == owner2, "Only owner.");
22         _;
23     }
24 
25     constructor() internal {
26         owner1 = msg.sender;
27     }
28 
29     function setOwner1(address _address) public onlyOwner {
30         require(_address != address(0));
31         owner1 = _address;
32     }
33 
34     function setOwner2(address _address) public onlyOwner {
35         require(_address != address(0));
36         owner2 = _address;
37     }
38 }
39 
40 
41 contract RequiringAuthorization is Owned {
42     Casino public casino;
43     bool public casinoAuthorized;
44     mapping(address => bool) public authorized;
45 
46     modifier onlyAuthorized {
47         require(authorized[msg.sender] || casinoAuthorized && casino.authorized(msg.sender), "Caller is not authorized.");
48         _;
49     }
50 
51     constructor(address _casino) internal {
52         authorized[msg.sender] = true;
53         casino = Casino(_casino);
54         casinoAuthorized = true;
55     }
56 
57     function authorize(address _address) public onlyOwner {
58         authorized[_address] = true;
59     }
60 
61     function deauthorize(address _address) public onlyOwner {
62         authorized[_address] = false;
63     }
64 
65     function authorizeCasino() public onlyOwner {
66         casinoAuthorized = true;
67     }
68 
69     function deauthorizeCasino() public onlyOwner {
70         casinoAuthorized = false;
71     }
72 
73     function setCasino(address _casino) public onlyOwner {
74         casino = Casino(_casino);
75     }
76 }
77 
78 
79 contract WalletController is RequiringAuthorization {
80     address public destination;
81     address public defaultSweeper = address(new DefaultSweeper(address(this)));
82     bool public halted = false;
83 
84     mapping(address => address) public sweepers;
85     mapping(address => bool) public wallets;
86 
87     event EthDeposit(address _from, address _to, uint _amount);
88     event WalletCreated(address _address);
89     event Sweeped(address _from, address _to, address _token, uint _amount);
90 
91     modifier onlyWallet {
92         require(wallets[msg.sender], "Caller must be user wallet.");
93         _;
94     }
95 
96     constructor(address _casino) public RequiringAuthorization(_casino) {
97         destination = msg.sender;
98     }
99 
100     function setDestination(address _destination) public onlyOwner {
101         destination = _destination;
102     }
103 
104     function createWallet() public {
105         address wallet = address(new UserWallet(this));
106         wallets[wallet] = true;
107         emit WalletCreated(wallet);
108     }
109 
110     function createWallets(uint count) public {
111         for (uint i = 0; i < count; i++) {
112             createWallet();
113         }
114     }
115 
116     function addSweeper(address _token, address _sweeper) public onlyOwner {
117         sweepers[_token] = _sweeper;
118     }
119 
120     function halt() public onlyAuthorized {
121         halted = true;
122     }
123 
124     function start() public onlyOwner {
125         halted = false;
126     }
127 
128     function sweeperOf(address _token) public view returns (address) {
129         address sweeper = sweepers[_token];
130         if (sweeper == 0) sweeper = defaultSweeper;
131         return sweeper;
132     }
133 
134     function logEthDeposit(address _from, address _to, uint _amount) public onlyWallet {
135         emit EthDeposit(_from, _to, _amount);
136     }
137 
138     function logSweep(address _from, address _to, address _token, uint _amount) public {
139         emit Sweeped(_from, _to, _token, _amount);
140     }
141 }
142 
143 
144 contract UserWallet {
145     WalletController private controller;
146 
147     constructor (address _controller) public {
148         controller = WalletController(_controller);
149     }
150 
151     function () public payable {
152         controller.logEthDeposit(msg.sender, address(this), msg.value);
153     }
154 
155     function tokenFallback(address _from, uint _value, bytes _data) public pure {
156         (_from);
157         (_value);
158         (_data);
159     }
160 
161     function sweep(address _token, uint _amount) public returns (bool) {
162         (_amount);
163         return controller.sweeperOf(_token).delegatecall(msg.data);
164     }
165 }
166 
167 
168 contract AbstractSweeper {
169     WalletController public controller;
170 
171     constructor (address _controller) public {
172         controller = WalletController(_controller);
173     }
174 
175     function () public { revert("Contract does not accept ETH."); }
176 
177     function sweep(address token, uint amount) public returns (bool);
178 
179     modifier canSweep() {
180         if (!(controller.authorized(msg.sender) || controller.casinoAuthorized() && controller.casino().authorized(msg.sender))) revert("Caller is not authorized to sweep.");
181         if (controller.halted()) revert("Contract is halted.");
182         _;
183     }
184 }
185 
186 
187 contract DefaultSweeper is AbstractSweeper {
188 
189     constructor (address controller) public AbstractSweeper(controller) {}
190 
191     function sweep(address _token, uint _amount) public canSweep returns (bool) {
192         bool success = false;
193         address destination = controller.destination();
194 
195         if (_token != address(0)) {
196             Token token = Token(_token);
197             uint amount = _amount;
198             if (amount > token.balanceOf(this)) {
199                 return false;
200             }
201 
202             success = token.transfer(destination, amount);
203         } else {
204             uint amountInWei = _amount;
205             if (amountInWei > address(this).balance) {
206                 return false;
207             }
208             success = destination.send(amountInWei);
209         }
210 
211         if (success) {
212             controller.logSweep(this, destination, _token, _amount);
213         }
214         return success;
215     }
216 }
217 
218 
219 contract Token {
220     function balanceOf(address a) public pure returns (uint) {
221         (a);
222         return 0;
223     }
224 
225     function transfer(address a, uint val) public pure returns (bool) {
226         (a);
227         (val);
228         return false;
229     }
230 }
231 
232 
233 contract Casino {
234     mapping(address => bool) public authorized;
235 }