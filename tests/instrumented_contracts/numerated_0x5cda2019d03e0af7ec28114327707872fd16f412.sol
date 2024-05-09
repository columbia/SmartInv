1 pragma solidity ^0.4.25 ;
2 
3 interface IERC20Token {                                     
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function decimals() external returns (uint256);
7 }
8 
9 
10 contract INTPOS {
11     using SafeMath for uint ; 
12     IERC20Token public tokenContract ;
13     address public owner;
14     
15     mapping (address => bool) public isMinting ; 
16     mapping(address => uint256) public mintingAmount ;
17     mapping(address => uint256) public mintingStart ; 
18     
19     uint256 public totalMintedAmount = 0 ;
20     uint256 public mintingAvailable = 10 * 10**6 * 10 ** 18 ; //10 mil * decimals
21     
22     uint32 public interestEpoch = 2678400 ; //1% per 31 days or 1 month
23     
24     uint8 interest = 100 ; //1% interest
25     
26     bool locked = false ;
27     
28     constructor(IERC20Token _tokenContract) public {
29         tokenContract = _tokenContract ;
30         owner = msg.sender ; 
31     }
32     
33     modifier canMint() {
34         require(totalMintedAmount <= mintingAvailable) ; 
35         _;
36     }
37     
38     modifier canClaim() {
39         require(getCoinAge(msg.sender) >= interestEpoch) ; 
40         _;
41     }
42     
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         owner = newOwner;
50     }
51     
52     function destroyOwnership() public onlyOwner {
53         owner = address(0) ; 
54     }
55     
56     function stopContract() public onlyOwner {
57         tokenContract.transfer(msg.sender, tokenContract.balanceOf(address(this))) ;
58         msg.sender.transfer(address(this).balance) ;  
59     }
60     
61         
62     function lockContract() public onlyOwner returns (bool success) {
63         locked = true ; 
64         return true ; 
65     }
66     
67     function startMint() canMint public {
68         require(tokenContract.balanceOf(msg.sender) >= interest);
69         require(isMinting[msg.sender] == false) ;
70         require(mintingStart[msg.sender] <= now) ; 
71         
72         isMinting[msg.sender] = true ; 
73         mintingAmount[msg.sender] = tokenContract.balanceOf(msg.sender); 
74         mintingStart[msg.sender] = now ; 
75     } 
76     
77     function stopMint() canClaim public {
78         require(mintingStart[msg.sender] <= now) ; 
79         require(isMinting[msg.sender] == true) ; 
80         require(tokenContract.balanceOf(msg.sender) >= mintingAmount[msg.sender]) ; 
81         
82         isMinting[msg.sender] = false ; 
83       
84         tokenContract.transfer(msg.sender, getMintingReward(msg.sender)) ; 
85         mintingAmount[msg.sender] = 0 ; 
86     }
87 
88     
89     function getMintingReward(address minter) public view returns (uint256 reward) {
90         uint age = getCoinAge(minter) ; 
91         
92         return age/interestEpoch * mintingAmount[msg.sender]/interest ;
93     }
94     
95     function getCoinAge(address minter) public view returns(uint256 age){
96         return (now - mintingStart[minter]) ; 
97     }
98     
99     function ceil(uint a, uint m) public pure returns (uint ) {
100         return ((a + m - 1) / m) * m;
101     }
102 }
103 
104 library SafeMath {
105   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106     if (a == 0) {
107       return 0;
108     }
109     uint256 c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a / b;
116     return c;
117   }
118 
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }