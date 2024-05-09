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
24 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
25 /// @author dev@smartcontracteam.com
26 /// Originally envisioned in FirstBlood ICO contract.
27 contract Haltable is Ownable {
28   bool public halted;
29 
30   modifier stopInEmergency {
31     require(!halted);
32     _;
33   }
34 
35   modifier onlyInEmergency {
36     require(halted);       
37     _;
38   }
39 
40   /// called by the owner on emergency, triggers stopped state
41   function halt() external onlyOwner {
42     halted = true;
43   }
44 
45   /// called by the owner on end of emergency, returns to normal state
46   function unhalt() external onlyOwner onlyInEmergency {
47     halted = false;
48   }
49 }
50 
51 
52 
53  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
54  /// @author dev@smartcontracteam.com
55 contract ERC20 {
56   uint public totalSupply;
57   function balanceOf(address who) constant returns (uint);
58   function allowance(address owner, address spender) constant returns (uint);
59   function mint(address receiver, uint amount);
60   function transfer(address to, uint value) returns (bool ok);
61   function transferFrom(address from, address to, uint value) returns (bool ok);
62   function approve(address spender, uint value) returns (bool ok);
63   event Transfer(address indexed from, address indexed to, uint value);
64   event Approval(address indexed owner, address indexed spender, uint value);
65 }
66 
67  /// @title SafeMath contract - math operations with safety checks
68  /// @author dev@smartcontracteam.com
69 contract SafeMath {
70   function safeMul(uint a, uint b) internal returns (uint) {
71     uint c = a * b;
72     assert(a == 0 || c / a == b);
73     return c;
74   }
75 
76   function safeDiv(uint a, uint b) internal returns (uint) {
77     assert(b > 0);
78     uint c = a / b;
79     assert(a == b * c + a % b);
80     return c;
81   }
82 
83   function safeSub(uint a, uint b) internal returns (uint) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   function safeAdd(uint a, uint b) internal returns (uint) {
89     uint c = a + b;
90     assert(c>=a && c>=b);
91     return c;
92   }
93 
94   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
95     return a >= b ? a : b;
96   }
97 
98   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
99     return a < b ? a : b;
100   }
101 
102   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
103     return a >= b ? a : b;
104   }
105 
106   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
107     return a < b ? a : b;
108   }
109 
110   function assert(bool assertion) internal {
111     require(assertion);  
112   }
113 }
114 
115 
116 /// @title SolarDaoToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
117 /// @author dev@smartcontracteam.com
118 contract SolarDaoToken is SafeMath, ERC20, Ownable {
119  string public name = "Solar DAO Token";
120  string public symbol = "SDAO";
121  uint public decimals = 4;
122 
123  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
124  address public crowdsaleAgent;
125  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
126  bool public released = false;
127  /// approve() allowances
128  mapping (address => mapping (address => uint)) allowed;
129  /// holder balances
130  mapping(address => uint) balances;
131 
132  /// @dev Limit token transfer until the crowdsale is over.
133  modifier canTransfer() {
134    if(!released) {
135        require(msg.sender == crowdsaleAgent);
136    }
137    _;
138  }
139 
140  /// @dev The function can be called only before or after the tokens have been releasesd
141  /// @param _released token transfer and mint state
142  modifier inReleaseState(bool _released) {
143    require(_released == released);
144    _;
145  }
146 
147  /// @dev The function can be called only by release agent.
148  modifier onlyCrowdsaleAgent() {
149    require(msg.sender == crowdsaleAgent);
150    _;
151  }
152 
153  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
154  /// @param size payload size
155  modifier onlyPayloadSize(uint size) {
156     require(msg.data.length >= size + 4);
157     _;
158  }
159 
160  /// @dev Make sure we are not done yet.
161  modifier canMint() {
162     require(!released);
163     _;
164   }
165 
166  /// @dev Constructor
167  function SolarDaoToken() {
168    owner = msg.sender;
169  }
170 
171  /// Fallback method will buyout tokens
172  function() payable {
173    revert();
174  }
175 
176  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
177  /// @param receiver Address of receiver
178  /// @param amount  Number of tokens to issue.
179  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
180     totalSupply = safeAdd(totalSupply, amount);
181     balances[receiver] = safeAdd(balances[receiver], amount);
182     Transfer(0, receiver, amount);
183  }
184 
185  /// @dev Set the contract that can call release and make the token transferable.
186  /// @param _crowdsaleAgent crowdsale contract address
187  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
188    crowdsaleAgent = _crowdsaleAgent;
189  }
190  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
191  function releaseTokenTransfer() public onlyCrowdsaleAgent {
192    released = true;
193  }
194  /// @dev Tranfer tokens to address
195  /// @param _to dest address
196  /// @param _value tokens amount
197  /// @return transfer result
198  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
199    balances[msg.sender] = safeSub(balances[msg.sender], _value);
200    balances[_to] = safeAdd(balances[_to], _value);
201 
202    Transfer(msg.sender, _to, _value);
203    return true;
204  }
205 
206  /// @dev Tranfer tokens from one address to other
207  /// @param _from source address
208  /// @param _to dest address
209  /// @param _value tokens amount
210  /// @return transfer result
211  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
212    var _allowance = allowed[_from][msg.sender];
213 
214     balances[_to] = safeAdd(balances[_to], _value);
215     balances[_from] = safeSub(balances[_from], _value);
216     allowed[_from][msg.sender] = safeSub(_allowance, _value);
217     Transfer(_from, _to, _value);
218     return true;
219  }
220  /// @dev Tokens balance
221  /// @param _owner holder address
222  /// @return balance amount
223  function balanceOf(address _owner) constant returns (uint balance) {
224    return balances[_owner];
225  }
226 
227  /// @dev Approve transfer
228  /// @param _spender holder address
229  /// @param _value tokens amount
230  /// @return result
231  function approve(address _spender, uint _value) returns (bool success) {
232    // To change the approve amount you first have to reduce the addresses`
233    //  allowance to zero by calling `approve(_spender, 0)` if it is not
234    //  already 0 to mitigate the race condition described here:
235    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
237 
238    allowed[msg.sender][_spender] = _value;
239    Approval(msg.sender, _spender, _value);
240    return true;
241  }
242 
243  /// @dev Token allowance
244  /// @param _owner holder address
245  /// @param _spender spender address
246  /// @return remain amount
247  function allowance(address _owner, address _spender) constant returns (uint remaining) {
248    return allowed[_owner][_spender];
249  }
250 }