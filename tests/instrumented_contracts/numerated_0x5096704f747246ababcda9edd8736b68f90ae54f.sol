1 pragma solidity ^0.6.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  *
9 */
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 
39   function ceil(uint a, uint m) internal pure returns (uint r) {
40     return (a + m - 1) / m * m;
41   }
42 }
43 
44 // ----------------------------------------------------------------------------
45 // Owned contract
46 // ----------------------------------------------------------------------------
47 contract Owned {
48     address payable public owner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address payable _newOwner) public onlyOwner {
62         owner = _newOwner;
63         emit OwnershipTransferred(msg.sender, _newOwner);
64     }
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // ERC Token Standard #20 Interface
70 // ----------------------------------------------------------------------------
71 interface IToken {
72     function transfer(address to, uint256 tokens) external returns (bool success);
73     function burnTokens(uint256 _amount) external;
74     function balanceOf(address tokenOwner) external view returns (uint256 balance);
75 }
76 
77 
78 contract UNQTpresale is Owned {
79     using SafeMath for uint256;
80     
81     bool public isPresaleOpen;
82     
83     //@dev ERC20 token address and decimals
84     address public tokenAddress;
85     uint256 public tokenDecimals = 18;
86     
87     //@dev amount of tokens per ether 1000 indicates 1 token per eth
88     uint256 public tokenRatePerEth = 1000_00;
89     //@dev decimal for tokenRatePerEth,
90     //2 means if you want 100 tokens per eth then set the rate as 100 + number of rateDecimals i.e => 10000
91     uint256 public rateDecimals = 2;
92     
93     //@dev max and min token buy limit per account
94     uint256 public minEthLimit = 1 finney; // 0.00100000 ETH
95     uint256 public maxEthLimit = 5 ether;
96     
97     mapping(address => uint256) public usersInvestments;
98     
99     constructor() public {
100         owner = msg.sender;
101     }
102     
103     function startPresale() external onlyOwner{
104         require(!isPresaleOpen, "Presale is open");
105         
106         isPresaleOpen = true;
107     }
108     
109     function closePresale() external onlyOwner{
110         require(isPresaleOpen, "Presale is not open yet.");
111         
112         isPresaleOpen = false;
113     }
114     
115     function setTokenAddress(address token) external onlyOwner {
116         require(tokenAddress == address(0), "Token address is already set.");
117         require(token != address(0), "Token address zero not allowed.");
118         
119         tokenAddress = token;
120     }
121     
122     function setTokenDecimals(uint256 decimals) external onlyOwner {
123        tokenDecimals = decimals;
124     }
125     
126     function setMinEthLimit(uint256 amount) external onlyOwner {
127         minEthLimit = amount;    
128     }
129     
130     function setMaxEthLimit(uint256 amount) external onlyOwner {
131         maxEthLimit = amount;    
132     }
133     
134     function setTokenRatePerEth(uint256 rate) external onlyOwner {
135         tokenRatePerEth = rate;
136     }
137     
138     function setRateDecimals(uint256 decimals) external onlyOwner {
139         rateDecimals = decimals;
140     }
141     
142     receive() external payable{
143         require(isPresaleOpen, "Presale is not open.");
144         require(
145                 usersInvestments[msg.sender].add(msg.value) <= maxEthLimit
146                 && usersInvestments[msg.sender].add(msg.value) >= minEthLimit,
147                 "Installment Invalid."
148             );
149         
150         //@dev calculate the amount of tokens to transfer for the given eth
151         uint256 tokenAmount = getTokensPerEth(msg.value);
152         
153         require(IToken(tokenAddress).transfer(msg.sender, tokenAmount), "Insufficient balance of presale contract!");
154         
155         usersInvestments[msg.sender] = usersInvestments[msg.sender].add(msg.value);
156         
157         //@dev send received funds to the owner
158         owner.transfer(msg.value);
159     }
160     
161     function getTokensPerEth(uint256 amount) internal view returns(uint256) {
162         return amount.mul(tokenRatePerEth).div(
163             10**(uint256(18).sub(tokenDecimals).add(rateDecimals))
164             );
165     }
166     
167     function burnUnsoldTokens() external onlyOwner {
168         require(!isPresaleOpen, "You cannot burn tokens untitl the presale is closed.");
169         
170         IToken(tokenAddress).burnTokens(IToken(tokenAddress).balanceOf(address(this)));   
171     }
172     
173     function getUnsoldTokens() external onlyOwner {
174         require(!isPresaleOpen, "You cannot get tokens until the presale is closed.");
175         
176         IToken(tokenAddress).transfer(owner, IToken(tokenAddress).balanceOf(address(this)) );
177     }
178 }