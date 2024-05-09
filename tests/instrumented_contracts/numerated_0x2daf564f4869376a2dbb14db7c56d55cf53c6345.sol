1 pragma solidity ^ 0.4.25;
2 
3 contract ERC223ReceivingContract { 
4 /**
5  * @dev Standard ERC223 function that will handle incoming token transfers.
6  *
7  * @param _from  Token sender address.
8  * @param _value Amount of tokens.
9  * @param _data  Transaction metadata.
10  */
11     function tokenFallback(address _from, uint _value, bytes _data);
12 }
13 
14 
15 contract tokenRecipient {
16     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal constant returns(uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) internal constant returns(uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 contract ERC20 {
51 
52  
53 
54     function transfer(address to, uint value) returns(bool ok);
55 
56     function transferFrom(address from, address to, uint value) returns(bool ok);
57 
58     function approve(address spender, uint value) returns(bool ok);
59 
60     function allowance(address owner, address spender) constant returns(uint);
61     event Transfer(address indexed from, address indexed to, uint value);
62     event Approval(address indexed owner, address indexed spender, uint value);
63 
64 }
65 
66 
67 contract XBV is ERC20  {
68 
69     using SafeMath
70     for uint256;
71     /* Public variables of the token */
72     string public standard = 'XBV 4.0';
73     string public name;
74     string public symbol;
75     uint8 public decimals;
76     uint256 public totalSupply;
77     uint256 public initialSupply;
78     bool initialize;
79     address public owner;
80 
81     mapping( address => uint256) public balanceOf;
82     mapping( address => mapping(address => uint256)) public allowance;
83     
84     mapping( address => bool ) public accountFrozen;
85     
86     mapping( uint256 => address ) public addressesFrozen;
87     uint256 public frozenAddresses;
88     
89     /* This generates a public event on the blockchain that will notify clients */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91     event Transfer(address indexed from, address indexed to, uint value, bytes data);
92     event Approval(address indexed owner, address indexed spender, uint value);
93 
94     /* This notifies clients about the amount burnt */
95     event Burn(address indexed from, uint256 value);
96 
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     /* Initializes contract with initial supply tokens to the creator of the contract */
103     function XBV() {
104 
105         uint256 _initialSupply = 100000000000000000000000000; 
106         uint8 decimalUnits = 18;
107         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
108         totalSupply = _initialSupply; // Update total supply
109         initialSupply = _initialSupply;
110         name = "XBV"; // Set the name for display purposes
111         symbol = "XBV"; // Set the symbol for display purposes
112         decimals = decimalUnits; // Amount of decimals for display purposes
113         owner = msg.sender;
114         
115     }
116 
117    function changeOwner ( address _owner ) onlyOwner {
118        
119        owner = _owner;
120        
121    }
122    
123 
124 
125 
126     
127 
128 
129     function transfer( address _to, uint256 _value ) returns(bool ok) {
130         
131         require ( accountFrozen[ msg.sender ] == false );
132         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
133         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
134         bytes memory empty;
135         
136         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
137         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
138         
139          if(isContract( _to )) {
140             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
141             receiver.tokenFallback(msg.sender, _value, empty);
142         }
143         
144         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
145         return true;
146     }
147     
148      function transfer( address _to, uint256 _value, bytes _data ) returns(bool ok) {
149          
150         require ( accountFrozen[ msg.sender ] == false );
151         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
152         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
153         bytes memory empty;
154         
155         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
156         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
157         
158          if(isContract( _to )) {
159             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
160             receiver.tokenFallback(msg.sender, _value, _data);
161         }
162         
163         Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
164         return true;
165     }
166     
167     
168     
169     function isContract( address _to ) internal returns ( bool ){
170         
171         
172         uint codeLength = 0;
173         
174         assembly {
175             // Retrieve the size of the code on target address, this needs assembly .
176             codeLength := extcodesize(_to)
177         }
178         
179          if(codeLength>0) {
180            
181            return true;
182            
183         }
184         
185         return false;
186         
187     }
188     
189     
190     /* Allow another contract to spend some tokens in your behalf */
191     function approve(address _spender, uint256 _value)
192     returns(bool success) {
193         allowance[msg.sender][_spender] = _value;
194         Approval( msg.sender ,_spender, _value);
195         return true;
196     }
197 
198     /* Approve and then communicate the approved contract in a single tx */
199     function approveAndCall( address _spender, uint256 _value, bytes _extraData )
200     returns(bool success) {
201         tokenRecipient spender = tokenRecipient(_spender);
202         if (approve(_spender, _value)) {
203             spender.receiveApproval(msg.sender, _value, this, _extraData);
204             return true;
205         }
206     }
207 
208     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
209         return allowance[_owner][_spender];
210     }
211 
212     /* A contract attempts to get the coins */
213     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
214         
215         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
216         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
217         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
218         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
219         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
220         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
221         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
222         Transfer(_from, _to, _value);
223         return true;
224     }
225   
226     function burn(uint256 _value) returns(bool success) {
227         
228         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
229         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
230         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
231         Burn(msg.sender, _value);
232         return true;
233     }
234 
235    function burnFrom(address _from, uint256 _value) returns(bool success) {
236         
237         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
238         if (balanceOf[_from] < _value) throw; 
239         if (_value > allowance[_from][msg.sender]) throw; 
240         balanceOf[_from] = balanceOf[_from].sub( _value ); 
241         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
242         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
243         Burn(_from, _value);
244         return true;
245     }
246     
247     function mintXBV ( uint256 _amount ) onlyOwner {
248         
249          
250          assert ( _amount > 0 );
251          uint256 tokens = _amount *(10**18);
252          balanceOf[msg.sender] = balanceOf[msg.sender].add( tokens );
253     
254         
255     }
256     
257     function  freezeAccount ( address _address ) onlyOwner {
258         
259         frozenAddresses++;
260         accountFrozen [ _address ] = true;
261         addressesFrozen[ frozenAddresses ] = _address;
262         
263     }
264 
265     function  unfreezeAccount ( address _address ) onlyOwner {
266         
267         accountFrozen [ _address ] = false;
268         
269     }
270 
271     
272     
273 }