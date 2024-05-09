1 pragma solidity ^0.4.18;
2 
3 // Potatoin (or potato coin) is the first of its kind, virtualized vegetable
4 // crypto-asset resistant to the inevitable crash of the world economy!
5 contract Potatoin {
6     // name, symbol and decimals implement the ERC20 token standard.
7     string public constant name     = "Potatoin";
8     string public constant symbol   = "POIN";
9     uint8  public constant decimals = 0;
10 
11     // genesis and relief define the start and duration of the potato relief
12     // organized by the Potatoin foundation.
13     uint public genesis;
14     uint public relief;
15 
16     // donated contains the addresses the foundation already donated to.
17     mapping(address => uint) public donated;
18 
19     // rot and grow contains the time intervals in which unsowed potatoes rot
20     // away and sowed potatoes double.
21     uint public decay;
22     uint public growth;
23 
24     // farmers, cellars and recycled track the current unsowed potatoes owned by
25     // individual famers and the last time rotten ones were recycled.
26     address[]                farmers;
27     mapping(address => uint) cellars;
28     mapping(address => uint) trashes;
29     mapping(address => uint) recycled;
30 
31     // field and fields define the potato fields owned by individual famers,
32     // along with the number of potatoes in them and the sowing time/
33     struct field {
34         uint potatoes;
35         uint sowed;
36     }
37     mapping(address => field[]) public fields;
38     mapping(address => uint)    public empties;
39 
40     // Transfer implements ERC20, raising a token transfer event.
41     event Transfer(address indexed _from, address indexed _to, uint _value);
42 
43     // Potatoin is the Potatoin foundation constructor. It configures the potato
44     // relief and sets up the organizational oversight.
45     function Potatoin(uint256 _relief, uint256 _decay, uint256 _growth) public {
46         genesis = block.timestamp;
47         relief  = _relief;
48         decay   = _decay;
49         growth  = _growth;
50     }
51 
52     // totalSupply returns the total number of potatoes owned by all people,
53     // taking into consideration those that already rotted away.
54     function totalSupply() constant public returns (uint totalSupply) {
55         for (uint i = 0; i < farmers.length; i++) {
56             totalSupply += balanceOf(farmers[i]);
57         }
58         return totalSupply;
59     }
60 
61     // balanceOf returns the current number of potatoes owned by a particular
62     // account, taking into consideration those that already rotted away.
63     function balanceOf(address farmer) constant public returns (uint256 balance) {
64        return unsowed(farmer) + sowed(farmer);
65     }
66 
67     // unsowed returns the current number of unsowed potatoes owned by a farmer,
68     // taking into consideration those that already rotted away.
69     function unsowed(address farmer) constant public returns (uint256 balance) {
70         // Retrieve the number of non-rotten potatoes from the cellar
71         var elapsed = block.timestamp - recycled[farmer];
72         if (elapsed < decay) {
73             balance = (cellars[farmer] * (decay - elapsed) + decay-1) / decay;
74         }
75         // Retrieve the number of non-rotten potatoes from the fields
76         var list = fields[farmer];
77         for (uint i = empties[farmer]; i < list.length; i++) {
78             elapsed = block.timestamp - list[i].sowed;
79             if (elapsed >= growth && elapsed - growth < decay) {
80                 balance += (2 * list[i].potatoes * (decay-elapsed+growth) + decay-1) / decay;
81             }
82         }
83         return balance;
84     }
85 
86     // sowed returns the current number of sowed potatoes owned by a farmer,
87     // taking into consideration those that are currently growing.
88     function sowed(address farmer) constant public returns (uint256 balance) {
89         var list = fields[farmer];
90         for (uint i = empties[farmer]; i < list.length; i++) {
91             // If the potatoes are fully grown, assume the field harvested
92             var elapsed = block.timestamp - list[i].sowed;
93             if (elapsed >= growth) {
94                 continue;
95             }
96             // Otherwise calculate the number of potatoes "in the making"
97             balance += list[i].potatoes + list[i].potatoes * elapsed / growth;
98         }
99         return balance;
100     }
101 
102     // trashed returns the number of potatoes owned by a farmer that rot away,
103     // taking into consideration the current storage and fields too.
104     function trashed(address farmer) constant public returns (uint256 balance) {
105         // Start with all the accounted for trash
106         balance = trashes[farmer];
107 
108         // Calculate the rotten potatoes from storage
109         var elapsed = block.timestamp - recycled[farmer];
110         if (elapsed >= 0) {
111             var rotten = cellars[farmer];
112             if (elapsed < decay) {
113                rotten = cellars[farmer] * elapsed / decay;
114             }
115             balance += rotten;
116         }
117         // Calculate the rotten potatoes from the fields
118         var list = fields[farmer];
119         for (uint i = empties[farmer]; i < list.length; i++) {
120             elapsed = block.timestamp - list[i].sowed;
121             if (elapsed >= growth) {
122                 rotten = 2 * list[i].potatoes;
123                 if  (elapsed - growth < decay) {
124                     rotten = 2 * list[i].potatoes * (elapsed - growth) / decay;
125                 }
126                 balance += rotten;
127             }
128         }
129         return balance;
130     }
131 
132     // request asks the Potatoin foundation for a grant of one potato. Potatoes
133     // are available only during the initial hunger relief phase.
134     function request() public {
135         // Farmers can only request potatoes during the relieve, one per person
136         require(block.timestamp < genesis + relief);
137         require(donated[msg.sender] == 0);
138 
139         // Farmer is indeed a new one, grant its potato
140         donated[msg.sender] = block.timestamp;
141 
142         farmers.push(msg.sender);
143         cellars[msg.sender] = 1;
144         recycled[msg.sender] = block.timestamp;
145 
146         Transfer(this, msg.sender, 1);
147     }
148 
149     // sow creates a new potato field with the requested number of potatoes in
150     // it, doubling after the growing period ends. If the farmer doesn't have
151     // the requested amount of potatoes, all existing ones will be sowed.
152     function sow(uint potatoes) public {
153         // Harvest any ripe fields
154         harvest(msg.sender);
155 
156         // Make sure we have a meaningful amount to sow
157         if (potatoes == 0) {
158             return;
159         }
160         // If any potatoes are left for the farmer, sow them
161         if (cellars[msg.sender] > 0) {
162             if (potatoes > cellars[msg.sender]) {
163                 potatoes = cellars[msg.sender];
164             }
165             fields[msg.sender].push(field(potatoes, block.timestamp));
166             cellars[msg.sender] -= potatoes;
167 
168             Transfer(msg.sender, this, potatoes);
169         }
170     }
171 
172     // harvest gathers all the potatoes of a user that have finished growing.
173     // Any rotten ones are deduced from the final counter. The potatoes in the
174     // cellar are also accounted for.
175     function harvest(address farmer) internal {
176         // Recycle any rotted away potatoes to update the recycle timer
177         recycle(farmer);
178 
179         // Harvest all the ripe fields
180         var list = fields[farmer];
181         for (uint i = empties[farmer]; i < list.length; i++) {
182             var elapsed = block.timestamp - list[i].sowed;
183             if (elapsed >= growth) {
184                 if (elapsed - growth < decay) {
185                     var harvested = (2 * list[i].potatoes * (decay-elapsed+growth) + decay-1) / decay;
186                     var rotten    = 2 * list[i].potatoes - harvested;
187 
188                     cellars[farmer] += harvested;
189                     Transfer(this, farmer, harvested);
190 
191                     if (rotten > 0) {
192                         trashes[farmer] += rotten;
193                         Transfer(this, 0, rotten);
194                     }
195                 } else {
196                     trashes[farmer] += 2 * list[i].potatoes;
197                     Transfer(this, 0, 2 * list[i].potatoes);
198                 }
199                 empties[farmer]++;
200             }
201         }
202         // If all the fields were harvested, rewind the accumulators
203         if (empties[farmer] > 0 && empties[farmer] == list.length) {
204             delete empties[farmer];
205             delete fields[farmer];
206         }
207     }
208 
209     // recycle throws away the potatoes of a user that rotted away.
210     function recycle(address farmer) internal {
211         var elapsed = block.timestamp - recycled[farmer];
212         if (elapsed == 0) {
213             return;
214         }
215         var rotten = cellars[farmer];
216         if (elapsed < decay) {
217            rotten = cellars[farmer] * elapsed / decay;
218         }
219         if (rotten > 0) {
220             cellars[farmer] -= rotten;
221             trashes[farmer] += rotten;
222 
223             Transfer(farmer, 0, rotten);
224         }
225         recycled[farmer] = block.timestamp;
226     }
227 
228     // transfer forwards a number of potatoes to the requested address.
229     function transfer(address to, uint potatoes) public returns (bool success) {
230         // Harvest own ripe fields and make sure we can transfer
231         harvest(msg.sender);
232         if (cellars[msg.sender] < potatoes) {
233             return false;
234         }
235         // Recycle the remote rotten ones and execute the transfre
236         recycle(to);
237         cellars[msg.sender] -= potatoes;
238         cellars[to]         += potatoes;
239 
240         Transfer(msg.sender, to, potatoes);
241         return true;
242     }
243 
244     // transferFrom implements ERC20, but is forbidden.
245     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
246         return false;
247     }
248 
249     // approve implements ERC20, but is forbidden.
250     function approve(address _spender, uint _value) returns (bool success) {
251         return false;
252     }
253 
254     // allowance implements ERC20, but is forbidden.
255     function allowance(address _owner, address _spender) constant returns (uint remaining) {
256         return 0;
257     }
258 }