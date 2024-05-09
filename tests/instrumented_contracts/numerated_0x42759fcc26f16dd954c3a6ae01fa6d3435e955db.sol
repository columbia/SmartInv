1 pragma solidity ^0.4.25;
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
32 interface ERC20 {
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   function allowance(address owner, address spender) public view returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 interface ERC223 {
43     function transfer(address to, uint value, bytes data) public;
44     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
45 }
46 
47 contract ERC223ReceivingContract { 
48     function tokenFallback(address _from, uint _value, bytes _data) public;
49 }
50 
51 contract AXD is ERC20, ERC223 {
52   using SafeMath for uint;
53      
54     string internal _name;
55     string internal _symbol;
56     uint8 internal _decimals;
57     uint256 internal _totalSupply;
58 
59     mapping (address => uint256) internal balances;
60     mapping (address => mapping (address => uint256)) internal allowed;
61 
62     function AXD(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
63         _symbol = symbol;
64         _name = name;
65         _decimals = decimals;
66         _totalSupply = totalSupply;
67         balances[msg.sender] = totalSupply;
68     }
69 
70     function name()
71         public
72         view
73         returns (string) {
74         return _name;
75     }
76 
77     function symbol()
78         public
79         view
80         returns (string) {
81         return _symbol;
82     }
83 
84     function decimals()
85         public
86         view
87         returns (uint8) {
88         return _decimals;
89     }
90 
91     function totalSupply()
92         public
93         view
94         returns (uint256) {
95         return _totalSupply;
96     }
97 
98    function transfer(address _to, uint256 _value) public returns (bool) {
99      require(_to != address(0));
100      require(_value <= balances[msg.sender]);
101      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
102      balances[_to] = SafeMath.add(balances[_to], _value);
103      Transfer(msg.sender, _to, _value);
104      return true;
105    }
106 
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109    }
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113      require(_value <= balances[_from]);
114      require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = SafeMath.sub(balances[_from], _value);
117      balances[_to] = SafeMath.add(balances[_to], _value);
118      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
119     Transfer(_from, _to, _value);
120      return true;
121    }
122 
123    function approve(address _spender, uint256 _value) public returns (bool) {
124      allowed[msg.sender][_spender] = _value;
125      Approval(msg.sender, _spender, _value);
126      return true;
127    }
128 
129   function allowance(address _owner, address _spender) public view returns (uint256) {
130      return allowed[_owner][_spender];
131    }
132 
133    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
134      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
135      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136      return true;
137    }
138 
139   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
140      uint oldValue = allowed[msg.sender][_spender];
141      if (_subtractedValue > oldValue) {
142        allowed[msg.sender][_spender] = 0;
143      } else {
144        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
145     }
146      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147      return true;
148    }
149    
150   function transfer(address _to, uint _value, bytes _data) public {
151     require(_value > 0 );
152     if(isContract(_to)) {
153         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
154         receiver.tokenFallback(msg.sender, _value, _data);
155     }
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         Transfer(msg.sender, _to, _value, _data);
159     }
160     
161   function isContract(address _addr) private returns (bool is_contract) {
162       uint length;
163       assembly {
164             //retrieve the size of the code on target address, this needs assembly
165             length := extcodesize(_addr)
166       }
167       return (length>0);
168     }
169 }