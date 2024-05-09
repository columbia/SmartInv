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
111     require(balanceOf[msg.sender] >= _amount);
112     require(balanceOf[_to] + _amount >= balanceOf[_to]);
113     balanceOf[msg.sender] -= _amount;
114     uint256 preBalance = balanceOf[_to];
115     balanceOf[_to] += _amount;
116     bool alreadyMax = preBalance >= singleIDXMQty;
117     if (!alreadyMax) {
118       if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;
119       validAfter[_to].ts = now;
120     }
121     if (validAfter[msg.sender].last > balanceOf[msg.sender]) validAfter[msg.sender].last = balanceOf[msg.sender];
122     Transfer(msg.sender, _to, _amount);
123     return true;
124   }
125 
126   /**
127    * @notice Transfer `_amount` from `_from` to `_to`.
128    *
129    * @param _from Origin address
130    * @param _to Address that will receive
131    * @param _amount Amount to be transferred.
132    * @return result of the method call
133    */
134   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
135     require(balanceOf[_from] >= _amount);
136     require(balanceOf[_to] + _amount >= balanceOf[_to]);
137     require(_amount <= allowance[_from][msg.sender]);
138     balanceOf[_from] -= _amount;
139     uint256 preBalance = balanceOf[_to];
140     balanceOf[_to] += _amount;
141     allowance[_from][msg.sender] -= _amount;
142     bool alreadyMax = preBalance >= singleIDXMQty;
143     if (!alreadyMax) {
144       if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;
145       validAfter[_to].ts = now;
146     }
147     if (validAfter[_from].last > balanceOf[_from]) validAfter[_from].last = balanceOf[_from];
148     Transfer(_from, _to, _amount);
149     return true;
150   }
151 
152   /**
153    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
154    *
155    * @param _spender Address that receives the cheque
156    * @param _amount Amount on the cheque
157    * @param _extraData Consequential contract to be executed by spender in same transcation.
158    * @return result of the method call
159    */
160   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
161     tokenRecipient spender = tokenRecipient(_spender);
162     if (approve(_spender, _amount)) {
163       spender.receiveApproval(msg.sender, _amount, this, _extraData);
164       return true;
165     }
166   }
167 
168   /**
169    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
170    *
171    * @param _spender Address that receives the cheque
172    * @param _amount Amount on the cheque
173    * @return result of the method call
174    */
175   function approve(address _spender, uint256 _amount) returns (bool success) {
176     allowance[msg.sender][_spender] = _amount;
177     Approval(msg.sender, _spender, _amount);
178     return true;
179   }
180 
181   function setExportFee(address addr, uint256 fee) onlyOwner {
182     require(addr != 0x00000000000000000000000000000000000000ff);
183     exportFee[addr] = fee;
184   }
185 
186   function setHoldingPeriod(uint256 ts) onlyOwner {
187     mustHoldFor = ts;
188   }
189 
190 
191   /* --------------- fee calculation method ---------------- */
192 
193   /**
194    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
195    *
196    * Fee's consist of a possible
197    *    - import fee on transfers to an address
198    *    - export fee on transfers from an address
199    * IDXM ownership on an address
200    *    - reduces fee on a transfer from this address to an import fee-ed address
201    *    - reduces the fee on a transfer to this address from an export fee-ed address
202    * IDXM discount does not work for addresses that have an import fee or export fee set up against them.
203    *
204    * IDXM discount goes up to 100%
205    *
206    * @param from From address
207    * @param to To address
208    * @param amount Amount for which fee needs to be calculated.
209    *
210    */
211   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
212     uint256 fee = exportFee[from];
213     if (fee == 0) return 0;
214     uint256 amountHeld;
215     if (balanceOf[to] != 0) {
216       if (validAfter[to].ts + mustHoldFor < now) amountHeld = balanceOf[to];
217       else amountHeld = validAfter[to].last;
218       if (amountHeld >= singleIDXMQty) return 0;
219       return amount*fee*(singleIDXMQty - amountHeld) / feeDivisor;
220     } else return amount*fee / baseFeeDivisor;
221   }
222   function precalculate() internal returns (bool success) {
223     baseFeeDivisor = pow10(1, feeDecimals);
224     feeDivisor = pow10(1, feeDecimals + decimals);
225     singleIDXMQty = pow10(1, decimals);
226   }
227   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
228     for (uint8 i = 0; i < b; i++) {
229       a /= 10;
230     }
231     return a;
232   }
233   function pow10(uint256 a, uint8 b) internal returns (uint256 result) {
234     for (uint8 i = 0; i < b; i++) {
235       a *= 10;
236     }
237     return a;
238   }
239 }