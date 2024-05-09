1 pragma solidity ^0.4.13;
2 
3  /// @title Ownable contract - base contract with an owner
4  /// @author dev@smartcontracteam.com
5 contract Ownable {
6   address public owner;
7 
8   function Ownable() {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);  
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 }
23 
24  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
25  /// @author dev@smartcontracteam.com
26 contract ERC20 {
27   uint public totalSupply;
28   function balanceOf(address who) constant returns (uint);
29   function allowance(address owner, address spender) constant returns (uint);
30   function mint(address receiver, uint amount);
31   function transfer(address to, uint value) returns (bool ok);
32   function transferFrom(address from, address to, uint value) returns (bool ok);
33   function approve(address spender, uint value) returns (bool ok);
34   event Transfer(address indexed from, address indexed to, uint value);
35   event Approval(address indexed owner, address indexed spender, uint value);
36 }
37 
38  /// @title SafeMath contract - math operations with safety checks
39  /// @author dev@smartcontracteam.com
40 contract SafeMath {
41   function safeMul(uint a, uint b) internal returns (uint) {
42     uint c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function safeDiv(uint a, uint b) internal returns (uint) {
48     assert(b > 0);
49     uint c = a / b;
50     assert(a == b * c + a % b);
51     return c;
52   }
53 
54   function safeSub(uint a, uint b) internal returns (uint) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   function safeAdd(uint a, uint b) internal returns (uint) {
60     uint c = a + b;
61     assert(c>=a && c>=b);
62     return c;
63   }
64 
65   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
66     return a >= b ? a : b;
67   }
68 
69   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
70     return a < b ? a : b;
71   }
72 
73   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
74     return a >= b ? a : b;
75   }
76 
77   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
78     return a < b ? a : b;
79   }
80 
81   function assert(bool assertion) internal {
82     require(assertion);  
83   }
84 }
85 
86 /// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
87 /// @author dev@smartcontracteam.com
88 contract ZiberToken is SafeMath, ERC20, Ownable {
89  string public name = "Ziber Token";
90  string public symbol = "ZBR";
91  uint public decimals = 8;
92  uint public constant FROZEN_TOKENS = 10000000;
93  uint public constant FREEZE_PERIOD = 1 years;
94  uint public crowdSaleOverTimestamp;
95 
96  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
97  address public crowdsaleAgent;
98  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
99  bool public released = false;
100  /// approve() allowances
101  mapping (address => mapping (address => uint)) allowed;
102  /// holder balances
103  mapping(address => uint) balances;
104 
105  /// @dev Limit token transfer until the crowdsale is over.
106  modifier canTransfer() {
107    if(!released) {
108      require(msg.sender == crowdsaleAgent);
109    }
110    _;
111  }
112 
113  modifier checkFrozenAmount(address source, uint amount) {
114    if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {
115      var frozenTokens = 10 ** decimals * FROZEN_TOKENS;
116      require(safeSub(balances[owner], amount) > frozenTokens);
117    }
118    _;
119  }
120 
121  /// @dev The function can be called only before or after the tokens have been releasesd
122  /// @param _released token transfer and mint state
123  modifier inReleaseState(bool _released) {
124    require(_released == released);
125    _;
126  }
127 
128  /// @dev The function can be called only by release agent.
129  modifier onlyCrowdsaleAgent() {
130    require(msg.sender == crowdsaleAgent);
131    _;
132  }
133 
134  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
135  /// @param size payload size
136  modifier onlyPayloadSize(uint size) {
137    require(msg.data.length >= size + 4);
138     _;
139  }
140 
141  /// @dev Make sure we are not done yet.
142  modifier canMint() {
143    require(!released);
144     _;
145   }
146 
147  /// @dev Constructor
148  function ZiberToken() {
149    owner = msg.sender;
150  }
151 
152  /// Fallback method will buyout tokens
153  function() payable {
154    revert();
155  }
156  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
157  /// @param receiver Address of receiver
158  /// @param amount  Number of tokens to issue.
159  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
160     totalSupply = safeAdd(totalSupply, amount);
161     balances[receiver] = safeAdd(balances[receiver], amount);
162     Transfer(0, receiver, amount);
163  }
164 
165  /// @dev Set the contract that can call release and make the token transferable.
166  /// @param _crowdsaleAgent crowdsale contract address
167  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
168    crowdsaleAgent = _crowdsaleAgent;
169  }
170  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
171  function releaseTokenTransfer() public onlyCrowdsaleAgent {
172    crowdSaleOverTimestamp = now;
173    released = true;
174  }
175  /// @dev Tranfer tokens to address
176  /// @param _to dest address
177  /// @param _value tokens amount
178  /// @return transfer result
179  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {
180    balances[msg.sender] = safeSub(balances[msg.sender], _value);
181    balances[_to] = safeAdd(balances[_to], _value);
182 
183    Transfer(msg.sender, _to, _value);
184    return true;
185  }
186 
187  /// @dev Tranfer tokens from one address to other
188  /// @param _from source address
189  /// @param _to dest address
190  /// @param _value tokens amount
191  /// @return transfer result
192  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {
193     var _allowance = allowed[_from][msg.sender];
194 
195     balances[_to] = safeAdd(balances[_to], _value);
196     balances[_from] = safeSub(balances[_from], _value);
197     allowed[_from][msg.sender] = safeSub(_allowance, _value);
198     Transfer(_from, _to, _value);
199     return true;
200  }
201  /// @dev Tokens balance
202  /// @param _owner holder address
203  /// @return balance amount
204  function balanceOf(address _owner) constant returns (uint balance) {
205    return balances[_owner];
206  }
207 
208  /// @dev Approve transfer
209  /// @param _spender holder address
210  /// @param _value tokens amount
211  /// @return result
212  function approve(address _spender, uint _value) returns (bool success) {
213    // To change the approve amount you first have to reduce the addresses`
214    //  allowance to zero by calling `approve(_spender, 0)` if it is not
215    //  already 0 to mitigate the race condition described here:
216    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729   
217    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
218 
219    allowed[msg.sender][_spender] = _value;
220    Approval(msg.sender, _spender, _value);
221    return true;
222  }
223 
224  /// @dev Token allowance
225  /// @param _owner holder address
226  /// @param _spender spender address
227  /// @return remain amount
228  function allowance(address _owner, address _spender) constant returns (uint remaining) {
229    return allowed[_owner][_spender];
230  }
231 }