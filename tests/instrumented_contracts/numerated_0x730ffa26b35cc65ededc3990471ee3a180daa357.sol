1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'SXCT' 'Example SX-Chain Token' token contract
5 //
6 // Symbol      : SXCT
7 // Name        : SX-Chain Token
8 // Total supply: 108,000,000.00000000
9 // Decimals    : 8
10 //
11 // Enjoy.
12 // ----------------------------------------------------------------------------
13 library SafeMath {
14 
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36  
37   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 contract ERC20Basic {
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender)
53     public view returns (uint256);
54 
55   function transferFrom(address from, address to, uint256 value)
56     public returns (bool);
57 
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(
60     address indexed owner,
61     address indexed spender,
62     uint256 value
63   );
64 }
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76 
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0),"_to address is 0.");
79     require(_value <= balances[msg.sender],"Insufficient balance.");
80 
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   function balanceOf(address _owner) public view returns (uint256) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 contract DetailedERC20 is ERC20 {
95   string public name;
96   string public symbol;
97   uint8 public decimals;
98 
99   constructor(string _name, string _symbol, uint8 _decimals) public {
100     name = _name;
101     symbol = _symbol;
102     decimals = _decimals;
103   }
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110   function transferFrom(
111     address _from,
112     address _to,
113     uint256 _value
114   )
115     public
116     returns (bool)
117   {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     emit Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   function allowance(
136     address _owner,
137     address _spender
138    )
139     public
140     view
141     returns (uint256)
142   {
143     return allowed[_owner][_spender];
144   }
145 
146   function increaseApproval(
147     address _spender,
148     uint _addedValue
149   )
150     public
151     returns (bool)
152   {
153     allowed[msg.sender][_spender] = (
154       allowed[msg.sender][_spender].add(_addedValue));
155     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   function decreaseApproval(
160     address _spender,
161     uint _subtractedValue
162   )
163     public
164     returns (bool)
165   {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 contract BurnableToken is BasicToken {
179 
180   event Burn(address indexed burner, uint256 value);
181 
182   function burn(uint256 _value) public {
183     _burn(msg.sender, _value);
184   }
185 
186   function _burn(address _who, uint256 _value) internal {
187     require(_value <= balances[_who]);
188     // no need to require value <= totalSupply, since that would imply the
189     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191     balances[_who] = balances[_who].sub(_value);
192     totalSupply_ = totalSupply_.sub(_value);
193     emit Burn(_who, _value);
194     emit Transfer(_who, address(0), _value);
195   }
196 }
197 
198 contract StandardBurnableToken is BurnableToken, StandardToken {
199 
200   function burnFrom(address _from, uint256 _value) public {
201     require(_value <= allowed[_from][msg.sender]);
202     // this function needs to emit an event with the updated approval.
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     _burn(_from, _value);
205   }
206 }
207 
208 contract SXCT is StandardBurnableToken,DetailedERC20 {
209     using SafeMath for uint256;
210 
211     constructor()
212         DetailedERC20("SX-Chain Token", "SXCT",8)
213         public {
214             totalSupply_ =  108000000e8;
215             balances[msg.sender] = totalSupply_;
216         }
217 }