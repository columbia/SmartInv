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
77 contract PreSale is Owned {
78     using SafeMath for uint256;
79     address public tokenAddress;
80     bool public saleOpen;
81     uint256 tokenRatePerEth = 30_000; 
82     
83     mapping(address => uint256) public usersInvestments;
84     
85     constructor() public {
86         owner = msg.sender;
87     }
88     
89     function startSale() external onlyOwner{
90         require(!saleOpen, "Sale is open");
91         saleOpen = true;
92     }
93     
94     function setTokenAddress(address tokenContract) external onlyOwner{
95         require(tokenAddress == address(0), "token address already set");
96         tokenAddress = tokenContract;
97     }
98     
99     function closeSale() external onlyOwner{
100         require(saleOpen, "Sale is not open");
101         saleOpen = false;
102     }
103 
104     receive() external payable{
105         require(saleOpen, "Sale is not open");
106         require(usersInvestments[msg.sender].add(msg.value) <= 3 ether 
107                 && usersInvestments[msg.sender].add(msg.value) >= 500 finney,
108                 "Installment must be in range of 3 to 0.5 ether");
109         
110         uint256 tokens = getTokenAmount(msg.value);
111         
112         require(IToken(tokenAddress).transfer(msg.sender, tokens), "Insufficient balance of sale contract!");
113         
114         usersInvestments[msg.sender] = usersInvestments[msg.sender].add(msg.value);
115         
116         // send received funds to the owner
117         owner.transfer(msg.value);
118     }
119     
120     function getTokenAmount(uint256 amount) internal view returns(uint256){
121         return amount.mul(tokenRatePerEth);
122     }
123     
124     function burnUnSoldTokens() external onlyOwner{
125         require(!saleOpen, "Please close the sale first");
126         IToken(tokenAddress).burnTokens(IToken(tokenAddress).balanceOf(address(this)));   
127     }
128 }