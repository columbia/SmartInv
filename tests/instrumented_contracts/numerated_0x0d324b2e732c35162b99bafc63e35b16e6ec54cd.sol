1 // compiler: 0.4.21+commit.dfe3193c.Emscripten.clang
2 pragma solidity ^0.4.21;
3 
4 // https://www.ethereum.org/token
5 interface tokenRecipient {
6   function receiveApproval( address from, uint256 value, bytes data ) external;
7 }
8 
9 // ERC223
10 interface ContractReceiver {
11   function tokenFallback( address from, uint value, bytes data ) external;
12 }
13 
14 // ERC20 token with added ERC223 and Ethereum-Token support
15 //
16 // Blend of multiple interfaces:
17 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
18 // - https://www.ethereum.org/token (uncontrolled, non-standard)
19 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
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
44   function ERC223Token( uint256 initialSupply,
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
102   function transfer(address to, uint256 value) public
103   {
104     bytes memory empty; // null
105     _transfer( msg.sender, to, value, empty );
106   }
107 
108   // ERC20
109   function transferFrom( address from, address to, uint256 value ) public
110   returns (bool success)
111   {
112     require( value <= allowances_[from][msg.sender] );
113 
114     allowances_[from][msg.sender] -= value;
115     bytes memory empty;
116     _transfer( from, to, value, empty );
117 
118     return true;
119   }
120 
121   // Ethereum Token
122   function approveAndCall( address spender,
123                            uint256 value,
124                            bytes context ) public
125   returns (bool success)
126   {
127     if ( approve(spender, value) )
128     {
129       tokenRecipient recip = tokenRecipient( spender );
130       recip.receiveApproval( msg.sender, value, context );
131       return true;
132     }
133     return false;
134   }        
135 
136   // Ethereum Token
137   function burn( uint256 value ) public
138   returns (bool success)
139   {
140     require( balances_[msg.sender] >= value );
141     balances_[msg.sender] -= value;
142     totalSupply -= value;
143 
144     emit Burn( msg.sender, value );
145     return true;
146   }
147 
148   // Ethereum Token
149   function burnFrom( address from, uint256 value ) public
150   returns (bool success)
151   {
152     require( balances_[from] >= value );
153     require( value <= allowances_[from][msg.sender] );
154 
155     balances_[from] -= value;
156     allowances_[from][msg.sender] -= value;
157     totalSupply -= value;
158 
159     emit Burn( from, value );
160     return true;
161   }
162 
163   // ERC223 Transfer and invoke specified callback
164   function transfer( address to,
165                      uint value,
166                      bytes data,
167                      string custom_fallback ) public returns (bool success)
168   {
169     _transfer( msg.sender, to, value, data );
170 
171     if ( isContract(to) )
172     {
173       ContractReceiver rx = ContractReceiver( to );
174       require( address(rx).call.value(0)(bytes4(keccak256(custom_fallback)),
175                msg.sender,
176                value,
177                data) );
178     }
179 
180     return true;
181   }
182 
183   // ERC223 Transfer to a contract or externally-owned account
184   function transfer( address to, uint value, bytes data ) public
185   returns (bool success)
186   {
187     if (isContract(to)) {
188       return transferToContract( to, value, data );
189     }
190 
191     _transfer( msg.sender, to, value, data );
192     return true;
193   }
194 
195   // ERC223 Transfer to contract and invoke tokenFallback() method
196   function transferToContract( address to, uint value, bytes data ) private
197   returns (bool success)
198   {
199     _transfer( msg.sender, to, value, data );
200 
201     ContractReceiver rx = ContractReceiver(to);
202     rx.tokenFallback( msg.sender, value, data );
203 
204     return true;
205   }
206 
207   // ERC223 fetch contract size (must be nonzero to be a contract)
208   function isContract( address _addr ) private constant returns (bool)
209   {
210     uint length;
211     assembly { length := extcodesize(_addr) }
212     return (length > 0);
213   }
214 
215   function _transfer( address from,
216                       address to,
217                       uint value,
218                       bytes data ) internal
219   {
220     require( to != 0x0 );
221     require( balances_[from] >= value );
222     require( balances_[to] + value > balances_[to] ); // catch overflow
223 
224     balances_[from] -= value;
225     balances_[to] += value;
226 
227     //Transfer( from, to, value, data ); ERC223-compat version
228     bytes memory empty;
229     empty = data;
230     emit Transfer( from, to, value ); // ERC20-compat version
231   }
232 }