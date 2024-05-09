1 //      IKB TOKEN
2 //      By Mitchell F. Chan
3 
4 
5 /*
6 OVERVIEW:
7     This contract manages the purchase and transferral of Digital Zones of Immaterial Pictorial Sensibility.
8     It reproduces the rules originally created by Yves Klein which governed the transferral of his original Zones of Immaterial Pictorial Sensibility.
9 
10     The project is described in full in the Blue Paper included in this repository.
11 */
12 
13 pragma solidity ^0.4.15;
14 
15 // interface for ERC20 standard token
16 contract ERC20 {
17     function totalSupply() constant returns (uint256 currentSupply);
18     function balanceOf(address _owner) public constant returns (uint256 balance);
19     function transfer(address _to, uint256 _value) returns (bool success);
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21     function approve(address _spender, uint256 _value) returns (bool success);
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27 //  token boilerplate
28 contract owned {
29     address public owner;
30 
31     function owned() {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner {
41         owner = newOwner;
42     }
43 }
44 
45 // library for math to prevent underflows and overflows
46 contract SafeMath {
47 
48   function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
49       uint256 z = x + y;
50       assert((z >= x) && (z >= y));
51       return z;
52   }
53 
54   function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
55       assert(x >= y);
56       uint256 z = x - y;
57       return z;
58   }
59 
60   function safeMult(uint256 x, uint256 y) internal returns(uint256) {
61       uint256 z = x * y;
62       assert((x == 0) || (z / x == y));
63       return z;
64   }
65 }
66 
67 contract Klein is ERC20, owned, SafeMath {
68     
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     mapping (address => mapping (address => mapping (uint256 => bool))) specificAllowed;
72     
73                                                                     // The Swarm address of the artwork is saved here for reference and posterity
74     string public constant zonesSwarmAddress = "0a52f265d8d60a89de41a65069fa472ac3b130c269b4788811220b6546784920";
75     address public constant theRiver = 0x8aDE9bCdA847852DE70badA69BBc9358C1c7B747;                      // ROPSTEN REVIVAL address
76     string public constant name = "Digital Zone of Immaterial Pictorial Sensibility";
77     string public constant symbol = "IKB";
78     uint256 public constant decimals = 0;
79     uint256 public maxSupplyPossible;
80     uint256 public initialPrice = 10**17;                              // should equal 0.1 ETH
81     uint256 public currentSeries;    
82     uint256 public issuedToDate;
83     uint256 public totalSold;
84     uint256 public burnedToDate;
85     bool first = true;
86                                                                     // IKB are issued in tranches, or series of editions. There will be 8 total
87                                                                     // Each IBKSeries represents one of Klein's receipt books, or a series of issued tokens.
88     struct IKBSeries {
89         uint256 price;
90         uint256 seriesSupply;
91     }
92 
93     IKBSeries[8] public series;                                     // An array of all 8 series
94 
95     struct record {
96         address addr;
97         uint256 price;
98         bool burned;
99     }
100 
101     record[101] public records;                                     // An array of all 101 records
102     
103     event UpdateRecord(uint indexed IKBedition, address holderAddress, uint256 price, bool burned);
104     event SeriesCreated(uint indexed seriesNum);
105     event SpecificApproval(address indexed owner, address indexed spender, uint256 indexed edition);
106     
107     function Klein() {
108         currentSeries = 0;
109         series[0] = IKBSeries(initialPrice, 31);                    // the first series has unique values...
110     
111         for(uint256 i = 1; i < series.length; i++){                    // ...while the next 7 can be defined in a for loop
112             series[i] = IKBSeries(series[i-1].price*2, 10);
113         }     
114         
115         maxSupplyPossible = 101;
116     }
117     
118     function() payable {
119         buy();
120     }
121 
122     function balanceOf(address _owner) constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126     function approve(address _spender, uint256 _value) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131     
132     function specificApprove(address _spender, uint256 _edition) returns (bool success) {
133         specificAllowed[msg.sender][_spender][_edition] = true;
134         SpecificApproval(msg.sender, _spender, _edition);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142     // NEW: I thought it was more in keeping with what totalSupply() is supposed to be about to return how many tokens are currently in circulation
143     function totalSupply() constant returns (uint _currentSupply) {
144       return (issuedToDate - burnedToDate);
145     }
146 
147     function issueNewSeries() onlyOwner returns (bool success){
148         require(balances[this] <= 0);                            //can only issue a new series if you've sold all the old ones
149         require(currentSeries < 7);
150         
151         if(!first){
152             currentSeries++;                                        // the first time we run this function, don't run up the currentSeries counter. Keep it at 0
153         } else if (first){
154             first=false;                                            // ...but only let this work once.
155         } 
156          
157         balances[this] = safeAdd(balances[this], series[currentSeries].seriesSupply);
158         issuedToDate = safeAdd(issuedToDate, series[currentSeries].seriesSupply);
159         SeriesCreated(currentSeries);
160         return true;
161     }
162     
163     function buy() payable returns (bool success){
164         require(balances[this] > 0);
165         require(msg.value >= series[currentSeries].price);
166         uint256 amount = msg.value / series[currentSeries].price;      // calculates the number of tokens the sender will buy
167         uint256 receivable = msg.value;
168         if (balances[this] < amount) {                              // this section handles what happens if someone tries to buy more than the currently available supply
169             receivable = safeMult(balances[this], series[currentSeries].price);
170             uint256 returnable = safeSubtract(msg.value, receivable);
171             amount = balances[this];
172             msg.sender.transfer(returnable);             
173         }
174         
175         if (receivable % series[currentSeries].price > 0) assert(returnChange(receivable));
176         
177         balances[msg.sender] = safeAdd(balances[msg.sender], amount);                             // adds the amount to buyer's balance
178         balances[this] = safeSubtract(balances[this], amount);      // subtracts amount from seller's balance
179         Transfer(this, msg.sender, amount);                         // execute an event reflecting the change
180 
181         for(uint k = 0; k < amount; k++){                           // now let's make a record of every sale
182             records[totalSold] = record(msg.sender, series[currentSeries].price, false);
183             totalSold++;
184         }
185         
186         return true;                                   // ends function and returns
187     }
188 
189     function returnChange(uint256 _receivable) internal returns (bool success){
190         uint256 change = _receivable % series[currentSeries].price;
191         msg.sender.transfer(change);
192         return true;
193     }
194                                                                     // when this function is called, the caller is transferring any number of tokens. The function automatically chooses the tokens with the LOWEST index to transfer.
195     function transfer(address _to, uint _value) returns (bool success) {
196         require(balances[msg.sender] >= _value);
197         require(_value > 0); 
198         uint256 recordsChanged = 0;
199 
200         for(uint k = 0; k < records.length; k++){                 // go through every record
201             if(records[k].addr == msg.sender && recordsChanged < _value) {
202                 records[k].addr = _to;                            // change the address associated with this record
203                 recordsChanged++;                                 // keep track of how many records you've changed in this transfer. After you've changed as many records as there are tokens being transferred, conditions of this loop will cease to be true.
204                 UpdateRecord(k, _to, records[k].price, records[k].burned);
205             }
206         }
207 
208         balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
209         balances[_to] = safeAdd(balances[_to], _value);
210         Transfer(msg.sender, _to, _value);
211         return true;
212     }
213     
214     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
215         require(balances[_from] >= _value); 
216         require(allowed[_from][msg.sender] >= _value); 
217         require(_value > 0);
218         uint256 recordsChanged = 0;
219         
220         for(uint256 k = 0; k < records.length; k++){                 // go through every record
221             if(records[k].addr == _from && recordsChanged < _value) {
222                 records[k].addr = _to;                            // change the address associated with this record
223                 recordsChanged++;                                 // keep track of how many records you've changed in this transfer. After you've changed as many records as there are tokens being transferred, conditions of this loop will cease to be true.
224                 UpdateRecord(k, _to, records[k].price, records[k].burned);
225             }
226         }
227         
228         balances[_from] = safeSubtract(balances[_from], _value);
229         allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
230         balances[_to] = safeAdd(balances[_to], _value); 
231         Transfer(_from, _to, _value);
232         return true;     
233     }   
234                                                                     // when this function is called, the caller is transferring only 1 IKB to another account, and specifying exactly which token they would like to transfer.
235     function specificTransfer(address _to, uint _edition) returns (bool success) {
236         require(balances[msg.sender] > 0);
237         require(records[_edition].addr == msg.sender); 
238         balances[msg.sender] = safeSubtract(balances[msg.sender], 1);
239         balances[_to] = safeAdd(balances[_to], 1);
240         records[_edition].addr = _to;                           // update the records so that the record shows this person owns the 
241         
242         Transfer(msg.sender, _to, 1);
243         UpdateRecord(_edition, _to, records[_edition].price, records[_edition].burned);
244         return true;
245     }
246     
247     function specificTransferFrom(address _from, address _to, uint _edition) returns (bool success){
248         require(balances[_from] > 0);
249         require(records[_edition].addr == _from);
250         require(specificAllowed[_from][msg.sender][_edition]);
251         balances[_from] = safeSubtract(balances[_from], 1);
252         balances[_to] = safeAdd(balances[_to], 1);
253         specificAllowed[_from][msg.sender][_edition] = false;
254         records[_edition].addr = _to;                           // update the records so that the record shows this person owns the 
255         
256         Transfer(msg.sender, _to, 1);
257         UpdateRecord(_edition, _to, records[_edition].price, records[_edition].burned);
258         return true;
259     }
260                                                                     // a quick way to figure out who holds a specific token without querying the whole record. This might actually be redundant.
261     function getTokenHolder(uint searchedRecord) public constant returns(address){
262         return records[searchedRecord].addr;
263     }
264     
265     function getHolderEditions(address _holder) public constant returns (uint256[] _editions) {
266         uint256[] memory editionsOwned = new uint256[](balances[_holder]);
267         uint256 index;
268         for(uint256 k = 0; k < records.length; k++) {
269             if(records[k].addr == _holder) {
270                 editionsOwned[index] = k;
271                 index++;
272             }
273         }
274         return editionsOwned;
275     }
276                                                                     // allows the artist to withdraw ether from the contract
277     function redeemEther() onlyOwner returns (bool success) {
278         owner.transfer(this.balance);  
279         return true;
280     }
281                                                                     // allows the artist to put ether back in the contract so that holders can execute the ritual function
282     function fund() payable onlyOwner returns (bool success) {
283         return true;
284     }
285     
286     function ritual(uint256 _edition) returns (bool success){
287         require(records[_edition].addr == msg.sender); 
288         require(!records[_edition].burned);
289         uint256 halfTheGold = records[_edition].price / 2;
290         require(this.balance >= halfTheGold);
291         
292         records[_edition].addr = 0xdead;
293         records[_edition].burned = true;
294         burnedToDate++;
295         balances[msg.sender] = safeSubtract(balances[msg.sender], 1);
296         theRiver.transfer(halfTheGold);                             // call should fail if this contract isn't holding enough ETH
297         return true;
298     }
299 }