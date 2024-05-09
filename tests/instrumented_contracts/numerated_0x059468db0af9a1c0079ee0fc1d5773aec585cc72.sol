1 pragma solidity ^0.4.11;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36    contract StudioToken  {
37        
38        using SafeMath for uint256;
39     /* Public variables of the token */
40     string public standard = 'Token 0.1';
41     string public name;
42     string public symbol;
43     uint8 public decimals;
44     uint256 public totalSupply;
45    
46     address public owner;
47     bool public pauseForDividend = false;
48     
49     
50     
51 
52     /* This creates an array with all balances */
53     mapping (address => uint256) public balanceOf;
54     mapping ( uint => address ) public accountIndex;
55     uint accountCount;
56     
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     /* This generates a public event on the blockchain that will notify clients */
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     /* This notifies clients about the amount burnt */
63     event Burn(address indexed from, uint256 value);
64 
65     /* Initializes contract with initial supply tokens to the creator of the contract */
66     function StudioToken(
67        ) {
68             
69        uint256 initialSupply = 50000000;
70         uint8 decimalUnits = 0;   
71         appendTokenHolders ( msg.sender );    
72         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
73         totalSupply = initialSupply;                        // Update total supply
74         name = "Studio";                                   // Set the name for display purposes
75         symbol = "STDO";                               // Set the symbol for display purposes
76         decimals = decimalUnits;                            // Amount of decimals for display purposes
77         
78         owner = msg.sender;
79     }
80     
81     function getBalance ( address tokenHolder ) returns (uint256) {
82         return balanceOf[ tokenHolder ];
83     }
84     
85     
86     function getAccountCount ( ) returns (uint256) {
87         return accountCount;
88     }
89     
90     
91     function getAddress ( uint256 slot ) returns ( address ) {
92         return accountIndex[ slot ];
93     }
94     
95     function getTotalSupply ( ) returns (uint256) {
96         return totalSupply;
97     }
98     
99     
100    
101     
102    
103     function appendTokenHolders ( address tokenHolder ) private {
104         
105         if ( balanceOf[ tokenHolder ] == 0 ){ 
106             accountIndex[ accountCount ] = tokenHolder;
107             accountCount++;
108         }
109         
110     }
111     
112 
113     /* Send coins */
114     function transfer(address _to, uint256 _value) {
115         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
116         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
117         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
118         if (  pauseForDividend == true ) throw;// Check for overflows
119         appendTokenHolders ( _to);
120         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
121         balanceOf[_to] += _value;                            // Add the same to the recipient
122         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
123     }
124 
125     /* Allow another contract to spend some tokens in your behalf */
126     function approve(address _spender, uint256 _value)
127         returns (bool success) {
128         allowance[msg.sender][_spender] = _value;
129         return true;
130     }
131 
132     /* Approve and then communicate the approved contract in a single tx */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }        
141 
142     /* A contract attempts to get the coins */
143     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
144         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
145         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
146         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
147         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
148         if (  pauseForDividend == true ) throw;// Check for overflows
149         balanceOf[_from] -= _value;                           // Subtract from the sender
150         balanceOf[_to] += _value;                             // Add the same to the recipient
151         allowance[_from][msg.sender] -= _value;
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function burn(uint256 _value) returns (bool success) {
157         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
158         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
159         totalSupply -= _value;                                // Updates totalSupply
160         Burn(msg.sender, _value);
161         return true;
162     }
163 
164     function burnFrom(address _from, uint256 _value) returns (bool success) {
165         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
166         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
167         balanceOf[_from] -= _value;                          // Subtract from the sender
168         totalSupply -= _value;                               // Updates totalSupply
169         Burn(_from, _value);
170         return true;
171     }
172     
173      modifier onlyOwner {
174         require(msg.sender == owner);
175         _;
176     }
177     
178     
179     
180     
181     function pauseForDividend() onlyOwner{
182         
183         if ( pauseForDividend == true ) pauseForDividend = false; else pauseForDividend = true;
184         
185     }
186     
187     
188     
189     
190     
191     
192     function transferOwnership ( address newOwner) onlyOwner {
193         
194         owner = newOwner;
195         
196         
197     }
198     
199     
200     
201     
202 }
203 
204 
205 contract Dividend {
206     StudioToken studio; // StudioICO contract instance
207     address studio_contract;
208    
209   
210     uint public accountCount;
211     event Log(uint);
212     address owner;
213 
214 
215     uint256 public ether_profit;
216     uint256 public profit_per_token;
217     uint256 holder_token_balance;
218     uint256 holder_profit;
219     
220     
221     
222      mapping (address => uint256) public balanceOf;
223     
224     
225     event Message(uint256 holder_profit);
226     event Transfer(address indexed_from, address indexed_to, uint value);
227 
228     // modifier for owner
229     modifier onlyOwner() {
230         if (msg.sender != owner) {
231             throw;
232         }
233         _;
234     }
235     // constructor which takes address of smart contract
236     function Dividend(address Studiocontract) {
237         owner = msg.sender;
238         studio = StudioToken(Studiocontract);
239     }
240     // unnamed function which takes ether
241     function() payable {
242        
243         studio.pauseForDividend();
244 
245         accountCount = studio.getAccountCount();
246         
247           Log(accountCount);
248 
249             ether_profit = msg.value;
250 
251             profit_per_token = ether_profit / studio.getTotalSupply();
252 
253             Message(profit_per_token);
254         
255         
256         if (msg.sender == owner) {
257             
258             for ( uint i=0; i < accountCount ; i++ ) {
259                
260                address tokenHolder = studio.getAddress(i);
261                balanceOf[ tokenHolder ] +=  studio.getBalance( tokenHolder ) * profit_per_token;
262         
263             }
264             
265           
266 
267           
268             
269         }
270         
271         
272          studio.pauseForDividend();
273     }
274     
275     
276     
277     function withdrawDividends (){
278         
279         
280         msg.sender.transfer(balanceOf[ msg.sender ]);
281         balanceOf[ msg.sender ] = 0;
282         
283         
284     }
285     
286   
287     
288 
289 
290 }