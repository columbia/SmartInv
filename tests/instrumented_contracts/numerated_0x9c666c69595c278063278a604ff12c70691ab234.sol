1 pragma solidity 0.5.4;
2 
3 interface IDGTXToken {
4     function transfer(address to, uint value) external returns (bool);
5     function balanceOf(address) external view returns (uint256);
6 }
7 
8 interface IWhitelist {
9     function approved(address user) external view returns (bool);
10 }
11 
12 interface ITreasury {
13     function phaseNum() external view returns (uint256);
14 }
15 
16 contract Sale {
17     address public owner;
18     address public whitelist;
19     address public token;
20     address public treasury;
21 
22     mapping(address => mapping(uint256 => uint256)) public purchased;
23 
24     uint256 internal rate;
25     uint256 internal constant RATE_DELIMITER = 1000;
26     uint256 internal constant ONE_TOKEN = 1e18; //1 DGTX
27     uint256 internal constant PURCHASE_LIMIT = 1e24; //1 000 000 DGTX
28 
29     uint256 internal oldRate;
30     uint256 internal constant RATE_UPDATE_DELAY = 15 minutes;
31     uint256 internal rateBecomesValidAt;
32 
33     event Purchase(address indexed buyer, uint256 amount);
34     event RateUpdate(uint256 newRate, uint256 rateBecomesValidAt);
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36     event TokensReceived(uint256 amount);
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     modifier onlyWhitelisted() {
44         require(IWhitelist(whitelist).approved(msg.sender));
45         _;
46     }
47 
48     constructor(address _token, address _whitelist, address _treasury, uint256 _rate) public {
49         require(_token != address(0));
50         require(_whitelist != address(0));
51         require(_treasury != address(0));
52         require(_rate != 0);
53 
54         owner = msg.sender;
55         token = _token;
56         whitelist = _whitelist;
57         treasury = _treasury;
58         rate = _rate;
59     }
60 
61     function() external payable {
62         require(msg.data.length == 0);
63 
64         buy();
65     }
66 
67     function updateRate(uint256 newRate) external onlyOwner {
68         require(newRate != 0);
69 
70         if (now > rateBecomesValidAt) {
71             oldRate = rate;
72         }
73         rate = newRate;
74         rateBecomesValidAt = now + RATE_UPDATE_DELAY;
75         emit RateUpdate(newRate, rateBecomesValidAt);
76     }
77 
78     function withdraw() external onlyOwner {
79         require(address(this).balance > 0);
80 
81         msg.sender.transfer(address(this).balance);
82     }
83 
84     function withdraw(address payable to) external onlyOwner {
85         require(address(this).balance > 0);
86 
87         to.transfer(address(this).balance);
88     }
89 
90     function transferOwnership(address _owner) external onlyOwner {
91         require(_owner != address(0));
92 
93         emit OwnershipTransferred(owner, _owner);
94 
95         owner = _owner;
96     }
97 
98     function tokenFallback(address, uint value, bytes calldata) external {
99         require(msg.sender == token);
100 
101         emit TokensReceived(value);
102     }
103 
104     function availablePersonal(address user) external view returns (uint256) {
105         if (IWhitelist(whitelist).approved(user)) {
106             uint256 currentPhase = ITreasury(treasury).phaseNum();
107             return PURCHASE_LIMIT - purchased[user][currentPhase];
108         }
109         return 0;
110     }
111 
112     function buy() public payable onlyWhitelisted() returns (uint256) {
113         uint256 availableTotal = availableTokens();
114         require(availableTotal > 0);
115 
116         uint256 currentPhase = ITreasury(treasury).phaseNum();
117         uint256 personalRestrictions = PURCHASE_LIMIT - purchased[msg.sender][currentPhase];
118         require(personalRestrictions > 0);
119 
120         uint256 amount = weiToTokens(msg.value);
121         require(amount >= ONE_TOKEN); // 1 DGTX
122 
123         // actual = min(amount, availableTotal, availablePersonal)
124         uint256 actual = amount < availableTotal ? amount : availableTotal;
125         actual = actual < personalRestrictions ? actual : personalRestrictions;
126 
127         purchased[msg.sender][currentPhase] += actual;
128 
129         require(IDGTXToken(token).transfer(msg.sender, actual));
130 
131         if (amount != actual) {
132             uint256 weiRefund = msg.value - tokensToWei(actual);
133             msg.sender.transfer(weiRefund);
134         }
135 
136         emit Purchase(msg.sender, actual);
137 
138         return actual;
139     }
140 
141     function currentRate() public view returns (uint256) {
142         return (now < rateBecomesValidAt) ? oldRate : rate;
143     }
144 
145     function weiToTokens(uint256 weiAmount) public view returns (uint256) {
146         uint256 exchangeRate = currentRate();
147 
148         return weiAmount * exchangeRate / RATE_DELIMITER;
149     }
150 
151     function tokensToWei(uint256 tokensAmount) public view returns (uint256) {
152         uint256 exchangeRate = currentRate();
153 
154         return tokensAmount * RATE_DELIMITER / exchangeRate;
155     }
156 
157     function futureRate() public view returns (uint256, uint256) {
158         return (now < rateBecomesValidAt) ? (rate, rateBecomesValidAt - now) : (rate, 0);
159     }
160 
161     function availableTokens() public view returns (uint256) {
162         return IDGTXToken(token).balanceOf(address(this));
163     }
164 }