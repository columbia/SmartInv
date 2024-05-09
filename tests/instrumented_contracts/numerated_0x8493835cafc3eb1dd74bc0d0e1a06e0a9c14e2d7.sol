1 /*
2 
3 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
4 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
5 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
6 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
7 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
8 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
9 SOFTWARE.
10 
11 https://www.lovco.in/
12 https://lovcoin.github.io/
13 
14 Version 1.0 - 21.feb.2018
15 
16 LoveLock smart contract - https://www.lovelock-online.com.
17 
18 */
19 
20 
21 
22 
23 // We need this interface to interact with our ERC20 tokencontract
24 contract ERC20Interface 
25 {
26          // function totalSupply() public constant returns (uint256);
27       function balanceOf(address tokenOwner) public constant returns (uint256 balance);
28       function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
29       function transfer(address to, uint256 tokens) public returns (bool success);
30          // function approve(address spender, uint256 tokens) public returns (bool success);
31       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
32          // event Transfer(address indexed from, address indexed to, uint256 tokens);
33          // event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
34 } 
35 
36 
37 
38 
39 // ---
40 // Main LoveLock class
41 //
42 contract LoveLock
43 {
44 address public owner;                    // The owner of this contract
45 
46 uint    public lastrecordindex;          // The highest record index, number of lovelocks
47 uint    public lovelock_price;           // Lovelock price (starts with ~ $9.99 in ETH, 0.0119 ETH)
48 uint    public lovelock_price_LOV;       // Lovelock price (in LOV!)
49 
50 address public last_buyer;               // Last buyer of a lovelock.
51 bytes32 public last_hash;                // Last index hash
52 
53 address TokenContractAddress;            // The address of the ERC20-Token, rewards are paying for
54 ERC20Interface TokenContract;            // Interface of the ERC20-Token
55 address public thisAddress;              // The address of this contract
56 
57 uint    public debug_last_approved;
58 
59 
60 //
61 // Datasets for the lovelocks.
62 //
63 struct DataRecord
64 {
65 string name1;
66 string name2;
67 string lovemessage;
68 uint   locktype;
69 uint   timestamp;
70 } // struct DataRecord
71 
72 mapping(bytes32 => DataRecord) public DataRecordStructs;
73 
74 //
75 // Dataset for indexes
76 //
77 struct DataRecordIndex
78 {
79 bytes32 index_hash;
80 } // DataRecordIndex
81 
82 mapping(uint256 => DataRecordIndex) public DataRecordIndexStructs;
83 
84 
85 
86 // ---
87 // Constructor
88 // 
89 function LoveLock () public
90 {
91 // Today 20.Feb.2018 - 1 ETH=$950, 0.01 ~ $9.99
92 
93 lovelock_price           = 10000000000000000;
94 
95 lovelock_price_LOV       = 1000000000000000000*5000; // 5000 LOV
96                            
97 owner                    = msg.sender;
98 
99 // Address of TokenContract
100 TokenContractAddress     = 0x26B1FBE292502da2C8fCdcCF9426304d0900b703; // Mainnet
101 TokenContract            = ERC20Interface(TokenContractAddress); 
102 
103 thisAddress              = address(this);
104 
105 lastrecordindex          = 0;
106 } // Constructor
107  
108 
109 
110 
111 // ---
112 // withdraw_to_owner
113 // 
114 function withdraw_to_owner() public returns (bool)
115 {
116 if (msg.sender != owner) return (false);
117 
118 // Transfer tokens to owner
119 uint256 balance = TokenContract.balanceOf(this);
120 TokenContract.transfer(owner, balance); 
121 
122 // Transfer ETH to owner
123 owner.transfer( this.balance );
124 
125 return(true);
126 } // withdraw_to_owner
127 
128 
129 
130 // ---
131 // number_to_hash
132 //
133 function number_to_hash( uint param ) public constant returns (bytes32)
134 {
135 bytes32 ret = keccak256(param);
136 return(ret);
137 } // number_to_hash
138 
139 
140 
141 
142 
143 // ---
144 // Web3 event 'LovelockPayment'
145 //
146 event LovelockPayment
147 (
148 address indexed _from,
149 bytes32 hashindex,
150 uint _value2
151 );
152     
153     
154 // ---
155 // buy lovelock (with ETH)
156 //
157 function buy_lovelock( bytes32 index_hash, string name1, string name2, string lovemessage, uint locktype ) public payable returns (uint)
158 {
159 last_buyer = msg.sender;
160 
161 
162 // Overwrite protection
163 if (DataRecordStructs[index_hash].timestamp > 1000)
164    {
165    return 0;
166    }
167    
168 
169 // only if payed the full price.
170 if ( msg.value >= lovelock_price )
171    {
172    
173    // ----- Create the lock ---------------------------------
174     // Increment the record index.
175     lastrecordindex = lastrecordindex + 1;  
176        
177     last_hash = index_hash;
178         
179     // Store the lovelock data into the record for the eternity.
180     DataRecordStructs[last_hash].name1       = name1;
181     DataRecordStructs[last_hash].name2       = name2;
182     DataRecordStructs[last_hash].lovemessage = lovemessage;
183     DataRecordStructs[last_hash].locktype    = locktype;
184     DataRecordStructs[last_hash].timestamp   = now;
185    
186     DataRecordIndexStructs[lastrecordindex].index_hash = last_hash;
187    
188     // The Web3-Event!!!
189     LovelockPayment(msg.sender, last_hash, lastrecordindex);  
190    // --- END lock creation --------------------------------------
191    
192    return(1);
193    } else
194      {
195      revert();
196      }
197 
198  
199 return(0);
200 } // buy_lovelock
201 
202 
203 
204 
205 // ---
206 // buy buy_lovelock_withLOV
207 //
208 function buy_lovelock_withLOV( bytes32 index_hash, string name1, string name2, string lovemessage, uint locktype ) public returns (uint)
209 {
210 last_buyer = msg.sender;
211 uint256      amount_token = 0; 
212 
213 
214 // Overwrite protection
215 if (DataRecordStructs[index_hash].timestamp > 1000)
216    {
217    return 0;
218    }
219 
220     
221 // Check token allowance   
222 amount_token = TokenContract.allowance( msg.sender, thisAddress );
223 debug_last_approved = amount_token;
224    
225 
226 if (amount_token >= lovelock_price_LOV)
227    {
228 
229    // Transfer token to this contract
230    bool success = TokenContract.transferFrom(msg.sender, thisAddress, amount_token);
231           
232    if (success == true)
233       {   
234 
235       // ----- Create the lock ------------------------------
236       // Increment the record index.
237       lastrecordindex = lastrecordindex + 1;  
238             
239       last_hash = index_hash;
240         
241       // Store the lovelock data into the record for the eternity.
242       DataRecordStructs[last_hash].name1       = name1;
243       DataRecordStructs[last_hash].name2       = name2;
244       DataRecordStructs[last_hash].lovemessage = lovemessage;
245       DataRecordStructs[last_hash].locktype    = locktype;
246       DataRecordStructs[last_hash].timestamp   = now;
247 
248       DataRecordIndexStructs[lastrecordindex].index_hash = last_hash;
249    
250       // The Web3-Event!!!
251       LovelockPayment(msg.sender, last_hash, lastrecordindex);  
252       // --- END creation -----------------------------------
253        
254       } // if (success == true)
255       else 
256          {
257          //debug = "transferFrom returns FALSE";   
258          }
259        
260       
261      
262    return(1); 
263    } else
264      {
265      // low balance  
266      //revert();
267      }
268 
269 return(0);
270 } // buy_lovelock_withLOV
271 
272 
273 
274 
275 //
276 // Transfer owner
277 //
278 function transfer_owner( address new_owner ) public returns (uint)
279 {
280 if (msg.sender != owner) return(0);
281 require(new_owner != 0);
282 
283 owner = new_owner;
284 return(1);
285 } // function transfer_owner()
286 
287 
288 
289 
290 
291 } // contract LoveLock