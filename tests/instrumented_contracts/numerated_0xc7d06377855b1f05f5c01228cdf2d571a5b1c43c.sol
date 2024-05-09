1 /*
2 Capital Technologies & Research - Bounty Distribution Smart Contract
3 https://www.mycapitalco.in
4 */
5 
6 pragma solidity 0.4.24;
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (a == 0) {
52       return 0;
53     }
54 
55     c = a * b;
56     assert(c / a == b);
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers, truncating the quotient.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     // uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return a / b;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   /**
79   * @dev Adds two numbers, throws on overflow.
80   */
81   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94   address public owner;
95 
96 
97   event OwnershipRenounced(address indexed previousOwner);
98   event OwnershipTransferred(
99     address indexed previousOwner,
100     address indexed newOwner
101   );
102 
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   constructor() public {
109     owner = msg.sender;
110   }
111 
112   /**
113    * @dev Throws if called by any account other than the owner.
114    */
115   modifier onlyOwner() {
116     require(msg.sender == owner);
117     _;
118   }
119 
120   /**
121    * @dev Allows the current owner to relinquish control of the contract.
122    */
123   function renounceOwnership() public onlyOwner {
124     emit OwnershipRenounced(owner);
125     owner = address(0);
126   }
127 
128   /**
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130    * @param _newOwner The address to transfer ownership to.
131    */
132   function transferOwnership(address _newOwner) public onlyOwner {
133     _transferOwnership(_newOwner);
134   }
135 
136   /**
137    * @dev Transfers control of the contract to a newOwner.
138    * @param _newOwner The address to transfer ownership to.
139    */
140   function _transferOwnership(address _newOwner) internal {
141     require(_newOwner != address(0));
142     emit OwnershipTransferred(owner, _newOwner);
143     owner = _newOwner;
144   }
145 }
146 
147 contract CapitalBountyDelivery is Ownable {
148 using SafeMath for uint256;
149     ERC20 public token_call;
150     ERC20 public token_callg;
151 	mapping (address => bool) public distributedFirst;
152 	mapping (address => bool) public distributedSecond;
153 	uint public sentFirst;
154 	uint public sentSecond;
155     event DistributeFirst(address indexed userWallet, uint token_call, uint token_callg);
156 	event DistributeSecond(address indexed userWallet, uint token_call, uint token_callg);
157 	event AdminWithdrawn(address indexed adminWallet, uint token_call, uint token_callg);
158     constructor (ERC20 _token_call, ERC20 _token_callg) public {
159         require(_token_call != address(0));
160         require(_token_callg != address(0));
161         token_call = _token_call;
162         token_callg = _token_callg;
163     }
164     function () public payable {
165     }
166     function sendFirst(address userWallet, uint call) public onlyOwner {
167 		require(now >= 1531958400);
168 		require(userWallet != address(0));
169 		require(!distributedFirst[userWallet]);
170         uint _call = call * 10 ** 18;
171 		uint _callg = _call.mul(200);
172 		distributedFirst[userWallet] = true;
173         require(token_call.transfer(userWallet, _call));
174         require(token_callg.transfer(userWallet, _callg));
175 		sentFirst = sentFirst.add(_call);
176         emit DistributeFirst(userWallet, _call, _callg);
177     }
178 	function sendSecond(address userWallet, uint call) public onlyOwner {
179 		require(now >= 1538179200);
180 		require(userWallet != address(0));
181 		require(!distributedSecond[userWallet]);
182         uint _call = call * 10 ** 18;
183 		uint _callg = _call.mul(200);
184 		distributedSecond[userWallet] = true;
185         require(token_call.transfer(userWallet, _call));
186         require(token_callg.transfer(userWallet, _callg));
187 		sentSecond = sentSecond.add(_call);
188         emit DistributeSecond(userWallet, _call, _callg);
189     }
190 	function sendFirstBatch(address[] _userWallet, uint[] call) public onlyOwner {
191 		require(now >= 1531958400);
192 		for(uint256 i = 0; i < _userWallet.length; i++) {
193 			if (!distributedFirst[_userWallet[i]]) {
194 				uint _call = call[i] * 10 ** 18;
195 				uint _callg = _call.mul(200);
196 				distributedFirst[_userWallet[i]] = true;
197 				require(token_call.transfer(_userWallet[i], _call));
198 				require(token_callg.transfer(_userWallet[i], _callg));
199 				sentFirst = sentFirst.add(_call);
200 				emit DistributeFirst(_userWallet[i], _call, _callg);
201 			}
202 		}
203     }
204 	function sendSecondBatch(address[] _userWallet, uint[] call) public onlyOwner {
205 		require(now >= 1538179200); 
206 		for(uint256 i = 0; i < _userWallet.length; i++) {
207 			if (!distributedSecond[_userWallet[i]]) {
208 				uint _call = call[i] * 10 ** 18;
209 				uint _callg = _call.mul(200);
210 				distributedSecond[_userWallet[i]] = true;
211 				require(token_call.transfer(_userWallet[i], _call));
212 				require(token_callg.transfer(_userWallet[i], _callg));
213 				sentSecond = sentSecond.add(_call);
214 				emit DistributeSecond(_userWallet[i], _call, _callg);
215 			}
216 		}
217     }
218 	function withdrawTokens(address adminWallet) public onlyOwner {
219         require(adminWallet != address(0));
220         uint call_balance = token_call.balanceOf(this);
221         uint callg_balance = token_callg.balanceOf(this);
222         token_call.transfer(adminWallet, call_balance);
223         token_callg.transfer(adminWallet, callg_balance);
224         emit AdminWithdrawn(adminWallet, call_balance, callg_balance);
225     }
226 }