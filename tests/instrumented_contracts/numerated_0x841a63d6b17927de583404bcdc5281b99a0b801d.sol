1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-15
3 */
4 
5 pragma solidity 0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, reverts on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     uint256 c = a * b;
25     require(c / a == b);
26 
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b > 0); // Solidity only automatically asserts when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38     return c;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     require(b <= a);
46     uint256 c = a - b;
47 
48     return c;
49   }
50 
51   /**
52   * @dev Adds two numbers, reverts on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     require(c >= a);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63   * reverts when dividing by zero.
64   */
65   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b != 0);
67     return a % b;
68   }
69 }
70 
71 library SafeERC20 {
72     /**
73     * @dev Transfer token for a specified address
74     * @param _token erc20 The address of the ERC20 contract
75     * @param _to address The address which you want to transfer to
76     * @param _value uint256 the _value of tokens to be transferred
77     * @return bool whether the transfer was successful or not
78     */
79     function safeTransfer(Token _token, address _to, uint256 _value) internal returns (bool) {
80         uint256 prevBalance = _token.balanceOf(address(this));
81 
82         if (prevBalance < _value) {
83             // Insufficient funds
84             return false;
85         }
86 
87         address(_token).call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
88 
89         // Fail if the new balance its not equal than previous balance sub _value
90         return prevBalance - _value == _token.balanceOf(address(this));
91     }
92 }
93 
94 interface Token {
95     function transfer(address _to, uint256 _value) external returns (bool success);
96     function balanceOf(address who) external view returns (uint256 balance);
97     function transferFrom(address from, address to, uint value) external returns (bool);
98     function allowance(address owner, address spender) external view returns (uint256);
99 }
100 
101 contract Sellix {
102     using SafeMath for uint256;
103     
104     address public owner;
105     uint public tokenSendFee; // in wei
106     uint public ethSendFee; // in wei
107     
108     constructor() public payable {
109         owner = msg.sender;
110     }
111     
112     modifier onlyOwner() {
113       require(msg.sender == owner);
114       _;
115     }
116     
117     function balance() public constant returns (uint value) {
118         return address(this).balance;
119     }
120     
121     function balanceToken(Token tokenAddr) public constant returns (uint value) {
122         return tokenAddr.balanceOf(address(this));
123     }
124     
125     function deposit() payable public returns (bool) {
126         return true;
127     }
128     
129     function withdrawEth(address addr, uint amount) public onlyOwner returns(bool success) {
130         addr.transfer(amount * 1 wei);
131         return true;
132     }
133     
134     function withdrawToken(Token tokenAddr, address _to, uint _amount) public onlyOwner returns(bool success) {
135         SafeERC20.safeTransfer(tokenAddr, _to, _amount);
136         return true;
137     }
138     
139     function multiPayoutToken(Token tokenAddr, address[] addresses, uint256[] amounts) public onlyOwner returns(bool success) {
140         uint total = 0;
141 
142         for (uint8 i = 0; i < amounts.length; i++) {
143             total = total.add(amounts[i]);
144         }
145         
146         // check if user has enough balance
147         require(total <= tokenAddr.balanceOf(address(this)), "Not enough token balance");
148         
149         for (uint8 j = 0; j < addresses.length; j++) {
150             SafeERC20.safeTransfer(tokenAddr, addresses[j], amounts[j]);
151         }
152         
153         return true;
154     }
155     
156     function multiPayoutEth(address[] addresses, uint256[] amounts) public onlyOwner returns(bool success) {
157         uint total = 0;
158 
159         for (uint8 i = 0; i < amounts.length; i++){
160             total = total.add(amounts[i]);
161         }
162         
163         // ensure that there is enough to complete the transaction
164         uint requiredAmount = total.add(ethSendFee * 1 wei);
165         require(address(this).balance >= (requiredAmount * 1 wei), "Not enough balance");
166         
167         for (uint8 j = 0; j < addresses.length; j++) {
168             addresses[j].transfer(amounts[j] * 1 wei);
169         }
170 
171         return true;
172     }
173     
174     function setTokenFee(uint _tokenSendFee) public onlyOwner returns(bool success) {
175         tokenSendFee = _tokenSendFee;
176         return true;
177     }
178     
179     function setEthFee(uint _ethSendFee) public onlyOwner returns(bool success) {
180         ethSendFee = _ethSendFee;
181         return true;
182     }
183  
184     function contractAddress() public onlyOwner constant returns (address) {
185         return address(this);
186     }
187 
188     function destroy (address _to) public onlyOwner {
189         selfdestruct(_to);
190     }
191 }