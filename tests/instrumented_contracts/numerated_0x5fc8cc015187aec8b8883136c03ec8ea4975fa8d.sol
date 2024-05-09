1 pragma solidity ^0.4.18;
2 
3 // https://www.ethereum.org/token
4 interface tokenRecipient {
5   function receiveApproval( address from, uint256 value, bytes data ) public;
6 }
7 
8 // ERC223
9 interface ContractReceiver {
10   function tokenFallback( address from, uint value, bytes data ) public;
11 }
12 
13 // ERC20 token with added ERC223 and Ethereum-Token support
14 //
15 // Blend of multiple interfaces:
16 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
17 // - https://www.ethereum.org/token (uncontrolled, non-standard)
18 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
19 
20 contract ERC223Token
21 {
22   string  public name;        // ERC20
23   string  public symbol;      // ERC20
24   uint8   public decimals;    // ERC20
25   uint256 public totalSupply; // ERC20
26 
27   mapping( address => uint256 ) balances_;
28   mapping( address => mapping(address => uint256) ) allowances_;
29 
30   // ERC20
31   event Approval( address indexed owner,
32                   address indexed spender,
33                   uint value );
34 
35   // ERC223, ERC20-compatible
36   event Transfer( address indexed from,
37                   address indexed to,
38                   uint256 value,
39                   bytes    data );
40 
41   // Ethereum Token
42   event Burn( address indexed from, uint256 value );
43 
44   function ERC223Token( uint256 initialSupply,
45                         string tokenName,
46                         uint8 decimalUnits,
47                         string tokenSymbol ) public
48   {
49     balances_[msg.sender] = initialSupply;
50     totalSupply = initialSupply;
51     name = tokenName;
52     decimals = decimalUnits;
53     symbol = tokenSymbol;
54   }
55 
56   function() public payable { revert(); } // does not accept money
57 
58   // ERC20
59   function balanceOf( address owner ) public constant returns (uint) {
60     return balances_[owner];
61   }
62 
63   // ERC20
64   function approve( address spender, uint256 value ) public
65   returns (bool success)
66   {
67     allowances_[msg.sender][spender] = value;
68     Approval( msg.sender, spender, value );
69     return true;
70   }
71  
72   // ERC20
73   function allowance( address owner, address spender ) public constant
74   returns (uint256 remaining)
75   {
76     return allowances_[owner][spender];
77   }
78 
79   // ERC20
80   function transfer(address to, uint256 value) public
81   {
82     bytes memory empty; // null
83     _transfer( msg.sender, to, value, empty );
84   }
85 
86   // ERC20
87   function transferFrom( address from, address to, uint256 value ) public
88   returns (bool success)
89   {
90     require( value <= allowances_[from][msg.sender] );
91 
92     allowances_[from][msg.sender] -= value;
93     bytes memory empty;
94     _transfer( from, to, value, empty );
95 
96     return true;
97   }
98 
99   // Ethereum Token
100   function approveAndCall( address spender,
101                            uint256 value,
102                            bytes context ) public
103   returns (bool success)
104   {
105     if ( approve(spender, value) )
106     {
107       tokenRecipient recip = tokenRecipient( spender );
108       recip.receiveApproval( msg.sender, value, context );
109       return true;
110     }
111     return false;
112   }        
113 
114   // Ethereum Token
115   function burn( uint256 value ) public
116   returns (bool success)
117   {
118     require( balances_[msg.sender] >= value );
119     balances_[msg.sender] -= value;
120     totalSupply -= value;
121 
122     Burn( msg.sender, value );
123     return true;
124   }
125 
126   // Ethereum Token
127   function burnFrom( address from, uint256 value ) public
128   returns (bool success)
129   {
130     require( balances_[from] >= value );
131     require( value <= allowances_[from][msg.sender] );
132 
133     balances_[from] -= value;
134     allowances_[from][msg.sender] -= value;
135     totalSupply -= value;
136 
137     Burn( from, value );
138     return true;
139   }
140 
141   // ERC223 Transfer and invoke specified callback
142   function transfer( address to,
143                      uint value,
144                      bytes data,
145                      string custom_fallback ) public returns (bool success)
146   {
147     _transfer( msg.sender, to, value, data );
148 
149     if ( isContract(to) )
150     {
151       ContractReceiver rx = ContractReceiver( to );
152       require( rx.call.value(0)(bytes4(keccak256(custom_fallback)),
153                msg.sender,
154                value,
155                data) );
156     }
157 
158     return true;
159   }
160 
161   // ERC223 Transfer to a contract or externally-owned account
162   function transfer( address to, uint value, bytes data ) public
163   returns (bool success)
164   {
165     if (isContract(to)) {
166       return transferToContract( to, value, data );
167     }
168 
169     _transfer( msg.sender, to, value, data );
170     return true;
171   }
172 
173   // ERC223 Transfer to contract and invoke tokenFallback() method
174   function transferToContract( address to, uint value, bytes data ) private
175   returns (bool success)
176   {
177     _transfer( msg.sender, to, value, data );
178 
179     ContractReceiver rx = ContractReceiver(to);
180     rx.tokenFallback( msg.sender, value, data );
181 
182     return true;
183   }
184 
185   // ERC223 fetch contract size (must be nonzero to be a contract)
186   function isContract( address _addr ) private constant returns (bool)
187   {
188     uint length;
189     assembly { length := extcodesize(_addr) }
190     return (length > 0);
191   }
192 
193   function _transfer( address from,
194                       address to,
195                       uint value,
196                       bytes data ) internal
197   {
198     require( to != 0x0 );
199     require( balances_[from] >= value );
200     require( balances_[to] + value > balances_[to] ); // catch overflow
201 
202     balances_[from] -= value;
203     balances_[to] += value;
204 
205     Transfer( from, to, value, data );
206   }
207 }