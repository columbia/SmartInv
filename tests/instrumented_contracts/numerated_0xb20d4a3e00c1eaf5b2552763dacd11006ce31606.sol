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
38 contract MONIToken is owned {
39 
40   string  public name;
41   string  public symbol;
42   uint8   public decimals;
43   uint256 public totalSupply;
44  // uint256 public supplyCap;
45 
46   uint256 public noTransferBefore;
47 
48   mapping( address => uint256 ) balances_;
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
68   function MONIToken( uint8 _decimals,
69                           //uint256 _tokcap,
70                           string _name,
71                           string _symbol,
72                           uint256 _noTransferBefore // datetime, in seconds
73   ) public {
74 
75     decimals = uint8(_decimals); // audit recommended 18 decimals
76   //  supplyCap = _tokcap * 10**uint256(decimals);
77     totalSupply = 0;
78 
79     name = _name;
80     symbol = _symbol;
81     noTransferBefore = _noTransferBefore;
82   }
83 
84   function mine( uint256 qty ) public onlyOwner {
85     require (    (totalSupply + qty) > totalSupply  );
86 
87     totalSupply += qty;
88     balances_[owner] += qty;
89     emit Transfer( address(0), owner, qty );
90   }
91 
92 //   function cap() public constant returns(uint256) {
93 //     return supplyCap;
94 //   }
95 
96   // ERC20
97   function balanceOf( address owner ) public constant returns (uint) {
98     return balances_[owner];
99   }
100 
101   // ERC20
102   function approve( address spender, uint256 value ) public
103   returns (bool success)
104   {
105     // WARNING! When changing the approval amount, first set it back to zero
106     // AND wait until the transaction is mined. Only afterwards set the new
107     // amount. Otherwise you may be prone to a race condition attack.
108     // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109 
110     allowances_[msg.sender][spender] = value;
111     emit Approval( msg.sender, spender, value );
112     return true;
113   }
114 
115   // recommended fix for known attack on any ERC20
116   function safeApprove( address _spender,
117                         uint256 _currentValue,
118                         uint256 _value ) public
119   returns (bool success)
120   {
121     // If current allowance for _spender is equal to _currentValue, then
122     // overwrite it with _value and return true, otherwise return false.
123 
124     if (allowances_[msg.sender][_spender] == _currentValue)
125       return approve(_spender, _value);
126 
127     return false;
128   }
129 
130   // ERC20
131   function allowance( address owner, address spender ) public constant
132   returns (uint256 remaining)
133   {
134     return allowances_[owner][spender];
135   }
136 
137   // ERC20
138   function transfer(address to, uint256 value) public
139   returns (bool success)
140   {
141     bytes memory empty; // null
142     _transfer( msg.sender, to, value, empty );
143     return true;
144   }
145 
146   // ERC20
147   function transferFrom( address from, address to, uint256 value ) public
148   returns (bool success)
149   {
150     require( value <= allowances_[from][msg.sender] );
151 
152     allowances_[from][msg.sender] -= value;
153     bytes memory empty;
154     _transfer( from, to, value, empty );
155 
156     return true;
157   }
158 
159   // Ethereum Token
160   function approveAndCall( address spender,
161                            uint256 value,
162                            bytes context ) public
163   returns (bool success)
164   {
165     if ( approve(spender, value) )
166     {
167       tokenRecipient recip = tokenRecipient( spender );
168 
169       if (isContract(recip))
170         recip.receiveApproval( msg.sender, value, context );
171 
172       return true;
173     }
174 
175     return false;
176   }
177 
178   // Ethereum Token
179   function burn( uint256 value ) public
180   returns (bool success)
181   {
182     require( balances_[msg.sender] >= value );
183     balances_[msg.sender] -= value;
184     totalSupply -= value;
185 
186     emit Burn( msg.sender, value );
187     return true;
188   }
189 
190   // Ethereum Token
191   function burnFrom( address from, uint256 value ) public
192   returns (bool success)
193   {
194     require( balances_[from] >= value );
195     require( value <= allowances_[from][msg.sender] );
196 
197     balances_[from] -= value;
198     allowances_[from][msg.sender] -= value;
199     totalSupply -= value;
200 
201     emit Burn( from, value );
202     return true;
203   }
204 
205   // ERC223 Transfer and invoke specified callback
206   function transfer( address to,
207                      uint value,
208                      bytes data,
209                      string custom_fallback ) public returns (bool success)
210   {
211     _transfer( msg.sender, to, value, data );
212 
213     // throws if custom_fallback is not a valid contract call
214     require( address(to).call.value(0)(bytes4(keccak256(custom_fallback)),
215              msg.sender,
216              value,
217              data) );
218 
219     return true;
220   }
221 
222   // ERC223 Transfer to a contract or externally-owned account
223   function transfer( address to, uint value, bytes data ) public
224   returns (bool success)
225   {
226     if (isContract(to)) {
227       return transferToContract( to, value, data );
228     }
229 
230     _transfer( msg.sender, to, value, data );
231     return true;
232   }
233 
234   // ERC223 Transfer to contract and invoke tokenFallback() method
235   function transferToContract( address to, uint value, bytes data ) private
236   returns (bool success)
237   {
238     _transfer( msg.sender, to, value, data );
239 
240     ContractReceiver rx = ContractReceiver(to);
241 
242     if (isContract(rx)) {
243       rx.tokenFallback( msg.sender, value, data );
244       return true;
245     }
246 
247     return false;
248   }
249 
250   // ERC223 fetch contract size (must be nonzero to be a contract)
251   function isContract( address _addr ) private constant returns (bool)
252   {
253     uint length;
254     assembly { length := extcodesize(_addr) }
255     return (length > 0);
256   }
257 
258   function _transfer( address from,
259                       address to,
260                       uint value,
261                       bytes data ) internal
262   {
263     require( to != 0x0 );
264     require( balances_[from] >= value );
265     require( balances_[to] + value > balances_[to] ); // catch overflow
266 
267     // no transfers allowed before trading begins
268     if (msg.sender != owner) require( now >= noTransferBefore );
269 
270     balances_[from] -= value;
271     balances_[to] += value;
272 
273     bytes memory ignore;
274     ignore = data;                    // ignore compiler warning
275     emit Transfer( from, to, value ); // ignore data
276   }
277 }