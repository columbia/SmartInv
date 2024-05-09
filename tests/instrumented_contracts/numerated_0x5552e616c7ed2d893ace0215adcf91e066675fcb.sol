1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 library SafeERC20 {
50   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
51     require(token.transfer(to, value));
52   }
53 
54   function safeTransferFrom(
55     ERC20 token,
56     address from,
57     address to,
58     uint256 value
59   )
60     internal
61   {
62     require(token.transferFrom(from, to, value));
63   }
64 
65   function safeApprove(ERC20 token, address spender, uint256 value) internal {
66     require(token.approve(spender, value));
67   }
68 }
69 
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender)
79     public view returns (uint256);
80 
81   function transferFrom(address from, address to, uint256 value)
82     public returns (bool);
83 
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(
86     address indexed owner,
87     address indexed spender,
88     uint256 value
89   );
90 }
91 
92 contract Ownable {
93   address public owner;
94 
95 
96   event OwnershipRenounced(address indexed previousOwner);
97   event OwnershipTransferred(
98     address indexed previousOwner,
99     address indexed newOwner
100   );
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129   /**
130    * @dev Allows the current owner to relinquish control of the contract.
131    */
132   function renounceOwnership() public onlyOwner {
133     emit OwnershipRenounced(owner);
134     owner = address(0);
135   }
136 }
137 
138 contract Distribution {
139 
140 	using SafeMath for uint256;
141 	using SafeERC20 for ERC20;
142 
143 	struct distributionInfo {
144 		ERC20 token;
145 		uint256 tokenDecimal;
146 	}
147 
148 	mapping (address => distributionInfo) wallets;
149 
150 	function() public payable {
151 		revert();
152 	}
153 
154 	function updateDistributionInfo(ERC20 _token, uint256 _tokenDecimal) public {
155 		require(_token != address(0));
156 		require(_tokenDecimal > 0);
157 
158 		distributionInfo storage wallet = wallets[msg.sender];
159 		wallet.token = _token;
160 		wallet.tokenDecimal = _tokenDecimal;
161 	} 
162 
163 	function distribute(address[] _addresses, uint256[] _amounts) public {
164 		require(wallets[msg.sender].token != address(0));
165 		require(_addresses.length == _amounts.length);
166 
167 	    for(uint256 i = 0; i < _addresses.length; i++){
168 	    	require(wallets[msg.sender].token.balanceOf(msg.sender) >= _amounts[i]);
169 	    	require(wallets[msg.sender].token.allowance(msg.sender,this) >= _amounts[i]);
170 	    	wallets[msg.sender].token.safeTransferFrom(msg.sender, _addresses[i], _amounts[i]);
171 	    }
172 	}
173 
174 	function getDistributionInfo(address _address) view public returns (ERC20, uint256) {
175         return (wallets[_address].token, wallets[_address].tokenDecimal);
176     }
177 
178 }