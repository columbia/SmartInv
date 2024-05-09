1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20
5  * @dev ERC20 interface
6  */
7 contract ERC20 {
8     function balanceOf(address who) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public constant returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Controlled {
18     /// @notice The address of the controller is the only address that can call
19     ///  a function with this modifier
20     modifier onlyController { require(msg.sender == controller); _; }
21 
22     address public controller;
23 
24     function Controlled() public { controller = msg.sender;}
25 
26     /// @notice Changes the controller of the contract
27     /// @param _newController The new controller of the contract
28     function changeController(address _newController) public onlyController {
29         controller = _newController;
30     }
31 }
32 
33 /**
34  * @title MiniMe interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20MiniMe is ERC20, Controlled {
38     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
39     function totalSupply() public constant returns (uint);
40     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
41     function totalSupplyAt(uint _blockNumber) public constant returns(uint);
42     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
43     function generateTokens(address _owner, uint _amount) public returns (bool);
44     function destroyTokens(address _owner, uint _amount)  public returns (bool);
45     function enableTransfers(bool _transfersEnabled) public;
46     function isContract(address _addr) constant internal returns(bool);
47     function claimTokens(address _token) public;
48     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
49     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() {
69     owner = msg.sender;
70   }
71 
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) onlyOwner public {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
100     uint256 c = a * b;
101     assert(a == 0 || c / a == b);
102     return c;
103   }
104 
105   function div(uint256 a, uint256 b) internal constant returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return c;
110   }
111 
112   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   function add(uint256 a, uint256 b) internal constant returns (uint256) {
118     uint256 c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 /**
125  * @title Etheal TokenVesting for Advisors
126  * @dev A token holder contract that can release its token balance gradually like a
127  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
128  * owner.
129  */
130 contract TokenVesting is Ownable {
131   using SafeMath for uint256;
132 
133   event Released(uint256 amount);
134   event Revoked();
135 
136   // beneficiary of tokens after they are released
137   address public beneficiary;
138 
139   uint256 public cliff;
140   uint256 public start;
141   uint256 public duration;
142 
143   bool public revocable;
144 
145   mapping (address => uint256) public released;
146   mapping (address => bool) public revoked;
147 
148   /**
149    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
150    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
151    * of the balance will have vested.
152    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
153    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
154    * @param _duration duration in seconds of the period in which the tokens will vest
155    * @param _revocable whether the vesting is revocable or not
156    */
157   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) {
158     require(_beneficiary != address(0));
159     require(_cliff <= _duration);
160 
161     beneficiary = _beneficiary;
162     revocable = _revocable;
163     duration = _duration;
164     cliff = _start.add(_cliff);
165     start = _start;
166   }
167 
168   /**
169    * @notice Transfers vested tokens to beneficiary.
170    * @param token ERC20 token which is being vested
171    */
172   function release(ERC20MiniMe token) public {
173     uint256 unreleased = releasableAmount(token);
174 
175     require(unreleased > 0);
176 
177     released[token] = released[token].add(unreleased);
178 
179     require(token.transfer(beneficiary, unreleased));
180 
181     Released(unreleased);
182   }
183 
184   /**
185    * @notice Allows the owner to revoke the vesting. Tokens already vested
186    * remain in the contract, the rest are returned to the owner.
187    * @param token ERC20MiniMe token which is being vested
188    */
189   function revoke(ERC20MiniMe token) public onlyOwner {
190     require(revocable);
191     require(!revoked[token]);
192 
193     uint256 balance = token.balanceOf(this);
194 
195     uint256 unreleased = releasableAmount(token);
196     uint256 refund = balance.sub(unreleased);
197 
198     revoked[token] = true;
199 
200     require(token.transfer(owner, refund));
201 
202     Revoked();
203   }
204 
205   /**
206    * @dev Calculates the amount that has already vested but hasn't been released yet.
207    * @param token ERC20MiniMe token which is being vested
208    */
209   function releasableAmount(ERC20MiniMe token) public constant returns (uint256) {
210     return vestedAmount(token).sub(released[token]);
211   }
212 
213   /**
214    * @dev Calculates the amount that has already vested.
215    * @param token ERC20MiniMe token which is being vested
216    */
217   function vestedAmount(ERC20MiniMe token) public constant returns (uint256) {
218     uint256 currentBalance = token.balanceOf(this);
219     uint256 totalBalance = currentBalance.add(released[token]);
220 
221     if (now < cliff) {
222       return 0;
223     } else if (now >= start.add(duration) || revoked[token]) {
224       return totalBalance;
225     } else {
226       return totalBalance.mul(now.sub(start)).div(duration);
227     }
228   }
229 }