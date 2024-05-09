1 // 0.4.20+commit.3155dd80.Emscripten.clang
2 pragma solidity ^0.4.20;
3 
4 /**
5  * Ethereum Token callback
6  */
7 interface tokenRecipient {
8   function receiveApproval( address from, uint256 value, bytes data ) external;
9 }
10 
11 /**
12  * ERC223 callback
13  */
14 interface ContractReceiver {
15   function tokenFallback( address from, uint value, bytes data ) external;
16 }
17 
18 /**
19  * Ownable Contract
20  */
21 contract Owned {
22   address public owner;
23 
24   function owned() public {
25     owner = msg.sender;
26   }
27 
28   function changeOwner(address _newOwner) public onlyOwner {
29     owner = _newOwner;
30   }
31 
32   modifier onlyOwner {
33     require (msg.sender == owner);
34     _;
35   }
36 }
37 
38 /**
39  * ERC20 token with added ERC223 and Ethereum-Token support
40  *
41  * Blend of multiple interfaces:
42  * - https://theethereum.wiki/w/index.php/ERC20_Token_Standard
43  * - https://www.ethereum.org/token (uncontrolled, non-standard)
44  * - https://github.com/Dexaran/ERC23-tokens/blob/Recommended/ERC223_Token.sol
45  */
46 contract Token is Owned {
47   string  public name;
48   string  public symbol;
49   uint8   public decimals = 18;
50   uint256 public totalSupply;
51 
52   mapping( address => uint256 ) balances;
53   mapping( address => mapping(address => uint256) ) allowances;
54 
55   /**
56    * ERC20 Approval Event
57    */
58   event Approval(
59     address indexed owner,
60     address indexed spender,
61     uint value
62   );
63 
64   /**
65    * ERC20-compatible version only, breaks ERC223 compliance but block
66    * explorers and exchanges expect ERC20. Also, cannot overload events
67    */
68   event Transfer(
69     address indexed from,
70     address indexed to,
71     uint256 value
72   );
73 
74   function Token(
75     uint256 _initialSupply,
76     string _tokenName,
77     string _tokenSymbol
78   )
79     public
80   {
81     totalSupply = _initialSupply * 10**18;
82     balances[msg.sender] = _initialSupply * 10**18;
83 
84     name = _tokenName;
85     symbol = _tokenSymbol;
86   }
87 
88   /**
89    * ERC20 Balance Of Function
90    */
91   function balanceOf( address owner ) public constant returns (uint) {
92     return balances[owner];
93   }
94 
95   /**
96    * ERC20 Approve Function
97    */
98   function approve( address spender, uint256 value ) public returns (bool success) {
99     // WARNING! When changing the approval amount, first set it back to zero
100     // AND wait until the transaction is mined. Only afterwards set the new
101     // amount. Otherwise you may be prone to a race condition attack.
102     // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103     allowances[msg.sender][spender] = value;
104     Approval( msg.sender, spender, value );
105     return true;
106   }
107 
108   /**
109    * Recommended fix for known attack on any ERC20
110    */
111   function safeApprove(
112     address _spender,
113     uint256 _currentValue,
114     uint256 _value
115   )
116     public
117     returns (bool success)
118   {
119     // If current allowance for _spender is equal to _currentValue, then
120     // overwrite it with _value and return true, otherwise return false.
121 
122     if (allowances[msg.sender][_spender] == _currentValue)
123       return approve(_spender, _value);
124 
125     return false;
126   }
127 
128   /**
129    * ERC20 Allowance Function
130    */
131   function allowance(
132     address owner,
133     address spender
134   )
135     public constant
136     returns (uint256 remaining)
137   {
138     return allowances[owner][spender];
139   }
140 
141   /**
142    * ERC20 Transfer Function
143    */
144   function transfer(
145     address to,
146     uint256 value
147   )
148     public
149     returns (bool success)
150   {
151     bytes memory empty; // null
152     _transfer( msg.sender, to, value, empty );
153     return true;
154   }
155 
156   /**
157    * ERC20 Transfer From Function
158    */
159   function transferFrom(
160     address from,
161     address to,
162     uint256 value
163   )
164     public
165     returns (bool success)
166   {
167     require( value <= allowances[from][msg.sender] );
168 
169     allowances[from][msg.sender] -= value;
170     bytes memory empty;
171     _transfer( from, to, value, empty );
172 
173     return true;
174   }
175 
176   /**
177    * Ethereum Token Approve and Call Function
178    */
179   function approveAndCall(
180     address spender,
181     uint256 value,
182     bytes context
183   )
184     public
185     returns (bool success)
186   {
187     if (approve(spender, value))
188     {
189       tokenRecipient recip = tokenRecipient(spender);
190 
191       if (isContract(recip))
192         recip.receiveApproval(msg.sender, value, context);
193 
194       return true;
195     }
196 
197     return false;
198   }
199 
200 
201   /**
202    * ERC223 Transfer and invoke specified callback
203    */
204   function transfer(
205     address to,
206     uint value,
207     bytes data,
208     string custom_fallback
209   )
210     public
211     returns (bool success)
212   {
213     _transfer( msg.sender, to, value, data );
214 
215     // throws if custom_fallback is not a valid contract call
216     require(
217       address(to).call.value(0)(
218         bytes4(keccak256(custom_fallback)),
219         msg.sender,
220         value,
221         data
222       )
223     );
224 
225     return true;
226   }
227 
228   /**
229    * ERC223 Transfer to a contract or externally-owned account
230    */
231   function transfer(
232     address to,
233     uint value,
234     bytes data
235   )
236     public
237     returns (bool success)
238   {
239     if (isContract(to)) {
240       return transferToContract( to, value, data );
241     }
242 
243     _transfer( msg.sender, to, value, data );
244     return true;
245   }
246 
247   /**
248    * ERC223 Transfer to contract and invoke tokenFallback() method
249    */
250   function transferToContract(
251     address to,
252     uint value,
253     bytes data
254   )
255     private
256     returns (bool success)
257   {
258     _transfer( msg.sender, to, value, data );
259 
260     ContractReceiver rx = ContractReceiver(to);
261 
262     if (isContract(rx)) {
263       rx.tokenFallback( msg.sender, value, data );
264       return true;
265     }
266 
267     return false;
268   }
269 
270   /**
271    * ERC223 fetch contract size (must be nonzero to be a contract)
272    */
273   function isContract(address _addr)
274     private
275     constant
276     returns (bool)
277   {
278     uint length;
279     assembly { length := extcodesize(_addr) }
280     return (length > 0);
281   }
282 
283   /**
284    * Transfer Functionality
285    */
286   function _transfer(
287     address from,
288     address to,
289     uint value,
290     bytes data
291   )
292     internal
293   {
294     require( to != 0x0 );
295     require( balances[from] >= value );
296     require( balances[to] + value > balances[to] ); // catch overflow
297 
298     balances[from] -= value;
299     balances[to] += value;
300 
301     bytes memory ignore;
302     ignore = data; // ignore compiler warning
303     Transfer( from, to, value ); // ERC20-version, ignore data
304   }
305 }