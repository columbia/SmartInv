1 // compiler: 0.4.21+commit.dfe3193c.Emscripten.clang
2 pragma solidity ^0.4.21;
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
44 
45   uint256 public supplyCap;
46 
47   mapping( address => uint256 ) balances_;
48 
49   mapping( address => mapping(address => uint256) ) allowances_;
50 
51   // ERC20
52   event Approval( address indexed owner,
53                   address indexed spender,
54                   uint value );
55 
56   // ERC20-compatible version only, breaks ERC223 compliance but etherscan
57   // and exchanges only support ERC20 version. Can't overload events
58 
59   event Transfer( address indexed from,
60                   address indexed to,
61                   uint256 value );
62                   //bytes    data );
63 
64   // Ethereum Token
65   event Burn( address indexed from,
66               uint256 value );
67 
68   function MineableToken() public {
69 
70     decimals = uint8(18); // audit recommended 18 decimals
71     supplyCap = 833333333 * 10**uint256(decimals);
72 
73     name = "ORST";
74     symbol = "ORS";
75   }
76 
77   function mine( uint256 qty ) public onlyOwner {
78     require (    (totalSupply + qty) > totalSupply
79               && (totalSupply + qty) <= supplyCap
80             );
81 
82     totalSupply += qty;
83     balances_[owner] += qty;
84     emit Transfer( address(0), owner, qty );
85   }
86 
87   function cap() public constant returns(uint256) {
88     return supplyCap;
89   }
90 
91   // ERC20
92   function balanceOf( address owner ) public constant returns (uint) {
93     return balances_[owner];
94   }
95 
96   // ERC20
97   function approve( address spender, uint256 value ) public
98   returns (bool success)
99   {
100     // WARNING! When changing the approval amount, first set it back to zero
101     // AND wait until the transaction is mined. Only afterwards set the new
102     // amount. Otherwise you may be prone to a race condition attack.
103     // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104 
105     allowances_[msg.sender][spender] = value;
106     emit Approval( msg.sender, spender, value );
107     return true;
108   }
109  
110   // recommended fix for known attack on any ERC20
111   function safeApprove( address _spender,
112                         uint256 _currentValue,
113                         uint256 _value ) public
114   returns (bool success)
115   {
116     // If current allowance for _spender is equal to _currentValue, then
117     // overwrite it with _value and return true, otherwise return false.
118 
119     if (allowances_[msg.sender][_spender] == _currentValue)
120       return approve(_spender, _value);
121 
122     return false;
123   }
124 
125   // ERC20
126   function allowance( address owner, address spender ) public constant
127   returns (uint256 remaining)
128   {
129     return allowances_[owner][spender];
130   }
131 
132   // ERC20
133   function transfer(address to, uint256 value) public
134   {
135     bytes memory empty; // null
136     _transfer( msg.sender, to, value, empty );
137   }
138 
139   // ERC20
140   function transferFrom( address from, address to, uint256 value ) public
141   returns (bool success)
142   {
143     require( value <= allowances_[from][msg.sender] );
144 
145     allowances_[from][msg.sender] -= value;
146     bytes memory empty;
147     _transfer( from, to, value, empty );
148 
149     return true;
150   }
151 
152   // Ethereum Token
153   function approveAndCall( address spender,
154                            uint256 value,
155                            bytes context ) public
156   returns (bool success)
157   {
158     if ( approve(spender, value) )
159     {
160       tokenRecipient recip = tokenRecipient( spender );
161 
162       if (isContract(recip))
163         recip.receiveApproval( msg.sender, value, context );
164 
165       return true;
166     }
167 
168     return false;
169   }        
170 
171   // Ethereum Token
172   function burn( uint256 value ) public
173   returns (bool success)
174   {
175     require( balances_[msg.sender] >= value );
176     balances_[msg.sender] -= value;
177     totalSupply -= value;
178 
179     emit Burn( msg.sender, value );
180     return true;
181   }
182 
183   // Ethereum Token
184   function burnFrom( address from, uint256 value ) public
185   returns (bool success)
186   {
187     require( balances_[from] >= value );
188     require( value <= allowances_[from][msg.sender] );
189 
190     balances_[from] -= value;
191     allowances_[from][msg.sender] -= value;
192     totalSupply -= value;
193 
194     emit Burn( from, value );
195     return true;
196   }
197 
198   // ERC223 Transfer and invoke specified callback
199   function transfer( address to,
200                      uint value,
201                      bytes data,
202                      string custom_fallback ) public returns (bool success)
203   {
204     _transfer( msg.sender, to, value, data );
205 
206     // throws if custom_fallback is not a valid contract call
207     require( address(to).call.value(0)(bytes4(keccak256(custom_fallback)),
208              msg.sender,
209              value,
210              data) );
211 
212     return true;
213   }
214 
215   // ERC223 Transfer to a contract or externally-owned account
216   function transfer( address to, uint value, bytes data ) public
217   returns (bool success)
218   {
219     if (isContract(to)) {
220       return transferToContract( to, value, data );
221     }
222 
223     _transfer( msg.sender, to, value, data );
224     return true;
225   }
226 
227   // ERC223 Transfer to contract and invoke tokenFallback() method
228   function transferToContract( address to, uint value, bytes data ) private
229   returns (bool success)
230   {
231     _transfer( msg.sender, to, value, data );
232 
233     ContractReceiver rx = ContractReceiver(to);
234 
235     if (isContract(rx)) {
236       rx.tokenFallback( msg.sender, value, data );
237       return true;
238     }
239 
240     return false;
241   }
242 
243   // ERC223 fetch contract size (must be nonzero to be a contract)
244   function isContract( address _addr ) private constant returns (bool)
245   {
246     uint length;
247     assembly { length := extcodesize(_addr) }
248     return (length > 0);
249   }
250 
251   function _transfer( address from,
252                       address to,
253                       uint value,
254                       bytes data ) internal
255   {
256     require( to != 0x0 );
257     require( balances_[from] >= value );
258     require( balances_[to] + value > balances_[to] ); // catch overflow
259 
260     // no transfers allowed before ICO ends 26MAY2018 0900 CET
261     if (msg.sender != owner) require( now >= 1527321600 );
262 
263     balances_[from] -= value;
264     balances_[to] += value;
265 
266     bytes memory ignore;
267     ignore = data;                    // ignore compiler warning
268     emit Transfer( from, to, value ); // ignore data
269   }
270 }