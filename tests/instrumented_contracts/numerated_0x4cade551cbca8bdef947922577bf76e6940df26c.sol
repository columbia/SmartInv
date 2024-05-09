1 // compiler: 0.4.21+commit.dfe3193c.Emscripten.clang
2 pragma solidity ^0.4.21;
3 
4 // https://www.ethereum.org/token
5 interface tokenRecipient {
6   function receiveApproval( address from, uint256 value, bytes data ) external;
7 }
8 
9 // ERC223 - LLT Luxury Lifestyle Token Intel-wise Edition - RS
10 // ERC20 token with added ERC223 and Ethereum-Token support
11 
12 // Combination of multiple interfaces:
13 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
14 // https://www.ethereum.org/token (uncontrolled, non-standard)
15 // https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
16 
17 interface ContractReceiver {
18   function tokenFallback( address from, uint value, bytes data ) external;
19 }
20 
21 contract ERC223Token
22 {
23   string  public name;
24   string  public symbol;
25   uint8   public decimals;
26   uint256 public totalSupply;
27 
28   mapping( address => uint256 ) balances_;
29   mapping( address => mapping(address => uint256) ) allowances_;
30 
31   // ERC20
32   event Approval( address indexed owner,
33                   address indexed spender,
34                   uint value );
35 
36   event Transfer( address indexed from,
37                   address indexed to,
38                   uint256 value );
39                // bytes    data ); use ERC20 version instead
40 
41   // Ethereum Token
42   event Burn( address indexed from, uint256 value );
43 
44   constructor( uint256 initialSupply,
45                         string tokenName,
46                         uint8 decimalUnits,
47                         string tokenSymbol ) public
48   {
49     totalSupply = initialSupply * 10 ** uint256(decimalUnits);
50     balances_[msg.sender] = totalSupply;
51     name = tokenName;
52     decimals = decimalUnits;
53     symbol = tokenSymbol;
54     emit Transfer( address(0), msg.sender, totalSupply );
55   }
56 
57   function() public payable { revert(); } // does not accept money
58 
59   // ERC20
60   function balanceOf( address owner ) public constant returns (uint) {
61     return balances_[owner];
62   }
63 
64   // ERC20
65   //
66   // WARNING! When changing the approval amount, first set it back to zero
67   // AND wait until the transaction is mined. Only afterwards set the new
68   // amount. Otherwise you may be prone to a race condition attack.
69   // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70 
71   function approve( address spender, uint256 value ) public
72   returns (bool success)
73   {
74     allowances_[msg.sender][spender] = value;
75     emit Approval( msg.sender, spender, value );
76     return true;
77   }
78  
79   // recommended fix for known attack on any ERC20
80   function safeApprove( address _spender,
81                         uint256 _currentValue,
82                         uint256 _value ) public
83                         returns (bool success) {
84 
85     // If current allowance for _spender is equal to _currentValue, then
86     // overwrite it with _value and return true, otherwise return false.
87 
88     if (allowances_[msg.sender][_spender] == _currentValue)
89       return approve(_spender, _value);
90 
91     return false;
92   }
93 
94   // ERC20
95   function allowance( address owner, address spender ) public constant
96   returns (uint256 remaining)
97   {
98     return allowances_[owner][spender];
99   }
100 
101   // ERC20
102   function transfer(address to, uint256 value) public returns (bool success)
103   {
104     bytes memory empty; // null
105     _transfer( msg.sender, to, value, empty );
106     return true;
107   }
108 
109   // ERC20
110   function transferFrom( address from, address to, uint256 value ) public
111   returns (bool success)
112   {
113     require( value <= allowances_[from][msg.sender] );
114 
115     allowances_[from][msg.sender] -= value;
116     bytes memory empty;
117     _transfer( from, to, value, empty );
118 
119     return true;
120   }
121 
122   // Ethereum Token Definition
123   function approveAndCall( address spender,
124                            uint256 value,
125                            bytes context ) public
126   returns (bool success)
127   {
128     if ( approve(spender, value) )
129     {
130       tokenRecipient recip = tokenRecipient( spender );
131       recip.receiveApproval( msg.sender, value, context );
132       return true;
133     }
134     return false;
135   }        
136 
137   // Ethereum Token
138   function burn( uint256 value ) public
139   returns (bool success)
140   {
141     require( balances_[msg.sender] >= value );
142     balances_[msg.sender] -= value;
143     totalSupply -= value;
144 
145     emit Burn( msg.sender, value );
146     return true;
147   }
148 
149   // Ethereum Token
150   function burnFrom( address from, uint256 value ) public
151   returns (bool success)
152   {
153     require( balances_[from] >= value );
154     require( value <= allowances_[from][msg.sender] );
155 
156     balances_[from] -= value;
157     allowances_[from][msg.sender] -= value;
158     totalSupply -= value;
159 
160     emit Burn( from, value );
161     return true;
162   }
163 
164   // ERC223 Transfer and invoke specified callback
165   function transfer( address to,
166                      uint value,
167                      bytes data,
168                      string custom_fallback ) public returns (bool success)
169   {
170     _transfer( msg.sender, to, value, data );
171 
172     if ( isContract(to) )
173     {
174       ContractReceiver rx = ContractReceiver( to );
175       require( address(rx).call.value(0)(bytes4(keccak256(abi.encodePacked(custom_fallback))),
176                msg.sender,
177                value,
178                data) );
179     }
180 
181     return true;
182   }
183 
184   // ERC223 Transfer to a contract or externally-owned account
185   function transfer( address to, uint value, bytes data ) public
186   returns (bool success)
187   {
188     if (isContract(to)) {
189       return transferToContract( to, value, data );
190     }
191 
192     _transfer( msg.sender, to, value, data );
193     return true;
194   }
195 
196   // ERC223 Transfer to contract and invoke tokenFallback() method
197   function transferToContract( address to, uint value, bytes data ) private
198   returns (bool success)
199   {
200     _transfer( msg.sender, to, value, data );
201 
202     ContractReceiver rx = ContractReceiver(to);
203     rx.tokenFallback( msg.sender, value, data );
204 
205     return true;
206   }
207 
208   // ERC223 Fetch contract size (This must be non-zero to be a contract)
209   function isContract( address _addr ) private constant returns (bool)
210   {
211     uint length;
212     assembly { length := extcodesize(_addr) }
213     return (length > 0);
214   }
215 
216   function _transfer( address from,
217                       address to,
218                       uint value,
219                       bytes data ) internal
220   {
221     require( to != 0x0 );
222     require( balances_[from] >= value );
223     require( balances_[to] + value > balances_[to] ); // catch overflow
224 
225     balances_[from] -= value;
226     balances_[to] += value;
227 
228     //Transfer( from, to, value, data ); This is the ERC223 compatible version
229     bytes memory empty;
230     empty = data;
231     emit Transfer( from, to, value ); // This is the ERC20 compatible version
232   }
233 }