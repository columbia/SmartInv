1 pragma solidity ^0.5.0;
2 
3  /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5   address public owner;
6 
7   constructor () public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) public onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
24 contract ERC20 {
25   uint public totalSupply;
26   function balanceOf(address who) public view returns (uint);
27   function allowance(address owner, address spender) public view returns (uint);
28   function transfer(address to, uint value) public returns (bool ok);
29   function transferFrom(address from, address to, uint value) public returns (bool ok);
30   function approve(address spender, uint value) public returns (bool ok);
31   event Transfer(address indexed from, address indexed to, uint value);
32   event Approval(address indexed owner, address indexed spender, uint value);
33 }
34 
35  /// @title SafeMath contract - math operations with safety checks
36 contract SafeMath {
37   function safeMul(uint a, uint b) internal pure returns (uint) {
38     uint c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function safeDiv(uint a, uint b) internal pure returns (uint) {
44     assert(b > 0);
45     uint c = a / b;
46     assert(a == b * c + a % b);
47     return c;
48   }
49 
50   function safeSub(uint a, uint b) internal pure returns (uint) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function safeAdd(uint a, uint b) internal pure returns (uint) {
56     uint c = a + b;
57     assert(c>=a && c>=b);
58     return c;
59   }
60 
61   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
62     return a >= b ? a : b;
63   }
64 
65   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
66     return a < b ? a : b;
67   }
68 
69   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
70     return a >= b ? a : b;
71   }
72 
73   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
74     return a < b ? a : b;
75   }
76 
77 }
78 
79 
80 /// @title PayFair contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
81 contract PayFair is SafeMath, ERC20, Ownable {
82  string public name = "PayFair Token";
83  string public symbol = "PFR";
84  uint public constant decimals = 8;
85  uint public constant FROZEN_TOKENS = 11e6;
86  uint public constant MULTIPLIER = 10 ** decimals;
87  ERC20 public oldToken;
88  
89  /// approve() allowances
90  mapping (address => mapping (address => uint)) allowed;
91  /// holder balances
92  mapping(address => uint) balances;
93  
94  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
95  /// @param size payload size
96  modifier onlyPayloadSize(uint size) {
97     require(msg.data.length >= size + 4);
98     _;
99  }
100 
101  /// @dev Constructor
102  constructor (address oldTokenAdddress) public {
103    owner = msg.sender;
104    oldToken = ERC20(oldTokenAdddress);
105    
106    totalSupply = convertToDecimal(FROZEN_TOKENS);
107    balances[owner] = convertToDecimal(FROZEN_TOKENS);
108  }
109 
110  /// Fallback method will buyout tokens
111  function() external payable {
112    revert();
113  }
114 
115  function upgradeTokens(uint amountToUpgrade) public {  
116     require(amountToUpgrade <= convertToDecimal(oldToken.balanceOf(msg.sender)));
117     require(amountToUpgrade <= convertToDecimal(oldToken.allowance(msg.sender, address(this))));   
118     
119     emit Transfer(address(0), msg.sender, amountToUpgrade);
120     totalSupply = safeAdd(totalSupply, amountToUpgrade);
121     balances[msg.sender] = safeAdd(balances[msg.sender], amountToUpgrade);
122     oldToken.transferFrom(msg.sender, address(0x0), amountToUpgrade);
123  }
124 
125  /// @dev Converts token value to value with decimal places
126  /// @param amount Source token value
127  function convertToDecimal(uint amount) private pure returns (uint) {
128    return safeMul(amount, MULTIPLIER);
129  }
130 
131  /// @dev Tranfer tokens to address
132  /// @param _to dest address
133  /// @param _value tokens amount
134  /// @return transfer result
135  function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
136    balances[msg.sender] = safeSub(balances[msg.sender], _value);
137    balances[_to] = safeAdd(balances[_to], _value);
138 
139    emit Transfer(msg.sender, _to, _value);
140    return true;
141  }
142 
143  /// @dev Tranfer tokens from one address to other
144  /// @param _from source address
145  /// @param _to dest address
146  /// @param _value tokens amount
147  /// @return transfer result
148  function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
149     uint256 _allowance = allowed[_from][msg.sender];
150 
151     balances[_to] = safeAdd(balances[_to], _value);
152     balances[_from] = safeSub(balances[_from], _value);
153     allowed[_from][msg.sender] = safeSub(_allowance, _value);
154     emit Transfer(_from, _to, _value);
155     return true;
156  }
157  /// @dev Tokens balance
158  /// @param _owner holder address
159  /// @return balance amount
160  function balanceOf(address _owner) public view returns (uint balance) {
161    return balances[_owner];
162  }
163 
164  /// @dev Approve transfer
165  /// @param _spender holder address
166  /// @param _value tokens amount
167  /// @return result
168  function approve(address _spender, uint _value) public returns (bool success) {
169    // To change the approve amount you first have to reduce the addresses`
170    //  allowance to zero by calling `approve(_spender, 0)` if it is not
171    //  already 0 to mitigate the race condition described here:
172    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
174 
175    allowed[msg.sender][_spender] = _value;
176    emit Approval(msg.sender, _spender, _value);
177    return true;
178  }
179 
180  /// @dev Token allowance
181  /// @param _owner holder address
182  /// @param _spender spender address
183  /// @return remain amount
184  function allowance(address _owner, address _spender) public view returns (uint remaining) {
185    return allowed[_owner][_spender];
186  }
187 }