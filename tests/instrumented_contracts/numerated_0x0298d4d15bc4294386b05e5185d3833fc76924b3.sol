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
45 
46 contract ERC223 {
47   uint public totalSupply;
48   function balanceOf(address who) public view returns (uint);
49   
50   function name() public view returns (string _name);
51   function symbol() public view returns (string _symbol);
52   function decimals() public view returns (uint8 _decimals);
53   function totalSupply() public view returns (uint256 _supply);
54 
55   function transfer(address to, uint value) public returns (bool ok);
56   function transfer(address to, uint value, bytes data) public returns (bool ok);
57   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
58   
59   event Transfer(address indexed from, address indexed to, uint value, bytes data);
60 }
61 
62 contract ContractReceiver {
63      
64     struct TKN {
65         address sender;
66         uint value;
67         bytes data;
68         bytes4 sig;
69     }
70     
71     
72     function tokenFallback(address _from, uint _value, bytes _data) public pure {
73       TKN memory tkn;
74       tkn.sender = _from;
75       tkn.value = _value;
76       tkn.data = _data;
77       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
78       tkn.sig = bytes4(u);
79       
80       /* tkn variable is analogue of msg variable of Ether transaction
81       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
82       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
83       *  tkn.data is data of token transaction   (analogue of msg.data)
84       *  tkn.sig is 4 bytes signature of function
85       *  if data of token transaction is a function execution
86       */
87     }
88 }
89 
90 contract StandardToken is ERC223 {
91     using SafeMath for uint;
92 
93     //user token balances
94     mapping (address => uint) balances;
95     //token transer permissions
96     mapping (address => mapping (address => uint)) allowed;
97 
98     // Function that is called when a user or another contract wants to transfer funds .
99     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
100         if(isContract(_to)) {
101             if (balanceOf(msg.sender) < _value) revert();
102             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
103             balances[_to] = balanceOf(_to).add(_value);
104             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
105             Transfer(msg.sender, _to, _value, _data);
106             return true;
107         }
108         else {
109             return transferToAddress(_to, _value, _data);
110         }
111     }
112     
113 
114     // Function that is called when a user or another contract wants to transfer funds .
115     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
116           
117         if(isContract(_to)) {
118             return transferToContract(_to, _value, _data);
119         }
120         else {
121             return transferToAddress(_to, _value, _data);
122         }
123     }
124       
125     // Standard function transfer similar to ERC20 transfer with no _data .
126     // Added due to backwards compatibility reasons .
127     function transfer(address _to, uint _value) public returns (bool success) {
128           
129         //standard function transfer similar to ERC20 transfer with no _data
130         //added due to backwards compatibility reasons
131         bytes memory empty;
132         if(isContract(_to)) {
133             return transferToContract(_to, _value, empty);
134         }
135         else {
136             return transferToAddress(_to, _value, empty);
137         }
138     }
139 
140     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
141     function isContract(address _addr) private view returns (bool is_contract) {
142         uint length;
143         assembly {
144             //retrieve the size of the code on target address, this needs assembly
145             length := extcodesize(_addr)
146         }
147         return (length > 0);
148     }
149 
150     //function that is called when transaction target is an address
151     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
152         if (balanceOf(msg.sender) < _value) revert();
153         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
154         balances[_to] = balanceOf(_to).add(_value);
155         Transfer(msg.sender, _to, _value, _data);
156         return true;
157     }
158       
159       //function that is called when transaction target is a contract
160       function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
161         if (balanceOf(msg.sender) < _value) revert();
162         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
163         balances[_to] = balanceOf(_to).add(_value);
164         ContractReceiver receiver = ContractReceiver(_to);
165         receiver.tokenFallback(msg.sender, _value, _data);
166         Transfer(msg.sender, _to, _value, _data);
167         return true;
168     }
169 
170     /**
171      * Token transfer from from to _to (permission needed)
172      */
173     function transferFrom(
174         address _from, 
175         address _to,
176         uint _value
177     ) 
178         public 
179         returns (bool)
180     {
181         if (balanceOf(_from) < _value && allowance(_from, msg.sender) < _value) revert();
182 
183         bytes memory empty;
184         balances[_to] = balanceOf(_to).add(_value);
185         balances[_from] = balanceOf(_from).sub(_value);
186         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);
187         if (isContract(_to)) {
188             ContractReceiver receiver = ContractReceiver(_to);
189             receiver.tokenFallback(msg.sender, _value, empty);
190         }
191         Transfer(_from, _to, _value, empty);
192         return true;
193     }
194 
195     /**
196      * Increase permission for transfer
197      */
198     function increaseApproval(
199         address spender,
200         uint value
201     )
202         public
203         returns (bool) 
204     {
205         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
206         return true;
207     }
208 
209     /**
210      * Decrease permission for transfer
211      */
212     function decreaseApproval(
213         address spender,
214         uint value
215     )
216         public
217         returns (bool) 
218     {
219         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
220         return true;
221     }
222 
223     /**
224      * User token balance
225      */
226     function balanceOf(
227         address owner
228     ) 
229         public 
230         constant 
231         returns (uint) 
232     {
233         return balances[owner];
234     }
235 
236     /**
237      * User transfer permission
238      */
239     function allowance(
240         address owner, 
241         address spender
242     )
243         public
244         constant
245         returns (uint remaining)
246     {
247         return allowed[owner][spender];
248     }
249 }
250 
251 contract MyDFSToken is StandardToken {
252 
253     string public name = "MyDFS Token";
254     uint8 public decimals = 6;
255     string public symbol = "MyDFS";
256     string public version = 'H1.0';
257     uint256 public totalSupply;
258 
259     function () external {
260         revert();
261     } 
262 
263     function MyDFSToken() public {
264         totalSupply = 125 * 1e12;
265         balances[msg.sender] = totalSupply;
266     }
267 
268     // Function to access name of token .
269     function name() public view returns (string _name) {
270         return name;
271     }
272     // Function to access symbol of token .
273     function symbol() public view returns (string _symbol) {
274         return symbol;
275     }
276     // Function to access decimals of token .
277     function decimals() public view returns (uint8 _decimals) {
278         return decimals;
279     }
280     // Function to access total supply of tokens .
281     function totalSupply() public view returns (uint256 _totalSupply) {
282         return totalSupply;
283     }
284 }