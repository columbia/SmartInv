1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14 
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));
24     OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 
28 }
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   
36 }
37 
38 contract BasicToken is ERC20Basic, Ownable {
39 
40     using SafeMath for uint256;
41     mapping(address => uint256) balances;
42 
43     bool public transfersEnabledFlag;
44 
45 
46     modifier transfersEnabled() {
47         require(transfersEnabledFlag);
48         _;
49     }
50 
51     function enableTransfers() public onlyOwner {
52         transfersEnabledFlag = true;
53     }
54 
55 
56     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
57         require(_to != address(0));
58         require(_value <= balances[msg.sender]);
59 
60         // SafeMath.sub will throw if there is not enough balance.
61         balances[msg.sender] = balances[msg.sender].sub(_value);
62         balances[_to] = balances[_to].add(_value);
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67 
68     function balanceOf(address _owner) public view returns (uint256 balance) {
69         return balances[_owner];
70     }
71 }
72 
73 
74 
75 
76 
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119 
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         Transfer(_from, _to, _value);
129         return true;
130     }
131 
132 
133     function approve(address _spender, uint256 _value) public returns (bool) {
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139 
140     function allowance(address _owner, address _spender) public view returns (uint256) {
141         return allowed[_owner][_spender];
142     }
143 
144     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
145         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
146         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 
150     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
151         uint oldValue = allowed[msg.sender][_spender];
152         if (_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         }
155         else {
156             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157         }
158         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162 }
163 
164 contract MintableToken is StandardToken {
165     event Mint(address indexed to, uint256 amount);
166 
167     event MintFinished();
168 
169     bool public mintingFinished = false;
170 
171     mapping(address => bool) public minters;
172 
173     modifier canMint() {
174         require(!mintingFinished);
175         _;
176     }
177     modifier onlyMinters() {
178         require(minters[msg.sender] || msg.sender == owner);
179         _;
180     }
181     function addMinter(address _addr) public onlyOwner {
182         minters[_addr] = true;
183     }
184 
185     function deleteMinter(address _addr) public onlyOwner {
186         delete minters[_addr];
187     }
188 
189 
190     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
191         require(_to != address(0));
192         totalSupply = totalSupply.add(_amount);
193         balances[_to] = balances[_to].add(_amount);
194         Mint(_to, _amount);
195         Transfer(address(0), _to, _amount);
196         return true;
197     }
198 
199     function finishMinting() onlyOwner canMint public returns (bool) {
200         mintingFinished = true;
201         MintFinished();
202         return true;
203     }
204 }
205 
206 
207 
208 contract CappedToken is MintableToken {
209 
210     uint256 public cap;
211 
212     function CappedToken(uint256 _cap) public {
213         require(_cap > 0);
214         cap = _cap;
215     }
216 
217 
218     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
219         require(totalSupply.add(_amount) <= cap);
220 
221         return super.mint(_to, _amount);
222     }
223 
224 }
225 
226 
227 contract ParameterizedToken is CappedToken {
228     string public name;
229 
230     string public symbol;
231 
232     uint256 public decimals;
233 
234     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
235         name = _name;
236         symbol = _symbol;
237         decimals = _decimals;
238     }
239 
240 }
241 
242 contract BTAToken is ParameterizedToken {
243 
244     function BTAToken() public ParameterizedToken("Blockchain To Application", "BTA", 18, 1300000000) {
245     }
246 
247 }