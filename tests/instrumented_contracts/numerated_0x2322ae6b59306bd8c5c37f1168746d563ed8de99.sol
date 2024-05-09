1 pragma solidity ^0.4.16;
2 /*
3 ETHB Crowdsale Contract
4 
5 Contract developer: Fares A. Akel C.
6 f.antonio.akel@gmail.com
7 MIT PGP KEY ID: 078E41CB
8 */
9 
10 /**
11  * @title SafeMath by OpenZeppelin
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30   }
31 }
32 
33 contract ERC20Token {
34 
35 	function balanceOf(address who) public constant returns (uint);
36 	function transfer(address to, uint value) public;	
37 }
38 
39 /**
40  * This contract is administered
41  */
42 
43 contract admined {
44     address public admin; //Admin address is public
45     /**
46     * @dev This constructor set the initial admin of the contract
47     */
48     function admined() internal {
49         admin = msg.sender; //Set initial admin to contract creator
50         Admined(admin);
51     }
52 
53     modifier onlyAdmin() { //A modifier to define admin-allowed functions
54         require(msg.sender == admin);
55         _;
56     }
57     /**
58     * @dev Transfer the adminship of the contract
59     * @param _newAdmin The address of the new admin.
60     */
61     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
62         require(_newAdmin != address(0));
63         admin = _newAdmin;
64         TransferAdminship(admin);
65     }
66     //All admin actions have a log for public review
67     event TransferAdminship(address newAdmin);
68     event Admined(address administrador);
69 }
70 
71 
72 contract ETHBCrowdsale is admined{
73 	/**
74     * Variables definition - Public
75     */
76     uint256 public startTime = now; //block-time when it was deployed
77     uint256 public totalDistributed = 0;
78     uint256 public currentBalance = 0;
79     ERC20Token public tokenReward;
80     address public creator;
81     address public ethWallet;
82     string public campaignUrl;
83     uint256 public constant version = 1;
84     uint256 public exchangeRate = 20000000; //1 ETH (18decimals) = 500 ETHB (8decimals)
85                                                                          //(1*10^18)/(500*10^8) = 20000000 ETH/ETHB
86 
87     event TokenWithdrawal(address _to,uint256 _withdraw);
88 	event PayOut(address _to,uint256 _withdraw);
89 	event TokenBought(address _buyer, uint256 _amount);
90 
91     /**
92     * @dev Transfer the adminship of the contract
93     * @param _ethWallet The address of the wallet used to payout ether.
94     * @param _campaignUrl URL of this crowdsale.
95     */
96     function ETHBCrowdsale(
97     	address _ethWallet,
98     	string _campaignUrl) public {
99 
100     	tokenReward = ERC20Token(0x3a26746Ddb79B1B8e4450e3F4FFE3285A307387E);
101     	creator = msg.sender;
102     	ethWallet = _ethWallet;
103     	campaignUrl = _campaignUrl;
104     }
105     /**
106     * @dev Exchange function
107     */
108     function exchange() public payable {
109     	require (tokenReward.balanceOf(this) > 0);
110     	require (msg.value > 1 finney);
111 
112     	uint256 tokenBought = SafeMath.div(msg.value,exchangeRate);
113 
114     	require(tokenReward.balanceOf(this) >= tokenBought );
115     	currentBalance = SafeMath.add(currentBalance,msg.value);
116     	totalDistributed = SafeMath.add(totalDistributed,tokenBought);
117     	tokenReward.transfer(msg.sender,tokenBought);
118 		TokenBought(msg.sender, tokenBought);
119 
120     }
121     /**
122     * @dev Withdraw remaining tokens to an specified address
123     * @param _to address to transfer tokens.
124     */
125     function tokenWithdraw (address _to) onlyAdmin public {
126     	require( _to != 0x0 );
127     	require(tokenReward.balanceOf(this)>0);
128     	uint256 withdraw = tokenReward.balanceOf(this);
129     	tokenReward.transfer(_to,withdraw);
130     	TokenWithdrawal(_to,withdraw);
131     }
132     /**
133     * @dev Withdraw collected ether to ethWallet
134     */
135     function ethWithdraw () onlyAdmin public {
136     	require(this.balance > 0);
137     	uint256 withdraw = this.balance;
138     	currentBalance = 0;
139     	require(ethWallet.send(withdraw));
140     	PayOut(ethWallet,withdraw);
141     }
142     /**
143     * @dev callback function to deal with direct transfers
144     */
145     function () public payable{
146         exchange();
147     }
148 }