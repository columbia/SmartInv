1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title EUROPEAN INVESTMENT FINANCIAL CENTER LTD (EIB)
5  *        53 Bedford Square, Fitzrovia, London, United Kingdom, WC1B 3DP
6  *        https://www.EIB.ai
7  *        https://t.me/EIB_exchange (Support)
8  */
9 
10 // File: contracts/browser/SafeMath.sol
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 // File: contracts/browser/ERC20.sol
46 
47 interface ERC20 {
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   function allowance(address owner, address spender) public view returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 // File: contracts/browser/ERC223.sol
58 
59 /**
60  * @title ERC223
61  * @dev ERC223 contract interface with ERC20 functions and events
62  *      Fully backward compatible with ERC20
63  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
64  */
65 
66 interface ERC223 {
67     function transfer(address to, uint value, bytes data) public;
68     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
69 }
70 
71 // File: contracts/browser/ContractReceiver.sol
72 
73  /*
74  * Contract that is working with ERC223 tokens
75  */
76 
77 contract ContractReceiver {
78 
79     struct TKN {
80         address sender;
81         uint value;
82         bytes data;
83         bytes4 sig;
84     }
85 
86     function tokenFallback(address _from, uint _value, bytes _data){
87       TKN memory tkn;
88       tkn.sender = _from;
89       tkn.value = _value;
90       tkn.data = _data;
91       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
92       tkn.sig = bytes4(u);
93 
94       /* tkn variable is analogue of msg variable of Ether transaction
95       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
96       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
97       *  tkn.data is data of token transaction   (analogue of msg.data)
98       *  tkn.sig is 4 bytes signature of function
99       *  if data of token transaction is a function execution
100       */
101     }
102 
103     function rewiewToken  () returns (address, uint, bytes, bytes4) {
104         TKN memory tkn;
105 
106         return (tkn.sender, tkn.value, tkn.data, tkn.sig);
107 
108     }
109 }
110 
111 // File: contracts/browser/ERC223ReceivingContract.sol
112 
113 /**
114  * 彡EUROPEAN INVESTMENT FINANCIAL CENTER LTD
115  * @title EIB
116  * @author FRASER, Matthew & EIB people
117  * @dev EIB is an ERC223 Token with ERC20 functions and events
118  *      Fully backward compatible with ERC20
119  */
120  
121 contract ERC223ReceivingContract { 
122     function tokenFallback(address _from, uint _value, bytes _data) public;
123 }
124 
125 contract EIB is ERC20, ERC223 {
126   using SafeMath for uint;
127      
128     string internal _name;
129     string internal _symbol;
130     uint8 internal _decimals;
131     uint256 internal _totalSupply;
132 
133     mapping (address => uint256) internal balances;
134     mapping (address => mapping (address => uint256)) internal allowed;
135 
136     function EIB (string name, string symbol, uint8 decimals, uint256 totalSupply) public {
137         _symbol = "EIB";
138         _name = "EIB";
139         _decimals = 18;
140         _totalSupply = 30e9 * 1e18;
141         balances[msg.sender] = 30e9 * 1e18;
142     }
143 
144     function name()
145         public
146         view
147         returns (string) {
148         return _name;
149     }
150 
151     function symbol()
152         public
153         view
154         returns (string) {
155         return _symbol;
156     }
157 
158     function decimals()
159         public
160         view
161         returns (uint8) {
162         return _decimals;
163     }
164 
165     function totalSupply()
166         public
167         view
168         returns (uint256) {
169         return _totalSupply;
170     }
171 
172    function transfer(address _to, uint256 _value) public returns (bool) {
173      require(_to != address(0));
174      require(_value <= balances[msg.sender]);
175      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
176      balances[_to] = SafeMath.add(balances[_to], _value);
177      Transfer(msg.sender, _to, _value);
178      return true;
179    }
180 
181   function balanceOf(address _owner) public view returns (uint256 balance) {
182     return balances[_owner];
183    }
184 
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187      require(_value <= balances[_from]);
188      require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = SafeMath.sub(balances[_from], _value);
191      balances[_to] = SafeMath.add(balances[_to], _value);
192      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
193     Transfer(_from, _to, _value);
194      return true;
195    }
196 
197    function approve(address _spender, uint256 _value) public returns (bool) {
198      allowed[msg.sender][_spender] = _value;
199      Approval(msg.sender, _spender, _value);
200      return true;
201    }
202 
203   function allowance(address _owner, address _spender) public view returns (uint256) {
204      return allowed[_owner][_spender];
205    }
206 
207    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
208      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
209      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210      return true;
211    }
212 
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214      uint oldValue = allowed[msg.sender][_spender];
215      if (_subtractedValue > oldValue) {
216        allowed[msg.sender][_spender] = 0;
217      } else {
218        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
219     }
220      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221      return true;
222    }
223    
224   function transfer(address _to, uint _value, bytes _data) public {
225     require(_value > 0 );
226     if(isContract(_to)) {
227         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
228         receiver.tokenFallback(msg.sender, _value, _data);
229     }
230         balances[msg.sender] = balances[msg.sender].sub(_value);
231         balances[_to] = balances[_to].add(_value);
232         Transfer(msg.sender, _to, _value, _data);
233     }
234     
235   function isContract(address _addr) private returns (bool is_contract) {
236       uint length;
237       assembly {
238             //retrieve the size of the code on target address, this needs assembly
239             length := extcodesize(_addr)
240       }
241       return (length>0);
242     }
243 
244 }
245 
246 /*
247  * ERC20/ERC223 - EIB
248  *     Created by EIB.ai
249  */