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
53     bool public halted = false;
54 
55     mapping(address => address) public sweepers;
56 
57     event EthDeposit(address _from, address _to, uint _amount);
58     event WalletCreated(address _address);
59     event Sweeped(address _from, address _to, address _token, uint _amount);
60 
61     constructor() public {
62         owner = msg.sender;
63         destination = msg.sender;
64     }
65 
66     function setDestination(address _destination) public {
67         destination = _destination;
68     }
69 
70     function createWallet() public {
71         address wallet = address(new UserWallet(this));
72         emit WalletCreated(wallet);
73     }
74 
75     function createWallets(uint count) public {
76         for (uint i = 0; i < count; i++) {
77             createWallet();
78         }
79     }
80 
81     function addSweeper(address _token, address _sweeper) public onlyOwner {
82         sweepers[_token] = _sweeper;
83     }
84     
85     function halt() public onlyAuthorized {
86         halted = true;
87     }
88     
89     function start() public onlyOwner {
90         halted = false;
91     }
92 
93     function sweeperOf(address _token) public view returns (address) {
94         address sweeper = sweepers[_token];
95         if (sweeper == 0) sweeper = defaultSweeper;
96         return sweeper;
97     }
98 
99     function logEthDeposit(address _from, address _to, uint _amount) public {
100         emit EthDeposit(_from, _to, _amount);
101     }
102 
103     function logSweep(address _from, address _to, address _token, uint _amount) public {
104         emit Sweeped(_from, _to, _token, _amount);
105     }
106 }
107 
108 
109 contract UserWallet {
110     WalletController private controller;
111 
112     constructor (address _controller) public {
113         controller = WalletController(_controller);
114     }
115 
116     function () public payable {
117         controller.logEthDeposit(msg.sender, address(this), msg.value);
118     }
119 
120     function tokenFallback(address _from, uint _value, bytes _data) public pure {
121         (_from);
122         (_value);
123         (_data);
124     }
125 
126     function sweep(address _token, uint _amount) public returns (bool) {
127         (_amount);
128         return controller.sweeperOf(_token).delegatecall(msg.data);
129     }
130 }
131 
132 
133 contract AbstractSweeper {
134     WalletController public controller;
135 
136     constructor (address _controller) public {
137         controller = WalletController(_controller);
138     }
139 
140     function () public { revert(); }
141 
142     function sweep(address token, uint amount) public returns (bool);
143 
144     modifier canSweep() {
145         if (!controller.authorized(msg.sender)) revert();
146         if (controller.halted()) revert();
147         _;
148     }
149 }
150 
151 
152 contract DefaultSweeper is AbstractSweeper {
153 
154     constructor (address controller) public AbstractSweeper(controller) {}
155 
156     function sweep(address _token, uint _amount) public canSweep returns (bool) {
157         bool success = false;
158         address destination = controller.destination();
159 
160         if (_token != address(0)) {
161             Token token = Token(_token);
162             uint amount = _amount;
163             if (amount > token.balanceOf(this)) {
164                 return false;
165             }
166 
167             success = token.transfer(destination, amount);
168         } else {
169             uint amountInWei = _amount;
170             if (amountInWei > address(this).balance) {
171                 return false;
172             }
173             success = destination.send(amountInWei);
174         }
175 
176         if (success) {
177             controller.logSweep(this, destination, _token, _amount);
178         }
179         return success;
180     }
181 }
182 
183 
184 contract Token {
185     function balanceOf(address a) public pure returns (uint) {
186         (a);
187         return 0;
188     }
189 
190     function transfer(address a, uint val) public pure returns (bool) {
191         (a);
192         (val);
193         return false;
194     }
195 }