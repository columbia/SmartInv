1 //
2 // compiler: solcjs -o ./build/contracts --optimize --abi --bin <this file>
3 //  version: 0.4.15+commit.bbb8e64f.Emscripten.clang
4 //
5 pragma solidity ^0.4.15;
6 
7 contract owned {
8   address public owner;
9 
10   function owned() { owner = msg.sender; }
11 
12   modifier onlyOwner {
13     if (msg.sender != owner) { revert(); }
14     _;
15   }
16 
17   function changeOwner( address newowner ) onlyOwner {
18     owner = newowner;
19   }
20 }
21 
22 // see https://www.ethereum.org/token
23 interface tokenRecipient {
24   function receiveApproval( address from, uint256 value, bytes data );
25 }
26 
27 // ERC223
28 interface ContractReceiver {
29   function tokenFallback( address from, uint value, bytes data );
30 }
31 
32 // ERC223-compliant token with ERC20 back-compatibility
33 //
34 // Implements:
35 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
36 // - https://www.ethereum.org/token (uncontrolled, non-standard)
37 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
38 
39 contract JBX is owned
40 {
41   string  public name;        // ERC20
42   string  public symbol;      // ERC20
43   uint8   public decimals;    // ERC20
44   uint256 public totalSupply; // ERC20
45 
46   mapping( address => uint256 ) balances_;
47   mapping( address => mapping(address => uint256) ) allowances_;
48 
49   // ERC20
50   event Approval( address indexed owner,
51                   address indexed spender,
52                   uint value );
53 
54   // ERC223, ERC20 plus last parameter
55   event Transfer( address indexed from,
56                   address indexed to,
57                   uint256 value,
58                   bytes   indexed data );
59 
60   // Ethereum Token
61   event Burn( address indexed from, uint256 value );
62 
63   function JBX()
64   {
65     balances_[msg.sender] = uint256(200000000);
66     totalSupply = uint256(200000000);
67     name = "Jbox";
68     decimals = uint8(0);
69     symbol = "JBX";
70   }
71 
72   // Jbox-specific
73   function mine( uint256 newTokens ) onlyOwner {
74     if (newTokens + totalSupply > 4e9)
75       revert();
76 
77     totalSupply += newTokens;
78     balances_[owner] += newTokens;
79     bytes memory empty;
80     Transfer( address(this), owner, newTokens, empty );
81   }
82 
83   function() payable { revert(); } // does not accept money
84 
85   // ERC20
86   function balanceOf( address owner ) constant returns (uint) {
87     return balances_[owner];
88   }
89 
90   // ERC20
91   function approve( address spender, uint256 value ) returns (bool success)
92   {
93     allowances_[msg.sender][spender] = value;
94     Approval( msg.sender, spender, value );
95     return true;
96   }
97  
98   // ERC20
99   function allowance( address owner, address spender ) constant
100   returns (uint256 remaining)
101   {
102     return allowances_[owner][spender];
103   }
104 
105   // ERC20
106   function transfer(address to, uint256 value)
107   {
108     bytes memory empty; // null
109     _transfer( msg.sender, to, value, empty );
110   }
111 
112   // ERC20
113   function transferFrom( address from, address to, uint256 value )
114   returns (bool success)
115   {
116     require( value <= allowances_[from][msg.sender] );
117 
118     allowances_[from][msg.sender] -= value;
119     bytes memory empty;
120     _transfer( from, to, value, empty );
121 
122     return true;
123   }
124 
125   // Ethereum Token
126   function approveAndCall( address spender, uint256 value, bytes context )
127   returns (bool success)
128   {
129     if ( approve(spender, value) )
130     {
131       tokenRecipient recip = tokenRecipient( spender );
132       recip.receiveApproval( msg.sender, value, context );
133       return true;
134     }
135     return false;
136   }        
137 
138   // Ethereum Token
139   function burn( uint256 value ) returns (bool success)
140   {
141     require( balances_[msg.sender] >= value );
142     balances_[msg.sender] -= value;
143     totalSupply -= value;
144 
145     Burn( msg.sender, value );
146     return true;
147   }
148 
149   // Ethereum Token
150   function burnFrom( address from, uint256 value ) returns (bool success)
151   {
152     require( balances_[from] >= value );
153     require( value <= allowances_[from][msg.sender] );
154 
155     balances_[from] -= value;
156     allowances_[from][msg.sender] -= value;
157     totalSupply -= value;
158 
159     Burn( from, value );
160     return true;
161   }
162 
163   function _transfer( address from,
164                       address to,
165                       uint value,
166                       bytes data ) internal
167   {
168     require( to != 0x0 );
169     require( balances_[from] >= value );
170     require( balances_[to] + value > balances_[to] ); // catch overflow
171 
172     balances_[from] -= value;
173     balances_[to] += value;
174 
175     Transfer( from, to, value, data );
176   }
177 
178   // ERC223 Transfer and invoke specified callback
179   function transfer( address to,
180                      uint value,
181                      bytes data,
182                      string custom_fallback ) returns (bool success)
183   {
184     _transfer( msg.sender, to, value, data );
185 
186     if ( isContract(to) )
187     {
188       ContractReceiver rx = ContractReceiver( to );
189       require( rx.call.value(0)
190                   (bytes4(sha3(custom_fallback)), msg.sender, value, data) );
191     }
192 
193     return true;
194   }
195 
196   // ERC223 Transfer to a contract or externally-owned account
197   function transfer( address to, uint value, bytes data ) returns (bool success)
198   {
199     if (isContract(to)) {
200       return transferToContract( to, value, data );
201     }
202 
203     _transfer( msg.sender, to, value, data );
204     return true;
205   }
206 
207   // ERC223 Transfer to contract and invoke tokenFallback() method
208   function transferToContract( address to, uint value, bytes data ) private
209   returns (bool success)
210   {
211     _transfer( msg.sender, to, value, data );
212 
213     ContractReceiver rx = ContractReceiver(to);
214     rx.tokenFallback( msg.sender, value, data );
215 
216     return true;
217   }
218 
219   // ERC223 fetch contract size (must be nonzero to be a contract)
220   function isContract( address _addr ) private returns (bool)
221   {
222     uint length;
223     assembly { length := extcodesize(_addr) }
224     return (length > 0);
225   }
226 }