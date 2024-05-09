1 pragma solidity ^0.4.10;
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
42 
43 interface ERC223 {
44     function transfer(address to, uint value, bytes data) public;
45     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
46 }
47 
48 contract ERC223ReceivingContract { 
49     function tokenFallback(address _from, uint _value, bytes _data) public;
50 }
51 
52 contract StandardToken is ERC20, ERC223 {
53   using SafeMath for uint;
54      
55     string internal _name;
56     string internal _symbol;
57     uint8 internal _decimals;
58     uint256 internal _totalSupply;
59 
60     mapping (address => uint256) internal balances;
61     mapping (address => mapping (address => uint256)) internal allowed;
62 
63     function StandardToken(string name, string symbol, uint8 decimals, uint256 initialSupply) public {
64         _symbol = symbol;
65         _name = name;
66         _decimals = decimals;
67         _totalSupply = initialSupply * 10 ** uint256(decimals); 
68         balances[msg.sender] = _totalSupply;
69     }
70 
71     function name()
72         public
73         view
74         returns (string) {
75         return _name;
76     }
77 
78     function symbol()
79         public
80         view
81         returns (string) {
82         return _symbol;
83     }
84 
85     function decimals()
86         public
87         view
88         returns (uint8) {
89         return _decimals;
90     }
91 
92     function totalSupply()
93         public
94         view
95         returns (uint256) {
96         return _totalSupply;
97     }
98 
99    function transfer(address _to, uint256 _value) public returns (bool) {
100      require(_to != address(0));
101      require(_value <= balances[msg.sender]);
102      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
103      balances[_to] = SafeMath.add(balances[_to], _value);
104      Transfer(msg.sender, _to, _value);
105      return true;
106    }
107 
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110    }
111 
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114      require(_value <= balances[_from]);
115      require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = SafeMath.sub(balances[_from], _value);
118      balances[_to] = SafeMath.add(balances[_to], _value);
119      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
120     Transfer(_from, _to, _value);
121      return true;
122    }
123 
124    function approve(address _spender, uint256 _value) public returns (bool) {
125      allowed[msg.sender][_spender] = _value;
126      Approval(msg.sender, _spender, _value);
127      return true;
128    }
129 
130   function allowance(address _owner, address _spender) public view returns (uint256) {
131      return allowed[_owner][_spender];
132    }
133 
134    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
136      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137      return true;
138    }
139 
140   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141      uint oldValue = allowed[msg.sender][_spender];
142      if (_subtractedValue > oldValue) {
143        allowed[msg.sender][_spender] = 0;
144      } else {
145        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
146     }
147      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148      return true;
149    }
150    
151   function transfer(address _to, uint _value, bytes _data) public {
152     require(_value > 0 );
153     if(isContract(_to)) {
154         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
155         receiver.tokenFallback(msg.sender, _value, _data);
156     }
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         Transfer(msg.sender, _to, _value, _data);
160     }
161     
162   function isContract(address _addr) private returns (bool is_contract) {
163       uint length;
164       assembly {
165             //retrieve the size of the code on target address, this needs assembly
166             length := extcodesize(_addr)
167       }
168       return (length>0);
169     }
170 
171 
172 }