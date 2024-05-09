1 interface ERC20 {
2   function balanceOf(address who) public view returns (uint256);
3   function transfer(address to, uint256 value) public returns (bool);
4   function allowance(address owner, address spender) public view returns (uint256);
5   function transferFrom(address from, address to, uint256 value) public returns (bool);
6   function approve(address spender, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8   event Approval(address indexed owner, address indexed spender, uint256 value);
9 }
10 
11 interface ERC223 {
12     function transfer(address to, uint value, bytes data) public;
13     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
14 }
15 
16 contract ERC223ReceivingContract { 
17     function tokenFallback(address _from, uint _value, bytes _data) public;
18 }
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 contract StandardToken is ERC20, ERC223 {
54   using SafeMath for uint;
55      
56     string internal _name;
57     string internal _symbol;
58     uint8 internal _decimals;
59     uint256 internal _totalSupply;
60 
61     mapping (address => uint256) internal balances;
62     mapping (address => mapping (address => uint256)) internal allowed;
63 
64     function StandardToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
65         _symbol = symbol;
66         _name = name;
67         _decimals = decimals;
68         _totalSupply = totalSupply;
69         balances[msg.sender] = totalSupply;
70     }
71 
72     function name()
73         public
74         view
75         returns (string) {
76         return _name;
77     }
78 
79     function symbol()
80         public
81         view
82         returns (string) {
83         return _symbol;
84     }
85 
86     function decimals()
87         public
88         view
89         returns (uint8) {
90         return _decimals;
91     }
92 
93     function totalSupply()
94         public
95         view
96         returns (uint256) {
97         return _totalSupply;
98     }
99 
100    function transfer(address _to, uint256 _value) public returns (bool) {
101      require(_to != address(0));
102      require(_value <= balances[msg.sender]);
103      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
104      balances[_to] = SafeMath.add(balances[_to], _value);
105      Transfer(msg.sender, _to, _value);
106      return true;
107    }
108 
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return balances[_owner];
111    }
112 
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115      require(_value <= balances[_from]);
116      require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = SafeMath.sub(balances[_from], _value);
119      balances[_to] = SafeMath.add(balances[_to], _value);
120      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
121     Transfer(_from, _to, _value);
122      return true;
123    }
124 
125    function approve(address _spender, uint256 _value) public returns (bool) {
126      allowed[msg.sender][_spender] = _value;
127      Approval(msg.sender, _spender, _value);
128      return true;
129    }
130 
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132      return allowed[_owner][_spender];
133    }
134 
135    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
137      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138      return true;
139    }
140 
141   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142      uint oldValue = allowed[msg.sender][_spender];
143      if (_subtractedValue > oldValue) {
144        allowed[msg.sender][_spender] = 0;
145      } else {
146        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
147     }
148      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149      return true;
150    }
151    
152   function transfer(address _to, uint _value, bytes _data) public {
153     require(_value > 0 );
154     if(isContract(_to)) {
155         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
156         receiver.tokenFallback(msg.sender, _value, _data);
157     }
158         balances[msg.sender] = balances[msg.sender].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         Transfer(msg.sender, _to, _value, _data);
161     }
162     
163   function isContract(address _addr) private returns (bool is_contract) {
164       uint length;
165       assembly {
166             //retrieve the size of the code on target address, this needs assembly
167             length := extcodesize(_addr)
168       }
169       return (length>0);
170     }
171 
172 
173 }