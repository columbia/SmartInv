1 pragma solidity ^0.4.13;
2 
3  /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
24 contract ERC20 {
25   uint public totalSupply;
26   function balanceOf(address who) constant returns (uint);
27   function allowance(address owner, address spender) constant returns (uint);
28   function mint(address receiver, uint amount);
29   function transfer(address to, uint value) returns (bool ok);
30   function transferFrom(address from, address to, uint value) returns (bool ok);
31   function approve(address spender, uint value) returns (bool ok);
32   event Transfer(address indexed from, address indexed to, uint value);
33   event Approval(address indexed owner, address indexed spender, uint value);
34 }
35 
36  /// @title SafeMath contract - math operations with safety checks
37 contract SafeMath {
38   function safeMul(uint a, uint b) internal returns (uint) {
39     uint c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function safeDiv(uint a, uint b) internal returns (uint) {
45     assert(b > 0);
46     uint c = a / b;
47     assert(a == b * c + a % b);
48     return c;
49   }
50 
51   function safeSub(uint a, uint b) internal returns (uint) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function safeAdd(uint a, uint b) internal returns (uint) {
57     uint c = a + b;
58     assert(c>=a && c>=b);
59     return c;
60   }
61 
62   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
63     return a >= b ? a : b;
64   }
65 
66   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a < b ? a : b;
68   }
69 
70   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
71     return a >= b ? a : b;
72   }
73 
74   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a < b ? a : b;
76   }
77 
78 }
79 
80 
81 /// @title PayFairToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
82 contract PayFairToken is SafeMath, ERC20, Ownable {
83  string public name = "PayFair Token";
84  string public symbol = "PFR";
85  uint public constant decimals = 8;
86  uint public constant FROZEN_TOKENS = 11e6;
87  uint public constant FREEZE_PERIOD = 1 years;
88  uint public constant MULTIPLIER = 10 ** decimals;
89  uint public crowdSaleOverTimestamp;
90 
91  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
92  address public crowdsaleAgent;
93  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
94  bool public released = false;
95  /// approve() allowances
96  mapping (address => mapping (address => uint)) allowed;
97  /// holder balances
98  mapping(address => uint) balances;
99 
100  /// @dev Limit token transfer until the crowdsale is over.
101  modifier canTransfer() {
102    if(!released) {
103       require(msg.sender == crowdsaleAgent);
104    }
105    _;
106  }
107 
108  modifier checkFrozenAmount(address source, uint amount) {
109    if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {
110      var frozenTokens = 10 ** decimals * FROZEN_TOKENS;
111      require(safeSub(balances[owner], amount) > frozenTokens);
112    }
113    _;
114  }
115 
116  /// @dev The function can be called only before or after the tokens have been releasesd
117  /// @param _released token transfer and mint state
118  modifier inReleaseState(bool _released) {
119    require(_released == released);
120    _;
121  }
122 
123  /// @dev The function can be called only by release agent.
124  modifier onlyCrowdsaleAgent() {
125    require(msg.sender == crowdsaleAgent);
126    _;
127  }
128 
129  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
130  /// @param size payload size
131  modifier onlyPayloadSize(uint size) {
132     require(msg.data.length >= size + 4);
133     _;
134  }
135 
136  /// @dev Make sure we are not done yet.
137  modifier canMint() {
138     require(!released);
139     _;
140   }
141 
142  /// @dev Constructor
143  function PayFairToken() {
144    owner = msg.sender;
145  }
146 
147  /// Fallback method will buyout tokens
148  function() payable {
149    revert();
150  }
151  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
152  /// @param receiver Address of receiver
153  /// @param amount  Number of tokens to issue.
154  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
155     totalSupply = safeAdd(totalSupply, amount);
156     balances[receiver] = safeAdd(balances[receiver], amount);
157     Transfer(0, receiver, amount);
158  }
159 
160  /// @dev Set the contract that can call release and make the token transferable.
161  /// @param _crowdsaleAgent crowdsale contract address
162  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
163    crowdsaleAgent = _crowdsaleAgent;
164  }
165  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
166  function releaseTokenTransfer() public onlyCrowdsaleAgent {
167    crowdSaleOverTimestamp = now;
168    released = true;
169  }
170 
171  /// @dev Converts token value to value with decimal places
172  /// @param amount Source token value
173  function convertToDecimal(uint amount) public constant returns (uint) {
174    return safeMul(amount, MULTIPLIER);
175  }
176 
177  /// @dev Tranfer tokens to address
178  /// @param _to dest address
179  /// @param _value tokens amount
180  /// @return transfer result
181  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {
182    balances[msg.sender] = safeSub(balances[msg.sender], _value);
183    balances[_to] = safeAdd(balances[_to], _value);
184 
185    Transfer(msg.sender, _to, _value);
186    return true;
187  }
188 
189  /// @dev Tranfer tokens from one address to other
190  /// @param _from source address
191  /// @param _to dest address
192  /// @param _value tokens amount
193  /// @return transfer result
194  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {
195     var _allowance = allowed[_from][msg.sender];
196 
197     balances[_to] = safeAdd(balances[_to], _value);
198     balances[_from] = safeSub(balances[_from], _value);
199     allowed[_from][msg.sender] = safeSub(_allowance, _value);
200     Transfer(_from, _to, _value);
201     return true;
202  }
203  /// @dev Tokens balance
204  /// @param _owner holder address
205  /// @return balance amount
206  function balanceOf(address _owner) constant returns (uint balance) {
207    return balances[_owner];
208  }
209 
210  /// @dev Approve transfer
211  /// @param _spender holder address
212  /// @param _value tokens amount
213  /// @return result
214  function approve(address _spender, uint _value) returns (bool success) {
215    // To change the approve amount you first have to reduce the addresses`
216    //  allowance to zero by calling `approve(_spender, 0)` if it is not
217    //  already 0 to mitigate the race condition described here:
218    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
220 
221    allowed[msg.sender][_spender] = _value;
222    Approval(msg.sender, _spender, _value);
223    return true;
224  }
225 
226  /// @dev Token allowance
227  /// @param _owner holder address
228  /// @param _spender spender address
229  /// @return remain amount
230  function allowance(address _owner, address _spender) constant returns (uint remaining) {
231    return allowed[_owner][_spender];
232  }
233 }