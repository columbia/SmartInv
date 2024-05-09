1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title DECENTRALIZATION EXCHANGE LTD
5  *        62a West Hill, London, United Kingdom, SW18 1RU
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 interface ERC20 {
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 /**
52  * @title ERC223
53  * @dev ERC223 contract interface with ERC20 functions and events
54  *      Fully backward compatible with ERC20
55  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
56  */
57 
58 interface ERC223 {
59     function transfer(address to, uint value, bytes data) public;
60     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
61 }
62 
63  /*
64  * Contract that is working with ERC223 tokens
65  */
66 
67 contract ContractReceiver {
68 
69     struct TKN {
70         address sender;
71         uint value;
72         bytes data;
73         bytes4 sig;
74     }
75 
76 
77     function tokenFallback(address _from, uint _value, bytes _data){
78       TKN memory tkn;
79       tkn.sender = _from;
80       tkn.value = _value;
81       tkn.data = _data;
82       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
83       tkn.sig = bytes4(u);
84 
85       /* tkn variable is analogue of msg variable of Ether transaction
86       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
87       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
88       *  tkn.data is data of token transaction   (analogue of msg.data)
89       *  tkn.sig is 4 bytes signature of function
90       *  if data of token transaction is a function execution
91       */
92     }
93 
94     function rewiewToken  () returns (address, uint, bytes, bytes4) {
95         TKN memory tkn;
96 
97         return (tkn.sender, tkn.value, tkn.data, tkn.sig);
98 
99     }
100 }
101 
102 /**
103  * DECENTRALIZATION EXCHANGE LTD
104  * 62a West Hill, London, United Kingdom, SW18 1RU
105  */
106  
107 contract ERC223ReceivingContract { 
108     function tokenFallback(address _from, uint _value, bytes _data) public;
109 }
110 
111 contract SmartExchange is ERC20, ERC223 {
112   using SafeMath for uint;
113      
114     string internal _name;
115     string internal _symbol;
116     uint8 internal _decimals;
117     uint256 internal _totalSupply;
118 
119     mapping (address => uint256) internal balances;
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122     function SmartExchange (string name, string symbol, uint8 decimals, uint256 totalSupply) public {
123         _symbol = "SDE";
124         _name = "Smart Exchange";
125         _decimals = 18;
126         _totalSupply = 28000000 * 1e18;
127         balances[msg.sender] = 28000000 * 1e18;
128     }
129 
130     function name()
131         public
132         view
133         returns (string) {
134         return _name;
135     }
136 
137     function symbol()
138         public
139         view
140         returns (string) {
141         return _symbol;
142     }
143 
144     function decimals()
145         public
146         view
147         returns (uint8) {
148         return _decimals;
149     }
150 
151     function totalSupply()
152         public
153         view
154         returns (uint256) {
155         return _totalSupply;
156     }
157 
158    function transfer(address _to, uint256 _value) public returns (bool) {
159      require(_to != address(0));
160      require(_value <= balances[msg.sender]);
161      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
162      balances[_to] = SafeMath.add(balances[_to], _value);
163      Transfer(msg.sender, _to, _value);
164      return true;
165    }
166 
167   function balanceOf(address _owner) public view returns (uint256 balance) {
168     return balances[_owner];
169    }
170 
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173      require(_value <= balances[_from]);
174      require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = SafeMath.sub(balances[_from], _value);
177      balances[_to] = SafeMath.add(balances[_to], _value);
178      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
179     Transfer(_from, _to, _value);
180      return true;
181    }
182 
183    function approve(address _spender, uint256 _value) public returns (bool) {
184      allowed[msg.sender][_spender] = _value;
185      Approval(msg.sender, _spender, _value);
186      return true;
187    }
188 
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190      return allowed[_owner][_spender];
191    }
192 
193    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
195      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196      return true;
197    }
198 
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200      uint oldValue = allowed[msg.sender][_spender];
201      if (_subtractedValue > oldValue) {
202        allowed[msg.sender][_spender] = 0;
203      } else {
204        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
205     }
206      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207      return true;
208    }
209    
210   function transfer(address _to, uint _value, bytes _data) public {
211     require(_value > 0 );
212     if(isContract(_to)) {
213         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
214         receiver.tokenFallback(msg.sender, _value, _data);
215     }
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         Transfer(msg.sender, _to, _value, _data);
219     }
220     
221   function isContract(address _addr) private returns (bool is_contract) {
222       uint length;
223       assembly {
224             //retrieve the size of the code on target address, this needs assembly
225             length := extcodesize(_addr)
226       }
227       return (length>0);
228     }
229 
230 }