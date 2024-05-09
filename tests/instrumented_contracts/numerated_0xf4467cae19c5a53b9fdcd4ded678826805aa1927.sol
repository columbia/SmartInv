1 pragma solidity ^ 0.4 .19;
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
64     event Approval(address indexed owner, address indexed spender, uint value);
65 
66 }
67 
68 
69 contract XBV is ERC20  {
70 
71     using SafeMath
72     for uint256;
73     /* Public variables of the token */
74     string public standard = 'XBV 2.2';
75     string public name;
76     string public symbol;
77     uint8 public decimals;
78     uint256 public totalSupply;
79     uint256 public initialSupply;
80     bool initialize;
81 
82     mapping( address => uint256) public balanceOf;
83     mapping(address => mapping(address => uint256)) public allowance;
84 
85     /* This generates a public event on the blockchain that will notify clients */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Transfer(address indexed from, address indexed to, uint value, bytes data);
88     event Approval(address indexed owner, address indexed spender, uint value);
89 
90     /* This notifies clients about the amount burnt */
91     event Burn(address indexed from, uint256 value);
92 
93     /* Initializes contract with initial supply tokens to the creator of the contract */
94     function XBV() {
95 
96         uint256 _initialSupply = 10000000000000000 ; 
97         uint8 decimalUnits = 8;
98         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
99         totalSupply = _initialSupply; // Update total supply
100         initialSupply = _initialSupply;
101         name = "BlockVentureCoin"; // Set the name for display purposes
102         symbol = "XBV"; // Set the symbol for display purposes
103         decimals = decimalUnits; // Amount of decimals for display purposes
104     }
105 
106    
107 
108 
109 
110     function balanceOf(address tokenHolder) constant returns(uint256) {
111 
112         return balanceOf[tokenHolder];
113     }
114 
115     function totalSupply() constant returns(uint256) {
116 
117         return totalSupply;
118     }
119 
120 
121     function transfer(address _to, uint256 _value) returns(bool ok) {
122         
123         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
124         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
125         bytes memory empty;
126         
127         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
128         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
129         
130          if(isContract( _to )) {
131             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
132             receiver.tokenFallback(msg.sender, _value, empty);
133         }
134         
135         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
136         return true;
137     }
138     
139      function transfer(address _to, uint256 _value, bytes _data ) returns(bool ok) {
140         
141         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
142         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
143         bytes memory empty;
144         
145         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
146         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
147         
148          if(isContract( _to )) {
149             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
150             receiver.tokenFallback(msg.sender, _value, _data);
151         }
152         
153         Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
154         return true;
155     }
156     
157     
158     
159     function isContract( address _to ) internal returns ( bool ){
160         
161         
162         uint codeLength = 0;
163         
164         assembly {
165             // Retrieve the size of the code on target address, this needs assembly .
166             codeLength := extcodesize(_to)
167         }
168         
169          if(codeLength>0) {
170            
171            return true;
172            
173         }
174         
175         return false;
176         
177     }
178     
179     
180     /* Allow another contract to spend some tokens in your behalf */
181     function approve(address _spender, uint256 _value)
182     returns(bool success) {
183         allowance[msg.sender][_spender] = _value;
184         Approval( msg.sender ,_spender, _value);
185         return true;
186     }
187 
188     /* Approve and then communicate the approved contract in a single tx */
189     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
190     returns(bool success) {
191         tokenRecipient spender = tokenRecipient(_spender);
192         if (approve(_spender, _value)) {
193             spender.receiveApproval(msg.sender, _value, this, _extraData);
194             return true;
195         }
196     }
197 
198     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
199         return allowance[_owner][_spender];
200     }
201 
202     /* A contract attempts to get the coins */
203     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
204         
205         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
206         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
207         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
208         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
209         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
210         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
211         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
212         Transfer(_from, _to, _value);
213         return true;
214     }
215   
216     function burn(uint256 _value) returns(bool success) {
217         
218         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
219         if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
220         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
221         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
222         Burn(msg.sender, _value);
223         return true;
224     }
225 
226    function burnFrom(address _from, uint256 _value) returns(bool success) {
227         
228         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
229         if (balanceOf[_from] < _value) throw; 
230         if (_value > allowance[_from][msg.sender]) throw; 
231         balanceOf[_from] = balanceOf[_from].sub( _value ); 
232         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
233         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
234         Burn(_from, _value);
235         return true;
236     }
237 
238 
239     
240     
241 }