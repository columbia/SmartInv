1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeERC20
28  * @dev Wrappers around ERC20 operations that throw on failure.
29  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
30  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
31  */
32 library SafeERC20 {
33   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
34     assert(token.transfer(to, value));
35   }
36 
37   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
38     assert(token.transferFrom(from, to, value));
39   }
40 
41   function safeApprove(ERC20 token, address spender, uint256 value) internal {
42     assert(token.approve(spender, value));
43   }
44 }
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal constant returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal constant returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 /**
77  * @title Ownable
78  * @dev The Ownable contract has an owner address, and provides basic authorization control
79  * functions, this simplifies the implementation of "user permissions".
80  */
81 contract Ownable {
82   address public owner;
83 
84 
85   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87 
88   /**
89    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
90    * account.
91    */
92   function Ownable() {
93     owner = msg.sender;
94   }
95 
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) onlyOwner public {
111     require(newOwner != address(0));
112     OwnershipTransferred(owner, newOwner);
113     owner = newOwner;
114   }
115 
116 }
117 
118 
119 /**
120  * @title BARTokenVesting
121  * @dev A token holder contract that can release its token balance gradually like a
122  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
123  * owner.
124  */
125 contract BARTokenVesting is Ownable {
126   using SafeMath for uint256;
127   using SafeERC20 for ERC20Basic;
128 
129   event Released(uint256 amount);
130   event Revoked();
131 
132   // beneficiary of tokens after they are released
133   address public beneficiary;
134 
135   uint256 public cliff;
136   uint256 public start;
137   uint256 public duration;
138 
139   bool public revocable;
140 
141   mapping (address => uint256) public released;
142   mapping (address => bool) public revoked;
143 
144   /**
145    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
146    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
147    * of the balance will have vested.
148    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
149    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
150    * @param _duration duration in seconds of the period in which the tokens will vest
151    * @param _revocable whether the vesting is revocable or not
152    */
153   function BARTokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
154     require(_beneficiary != address(0));
155     require(_cliff <= _duration);
156 
157     beneficiary = _beneficiary;
158     revocable = _revocable;
159     duration = _duration;
160     cliff = _start.add(_cliff);
161     start = _start;
162   }
163 
164   /**
165    * @notice Transfers vested tokens to beneficiary.
166    * @param token ERC20 token which is being vested
167    */
168   function release(ERC20Basic token) public {
169     uint256 unreleased = releasableAmount(token);
170 
171     require(unreleased > 0);
172 
173     released[token] = released[token].add(unreleased);
174 
175     token.safeTransfer(beneficiary, unreleased);
176 
177     Released(unreleased);
178   }
179 
180   /**
181    * @notice Allows the owner to revoke the vesting. Tokens already vested
182    * remain in the contract, the rest are returned to the owner.
183    * @param token ERC20 token which is being vested
184    */
185   function revoke(ERC20Basic token) public onlyOwner {
186     require(revocable);
187     require(!revoked[token]);
188 
189     uint256 balance = token.balanceOf(this);
190 
191     uint256 unreleased = releasableAmount(token);
192     uint256 refund = balance.sub(unreleased);
193 
194     revoked[token] = true;
195 
196     token.safeTransfer(owner, refund);
197 
198     Revoked();
199   }
200 
201   /**
202    * @dev Calculates the amount that has already vested but hasn't been released yet.
203    * @param token ERC20 token which is being vested
204    */
205   function releasableAmount(ERC20Basic token) public view returns (uint256) {
206     return vestedAmount(token).sub(released[token]);
207   }
208 
209   /**
210    * @dev Calculates the amount that has already vested.
211    * @param token ERC20 token which is being vested
212    */
213   function vestedAmount(ERC20Basic token) public view returns (uint256) {
214     uint256 currentBalance = token.balanceOf(this);
215     uint256 totalBalance = currentBalance.add(released[token]);
216 
217     if (now < cliff) {
218       return 0;
219     } else if (now >= start.add(duration) || revoked[token]) {
220       return totalBalance;
221     } else {
222       return totalBalance.mul(now.sub(start)).div(duration);
223     }
224   }
225 }