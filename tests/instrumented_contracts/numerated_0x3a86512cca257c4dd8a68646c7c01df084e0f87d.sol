1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ContractReceiver {
33     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
34 }
35 
36 contract ERC223Basic {
37     uint256 public totalSupply;
38     function balanceOf(address who) public constant returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     function transfer(address to, uint256 value, bytes data) public returns (bool);
41     function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC223 is ERC223Basic {
46     function allowance(address owner, address spender) public constant returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface Token { 
53     function distr(address _to, uint256 _value) public returns (bool);
54     function totalSupply() constant public returns (uint256 supply);
55     function balanceOf(address _owner) constant public returns (uint256 balance);
56 }
57 
58 contract Git is ERC223 {
59     
60     using SafeMath for uint256;
61     address owner = msg.sender;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65 
66     string public constant name = "Git";
67     string public constant symbol = "Git";
68     uint public constant decimals = 18;
69     
70     uint256 public totalSupply;
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     event LOG_Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
75 
76     
77     event Burn(address indexed burner, uint256 value);
78     event Mint(address indexed minter, uint256 value);
79 
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     function Git (uint256 _initialAmount) public {
86         require(_initialAmount != 0);
87         owner = msg.sender;
88         totalSupply = _initialAmount;
89         balances[msg.sender] = totalSupply;
90     }
91     
92     function () external payable {
93         
94     }
95     
96     function transferOwnership(address newOwner) onlyOwner public {
97         if (newOwner != address(0)) {
98             owner = newOwner;
99         }
100     }
101 
102     function balanceOf(address _owner) constant public returns (uint256) {
103 	    return balances[_owner];
104     }
105 
106     // mitigates the ERC20 short address attack
107     modifier onlyPayloadSize(uint size) {
108         assert(msg.data.length >= size + 4);
109         _;
110     }
111     
112     function transfer(address _to, uint256 _amount, bytes _data, string _custom_fallback) onlyPayloadSize(2 * 32) public returns (bool success) {
113         if(isContract(_to)) {
114             require(balanceOf(msg.sender) >= _amount);
115             balances[msg.sender] = balanceOf(msg.sender).sub(_amount);
116             balances[_to] = balanceOf(_to).add(_amount);
117             ContractReceiver receiver = ContractReceiver(_to);
118             require(receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _amount, _data));
119             
120             Transfer(msg.sender, _to, _amount);
121             LOG_Transfer(msg.sender, _to, _amount, _data);
122             return true;
123         }
124         else {
125             return transferToAddress(_to, _amount, _data);
126         }
127     }
128 
129 
130     function transfer(address _to, uint256 _amount, bytes _data) onlyPayloadSize(2 * 32) public returns (bool success) {
131 
132         require(_to != address(0));
133 
134         if(isContract(_to)) {
135             return transferToContract(_to, _amount, _data);
136         }
137         else {
138             return transferToAddress(_to, _amount, _data);
139         }
140     }
141 
142     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
143     
144         require(_to != address(0));
145         
146         bytes memory empty;
147         
148         if(isContract(_to)) {
149             return transferToContract(_to, _amount, empty);
150         }
151         else {
152             return transferToAddress(_to, _amount, empty);
153         }
154     }
155     
156     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
157 
158         require(_to != address(0));
159         require(_amount <= balances[_from]);
160         require(_amount <= allowed[_from][msg.sender]);
161         
162         bytes memory empty;
163         
164         balances[_from] = balances[_from].sub(_amount);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
166         balances[_to] = balances[_to].add(_amount);
167         Transfer(_from, _to, _amount);
168         LOG_Transfer(_from, _to, _amount, empty);
169         return true;
170     }
171     
172     function approve(address _spender, uint256 _value) public returns (bool success) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177     
178     function allowance(address _owner, address _spender) constant public returns (uint256) {
179         return allowed[_owner][_spender];
180     }
181     
182     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
183         ForeignToken t = ForeignToken(tokenAddress);
184         uint bal = t.balanceOf(who);
185         return bal;
186     }
187     
188     function withdraw() onlyOwner public {
189         uint256 etherBalance = this.balance;
190         owner.transfer(etherBalance);
191     }
192     
193     function mint(uint256 _value) onlyOwner public {
194 
195         address minter = msg.sender;
196         balances[minter] = balances[minter].add(_value);
197         totalSupply = totalSupply.add(_value);
198         Mint(minter, _value);
199     }
200     
201     function burn(uint256 _value) onlyOwner public {
202         require(_value <= balances[msg.sender]);
203 
204         address burner = msg.sender;
205         balances[burner] = balances[burner].sub(_value);
206         totalSupply = totalSupply.sub(_value);
207         Burn(burner, _value);
208     }
209     
210     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
211         ForeignToken token = ForeignToken(_tokenContract);
212         uint256 amount = token.balanceOf(address(this));
213         return token.transfer(owner, amount);
214     }
215     
216     function approveAndCall(address _spender, uint256 _value, bytes _extraData) payable public returns (bool) {
217         allowed[msg.sender][_spender] = _value;
218         Approval(msg.sender, _spender, _value);
219         
220         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
221         return true;
222     }
223     
224     function isContract(address _addr) private constant returns (bool) {
225         uint length;
226         assembly {
227             length := extcodesize(_addr)
228         }
229         return (length>0);
230     }
231 
232     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
233         require(balanceOf(msg.sender) >= _value);
234         balances[msg.sender] =  balanceOf(msg.sender).sub(_value);
235         balances[_to] = balanceOf(_to).add(_value);
236         Transfer(msg.sender, _to, _value);
237         LOG_Transfer(msg.sender, _to, _value, _data);
238         return true;
239     }
240 
241     function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
242         require(balanceOf(msg.sender) >= _value);
243         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
244         balances[_to] = balanceOf(_to).add(_value);
245         ContractReceiver receiver = ContractReceiver(_to);
246         receiver.tokenFallback(msg.sender, _value, _data);
247         Transfer(msg.sender, _to, _value);
248         LOG_Transfer(msg.sender, _to, _value, _data);
249         return true;
250     }
251 
252 }