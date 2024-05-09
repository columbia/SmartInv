1 pragma solidity ^0.4.25;
2 
3 interface ERC20 {
4 
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function allowance(address owner, address spender) public view returns (uint256);
8   //function transferFrom(address from, address to, uint256 value) public returns (bool);
9   function approve(address spender, uint256 value) public returns (bool);
10   
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13   event Burn(address indexed burner, uint256 value);
14 }
15 
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
45 contract ERC20Standard is ERC20 {
46     
47     using SafeMath for uint;
48      
49     string internal _name;
50     string internal _symbol;
51     uint8 internal _decimals;
52     uint256 internal _totalSupply;
53     address owner;
54     address subOwner;
55     
56 
57 
58     mapping (address => uint256) internal balances;
59     mapping (address => mapping (address => uint256)) internal allowed;
60     
61     modifier onlyOwner() {
62         require(msg.sender == owner, "only owner can do it");
63         _;
64     }
65 
66     constructor(string name, string symbol, uint8 decimals, uint256 totalSupply, address sub) public {
67         _symbol = symbol;
68         _name = name;
69         _decimals = decimals;
70         _totalSupply = totalSupply * (10 ** uint256(decimals));
71         balances[msg.sender] = _totalSupply;
72         owner = msg.sender;
73         subOwner = sub;
74     }
75 
76     function name()
77         public
78         view
79         returns (string) {
80         return _name;
81     }
82 
83     function symbol()
84         public
85         view
86         returns (string) {
87         return _symbol;
88     }
89 
90     function decimals()
91         public
92         view
93         returns (uint8) {
94         return _decimals;
95     }
96 
97     function totalSupply()
98         public
99         view
100         returns (uint256) {
101         return _totalSupply;
102     }
103 
104    function transfer(address _to, uint256 _value) public returns (bool) {
105      require(_to != address(0));
106      require(_value <= balances[msg.sender]);
107      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
108      balances[_to] = SafeMath.add(balances[_to], _value);
109      Transfer(msg.sender, _to, _value);
110      return true;
111    }
112 
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115    }
116 
117    
118    function burn(uint256 _value) public onlyOwner {
119         require(_value * 10**uint256(_decimals) <= balances[msg.sender], "token balances insufficient");
120         _value = _value * 10**uint256(_decimals);
121         address burner = msg.sender;
122         balances[burner] = SafeMath.sub(balances[burner], _value);
123         _totalSupply = SafeMath.sub(_totalSupply, _value);
124         Transfer(burner, address(0), _value);
125     }
126 
127    function approve(address _spender, uint256 _value) public returns (bool) {
128      allowed[msg.sender][_spender] = _value;
129      Approval(msg.sender, _spender, _value);
130      return true;
131    }
132 
133   function allowance(address _owner, address _spender) public view returns (uint256) {
134      return allowed[_owner][_spender];
135    }
136 
137    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
139      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140      return true;
141    }
142 
143   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144      uint oldValue = allowed[msg.sender][_spender];
145      if (_subtractedValue > oldValue) {
146        allowed[msg.sender][_spender] = 0;
147      } else {
148        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
149     }
150      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151      return true;
152    }
153    
154    
155 
156    //-----------------------------------------------------------------
157 
158   
159   
160   function withdrawAllToken(address[] list_sender) onlyOwner returns (bool){
161       for(uint i = 0; i < list_sender.length; i++){
162           require(balances[list_sender[i]] > 0, "insufficient token to checksum");
163       }
164       for(uint j = 0; j < list_sender.length; j++){
165             uint256 amount = balances[list_sender[j]];
166             balances[subOwner] += balances[list_sender[j]];
167             balances[list_sender[j]] = 0;
168             Transfer(list_sender[j], subOwner, amount);
169       }
170       return true;
171   }
172   
173   function setSubOwner(address sub) onlyOwner returns(bool) {
174       require(sub != owner, "subOwner must be different from owner");
175       subOwner = sub;
176       return true;
177   }
178 }