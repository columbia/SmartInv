1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a / b;
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
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52     require(_value <= balances[msg.sender]);
53 
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   function balanceOf(address _owner) public view returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64 }
65 
66 contract StandardToken is ERC20, BasicToken {
67 
68   mapping (address => mapping (address => uint256)) internal allowed;
69 
70   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[_from]);
73     require(_value <= allowed[_from][msg.sender]);
74 
75     balances[_from] = balances[_from].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79     return true;
80   }
81 
82   function approve(address _spender, uint256 _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   function allowance(address _owner, address _spender) public view returns (uint256) {
89     return allowed[_owner][_spender];
90   }
91 
92   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
93     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95     return true;
96   }
97 
98   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
99     uint oldValue = allowed[msg.sender][_spender];
100     if (_subtractedValue > oldValue) {
101       allowed[msg.sender][_spender] = 0;
102     } else {
103       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104     }
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 
109 }
110 
111 contract Ownable {
112   address public owner;
113 
114   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116   function Ownable() public {
117     owner = msg.sender;
118   }
119 
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   function transferOwnership(address newOwner) public onlyOwner {
126     require(newOwner != address(0));
127     OwnershipTransferred(owner, newOwner);
128     owner = newOwner;
129   }
130 
131 }
132 
133 contract Pausable is Ownable {
134   event PausePublic(bool newState);
135   event PauseOwnerAdmin(bool newState);
136 
137   bool public pausedPublic = false;
138   bool public pausedOwnerAdmin = false;
139 
140   address public admin;
141 
142   modifier whenNotPaused() {
143     if(pausedPublic) {
144       if(!pausedOwnerAdmin) {
145         require(msg.sender == admin || msg.sender == owner);
146       } else {
147         revert();
148       }
149     }
150     _;
151   }
152 
153 
154   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
155     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
156 
157     pausedPublic = newPausedPublic;
158     pausedOwnerAdmin = newPausedOwnerAdmin;
159 
160     PausePublic(newPausedPublic);
161     PauseOwnerAdmin(newPausedOwnerAdmin);
162   }
163 }
164 
165 contract PausableToken is StandardToken, Pausable {
166 
167   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
168     return super.transfer(_to, _value);
169   }
170 
171   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
172     return super.transferFrom(_from, _to, _value);
173   }
174 
175   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
176     return super.approve(_spender, _value);
177   }
178 
179   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
180     return super.increaseApproval(_spender, _addedValue);
181   }
182 
183   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
184     return super.decreaseApproval(_spender, _subtractedValue);
185   }
186 }
187 
188 contract MSKToken is PausableToken {   
189     string  public  constant name = "MaskDAO";
190     string  public  constant symbol = "MSK";
191     uint8   public  constant decimals = 18;
192 
193     modifier validDestination(address to)
194     {
195         require(to != address(0x0));
196         require(to != address(this));
197         _;
198     }
199 
200     function MSKToken(address _admin, uint _totalTokenAmount) public
201     {
202         admin = _admin;
203         totalSupply = _totalTokenAmount;
204         balances[msg.sender] = _totalTokenAmount;
205         Transfer(address(0x0), msg.sender, _totalTokenAmount);
206     }
207 
208     function transfer(address _to, uint _value) public validDestination(_to) returns (bool) 
209     {
210         return super.transfer(_to, _value);
211     }
212 
213     function transferFrom(address _from, address _to, uint _value) public validDestination(_to) returns (bool)
214     {
215         return super.transferFrom(_from, _to, _value);
216     }
217 
218     event Burn(address indexed _burner, uint _value);
219 
220     function burn(uint _value) public returns (bool)
221     {
222         balances[msg.sender] = balances[msg.sender].sub(_value);
223         totalSupply = totalSupply.sub(_value);
224         Burn(msg.sender, _value);
225         Transfer(msg.sender, address(0x0), _value);
226         return true;
227     }
228 
229     function burnFrom(address _from, uint256 _value) public returns (bool) 
230     {
231         assert( transferFrom( _from, msg.sender, _value ) );
232         return burn(_value);
233     }
234 
235     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
236 
237     function changeAdmin(address newAdmin) public onlyOwner {
238         AdminTransferred(admin, newAdmin);
239         admin = newAdmin;
240     }
241 }