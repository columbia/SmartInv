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
45     uint256 public decimals = 18;
46     uint256 public fixamt = 100 * (10 ** uint256(decimals));
47     address public owner;
48     address public wallet;
49     ERC20 public token;
50     address[] public bountyaddress;
51     mapping (address => bool) public admins;
52     mapping (address => bool) public bounty;
53 	
54     modifier onlyOwner {
55        require(msg.sender == owner);
56        _;
57     }
58 	
59      function ImmAirDropA(ERC20 _token, address _wallet) public {
60         require(_token != address(0));
61         token = _token;
62         admins[msg.sender] = true;
63         owner = msg.sender;
64         wallet = _wallet;
65     }
66 
67    modifier onlyAdmin {
68         require(admins[msg.sender]);
69         _;
70     }
71 
72 	function addAdminWhitelist(address _userlist) public onlyOwner onlyAdmin{
73 		if(_userlist != address(0) && !admins[_userlist]){
74 			admins[_userlist] = true;
75 		}
76 	}
77 	
78 	function reClaimBalance() public onlyAdmin{
79 		uint256 taBal = token.balanceOf(this);
80 		token.transfer(wallet, taBal);
81 	}
82 	
83 	function adminUpdateWallet(address _wallet) public onlyAdmin{
84 		require(_wallet != address(0));
85 		wallet = _wallet;
86 	}
87 
88     function signupUserWhitelist(address[] _userlist) public onlyAdmin{
89     	require(_userlist.length > 0);
90     	for (uint256 i = 0; i < _userlist.length; i++) {
91     		if(_userlist[i] != address(0) && !bounty[_userlist[i]]){
92             	bounty[_userlist[i]] = true;
93             	bountyaddress.push(_userlist[i]) -1;
94     			token.transfer(_userlist[i], fixamt);
95     		}
96     	}
97     }
98 	
99 	function getBountyAddress() view public onlyAdmin returns(address[]){
100 		return bountyaddress;
101 	}
102 
103 	function () external payable {
104 		revert();
105 	}
106 	
107 }