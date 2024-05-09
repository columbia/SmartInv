1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 interface ERC20 {
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 interface ERC223 {
61     function transfer(address to, uint value, bytes data) public;
62     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
63 }
64 
65 contract ERC223ReceivingContract { 
66     function tokenFallback(address _from, uint _value, bytes _data) public;
67 }
68 
69 contract LIZAToken is ERC20, ERC223 {
70   using SafeMath for uint;
71      
72     string internal _name;
73     string internal _symbol;
74     uint8 internal _decimals;
75     uint256 internal _totalSupply;
76 
77     mapping (address => uint256) internal balances;
78     mapping (address => mapping (address => uint256)) internal allowed;
79 
80     function LIZAToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
81         _symbol = symbol;
82         _name = name;
83         _decimals = decimals;
84         _totalSupply = totalSupply;
85         balances[msg.sender] = totalSupply;
86     }
87 
88     function name()
89         public
90         view
91         returns (string) {
92         return _name;
93     }
94 
95     function symbol()
96         public
97         view
98         returns (string) {
99         return _symbol;
100     }
101 
102     function decimals()
103         public
104         view
105         returns (uint8) {
106         return _decimals;
107     }
108 
109     function totalSupply()
110         public
111         view
112         returns (uint256) {
113         return _totalSupply;
114     }
115 
116     function transfer(address _to, uint256 _value) public returns (bool) {
117      require(_to != address(0));
118      require(_value <= balances[msg.sender]);
119      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
120      balances[_to] = SafeMath.add(balances[_to], _value);
121      Transfer(msg.sender, _to, _value);
122      return true;
123    }
124 
125    function balanceOf(address _owner) public view returns (uint256 balance) {
126     return balances[_owner];
127    }
128 
129    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131      require(_value <= balances[_from]);
132      require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = SafeMath.sub(balances[_from], _value);
135      balances[_to] = SafeMath.add(balances[_to], _value);
136      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
137     Transfer(_from, _to, _value);
138      return true;
139    }
140 
141    function approve(address _spender, uint256 _value) public returns (bool) {
142      allowed[msg.sender][_spender] = _value;
143      Approval(msg.sender, _spender, _value);
144      return true;
145    }
146 
147    function allowance(address _owner, address _spender) public view returns (uint256) {
148      return allowed[_owner][_spender];
149    }
150 
151    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
152      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
153      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154      return true;
155    }
156 
157     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
158      uint oldValue = allowed[msg.sender][_spender];
159      if (_subtractedValue > oldValue) {
160        allowed[msg.sender][_spender] = 0;
161      } else {
162        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
163     }
164      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165      return true;
166    }
167    
168     function transfer(address _to, uint _value, bytes _data) public {
169     require(_value > 0 );
170     if(isContract(_to)) {
171         ERC223ReceivingContract receiver =         ERC223ReceivingContract(_to);
172         receiver.tokenFallback(msg.sender, _value, _data);
173     }
174         balances[msg.sender] = balances[msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         Transfer(msg.sender, _to, _value, _data);
177     }
178 
179     function isContract(address _addr) private returns (bool is_contract) {
180       uint length;
181       assembly {
182             //retrieve the size of the code on target address, this needs assembly
183             length := extcodesize(_addr)
184       }
185       return (length>0);
186     }
187 
188 }