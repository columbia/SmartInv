1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  *
8 */
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 
38   function ceil(uint a, uint m) internal pure returns (uint r) {
39     return (a + m - 1) / m * m;
40   }
41 }
42 
43 // ----------------------------------------------------------------------------
44 // Owned contract
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address payable public owner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address payable _newOwner) public onlyOwner {
61         owner = _newOwner;
62         emit OwnershipTransferred(msg.sender, _newOwner);
63     }
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // ERC Token Standard #20 Interface
69 // ----------------------------------------------------------------------------
70 interface IToken {
71     function transfer(address to, uint256 tokens) external returns (bool success);
72     function burnTokens(uint256 _amount) external;
73     function balanceOf(address tokenOwner) external view returns (uint256 balance);
74 }
75 
76 
77 contract Presale is Owned {
78     using SafeMath for uint256;
79     
80     bool public isPresaleOpen;
81     
82     //@dev ERC20 token address and decimals
83     address public tokenAddress;
84     uint256 public tokenDecimals = 18;
85     
86     //@dev amount of tokens per ether 100 indicates 1 token per eth
87     uint256 public tokenRatePerEth = 3_00;
88     //@dev decimal for tokenRatePerEth,
89     //2 means if you want 100 tokens per eth then set the rate as 100 + number of rateDecimals i.e => 10000
90     uint256 public rateDecimals = 2;
91     
92     //@dev max and min token buy limit per account
93     uint256 public minEthLimit = 100 finney;
94     uint256 public maxEthLimit = 2 ether;
95     
96     mapping(address => uint256) public usersInvestments;
97     
98     constructor() public {
99         owner = msg.sender;
100     }
101     
102     function startPresale() external onlyOwner{
103         require(!isPresaleOpen, "Presale is open");
104         
105         isPresaleOpen = true;
106     }
107     
108     function closePrsale() external onlyOwner{
109         require(isPresaleOpen, "Presale is not open yet.");
110         
111         isPresaleOpen = false;
112     }
113     
114     function setTokenAddress(address token) external onlyOwner {
115         require(tokenAddress == address(0), "Token address is already set.");
116         require(token != address(0), "Token address zero not allowed.");
117         
118         tokenAddress = token;
119     }
120     
121     function setTokenDecimals(uint256 decimals) external onlyOwner {
122        tokenDecimals = decimals;
123     }
124     
125     function setMinEthLimit(uint256 amount) external onlyOwner {
126         minEthLimit = amount;    
127     }
128     
129     function setMaxEthLimit(uint256 amount) external onlyOwner {
130         maxEthLimit = amount;    
131     }
132     
133     function setTokenRatePerEth(uint256 rate) external onlyOwner {
134         tokenRatePerEth = rate;
135     }
136     
137     function setRateDecimals(uint256 decimals) external onlyOwner {
138         rateDecimals = decimals;
139     }
140     
141     receive() external payable{
142         require(isPresaleOpen, "Presale is not open.");
143         require(
144                 usersInvestments[msg.sender].add(msg.value) <= maxEthLimit
145                 && usersInvestments[msg.sender].add(msg.value) >= minEthLimit,
146                 "Installment Invalid."
147             );
148         
149         //@dev calculate the amount of tokens to transfer for the given eth
150         uint256 tokenAmount = getTokensPerEth(msg.value);
151         
152         require(IToken(tokenAddress).transfer(msg.sender, tokenAmount), "Insufficient balance of presale contract!");
153         
154         usersInvestments[msg.sender] = usersInvestments[msg.sender].add(msg.value);
155         
156         //@dev send received funds to the owner
157         owner.transfer(msg.value);
158     }
159     
160     function getTokensPerEth(uint256 amount) internal view returns(uint256) {
161         return amount.mul(tokenRatePerEth).div(
162             10**(uint256(18).sub(tokenDecimals).add(rateDecimals))
163             );
164     }
165     
166     function burnUnsoldTokens() external onlyOwner {
167         require(!isPresaleOpen, "You cannot burn tokens untitl the presale is closed.");
168         
169         IToken(tokenAddress).burnTokens(IToken(tokenAddress).balanceOf(address(this)));   
170     }
171     
172     function getUnsoldTokens() external onlyOwner {
173         require(!isPresaleOpen, "You cannot get tokens until the presale is closed.");
174         
175         IToken(tokenAddress).transfer(owner, IToken(tokenAddress).balanceOf(address(this)) );
176     }
177 }