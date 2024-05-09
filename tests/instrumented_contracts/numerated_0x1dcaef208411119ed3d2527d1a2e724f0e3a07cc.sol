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
61  * SilkrouteCoin is an ERC20 token with ERC223 Extensions
62  */
63 contract SilkrouteCoin {
64     
65     using SafeMath for uint256;
66 
67     string public name 			= "SilkrouteCoin";
68     string public symbol 		= "XRT";
69     uint8 public decimals 		= 18;
70     uint256 public totalSupply  = 1000000000000 * 10**18;
71 	bool public tokenCreated 	= false;
72 
73     address public owner;  
74     mapping(address => uint256) balances;
75 	mapping(address => mapping (address => uint256)) allowed;
76 
77     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint _value);
80     event Burn(address indexed from, uint256 value);	
81 
82    function SilkrouteCoin() public {       
83         require(tokenCreated == false);
84         tokenCreated = true;
85         owner = msg.sender;
86         balances[owner] = totalSupply;
87         require(balances[owner] > 0);
88     }
89 
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }  
94    
95     function name() constant public returns (string _name) {
96         return name;
97     }
98     
99     function symbol() constant public returns (string _symbol) {
100         return symbol;
101     }
102     
103     function decimals() constant public returns (uint8 _decimals) {
104         return decimals;
105     }
106    
107     function totalSupply() constant public returns (uint256 _totalSupply) {
108         return totalSupply;
109     }   
110 
111     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
112        
113         if (isContract(_to)) {
114             return transferToContract(_to, _value, _data);
115         } else {
116             return transferToAddress(_to, _value, _data);
117         }
118     }
119 
120     function transfer(address _to, uint _value) public returns (bool success) {       
121         bytes memory empty;
122         if (isContract(_to)) {
123             return transferToContract(_to, _value, empty);
124         } else {
125             return transferToAddress(_to, _value, empty);
126         }
127     }
128 
129     function isContract(address _addr) constant private returns (bool) {
130         uint length;
131         assembly {
132             length := extcodesize(_addr)
133         }
134         return (length > 0);
135     }
136 
137     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
138         if (balanceOf(msg.sender) < _value) {
139             revert();
140         }
141         balances[msg.sender] = balanceOf(msg.sender).ssub(_value);
142         balances[_to] = balanceOf(_to).sadd(_value);
143         Transfer(msg.sender, _to, _value, _data);
144         return true;
145     }
146 
147    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
148         if (balanceOf(msg.sender) < _value) {
149             revert();
150         }
151         balances[msg.sender] = balanceOf(msg.sender).ssub(_value);
152         balances[_to] = balanceOf(_to).sadd(_value);
153         ContractReceiver receiver = ContractReceiver(_to);
154         receiver.tokenFallback(msg.sender, _value, _data);
155         Transfer(msg.sender, _to, _value, _data);
156         return true;
157     }
158 
159     function balanceOf(address _owner) constant public returns (uint256 balance) {
160         return balances[_owner];
161     }
162    
163     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
164        
165         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
166         uint256 allowance = allowed[_from][msg.sender];
167         require(balances[_from] >= _value && allowance >= _value);
168         balances[_to] = balanceOf(_to).ssub(_value);
169         balances[_from] = balanceOf(_from).sadd(_value);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].ssub(_value);
171         Transfer(_from, _to, _value);
172         return true;
173     }
174 
175     function approve(address _spender, uint256 _value) public returns (bool success) {
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
182       return allowed[_owner][_spender];
183     }
184     
185     function burn(uint256 _value) public {
186         require(_value <= balances[msg.sender]);
187         
188         address burner = msg.sender;
189         balances[burner] = balances[burner].ssub(_value);
190         totalSupply = totalSupply.ssub(_value);
191         Burn(burner, _value);
192     }
193 
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(_value <= allowed[_from][msg.sender]);
196         allowed[_from][msg.sender].ssub(_value);
197         totalSupply.ssub(_value);
198         Burn(_from, _value);
199         return true;
200     }
201 	
202 }