1 pragma solidity ^0.4.25 ;
2 
3 interface IERC20Token {                                     
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
7     function decimals() external returns (uint256);
8 }
9 
10 
11 contract ITNPOS {
12     using SafeMath for uint ; 
13     IERC20Token public tokenContract ;
14     address public owner;
15     
16     mapping (address => bool) public isMinting ; 
17     mapping(address => uint256) public mintingAmount ;
18     mapping(address => uint256) public mintingStart ; 
19     
20     uint256 public totalMintedAmount = 0 ;
21     uint256 public mintingAvailable = 10 * 10**6 * 10 ** 18 ; //10 mil * decimals
22     
23     uint32 public interestEpoch = 2678400 ; //1% per 31 days or 1 month
24     
25     uint8 interest = 100 ; //1% interest
26     
27     bool locked = false ;
28     
29     constructor(IERC20Token _tokenContract) public {
30         tokenContract = _tokenContract ;
31         owner = msg.sender ; 
32     }
33     
34     modifier canMint() {
35         require(totalMintedAmount <= mintingAvailable) ; 
36         _;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) public onlyOwner {
45         owner = newOwner;
46     }
47     
48     function destroyOwnership() public onlyOwner {
49         owner = address(0) ; 
50     }
51     
52     function stopContract() public onlyOwner {
53         tokenContract.transfer(msg.sender, tokenContract.balanceOf(address(this))) ;
54         msg.sender.transfer(address(this).balance) ;  
55     }
56     
57         
58     function lockContract() public onlyOwner returns (bool success) {
59         locked = true ; 
60         return true ; 
61     }
62     
63     
64     function mint(uint amount) canMint payable public {
65         require(isMinting[msg.sender] == false) ;
66         require(tokenContract.balanceOf(msg.sender) >= interest);
67         require(mintingStart[msg.sender] <= now) ; 
68         
69         tokenContract.transferFrom(msg.sender, address(this), amount) ; 
70         
71         isMinting[msg.sender] = true ; 
72         mintingAmount[msg.sender] = amount; 
73         mintingStart[msg.sender] = now ; 
74     } 
75     
76     function stopMint() public {
77         require(mintingStart[msg.sender] <= now) ; 
78         require(isMinting[msg.sender] == true) ; 
79         
80         isMinting[msg.sender] = false ; 
81       
82         tokenContract.transfer(msg.sender, (mintingAmount[msg.sender] + getMintingReward(msg.sender))) ; 
83         mintingAmount[msg.sender] = 0 ; 
84     }
85 
86     
87     function getMintingReward(address minter) public view returns (uint256 reward) {
88         uint age = getCoinAge(minter) ; 
89         
90         return age/interestEpoch * mintingAmount[msg.sender]/interest ;
91     }
92     
93     function getCoinAge(address minter) public view returns(uint256 age){
94         return (now - mintingStart[minter]) ; 
95     }
96     
97     function ceil(uint a, uint m) public pure returns (uint ) {
98         return ((a + m - 1) / m) * m;
99     }
100 }
101 
102 library SafeMath {
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104     if (a == 0) {
105       return 0;
106     }
107     uint256 c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a / b;
114     return c;
115   }
116 
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }