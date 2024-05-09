1 pragma solidity ^0.4.23;
2 
3 contract ERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) public view returns (uint);
6 
7   function transfer(address to, uint value) public returns (bool ok);
8   function transfer(address to, uint value, bytes data) public returns (bool ok);
9   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
10 
11   // event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
12   event Transfer(address indexed from, address indexed to, uint value);
13 }
14 contract ContractReceiver {
15  
16     struct TKN {
17         address sender;
18         uint value;
19         bytes data;
20         bytes4 sig;
21     }
22 
23 
24     function tokenFallback(address _from, uint _value, bytes _data) public pure {
25       TKN memory tkn;
26       tkn.sender = _from;
27       tkn.value = _value;
28       tkn.data = _data;
29       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
30       tkn.sig = bytes4(u);
31       
32       /* tkn variable is analogue of msg variable of Ether transaction
33       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
34       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
35       *  tkn.data is data of token transaction   (analogue of msg.data)
36       *  tkn.sig is 4 bytes signature of function
37       *  if data of token transaction is a function execution
38       */
39     }
40 }
41 
42 
43 library SafeMath {
44   function mul(uint a, uint b) internal returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint a, uint b) internal returns (uint) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint a, uint b) internal returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint a, uint b) internal returns (uint) {
63     uint c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 
68   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a >= b ? a : b;
70   }
71 
72   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
73     return a < b ? a : b;
74   }
75 
76   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a >= b ? a : b;
78   }
79 
80   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
81     return a < b ? a : b;
82   }
83 
84   function assert(bool assertion) internal {
85     if (!assertion) {
86       throw;
87     }
88   }
89 }
90 
91 contract KPRToken is ERC223 {
92     
93     using SafeMath for uint256;
94     
95 
96     
97     //public variables
98     string public constant symbol="KPR"; 
99     string public constant name="KPR Coin"; 
100     uint8 public constant decimals=18;
101 
102     //1 ETH = 2,500 KPR
103     uint256 public  buyPrice = 2500;
104 
105     //totalsupplyoftoken 
106     uint public totalSupply = 100000000 * 10 ** uint(decimals);
107     
108     uint public buyabletoken = 70000000 * 10 ** uint(decimals);
109     //where the ETH goes 
110     address public owner;
111     
112     //map the addresses
113     mapping(address => uint256) balances;
114     mapping(address => mapping(address => uint256)) allowed;
115     // 1514764800 : Jan 1 2018
116     uint256 phase1starttime = 1525132800; // Phase 1 Start Date May 1 2018
117     uint256 phase1endtime = 1527033540;  // Phase 1 End Date May 22 2018
118     uint256 phase2starttime = 1527811200;  // Phase 2 Start Date June 1 2018
119     uint256 phase2endtime = 1529711940; // Phase 2 End Date June 22 2018
120     
121     //create token function = check
122 
123     function() payable{
124         require(msg.value > 0);
125         require(buyabletoken > 0);
126         require(now >= phase1starttime && now <= phase2endtime);
127         
128         if (now > phase1starttime && now < phase1endtime){
129             buyPrice = 3000;
130         } else if(now > phase2starttime && now < phase2endtime){
131             buyPrice = 2000;
132         }
133         
134         uint256 amount = msg.value.mul(buyPrice); 
135         
136         balances[msg.sender] = balances[msg.sender].add(amount);
137         
138         balances[owner] = balances[owner].sub(amount);
139         
140         buyabletoken = buyabletoken.sub(amount);
141         owner.transfer(msg.value);
142     }
143 
144     function KPRToken() {
145         owner = msg.sender;
146         balances[owner] = totalSupply;
147     }
148     
149       event Burn(address indexed burner, uint256 value);
150 
151       /**
152        * @dev Burns a specific amount of tokens.
153        * @param _value The amount of token to be burned.
154        */
155       function burn(uint256 _value) public {
156         _burn(msg.sender, _value);
157       }
158 
159       function _burn(address _who, uint256 _value) internal {
160         require(_value <= balances[_who]);
161         // no need to require value <= totalSupply, since that would imply the
162         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
163     
164         balances[_who] = balances[_who].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166         emit Burn(_who, _value);
167         emit Transfer(_who, address(0), _value);
168       }
169 
170     function balanceOf(address _owner) constant returns(uint256 balance) {
171         
172         return balances[_owner];
173         
174     }
175 
176 
177     // Function that is called when a user or another contract wants to transfer funds .
178     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
179         
180         if (isContract(_to)) {
181             if (balanceOf(msg.sender) < _value)
182                 revert();
183             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
184             balances[_to] = balanceOf(_to).add(_value);
185             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
186             Transfer(msg.sender, _to, _value);
187             return true;
188         } else {
189             return transferToAddress(_to, _value, _data);
190         }
191     }
192     
193     // Function that is called when a user or another contract wants to transfer funds .
194     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
195         
196         if (isContract(_to)) {
197             return transferToContract(_to, _value, _data);
198         } else {
199             return transferToAddress(_to, _value, _data);
200         }
201     }
202     
203     // Standard function transfer similar to ERC20 transfer with no _data .
204     // Added due to backwards compatibility reasons .
205     function transfer(address _to, uint _value) public returns (bool success) {
206         
207         //standard function transfer similar to ERC20 transfer with no _data
208         //added due to backwards compatibility reasons
209         bytes memory empty;
210         if (isContract(_to)) {
211             return transferToContract(_to, _value, empty);
212         } else {
213             return transferToAddress(_to, _value, empty);
214         }
215     }
216 
217     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
218     function isContract(address _addr) private view returns (bool is_contract) {
219         uint length;
220         assembly {
221                 //retrieve the size of the code on target address, this needs assembly
222                 length := extcodesize(_addr)
223         }
224         return (length>0);
225     }
226 
227     //function that is called when transaction target is an address
228     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
229         if (balanceOf(msg.sender) < _value)
230             revert();
231         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
232         balances[_to] = balanceOf(_to).add(_value);
233         Transfer(msg.sender, _to, _value);
234         return true;
235     }
236     
237     //function that is called when transaction target is a contract
238     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
239         if (balanceOf(msg.sender) < _value)
240             revert();
241         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
242         balances[_to] = balanceOf(_to).add(_value);
243         ContractReceiver receiver = ContractReceiver(_to);
244         receiver.tokenFallback(msg.sender, _value, _data);
245         Transfer(msg.sender, _to, _value);
246         return true;
247     }
248     
249     event Transfer(address indexed_from, address indexed_to, uint256 _value);
250     event Approval(address indexed_owner, address indexed_spender, uint256 _value);
251     
252     
253 }