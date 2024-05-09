1 pragma solidity ^ 0.4 .21;
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
52    function totalSupply() constant returns(uint totalSupply);
53 
54     function balanceOf(address who) constant returns(uint256);
55 
56     function transfer(address to, uint value) returns(bool ok);
57 
58     function transferFrom(address from, address to, uint value) returns(bool ok);
59 
60     function approve(address spender, uint value) returns(bool ok);
61 
62     function allowance(address owner, address spender) constant returns(uint);
63     event Transfer(address indexed from, address indexed to, uint value);
64     event Transfer(address indexed from, address indexed to, uint value, bytes data);
65     event Approval(address indexed owner, address indexed spender, uint value);
66 
67 }
68 
69 
70 contract BSAFE is ERC20  {
71 
72     using SafeMath
73     for uint256;
74     /* Public variables of the token */
75     string public standard = 'BSAFE 1.1';
76     string public name;
77     string public symbol;
78     uint8 public decimals;
79     uint256 public totalSupply;
80     uint256 public initialSupply;
81     bool initialize;
82 
83     mapping( address => uint256) public balanceOf;
84     mapping(address => mapping(address => uint256)) public allowance;
85 
86     /* This generates a public event on the blockchain that will notify clients */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Transfer(address indexed from, address indexed to, uint value, bytes data);
89     event Approval(address indexed owner, address indexed spender, uint value);
90 
91     /* This notifies clients about the amount burnt */
92     event Burn(address indexed from, uint256 value);
93 
94     /* Initializes contract with initial supply tokens to the creator of the contract */
95     function BSAFE() {
96 
97         uint256 _initialSupply = 12000000000000000 ; 
98         uint8 decimalUnits = 8;
99         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
100         totalSupply = _initialSupply; // Update total supply
101         initialSupply = _initialSupply;
102         name = "BlockSafe"; // Set the name for display purposes
103         symbol = "BSAFE"; // Set the symbol for display purposes
104         decimals = decimalUnits; // Amount of decimals for display purposes
105     }
106 
107    
108 
109 
110 
111     function balanceOf(address tokenHolder) constant returns(uint256) {
112 
113         return balanceOf[tokenHolder];
114     }
115 
116     function totalSupply() constant returns(uint256) {
117 
118         return totalSupply;
119     }
120 
121 
122     function transfer(address _to, uint256 _value) returns(bool ok) {
123         
124         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
125         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
126         bytes memory empty;
127         
128         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
129         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
130         
131          if(isContract( _to )) {
132             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
133             receiver.tokenFallback(msg.sender, _value, empty);
134         }
135         
136         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
137         return true;
138     }
139     
140      function transfer(address _to, uint256 _value, bytes _data ) returns(bool ok) {
141         
142         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
143         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
144         bytes memory empty;
145         
146         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
147         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
148         
149          if(isContract( _to )) {
150             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
151             receiver.tokenFallback(msg.sender, _value, _data);
152         }
153         
154         Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
155         return true;
156     }
157     
158     
159     
160     function isContract( address _to ) internal returns ( bool ){
161         
162         
163         uint codeLength = 0;
164         
165         assembly {
166             // Retrieve the size of the code on target address, this needs assembly .
167             codeLength := extcodesize(_to)
168         }
169         
170          if(codeLength>0) {
171            
172            return true;
173            
174         }
175         
176         return false;
177         
178     }
179     
180     
181     /* Allow another contract to spend some tokens in your behalf */
182     function approve(address _spender, uint256 _value)
183     returns(bool success) {
184         allowance[msg.sender][_spender] = _value;
185         Approval( msg.sender ,_spender, _value);
186         return true;
187     }
188 
189     /* Approve and then communicate the approved contract in a single tx */
190     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
191     returns(bool success) {
192         tokenRecipient spender = tokenRecipient(_spender);
193         if (approve(_spender, _value)) {
194             spender.receiveApproval(msg.sender, _value, this, _extraData);
195             return true;
196         }
197     }
198 
199     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
200         return allowance[_owner][_spender];
201     }
202 
203     /* A contract attempts to get the coins */
204     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
205         
206         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
207         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
208         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
209         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
210         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
211         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
212         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
213         Transfer(_from, _to, _value);
214         return true;
215     }
216   
217     function burn(uint256 _value) returns(bool success) {
218         
219         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
220         if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
221         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
222         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
223         Burn(msg.sender, _value);
224         return true;
225     }
226 
227    function burnFrom(address _from, uint256 _value) returns(bool success) {
228         
229         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
230         if (balanceOf[_from] < _value) throw; 
231         if (_value > allowance[_from][msg.sender]) throw; 
232         balanceOf[_from] = balanceOf[_from].sub( _value ); 
233         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
234         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
235         Burn(_from, _value);
236         return true;
237     }
238 
239 
240     
241     
242 }