1 pragma solidity ^0.4.18;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) public onlyOwner {
29     require(newOwner != address(0));
30     OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 }
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public view returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 /**
56  * @title SafeERC20
57  * @dev Wrappers around ERC20 operations that throw on failure.
58  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
59  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
60  */
61 library SafeERC20 {
62   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
63     assert(token.transfer(to, value));
64   }
65   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
66     assert(token.transferFrom(from, to, value));
67   }
68   function safeApprove(ERC20 token, address spender, uint256 value) internal {
69     assert(token.approve(spender, value));
70   }
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 /**
103  * @title TokenVesting
104  * @dev A token holder contract that can release its token balance gradually like a
105  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
106  * owner.
107  */
108 contract TokenVesting is Ownable {
109   using SafeMath for uint256;
110   using SafeERC20 for ERC20Basic;
111   event Released(uint256 amount);
112   event Revoked();
113   // beneficiary of tokens after they are released
114   address public beneficiary;
115   uint256 public cliff;
116   uint256 public start;
117   uint256 public duration;
118   bool public revocable;
119   mapping (address => uint256) public released;
120   mapping (address => bool) public revoked;
121   /**
122    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
123    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
124    * of the balance will have vested.
125    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
126    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
127    * @param _duration duration in seconds of the period in which the tokens will vest
128    * @param _revocable whether the vesting is revocable or not
129    */
130   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
131     require(_beneficiary != address(0));
132     require(_cliff <= _duration);
133     beneficiary = _beneficiary;
134     revocable = _revocable;
135     duration = _duration;
136     cliff = _start.add(_cliff);
137     start = _start;
138   }
139   /**
140    * @notice Transfers vested tokens to beneficiary.
141    * @param token ERC20 token which is being vested
142    */
143   function release(ERC20Basic token) public {
144     uint256 unreleased = releasableAmount(token);
145     require(unreleased > 0);
146     released[token] = released[token].add(unreleased);
147     token.safeTransfer(beneficiary, unreleased);
148     Released(unreleased);
149   }
150   /**
151    * @notice Allows the owner to revoke the vesting. Tokens already vested
152    * remain in the contract, the rest are returned to the owner.
153    * @param token ERC20 token which is being vested
154    */
155   function revoke(ERC20Basic token) public onlyOwner {
156     require(revocable);
157     require(!revoked[token]);
158     uint256 balance = token.balanceOf(this);
159     uint256 unreleased = releasableAmount(token);
160     uint256 refund = balance.sub(unreleased);
161     revoked[token] = true;
162     token.safeTransfer(owner, refund);
163     Revoked();
164   }
165   /**
166    * @dev Calculates the amount that has already vested but hasn't been released yet.
167    * @param token ERC20 token which is being vested
168    */
169   function releasableAmount(ERC20Basic token) public view returns (uint256) {
170     return vestedAmount(token).sub(released[token]);
171   }
172   /**
173    * @dev Calculates the amount that has already vested.
174    * @param token ERC20 token which is being vested
175    */
176   function vestedAmount(ERC20Basic token) public view returns (uint256) {
177     uint256 currentBalance = token.balanceOf(this);
178     uint256 totalBalance = currentBalance.add(released[token]);
179     if (now < cliff) {
180       return 0;
181     } else if (now >= start.add(duration) || revoked[token]) {
182       return totalBalance;
183     } else {
184       return totalBalance.mul(now.sub(start)).div(duration);
185     }
186   }
187 }
188 contract ShortVesting is TokenVesting {
189     function ShortVesting(address _beneficiary) TokenVesting(
190             _beneficiary,
191             1522540800,
192             0,
193             0,
194             false
195         )
196     {}
197 }