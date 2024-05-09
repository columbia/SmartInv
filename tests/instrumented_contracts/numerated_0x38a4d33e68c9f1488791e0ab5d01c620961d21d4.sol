1 pragma solidity 0.4.19;
2 contract ERC20Basic {
3   function totalSupply() public view returns (uint256);
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 contract ERC20 is ERC20Basic {
10   function allowance(address owner, address spender) public view returns (uint256);
11   function transferFrom(address from, address to, uint256 value) public returns (bool);
12   function approve(address spender, uint256 value) public returns (bool);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 library SafeERC20 {
18   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
19     assert(token.transfer(to, value));
20   }
21 
22   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
23     assert(token.transferFrom(from, to, value));
24   }
25 
26   function safeApprove(ERC20 token, address spender, uint256 value) internal {
27     assert(token.approve(spender, value));
28   }
29 }
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   /**
89   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 contract TokenVesting is Ownable {
106   using SafeMath for uint256;
107   using SafeERC20 for ERC20Basic;
108 
109   event Released(uint256 amount);
110   event Revoked();
111 
112   // beneficiary of tokens after they are released
113   address public beneficiary;
114 
115   uint256 public cliff;
116   uint256 public start;
117   uint256 public duration;
118 
119   bool public revocable;
120 
121   mapping (address => uint256) public released;
122   mapping (address => bool) public revoked;
123 
124   /**
125    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
126    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
127    * of the balance will have vested.
128    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
129    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
130    * @param _duration duration in seconds of the period in which the tokens will vest
131    * @param _revocable whether the vesting is revocable or not
132    */
133   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
134     require(_beneficiary != address(0));
135     require(_cliff <= _duration);
136 
137     beneficiary = _beneficiary;
138     revocable = _revocable;
139     duration = _duration;
140     cliff = _start.add(_cliff);
141     start = _start;
142   }
143 
144   /**
145    * @notice Transfers vested tokens to beneficiary.
146    * @param token ERC20 token which is being vested
147    */
148   function release(ERC20Basic token) public {
149     uint256 unreleased = releasableAmount(token);
150 
151     require(unreleased > 0);
152 
153     released[token] = released[token].add(unreleased);
154 
155     token.safeTransfer(beneficiary, unreleased);
156 
157     Released(unreleased);
158   }
159 
160   /**
161    * @notice Allows the owner to revoke the vesting. Tokens already vested
162    * remain in the contract, the rest are returned to the owner.
163    * @param token ERC20 token which is being vested
164    */
165   function revoke(ERC20Basic token) public onlyOwner {
166     require(revocable);
167     require(!revoked[token]);
168 
169     uint256 balance = token.balanceOf(this);
170 
171     uint256 unreleased = releasableAmount(token);
172     uint256 refund = balance.sub(unreleased);
173 
174     revoked[token] = true;
175 
176     token.safeTransfer(owner, refund);
177 
178     Revoked();
179   }
180 
181   /**
182    * @dev Calculates the amount that has already vested but hasn't been released yet.
183    * @param token ERC20 token which is being vested
184    */
185   function releasableAmount(ERC20Basic token) public view returns (uint256) {
186     return vestedAmount(token).sub(released[token]);
187   }
188 
189   /**
190    * @dev Calculates the amount that has already vested.
191    * @param token ERC20 token which is being vested
192    */
193   function vestedAmount(ERC20Basic token) public view returns (uint256) {
194     uint256 currentBalance = token.balanceOf(this);
195     uint256 totalBalance = currentBalance.add(released[token]);
196 
197     if (now < cliff) {
198       return 0;
199     } else if (now >= start.add(duration) || revoked[token]) {
200       return totalBalance;
201     } else {
202       return totalBalance.mul(now.sub(start)).div(duration);
203     }
204   }
205 }