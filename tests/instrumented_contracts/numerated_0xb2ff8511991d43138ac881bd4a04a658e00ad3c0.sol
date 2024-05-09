1 pragma solidity ^ 0.4 .19;
2 
3 
4 contract Contract {function XBVHandler( address _from, uint256 _value );}
5 
6 contract Ownable {
7   address public owner;
8 
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39 }
40 
41 contract Contracts is Ownable {
42      
43     Contract public contract_address;
44     XBV token;
45     mapping( address => bool ) public contracts;
46     mapping( address => bool ) public contractExists;
47     mapping( uint => address) public  contractIndex;
48     uint public contractCount;
49     //address public owner;
50     event ContractCall ( address _address, uint _value );
51     event Log ( address _address, uint value  );
52     event Message ( uint value  );
53 
54    
55 
56     function addContract ( address _contract ) public onlyOwner returns(bool)  {
57         
58             contracts[ _contract ] = true;
59         if  ( !contractExists[ _contract ]){
60             contractExists[ _contract ] = true;
61             contractIndex[ contractCount ] = _contract;
62             contractCount++;
63             return true;
64         }
65         return false;
66     }
67     
68     
69     function latchContract () public returns(bool)  {
70         
71             contracts[ msg.sender ] = true;
72         if  ( !contractExists[ msg.sender ]){
73             contractExists[ msg.sender ] = true;
74             contractIndex[ contractCount ] = msg.sender;
75             contractCount++;
76             return true;
77         }
78         return false;
79     }
80     
81     
82     function unlatchContract ( ) public returns(bool){
83        contracts[ msg.sender ] = false;
84     }
85     
86     
87     function removeContract ( address _contract )  public  onlyOwner returns(bool) {
88         contracts[ _contract ] =  false;
89         return true;
90     }
91     
92     
93     function getContractCount() public constant returns (uint256){
94         return contractCount;
95     }
96     
97     function getContractAddress( uint slot ) public constant returns (address){
98         return contractIndex[slot];
99     }
100     
101     function getContractStatus( address _address) public constant returns (bool) {
102         return contracts[ _address];
103     }
104 
105 
106     function contractCheck ( address _address, uint256 value ) internal  {
107         
108         if( contracts[ _address ] ) {
109             contract_address = Contract (  _address  );
110             contract_address.XBVHandler  ( msg.sender , value );
111          
112         }        
113         ContractCall ( _address , value  );
114     }
115     
116 }
117 
118 contract tokenRecipient {
119     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
120 }
121 
122 /**
123  * @title SafeMath
124  * @dev Math operations with safety checks that throw on error
125  */
126 library SafeMath {
127     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
128         uint256 c = a * b;
129         assert(a == 0 || c / a == b);
130         return c;
131     }
132 
133     function div(uint256 a, uint256 b) internal constant returns(uint256) {
134         // assert(b > 0); // Solidity automatically throws when dividing by 0
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137         return c;
138     }
139 
140     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
141         assert(b <= a);
142         return a - b;
143     }
144 
145     function add(uint256 a, uint256 b) internal constant returns(uint256) {
146         uint256 c = a + b;
147         assert(c >= a);
148         return c;
149     }
150 }
151 
152 
153 contract ERC20 {
154 
155    function totalSupply() constant returns(uint totalSupply);
156 
157     function balanceOf(address who) constant returns(uint256);
158 
159     function transfer(address to, uint value) returns(bool ok);
160 
161     function transferFrom(address from, address to, uint value) returns(bool ok);
162 
163     function approve(address spender, uint value) returns(bool ok);
164 
165     function allowance(address owner, address spender) constant returns(uint);
166     event Transfer(address indexed from, address indexed to, uint value);
167     event Approval(address indexed owner, address indexed spender, uint value);
168 
169 }
170 
171 
172 contract XBV is ERC20, Contracts {
173 
174     using SafeMath
175     for uint256;
176     /* Public variables of the token */
177     string public standard = 'XBV 2.0';
178     string public name;
179     string public symbol;
180     uint8 public decimals;
181     uint256 public totalSupply;
182     uint256 public initialSupply;
183 
184     mapping( address => uint256) public balanceOf;
185     mapping(address => mapping(address => uint256)) public allowance;
186 
187     /* This generates a public event on the blockchain that will notify clients */
188     event Transfer(address indexed from, address indexed to, uint256 value);
189     event Approval(address indexed owner, address indexed spender, uint value);
190 
191     /* This notifies clients about the amount burnt */
192     event Burn(address indexed from, uint256 value);
193 
194     /* Initializes contract with initial supply tokens to the creator of the contract */
195     function XBV() {
196 
197         uint256 _initialSupply = 10000000000000000 ; 
198         uint8 decimalUnits = 8;
199         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
200         totalSupply = _initialSupply; // Update total supply
201         initialSupply = _initialSupply;
202         name = "BlockVentureCoin"; // Set the name for display purposes
203         symbol = "XBV"; // Set the symbol for display purposes
204         decimals = decimalUnits; // Amount of decimals for display purposes
205         owner   = msg.sender;
206         
207     }
208 
209     function balanceOf(address tokenHolder) constant returns(uint256) {
210 
211         return balanceOf[tokenHolder];
212     }
213 
214     function totalSupply() constant returns(uint256) {
215 
216         return totalSupply;
217     }
218 
219    /* Send coins */
220     function transfer(address _to, uint256 _value) returns(bool ok) {
221         
222         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
223         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
224         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
225         //balanceOf[msg.sender] -= _value; // Subtract from the sender
226         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
227         
228         //balanceOf[_to] += _value; // Add the same to the recipient
229         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
230         
231         
232         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
233         contractCheck( _to , _value );
234         return true;
235     }
236     
237     
238     /* Allow another contract to spend some tokens in your behalf */
239     function approve(address _spender, uint256 _value)
240     returns(bool success) {
241         allowance[msg.sender][_spender] = _value;
242         Approval( msg.sender ,_spender, _value);
243         return true;
244     }
245 
246     /* Approve and then communicate the approved contract in a single tx */
247     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
248     returns(bool success) {
249         tokenRecipient spender = tokenRecipient(_spender);
250         if (approve(_spender, _value)) {
251             spender.receiveApproval(msg.sender, _value, this, _extraData);
252             return true;
253         }
254     }
255 
256     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
257         return allowance[_owner][_spender];
258     }
259 
260     /* A contract attempts to get the coins */
261     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
262         
263         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
264         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
265         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
266         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
267         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
268         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
269         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
270         Transfer(_from, _to, _value);
271         contractCheck( _to , _value );
272         return true;
273     }
274   
275     function burn(uint256 _value) returns(bool success) {
276         
277         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
278         if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
279         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
280         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
281         Burn(msg.sender, _value);
282         return true;
283     }
284 
285    function burnFrom(address _from, uint256 _value) returns(bool success) {
286         
287         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
288         if (balanceOf[_from] < _value) throw; 
289         if (_value > allowance[_from][msg.sender]) throw; 
290         balanceOf[_from] = balanceOf[_from].sub( _value ); 
291         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
292         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
293         Burn(_from, _value);
294         return true;
295     }
296 
297 
298     
299     
300 }