1 pragma solidity ^0.6.0;
2 // SPDX-License-Identifier: UNLICENSED
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
72 }
73 
74 
75 contract PreSale is Owned {
76     using SafeMath for uint256;
77     address public tokenAddress;
78     bool public saleOpen;
79     uint256 tokenRatePerEth = 160000; // 1 ether = 160000 tokens approx
80 
81     constructor() public {
82         owner = msg.sender;
83     }
84     
85     function setTokenAddress(address _tokenAddress) external onlyOwner{
86         require(tokenAddress == address(0), "address already set");
87         tokenAddress = _tokenAddress;
88     }
89     
90     function startSale() external onlyOwner{
91         require(!saleOpen, "Sale is already open");
92         saleOpen = true;
93     }
94     
95     function closeSale() external onlyOwner{
96         require(saleOpen, "Sale is not open");
97         saleOpen = false;
98     }
99 
100     receive() external payable{
101         
102         require(saleOpen, "Sale is not open");
103         require(msg.value >= 0.1 ether, "Min investment allowed is 0.1 ether");
104         
105         uint256 tokens = getTokenAmount(msg.value);
106         
107         require(IToken(tokenAddress).transfer(msg.sender, tokens), "Insufficient balance of sale contract!");
108         
109         // send received funds to the owner
110         owner.transfer(msg.value);
111     }
112     
113     function getTokenAmount(uint256 amount) internal view returns(uint256){
114         return amount.mul(tokenRatePerEth);
115     }
116     
117     function setTokenRate(uint256 ratePerEth) external onlyOwner{
118         require(!saleOpen, "Sale is open, cannot change now");
119         tokenRatePerEth = ratePerEth;
120     }
121 
122 }