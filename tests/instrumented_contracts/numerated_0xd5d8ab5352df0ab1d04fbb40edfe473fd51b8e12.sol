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
69 contract StandardToken is ERC20 {
70     using SafeMath for uint256;
71 
72     uint256 totalSupply_;
73 
74     string public name;
75     string public symbol;
76     uint8 public decimals;
77 
78     mapping(address => uint256) balances;
79     mapping(address => mapping(address => uint256)) internal allowed;
80 
81     constructor(string _name, string _symbol, uint8 _decimals) public {
82         name = _name;
83         symbol = _symbol;
84         decimals = _decimals;
85     }
86 
87     function totalSupply() public view returns(uint256) {
88         return totalSupply_;
89     }
90 
91     function balanceOf(address _owner) public view returns(uint256) {
92         return balances[_owner];
93     }
94 
95     function transfer(address _to, uint256 _value) public returns(bool) {
96         require(_to != address(0));
97         require(_value <= balances[msg.sender]);
98 
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         
102         emit Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
107         require(_to.length == _value.length);
108 
109         for(uint i = 0; i < _to.length; i++) {
110             transfer(_to[i], _value[i]);
111         }
112 
113         return true;
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
117         require(_to != address(0));
118         require(_value <= balances[_from]);
119         require(_value <= allowed[_from][msg.sender]);
120 
121         balances[_from] = balances[_from].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124 
125         emit Transfer(_from, _to, _value);
126         return true;
127     }
128 
129     function allowance(address _owner, address _spender) public view returns(uint256) {
130         return allowed[_owner][_spender];
131     }
132 
133     function approve(address _spender, uint256 _value) public returns(bool) {
134         allowed[msg.sender][_spender] = _value;
135 
136         emit Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
141         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
142 
143         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
148         uint oldValue = allowed[msg.sender][_spender];
149 
150         if(_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         }
153         else {
154             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155         }
156 
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 }
161 
162 contract MintableToken is StandardToken, Ownable {
163     bool public mintingFinished = false;
164 
165     event Mint(address indexed to, uint256 amount);
166     event MintFinished();
167 
168     modifier canMint() { require(!mintingFinished); _; }
169     modifier hasMintPermission() { require(msg.sender == owner); _; }
170 
171     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
172         totalSupply_ = totalSupply_.add(_amount);
173         balances[_to] = balances[_to].add(_amount);
174 
175         emit Mint(_to, _amount);
176         emit Transfer(address(0), _to, _amount);
177         return true;
178     }
179 
180     function finishMinting() onlyOwner canMint public returns(bool) {
181         mintingFinished = true;
182 
183         emit MintFinished();
184         return true;
185     }
186 }
187 
188 contract CappedToken is MintableToken {
189     uint256 public cap;
190 
191     constructor(uint256 _cap) public {
192         require(_cap > 0);
193         cap = _cap;
194     }
195 
196     function mint(address _to, uint256 _amount) public returns(bool) {
197         require(totalSupply_.add(_amount) <= cap);
198 
199         return super.mint(_to, _amount);
200     }
201 }
202 
203 contract BurnableToken is StandardToken {
204     event Burn(address indexed burner, uint256 value);
205 
206     function _burn(address _who, uint256 _value) internal {
207         require(_value <= balances[_who]);
208 
209         balances[_who] = balances[_who].sub(_value);
210         totalSupply_ = totalSupply_.sub(_value);
211 
212         emit Burn(_who, _value);
213         emit Transfer(_who, address(0), _value);
214     }
215 
216     function burn(uint256 _value) public {
217         _burn(msg.sender, _value);
218     }
219 
220     function burnFrom(address _from, uint256 _value) public {
221         require(_value <= allowed[_from][msg.sender]);
222         
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224         _burn(_from, _value);
225     }
226 }
227 
228 contract Withdrawable is Ownable {
229     function withdrawEther(address _to, uint _value) onlyOwner public {
230         require(_to != address(0));
231         require(address(this).balance >= _value);
232 
233         _to.transfer(_value);
234     }
235 
236     function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
237         require(_token.transfer(_to, _value));
238     }
239 
240     function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
241         require(_token.transferFrom(_from, _to, _value));
242     }
243 
244     function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
245         require(_token.approve(_spender, _value));
246     }
247 }
248 
249 contract BILLCRYPT is CappedToken, BurnableToken, Withdrawable {
250     constructor() CappedToken(152000000e8) StandardToken("BILLCRYPT", "BILC", 8) public {
251         
252     }
253 }