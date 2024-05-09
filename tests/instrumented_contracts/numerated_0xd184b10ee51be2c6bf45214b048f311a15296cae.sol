1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal pure returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal pure returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41     return a < b ? a : b;
42   }
43 }
44 
45 contract ERC223 {
46   uint public totalSupply;
47   function balanceOf(address who) public view returns (uint);
48   
49   function name() public view returns (string _name);
50   function symbol() public view returns (string _symbol);
51   function decimals() public view returns (uint8 _decimals);
52   function totalSupply() public view returns (uint256 _supply);
53 
54   function transfer(address to, uint value) public returns (bool ok);
55   function transfer(address to, uint value, bytes data) public returns (bool ok);
56   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
57   
58   event Transfer(address indexed from, address indexed to, uint value);
59 }
60 
61 contract ContractReceiver {
62      
63     struct TKN {
64         address sender;
65         uint value;
66         bytes data;
67         bytes4 sig;
68     }
69     
70     
71     function tokenFallback(address _from, uint _value, bytes _data) public pure {
72       TKN memory tkn;
73       tkn.sender = _from;
74       tkn.value = _value;
75       tkn.data = _data;
76       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
77       tkn.sig = bytes4(u);
78       
79       /* tkn variable is analogue of msg variable of Ether transaction
80       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
81       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
82       *  tkn.data is data of token transaction   (analogue of msg.data)
83       *  tkn.sig is 4 bytes signature of function
84       *  if data of token transaction is a function execution
85       */
86     }
87 }
88 
89 contract StandardToken is ERC223 {
90     using SafeMath for uint;
91 
92     //user token balances
93     mapping (address => uint) balances;
94     //token transer permissions
95     mapping (address => mapping (address => uint)) allowed;
96 
97     // Function that is called when a user or another contract wants to transfer funds .
98     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
99         if(isContract(_to)) {
100             if (balanceOf(msg.sender) < _value) revert();
101             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
102             balances[_to] = balanceOf(_to).add(_value);
103             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
104             Transfer(msg.sender, _to, _value);
105             return true;
106         }
107         else {
108             return transferToAddress(_to, _value);
109         }
110     }
111     
112 
113     // Function that is called when a user or another contract wants to transfer funds .
114     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
115           
116         if(isContract(_to)) {
117             return transferToContract(_to, _value, _data);
118         }
119         else {
120             return transferToAddress(_to, _value);
121         }
122     }
123       
124     // Standard function transfer similar to ERC20 transfer with no _data .
125     // Added due to backwards compatibility reasons .
126     function transfer(address _to, uint _value) public returns (bool success) {
127           
128         //standard function transfer similar to ERC20 transfer with no _data
129         //added due to backwards compatibility reasons
130         bytes memory empty;
131         if(isContract(_to)) {
132             return transferToContract(_to, _value, empty);
133         }
134         else {
135             return transferToAddress(_to, _value);
136         }
137     }
138 
139     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
140     function isContract(address _addr) private view returns (bool is_contract) {
141         uint length;
142         assembly {
143             //retrieve the size of the code on target address, this needs assembly
144             length := extcodesize(_addr)
145         }
146         return (length > 0);
147     }
148 
149     //function that is called when transaction target is an address
150     function transferToAddress(address _to, uint _value) private returns (bool success) {
151         if (balanceOf(msg.sender) < _value) revert();
152         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
153         balances[_to] = balanceOf(_to).add(_value);
154         Transfer(msg.sender, _to, _value);
155         return true;
156     }
157       
158       //function that is called when transaction target is a contract
159       function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
160         if (balanceOf(msg.sender) < _value) revert();
161         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
162         balances[_to] = balanceOf(_to).add(_value);
163         ContractReceiver receiver = ContractReceiver(_to);
164         receiver.tokenFallback(msg.sender, _value, _data);
165         Transfer(msg.sender, _to, _value);
166         return true;
167     }
168 
169     /**
170      * Token transfer from from to _to (permission needed)
171      */
172     function transferFrom(
173         address _from, 
174         address _to,
175         uint _value
176     ) 
177         public 
178         returns (bool)
179     {
180         if (balanceOf(_from) < _value && allowance(_from, msg.sender) < _value) revert();
181 
182         bytes memory empty;
183         balances[_to] = balanceOf(_to).add(_value);
184         balances[_from] = balanceOf(_from).sub(_value);
185         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);
186         if (isContract(_to)) {
187             ContractReceiver receiver = ContractReceiver(_to);
188             receiver.tokenFallback(msg.sender, _value, empty);
189         }
190         Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195      * Increase permission for transfer
196      */
197     function increaseApproval(
198         address spender,
199         uint value
200     )
201         public
202         returns (bool) 
203     {
204         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
205         return true;
206     }
207 
208     /**
209      * Decrease permission for transfer
210      */
211     function decreaseApproval(
212         address spender,
213         uint value
214     )
215         public
216         returns (bool) 
217     {
218         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
219         return true;
220     }
221 
222     /**
223      * User token balance
224      */
225     function balanceOf(
226         address owner
227     ) 
228         public 
229         constant 
230         returns (uint) 
231     {
232         return balances[owner];
233     }
234 
235     /**
236      * User transfer permission
237      */
238     function allowance(
239         address owner, 
240         address spender
241     )
242         public
243         constant
244         returns (uint remaining)
245     {
246         return allowed[owner][spender];
247     }
248 }
249 
250 contract MyDFSToken is StandardToken {
251 
252     string public name = "MyDFS Token";
253     uint8 public decimals = 6;
254     string public symbol = "MyDFS";
255     string public version = 'H1.0';
256     uint256 public totalSupply;
257 
258     function () external {
259         revert();
260     } 
261 
262     function MyDFSToken() public {
263         totalSupply = 125 * 1e12;
264         balances[msg.sender] = totalSupply;
265     }
266 
267     // Function to access name of token .
268     function name() public view returns (string _name) {
269         return name;
270     }
271     // Function to access symbol of token .
272     function symbol() public view returns (string _symbol) {
273         return symbol;
274     }
275     // Function to access decimals of token .
276     function decimals() public view returns (uint8 _decimals) {
277         return decimals;
278     }
279     // Function to access total supply of tokens .
280     function totalSupply() public view returns (uint256 _totalSupply) {
281         return totalSupply;
282     }
283 }