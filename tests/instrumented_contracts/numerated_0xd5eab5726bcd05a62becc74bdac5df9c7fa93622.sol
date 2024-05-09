1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 library SafeERC20 {
68     /**
69     * @dev Transfer token for a specified address
70     * @param _token erc20 The address of the ERC20 contract
71     * @param _to address The address which you want to transfer to
72     * @param _value uint256 the _value of tokens to be transferred
73     * @return bool whether the transfer was successful or not
74     */
75     function safeTransfer(Token _token, address _to, uint256 _value) internal returns (bool) {
76         uint256 prevBalance = _token.balanceOf(address(this));
77 
78         if (prevBalance < _value) {
79             // Insufficient funds
80             return false;
81         }
82 
83         address(_token).call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
84 
85         // Fail if the new balance its not equal than previous balance sub _value
86         return prevBalance - _value == _token.balanceOf(address(this));
87     }
88 }
89 
90 interface Token {
91     function transfer(address _to, uint256 _value) external returns (bool success);
92     function balanceOf(address who) external view returns (uint256 balance);
93     function transferFrom(address from, address to, uint value) external returns (bool);
94     function allowance(address owner, address spender) external view returns (uint256);
95 }
96 
97 contract Sellix {
98     using SafeMath for uint256;
99     
100     address public owner;
101     uint public tokenSendFee; // in wei
102     uint public ethSendFee; // in wei
103     
104     constructor() public payable {
105         owner = msg.sender;
106     }
107     
108     modifier onlyOwner() {
109       require(msg.sender == owner);
110       _;
111     }
112     
113     function balance() public constant returns (uint value) {
114         return address(this).balance;
115     }
116     
117     function balanceToken(Token tokenAddr) public constant returns (uint value) {
118         return tokenAddr.balanceOf(address(this));
119     }
120     
121     function deposit() payable public returns (bool) {
122         return true;
123     }
124     
125     function withdrawEth(address addr, uint amount) public onlyOwner returns(bool success) {
126         addr.transfer(amount * 1 wei);
127         return true;
128     }
129     
130     function withdrawToken(Token tokenAddr, address _to, uint _amount) public onlyOwner returns(bool success) {
131         SafeERC20.safeTransfer(tokenAddr, _to, _amount);
132         return true;
133     }
134     
135     function multiPayoutToken(Token tokenAddr, address[] addresses, uint256[] amounts) public onlyOwner returns(bool success) {
136         uint total = 0;
137 
138         for (uint8 i = 0; i < amounts.length; i++) {
139             total = total.add(amounts[i]);
140         }
141         
142         // check if user has enough balance
143         require(total <= tokenAddr.balanceOf(address(this)), "Not enough token balance");
144         
145         for (uint8 j = 0; j < addresses.length; j++) {
146             SafeERC20.safeTransfer(tokenAddr, addresses[j], amounts[j]);
147         }
148         
149         return true;
150     }
151     
152     function multiPayoutEth(address[] addresses, uint256[] amounts) public onlyOwner returns(bool success) {
153         uint total = 0;
154 
155         for (uint8 i = 0; i < amounts.length; i++){
156             total = total.add(amounts[i]);
157         }
158         
159         // ensure that there is enough to complete the transaction
160         uint requiredAmount = total.add(ethSendFee * 1 wei);
161         require(address(this).balance >= (requiredAmount * 1 wei), "Not enough balance");
162         
163         for (uint8 j = 0; j < addresses.length; j++) {
164             addresses[j].transfer(amounts[j] * 1 wei);
165         }
166 
167         return true;
168     }
169     
170     function setTokenFee(uint _tokenSendFee) public onlyOwner returns(bool success) {
171         tokenSendFee = _tokenSendFee;
172         return true;
173     }
174     
175     function setEthFee(uint _ethSendFee) public onlyOwner returns(bool success) {
176         ethSendFee = _ethSendFee;
177         return true;
178     }
179  
180     function contractAddress() public onlyOwner constant returns (address) {
181         return address(this);
182     }
183 
184     function destroy (address _to) public onlyOwner {
185         selfdestruct(_to);
186     }
187 }