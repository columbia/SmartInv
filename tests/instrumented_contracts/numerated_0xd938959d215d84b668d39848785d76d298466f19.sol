1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 	function smul(uint256 a, uint256 b) internal pure returns (uint256) {		
5 		if(a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		require(c / a == b);
10 		return c;
11 	}
12 	
13 	function sdiv(uint256 a, uint256 b) internal pure returns (uint256) {
14 		uint256 c = a / b;
15 		return c;
16 	}
17 	
18 	function ssub(uint256 a, uint256 b) internal pure returns (uint256) {
19 		require( b <= a);
20 		return a-b;
21 	}
22 
23 	function sadd(uint256 a, uint256 b) internal pure returns (uint256) {
24 		uint256 c = a + b;
25 		require(c >= a);
26 		return c;
27 	}
28 }
29 
30 /*
31  * Contract that is working with ERC223 tokens
32  */
33  contract ContractReceiver {
34 
35     struct TKN {
36         address sender;
37         uint value;
38         bytes data;
39         bytes4 sig;
40     }
41 
42     function tokenFallback(address _from, uint _value, bytes _data) public pure {
43       TKN memory tkn;
44       tkn.sender = _from;
45       tkn.value = _value;
46       tkn.data = _data;
47       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
48       tkn.sig = bytes4(u);
49 
50       /* tkn variable is analogue of msg variable of Ether transaction
51       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
52       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
53       *  tkn.data is data of token transaction   (analogue of msg.data)
54       *  tkn.sig is 4 bytes signature of function
55       *  if data of token transaction is a function execution
56       */
57     }
58 }
59 
60 /*
61  * PetroleumToken is an ERC20 token with ERC223 Extensions
62  */
63 contract PetroleumToken {
64     
65     using SafeMath for uint256;
66 
67     string public name 			= "Petroleum";
68     string public symbol 		= "OIL";
69     uint8 public decimals 		= 18;
70     uint256 public totalSupply  = 1000000 * 10**18;
71 	bool public tokenCreated 	= false;
72 	bool public mintingFinished = false;
73 
74     address public owner;  
75     mapping(address => uint256) balances;
76 	mapping(address => mapping (address => uint256)) allowed;
77 
78     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint _value);
81     event Burn(address indexed from, uint256 value);
82     event Mint(address indexed to, uint256 amount);
83     event MintFinished();
84 
85    function PetroleumToken() public {       
86         require(tokenCreated == false);
87         tokenCreated = true;
88         owner = msg.sender;
89         balances[owner] = totalSupply;
90         require(balances[owner] > 0);
91     }
92 
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97 
98 	modifier canMint() {
99 		require(!mintingFinished);
100 		_;
101 	}    
102    
103     function name() constant public returns (string _name) {
104         return name;
105     }
106     
107     function symbol() constant public returns (string _symbol) {
108         return symbol;
109     }
110     
111     function decimals() constant public returns (uint8 _decimals) {
112         return decimals;
113     }
114    
115     function totalSupply() constant public returns (uint256 _totalSupply) {
116         return totalSupply;
117     }   
118 
119     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
120        
121         if (isContract(_to)) {
122             return transferToContract(_to, _value, _data);
123         } else {
124             return transferToAddress(_to, _value, _data);
125         }
126     }
127 
128     function transfer(address _to, uint _value) public returns (bool success) {       
129         bytes memory empty;
130         if (isContract(_to)) {
131             return transferToContract(_to, _value, empty);
132         } else {
133             return transferToAddress(_to, _value, empty);
134         }
135     }
136 
137     function isContract(address _addr) constant private returns (bool) {
138         uint length;
139         assembly {
140             length := extcodesize(_addr)
141         }
142         return (length > 0);
143     }
144 
145     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
146         if (balanceOf(msg.sender) < _value) {
147             revert();
148         }
149         balances[msg.sender] = balanceOf(msg.sender).ssub(_value);
150         balances[_to] = balanceOf(_to).sadd(_value);
151         Transfer(msg.sender, _to, _value, _data);
152         return true;
153     }
154 
155    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
156         if (balanceOf(msg.sender) < _value) {
157             revert();
158         }
159         balances[msg.sender] = balanceOf(msg.sender).ssub(_value);
160         balances[_to] = balanceOf(_to).sadd(_value);
161         ContractReceiver receiver = ContractReceiver(_to);
162         receiver.tokenFallback(msg.sender, _value, _data);
163         Transfer(msg.sender, _to, _value, _data);
164         return true;
165     }
166 
167     function balanceOf(address _owner) constant public returns (uint256 balance) {
168         return balances[_owner];
169     }
170    
171     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
172        
173         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
174         uint256 allowance = allowed[_from][msg.sender];
175         require(balances[_from] >= _value && allowance >= _value);
176         balances[_to] = balanceOf(_to).ssub(_value);
177         balances[_from] = balanceOf(_from).sadd(_value);
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].ssub(_value);
179         Transfer(_from, _to, _value);
180         return true;
181     }
182 
183     function approve(address _spender, uint256 _value) public returns (bool success) {
184         allowed[msg.sender][_spender] = _value;
185         Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
190       return allowed[_owner][_spender];
191     }
192     
193     
194     function burn(uint256 _value) public {
195         require(_value <= balances[msg.sender]);
196         
197         address burner = msg.sender;
198         balances[burner] = balances[burner].ssub(_value);
199         totalSupply = totalSupply.ssub(_value);
200         Burn(burner, _value);
201     }
202 
203     function burnFrom(address _from, uint256 _value) public returns (bool success) {
204         require(_value <= allowed[_from][msg.sender]);
205         allowed[_from][msg.sender].ssub(_value);
206         totalSupply.ssub(_value);
207         Burn(_from, _value);
208         return true;
209     }
210 
211 	function mint(address _to, uint256 _value) onlyOwner canMint public returns (bool) {
212 		totalSupply = totalSupply.sadd(_value);
213 		balances[_to] = balances[_to].sadd(_value);
214 		Mint(_to, _value);
215 		Transfer(address(0), _to, _value);
216 		return true;
217 	}
218 
219 	function finishMinting() onlyOwner canMint public returns (bool) {
220 		mintingFinished = true;
221 		MintFinished();
222 		return true;
223 	}
224 }