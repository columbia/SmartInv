1 pragma solidity ^0.4.19;
2 
3 interface ERC20 {
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   function allowance(address owner, address spender) public view returns (uint256);
7   function transferFrom(address from, address to, uint256 value) public returns (bool);
8   function approve(address spender, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 interface ERC223 {
14     function transfer(address to, uint value, bytes data) public;
15     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
16 }
17 
18 contract ERC223ReceivingContract { 
19     function tokenFallback(address _from, uint _value, bytes _data) public;
20 }
21 
22 contract MoonMinerToken is ERC20, ERC223 {
23   using SafeMath for uint;
24      
25     string internal _name;
26     string internal _symbol;
27     uint8 internal _decimals;
28     uint256 internal _totalSupply;
29 
30     mapping (address => uint256) internal balances;
31     mapping (address => mapping (address => uint256)) internal allowed;
32 
33     function MoonMinerToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
34         _symbol = symbol;
35         _name = name;
36         _decimals = decimals;
37         _totalSupply = totalSupply * 10 ** uint256(decimals);
38         balances[msg.sender] = totalSupply * 10 ** uint256(decimals);
39     }
40 
41     function name()
42         public
43         view
44         returns (string) {
45         return _name;
46     }
47 
48     function symbol()
49         public
50         view
51         returns (string) {
52         return _symbol;
53     }
54 
55     function decimals()
56         public
57         view
58         returns (uint8) {
59         return _decimals;
60     }
61 
62     function totalSupply()
63         public
64         view
65         returns (uint256) {
66         return _totalSupply;
67     }
68 
69 
70    function transfer(address _to, uint256 _value) public returns (bool) {
71      require(_to != address(0));
72      require(_value <= balances[msg.sender]);
73      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
74      balances[_to] = SafeMath.add(balances[_to], _value);
75      Transfer(msg.sender, _to, _value);
76      return true;
77    }
78 
79   function balanceOf(address _owner) public view returns (uint256 balance) {
80     return balances[_owner];
81    }
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84      require(_to != address(0));
85      require(_value <= balances[_from]);
86      require(_value <= allowed[_from][msg.sender]);
87 
88      balances[_from] = SafeMath.sub(balances[_from], _value);
89      balances[_to] = SafeMath.add(balances[_to], _value);
90      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
91      Transfer(_from, _to, _value);
92      return true;
93    }
94 
95    function approve(address _spender, uint256 _value) public returns (bool) {
96      allowed[msg.sender][_spender] = _value;
97      Approval(msg.sender, _spender, _value);
98      return true;
99    }
100 
101   function allowance(address _owner, address _spender) public view returns (uint256) {
102      return allowed[_owner][_spender];
103    }
104 
105    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
106      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
107      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108      return true;
109    }
110 
111   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
112      uint oldValue = allowed[msg.sender][_spender];
113      if (_subtractedValue > oldValue) {
114        allowed[msg.sender][_spender] = 0;
115      } else {
116        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
117     }
118      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119      return true;
120    }
121 
122     function transfer(address _to, uint _value, bytes _data) public {
123         require(_value > 0 );
124         if(isContract(_to)) {
125             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
126             receiver.tokenFallback(msg.sender, _value, _data);
127         }
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         Transfer(msg.sender, _to, _value, _data);
131     }
132 
133     function isContract(address _addr) private returns (bool is_contract) {
134       uint length;
135       assembly {
136             //retrieve the size of the code on target address, this needs assembly
137             length := extcodesize(_addr)
138       }
139       return (length>0);
140     }
141 
142 }
143 
144 library SafeMath {
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155     // assert(b > 0); // Solidity automatically throws when dividing by 0
156     uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158     return c;
159   }
160 
161   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   function add(uint256 a, uint256 b) internal pure returns (uint256) {
167     uint256 c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }