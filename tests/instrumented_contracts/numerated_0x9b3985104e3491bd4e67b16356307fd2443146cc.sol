1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 
35 /**
36  * @title SafeERC20
37  * @dev Wrappers around ERC20 operations that throw on failure.
38  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
39  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
40  */
41 library SafeERC20 {
42   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
43     require(token.transfer(to, value));
44   }
45 
46   function safeTransferFrom(
47     ERC20 token,
48     address from,
49     address to,
50     uint256 value
51   )
52     internal
53   {
54     require(token.transferFrom(from, to, value));
55   }
56 
57   function safeApprove(ERC20 token, address spender, uint256 value) internal {
58     require(token.approve(spender, value));
59   }
60 }
61 
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74     // benefit is lost if 'b' is also tested.
75     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76     if (a == 0) {
77       return 0;
78     }
79 
80     c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 contract OpetEscrow {
114 
115 	using SafeMath for uint256;
116 	using SafeERC20 for ERC20;
117 
118 	ERC20 public opetToken;
119 	address public opetWallet;
120 
121 	ERC20 public pecunioToken;
122 	address public pecunioWallet;
123 
124 	uint256 public depositCount;
125 
126 	modifier onlyParticipants() {
127 	    require(msg.sender == opetWallet || msg.sender == pecunioWallet);
128 	    _;
129 	}
130 
131 	constructor(ERC20 _opetToken, address _opetWallet, ERC20 _pecunioToken, address _pecunioWallet) public {
132 		require(_opetToken != address(0));
133 		require(_opetWallet != address(0));
134 		require(_pecunioToken != address(0));
135 		require(_pecunioWallet != address(0));
136 
137 	    opetToken = _opetToken;
138 	    opetWallet = _opetWallet;
139 	    pecunioToken = _pecunioToken;
140 	    pecunioWallet = _pecunioWallet;
141 	    depositCount = 0;
142 	}
143 
144 	function() public payable {
145 		revert();
146 	}
147 
148 	function opetTokenBalance() view public returns (uint256) {
149 	    return opetToken.balanceOf(this);
150 	}
151 
152 	function pecunioTokenBalance() view public returns (uint256) {
153 	    return pecunioToken.balanceOf(this);
154 	}
155 
156 	function initiateDeposit() onlyParticipants public {
157 		require(depositCount < 2);
158 
159 		uint256 opetInitital = uint256(2000000).mul(uint256(10)**uint256(18));
160 		uint256 pecunioInitital = uint256(1333333).mul(uint256(10)**uint256(8));
161 
162 		require(opetToken.allowance(opetWallet, this) == opetInitital);
163 		require(pecunioToken.allowance(pecunioWallet, this) == pecunioInitital);
164 
165 		opetToken.safeTransferFrom(opetWallet, this, opetInitital);
166 		pecunioToken.safeTransferFrom(pecunioWallet, this, pecunioInitital);
167 
168 		depositCount = depositCount.add(1);
169 	}
170 
171 	function refundTokens() onlyParticipants public {
172 		require(opetToken.balanceOf(this) > 0);
173 		require(pecunioToken.balanceOf(this) > 0);
174 
175 		opetToken.safeTransfer(opetWallet, opetToken.balanceOf(this));
176 		pecunioToken.safeTransfer(pecunioWallet, pecunioToken.balanceOf(this));
177 
178 	}
179 
180 	function releaseTokens() onlyParticipants public {
181 		// 30-06-2019 00:00:00 UTC
182 		require(block.timestamp > 1561852800);
183 		require(opetToken.balanceOf(this) > 0);
184 		require(pecunioToken.balanceOf(this) > 0);
185 
186 		opetToken.safeTransfer(pecunioWallet, opetToken.balanceOf(this));
187 		pecunioToken.safeTransfer(opetWallet, pecunioToken.balanceOf(this));
188 	}
189 
190 }