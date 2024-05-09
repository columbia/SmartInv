1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title IDXM Contract. IDEX Membership Token contract.
5  *
6  * @author Ray Pulver, ray@auroradao.com
7  */
8 
9 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
10 
11 contract SafeMath {
12   function safeMul(uint256 a, uint256 b) returns (uint256) {
13     uint256 c = a * b;
14     require(a == 0 || c / a == b);
15     return c;
16   }
17   function safeSub(uint256 a, uint256 b) returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21   function safeAdd(uint256 a, uint256 b) returns (uint256) {
22     uint c = a + b;
23     require(c >= a && c >= b);
24     return c;
25   }
26 }
27 
28 contract Owned {
29   address public owner;
30   function Owned() {
31     owner = msg.sender;
32   }
33   function setOwner(address _owner) returns (bool success) {
34     owner = _owner;
35     return true;
36   }
37   modifier onlyOwner {
38     require(msg.sender == owner);
39     _;
40   }
41 }
42 
43 contract IDXM is Owned, SafeMath {
44   uint8 public decimals = 8;
45   bytes32 public standard = 'Token 0.1';
46   bytes32 public name = 'IDEX Membership';
47   bytes32 public symbol = 'IDXM';
48   uint256 public totalSupply;
49 
50   event Approval(address indexed from, address indexed spender, uint256 amount);
51 
52   mapping (address => uint256) public balanceOf;
53   mapping (address => mapping (address => uint256)) public allowance;
54 
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 
57   uint256 public baseFeeDivisor;
58   uint256 public feeDivisor;
59   uint256 public singleIDXMQty;
60 
61   function () external {
62     throw;
63   }
64 
65   uint8 public feeDecimals = 8;
66 
67   struct Validity {
68     uint256 last;
69     uint256 ts;
70   }
71 
72   mapping (address => Validity) public validAfter;
73   uint256 public mustHoldFor = 604800;
74   mapping (address => uint256) public exportFee;
75 
76   /**
77    * Constructor.
78    *
79    */
80   function IDXM() {
81     totalSupply = 200000000000;
82     balanceOf[msg.sender] = totalSupply;
83     exportFee[0x00000000000000000000000000000000000000ff] = 100000000;
84     precalculate();
85   }
86 
87   bool public balancesLocked = false;
88 
89   function uploadBalances(address[] addresses, uint256[] balances) onlyOwner {
90     require(!balancesLocked);
91     require(addresses.length == balances.length);
92     uint256 sum;
93     for (uint256 i = 0; i < uint256(addresses.length); i++) {
94       sum = safeAdd(sum, safeSub(balances[i], balanceOf[addresses[i]]));
95       balanceOf[addresses[i]] = balances[i];
96     }
97     balanceOf[owner] = safeSub(balanceOf[owner], sum);
98   }
99 
100   function lockBalances() onlyOwner {
101     balancesLocked = true;
102   }
103 
104   /**
105    * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.
106    *
107    * @param _to Address that will receive.
108    * @param _amount Amount to be transferred.
109    */
110   function transfer(address _to, uint256 _amount) returns (bool success) {
111     require(!locked);
112     require(balanceOf[msg.sender] >= _amount);
113     require(balanceOf[_to] + _amount >= balanceOf[_to]);
114     balanceOf[msg.sender] -= _amount;
115     uint256 preBalance = balanceOf[_to];
116     balanceOf[_to] += _amount;
117     bool alreadyMax = preBalance >= singleIDXMQty;
118     if (!alreadyMax) {
119       if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;
120       validAfter[_to].ts = now;
121     }
122     if (validAfter[msg.sender].last > balanceOf[msg.sender]) validAfter[msg.sender].last = balanceOf[msg.sender];
123     Transfer(msg.sender, _to, _amount);
124     return true;
125   }
126 
127   /**
128    * @notice Transfer `_amount` from `_from` to `_to`.
129    *
130    * @param _from Origin address
131    * @param _to Address that will receive
132    * @param _amount Amount to be transferred.
133    * @return result of the method call
134    */
135   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
136     require(!locked);
137     require(balanceOf[_from] >= _amount);
138     require(balanceOf[_to] + _amount >= balanceOf[_to]);
139     require(_amount <= allowance[_from][msg.sender]);
140     balanceOf[_from] -= _amount;
141     uint256 preBalance = balanceOf[_to];
142     balanceOf[_to] += _amount;
143     allowance[_from][msg.sender] -= _amount;
144     bool alreadyMax = preBalance >= singleIDXMQty;
145     if (!alreadyMax) {
146       if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;
147       validAfter[_to].ts = now;
148     }
149     if (validAfter[_from].last > balanceOf[_from]) validAfter[_from].last = balanceOf[_from];
150     Transfer(_from, _to, _amount);
151     return true;
152   }
153 
154   /**
155    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
156    *
157    * @param _spender Address that receives the cheque
158    * @param _amount Amount on the cheque
159    * @param _extraData Consequential contract to be executed by spender in same transcation.
160    * @return result of the method call
161    */
162   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
163     tokenRecipient spender = tokenRecipient(_spender);
164     if (approve(_spender, _amount)) {
165       spender.receiveApproval(msg.sender, _amount, this, _extraData);
166       return true;
167     }
168   }
169 
170   /**
171    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
172    *
173    * @param _spender Address that receives the cheque
174    * @param _amount Amount on the cheque
175    * @return result of the method call
176    */
177   function approve(address _spender, uint256 _amount) returns (bool success) {
178     require(!locked);
179     allowance[msg.sender][_spender] = _amount;
180     Approval(msg.sender, _spender, _amount);
181     return true;
182   }
183 
184   function setExportFee(address addr, uint256 fee) onlyOwner {
185     require(addr != 0x00000000000000000000000000000000000000ff);
186     exportFee[addr] = fee;
187   }
188 
189   function setHoldingPeriod(uint256 ts) onlyOwner {
190     mustHoldFor = ts;
191   }
192 
193 
194   /* --------------- fee calculation method ---------------- */
195 
196   /**
197    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
198    *
199    * Fee's consist of a possible
200    *    - import fee on transfers to an address
201    *    - export fee on transfers from an address
202    * IDXM ownership on an address
203    *    - reduces fee on a transfer from this address to an import fee-ed address
204    *    - reduces the fee on a transfer to this address from an export fee-ed address
205    * IDXM discount does not work for addresses that have an import fee or export fee set up against them.
206    *
207    * IDXM discount goes up to 100%
208    *
209    * @param from From address
210    * @param to To address
211    * @param amount Amount for which fee needs to be calculated.
212    *
213    */
214   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
215     uint256 fee = exportFee[from];
216     if (fee == 0) return 0;
217     uint256 amountHeld;
218     if (balanceOf[to] != 0) {
219       if (validAfter[to].ts + mustHoldFor < now) amountHeld = balanceOf[to];
220       else amountHeld = validAfter[to].last;
221       if (amountHeld >= singleIDXMQty) return 0;
222       return amount*fee*(singleIDXMQty - amountHeld) / feeDivisor;
223     } else return amount*fee / baseFeeDivisor;
224   }
225   
226   bool public locked = true;
227 
228   function unlockToken() onlyOwner {
229     locked = false;
230   }
231 
232   function precalculate() internal returns (bool success) {
233     baseFeeDivisor = pow10(1, feeDecimals);
234     feeDivisor = pow10(1, feeDecimals + decimals);
235     singleIDXMQty = pow10(1, decimals);
236   }
237   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
238     for (uint8 i = 0; i < b; i++) {
239       a /= 10;
240     }
241     return a;
242   }
243   function pow10(uint256 a, uint8 b) internal returns (uint256 result) {
244     for (uint8 i = 0; i < b; i++) {
245       a *= 10;
246     }
247     return a;
248   }
249 }