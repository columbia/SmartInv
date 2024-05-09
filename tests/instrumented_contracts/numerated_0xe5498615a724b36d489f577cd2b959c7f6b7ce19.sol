1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     if (a == 0) {
48       return 0;
49     }
50     c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return a / b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 
98 
99 /**
100  * @title TokenVesting
101  * @dev A token holder contract that can release its token balance gradually like a
102  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
103  * owner.
104  */
105 contract TokenVesting is Ownable {
106   using SafeMath for uint256;
107 
108   event Released(uint256 amount);
109   event Revoked();
110 
111   // beneficiary of tokens after they are released
112   address public beneficiary;
113 
114   uint256 public cliff;
115   uint256 public start;
116   uint256 public duration;
117 
118   bool public revocable;
119 
120   mapping (address => uint256) public released;
121   mapping (address => bool) public revoked;
122 
123   /**
124    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
125    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
126    * of the balance will have vested.
127    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
128    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
129    * @param _start the time (as Unix time) at which point vesting starts 
130    * @param _duration duration in seconds of the period in which the tokens will vest
131    * @param _revocable whether the vesting is revocable or not
132    */
133   function TokenVesting(
134     address _beneficiary,
135     uint256 _start,
136     uint256 _cliff,
137     uint256 _duration,
138     bool _revocable
139   )
140     public
141   {
142     require(_beneficiary != address(0));
143     require(_cliff <= _duration);
144 
145     beneficiary = _beneficiary;
146     revocable = _revocable;
147     duration = _duration;
148     cliff = _start.add(_cliff);
149     start = _start;
150   }
151 
152   /**
153    * @notice Transfers vested tokens to beneficiary.
154    * @param token ERC20 token which is being vested
155    */
156   function release(ERC20Basic token) public {
157     uint256 unreleased = releasableAmount(token);
158 
159     require(unreleased > 0);
160 
161     released[token] = released[token].add(unreleased);
162 
163     require(token.transfer(beneficiary, unreleased));
164 
165     emit Released(unreleased);
166   }
167 
168   /**
169    * @notice Allows the owner to revoke the vesting. Tokens already vested
170    * remain in the contract, the rest are returned to the owner.
171    * @param token ERC20 token which is being vested
172    */
173   function revoke(ERC20Basic token) public onlyOwner {
174     require(revocable);
175     require(!revoked[token]);
176 
177     uint256 balance = token.balanceOf(this);
178 
179     uint256 unreleased = releasableAmount(token);
180     uint256 refund = balance.sub(unreleased);
181 
182     revoked[token] = true;
183 
184     require(token.transfer(owner, refund));
185 
186     emit Revoked();
187   }
188 
189   /**
190    * @dev Calculates the amount that has already vested but hasn't been released yet.
191    * @param token ERC20 token which is being vested
192    */
193   function releasableAmount(ERC20Basic token) public view returns (uint256) {
194     return vestedAmount(token).sub(released[token]);
195   }
196 
197   /**
198    * @dev Calculates the amount that has already vested.
199    * @param token ERC20 token which is being vested
200    */
201   function vestedAmount(ERC20Basic token) public view returns (uint256) {
202     uint256 currentBalance = token.balanceOf(this);
203     uint256 totalBalance = currentBalance.add(released[token]);
204 
205     if (block.timestamp < cliff) {
206       return 0;
207     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
208       return totalBalance;
209     } else {
210       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
211     }
212   }
213 }