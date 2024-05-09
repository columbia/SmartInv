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
23  /// @title ERC223 interface 
24 contract ERC223 {
25   uint public totalSupply;
26   function balanceOf(address who) public view returns (uint);
27   function allowance(address owner, address spender) public view returns (uint);
28   function transfer(address to, uint value) public returns (bool ok);
29   function transferFrom(address from, address to, uint value) public returns (bool ok);
30   function transfer(address to, uint value, bytes memory data) public returns (bool ok);
31   function transferFrom(address from, address to, uint value, bytes memory data) public returns (bool ok);
32   function approve(address spender, uint value) public returns (bool ok);
33   event Transfer(address indexed from, address indexed to, uint value);
34   event Approval(address indexed owner, address indexed spender, uint value);
35 }
36 
37  /// @title Contract that will work with ERC223 tokens.
38 contract ERC223Receiver { 
39   function tokenFallback(address sender, address origin, uint value, bytes memory data) public returns (bool ok);
40 }
41 
42  /// @title SafeMath contract - math operations with safety checks
43 contract SafeMath {
44   function safeMul(uint a, uint b) internal pure returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function safeDiv(uint a, uint b) internal pure returns (uint) {
51     assert(b > 0);
52     uint c = a / b;
53     assert(a == b * c + a % b);
54     return c;
55   }
56 
57   function safeSub(uint a, uint b) internal pure returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function safeAdd(uint a, uint b) internal pure returns (uint) {
63     uint c = a + b;
64     assert(c>=a && c>=b);
65     return c;
66   }
67 
68   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
69     return a >= b ? a : b;
70   }
71 
72   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
73     return a < b ? a : b;
74   }
75 
76   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
77     return a >= b ? a : b;
78   }
79 
80   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
81     return a < b ? a : b;
82   }
83 
84 }
85 
86 
87 /// @title PayFair contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
88 contract PayFair is SafeMath, ERC223, Ownable {
89  string public name = "PayFair Token";
90  string public symbol = "PFR";
91  uint public constant decimals = 8;
92  uint public constant FROZEN_TOKENS = 11109031;
93  uint public constant MULTIPLIER = 10 ** decimals;
94  ERC223 public oldToken;
95  
96  /// approve() allowances
97  mapping (address => mapping (address => uint)) allowed;
98  /// holder balances
99  mapping(address => uint) balances;
100  
101  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
102  /// @param size payload size
103  modifier onlyPayloadSize(uint size) {
104     require(msg.data.length >= size + 4);
105     _;
106  }
107 
108  /// @dev Constructor
109  constructor (address oldTokenAdddress) public {   
110    oldToken = ERC223(oldTokenAdddress);
111    
112    totalSupply = convertToDecimal(FROZEN_TOKENS);
113    balances[owner] = convertToDecimal(FROZEN_TOKENS);
114  }
115 
116  /// Fallback method will buyout tokens
117  function() external payable {
118    revert();
119  }
120 
121  function upgradeTokens(uint amountToUpgrade) public {  
122     require(amountToUpgrade <= oldToken.balanceOf(msg.sender));
123     require(amountToUpgrade <= oldToken.allowance(msg.sender, address(this)));   
124     
125     emit Transfer(address(0), msg.sender, amountToUpgrade);
126     totalSupply = safeAdd(totalSupply, amountToUpgrade);
127     balances[msg.sender] = safeAdd(balances[msg.sender], amountToUpgrade);
128     oldToken.transferFrom(msg.sender, address(0x0), amountToUpgrade);
129  }
130 
131  /// @dev Converts token value to value with decimal places
132  /// @param amount Source token value
133  function convertToDecimal(uint amount) private pure returns (uint) {
134    return safeMul(amount, MULTIPLIER);
135  }
136 
137  /// @dev Tranfer tokens to address
138  /// @param _to dest address
139  /// @param _value tokens amount
140  /// @return transfer result
141  function transfer(address _to, uint _value) public returns (bool success) {
142    bytes memory empty;
143    return transfer(_to, _value, empty);
144  }
145 
146  /// @dev Tranfer tokens from one address to other
147  /// @param _from source address
148  /// @param _to dest address
149  /// @param _value tokens amount
150  /// @return transfer result
151  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
152     bytes memory empty;
153     return transferFrom(_from, _to, _value, empty);
154  }
155  
156  /// @dev Tranfer tokens to address
157  /// @param _to dest address
158  /// @param _value tokens amount
159  /// @param _data data
160  /// @return transfer result
161  function transfer(address _to, uint _value, bytes memory _data) public onlyPayloadSize(2 * 32) returns (bool success) {
162    balances[msg.sender] = safeSub(balances[msg.sender], _value);
163    balances[_to] = safeAdd(balances[_to], _value);
164    
165    if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
166    emit Transfer(msg.sender, _to, _value);
167    return true;
168  }
169 
170  /// @dev Tranfer tokens from one address to other
171  /// @param _from source address
172  /// @param _to dest address
173  /// @param _value tokens amount
174  /// @param _data data
175  /// @return transfer result
176  function transferFrom(address _from, address _to, uint _value, bytes memory _data) public onlyPayloadSize(2 * 32) returns (bool success) {
177     uint256 _allowance = allowed[_from][msg.sender];
178 
179     balances[_to] = safeAdd(balances[_to], _value);
180     balances[_from] = safeSub(balances[_from], _value);
181     allowed[_from][msg.sender] = safeSub(_allowance, _value);
182     
183     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
184     emit Transfer(_from, _to, _value);
185     return true;
186  }
187  /// @dev Tokens balance
188  /// @param _owner holder address
189  /// @return balance amount
190  function balanceOf(address _owner) public view returns (uint balance) {
191    return balances[_owner];
192  }
193 
194  /// @dev Approve transfer
195  /// @param _spender holder address
196  /// @param _value tokens amount
197  /// @return result
198  function approve(address _spender, uint _value) public returns (bool success) {
199    // To change the approve amount you first have to reduce the addresses`
200    //  allowance to zero by calling `approve(_spender, 0)` if it is not
201    //  already 0 to mitigate the race condition described here:
202    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
204 
205    allowed[msg.sender][_spender] = _value;
206    emit Approval(msg.sender, _spender, _value);
207    return true;
208  }
209 
210  /// @dev Token allowance
211  /// @param _owner holder address
212  /// @param _spender spender address
213  /// @return remain amount
214  function allowance(address _owner, address _spender) public view returns (uint remaining) {
215    return allowed[_owner][_spender];
216  }
217  
218  /// @dev Called when transaction target is a contract
219  /// @param _origin holder origin address
220  /// @param _to address
221  /// @param _value value
222  /// @param _data data
223  /// @return success result
224  function contractFallback(address _origin, address _to, uint _value, bytes memory _data) private returns (bool success) {
225     ERC223Receiver reciever = ERC223Receiver(_to);
226     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
227  }
228   
229  /// @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
230  /// @param _addr address
231  /// @return is_contract result
232  function isContract(address _addr) private returns (bool is_contract) {
233    // retrieve the size of the code on target address, this needs assembly
234     uint length;
235     assembly { length := extcodesize(_addr) }
236     return length > 0;
237  }
238 }