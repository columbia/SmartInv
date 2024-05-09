1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address who) public view returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract ImmAirDropA{
44     using SafeMath for uint256;
45 	
46     struct User{
47 		address user_address;
48 		uint signup_time;
49 		uint256 reward_amount;
50 		bool blacklisted;
51 		uint paid_time;
52 		uint256 paid_token;
53 		bool status;
54 	}
55 	
56     uint256 fixamt = 100000000000000000000;
57     address public owner;
58 	
59     /* @dev Assigned wallet where the remaining unclaim tokens to be return */
60     address public wallet;
61 	
62     /* @dev The token being distribute */
63     ERC20 public token;
64 
65     /* @dev To record the different reward amount for each bounty  */
66     mapping(address => User) public bounties;
67 	
68     /* @dev Admin with permission to manage the signed up bounty */
69     mapping (address => bool) public admins;
70 	
71     function ImmAirDropA(ERC20 _token, address _wallet) public {
72         require(_token != address(0));
73         token = _token;
74         admins[msg.sender] = true;
75         owner = msg.sender;
76         wallet = _wallet;
77     }
78 
79     modifier onlyOwner {
80        require(msg.sender == owner);
81        _;
82     }
83 	
84     modifier onlyAdmin {
85         require(admins[msg.sender]);
86         _;
87     }
88 
89 	function addAdminWhitelist(address _userlist) public onlyOwner onlyAdmin{
90 		if(_userlist != address(0) && !admins[_userlist]){
91 			admins[_userlist] = true;
92 		}
93 	}
94 	
95 	function reClaimBalance() public onlyAdmin{
96 		uint256 taBal = token.balanceOf(this);
97 		token.transfer(wallet, taBal);
98 	}
99 	
100 	function adminUpdateWallet(address _wallet) public onlyAdmin{
101 		require(_wallet != address(0));
102 		wallet = _wallet;
103 	}
104 
105     function signupUserWhitelist(address[] _userlist) public onlyAdmin{
106     	require(_userlist.length > 0);
107     	for (uint256 i = 0; i < _userlist.length; i++) {
108     		address baddr = _userlist[i];
109     		if(baddr != address(0)){
110     			if(bounties[baddr].user_address != baddr){
111 					bounties[baddr] = User(baddr,now,0,false,now,fixamt,true);
112 					token.transfer(baddr, fixamt);
113     			}
114     		}
115     	}
116     }
117 	
118 	function () external payable {
119 		revert();
120 	}
121 	
122 }