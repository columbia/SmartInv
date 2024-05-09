1 pragma solidity ^0.4.24;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Name of the project: JeiCoin Gold Token
7  * BiJust
8  * Ethernity.live
9 *
10  * v1.5
11  *
12  *********************************************************************************
13  ********************************************************************************/
14 
15  /* ERC20 contract interface */
16 
17 contract ERC20Basic {
18     uint256 public totalSupply;
19     function balanceOf(address who) constant returns (uint256);
20     function transfer(address to, uint256 value) returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 
25 // The Token. A TokenWithDates ERC20 token
26 contract JeiCoinToken {
27 
28     // Token public variables
29     string public name;
30     string public symbol;
31     uint8 public decimals; 
32     string public version = 'v1.5';
33     uint256 public totalSupply;
34     uint public price;
35     bool public locked;
36     uint multiplier;
37 
38     address public rootAddress;
39     address public Owner;
40 
41     mapping(address => uint256) public balances;
42     mapping(address => mapping(address => uint256)) public allowed;
43     mapping(address => bool) public freezed;
44 
45     mapping(address => uint) public maxIndex; // To store index of last batch: points to the next one
46     mapping(address => uint) public minIndex; // To store index of first batch
47     mapping(address => mapping(uint => Batch)) public batches; // To store batches with quantities and ages
48 
49     struct Batch {
50         uint quant;
51         uint age;
52     }
53 
54     // ERC20 events
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58 
59     // Modifiers
60 
61     modifier onlyOwner() {
62         if ( msg.sender != rootAddress && msg.sender != Owner ) revert();
63         _;
64     }
65 
66     modifier onlyRoot() {
67         if ( msg.sender != rootAddress ) revert();
68         _;
69     }
70 
71     modifier isUnlocked() {
72     	if ( locked && msg.sender != rootAddress && msg.sender != Owner ) revert();
73 		_;    	
74     }
75 
76     modifier isUnfreezed(address _to) {
77     	if ( freezed[msg.sender] || freezed[_to] ) revert();
78     	_;
79     }
80 
81     // Safe math
82     function safeSub(uint x, uint y) pure internal returns (uint z) {
83         require((z = x - y) <= x);
84     }
85 
86 
87     // Token constructor
88     constructor(address _root) {        
89         locked = false;
90         name = 'JeiCoin Gold'; 
91         symbol = 'JEIG'; 
92         decimals = 18; 
93         multiplier = 10 ** uint(decimals);
94         totalSupply = 63000000 * multiplier; // 63,000,000 tokens
95         if (_root != 0x0) rootAddress = _root; else rootAddress = msg.sender;  
96         Owner = msg.sender;
97 
98         // Asign total supply to the balance and to the first batch
99         balances[rootAddress] = totalSupply; 
100         batches[rootAddress][0].quant = totalSupply;
101         batches[rootAddress][0].age = now;
102         maxIndex[rootAddress] = 1;
103     }
104 
105 
106     // Only root function
107 
108     function changeRoot(address _newRootAddress) onlyRoot returns(bool){
109         rootAddress = _newRootAddress;
110         return true;
111     }
112 
113     // Only owner functions
114 
115     // To send ERC20 tokens sent accidentally
116     function sendToken(address _token,address _to , uint _value) onlyOwner returns(bool) {
117         ERC20Basic Token = ERC20Basic(_token);
118         require(Token.transfer(_to, _value));
119         return true;
120     }
121 
122     function changeOwner(address _newOwner) onlyOwner returns(bool) {
123         Owner = _newOwner;
124         return true;
125     }
126        
127     function unlock() onlyOwner returns(bool) {
128         locked = false;
129         return true;
130     }
131 
132     function lock() onlyOwner returns(bool) {
133         locked = true;
134         return true;
135     }
136 
137     function freeze(address _address) onlyOwner returns(bool) {
138         freezed[_address] = true;
139         return true;
140     }
141 
142     function unfreeze(address _address) onlyOwner returns(bool) {
143         freezed[_address] = false;
144         return true;
145     }
146 
147     function burn(uint256 _value) onlyOwner returns(bool) {
148         require (balances[msg.sender] >= _value);
149         balances[msg.sender] = balances[msg.sender] - _value;
150         totalSupply = safeSub( totalSupply,  _value );
151         emit Transfer(msg.sender, 0x0,_value);
152         return true;
153     }
154 
155     // Public token functions
156     // Standard transfer function
157     function transfer(address _to, uint _value) isUnlocked public returns (bool success) {
158         require(msg.sender != _to);
159         if (balances[msg.sender] < _value) return false;
160         if (freezed[msg.sender] || freezed[_to]) return false; // Check if destination address is freezed
161         balances[msg.sender] = balances[msg.sender] - _value;
162         balances[_to] = balances[_to] + _value;
163 
164         updateBatches(msg.sender, _to, _value);
165 
166         emit Transfer(msg.sender,_to,_value);
167         return true;
168         }
169 
170 
171     function transferFrom(address _from, address _to, uint256 _value) isUnlocked public returns(bool) {
172         require(_from != _to);
173         if ( freezed[_from] || freezed[_to] ) return false; // Check if destination address is freezed
174         if ( balances[_from] < _value ) return false; // Check if the sender has enough
175     	if ( _value > allowed[_from][msg.sender] ) return false; // Check allowance
176 
177         balances[_from] = balances[_from] - _value; // Subtract from the sender
178         balances[_to] = balances[_to] + _value; // Add the same to the recipient
179 
180         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
181 
182         updateBatches(_from, _to, _value);
183 
184         emit Transfer(_from,_to,_value);
185         return true;
186     }
187 
188     function approve(address _spender, uint _value) public returns(bool) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194 
195     // Public getters
196 
197     function isLocked() public view returns(bool) {
198         return locked;
199     }
200 
201     function balanceOf(address _owner) public view returns(uint256 balance) {
202         return balances[_owner];
203     }
204 
205     function allowance(address _owner, address _spender) public view returns(uint256) {
206         return allowed[_owner][_spender];
207     }
208 
209 
210     // To read batches from external tokens
211 
212     function getBatch(address _address , uint _batch) public view returns(uint _quant,uint _age) {
213         return (batches[_address][_batch].quant , batches[_address][_batch].age);
214     }
215 
216     function getFirstBatch(address _address) public view returns(uint _quant,uint _age) {
217         return (batches[_address][minIndex[_address]].quant , batches[_address][minIndex[_address]].age);
218     }
219 
220     // Private function to register quantity and age of batches from sender and receiver (TokenWithDates)
221     function updateBatches(address _from,address _to,uint _value) private {
222         // Discounting tokens from batches AT SOURCE
223         uint count = _value;
224         uint i = minIndex[_from];
225          while(count > 0) { // To iterate over the mapping. // && i < maxIndex is just a protection from infinite loop, that should not happen anyways
226             uint _quant = batches[_from][i].quant;
227             if ( count >= _quant ) { // If there is more to send than the batch
228                 // Empty batch and continue counting
229                 count -= _quant; // First rest the batch to the count
230                 batches[_from][i].quant = 0; // Then empty the batch
231                 minIndex[_from] = i + 1;
232                 } else { // If this batch is enough to send everything
233                     // Empty counter and adjust the batch
234                     batches[_from][i].quant -= count; // First adjust the batch, just in case anything rest
235                     count = 0; // Then empty the counter and thus stop loop
236                     }
237             i++;
238         } // Closes while loop
239 
240         // Counting tokens for batches AT TARGET
241         // Prepare struct
242         Batch memory thisBatch;
243         thisBatch.quant = _value;
244         thisBatch.age = now;
245         // Assign batch and move the index
246         batches[_to][maxIndex[_to]] = thisBatch;
247         maxIndex[_to]++;
248     }
249 
250 }