1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Bitbucx'  token contract
5 //
6 // Symbol      : BTCX
7 // Name        : Bitbucx
8 // Total supply: 31 300 000
9 // Decimals    : 8
10 // (c) by Team @ Bitbucx 2019.
11 // ----------------------------------------------------------------------------
12 
13 
14 
15 //interface ERC20
16 
17 interface ERC20 {
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 //----X-----
28 
29 
30 //interface ERC223
31 
32 interface ERC223 {
33     function transfer(address to, uint value, bytes data) public;
34     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
35 }
36 
37 //----X-----
38 
39 
40 // contract Recieving ether
41 
42 contract ERC223ReceivingContract { 
43     function tokenFallback(address _from, uint _value, bytes _data) public;
44 }
45 
46 //----X-----
47 
48 
49 
50 // SafeMath library
51 
52 library SafeMath {
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a / b;
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 //----X-----
80 
81 contract Ownable {
82   address public owner;
83 
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86   constructor() public {
87     owner = msg.sender;
88   }
89 
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     emit OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101 }
102 
103 
104 // standard token contract 
105 contract StandardToken is ERC20, ERC223, Ownable {
106   using SafeMath for uint;
107      
108     string internal _name;
109     string internal _symbol;
110     uint8 internal _decimals;
111     uint256 internal _totalSupply;
112 
113     mapping (address => uint256) internal balances;
114     mapping (address => mapping (address => uint256)) internal allowed;
115 
116     function StandardToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
117         _symbol = symbol;
118         _name = name;
119         _decimals = decimals;
120         _totalSupply = totalSupply;
121         balances[msg.sender] = totalSupply;
122     }
123 
124     function name()
125         public
126         view
127         returns (string) {
128         return _name;
129     }
130 
131     function symbol()
132         public
133         view
134         returns (string) {
135         return _symbol;
136     }
137 
138     function decimals()
139         public
140         view
141         returns (uint8) {
142         return _decimals;
143     }
144 
145     function totalSupply()
146         public
147         view
148         returns (uint256) {
149         return _totalSupply;
150     }
151 
152    function transfer(address _to, uint256 _value) public returns (bool) {
153      require(_to != address(0));
154      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
155      balances[_to] = SafeMath.add(balances[_to], _value);
156      Transfer(msg.sender, _to, _value);
157      return true;
158    }
159 
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162    }
163 
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166 
167     balances[_from] = SafeMath.sub(balances[_from], _value);
168      balances[_to] = SafeMath.add(balances[_to], _value);
169      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
170     Transfer(_from, _to, _value);
171      return true;
172    }
173 
174    function approve(address _spender, uint256 _value) public returns (bool) {
175      allowed[msg.sender][_spender] = _value;
176      Approval(msg.sender, _spender, _value);
177      return true;
178    }
179 
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181      return allowed[_owner][_spender];
182    }
183 
184    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
186      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187      return true;
188    }
189 
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191      uint oldValue = allowed[msg.sender][_spender];
192      if (_subtractedValue > oldValue) {
193        allowed[msg.sender][_spender] = 0;
194      } else {
195        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
196     }
197      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198      return true;
199    }
200 
201     function transfer(address _to, uint _value, bytes _data) {
202         // Standard function transfer similar to ERC20 transfer with no _data .
203         // Added due to backwards compatibility reasons .
204         uint codeLength;
205 
206         assembly {
207             // Retrieve the size of the code on target address, this needs assembly .
208             codeLength := extcodesize(_to)
209         }
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         if(codeLength>0) {
214             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
215             receiver.tokenFallback(msg.sender, _value, _data);
216         }
217         emit Transfer(msg.sender, _to, _value, _data);
218     }
219     
220   function isContract(address _addr) private returns (bool is_contract) {
221       uint length;
222       assembly {
223             length := extcodesize(_addr)
224       }
225       return (length>0);
226     }
227 
228 
229 }