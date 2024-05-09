1 pragma solidity ^ 0.4 .25;
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
75     string public standard = 'BSAFE 1.2';
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
95     constructor () public {
96 
97         uint256 _initialSupply = 12000000000000000 ; 
98         uint8 decimalUnits = 8;
99         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
100         totalSupply = _initialSupply; // Update total supply
101         initialSupply = _initialSupply;
102         name = "BlockSafe"; // Set the name for display purposes
103         symbol = "BSAFE"; // Set the symbol for display purposes
104         decimals = decimalUnits; // Amount of decimals for display purposes
105         emit Transfer( address(0),  msg.sender, _initialSupply);
106     }
107 
108    
109 
110 
111 
112     function balanceOf(address _tokenHolder) constant returns(uint256) {
113 
114         return balanceOf[_tokenHolder];
115     }
116 
117     function totalSupply() constant returns(uint256) {
118 
119         return totalSupply;
120     }
121 
122 
123     function transfer(address _to, uint256 _value) returns(bool ok) {
124         
125         require (_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
126         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
127         bytes memory empty;
128         
129         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
130         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
131         
132          if(isContract( _to )) {
133             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
134             receiver.tokenFallback(msg.sender, _value, empty);
135         }
136         
137         emit Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
138         return true;
139     }
140     
141      function transfer(address _to, uint256 _value, bytes _data ) returns(bool ok) {
142         
143         require (_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
144         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
145         bytes memory empty;
146         
147         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
148         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
149         
150          if(isContract( _to )) {
151             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
152             receiver.tokenFallback(msg.sender, _value, _data);
153         }
154         
155         emit Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
156         return true;
157     }
158     
159     
160     
161     function isContract( address _to ) internal returns ( bool ){
162         
163         
164         uint codeLength = 0;
165         
166         assembly {
167             // Retrieve the size of the code on target address, this needs assembly .
168             codeLength := extcodesize(_to)
169         }
170         
171          if(codeLength>0) {
172            
173            return true;
174            
175         }
176         
177         return false;
178         
179     }
180     
181     
182     /* Allow another contract to spend some tokens in your behalf */
183     function approve(address _spender, uint256 _value)
184     returns(bool success) {
185         allowance[msg.sender][_spender] = _value;
186         Approval( msg.sender ,_spender, _value);
187         return true;
188     }
189 
190     /* Approve and then communicate the approved contract in a single tx */
191     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
192     returns(bool success) {
193         tokenRecipient spender = tokenRecipient(_spender);
194         if (approve(_spender, _value)) {
195             spender.receiveApproval(msg.sender, _value, this, _extraData);
196             return true;
197         }
198     }
199 
200     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
201         return allowance[_owner][_spender];
202     }
203 
204     /* A contract attempts to get the coins */
205     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
206         
207         require (_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
208         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
209         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
210         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
211         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
212         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
213         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
214         emit Transfer(_from, _to, _value);
215         return true;
216     }
217   
218     function burn(uint256 _value) returns(bool success) {
219         
220         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
221       
222         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
223         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
224         emit Burn(msg.sender, _value);
225         return true;
226     }
227 
228    function burnFrom(address _from, uint256 _value) returns(bool success) {
229         
230         require (_from != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
231         if (balanceOf[_from] < _value) throw; 
232         if (_value > allowance[_from][msg.sender]) throw; 
233         balanceOf[_from] = balanceOf[_from].sub( _value ); 
234         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
235         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
236         emit Burn(_from, _value);
237         return true;
238     }
239 
240 
241     
242     
243 }