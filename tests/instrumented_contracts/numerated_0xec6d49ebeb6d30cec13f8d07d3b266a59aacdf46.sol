1 //
2 // compiler: solcjs
3 //  version: 0.4.19+commit.c4cbbb05.Emscripten.clang
4 //
5 pragma solidity ^0.4.19;
6 
7 contract owned {
8   address public owner;
9 
10   function owned() public { owner = msg.sender; }
11 
12   modifier onlyOwner {
13     if (msg.sender != owner) { revert(); }
14     _;
15   }
16 
17   function changeOwner( address newowner ) public onlyOwner {
18     owner = newowner;
19   }
20 }
21 
22 // see https://www.ethereum.org/token
23 interface tokenRecipient {
24   function receiveApproval( address from, uint256 value, bytes data ) public;
25 }
26 
27 // ERC223
28 interface ContractReceiver {
29   function tokenFallback( address from, uint value, bytes data ) public;
30 }
31 
32 // ERC223-compliant token with ERC20 back-compatibility
33 //
34 // Implements:
35 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
36 // - https://www.ethereum.org/token (uncontrolled, non-standard)
37 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
38 
39 contract HashBux is owned
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
63   function HashBux() public
64   {
65     balances_[msg.sender] = uint256(80000000);
66     totalSupply = uint256(80000000);
67     name = "HashBux";
68     decimals = uint8(0);
69     symbol = "HASH";
70   }
71 
72   // HashBux-specific
73   function mine( uint256 newTokens ) public onlyOwner {
74     if (newTokens + totalSupply > 4e9)
75       revert();
76 
77     totalSupply += newTokens;
78     balances_[owner] += newTokens;
79     bytes memory empty;
80     Transfer( address(this), owner, newTokens, empty );
81   }
82 
83   function() public payable { revert(); } // does not accept money
84 
85   // ERC20
86   function balanceOf( address owner ) public constant returns (uint) {
87     return balances_[owner];
88   }
89 
90   // ERC20
91   function approve( address spender, uint256 value ) public
92   returns (bool success)
93   {
94     allowances_[msg.sender][spender] = value;
95     Approval( msg.sender, spender, value );
96     return true;
97   }
98  
99   // ERC20
100   function allowance( address owner, address spender ) public constant
101   returns (uint256 remaining)
102   {
103     return allowances_[owner][spender];
104   }
105 
106   // ERC20
107   function transfer(address to, uint256 value) public
108   {
109     bytes memory empty; // null
110     _transfer( msg.sender, to, value, empty );
111   }
112 
113   // ERC20
114   function transferFrom( address from, address to, uint256 value ) public
115   returns (bool success)
116   {
117     require( value <= allowances_[from][msg.sender] );
118 
119     allowances_[from][msg.sender] -= value;
120     bytes memory empty;
121     _transfer( from, to, value, empty );
122 
123     return true;
124   }
125 
126   // Ethereum Token
127   function approveAndCall( address spender, uint256 value, bytes context )
128   public returns (bool success)
129   {
130     if ( approve(spender, value) )
131     {
132       tokenRecipient recip = tokenRecipient( spender );
133       recip.receiveApproval( msg.sender, value, context );
134       return true;
135     }
136     return false;
137   }        
138 
139   // Ethereum Token
140   function burn( uint256 value ) public returns (bool success)
141   {
142     require( balances_[msg.sender] >= value );
143     balances_[msg.sender] -= value;
144     totalSupply -= value;
145 
146     Burn( msg.sender, value );
147     return true;
148   }
149 
150   // Ethereum Token
151   function burnFrom( address from, uint256 value ) public returns (bool success)
152   {
153     require( balances_[from] >= value );
154     require( value <= allowances_[from][msg.sender] );
155 
156     balances_[from] -= value;
157     allowances_[from][msg.sender] -= value;
158     totalSupply -= value;
159 
160     Burn( from, value );
161     return true;
162   }
163 
164   function _transfer( address from,
165                       address to,
166                       uint value,
167                       bytes data ) internal
168   {
169     require( to != 0x0 );
170     require( balances_[from] >= value );
171     require( balances_[to] + value > balances_[to] ); // catch overflow
172 
173     balances_[from] -= value;
174     balances_[to] += value;
175 
176     Transfer( from, to, value, data );
177   }
178 
179   // ERC223 Transfer and invoke specified callback
180   function transfer( address to,
181                      uint value,
182                      bytes data,
183                      string custom_fallback ) public returns (bool success)
184   {
185     _transfer( msg.sender, to, value, data );
186 
187     if ( isContract(to) )
188     {
189       ContractReceiver rx = ContractReceiver( to );
190       require( rx.call.value(0)
191                (bytes4(keccak256(custom_fallback)), msg.sender, value, data) );
192     }
193 
194     return true;
195   }
196 
197   // ERC223 Transfer to a contract or externally-owned account
198   function transfer( address to, uint value, bytes data ) public
199   returns (bool success)
200   {
201     if (isContract(to)) {
202       return transferToContract( to, value, data );
203     }
204 
205     _transfer( msg.sender, to, value, data );
206     return true;
207   }
208 
209   // ERC223 Transfer to contract and invoke tokenFallback() method
210   function transferToContract( address to, uint value, bytes data ) private
211   returns (bool success)
212   {
213     _transfer( msg.sender, to, value, data );
214 
215     ContractReceiver rx = ContractReceiver(to);
216     rx.tokenFallback( msg.sender, value, data );
217 
218     return true;
219   }
220 
221   // ERC223 fetch contract size (must be nonzero to be a contract)
222   function isContract( address _addr ) private constant returns (bool)
223   {
224     uint length;
225     assembly { length := extcodesize(_addr) }
226     return (length > 0);
227   }
228 }