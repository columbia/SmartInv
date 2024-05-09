1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Unsigned math operations with safety checks that revert on error.
24  */
25 library SafeMath {
26     /**
27      * @dev Multiplies two unsigned integers, reverts on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0, "SafeMath: division by zero");
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a, "SafeMath: subtraction overflow");
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Adds two unsigned integers, reverts on overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0, "SafeMath: modulo by zero");
81         return a % b;
82     }
83 }
84 
85 /**
86 * @title Multisend contract
87 * @dev Provides ability to send multiple ERC20 tokens and ether within one transaction
88 **/
89 contract Multisend {
90   using SafeMath for uint256;
91 
92   address payable private _owner; // owner of the contract
93   mapping(address => bool) public whitelist; //whitelisted contract address to transfer to
94   uint private _fee; // amount in basis points to take from each deposit
95   mapping(address => mapping(address => uint256)) public balances; // deposited token/ether balances
96 
97 
98   /**
99   * @param initialFee amount of fees taken per transaction in basis points
100   **/
101   constructor(uint256 initialFee) public {
102     _owner = msg.sender;
103     _fee = initialFee;
104   }
105 
106   /**
107   * @dev Deposit token into this contract to use for sending
108   * @param tokenDepositAddress token contract addresses to deposit tokens from
109   * @param tokenDepositAmount amount of tokens to deposit
110   * @dev for ether transactions use address(0) as token contract address
111   **/
112   function deposit(address[] memory tokenDepositAddress, uint256[] memory tokenDepositAmount) public payable {
113     require(tokenDepositAddress.length == tokenDepositAmount.length);
114     // if any ether was sent
115     if(msg.value != 0) {
116       uint256 etherFee = msg.value.div(10000).mul(_fee); //calculate fee
117       balances[msg.sender][address(0)] = balances[msg.sender][address(0)].add(msg.value.sub(etherFee));
118       balances[address(this)][address(0)] = balances[address(this)][address(0)].add(etherFee);
119     }
120     for (uint i=0;i<tokenDepositAddress.length;i++) {
121       require(whitelist[tokenDepositAddress[i]] == true, "token not whitelisted");
122       uint256 tokenFee = tokenDepositAmount[i].div(10000).mul(_fee);
123       IERC20(tokenDepositAddress[i]).transferFrom(msg.sender, address(this), tokenDepositAmount[i]);
124       balances[msg.sender][tokenDepositAddress[i]] = balances[msg.sender][tokenDepositAddress[i]].add(tokenDepositAmount[i].sub(tokenFee));
125       balances[address(this)][tokenDepositAddress[i]] = balances[address(this)][tokenDepositAddress[i]].add(tokenFee);
126     }
127   }
128 
129   /**
130   * Send payment from the funds initially depositted
131   * @param tokens token contract address to send payment
132   * @param recipients addresses to send tokens to
133   * @param amounts token amount being sent
134   * @dev for ether payments use address(0)
135   **/
136   function sendPayment(address[] memory tokens, address payable[] memory recipients, uint256[] memory amounts) public payable returns (bool) {
137     require(tokens.length == recipients.length);
138     require(tokens.length == amounts.length);
139     uint256 total_ether_amount = 0;
140     for (uint i=0; i < recipients.length; i++) {
141       if(tokens[i] != address(0)) {
142         balances[msg.sender][tokens[i]] = balances[msg.sender][tokens[i]].sub(amounts[i]);
143         IERC20(tokens[i]).transfer(recipients[i], amounts[i]);
144       }
145       else {
146         total_ether_amount = total_ether_amount.add(amounts[i]);
147         balances[msg.sender][address(0)] = balances[msg.sender][address(0)].sub(amounts[i]);
148         recipients[i].transfer(amounts[i]);
149       }
150     }
151   }
152 
153   /**
154   * @dev calls deposit and send methods in one transaction
155   **/
156   function depositAndSendPayment(address[] calldata tokenDepositAddress, uint256[] calldata tokenDepositAmount, address[] calldata tokens, address payable[] calldata recipients, uint256[] calldata amounts) external payable returns (bool) {
157       deposit(tokenDepositAddress, tokenDepositAmount);
158       sendPayment(tokens, recipients, amounts);
159   }
160 
161   /**
162   * @dev Withdraw method to return tokens to original owner
163   * @param tokenAddresses token contract address to withdraw from
164   **/
165   function withdrawTokens(address payable[] calldata tokenAddresses) external {
166     for(uint i=0; i<tokenAddresses.length;i++) {
167       uint balance = balances[msg.sender][tokenAddresses[i]];
168       balances[msg.sender][tokenAddresses[i]] = 0;
169       IERC20 ERC20 = IERC20(tokenAddresses[i]);
170       ERC20.transfer(msg.sender, balance);
171     }
172   }
173 
174   // @dev Withdraw method to return ether to original owner
175   function withdrawEther() external {
176     uint balance = balances[msg.sender][address(0)];
177     balances[msg.sender][address(0)] = 0;
178     msg.sender.transfer(balance);
179   }
180 
181   /*** CONSTANT METHODS **/
182 
183   /**
184   * @param owner address to query balance of
185   * @param token contract address to query
186   * @return a uint256 balance of the given users token amount
187   **/
188   function getBalance(address owner, address token) external view returns (uint256) {
189     return balances[owner][token];
190   }
191 
192   /**
193   * @dev returns the owner of the contract
194   * @return address of this contracts owner
195   **/
196   function owner() external view returns (address) {
197     return _owner;
198   }
199 
200   /*** OWNER METHODS **/
201 
202   /**
203   * @dev function that returns the token fees collected by the contract to the owner
204   * @param tokenAddresses token contract addresses to withdraw from
205   **/
206   function ownerWithdrawTokens(address payable[] calldata tokenAddresses) external onlyOwner {
207     for(uint i=0; i<tokenAddresses.length;i++) {
208       uint balance = balances[address(this)][tokenAddresses[i]];
209       balances[address(this)][tokenAddresses[i]] = 0;
210       IERC20 ERC20 = IERC20(tokenAddresses[i]);
211       ERC20.transfer(_owner, balance);
212     }
213   }
214 
215   // @dev function that returns the ether fees collected by the contract to the owner
216   function ownerWithdrawEther() external onlyOwner {
217     uint balance = balances[address(this)][address(0)];
218     balances[address(this)][address(0)] = 0;
219     _owner.transfer(balance);
220   }
221 
222   /**
223   * @dev whitelist a token address
224   * @param contractAddress the address to be whitelisted
225   */
226   function whitelistAddress(address contractAddress) external onlyOwner {
227     whitelist[contractAddress] = true;
228   }
229 
230   /**
231   * @dev method to transfer ownership to a new address
232   * @param newOwner address of the new owner
233   **/
234   function transferOwnership(address payable newOwner) external onlyOwner {
235     require(newOwner != address(0), "Owner address may not be set to zero address");
236     _owner = newOwner;
237   }
238 
239   modifier onlyOwner {
240     require(msg.sender == _owner, "Sender is not owner of the contract");
241     _;
242   }
243 }
