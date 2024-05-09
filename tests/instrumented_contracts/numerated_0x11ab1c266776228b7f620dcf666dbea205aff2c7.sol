1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.5;
3 
4 interface IERC20Token {
5     function balanceOf(address owner) external returns (uint256);
6     function transfer(address to, uint256 amount) external returns (bool);
7     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
8     function decimals() external returns (uint256);
9 }
10 
11 
12 contract Owned {
13     address payable public owner;
14 
15     event OwnershipTransferred(address indexed _from, address indexed _to);
16 
17     constructor() {
18         owner = msg.sender;
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function transferOwnership(address payable _newOwner) public onlyOwner {
27         require(_newOwner != address(0), "ERC20: sending to the zero address");
28         owner = _newOwner;
29         emit OwnershipTransferred(msg.sender, _newOwner);
30     }
31 }
32 
33 
34 contract TokenSale is Owned{
35     IERC20Token public tokenContract;  // the token being sold
36     uint256 public price = 8;              // 1eth = 8 tokens
37     uint256 public decimals = 18;
38     
39     uint256 public tokensSold;
40     uint256 public ethRaised;
41     uint256 public MaxETHAmount;
42     
43     address[] internal buyers;
44     mapping (address => uint256) public _balances;
45 
46     event Sold(address buyer, uint256 amount);
47     event DistributedTokens(uint256 tokensSold);
48 
49     constructor(IERC20Token _tokenContract, uint256 _maxEthAmount) {
50         owner = msg.sender;
51         tokenContract = _tokenContract;
52         MaxETHAmount = _maxEthAmount;
53     }
54     
55     fallback() external payable {
56         buyTokensWithETH(msg.sender);
57     }
58     
59     receive() external payable{ buyTokensWithETH(msg.sender); }
60 
61     // Guards against integer overflows
62     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         } else {
66             uint256 c = a * b;
67             assert(c / a == b);
68             return c;
69         }
70     }
71     
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78     
79     function multiply(uint x, uint y) internal pure returns (uint z) {
80         require(y == 0 || (z = x * y) / y == x);
81     }
82     
83     function setPrice(uint256 price_) external onlyOwner{
84         price = price_;
85     }
86     
87     function isBuyer(address _address)
88         public
89         view
90         returns (bool)
91     {
92         for (uint256 s = 0; s < buyers.length; s += 1) {
93             if (_address == buyers[s]) return (true);
94         }
95         return (false);
96     }
97 
98     function addbuyer(address _buyer, uint256 _amount) internal {
99         bool _isbuyer = isBuyer(_buyer);
100         if (!_isbuyer) buyers.push(_buyer);
101         
102         _balances[_buyer] = add(_balances[_buyer], _amount);
103     }
104 
105 
106 
107     function buyTokensWithETH(address _receiver) public payable {
108         require(ethRaised < MaxETHAmount, "Presale finished");
109         uint _amount = msg.value; 
110         require(_receiver != address(0), "Can't send to 0x00 address"); 
111         require(_amount > 0, "Can't buy with 0 eth"); 
112         
113         require(owner.send(_amount), "Unable to transfer eth to owner");
114         ethRaised += _amount;
115         
116         addbuyer(msg.sender, _amount);
117         
118     }
119     
120     function sendTokensByAdmin() public onlyOwner{
121         require(multiply(ethRaised, price) <= tokenContract.balanceOf(address(this)), 'Error: Contract dont have Enough tokens');
122         for (uint256 s = 0; s < buyers.length; s += 1) {
123             uint256 gBalance = _balances[buyers[s]];
124             
125             if(gBalance > 0) {
126                 _balances[buyers[s]] = 0;
127                 
128                 uint tokensToBuy = multiply(gBalance, price);
129                 require(tokenContract.transfer( buyers[s], tokensToBuy), "Unable to transfer token to user");
130                 
131                 tokensSold += tokensToBuy;
132                 
133                 emit Sold(msg.sender, tokensToBuy);
134             }
135         }
136         
137         ethRaised = 0;
138         emit DistributedTokens(tokensSold);
139     }
140     
141 
142     function endSale() public {
143         require(msg.sender == owner);
144 
145         // Send unsold tokens to the owner.
146         require(tokenContract.transfer(owner, tokenContract.balanceOf(address(this))));
147 
148         msg.sender.transfer(address(this).balance);
149     }
150 }