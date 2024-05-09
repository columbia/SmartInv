1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender)
21         public view returns (uint256);
22 
23     function transferFrom(address from, address to, uint256 value)
24         public returns (bool);
25 
26     function approve(address spender, uint256 value) public returns (bool);
27     event Approval(
28             address indexed owner,
29             address indexed spender,
30             uint256 value
31             );
32 }
33 
34 /**
35  * @title SafeERC20
36  * @dev Wrappers around ERC20 operations that throw on failure.
37  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
38  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
39  */
40 library SafeERC20 {
41     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
42         require(token.transfer(to, value));
43     }
44 
45     function safeTransferFrom(
46             ERC20 token,
47             address from,
48             address to,
49             uint256 value
50             )
51         internal
52         {
53             require(token.transferFrom(from, to, value));
54         }
55 
56     function safeApprove(ERC20 token, address spender, uint256 value) internal {
57         require(token.approve(spender, value));
58     }
59 }
60 
61 /**
62  * @title TokenTimelock
63  * @dev TokenTimelock is a token holder contract that will allow a
64  * beneficiary to extract the tokens after a given release time
65  */
66 contract TokenTimelock {
67     using SafeERC20 for ERC20Basic;
68 
69     // ERC20 basic token contract being held
70     ERC20Basic public token;
71 
72     // beneficiary of tokens after they are released
73     address public beneficiary = 0x2F1C2Fb4cf9b46172D59d8878Fc795277b8a2c9a;
74 
75     // timestamp when token release is enabled
76     uint256 public firstTime = 1529942400;         //2018-06-26
77     uint256 public secondTime = 1532534400;        //2018-07-26
78     uint256 public thirdTime = 1535212800;         //2018-08-26
79 
80     uint256 public firstPay = 900000000000000000000000000;    //900 million  FTI
81     uint256 public secondPay = 900000000000000000000000000;    //900 million  FTI
82     uint256 public thirdPay = 600000000000000000000000000;    //900 million  FTI
83 
84     constructor(
85             ERC20Basic _token
86             )
87         public
88         {
89             token = _token;
90         }
91 
92     /**
93      * @notice Transfers tokens held by timelock to beneficiary.
94      */
95     function release() public {
96         uint256 tmpPay = 0;
97         if(block.timestamp >= firstTime && firstPay > 0){
98             tmpPay = firstPay;
99             firstPay = 0;
100         }else if(block.timestamp >= secondTime && secondPay > 0 ){
101             tmpPay = secondPay;
102             secondPay = 0;
103         }else if (block.timestamp >= thirdTime && thirdPay > 0) {
104             tmpPay = token.balanceOf(this);
105             thirdPay = 0;
106         }
107         require(tmpPay > 0);
108         uint256 amount = token.balanceOf(this);
109         require(amount >= tmpPay);
110         token.safeTransfer(beneficiary, tmpPay);
111     }
112 }