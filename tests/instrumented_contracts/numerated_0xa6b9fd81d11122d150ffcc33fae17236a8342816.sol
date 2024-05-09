1 pragma solidity ^0.4.16;  
2 /*
3 ETHB Crowdsale Contract
4 
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16     }
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27   }
28 }
29 
30 contract ERC20Token {
31 
32 	function balanceOf(address who) public constant returns (uint);
33 	function transfer(address to, uint value) public;	
34 }
35 
36 /**
37  * This contract is administered
38  */
39 
40 contract admined {
41     address public admin; //Admin address is public
42     /**
43     * @dev This constructor set the initial admin of the contract
44     */
45     function admined() internal {
46         admin = msg.sender; //Set initial admin to contract creator
47         Admined(admin);
48     }
49 
50     modifier onlyAdmin() { //A modifier to define admin-allowed functions
51         require(msg.sender == admin);
52         _;
53     }
54     /**
55     * @dev Transfer the adminship of the contract
56     * @param _newAdmin The address of the new admin.
57     */
58     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
59         require(_newAdmin != address(0));
60         admin = _newAdmin;
61         TransferAdminship(admin);
62     }
63     //All admin actions have a log for public review
64     event TransferAdminship(address newAdmin);
65     event Admined(address administrador);
66 }
67 
68 
69 contract ETHBCrowdsale is admined{
70 	/**
71     * Variables definition - Public
72     */
73     uint256 public startTime = now; //block-time when it was deployed
74     uint256 public totalDistributed = 0;
75     uint256 public currentBalance = 0;
76     ERC20Token public tokenReward;
77     address public creator;
78     address public ethWallet;
79     string public campaignUrl;
80     uint256 public constant version = 1;
81     uint256 public exchangeRate = 10**7; //1 ETH (18decimals) = 1000 ETHB (8decimals)
82     									 //(1*10^18)/(1000*10^8) = 1*10^7 ETH/ETHB
83 
84     event TokenWithdrawal(address _to,uint256 _withdraw);
85 	event PayOut(address _to,uint256 _withdraw);
86 	event TokenBought(address _buyer, uint256 _amount);
87 
88     /**
89     * @dev Transfer the adminship of the contract
90     * @param _ethWallet The address of the wallet used to payout ether.
91     * @param _campaignUrl URL of this crowdsale.
92     */
93     function ETHBCrowdsale(
94     	address _ethWallet,
95     	string _campaignUrl) public {
96 
97     	tokenReward = ERC20Token(0x3a26746Ddb79B1B8e4450e3F4FFE3285A307387E);
98     	creator = msg.sender;
99     	ethWallet = _ethWallet;
100     	campaignUrl = _campaignUrl;
101     }
102     /**
103     * @dev Exchange function
104     */
105     function exchange() public payable {
106     	require (tokenReward.balanceOf(this) > 0);
107     	require (msg.value > 1 finney);
108 
109     	uint256 tokenBought = SafeMath.div(msg.value,exchangeRate);
110 
111     	require(tokenReward.balanceOf(this) >= tokenBought );
112     	currentBalance = SafeMath.add(currentBalance,msg.value);
113     	totalDistributed = SafeMath.add(totalDistributed,tokenBought);
114     	tokenReward.transfer(msg.sender,tokenBought);
115 		TokenBought(msg.sender, tokenBought);
116 
117     }
118     /**
119     * @dev Withdraw remaining tokens to an specified address
120     * @param _to address to transfer tokens.
121     */
122     function tokenWithdraw (address _to) onlyAdmin public {
123     	require( _to != 0x0 );
124     	require(tokenReward.balanceOf(this)>0);
125     	uint256 withdraw = tokenReward.balanceOf(this);
126     	tokenReward.transfer(_to,withdraw);
127     	TokenWithdrawal(_to,withdraw);
128     }
129     /**
130     * @dev Withdraw collected ether to ethWallet
131     */
132     function ethWithdraw () onlyAdmin public {
133     	require(this.balance > 0);
134     	uint256 withdraw = this.balance;
135     	currentBalance = 0;
136     	require(ethWallet.send(withdraw));
137     	PayOut(ethWallet,withdraw);
138     }
139     /**
140     * @dev callback function to deal with direct transfers
141     */
142     function () public payable{
143         exchange();
144     }
145 }