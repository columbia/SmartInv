1 // 0.4.20+commit.3155dd80.Emscripten.clang
2 pragma solidity ^0.4.20;
3 
4 // Ethereum Token callback
5 interface tokenRecipient {
6   function receiveApproval( address from, uint256 value, bytes data ) external;
7 }
8 
9 // ERC223 callback
10 interface ContractReceiver {
11   function tokenFallback( address from, uint value, bytes data ) external;
12 }
13 
14 contract owned {
15   address public owner;
16 
17   function owned() public {
18     owner = msg.sender;
19   }
20 
21   function changeOwner( address _miner ) public onlyOwner {
22     owner = _miner;
23   }
24 
25   modifier onlyOwner {
26     require (msg.sender == owner);
27     _;
28   }
29 }
30 
31 // ERC20 token with added ERC223 and Ethereum-Token support
32 //
33 // Blend of multiple interfaces:
34 // - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
35 // - https://www.ethereum.org/token (uncontrolled, non-standard)
36 // - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
37 
38 contract MineableToken is owned {
39 
40   string  public name;
41   string  public symbol;
42   uint8   public decimals;
43   uint256 public totalSupply;
44   uint256 public supplyCap;
45 
46   mapping( address => uint256 ) balances_;
47   mapping( address => mapping(address => uint256) ) allowances_;
48 
49   // ERC20
50   event Approval( address indexed owner,
51                   address indexed spender,
52                   uint value );
53 
54   // ERC20-compatible version only, breaks ERC223 compliance but block
55   // explorers and exchanges expect ERC20. Also, cannot overload events
56 
57   event Transfer( address indexed from,
58                   address indexed to,
59                   uint256 value );
60                   //bytes    data );
61 
62   // Ethereum Token
63   event Burn( address indexed from,
64               uint256 value );
65 
66   function MineableToken() public {
67     decimals = uint8(18);
68     supplyCap = 4 * 1e9 * 10**uint256(decimals);
69     name = "Jbox";
70     symbol = "JBX";
71   }
72 
73   function mine( uint256 qty ) public onlyOwner {
74 
75     require (    (totalSupply + qty) > totalSupply
76               && (totalSupply + qty) <= supplyCap
77             );
78 
79     totalSupply += qty;
80     balances_[owner] += qty;
81     Transfer( address(0), owner, qty );
82   }
83 
84   function cap() public constant returns(uint256) {
85     return supplyCap;
86   }
87 
88   // ERC20
89   function balanceOf( address owner ) public constant returns (uint) {
90     return balances_[owner];
91   }
92 
93   // ERC20
94   function approve( address spender, uint256 value ) public
95   returns (bool success)
96   {
97     // WARNING! When changing the approval amount, first set it back to zero
98     // AND wait until the transaction is mined. Only afterwards set the new
99     // amount. Otherwise you may be prone to a race condition attack.
100     // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101 
102     allowances_[msg.sender][spender] = value;
103     Approval( msg.sender, spender, value );
104     return true;
105   }
106  
107   // recommended fix for known attack on any ERC20
108   function safeApprove( address _spender,
109                         uint256 _currentValue,
110                         uint256 _value ) public
111   returns (bool success)
112   {
113     // If current allowance for _spender is equal to _currentValue, then
114     // overwrite it with _value and return true, otherwise return false.
115 
116     if (allowances_[msg.sender][_spender] == _currentValue)
117       return approve(_spender, _value);
118 
119     return false;
120   }
121 
122   // ERC20
123   function allowance( address owner, address spender ) public constant
124   returns (uint256 remaining)
125   {
126     return allowances_[owner][spender];
127   }
128 
129   // ERC20
130   function transfer(address to, uint256 value) public
131   returns (bool success)
132   {
133     bytes memory empty; // null
134     _transfer( msg.sender, to, value, empty );
135     return true;
136   }
137 
138   // ERC20
139   function transferFrom( address from, address to, uint256 value ) public
140   returns (bool success)
141   {
142     require( value <= allowances_[from][msg.sender] );
143 
144     allowances_[from][msg.sender] -= value;
145     bytes memory empty;
146     _transfer( from, to, value, empty );
147 
148     return true;
149   }
150 
151   // Ethereum Token
152   function approveAndCall( address spender,
153                            uint256 value,
154                            bytes context ) public
155   returns (bool success)
156   {
157     if ( approve(spender, value) )
158     {
159       tokenRecipient recip = tokenRecipient( spender );
160 
161       if (isContract(recip))
162         recip.receiveApproval( msg.sender, value, context );
163 
164       return true;
165     }
166 
167     return false;
168   }        
169 
170   // Ethereum Token
171   function burn( uint256 value ) public
172   returns (bool success)
173   {
174     require( balances_[msg.sender] >= value );
175     balances_[msg.sender] -= value;
176     totalSupply -= value;
177 
178     Burn( msg.sender, value );
179     return true;
180   }
181 
182   // Ethereum Token
183   function burnFrom( address from, uint256 value ) public
184   returns (bool success)
185   {
186     require( balances_[from] >= value );
187     require( value <= allowances_[from][msg.sender] );
188 
189     balances_[from] -= value;
190     allowances_[from][msg.sender] -= value;
191     totalSupply -= value;
192 
193     Burn( from, value );
194     return true;
195   }
196 
197   // ERC223 Transfer and invoke specified callback
198   function transfer( address to,
199                      uint value,
200                      bytes data,
201                      string custom_fallback ) public returns (bool success)
202   {
203     _transfer( msg.sender, to, value, data );
204 
205     // throws if custom_fallback is not a valid contract call
206     require( address(to).call.value(0)(bytes4(keccak256(custom_fallback)),
207              msg.sender,
208              value,
209              data) );
210 
211     return true;
212   }
213 
214   // ERC223 Transfer to a contract or externally-owned account
215   function transfer( address to, uint value, bytes data ) public
216   returns (bool success)
217   {
218     if (isContract(to)) {
219       return transferToContract( to, value, data );
220     }
221 
222     _transfer( msg.sender, to, value, data );
223     return true;
224   }
225 
226   // ERC223 Transfer to contract and invoke tokenFallback() method
227   function transferToContract( address to, uint value, bytes data ) private
228   returns (bool success)
229   {
230     _transfer( msg.sender, to, value, data );
231 
232     ContractReceiver rx = ContractReceiver(to);
233 
234     if (isContract(rx)) {
235       rx.tokenFallback( msg.sender, value, data );
236       return true;
237     }
238 
239     return false;
240   }
241 
242   // ERC223 fetch contract size (must be nonzero to be a contract)
243   function isContract( address _addr ) private constant returns (bool)
244   {
245     uint length;
246     assembly { length := extcodesize(_addr) }
247     return (length > 0);
248   }
249 
250   function _transfer( address from,
251                       address to,
252                       uint value,
253                       bytes data ) internal
254   {
255     require( to != 0x0 );
256     require( balances_[from] >= value );
257     require( balances_[to] + value > balances_[to] ); // catch overflow
258 
259     balances_[from] -= value;
260     balances_[to] += value;
261 
262     bytes memory ignore;
263     ignore = data;                    // ignore compiler warning
264     Transfer( from, to, value ); // ERC20-version, ignore data
265   }
266 }