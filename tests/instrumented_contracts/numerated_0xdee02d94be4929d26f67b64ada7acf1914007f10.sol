1 // compiler: 0.4.21+commit.dfe3193c.Emscripten.clang
2 pragma solidity ^0.4.21;
3 
4 // ERC20 Token with ERC223 Token compatibility
5 // SafeMath from OpenZeppelin Standard
6 // Added burn functions from Ethereum Token 
7 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
8 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
9 // - https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
10 // - https://www.ethereum.org/token (uncontrolled, non-standard)
11 
12 
13 // ERC223
14 interface ContractReceiver {
15   function tokenFallback( address from, uint value, bytes data ) external;
16 }
17 
18 // SafeMath
19 contract SafeMath {
20 
21     function safeSub(uint a, uint b) internal pure returns (uint) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint a, uint b) internal pure returns (uint) {
27         uint c = a + b;
28         assert(c >= a);
29         return c;
30     }
31     
32     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a >= b ? a : b;
34     }
35 
36     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
37         return a < b ? a : b;
38     }
39 
40     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a >= b ? a : b;
42     }
43 
44     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a < b ? a : b;
46 }
47 }
48 
49 
50 contract RUNEToken is SafeMath
51 {
52     
53     // Rune Characteristics
54   string  public name = "Rune";
55   string  public symbol  = "RUNE";
56   uint256   public decimals  = 18;
57   uint256 public totalSupply  = 1000000000 * (10 ** decimals);
58 
59     // Mapping
60   mapping( address => uint256 ) balances_;
61   mapping( address => mapping(address => uint256) ) allowances_;
62   
63   // Minting event
64   function RUNEToken() public {
65         balances_[msg.sender] = totalSupply;
66             emit Transfer( address(0), msg.sender, totalSupply );
67     }
68 
69   function() public payable { revert(); } // does not accept money
70   
71   // ERC20
72   event Approval( address indexed owner,
73                   address indexed spender,
74                   uint value );
75 
76   event Transfer( address indexed from,
77                   address indexed to,
78                   uint256 value );
79 
80 
81   // ERC20
82   function balanceOf( address owner ) public constant returns (uint) {
83     return balances_[owner];
84   }
85 
86   // ERC20
87   function approve( address spender, uint256 value ) public
88   returns (bool success)
89   {
90     allowances_[msg.sender][spender] = value;
91     emit Approval( msg.sender, spender, value );
92     return true;
93   }
94  
95   // recommended fix for known attack on any ERC20
96   function safeApprove( address _spender,
97                         uint256 _currentValue,
98                         uint256 _value ) public
99                         returns (bool success) {
100 
101     // If current allowance for _spender is equal to _currentValue, then
102     // overwrite it with _value and return true, otherwise return false.
103 
104     if (allowances_[msg.sender][_spender] == _currentValue)
105       return approve(_spender, _value);
106 
107     return false;
108   }
109 
110   // ERC20
111   function allowance( address owner, address spender ) public constant
112   returns (uint256 remaining)
113   {
114     return allowances_[owner][spender];
115   }
116 
117   // ERC20
118   function transfer(address to, uint256 value) public returns (bool success)
119   {
120     bytes memory empty; // null
121     _transfer( msg.sender, to, value, empty );
122     return true;
123   }
124 
125   // ERC20
126   function transferFrom( address from, address to, uint256 value ) public
127   returns (bool success)
128   {
129     require( value <= allowances_[from][msg.sender] );
130 
131     allowances_[from][msg.sender] -= value;
132     bytes memory empty;
133     _transfer( from, to, value, empty );
134 
135     return true;
136   }
137 
138   // ERC223 Transfer and invoke specified callback
139   function transfer( address to,
140                      uint value,
141                      bytes data,
142                      string custom_fallback ) public returns (bool success)
143   {
144     _transfer( msg.sender, to, value, data );
145 
146     if ( isContract(to) )
147     {
148       ContractReceiver rx = ContractReceiver( to );
149       require( address(rx).call.value(0)(bytes4(keccak256(custom_fallback)),
150                msg.sender,
151                value,
152                data) );
153     }
154 
155     return true;
156   }
157 
158   // ERC223 Transfer to a contract or externally-owned account
159   function transfer( address to, uint value, bytes data ) public
160   returns (bool success)
161   {
162     if (isContract(to)) {
163       return transferToContract( to, value, data );
164     }
165 
166     _transfer( msg.sender, to, value, data );
167     return true;
168   }
169 
170   // ERC223 Transfer to contract and invoke tokenFallback() method
171   function transferToContract( address to, uint value, bytes data ) private
172   returns (bool success)
173   {
174     _transfer( msg.sender, to, value, data );
175 
176     ContractReceiver rx = ContractReceiver(to);
177     rx.tokenFallback( msg.sender, value, data );
178 
179     return true;
180   }
181 
182   // ERC223 fetch contract size (must be nonzero to be a contract)
183   function isContract( address _addr ) private constant returns (bool)
184   {
185     uint length;
186     assembly { length := extcodesize(_addr) }
187     return (length > 0);
188   }
189 
190   function _transfer( address from,
191                       address to,
192                       uint value,
193                       bytes data ) internal
194   {
195     require( to != 0x0 );
196     require( balances_[from] >= value );
197     require( balances_[to] + value > balances_[to] ); // catch overflow
198 
199     balances_[from] -= value;
200     balances_[to] += value;
201 
202     //Transfer( from, to, value, data ); ERC223-compat version
203     bytes memory empty;
204     empty = data;
205     emit Transfer( from, to, value ); // ERC20-compat version
206   }
207   
208   
209     // Ethereum Token
210   event Burn( address indexed from, uint256 value );
211   
212     // Ethereum Token
213   function burn( uint256 value ) public
214   returns (bool success)
215   {
216     require( balances_[msg.sender] >= value );
217     balances_[msg.sender] -= value;
218     totalSupply -= value;
219 
220     emit Burn( msg.sender, value );
221     return true;
222   }
223 
224   // Ethereum Token
225   function burnFrom( address from, uint256 value ) public
226   returns (bool success)
227   {
228     require( balances_[from] >= value );
229     require( value <= allowances_[from][msg.sender] );
230 
231     balances_[from] -= value;
232     allowances_[from][msg.sender] -= value;
233     totalSupply -= value;
234 
235     emit Burn( from, value );
236     return true;
237   }
238   
239   
240 }