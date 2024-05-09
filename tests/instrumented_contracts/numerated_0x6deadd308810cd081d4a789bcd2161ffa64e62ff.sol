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
50     mapping (address => bool) public admins;
51 	
52     modifier onlyOwner {
53        require(msg.sender == owner);
54        _;
55     }
56 	
57      function ImmAirDropA(ERC20 _token, address _wallet) public {
58         require(_token != address(0));
59         token = _token;
60         admins[msg.sender] = true;
61         owner = msg.sender;
62         wallet = _wallet;
63     }
64 
65    modifier onlyAdmin {
66         require(admins[msg.sender]);
67         _;
68     }
69 
70 	function addAdminWhitelist(address _userlist) public onlyOwner onlyAdmin{
71 		if(_userlist != address(0) && !admins[_userlist]){
72 			admins[_userlist] = true;
73 		}
74 	}
75 	
76 	function reClaimBalance() public onlyAdmin{
77 		uint256 taBal = token.balanceOf(this);
78 		token.transfer(wallet, taBal);
79 	}
80 	
81 	function adminUpdateWallet(address _wallet) public onlyAdmin{
82 		require(_wallet != address(0));
83 		wallet = _wallet;
84 	}
85 
86     function signupUserWhitelist(address[] _userlist) public onlyAdmin{
87     	require(_userlist.length > 0);
88     	for (uint256 i = 0; i < _userlist.length; i++) {
89     		if(_userlist[i] != address(0)){
90     			token.transfer(_userlist[i], fixamt);
91     		}
92     	}
93     }
94 	
95 	function () external payable {
96 		revert();
97 	}
98 	
99 }