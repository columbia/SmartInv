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
11 https://lovcoin.github.io/
12 
13 BETA/DRAFT - NOT TESTED !!! - DO NOT USE THIS SOURCE FOR LIVE-REVARD
14 
15 Draft 0.1 - 08.feb.2018
16 
17 */
18 
19 
20 
21 // ---
22 // Main LoveLock class
23 //
24 contract LoveLock
25 {
26 address public owner;                    // The owner of this contract
27 
28 uint    public lastrecordindex;          // The highest record index, number of lovelocks
29 uint    public lovelock_price;           // Lovelock price (starts with ~ $9.99 in ETH, 0.0119 ETH)
30 
31 address public last_buyer;               // Last buyer of a lovelock.
32 bytes32 public last_hash;                // Last index hash
33 
34 
35 //
36 // Datasets for the lovelocks.
37 //
38 struct DataRecord
39 {
40 string name1;
41 string name2;
42 string lovemessage;
43 uint   locktype;
44 } // struct DataRecord
45 
46 mapping(bytes32 => DataRecord) public DataRecordStructs;
47 
48 
49 
50 
51 
52 // ---
53 // Constructor
54 // 
55 function LoveLock () public
56 {
57 // Today 08.Feb.2018 - 1 ETH=$836, 0.0119 ~ $9.99
58 
59 //lovelock_price           = 11900000000000000;
60 // (much smaller for testing)
61 lovelock_price             = 1100000000000000;
62 owner                    = msg.sender;
63 lastrecordindex          = 0;
64 } // Constructor
65  
66 
67 
68 
69 // ---
70 // withdraw_to_reward_contract
71 // 
72 function withdraw_to_reward_contract() public constant returns (bool)
73 {
74 address reward_contract = 0xF711233A0Bec76689FEA4870cc6f4224334DB9c3;
75 reward_contract.transfer( this.balance );
76 return(true);
77 } // withdraw_to_reward_contract
78 
79 
80 
81 // ---
82 // number_to_hash
83 //
84 function number_to_hash( uint param ) public constant returns (bytes32)
85 {
86 bytes32 ret = keccak256(param);
87 return(ret);
88 } // number_to_hash
89 
90 
91 
92 
93 
94 // ---
95 // Web3 event 'LovelockPayment'
96 //
97 event LovelockPayment
98 (
99 address indexed _from,
100 bytes32 hashindex,
101 uint _value2
102 );
103     
104     
105 // ---
106 // buy lovelock
107 //
108 function buy_lovelock( string name1, string name2, string lovemessage, uint locktype ) public payable returns (uint)
109 {
110 last_buyer = msg.sender;
111 
112 // only if payed the full price.
113 if ( msg.value >= lovelock_price )
114    {
115    // Increment the record index.
116    lastrecordindex = lastrecordindex + 1;  
117        
118    // calculate the hash of this index.   
119    last_hash = keccak256(lastrecordindex);  
120         
121    // Store the lovelock data into the record for the eternity.
122    DataRecordStructs[last_hash].name1       = name1;
123    DataRecordStructs[last_hash].name2       = name2;
124    DataRecordStructs[last_hash].lovemessage = lovemessage;
125    DataRecordStructs[last_hash].locktype    = locktype;
126    
127    // The Web3-Event!!!
128    LovelockPayment(msg.sender, last_hash, lastrecordindex);  
129    
130    return(1);
131    } else
132      {
133      revert();
134      }
135 
136  
137 return(0);
138 } 
139 
140 
141 
142 
143 
144 
145 
146 // DEBUG - REMOVE, if going life!!!
147 // Kill (owner only)
148 //
149 function kill () public
150 {
151 if (msg.sender != owner) return;
152 
153 /*
154 // Transfer tokens back to owner
155 uint256 balance = TokenContract.balanceOf(this);
156 assert(balance > 0);
157 TokenContract.transfer(owner, balance);
158  */
159 owner.transfer( this.balance );
160 selfdestruct(owner);
161 } // kill
162 
163 
164 
165 } // contract LoveLock