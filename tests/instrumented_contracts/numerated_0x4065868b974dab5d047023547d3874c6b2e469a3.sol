1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
5         if(a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipRenounced(address indexed previousOwner);
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     modifier onlyOwner() { require(msg.sender == owner); _;  }
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     function _transferOwnership(address _newOwner) internal {
42         require(_newOwner != address(0));
43         emit OwnershipTransferred(owner, _newOwner);
44         owner = _newOwner;
45     }
46 
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipRenounced(owner);
49         owner = address(0);
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         _transferOwnership(_newOwner);
54     }
55 }
56 
57 contract ERC20 {
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 
61     function totalSupply() public view returns(uint256);
62     function balanceOf(address who) public view returns(uint256);
63     function transfer(address to, uint256 value) public returns(bool);
64     function transferFrom(address from, address to, uint256 value) public returns(bool);
65     function allowance(address owner, address spender) public view returns(uint256);
66     function approve(address spender, uint256 value) public returns(bool);
67 }
68 
69 contract StandardToken is ERC20, Ownable {
70     using SafeMath for uint256;
71 
72     uint256 totalSupply_;
73 
74     string public name;
75     string public symbol;
76     uint8 public decimals;
77 
78     mapping(address => uint256) balances;
79     mapping(address => mapping(address => uint256)) public allowed;
80 
81     constructor(string _name, string _symbol, uint8 _decimals) public {
82         name = _name;
83         symbol = _symbol;
84         decimals = _decimals;
85     }
86     
87     
88     
89     bool public paused = true;
90     
91     event Pause();
92     event Unpause();
93 
94     modifier whenNotPaused() { require(!paused); _; }
95     modifier whenPaused() { require(paused); _; }
96 
97     function pause() onlyOwner whenNotPaused public {
98         paused = true;
99         emit Pause();
100     }
101     
102     function unpause() onlyOwner whenPaused public {
103         paused = false;
104         emit Unpause();
105     }
106     
107     
108     
109     
110     function totalSupply() public view returns(uint256) {
111         return totalSupply_;
112     }
113 
114     function balanceOf(address _owner) public view returns(uint256) {
115         return balances[_owner];
116     }
117 
118     function transfer(address _to, uint256 _value) whenNotPaused public returns(bool) {
119         require(_to != address(0));
120         require(_value <= balances[msg.sender]);
121 
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         
125         emit Transfer(msg.sender, _to, _value);
126         return true;
127     }
128 
129 
130     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns(bool) {
131         require(_to != address(0));
132         require(_value <= allowed[_from][msg.sender]); // Check allowance
133         require(_value > 0);
134 
135         balances[_from] = balances[_from].sub(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138 
139         emit Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) public view returns(uint256) {
144         return allowed[_owner][_spender];
145     }
146 
147     function approve(address _spender, uint256 _value) public returns(bool) {
148         allowed[msg.sender][_spender] = _value;
149 
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
155         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
156 
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
162         uint oldValue = allowed[msg.sender][_spender];
163 
164         if(_subtractedValue > oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         }
167         else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170 
171         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172         return true;
173     }
174 }
175 
176 contract MintableToken is StandardToken {
177     bool public mintingFinished = false;
178 
179     event Mint(address indexed to, uint256 amount);
180     event MintFinished();
181 
182     modifier canMint() { require(!mintingFinished); _; }
183     modifier hasMintPermission() { require(msg.sender == owner); _; }
184 
185     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
186         totalSupply_ = totalSupply_.add(_amount);
187         balances[_to] = balances[_to].add(_amount);
188 
189         emit Mint(_to, _amount);
190         emit Transfer(address(0), _to, _amount);
191         return true;
192     }
193 
194     function finishMinting() onlyOwner canMint public returns(bool) {
195         mintingFinished = true;
196 
197         emit MintFinished();
198         return true;
199     }
200 }
201 
202 contract CappedToken is MintableToken {
203     uint256 public cap;
204 
205     constructor(uint256 _cap) public {
206         require(_cap > 0);
207         cap = _cap;
208     }
209 
210     function mint(address _to, uint256 _amount) public returns(bool) {
211         require(totalSupply_.add(_amount) <= cap);
212 
213         return super.mint(_to, _amount);
214     }
215 }
216 
217 contract BurnableToken is StandardToken {
218     event Burn(address indexed burner, uint256 value);
219 
220     function _burn(address _who, uint256 _value) internal {
221         require(_value <= balances[_who]);
222 
223         balances[_who] = balances[_who].sub(_value);
224         totalSupply_ = totalSupply_.sub(_value);
225 
226         emit Burn(_who, _value);
227         emit Transfer(_who, address(0), _value);
228     }
229 
230     function burn(uint256 _value) onlyOwner public {
231         _burn(msg.sender, _value);
232     }
233 }
234 
235 contract SafeCrypt is CappedToken, BurnableToken {
236     constructor() CappedToken(1535714285000000000000000000) StandardToken("SafeCrypt", "SFC", 18) public {
237         
238     }
239 }