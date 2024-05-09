1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient {
4   function receiveApproval( address from, uint256 value, bytes data ) external;
5 }
6 
7 // ERC223
8 interface ContractReceiver {
9   function tokenFallback( address from, uint value, bytes data ) external;
10 }
11 
12 
13 contract ERC223Token
14 {
15   string  public name;
16   string  public symbol;
17   uint8   public decimals;
18   uint256 public totalSupply;
19 
20   mapping( address => uint256 ) balances_;
21   mapping( address => mapping(address => uint256) ) allowances_;
22 
23   // ERC20
24   event Approval( address indexed owner,
25                   address indexed spender,
26                   uint value );
27 
28   event Transfer( address indexed from,
29                   address indexed to,
30                   uint256 value );
31                // bytes    data ); use ERC20 version instead
32 
33   event Burn( address indexed from, uint256 value );
34 
35   function ERC223Token( uint256 initialSupply,
36                         string tokenName,
37                         uint8 decimalUnits,
38                         string tokenSymbol ) public
39   {
40     totalSupply = initialSupply * 10 ** uint256(decimalUnits);
41     balances_[msg.sender] = totalSupply;
42     name = tokenName;
43     decimals = decimalUnits;
44     symbol = tokenSymbol;
45     emit Transfer( address(0), msg.sender, totalSupply );
46   }
47 
48   function() public payable { revert(); } // does not accept money
49 
50   function balanceOf( address owner ) public constant returns (uint) {
51     return balances_[owner];
52   }
53 
54   // ERC20
55 
56   function approve( address spender, uint256 value ) public
57   returns (bool success)
58   {
59     allowances_[msg.sender][spender] = value;
60     emit Approval( msg.sender, spender, value );
61     return true;
62   }
63  
64   // recommended fix for known attack on any ERC20
65   function safeApprove( address _spender,
66                         uint256 _currentValue,
67                         uint256 _value ) public
68                         returns (bool success) {
69 
70     // If current allowance for _spender is equal to _currentValue, then
71     // overwrite it with _value and return true, otherwise return false.
72 
73     if (allowances_[msg.sender][_spender] == _currentValue)
74       return approve(_spender, _value);
75 
76     return false;
77   }
78 
79   // ERC20
80   function allowance( address owner, address spender ) public constant
81   returns (uint256 remaining)
82   {
83     return allowances_[owner][spender];
84   }
85 
86   // ERC20
87   function transfer(address to, uint256 value) public returns (bool alwaystrue)
88   {
89     bytes memory empty; // null
90     _transfer( msg.sender, to, value, empty );
91     return true;
92   }
93 
94   // ERC20
95   function transferFrom( address from, address to, uint256 value ) public
96   returns (bool success)
97   {
98     require( value <= allowances_[from][msg.sender] );
99 
100     allowances_[from][msg.sender] -= value;
101     bytes memory empty;
102     _transfer( from, to, value, empty );
103 
104     return true;
105   }
106 
107   // Ethereum Token
108   function approveAndCall( address spender,
109                            uint256 value,
110                            bytes context ) public
111   returns (bool success)
112   {
113     if ( approve(spender, value) )
114     {
115       tokenRecipient recip = tokenRecipient( spender );
116       recip.receiveApproval( msg.sender, value, context );
117       return true;
118     }
119     return false;
120   }        
121 
122   // Ethereum Token
123   function burn( uint256 value ) public
124   returns (bool success)
125   {
126     require( balances_[msg.sender] >= value );
127     balances_[msg.sender] -= value;
128     totalSupply -= value;
129 
130     emit Burn( msg.sender, value );
131     return true;
132   }
133 
134   // Ethereum Token
135   function burnFrom( address from, uint256 value ) public
136   returns (bool success)
137   {
138     require( balances_[from] >= value );
139     require( value <= allowances_[from][msg.sender] );
140 
141     balances_[from] -= value;
142     allowances_[from][msg.sender] -= value;
143     totalSupply -= value;
144 
145     emit Burn( from, value );
146     return true;
147   }
148 
149   // ERC223 Transfer and invoke specified callback
150   function transfer( address to,
151                      uint value,
152                      bytes data,
153                      string custom_fallback ) public returns (bool success)
154   {
155     _transfer( msg.sender, to, value, data );
156 
157     if ( isContract(to) )
158     {
159       ContractReceiver rx = ContractReceiver( to );
160       require( address(rx).call.value(0)(bytes4(keccak256(custom_fallback)),
161                msg.sender,
162                value,
163                data) );
164     }
165 
166     return true;
167   }
168 
169   // ERC223 Transfer to a contract or externally-owned account
170   function transfer( address to, uint value, bytes data ) public
171   returns (bool success)
172   {
173     if (isContract(to)) {
174       return transferToContract( to, value, data );
175     }
176 
177     _transfer( msg.sender, to, value, data );
178     return true;
179   }
180 
181   // ERC223 Transfer to contract and invoke tokenFallback() method
182   function transferToContract( address to, uint value, bytes data ) private
183   returns (bool success)
184   {
185     _transfer( msg.sender, to, value, data );
186 
187     ContractReceiver rx = ContractReceiver(to);
188     rx.tokenFallback( msg.sender, value, data );
189 
190     return true;
191   }
192 
193   // ERC223 fetch contract size (must be nonzero to be a contract)
194   function isContract( address _addr ) private constant returns (bool)
195   {
196     uint length;
197     assembly { length := extcodesize(_addr) }
198     return (length > 0);
199   }
200 
201   function _transfer( address from,
202                       address to,
203                       uint value,
204                       bytes data ) internal
205   {
206     require( to != 0x0 );
207     require( balances_[from] >= value );
208     require( balances_[to] + value > balances_[to] ); // catch overflow
209 
210     balances_[from] -= value;
211     balances_[to] += value;
212 
213     //Transfer( from, to, value, data ); ERC223-compat version
214     bytes memory empty;
215     empty = data;
216     emit Transfer( from, to, value ); // ERC20-compat version
217   }
218 }