1 pragma solidity ^0.5.4;
2 
3 /**
4  * ERC20 contract interface.
5  */
6 contract ERC20 {
7     function totalSupply() public view returns (uint);
8     function decimals() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 }
15 
16 contract KyberNetwork {
17 
18     function getExpectedRate(
19         ERC20 src,
20         ERC20 dest,
21         uint srcQty
22     )
23         public
24         view
25         returns (uint expectedRate, uint slippageRate);
26 
27     function trade(
28         ERC20 src,
29         uint srcAmount,
30         ERC20 dest,
31         address payable destAddress,
32         uint maxDestAmount,
33         uint minConversionRate,
34         address walletId
35     )
36         public
37         payable
38         returns(uint);
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47     /**
48     * @dev Multiplies two numbers, reverts on overflow.
49     */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52         // benefit is lost if 'b' is also tested.
53         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54         if (a == 0) {
55             return 0;
56         }
57 
58         uint256 c = a * b;
59         require(c / a == b);
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
66     */
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b > 0); // Solidity only automatically asserts when dividing by 0
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     /**
76     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77     */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b <= a);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86     * @dev Adds two numbers, reverts on overflow.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a);
91 
92         return c;
93     }
94 
95     /**
96     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97     * reverts when dividing by zero.
98     */
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0);
101         return a % b;
102     }
103 
104     /**
105     * @dev Returns ceil(a / b).
106     */
107     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a / b;
109         if(a % b == 0) {
110             return c;
111         }
112         else {
113             return c + 1;
114         }
115     }
116 }
117 
118 /**
119  * @title Owned
120  * @dev Basic contract to define an owner.
121  * @author Julien Niset - <julien@argent.im>
122  */
123 contract Owned {
124 
125     // The owner
126     address public owner;
127 
128     event OwnerChanged(address indexed _newOwner);
129 
130     /**
131      * @dev Throws if the sender is not the owner.
132      */
133     modifier onlyOwner {
134         require(msg.sender == owner, "Must be owner");
135         _;
136     }
137 
138     constructor() public {
139         owner = msg.sender;
140     }
141 
142     /**
143      * @dev Lets the owner transfer ownership of the contract to a new owner.
144      * @param _newOwner The new owner.
145      */
146     function changeOwner(address _newOwner) external onlyOwner {
147         require(_newOwner != address(0), "Address must not be null");
148         owner = _newOwner;
149         emit OwnerChanged(_newOwner);
150     }
151 }
152 
153 /**
154  * @title Managed
155  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
156  * @author Julien Niset - <julien@argent.im>
157  */
158 contract Managed is Owned {
159 
160     // The managers
161     mapping (address => bool) public managers;
162 
163     /**
164      * @dev Throws if the sender is not a manager.
165      */
166     modifier onlyManager {
167         require(managers[msg.sender] == true, "M: Must be manager");
168         _;
169     }
170 
171     event ManagerAdded(address indexed _manager);
172     event ManagerRevoked(address indexed _manager);
173 
174     /**
175     * @dev Adds a manager. 
176     * @param _manager The address of the manager.
177     */
178     function addManager(address _manager) external onlyOwner {
179         require(_manager != address(0), "M: Address must not be null");
180         if(managers[_manager] == false) {
181             managers[_manager] = true;
182             emit ManagerAdded(_manager);
183         }        
184     }
185 
186     /**
187     * @dev Revokes a manager.
188     * @param _manager The address of the manager.
189     */
190     function revokeManager(address _manager) external onlyOwner {
191         require(managers[_manager] == true, "M: Target must be an existing manager");
192         delete managers[_manager];
193         emit ManagerRevoked(_manager);
194     }
195 }
196 
197 contract TokenPriceProvider is Managed {
198 
199     // Mock token address for ETH
200     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
201 
202     using SafeMath for uint256;
203 
204     mapping(address => uint256) public cachedPrices;
205 
206     // Address of the KyberNetwork contract
207     KyberNetwork public kyberNetwork;
208 
209     constructor(KyberNetwork _kyberNetwork) public {
210         kyberNetwork = _kyberNetwork;
211     }
212 
213     function setPrice(ERC20 _token, uint256 _price) public onlyManager {
214         cachedPrices[address(_token)] = _price;
215     }
216 
217     function setPriceForTokenList(ERC20[] calldata _tokens, uint256[] calldata _prices) external onlyManager {
218         for(uint16 i = 0; i < _tokens.length; i++) {
219             setPrice(_tokens[i], _prices[i]);
220         }
221     }
222 
223     /**
224      * @dev Converts the value of _amount tokens in ether.
225      * @param _amount the amount of tokens to convert (in 'token wei' twei)
226      * @param _token the ERC20 token contract
227      * @return the ether value (in wei) of _amount tokens with contract _token
228      */
229     function getEtherValue(uint256 _amount, address _token) external view returns (uint256) {
230         uint256 decimals = ERC20(_token).decimals();
231         uint256 price = cachedPrices[_token];
232         return price.mul(_amount).div(10**decimals);
233     }
234 
235     //
236     // The following is added to be backward-compatible with Argent's old backend
237     //
238 
239     function setKyberNetwork(KyberNetwork _kyberNetwork) external onlyManager {
240         kyberNetwork = _kyberNetwork;
241     }
242 
243     function syncPrice(ERC20 _token) external {
244         require(address(kyberNetwork) != address(0), "Kyber sync is disabled");
245         (uint256 expectedRate,) = kyberNetwork.getExpectedRate(_token, ERC20(ETH_TOKEN_ADDRESS), 10000);
246         cachedPrices[address(_token)] = expectedRate;
247     }
248 
249     function syncPriceForTokenList(ERC20[] calldata _tokens) external {
250         require(address(kyberNetwork) != address(0), "Kyber sync is disabled");
251         for(uint16 i = 0; i < _tokens.length; i++) {
252             (uint256 expectedRate,) = kyberNetwork.getExpectedRate(_tokens[i], ERC20(ETH_TOKEN_ADDRESS), 10000);
253             cachedPrices[address(_tokens[i])] = expectedRate;
254         }
255     }
256 }