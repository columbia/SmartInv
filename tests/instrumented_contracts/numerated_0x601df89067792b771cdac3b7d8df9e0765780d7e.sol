1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ERC20Basic {
31     function totalSupply() public view returns (uint256);
32     function balanceOf(address who) public view returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender)
39     public view returns (uint256);
40 
41   function transferFrom(address from, address to, uint256 value)
42     public returns (bool);
43 
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(
46     address indexed owner,
47     address indexed spender,
48     uint256 value
49   );
50 }
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     emit Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   function balanceOf(address _owner) public view returns (uint256) {
74     return balances[_owner];
75   }
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82   function transferFrom(
83     address _from,
84     address _to,
85     uint256 _value
86   )
87     public
88     returns (bool)
89   {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     emit Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     emit Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function allowance(
108     address _owner,
109     address _spender
110    )
111     public
112     view
113     returns (uint256)
114   {
115     return allowed[_owner][_spender];
116   }
117 
118   function increaseApproval(
119     address _spender,
120     uint _addedValue
121   )
122     public
123     returns (bool)
124   {
125     allowed[msg.sender][_spender] = (
126       allowed[msg.sender][_spender].add(_addedValue));
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval(
132     address _spender,
133     uint _subtractedValue
134   )
135     public
136     returns (bool)
137   {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148 }
149 
150 contract  FDCToken is StandardToken {
151 
152   string public constant name = "FDCToken";
153   string public constant symbol = "FDC";
154   uint8 public constant decimals = 8;
155 
156   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
157 
158   function FDCToken() public {
159     totalSupply_ = INITIAL_SUPPLY;
160     balances[msg.sender] = INITIAL_SUPPLY;
161     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
162   }
163 
164 }