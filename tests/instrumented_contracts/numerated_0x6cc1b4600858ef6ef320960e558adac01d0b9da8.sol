1 pragma solidity ^0.4.10;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 
40 
41 
42 
43 
44 
45 interface ERC20 {
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 
56 
57 
58 
59 
60 
61 interface ERC223 {
62     function transfer(address to, uint value, bytes data) public;
63     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
64 }
65 
66 
67 
68 
69 
70 
71 
72 
73 contract ERC223ReceivingContract { 
74     function tokenFallback(address _from, uint _value, bytes _data) public;
75 }
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 contract StandardToken is ERC20, ERC223 {
90   using SafeMath for uint;
91      
92     string internal _name;
93     string internal _symbol;
94     uint8 internal _decimals;
95     uint256 internal _totalSupply;
96 
97     mapping (address => uint256) internal balances;
98     mapping (address => mapping (address => uint256)) internal allowed;
99 
100     function StandardToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
101         _symbol = symbol;
102         _name = name;
103         _decimals = decimals;
104         _totalSupply = totalSupply;
105         balances[msg.sender] = totalSupply;
106     }
107 
108     function name()
109         public
110         view
111         returns (string) {
112         return _name;
113     }
114 
115     function symbol()
116         public
117         view
118         returns (string) {
119         return _symbol;
120     }
121 
122     function decimals()
123         public
124         view
125         returns (uint8) {
126         return _decimals;
127     }
128 
129     function totalSupply()
130         public
131         view
132         returns (uint256) {
133         return _totalSupply;
134     }
135 
136    function transfer(address _to, uint256 _value) public returns (bool) {
137      require(_to != address(0));
138      require(_value <= balances[msg.sender]);
139      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
140      balances[_to] = SafeMath.add(balances[_to], _value);
141      Transfer(msg.sender, _to, _value);
142      return true;
143    }
144 
145   function balanceOf(address _owner) public view returns (uint256 balance) {
146     return balances[_owner];
147    }
148 
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151      require(_value <= balances[_from]);
152      require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = SafeMath.sub(balances[_from], _value);
155      balances[_to] = SafeMath.add(balances[_to], _value);
156      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
157     Transfer(_from, _to, _value);
158      return true;
159    }
160 
161    function approve(address _spender, uint256 _value) public returns (bool) {
162      allowed[msg.sender][_spender] = _value;
163      Approval(msg.sender, _spender, _value);
164      return true;
165    }
166 
167   function allowance(address _owner, address _spender) public view returns (uint256) {
168      return allowed[_owner][_spender];
169    }
170 
171    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
172      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
173      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174      return true;
175    }
176 
177   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178      uint oldValue = allowed[msg.sender][_spender];
179      if (_subtractedValue > oldValue) {
180        allowed[msg.sender][_spender] = 0;
181      } else {
182        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
183     }
184      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185      return true;
186    }
187    
188   function transfer(address _to, uint _value, bytes _data) public {
189     require(_value > 0 );
190     if(isContract(_to)) {
191         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
192         receiver.tokenFallback(msg.sender, _value, _data);
193     }
194         balances[msg.sender] = balances[msg.sender].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         Transfer(msg.sender, _to, _value, _data);
197     }
198     
199   function isContract(address _addr) private returns (bool is_contract) {
200       uint length;
201       assembly {
202             //retrieve the size of the code on target address, this needs assembly
203             length := extcodesize(_addr)
204       }
205       return (length>0);
206     }
207 
208 
209 }