1 // compiler: 0.4.19+commit.c4cbbb05.Emscripten.clang
2 pragma solidity ^0.4.19;
3 
4 // https://www.ethereum.org/token
5 interface tokenRecipient {
6   function receiveApproval( address from, uint256 value, bytes data ) public;
7 }
8 
9 // ERC223
10 interface ContractReceiver {
11   function tokenFallback( address from, uint value, bytes data ) public;
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
23   string  public name;        // ERC20
24   string  public symbol;      // ERC20
25   uint8   public decimals;    // ERC20
26   uint256 public totalSupply; // ERC20
27 
28   mapping( address => uint256 ) balances_;
29   mapping( address => mapping(address => uint256) ) allowances_;
30 
31   // ERC20
32   event Approval( address indexed owner,
33                   address indexed spender,
34                   uint value );
35 
36   // ERC223, ERC20-compatible
37   event Transfer( address indexed from,
38                   address indexed to,
39                   uint256 value,
40                   bytes    data );
41 
42   // Ethereum Token
43   event Burn( address indexed from, uint256 value );
44 
45   function ERC223Token( uint256 initialSupply,
46                         string tokenName,
47                         uint8 decimalUnits,
48                         string tokenSymbol ) public
49   {
50     totalSupply = initialSupply * 10 ** uint256(decimalUnits);
51     balances_[msg.sender] = totalSupply;
52     name = tokenName;
53     decimals = decimalUnits;
54     symbol = tokenSymbol;
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
65   function approve( address spender, uint256 value ) public
66   returns (bool success)
67   {
68     allowances_[msg.sender][spender] = value;
69     Approval( msg.sender, spender, value );
70     return true;
71   }
72  
73   // ERC20
74   function allowance( address owner, address spender ) public constant
75   returns (uint256 remaining)
76   {
77     return allowances_[owner][spender];
78   }
79 
80   // ERC20
81   function transfer(address to, uint256 value) public
82   {
83     bytes memory empty; // null
84     _transfer( msg.sender, to, value, empty );
85   }
86 
87   // ERC20
88   function transferFrom( address from, address to, uint256 value ) public
89   returns (bool success)
90   {
91     require( value <= allowances_[from][msg.sender] );
92 
93     allowances_[from][msg.sender] -= value;
94     bytes memory empty;
95     _transfer( from, to, value, empty );
96 
97     return true;
98   }
99 
100   // Ethereum Token
101   function approveAndCall( address spender,
102                            uint256 value,
103                            bytes context ) public
104   returns (bool success)
105   {
106     if ( approve(spender, value) )
107     {
108       tokenRecipient recip = tokenRecipient( spender );
109       recip.receiveApproval( msg.sender, value, context );
110       return true;
111     }
112     return false;
113   }        
114 
115   // Ethereum Token
116   function burn( uint256 value ) public
117   returns (bool success)
118   {
119     require( balances_[msg.sender] >= value );
120     balances_[msg.sender] -= value;
121     totalSupply -= value;
122 
123     Burn( msg.sender, value );
124     return true;
125   }
126 
127   // Ethereum Token
128   function burnFrom( address from, uint256 value ) public
129   returns (bool success)
130   {
131     require( balances_[from] >= value );
132     require( value <= allowances_[from][msg.sender] );
133 
134     balances_[from] -= value;
135     allowances_[from][msg.sender] -= value;
136     totalSupply -= value;
137 
138     Burn( from, value );
139     return true;
140   }
141 
142   // ERC223 Transfer and invoke specified callback
143   function transfer( address to,
144                      uint value,
145                      bytes data,
146                      string custom_fallback ) public returns (bool success)
147   {
148     _transfer( msg.sender, to, value, data );
149 
150     if ( isContract(to) )
151     {
152       ContractReceiver rx = ContractReceiver( to );
153       require( rx.call.value(0)(bytes4(keccak256(custom_fallback)),
154                msg.sender,
155                value,
156                data) );
157     }
158 
159     return true;
160   }
161 
162   // ERC223 Transfer to a contract or externally-owned account
163   function transfer( address to, uint value, bytes data ) public
164   returns (bool success)
165   {
166     if (isContract(to)) {
167       return transferToContract( to, value, data );
168     }
169 
170     _transfer( msg.sender, to, value, data );
171     return true;
172   }
173 
174   // ERC223 Transfer to contract and invoke tokenFallback() method
175   function transferToContract( address to, uint value, bytes data ) private
176   returns (bool success)
177   {
178     _transfer( msg.sender, to, value, data );
179 
180     ContractReceiver rx = ContractReceiver(to);
181     rx.tokenFallback( msg.sender, value, data );
182 
183     return true;
184   }
185 
186   // ERC223 fetch contract size (must be nonzero to be a contract)
187   function isContract( address _addr ) private constant returns (bool)
188   {
189     uint length;
190     assembly { length := extcodesize(_addr) }
191     return (length > 0);
192   }
193 
194   function _transfer( address from,
195                       address to,
196                       uint value,
197                       bytes data ) internal
198   {
199     require( to != 0x0 );
200     require( balances_[from] >= value );
201     require( balances_[to] + value > balances_[to] ); // catch overflow
202 
203     balances_[from] -= value;
204     balances_[to] += value;
205 
206     Transfer( from, to, value, data );
207   }
208 }