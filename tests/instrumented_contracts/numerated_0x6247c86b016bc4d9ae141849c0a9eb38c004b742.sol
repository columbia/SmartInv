1 // Hotelium.sol
2 pragma solidity ^0.4.24;
3 
4 
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender)
15     public view returns (uint256);
16 
17   function transferFrom(address from, address to, uint256 value)
18     public returns (bool);
19 
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(
22     address indexed owner,
23     address indexed spender,
24     uint256 value
25   );
26 }
27 
28 
29 contract BasicToken is ERC20Basic {
30   using SafeMath for uint256;
31 
32   mapping(address => uint256) balances;
33 
34   uint256 totalSupply_;
35 
36   function totalSupply() public view returns (uint256) {
37     return totalSupply_;
38   }
39 
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42     require(_value <= balances[msg.sender]);
43 
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     emit Transfer(msg.sender, _to, _value);
47     return true;
48   }
49 
50   function balanceOf(address _owner) public view returns (uint256) {
51     return balances[_owner];
52   }
53 
54 }
55 
56 contract BurnableToken is BasicToken {
57 
58   event Burn(address indexed burner, uint256 value);
59 
60   function burn(uint256 _value) public {
61     _burn(msg.sender, _value);
62   }
63 
64   function _burn(address _who, uint256 _value) internal {
65     require(_value <= balances[_who]);
66 
67     balances[_who] = balances[_who].sub(_value);
68     totalSupply_ = totalSupply_.sub(_value);
69     emit Burn(_who, _value);
70     emit Transfer(_who, address(0), _value);
71   }
72 }
73 
74 
75 
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
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
120     uint256 _addedValue
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
133     uint256 _subtractedValue
134   )
135     public
136     returns (bool)
137   {
138     uint256 oldValue = allowed[msg.sender][_spender];
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
150 
151 contract StandardBurnableToken is BurnableToken, StandardToken {
152 
153   function burnFrom(address _from, uint256 _value) public {
154     require(_value <= allowed[_from][msg.sender]);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     _burn(_from, _value);
157   }
158 }
159 
160 
161 contract Ownable {
162   address public owner;
163 
164 
165   event OwnershipRenounced(address indexed previousOwner);
166   event OwnershipTransferred(
167     address indexed previousOwner,
168     address indexed newOwner
169   );
170 
171 
172   constructor() public {
173     owner = msg.sender;
174   }
175 
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   function renounceOwnership() public onlyOwner {
182     emit OwnershipRenounced(owner);
183     owner = address(0);
184   }
185 
186   function transferOwnership(address _newOwner) public onlyOwner {
187     _transferOwnership(_newOwner);
188   }
189 
190   function _transferOwnership(address _newOwner) internal {
191     require(_newOwner != address(0));
192     emit OwnershipTransferred(owner, _newOwner);
193     owner = _newOwner;
194   }
195 }
196 
197 library SafeMath {
198 
199   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
200     if (a == 0) {
201       return 0;
202     }
203 
204     c = a * b;
205     assert(c / a == b);
206     return c;
207   }
208 
209   function div(uint256 a, uint256 b) internal pure returns (uint256) {
210     return a / b;
211   }
212 
213   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214     assert(b <= a);
215     return a - b;
216   }
217 
218   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
219     c = a + b;
220     assert(c >= a);
221     return c;
222   }
223 }
224 
225 contract Hotelium is StandardBurnableToken, Ownable {
226     using SafeMath for uint256;
227 
228     string public constant name = "Hotelium";
229     string public constant symbol = "HTL";
230     uint8 public constant decimals = 18;
231     
232     constructor() public {
233         totalSupply_ = 490000000000000000000000000;
234         owner = msg.sender;
235 
236         balances[0xf3e214dEeD62d00ea6b8FA70923a1Cf8FA191D25 ] = totalSupply_;
237         emit Transfer(address(0), 0xf3e214dEeD62d00ea6b8FA70923a1Cf8FA191D25 , totalSupply_);
238     }
239 
240   function () public payable {
241 	revert();
242   }
243 
244   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
245 	return StandardBurnableToken(tokenAddress).transfer(owner, tokens);
246   }    
247 }