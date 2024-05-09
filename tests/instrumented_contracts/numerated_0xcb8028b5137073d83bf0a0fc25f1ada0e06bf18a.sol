1 pragma solidity ^0.4.23;
2 
3 contract SafeMath {
4     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract ContractReceiver {
33      
34     struct TKN {
35         address sender;
36         uint value;
37         bytes data;
38         bytes4 sig;
39     }
40     
41     function tokenFallback(address _from, uint _value, bytes _data) public pure {
42         TKN memory tkn;
43         tkn.sender = _from;
44         tkn.value = _value;
45         tkn.data = _data;
46         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
47         tkn.sig = bytes4(u);
48       
49         /* tkn variable is analogue of msg variable of Ether transaction
50         *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
51         *  tkn.value the number of tokens that were sent   (analogue of msg.value)
52         *  tkn.data is data of token transaction   (analogue of msg.data)
53         *  tkn.sig is 4 bytes signature of function
54         *  if data of token transaction is a function execution
55         */
56     }
57 }
58 
59 contract ERC223 {
60     uint public totalSupply;
61     function balanceOf(address who) public view returns (uint);
62     
63     function name() public view returns (string _name);
64     function symbol() public view returns (string _symbol);
65     function decimals() public view returns (uint8 _decimals);
66     function totalSupply() public view returns (uint256 _supply);
67 
68     function transfer(address to, uint value) public returns (bool ok);
69     function transfer(address to, uint value, bytes data) public returns (bool ok);
70     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
71     
72     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
73     event Transfer(address indexed from, address indexed to, uint value);
74 }
75 
76 contract ERC223Token is ERC223, SafeMath {
77 
78     mapping(address => uint) balances;
79     
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83     uint256 public totalSupply;
84   
85     // Function to access name of token .
86     function name() public view returns (string _name) {
87         return name;
88     }
89     // Function to access symbol of token .
90     function symbol() public view returns (string _symbol) {
91         return symbol;
92     }
93     // Function to access decimals of token .
94     function decimals() public view returns (uint8 _decimals) {
95         return decimals;
96     }
97     // Function to access total supply of tokens .
98     function totalSupply() public view returns (uint256 _totalSupply) {
99         return totalSupply;
100     }
101   
102   
103     // Function that is called when a user or another contract wants to transfer funds .
104     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
105         
106         if(isContract(_to)) {
107             if (balanceOf(msg.sender) < _value) revert();
108             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
109             balances[_to] = safeAdd(balanceOf(_to), _value);
110             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
111             emit Transfer(msg.sender, _to, _value, _data);
112             emit Transfer(msg.sender, _to, _value);
113             return true;
114         }
115         else {
116             return transferToAddress(_to, _value, _data);
117         }
118     }
119 
120     // Function that is called when a user or another contract wants to transfer funds .
121     function transfer(address _to, uint _value, bytes _data) public returns (bool success) { 
122         if(isContract(_to)) {
123             return transferToContract(_to, _value, _data);
124         }
125         else {
126             return transferToAddress(_to, _value, _data);
127         }
128     }
129   
130     // Standard function transfer similar to ERC20 transfer with no _data .
131     // Added due to backwards compatibility reasons .
132     function transfer(address _to, uint _value) public returns (bool success) {
133         //standard function transfer similar to ERC20 transfer with no _data
134         //added due to backwards compatibility reasons
135         bytes memory empty;
136         if(isContract(_to)) {
137             return transferToContract(_to, _value, empty);
138         }
139         else {
140             return transferToAddress(_to, _value, empty);
141         }
142     }
143 
144     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
145     function isContract(address _addr) private view returns (bool is_contract) {
146         uint length;
147         assembly {
148             //retrieve the size of the code on target address, this needs assembly
149             length := extcodesize(_addr)
150         }
151         return (length>0);
152     }
153 
154     //function that is called when transaction target is an address
155     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
156         if (balanceOf(msg.sender) < _value) revert();
157         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
158         balances[_to] = safeAdd(balanceOf(_to), _value);
159         emit Transfer(msg.sender, _to, _value, _data);
160         emit Transfer(msg.sender, _to, _value);
161         return true;
162     }
163   
164     //function that is called when transaction target is a contract
165     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
166         if (balanceOf(msg.sender) < _value) revert();
167         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
168         balances[_to] = safeAdd(balanceOf(_to), _value);
169         ContractReceiver receiver = ContractReceiver(_to);
170         receiver.tokenFallback(msg.sender, _value, _data);
171         emit Transfer(msg.sender, _to, _value, _data);
172         emit Transfer(msg.sender, _to, _value);
173         return true;
174     }
175 
176 
177     function balanceOf(address _owner) public view returns (uint balance) {
178         return balances[_owner];
179     }
180 }
181 
182 
183 contract owned {
184     address public owner;
185 
186     constructor() public{
187         owner = msg.sender;
188     }
189 
190     modifier onlyOwner {
191         require(msg.sender == owner);
192         _;
193     }
194 
195     function transferOwnership(address newOwner) onlyOwner public {
196         owner = newOwner;
197     }
198 }
199 
200 contract MoeSeed is ERC223Token, owned{
201     string public name;
202     string public symbol;
203     uint256 public decimals;
204     uint256 public totalSupply;
205     
206     constructor() public{
207         name = "Moe Seed";
208         symbol = "MOE";
209         decimals = 18;
210         totalSupply = 10000000000 * 10 ** decimals;
211         balances[msg.sender] = totalSupply;
212     }
213     
214     function changeOwner(address newOwner) onlyOwner public{
215         uint balanceOwner = balanceOf(owner);
216         balances[owner] = safeSub(balanceOf(owner), balanceOwner);
217         balances[newOwner] = safeAdd(balanceOf(newOwner), balanceOwner);
218         bytes memory empty;
219         emit Transfer(owner, newOwner, balanceOwner, empty);
220         emit Transfer(owner, newOwner, balanceOwner);
221         transferOwnership(newOwner);
222     }
223     
224     function transferFromOwner(address _from, address _to, uint _value, uint _fee) onlyOwner public{
225         bytes memory empty;
226         if (balanceOf(_from) < (_value + _fee)) revert();
227         balances[_from] = safeSub(balanceOf(_from), _value);
228         balances[_to] = safeAdd(balanceOf(_to), _value);
229         emit Transfer(_from, _to, _value, empty);
230         emit Transfer(_from, _to, _value);
231         balances[_from] = safeSub(balanceOf(_from), _fee);
232         balances[owner] = safeAdd(balanceOf(owner), _fee);
233         emit Transfer(_from, owner, _fee, empty);
234         emit Transfer(_from, owner, _fee);
235     }
236 }