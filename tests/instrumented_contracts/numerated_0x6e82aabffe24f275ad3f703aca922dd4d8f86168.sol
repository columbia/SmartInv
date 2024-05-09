1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     if (a == 0) {
40       return 0;
41     }
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 
77 /**
78  * @title Ownable
79  * @dev The Ownable contract has an owner address, and provides basic authorization control
80  * functions, this simplifies the implementation of "user permissions".
81  */
82 contract Ownable {
83   address public owner;
84 
85 
86   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   function Ownable() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     emit OwnershipTransferred(owner, newOwner);
112     owner = newOwner;
113   }
114 
115 }
116 
117 
118 contract BatchTransfer is Ownable {
119     using SafeMath for uint256;
120 
121     event Withdraw(address indexed receiver, address indexed token, uint amount);
122     event TransferEther(address indexed sender, address indexed receiver, uint256 amount);
123 
124     modifier checkArrayArgument(address[] _receivers, uint256[] _amounts) {
125         require(_receivers.length == _amounts.length && _receivers.length != 0);
126         _;
127     }
128 
129     function batchTransferToken(address _token, address[] _receivers, uint256[] _tokenAmounts) public checkArrayArgument(_receivers, _tokenAmounts) {
130         require(_token != address(0));
131 
132         ERC20 token = ERC20(_token);
133         require(allowanceForContract(_token) >= getTotalSendingAmount(_tokenAmounts));
134 
135         for (uint i = 0; i < _receivers.length; i++) {
136             require(_receivers[i] != address(0));
137             require(token.transferFrom(msg.sender, _receivers[i], _tokenAmounts[i]));
138         }
139     }
140 
141     function batchTransferEther(address[] _receivers, uint[] _amounts) public payable checkArrayArgument(_receivers, _amounts) {
142         require(msg.value != 0 && msg.value == getTotalSendingAmount(_amounts));
143 
144         for (uint i = 0; i < _receivers.length; i++) {
145             require(_receivers[i] != address(0));
146             _receivers[i].transfer(_amounts[i]);
147             emit TransferEther(msg.sender, _receivers[i], _amounts[i]);
148         }
149     }
150 
151     function withdraw(address _receiver, address _token) public onlyOwner {
152         ERC20 token = ERC20(_token);
153         uint tokenBalanceOfContract = token.balanceOf(this);
154         require(_receiver != address(0) && tokenBalanceOfContract > 0);
155         require(token.transfer(_receiver, tokenBalanceOfContract));
156         emit Withdraw(_receiver, _token, tokenBalanceOfContract);
157     }
158 
159     function balanceOfContract(address _token) public view returns (uint) {
160         ERC20 token = ERC20(_token);
161         return token.balanceOf(this);
162     }
163 
164     function allowanceForContract(address _token) public view returns (uint) {
165         ERC20 token = ERC20(_token);
166         return token.allowance(msg.sender, this);
167     }
168 
169     function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {
170         for (uint i = 0; i < _amounts.length; i++) {
171             require(_amounts[i] > 0);
172             totalSendingAmount = totalSendingAmount.add(_amounts[i]);
173         }
174     }
175 }