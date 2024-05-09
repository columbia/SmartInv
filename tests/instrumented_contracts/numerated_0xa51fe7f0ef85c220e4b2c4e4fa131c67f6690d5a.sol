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
43 contract ImmAirDropB{
44     using SafeMath for uint256;
45     uint256 public decimals = 18;
46     address public wallet;
47     ERC20 public token;
48     mapping (address => bool) public admins;
49 
50 	
51      function ImmAirDropB(ERC20 _token, address _wallet) public {
52         require(_token != address(0));
53         token = _token;
54         admins[msg.sender] = true;
55         admins[_wallet] = true;
56         wallet = _wallet;
57     }
58 
59    modifier onlyAdmin {
60         require(admins[msg.sender]);
61         _;
62     }
63 
64 	function addAdminWhitelist(address _userlist) public onlyAdmin{
65 		if(_userlist != address(0) && !admins[_userlist]){
66 			admins[_userlist] = true;
67 		}
68 	}
69 
70     function signupUserWhitelist(address[] _userlist, uint256 _amttype) public onlyAdmin{
71     	require(_userlist.length > 0);
72     	uint256 useamt = _amttype * (10 ** uint256(decimals));
73     	for (uint256 i = 0; i < _userlist.length; i++) {
74     		if(_userlist[i] != address(0)){
75     			token.transfer(_userlist[i], useamt);
76     		}
77     	}
78     }
79 	
80 	function () external payable {
81 		revert();
82 	}
83 	
84 }