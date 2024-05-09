1 pragma solidity 0.4.25;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address who) external view returns (uint256);
7 
8     function allowance(address owner, address spender) external view returns (uint256);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function transferTrade(address from, address to, uint256 value) external returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     /**
25     * @dev Multiplies two unsigned integers, reverts on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     /**
42     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
43     */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Solidity only automatically asserts when dividing by 0
46         require(b > 0);
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50         return c;
51     }
52 
53     /**
54     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55     */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64     * @dev Adds two unsigned integers, reverts on overflow.
65     */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a);
69 
70         return c;
71     }
72 }
73 
74 contract Ownable {
75     uint public ownersCount = 1;
76     mapping(address => bool) public owner;
77     mapping(uint => address) public ownerList;
78 
79     constructor () internal {
80         owner[msg.sender] = true;
81         ownerList[ownersCount] = msg.sender;
82     }
83 
84     modifier onlyOwner() {
85         require(isOwner(msg.sender));
86         _;
87     }
88 
89     function isOwner(address user) public view returns (bool) {
90         return owner[user];
91     }
92 
93     function addOwner(address _owner) public onlyOwner {
94         require(!owner[_owner], "It's owner now");
95         owner[_owner] = true;
96         ownersCount++;
97         ownerList[ownersCount] = _owner;
98     }
99 
100     function removeOwner(address _owner) public onlyOwner {
101         require(owner[_owner], "It's not owner now");
102         require(ownersCount > 1);
103         owner[_owner] = false;
104 
105         for (uint i = 1; i < ownersCount + 1; i++) {
106             if (ownerList[i] == _owner) {
107                 delete ownerList[i];
108                 break;
109             }
110         }
111 
112         ownersCount--;
113     }
114 }
115 
116 contract Trade is Ownable {
117     using SafeMath for uint;
118     uint public cursETHtoUSD = 15000;
119     uint public costClientBuyETH = 1 ether / 10000;
120     uint public costClientSellETH = 1 ether / 100000;
121     uint public costClientBuyUSD = costClientBuyETH * cursETHtoUSD / 100;
122     uint public costClientSellUSD = costClientSellETH * cursETHtoUSD / 100;
123     uint private DEC = 10 ** 18;
124     bool public clientBuyOpen = true;
125     bool public clientSellOpen = true;
126     uint public clientBuyTimeWorkFrom = 1545264000;
127     uint public clientBuyTimeWork = 24 hours;
128     uint public clientSellTimeWorkFrom = 1545264000;
129     uint public clientSellTimeWork = 24 hours;
130     address public tokenAddress;
131 
132     event clientBuy(address user, uint valueETH, uint amount);
133     event clientSell(address user, uint valueETH, uint amount);
134     event Deposit(address user, uint value);
135     event DepositToken(address user, uint value);
136     event WithdrawEth(address user, uint value);
137     event WithdrawTokens(address user, uint value);
138 
139     modifier buyIsOpen() {
140         require(clientBuyOpen == true, "Buying are closed");
141         require((now - clientBuyTimeWorkFrom) % 24 hours <= clientBuyTimeWork, "Now buying are closed");
142         _;
143     }
144 
145     modifier sellIsOpen() {
146         require(clientSellOpen == true, "Selling are closed");
147         require((now - clientSellTimeWorkFrom) % 24 hours <= clientSellTimeWork, "Now selling are closed");
148         _;
149     }
150 
151     function updateCursETHtoUSD(uint _value) onlyOwner public {
152         cursETHtoUSD = _value;
153         costClientBuyUSD = costClientBuyETH.mul(cursETHtoUSD).div(100);
154         costClientSellUSD = costClientSellETH.mul(cursETHtoUSD).div(100);
155     }
156 
157     function contractSalesAtUsd(uint _value) onlyOwner public {
158         costClientBuyUSD = _value;
159         costClientBuyETH = costClientBuyUSD.div(cursETHtoUSD).mul(100);
160     }
161 
162     function contractBuysAtUsd(uint _value) onlyOwner public {
163         costClientSellUSD = _value;
164         costClientSellETH = costClientSellUSD.div(cursETHtoUSD).mul(100);
165     }
166 
167     function contractSalesAtEth(uint _value) onlyOwner public {
168         costClientBuyETH = _value;
169         costClientBuyUSD = costClientBuyETH.mul(cursETHtoUSD).div(100);
170     }
171 
172     function contractBuysAtEth(uint _value) onlyOwner public {
173         costClientSellETH = _value;
174         costClientSellUSD = costClientSellETH.mul(cursETHtoUSD).div(100);
175     }
176 
177     function closeClientBuy() onlyOwner public {
178         clientBuyOpen = false;
179     }
180 
181     function openClientBuy() onlyOwner public {
182         clientBuyOpen = true;
183     }
184 
185     function closeClientSell() onlyOwner public {
186         clientSellOpen = false;
187     }
188 
189     function openClientSell() onlyOwner public {
190         clientSellOpen = true;
191     }
192 
193     function setClientBuyingTime(uint _from, uint _time) onlyOwner public {
194         clientBuyTimeWorkFrom = _from;
195         clientBuyTimeWork = _time;
196     }
197 
198     function setClientSellingTime(uint _from, uint _time) onlyOwner public {
199         clientSellTimeWorkFrom = _from;
200         clientSellTimeWork = _time;
201     }
202 
203     function contractSellTokens() buyIsOpen payable public {
204         require(msg.value > 0, "ETH amount must be greater than 0");
205 
206         uint amount = msg.value.mul(DEC).div(costClientBuyETH);
207 
208         require(IERC20(tokenAddress).balanceOf(this) >= amount, "Not enough tokens");
209 
210         IERC20(tokenAddress).transfer(msg.sender, amount);
211 
212         emit clientBuy(msg.sender, msg.value, amount);
213     }
214 
215     function() external payable {
216         contractSellTokens();
217     }
218 
219     function contractBuyTokens(uint amount) sellIsOpen public {
220         require(amount > 0, "Tokens amount must be greater than 0");
221         require(IERC20(tokenAddress).balanceOf(msg.sender) >= amount, "Not enough tokens on balance");
222 
223         uint valueETH = amount.mul(costClientSellETH).div(DEC);
224         require(valueETH <= address(this).balance, "Not enough balance on the contract");
225 
226         IERC20(tokenAddress).transferTrade(msg.sender, this, amount);
227         msg.sender.transfer(valueETH);
228 
229         emit clientSell(msg.sender, valueETH, amount);
230     }
231 
232     function contractBuyTokensFrom(address from, uint amount) sellIsOpen public {
233         require(keccak256(msg.sender) == keccak256(tokenAddress), "Only for token");
234         require(amount > 0, "Tokens amount must be greater than 0");
235         require(IERC20(tokenAddress).balanceOf(from) >= amount, "Not enough tokens on balance");
236 
237         uint valueETH = amount.mul(costClientSellETH).div(DEC);
238         require(valueETH <= address(this).balance, "Not enough balance on the contract");
239 
240         IERC20(tokenAddress).transferTrade(from, this, amount);
241         from.transfer(valueETH);
242 
243         emit clientSell(from, valueETH, amount);
244     }
245 
246     function withdrawEth(address to, uint256 value) onlyOwner public {
247         require(address(this).balance >= value, "Not enough balance on the contract");
248         to.transfer(value);
249 
250         emit WithdrawEth(to, value);
251     }
252 
253     function withdrawTokens(address to, uint256 value) onlyOwner public {
254         require(IERC20(tokenAddress).balanceOf(this) >= value, "Not enough token balance on the contract");
255 
256         IERC20(tokenAddress).transferTrade(this, to, value);
257 
258         emit WithdrawTokens(to, value);
259     }
260 
261     function depositEther() onlyOwner payable public {
262         emit Deposit(msg.sender, msg.value);
263     }
264 
265     function depositToken(uint _value) onlyOwner public {
266         IERC20(tokenAddress).transferTrade(msg.sender, this, _value);
267     }
268 
269     function changeTokenAddress(address newTokenAddress) onlyOwner public {
270         tokenAddress = newTokenAddress;
271     }
272 }