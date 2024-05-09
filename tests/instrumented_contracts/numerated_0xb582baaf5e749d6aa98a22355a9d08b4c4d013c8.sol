1 contract TokenInterface {
2     uint totalSupply;
3     function balanceOf(address owner) constant returns (uint256 balance);
4     
5     function transfer(address to, uint256 value) returns (bool success);
6 
7     function transferFrom(address from, address to, uint256 value) returns (bool success);
8     function approve(address spender, uint256 value) returns (bool success);
9     function allowance(address owner, address spender) constant returns (uint256 remaining);
10 
11     // events notifications
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 contract StandardToken is TokenInterface {
16 
17     mapping (address => uint256) balances;
18 
19     mapping (address => mapping (address => uint256)) allowed;
20     
21     function StandardToken(){
22     }
23     function transfer(address to, uint256 value) returns (bool success) {
24         
25         
26         if (balances[msg.sender] >= value && value > 0) {
27 
28             // do actual tokens transfer       
29             balances[msg.sender] -= value;
30             balances[to]         += value;
31             
32             // rise the Transfer event
33             Transfer(msg.sender, to, value);
34             return true;
35         } else {
36             
37             return false; 
38         }
39     }
40     
41     function transferFrom(address from, address to, uint256 value) returns (bool success) {
42     
43         if ( balances[from] >= value && 
44              allowed[from][msg.sender] >= value && 
45              value > 0) {
46                                           
47     
48             // do the actual transfer
49             balances[from] -= value;    
50             balances[to] =+ value;            
51             
52 
53             // addjust the permision, after part of 
54             // permited to spend value was used
55             allowed[from][msg.sender] -= value;
56             
57             // rise the Transfer event
58             Transfer(from, to, value);
59             return true;
60         } else { 
61             
62             return false; 
63         }
64     }
65     function balanceOf(address owner) constant returns (uint256 balance) {
66         return balances[owner];
67     }
68 
69     function approve(address spender, uint256 value) returns (bool success) {
70         
71         allowed[msg.sender][spender] = value;
72         Approval(msg.sender, spender, value);
73         
74         return true;
75     }
76 
77     function allowance(address owner, address spender) constant returns (uint256 remaining) {
78       return allowed[owner][spender];
79     }
80 
81 }
82 contract HackerGold is StandardToken {
83 
84     string public name = "HackerGold";
85 
86     uint8  public decimals = 3;
87     string public symbol = "HKG";
88     
89     uint BASE_PRICE = 200;
90     uint MID_PRICE = 150;
91     uint FIN_PRICE = 100;
92     uint SAFETY_LIMIT = 4000000 ether;
93     uint DECIMAL_ZEROS = 1000;
94     
95     uint totalValue;
96     
97     address wallet;
98 
99     struct milestones_struct {
100       uint p1;
101       uint p2; 
102       uint p3;
103       uint p4;
104       uint p5;
105       uint p6;
106     }
107     // Milestones instance
108     milestones_struct milestones;
109     
110     function HackerGold(address multisig) {
111         
112         wallet = multisig;
113 
114         // set time periods for sale
115         milestones = milestones_struct(
116         
117           1476799200,  // P1: GMT: 18-Oct-2016 14:00  => The Sale Starts
118           1478181600,  // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
119           1479391200,  // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
120                        //                                Hackathon Starts
121           1480600800,  // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
122           1481810400,  // P5: GMT: 15-Dec-2016 14:00  => Price Stable
123           1482415200   // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
124         );
125                 
126     }
127     
128     
129     /**
130      * Fallback function: called on ether sent.
131      * 
132      * It calls to createHKG function with msg.sender 
133      * as a value for holder argument
134      */
135     function () payable {
136         createHKG(msg.sender);
137     }
138     
139     /**
140      * Creates HKG tokens.
141      * 
142      * Runs sanity checks including safety cap
143      * Then calculates current price by getPrice() function, creates HKG tokens
144      * Finally sends a value of transaction to the wallet
145      * 
146      * Note: due to lack of floating point types in Solidity,
147      * contract assumes that last 3 digits in tokens amount are stood after the point.
148      * It means that if stored HKG balance is 100000, then its real value is 100 HKG
149      * 
150      * @param holder token holder
151      */
152     function createHKG(address holder) payable {
153         
154         if (now < milestones.p1) throw;
155         if (now >= milestones.p6) throw;
156         if (msg.value == 0) throw;
157     
158         // safety cap
159         if (getTotalValue() + msg.value > SAFETY_LIMIT) throw; 
160     
161         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
162 
163         totalSupply += tokens;
164         balances[holder] += tokens;
165         totalValue += msg.value;
166         
167         if (!wallet.send(msg.value)) throw;
168     }
169     
170     /**
171      * Denotes complete price structure during the sale.
172      *
173      * @return HKG amount per 1 ETH for the current moment in time
174      */
175     function getPrice() constant returns (uint result) {
176         
177         if (now < milestones.p1) return 0;
178         
179         if (now >= milestones.p1 && now < milestones.p2) {
180         
181             return BASE_PRICE;
182         }
183         
184         if (now >= milestones.p2 && now < milestones.p3) {
185             
186             uint days_in = 1 + (now - milestones.p2) / 1 days; 
187             return BASE_PRICE - days_in * 25 / 7;  // daily decrease 3.5
188         }
189 
190         if (now >= milestones.p3 && now < milestones.p4) {
191         
192             return MID_PRICE;
193         }
194         
195         if (now >= milestones.p4 && now < milestones.p5) {
196             
197             days_in = 1 + (now - milestones.p4) / 1 days; 
198             return MID_PRICE - days_in * 25 / 7;  // daily decrease 3.5
199         }
200 
201         if (now >= milestones.p5 && now < milestones.p6) {
202         
203             return FIN_PRICE;
204         }
205         
206         if (now >= milestones.p6){
207 
208             return 0;
209         }
210 
211      }
212     
213     /**
214      * Returns total stored HKG amount.
215      * 
216      * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
217      * Thus, result of this function should be divided by 1000 to get HKG value
218      * 
219      * @return result stored HKG amount
220      */
221     function getTotalSupply() constant returns (uint result) {
222         return totalSupply;
223     } 
224 
225     /**
226      * It is used for test purposes.
227      * 
228      * Returns the result of 'now' statement of Solidity language
229      * 
230      * @return unix timestamp for current moment in time
231      */
232     function getNow() constant returns (uint result) {
233         return now;
234     }
235 
236     /**
237      * Returns total value passed through the contract
238      * 
239      * @return result total value in wei
240      */
241     function getTotalValue() constant returns (uint result) {
242         return totalValue;  
243     }
244 }