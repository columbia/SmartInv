1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 pragma solidity ^0.5.0;
33 
34 interface ERC20 {
35   function balanceOf(address who) external view returns (uint256);
36   function transfer(address to, uint256 value) external returns (bool);
37   function allowance(address owner, address spender) external view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) external returns (bool);
39   function approve(address spender, uint256 value) external returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 pragma solidity ^0.5.0;
45 
46 interface ERC223 {
47     function transfer(address to, uint value, bytes calldata data) external;
48     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
49 }
50 
51 pragma solidity ^0.5.0;
52 
53 contract ERC223ReceivingContract { 
54     function tokenFallback(address _from, uint _value, bytes memory _data) public;
55 }
56 
57 pragma solidity ^0.5.0;
58 
59 contract bitcoinTwo is ERC20, ERC223 {
60   using SafeMath for uint;
61      
62     string internal _name;
63     string internal _symbol;
64     uint8 internal _decimals;
65     uint256 internal _totalSupply;
66 
67     mapping (address => uint256) internal balances;
68     mapping (address => mapping (address => uint256)) internal allowed;
69 
70     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public {
71         _symbol = symbol;
72         _name = name;
73         _decimals = decimals;
74         _totalSupply = totalSupply;
75         balances[msg.sender] = totalSupply;
76     }
77 
78     function name()
79         public
80         view
81         returns (string memory) {
82         return _name;
83     }
84 
85     function symbol()
86         public
87         view
88         returns (string memory) {
89         return _symbol;
90     }
91 
92     function decimals()
93         public
94         view
95         returns (uint8) {
96         return _decimals;
97     }
98 
99     function totalSupply()
100         public
101         view
102         returns (uint256) {
103         return _totalSupply;
104     }
105 
106    function transfer(address _to, uint256 _value) public returns (bool) {
107      require(_to != address(0));
108      require(_value <= balances[msg.sender]);
109      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
110      balances[_to] = SafeMath.add(balances[_to], _value);
111      emit Transfer(msg.sender, _to, _value);
112      return true;
113    }
114 
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117    }
118 
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121      require(_value <= balances[_from]);
122      require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = SafeMath.sub(balances[_from], _value);
125      balances[_to] = SafeMath.add(balances[_to], _value);
126      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
127      emit Transfer(_from, _to, _value);
128      return true;
129    }
130 
131    function approve(address _spender, uint256 _value) public returns (bool) {
132      allowed[msg.sender][_spender] = _value;
133      emit Approval(msg.sender, _spender, _value);
134      return true;
135    }
136 
137   function allowance(address _owner, address _spender) public view returns (uint256) {
138      return allowed[_owner][_spender];
139    }
140 
141    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
143      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144      return true;
145    }
146 
147   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148      uint oldValue = allowed[msg.sender][_spender];
149      if (_subtractedValue > oldValue) {
150        allowed[msg.sender][_spender] = 0;
151      } else {
152        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
153     }
154      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155      return true;
156    }
157    
158    function transfer(address _to, uint _value, bytes calldata _data) external {
159     require(_value > 0 );
160     if(isContract(_to)) {
161         ERC223ReceivingContract receiver =         ERC223ReceivingContract(_to);
162         receiver.tokenFallback(msg.sender, _value, _data);
163     }
164         balances[msg.sender] = balances[msg.sender].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         emit Transfer(msg.sender, _to, _value, _data);
167     }
168     
169     function isContract(address _addr) private view returns (bool is_contract) {
170       uint length;
171       assembly {
172             //retrieve the size of the code on target address, this needs assembly
173             length := extcodesize(_addr)
174       }
175       return (length>0);
176     }
177 
178 }