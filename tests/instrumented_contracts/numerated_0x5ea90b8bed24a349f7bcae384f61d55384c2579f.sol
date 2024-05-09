1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9 
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a / b;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 interface TokenOLD {
33     function balanceOf(address who) external view returns (uint256);
34     function transferFrom(address from, address to, uint tokens) external returns (bool success);
35 }
36 
37 interface TokenNEW {
38     function transfer(address to, uint256 value) external returns (bool);
39 }
40 
41 contract ClaimSPTI{
42     
43     using SafeMath for uint256;
44     
45     TokenNEW public newTokenReward;
46     TokenOLD  public oldToken;
47     address public creator;
48     address public owner = 0x1Ab98C0833e034b1E81F4F0282914C615d795299;
49     uint256 public startDate;
50     uint256 public endDate;
51 
52 
53     modifier isCreator() {
54         require(msg.sender == creator);
55         _;
56     }
57 
58     event FundTransfer(address backer, uint amount, bool isContribution);
59     constructor() public {
60         startDate = 1538554875;
61         endDate = startDate + 30 days;
62         creator = msg.sender;
63         newTokenReward = TokenNEW(0xc91d83955486e5261528d1acc1956529d2fe282b); //Instantiate the new reward
64         oldToken = TokenOLD(0xa673802792379714201ebc5f586c3a44b0248681); //Instantiate old token to be replaced
65     }
66     
67     function() public payable {
68         
69         require(now > startDate);
70         require(now < endDate);
71         require(msg.value == 0); // Only 0 ether accepted, This is not an IC Oh!
72         uint oldSptiUserBal;
73         oldSptiUserBal = getBalance(msg.sender); //Get Old SPTI balance
74         require(oldSptiUserBal > 0); // Make sure claimant actually possesses Old SPTI
75         require(oldToken.transferFrom(msg.sender, 0xceC74106a23329745b07f6eC5e1E39803b3fF31F, oldSptiUserBal));
76         
77         //If all of the above happens accordingly, go ahead and release new token
78         //to old token holders
79         uint256 amount = oldSptiUserBal.div(8);
80         newTokenReward.transfer(msg.sender, amount);
81         emit FundTransfer(msg.sender, amount, true);
82 
83     }
84     
85     function getBalance(address userAddress) public view returns (uint256){
86         uint bal = oldToken.balanceOf(userAddress);
87         return bal;
88     }
89     
90     function transferToken(address to, uint256 value) isCreator public {
91         newTokenReward.transfer(to, value);      
92     }
93 
94     function kill() isCreator public {
95         selfdestruct(owner);
96     }
97 
98 }