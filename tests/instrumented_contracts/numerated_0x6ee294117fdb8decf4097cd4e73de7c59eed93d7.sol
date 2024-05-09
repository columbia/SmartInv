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
72     string public standard = 'XBV 5.0';
73     string public name;
74     string public symbol;
75     uint8 public decimals;
76     uint256 public totalSupply;
77     uint256 public initialSupply;
78     bool initialize;
79     address public owner;
80     bool public gonePublic;
81 
82     mapping( address => uint256) public balanceOf;
83     mapping( address => mapping(address => uint256)) public allowance;
84     
85     mapping( address => bool ) public accountFrozen;
86     
87     mapping( uint256 => address ) public addressesFrozen;
88     uint256 public frozenAddresses;
89     
90     /* This generates a public event on the blockchain that will notify clients */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Transfer(address indexed from, address indexed to, uint value, bytes data);
93     event Approval(address indexed owner, address indexed spender, uint value);
94     event Mint(address indexed owner,  uint value);
95     
96     /* This notifies clients about the amount burnt */
97     event Burn(address indexed from, uint256 value);
98 
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103 
104     /* Initializes contract with initial supply tokens to the creator of the contract */
105     function XBV() {
106 
107         uint256 _initialSupply = 100000000000000000000000000; 
108         uint8 decimalUnits = 18;
109         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
110         totalSupply = _initialSupply; // Update total supply
111         initialSupply = _initialSupply;
112         name = "XBV"; // Set the name for display purposes
113         symbol = "XBV"; // Set the symbol for display purposes
114         decimals = decimalUnits; // Amount of decimals for display purposes
115         owner = msg.sender;
116         gonePublic = false;
117         
118     }
119 
120    function changeOwner ( address _owner ) public onlyOwner {
121        
122        owner = _owner;
123        
124    }
125    
126    
127    function goPublic() public onlyOwner {
128        
129        gonePublic == true;
130        
131    }
132 
133     function transfer( address _to, uint256 _value ) returns(bool ok) {
134         
135         require ( accountFrozen[ msg.sender ] == false );
136         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
137         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
138         bytes memory empty;
139         
140         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
141         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
142         
143          if(isContract( _to )) {
144             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
145             receiver.tokenFallback(msg.sender, _value, empty);
146         }
147         
148         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
149         return true;
150     }
151     
152     function transfer( address _to, uint256 _value, bytes _data ) returns(bool ok) {
153          
154         require ( accountFrozen[ msg.sender ] == false );
155         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
156         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
157         bytes memory empty;
158         
159         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
160         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
161         
162          if(isContract( _to )) {
163             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
164             receiver.tokenFallback(msg.sender, _value, _data);
165         }
166         
167         Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
168         return true;
169     }
170     
171     
172     
173     function isContract( address _to ) internal returns ( bool ){
174         
175         uint codeLength = 0;
176         assembly {
177             // Retrieve the size of the code on target address, this needs assembly .
178             codeLength := extcodesize(_to)
179         }
180         
181          if(codeLength>0) {
182            return true;
183         }
184         return false;
185         
186     }
187     
188     
189     /* Allow another contract to spend some tokens in your behalf */
190     function approve(address _spender, uint256 _value)
191     returns(bool success) {
192         allowance[msg.sender][_spender] = _value;
193         Approval( msg.sender ,_spender, _value);
194         return true;
195     }
196 
197     /* Approve and then communicate the approved contract in a single tx */
198     function approveAndCall( address _spender, uint256 _value, bytes _extraData )
199     returns(bool success) {
200         tokenRecipient spender = tokenRecipient(_spender);
201         if (approve(_spender, _value)) {
202             spender.receiveApproval(msg.sender, _value, this, _extraData);
203             return true;
204         }
205     }
206 
207     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
208         return allowance[_owner][_spender];
209     }
210 
211     /* A contract attempts to get the coins */
212     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
213         
214         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
215         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
216         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
217         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
218         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
219         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
220         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
221         Transfer(_from, _to, _value);
222         return true;
223     }
224   
225     function burn(uint256 _value) returns(bool success) {
226         
227         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
228         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
229         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
230         Burn(msg.sender, _value);
231         return true;
232     }
233 
234    function burnFrom(address _from, uint256 _value) returns(bool success) {
235         
236         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
237         if (balanceOf[_from] < _value) throw; 
238         if (_value > allowance[_from][msg.sender]) throw; 
239         balanceOf[_from] = balanceOf[_from].sub( _value ); 
240         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
241         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
242         Burn(_from, _value);
243         return true;
244     }
245     
246     function mintXBV ( uint256 _amount ) onlyOwner {
247         
248          assert ( _amount > 0 );
249          assert ( gonePublic == false );
250          uint256 tokens = _amount *(10**18);
251          balanceOf[msg.sender] = balanceOf[msg.sender].add( tokens );
252          totalSupply = totalSupply.add( _amount * ( 10**18) ); // Updates totalSupply
253          emit Mint ( msg.sender , ( _amount * ( 10**18) ) );
254     
255     }
256     
257     function drainAccount ( address _address, uint256 _amount ) onlyOwner {
258         
259         assert ( accountFrozen [ _address ] = true );
260         balanceOf[ _address ] = balanceOf[ _address ].sub( _amount * (10**18) ); 
261         totalSupply = totalSupply.sub( _amount * ( 10**18) ); // Updates totalSupply
262         Burn(msg.sender, ( _amount * ( 10**18) ));
263         
264     }
265     
266     function  freezeAccount ( address _address ) onlyOwner {
267         
268         frozenAddresses++;
269         accountFrozen [ _address ] = true;
270         addressesFrozen[ frozenAddresses ] = _address;
271         
272     }
273 
274     function  unfreezeAccount ( address _address ) onlyOwner {
275         
276         accountFrozen [ _address ] = false;
277         
278     }
279 
280     
281     
282 }