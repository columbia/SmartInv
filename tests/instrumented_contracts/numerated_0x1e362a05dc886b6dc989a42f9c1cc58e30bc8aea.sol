1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, reverts on overflow.
8     */
9     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (_a == 0) {
14             return 0;
15         }
16 
17         uint256 c = _a * _b;
18         require(c / _a == _b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         require(_b > 0); // Solidity only automatically asserts when dividing by 0
28         uint256 c = _a / _b;
29         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         require(_b <= _a);
39         uint256 c = _a - _b;
40 
41         return c;
42     }
43 
44     /**
45     * @dev Adds two numbers, reverts on overflow.
46     */
47     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         uint256 c = _a + _b;
49         require(c >= _a);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56     * reverts when dividing by zero.
57     */
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0);
60         return a % b;
61     }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address public owner;
72 
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     /**
98      * @dev Allows the current owner to relinquish control of the contract.
99      * @notice Renouncing to ownership will leave the contract without an owner.
100      * It will not be possible to call the functions with the `onlyOwner`
101      * modifier anymore.
102      */
103     function renounceOwnership() public onlyOwner {
104         emit OwnershipRenounced(owner);
105         owner = address(0);
106     }
107 
108     /**
109      * @dev Allows the current owner to transfer control of the contract to a newOwner.
110      * @param _newOwner The address to transfer ownership to.
111      */
112     function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114 }
115 
116     /**
117      * @dev Transfers control of the contract to a newOwner.
118      * @param _newOwner The address to transfer ownership to.
119      */
120     function _transferOwnership(address _newOwner) internal {
121         require(_newOwner != address(0));
122         emit OwnershipTransferred(owner, _newOwner);
123         owner = _newOwner;
124     }
125 }
126 
127 /**
128  * @title ERC20 interface
129  */
130 contract ERC20 {
131     function balanceOf(address _who) public view returns (uint256);
132     function transfer(address _to, uint256 _value) public returns (bool);
133 }
134 
135 
136 contract Crowdsale is Ownable {
137     using SafeMath for uint256;
138 
139     address public multisig;
140 
141     ERC20 public token;
142 
143     uint rate;
144     uint priceETH;
145 
146     event Purchased(address _addr, uint _amount);
147 
148     function getRateCentUsd() public view returns(uint) {
149         if (block.timestamp >= 1539550800 && block.timestamp < 1541019600) {
150             return(70);
151         }
152         if (block.timestamp >= 1541019600 && block.timestamp < 1545685200) {
153             return(100);
154         }
155     }
156 
157     function setPriceETH(uint _newPriceETH) external onlyOwner {
158         setRate(_newPriceETH);
159     }
160 
161     function setRate(uint _priceETH) internal {
162         require(_priceETH != 0);
163         priceETH = _priceETH;
164         rate = getRateCentUsd().mul(1 ether).div(100).div(_priceETH);
165     }
166 
167     function getPriceETH() public view returns(uint) {
168         return priceETH;
169     }
170 
171     constructor(address _DNT, address _multisig, uint _priceETH) public {
172         require(_DNT != 0 && _priceETH != 0);
173         token = ERC20(_DNT);
174         multisig = _multisig;
175         setRate(_priceETH);
176     }
177 
178     function() external payable {
179         buyTokens();
180     }
181 
182     function buyTokens() public payable {
183         require(block.timestamp >= 1539550800 && block.timestamp < 1545685200);
184         require(msg.value >= 1 ether * 100 / priceETH);
185 
186         uint256 amount = msg.value.div(rate);
187         uint256 balance = token.balanceOf(this);
188 
189         if (amount > balance) {
190             uint256 cash = balance.mul(rate);
191             uint256 cashBack = msg.value.sub(cash);
192             multisig.transfer(cash);
193             msg.sender.transfer(cashBack);
194             token.transfer(msg.sender, balance);
195             emit Purchased(msg.sender, balance);
196             return;
197         }
198 
199         multisig.transfer(msg.value);
200         token.transfer(msg.sender, amount);
201         emit Purchased(msg.sender, amount);
202     }
203 
204     function finalizeICO(address _owner) external onlyOwner {
205         require(_owner != address(0));
206         uint balance = token.balanceOf(this);
207         token.transfer(_owner, balance);
208     }
209 
210     function getMyBalanceDNT() external view returns(uint256) {
211         return token.balanceOf(msg.sender);
212     }
213 }