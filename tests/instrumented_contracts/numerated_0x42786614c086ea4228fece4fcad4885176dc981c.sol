1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     // uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26  
27   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender)
43     public view returns (uint256);
44 
45   function transferFrom(address from, address to, uint256 value)
46     public returns (bool);
47 
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(
50     address indexed owner,
51     address indexed spender,
52     uint256 value
53   );
54 }
55 
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   uint256 totalSupply_;
62 
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0),"_to address is 0.");
69     require(_value <= balances[msg.sender],"Insufficient balance.");
70 
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     emit Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   function balanceOf(address _owner) public view returns (uint256) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 
84 contract DetailedERC20 is ERC20 {
85   string public name;
86   string public symbol;
87   uint8 public decimals;
88 
89   constructor(string _name, string _symbol, uint8 _decimals) public {
90     name = _name;
91     symbol = _symbol;
92     decimals = _decimals;
93   }
94 }
95 
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) internal allowed;
99 
100   function transferFrom(
101     address _from,
102     address _to,
103     uint256 _value
104   )
105     public
106     returns (bool)
107   {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     emit Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   function allowance(
126     address _owner,
127     address _spender
128    )
129     public
130     view
131     returns (uint256)
132   {
133     return allowed[_owner][_spender];
134   }
135 
136   function increaseApproval(
137     address _spender,
138     uint _addedValue
139   )
140     public
141     returns (bool)
142   {
143     allowed[msg.sender][_spender] = (
144       allowed[msg.sender][_spender].add(_addedValue));
145     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149   function decreaseApproval(
150     address _spender,
151     uint _subtractedValue
152   )
153     public
154     returns (bool)
155   {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166 }
167 
168 contract BurnableToken is BasicToken {
169 
170   event Burn(address indexed burner, uint256 value);
171 
172   function burn(uint256 _value) public {
173     _burn(msg.sender, _value);
174   }
175 
176   function _burn(address _who, uint256 _value) internal {
177     require(_value <= balances[_who]);
178     // no need to require value <= totalSupply, since that would imply the
179     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
180 
181     balances[_who] = balances[_who].sub(_value);
182     totalSupply_ = totalSupply_.sub(_value);
183     emit Burn(_who, _value);
184     emit Transfer(_who, address(0), _value);
185   }
186 }
187 
188 contract StandardBurnableToken is BurnableToken, StandardToken {
189 
190   function burnFrom(address _from, uint256 _value) public {
191     require(_value <= allowed[_from][msg.sender]);
192     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
193     // this function needs to emit an event with the updated approval.
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     _burn(_from, _value);
196   }
197 }
198 
199 contract OMCV2 is StandardBurnableToken,DetailedERC20 {
200     using SafeMath for uint256;
201 
202     constructor()
203         DetailedERC20("Oriental Medical Chain", "OMC",8)
204         public {
205             totalSupply_ =  2100000000e8;
206             balances[msg.sender] = totalSupply_;
207         }
208 }