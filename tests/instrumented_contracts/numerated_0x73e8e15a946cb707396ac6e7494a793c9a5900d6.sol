1 //SPDX-License-Identifier: MIT Licensed
2 pragma solidity ^0.8.10;
3 
4 interface IERC20 {
5     function name() external view returns (string memory);
6 
7     function symbol() external view returns (string memory);
8 
9     function decimals() external view returns (uint8);
10 
11     function tokensForSale() external view returns (uint256);
12 
13     function balanceOf(address owner) external view returns (uint256);
14 
15     function allowance(
16         address owner,
17         address spender
18     ) external view returns (uint256);
19 
20     function approve(address spender, uint256 value) external;
21 
22     function transfer(address to, uint256 value) external;
23 
24     function transferFrom(address from, address to, uint256 value) external;
25 
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract GoldenPresale {
35     IERC20 public GoldenToken;
36 
37     address payable public owner;
38 
39     uint256 public tokenPerEth = 200000000000000 * 1e9;
40     uint256 public totalUsers;
41     uint256 public soldToken;
42     uint256 public maxPurchase = 1 ether;
43     uint256 public tokensForSale = 10000000000000000 * 1e9;
44 
45     uint256 public amountRaisedInEth;
46     address payable public fundReceiver =
47         payable(0xE62146C0d544F3B3fe9C75676350d39f54A9D17b);
48 
49     uint256 public constant divider = 100;
50     bool public enableClaim;
51     struct user {
52         uint256 Eth_balance;
53         uint256 token_balance;
54         uint256 claimed_token;
55     }
56 
57     mapping(address => user) public users;
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner, "PRESALE: Not an owner");
61         _;
62     }
63 
64     event BuyToken(address indexed _user, uint256 indexed _amount);
65     event ClaimToken(address indexed _user, uint256 indexed _amount);
66 
67     constructor(IERC20 _token) {
68         owner = payable(0xE62146C0d544F3B3fe9C75676350d39f54A9D17b);
69         GoldenToken = _token;
70     }
71 
72     receive() external payable {}
73 
74     // to buy token during preSale time with Eth => for web3 use
75 
76     function buyToken() public payable {
77         require(enableClaim == false, "Presale : Paused");
78         require(
79             users[msg.sender].Eth_balance + msg.value <= maxPurchase,
80             "Presale : amount must be less than max purchase"
81         );
82         require(soldToken <= tokensForSale, "All Sold");
83 
84         uint256 numberOfTokens;
85         numberOfTokens = EthToToken(msg.value);
86         soldToken = soldToken + (numberOfTokens);
87         amountRaisedInEth = amountRaisedInEth + (msg.value);
88         fundReceiver.transfer(msg.value);
89 
90         users[msg.sender].Eth_balance =
91             users[msg.sender].Eth_balance +
92             (msg.value);
93         users[msg.sender].token_balance =
94             users[msg.sender].token_balance +
95             (numberOfTokens);
96     }
97 
98     // to change preSale amount limits
99     function setSupply(
100         uint256 tokenPerPhase,
101         uint256 _soldToken
102     ) external onlyOwner {
103         tokensForSale = tokenPerPhase;
104         soldToken = _soldToken;
105     }
106 
107     // Claim bought tokens
108     function claimTokens() external {
109         require(enableClaim == true, "Presale : Presale is not finished yet");
110         require(users[msg.sender].token_balance != 0, "Presale: 0 to claim");
111 
112         user storage _usr = users[msg.sender];
113 
114         GoldenToken.transfer(msg.sender, _usr.token_balance);
115         _usr.claimed_token += _usr.token_balance;
116         _usr.token_balance -= _usr.token_balance;
117 
118         emit ClaimToken(msg.sender, _usr.token_balance);
119     }
120 
121     // to check number of token for given eth
122     function EthToToken(uint256 _amount) public view returns (uint256) {
123         uint256 numberOfTokens = (_amount * (tokenPerEth)) / (1e18);
124         return numberOfTokens;
125     }
126 
127     // to change Price of the token
128     function changePrice(uint256 _price) external onlyOwner {
129         tokenPerEth = _price;
130     }
131 
132     function EnableClaim(bool _claim) public onlyOwner {
133         enableClaim = _claim;
134     }
135 
136     function changePurchaseLimits(uint256 _maxPurchase) public onlyOwner {
137         maxPurchase = _maxPurchase;
138     }
139 
140     // transfer ownership
141     function changeOwner(address payable _newOwner) external onlyOwner {
142         owner = _newOwner;
143     }
144 
145     // change tokens
146     function changeToken(address _token) external onlyOwner {
147         GoldenToken = IERC20(_token);
148     }
149 
150     // to draw funds for liquidity
151     function transferFundsEth(uint256 _value) external onlyOwner {
152         owner.transfer(_value);
153     }
154 
155     // to draw out tokens
156     function transferTokens(IERC20 token, uint256 _value) external onlyOwner {
157         token.transfer(msg.sender, _value);
158     }
159 }