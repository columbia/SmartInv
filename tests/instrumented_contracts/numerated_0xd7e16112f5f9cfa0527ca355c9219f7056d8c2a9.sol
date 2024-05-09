1 pragma solidity ^0.4.24;
2 library SafeMath {
3     /**
4     * @dev Multiplies two numbers, reverts on overflow.
5     */
6     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
7         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
8         // benefit is lost if 'b' is also tested.
9         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10         if (_a == 0) {
11             return 0;
12         }
13         uint256 c = _a * _b;
14         require(c / _a == _b);
15         return c;
16     }
17     /**
18     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
19     */
20     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
21         require(_b > 0); // Solidity only automatically asserts when dividing by 0
22         uint256 c = _a / _b;
23         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
24         return c;
25     }
26     /**
27     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         require(_b <= _a);
31         uint256 c = _a - _b;
32         return c;
33     }
34     /**
35     * @dev Adds two numbers, reverts on overflow.
36     */
37     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         uint256 c = _a + _b;
39         require(c >= _a);
40         return c;
41     }
42     /**
43     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
44     * reverts when dividing by zero.
45     */
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58     event OwnershipRenounced(address indexed previousOwner);
59     event OwnershipTransferred(
60         address indexed previousOwner,
61         address indexed newOwner
62     );
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     constructor() public {
68         owner = msg.sender;
69     }
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77     /**
78      * @dev Allows the current owner to relinquish control of the contract.
79      * @notice Renouncing to ownership will leave the contract without an owner.
80      * It will not be possible to call the functions with the `onlyOwner`
81      * modifier anymore.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipRenounced(owner);
85         owner = address(0);
86     }
87     /**
88      * @dev Allows the current owner to transfer control of the contract to a newOwner.
89      * @param _newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93 }
94     /**
95      * @dev Transfers control of the contract to a newOwner.
96      * @param _newOwner The address to transfer ownership to.
97      */
98     function _transferOwnership(address _newOwner) internal {
99         require(_newOwner != address(0));
100         emit OwnershipTransferred(owner, _newOwner);
101         owner = _newOwner;
102     }
103 }
104 contract ERC20 {
105     function totalSupply() public view returns (uint256);
106     function balanceOf(address _who) public view returns (uint256);
107     function allowance(address _owner, address _spender)
108     public view returns (uint256);
109     function transfer(address _to, uint256 _value) public returns (bool);
110     function approve(address _spender, uint256 _value)
111     public returns (bool);
112     function transferFrom(address _from, address _to, uint256 _value)
113     public returns (bool);
114     function lock(address _victim, uint256 _value, uint256 _periodSec) public;
115     function unlock(address _luckier) external;
116     function transferOwnership(address _newOwner) public;
117 }
118 contract Crowdsale is Ownable {
119     using SafeMath for uint256;
120     address public multisig;
121     address public tokenHolder;
122     ERC20 public token;
123     uint256 rate;
124     uint256 rateInUsd;
125     uint256 priceETH;
126     uint256 startIco;
127     uint256 periodIco;
128     uint256 periodPreIco;
129     uint256 indCap;
130     mapping (address => uint256) tokens;
131     address[] addresses;
132     uint256 index;
133     event Purchased(address _buyer, uint256 _amount);
134     constructor(address _AS, address _multisig, address _tokenHolder, uint256 _priceETH, uint256 _startIcoUNIX, uint256 _periodPreIcoSEC, uint256 _periodIcoSEC) public {
135         require(_AS != 0 && _priceETH != 0);
136         token = ERC20(_AS);
137         multisig = _multisig;
138         tokenHolder = _tokenHolder;
139         startIco = _startIcoUNIX;
140         periodPreIco = _periodPreIcoSEC;
141         periodIco = _periodIcoSEC;
142         rateInUsd = 10;
143         setRate(_priceETH);
144     }
145     function setIndCap(uint256 _indCapETH) public onlyOwner {
146         indCap = _indCapETH;
147     }
148     function setPriceETH(uint256 _newPriceETH) external onlyOwner {
149         setRate(_newPriceETH);
150     }
151     function setRate(uint256 _priceETH) internal {
152         require(_priceETH != 0);
153         priceETH = _priceETH;
154         rate = rateInUsd.mul(1 ether).div(100).div(_priceETH);
155     }
156     function transferTokenOwnership(address _newOwner) external onlyOwner {
157         require(_newOwner != address(0));
158         token.transferOwnership(_newOwner);
159     }
160     function _lock(address _address, uint256 _value, uint256 _period) internal {
161         token.lock(_address, _value, _period);
162     }
163     function lock(address _address, uint256 _value, uint256 _period) external onlyOwner {
164         _lock(_address, _value, _period);
165     }
166     function unlock(address _address) external onlyOwner {
167         token.unlock(_address);
168     }
169     function unlockList() external onlyOwner {
170         for (uint256 i = index; i < addresses.length; i++) {
171             token.unlock(addresses[i]);
172             if (gasleft() < 70000) {
173                 index = i + 1;
174                 return;
175             }
176         }
177         index = 0;
178     }
179     function extendPeriodPreICO(uint256 _days) external onlyOwner {
180         periodIco = periodPreIco.add(_days.mul(1 days));
181     }
182     function extendPeriodICO(uint256 _days) external onlyOwner {
183         periodIco = periodIco.add(_days.mul(1 days));
184     }
185     function() external payable {
186         buyTokens();
187     }
188     function buyTokens() public payable {
189         require(block.timestamp > startIco && block.timestamp < startIco.add(periodIco));
190         if (indCap > 0) {
191             require(msg.value <= indCap.mul(1 ether));
192         }
193         uint256 totalAmount = msg.value.mul(10**8).div(rate).add(msg.value.mul(10**8).mul(getBonuses()).div(100).div(rate));
194         uint256 balance = token.allowance(tokenHolder, address(this));
195         require(balance > 0);
196         if (totalAmount > balance) {
197             uint256 cash = balance.mul(rate).mul(100).div(100 + getBonuses()).div(10**8);
198             uint256 cashBack = msg.value.sub(cash);
199             totalAmount = balance;
200             msg.sender.transfer(cashBack);
201         }
202         multisig.transfer(msg.value + cash);
203         token.transferFrom(tokenHolder, msg.sender, totalAmount);
204         if (tokens[msg.sender] == 0) {
205             addresses.push(msg.sender);
206         }
207         tokens[msg.sender] = tokens[msg.sender].add(totalAmount);
208         _lock(msg.sender, tokens[msg.sender], startIco.add(periodIco).sub(block.timestamp));
209         emit Purchased(msg.sender, totalAmount);
210     }
211     function getBonuses() internal view returns(uint256) {
212         if (block.timestamp < startIco.add(periodPreIco)) {
213             return 20;
214         } else {
215             return 0;
216         }
217     }
218     function getIndCapInETH() public view returns(uint) {
219         return indCap;
220     }
221     function getPriceETH() public view returns(uint) {
222         return priceETH;
223     }
224     function tokenBalanceOf(address _address) external view returns(uint256) {
225         return token.balanceOf(_address);
226     }
227 }