1 pragma solidity ^0.4.24;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * See https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13  /**
14  * @title Contract that will work with ERC223 tokens.
15  */
16 contract ERC223ReceivingContract {
17 /**
18  * @dev Standard ERC223 function that will handle incoming token transfers.
19  *
20  * @param _from  Token sender address.
21  * @param _value Amount of tokens.
22  * @param _data  Transaction metadata.
23  */
24     function tokenFallback(address _from, uint _value, bytes _data);
25 }
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33   event OwnershipRenounced(address indexed previousOwner);
34   event OwnershipTransferred(
35     address indexed previousOwner,
36     address indexed newOwner
37   );
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public {
43     owner = msg.sender;
44   }
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(owner);
60     owner = address(0);
61   }
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address _newOwner) public onlyOwner {
67     _transferOwnership(_newOwner);
68   }
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 /**
80  * @title SafeMath
81  * @dev Math operations with safety checks that throw on error
82  */
83 library SafeMath {
84   /**
85   * @dev Multiplies two numbers, throws on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94     c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98   /**
99   * @dev Integer division of two numbers, truncating the quotient.
100   */
101   function div(uint256 a, uint256 b) internal pure returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     // uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return a / b;
106   }
107   /**
108   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109   */
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 /**
124  * @title Pausable
125  * @dev Base contract which allows children to implement an emergency stop mechanism.
126  */
127 contract Pausable is Ownable {
128   event Pause();
129   event Unpause();
130   bool public paused = false;
131   /**
132    * @dev Modifier to make a function callable only when the contract is not paused.
133    */
134   modifier whenNotPaused() {
135     require(!paused);
136     _;
137   }
138   /**
139    * @dev Modifier to make a function callable only when the contract is paused.
140    */
141   modifier whenPaused() {
142     require(paused);
143     _;
144   }
145   /**
146    * @dev called by the owner to pause, triggers stopped state
147    */
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     emit Pause();
151   }
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() onlyOwner whenPaused public {
156     paused = false;
157     emit Unpause();
158   }
159 }
160 /**
161  * @title ERC20 interface
162  * @dev see https://github.com/ethereum/EIPs/issues/20
163  */
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender)
166     public view returns (uint256);
167   function transferFrom(address from, address to, uint256 value)
168     public returns (bool);
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(
171     address indexed owner,
172     address indexed spender,
173     uint256 value
174   );
175 }
176 contract Bounty0xEscrow is Ownable, ERC223ReceivingContract, Pausable {
177     using SafeMath for uint256;
178     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
179     event Deposit(address indexed token, address indexed user, uint amount, uint balance);
180     event Distribution(address indexed token, address indexed host, address indexed hunter, uint256 amount);
181     constructor() public {
182     }
183     // for erc223 tokens
184     function tokenFallback(address _from, uint _value, bytes _data) public whenNotPaused {
185         address _token = msg.sender;
186         tokens[_token][_from] = SafeMath.add(tokens[_token][_from], _value);
187         emit Deposit(_token, _from, _value, tokens[_token][_from]);
188     }
189     // for erc20 tokens
190     function depositToken(address _token, uint _amount) public whenNotPaused {
191         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
192         require(_token != address(0));
193         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
194         tokens[_token][msg.sender] = SafeMath.add(tokens[_token][msg.sender], _amount);
195         emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
196     }
197     // for ether
198     function depositEther() public payable whenNotPaused {
199         tokens[address(0)][msg.sender] = SafeMath.add(tokens[address(0)][msg.sender], msg.value);
200         emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
201     }
202     function distributeTokenToAddress(address _token, address _host, address _hunter, uint256 _amount) external onlyOwner {
203         require(_hunter != address(0));
204         require(tokens[_token][_host] >= _amount);
205         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], _amount);
206         if (_token == address(0)) {
207             require(_hunter.send(_amount));
208         } else {
209             ERC20(_token).transfer(_hunter, _amount);
210         }
211         emit Distribution(_token, _host, _hunter, _amount);
212     }
213     function distributeTokenToAddressesAndAmounts(address _token, address _host, address[] _hunters, uint256[] _amounts) external onlyOwner {
214         require(_host != address(0));
215         require(_hunters.length == _amounts.length);
216         uint256 totalAmount = 0;
217         for (uint j = 0; j < _amounts.length; j++) {
218             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
219         }
220         require(tokens[_token][_host] >= totalAmount);
221         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], totalAmount);
222         if (_token == address(0)) {
223             for (uint i = 0; i < _hunters.length; i++) {
224                 require(_hunters[i].send(_amounts[i]));
225                 emit Distribution(_token, _host, _hunters[i], _amounts[i]);
226             }
227         } else {
228             for (uint k = 0; k < _hunters.length; k++) {
229                 ERC20(_token).transfer(_hunters[k], _amounts[k]);
230                 emit Distribution(_token, _host, _hunters[k], _amounts[k]);
231             }
232         }
233     }
234     function distributeTokenToAddressesAndAmountsWithoutHost(address _token, address[] _hunters, uint256[] _amounts) external onlyOwner {
235         require(_hunters.length == _amounts.length);
236         uint256 totalAmount = 0;
237         for (uint j = 0; j < _amounts.length; j++) {
238             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
239         }
240         if (_token == address(0)) {
241             require(address(this).balance >= totalAmount);
242             for (uint i = 0; i < _hunters.length; i++) {
243                 require(_hunters[i].send(_amounts[i]));
244                 emit Distribution(_token, this, _hunters[i], _amounts[i]);
245             }
246         } else {
247             require(ERC20(_token).balanceOf(this) >= totalAmount);
248             for (uint k = 0; k < _hunters.length; k++) {
249                 ERC20(_token).transfer(_hunters[k], _amounts[k]);
250                 emit Distribution(_token, this, _hunters[k], _amounts[k]);
251             }
252         }
253     }
254     function distributeWithTransferFrom(address _token, address _ownerOfTokens, address[] _hunters, uint256[] _amounts) external onlyOwner {
255         require(_token != address(0));
256         require(_hunters.length == _amounts.length);
257         uint256 totalAmount = 0;
258         for (uint j = 0; j < _amounts.length; j++) {
259             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
260         }
261         require(ERC20(_token).allowance(_ownerOfTokens, this) >= totalAmount);
262         for (uint i = 0; i < _hunters.length; i++) {
263             ERC20(_token).transferFrom(_ownerOfTokens, _hunters[i], _amounts[i]);
264             emit Distribution(_token, this, _hunters[i], _amounts[i]);
265         }
266     }
267     // in case of emergency
268     function approveToPullOutTokens(address _token, address _receiver, uint256 _amount) external onlyOwner {
269         ERC20(_token).approve(_receiver, _amount);
270     }
271 }