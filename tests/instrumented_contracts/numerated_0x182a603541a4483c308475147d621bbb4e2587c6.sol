1 pragma solidity ^0.4.16;
2 interface ContractReceiver {
3   function tokenFallback( address from, uint value, bytes data ) external;
4 }
5 
6 interface TokenRecipient {
7   function receiveApproval( address from, uint256 value, bytes data ) external;
8 }
9 
10 interface ERC223TokenBasic {
11     function transfer(address receiver, uint256 amount, bytes data) external;
12     function balanceOf(address owner) external constant returns (uint);    
13     function transferFrom( address from, address to, uint256 value ) external returns (bool success);
14 }
15 contract ZBToken is ERC223TokenBasic
16 {
17   string  public name;
18   string  public symbol;
19   uint8   public decimals;
20   uint256 public totalSupply;
21   address public issuer;
22 
23   mapping( address => uint256 ) balances_;
24   mapping( address => mapping(address => uint256) ) allowances_;
25 
26   // ERC20
27   event Approval( address indexed owner,
28                   address indexed spender,
29                   uint value );
30 
31   event Transfer( address indexed from,
32                   address indexed to,
33                   uint256 value );
34                // bytes    data ); use ERC20 version instead
35 
36   // Ethereum Token
37   event Burn( address indexed from, uint256 value );
38 
39   constructor ( uint256 initialSupply,
40                 string tokenName,
41                 uint8 decimalUnits,
42                 string tokenSymbol ) public
43   {
44     totalSupply = initialSupply * 10 ** uint256(decimalUnits);
45     balances_[msg.sender] = totalSupply;
46     name = tokenName;
47     decimals = decimalUnits;
48     symbol = tokenSymbol;
49     issuer = msg.sender;
50     emit Transfer( address(0), msg.sender, totalSupply );
51   }
52 
53   function() public payable { revert(); } // does not accept ETH
54 
55   // ERC20
56   function balanceOf( address owner ) public constant returns (uint) {
57     return balances_[owner];
58   }
59 
60   // ERC20
61   //
62   // WARNING! When changing the approval amount, first set it back to zero
63   // AND wait until the transaction is mined. Only afterwards set the new
64   // amount. Otherwise you may be prone to a race condition attack.
65   // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66   function approve( address spender, uint256 value ) public
67   returns (bool success)
68   {
69     allowances_[msg.sender][spender] = value;
70     emit Approval( msg.sender, spender, value );
71     return true;
72   }
73 
74   // recommended fix for known attack on any ERC20
75   function safeApprove( address _spender,
76                         uint256 _currentValue,
77                         uint256 _value ) public
78                         returns (bool success) 
79   {
80     // If current allowance for _spender is equal to _currentValue, then
81     // overwrite it with _value and return true, otherwise return false.
82     if (allowances_[msg.sender][_spender] == _currentValue)
83       return approve(_spender, _value);
84 
85     return false;
86   }
87 
88   // ERC20
89   function allowance( address owner, address spender ) public constant
90   returns (uint256 remaining)
91   {
92     return allowances_[owner][spender];
93   }
94 
95   function transfer(address to, uint256 value) public returns (bool success)
96   {
97     bytes memory empty; // null
98     _transfer( msg.sender, to, value, empty );
99     return true;
100   }
101 
102   // ERC20
103   function transferFrom( address from, address to, uint256 value ) public returns (bool success)
104   {
105     require( value <= allowances_[from][msg.sender] );
106 
107     allowances_[from][msg.sender] -= value;
108     bytes memory empty;
109     _transfer( from, to, value, empty );
110 
111     return true;
112   }
113 
114   // Ethereum Token
115   function approveAndCall( address spender,
116                            uint256 value,
117                            bytes context ) public
118   returns (bool success)
119   {
120     if ( approve(spender, value) )
121     {
122       TokenRecipient recip = TokenRecipient( spender );
123       recip.receiveApproval( msg.sender, value, context );
124       return true;
125     }
126     return false;
127   }
128 
129   // Ethereum Token
130   function burn( uint256 value ) public
131   returns (bool success)
132   {
133     require( balances_[msg.sender] >= value );
134     balances_[msg.sender] -= value;
135     totalSupply -= value;
136 
137     emit Burn( msg.sender, value );
138     return true;
139   }
140 
141   // Ethereum Token
142   function burnFrom( address from, uint256 value ) public
143   returns (bool success)
144   {
145     require( balances_[from] >= value );
146     require( value <= allowances_[from][msg.sender] );
147 
148     balances_[from] -= value;
149     allowances_[from][msg.sender] -= value;
150     totalSupply -= value;
151 
152     emit Burn( from, value );
153     return true;
154   }
155 
156   // ERC223 Transfer to a contract or externally-owned account
157   function transfer( address to, uint value, bytes data ) external
158   {
159     if (isContract(to)) {
160       transferToContract( to, value, data );
161     }
162     else
163     {
164       _transfer( msg.sender, to, value, data );
165     }
166   }
167 
168   // ERC223 Transfer and invoke specified callback
169   function transfer( address to,
170                      uint value,
171                      bytes data,
172                      string custom_fallback ) public returns (bool success)
173   {
174     _transfer( msg.sender, to, value, data );
175 
176     if ( isContract(to) )
177     {
178       ContractReceiver rx = ContractReceiver( to );
179       require( address(rx).call.value(0)(bytes4(keccak256(abi.encodePacked(custom_fallback))),
180                msg.sender,
181                value,
182                data) );
183     }
184 
185     return true;
186   }
187 
188   // ERC223 Transfer to contract and invoke tokenFallback() method
189   function transferToContract( address to, uint value, bytes data ) private
190   returns (bool success)
191   {
192     _transfer( msg.sender, to, value, data );
193 
194     ContractReceiver cr = ContractReceiver(to);
195     cr.tokenFallback( msg.sender, value, data );
196 
197     return true;
198   }
199 
200   // ERC223 fetch contract size (must be nonzero to be a contract)
201   function isContract( address _addr ) private constant returns (bool)
202   {
203     uint length;
204     assembly { length := extcodesize(_addr) }
205     return (length > 0);
206   }
207 
208   function _transfer( address from,
209                       address to,
210                       uint value,
211                       bytes data ) internal
212   {
213     require( to != 0x0 );
214     require( balances_[from] >= value );
215     require( balances_[to] + value > balances_[to] ); // catch overflow
216 
217     balances_[from] -= value;
218     balances_[to] += value;
219 
220     //Transfer( from, to, value, data ); ERC223-compat version
221     bytes memory empty;
222     empty = data;
223     emit Transfer( from, to, value ); // ERC20-compat version
224   }
225 }