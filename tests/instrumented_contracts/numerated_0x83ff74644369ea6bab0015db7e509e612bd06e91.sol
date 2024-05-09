1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         if(a == 0) return 0;
6         uint256 c = a * b;
7         require(c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         require(b > 0);
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
18         require(b <= a);
19         uint256 c = a - b;
20         return c;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 
29     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
30         require(b != 0);
31         return a % b;
32     }
33 }
34 
35 contract Ownable {
36     address public owner;
37     address public new_owner;
38 
39     event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     modifier onlyOwner() { require(msg.sender == owner); _;  }
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     function _transferOwnership(address _to) internal {
49         require(_to != address(0));
50 
51         new_owner = _to;
52 
53         emit OwnershipTransfer(owner, _to);
54     }
55 
56     function acceptOwnership() public {
57         require(new_owner != address(0) && msg.sender == new_owner);
58 
59         emit OwnershipTransferred(owner, new_owner);
60 
61         owner = new_owner;
62         new_owner = address(0);
63     }
64 
65     function transferOwnership(address _to) public onlyOwner {
66         _transferOwnership(_to);
67     }
68 }
69 
70 contract ERC20 {
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74     function totalSupply() public view returns(uint256);
75     function balanceOf(address who) public view returns(uint256);
76     function transfer(address to, uint256 value) public returns(bool);
77     function transferFrom(address from, address to, uint256 value) public returns(bool);
78     function allowance(address owner, address spender) public view returns(uint256);
79     function approve(address spender, uint256 value) public returns(bool);
80 }
81 
82 contract StandardToken is ERC20 {
83     using SafeMath for uint256;
84 
85     uint256 internal totalSupply_;
86 
87     string public name;
88     string public symbol;
89     uint8 public decimals;
90 
91     mapping(address => uint256) public balances;
92     mapping(address => mapping(address => uint256)) internal allowed;
93 
94     constructor(string _name, string _symbol, uint8 _decimals) public {
95         name = _name;
96         symbol = _symbol;
97         decimals = _decimals;
98     }
99 
100     function totalSupply() public view returns(uint256) {
101         return totalSupply_;
102     }
103 
104     function balanceOf(address _owner) public view returns(uint256) {
105         return balances[_owner];
106     }
107 
108     function transfer(address _to, uint256 _value) public returns(bool) {
109         require(_to != address(0));
110         require(_value <= balances[msg.sender]);
111 
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         
115         emit Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
120         require(_to.length == _value.length);
121 
122         for(uint i = 0; i < _to.length; i++) {
123             transfer(_to[i], _value[i]);
124         }
125 
126         return true;
127     }
128 
129     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137 
138         emit Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public view returns(uint256) {
143         return allowed[_owner][_spender];
144     }
145 
146     function approve(address _spender, uint256 _value) public returns(bool) {
147         require(_spender != address(0));
148         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
149 
150         allowed[msg.sender][_spender] = _value;
151 
152         emit Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
157         require(_spender != address(0));
158         require(_addedValue > 0);
159 
160         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
161 
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
167         require(_spender != address(0));
168         require(_subtractedValue > 0);
169 
170         uint oldValue = allowed[msg.sender][_spender];
171 
172         if(_subtractedValue > oldValue) {
173             allowed[msg.sender][_spender] = 0;
174         }
175         else {
176             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177         }
178 
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 }
183 
184 contract MintableToken is StandardToken, Ownable {
185     bool public mintingFinished = false;
186 
187     event Mint(address indexed to, uint256 amount);
188     event MintFinished();
189 
190     modifier canMint() { require(!mintingFinished); _; }
191     modifier hasMintPermission() { require(msg.sender == owner); _; }
192 
193     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
194         totalSupply_ = totalSupply_.add(_amount);
195         balances[_to] = balances[_to].add(_amount);
196 
197         emit Mint(_to, _amount);
198         emit Transfer(address(0), _to, _amount);
199         return true;
200     }
201 
202     function finishMinting() onlyOwner canMint public returns(bool) {
203         mintingFinished = true;
204 
205         emit MintFinished();
206         return true;
207     }
208 }
209 
210 contract CappedToken is MintableToken {
211     uint256 public cap;
212 
213     constructor(uint256 _cap) public {
214         require(_cap > 0);
215         cap = _cap;
216     }
217 
218     function mint(address _to, uint256 _amount) public returns(bool) {
219         require(totalSupply_.add(_amount) <= cap);
220 
221         return super.mint(_to, _amount);
222     }
223 }
224 
225 contract BurnableToken is StandardToken {
226     event Burn(address indexed burner, uint256 value);
227 
228     function _burn(address _who, uint256 _value) internal {
229         require(_value <= balances[_who]);
230 
231         balances[_who] = balances[_who].sub(_value);
232         totalSupply_ = totalSupply_.sub(_value);
233 
234         emit Burn(_who, _value);
235         emit Transfer(_who, address(0), _value);
236     }
237 
238     function burn(uint256 _value) public {
239         _burn(msg.sender, _value);
240     }
241 
242     function burnFrom(address _from, uint256 _value) public {
243         require(_value <= allowed[_from][msg.sender]);
244         
245         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246         _burn(_from, _value);
247     }
248 }
249 
250 contract Withdrawable is Ownable {
251     event WithdrawEther(address indexed to, uint value);
252 
253     function withdrawEther(address _to, uint _value) onlyOwner public {
254         require(_to != address(0));
255         require(address(this).balance >= _value);
256 
257         _to.transfer(_value);
258 
259         emit WithdrawEther(_to, _value);
260     }
261 
262     function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
263         require(_token.transfer(_to, _value));
264     }
265 
266     function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
267         require(_token.transferFrom(_from, _to, _value));
268     }
269 
270     function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
271         require(_token.approve(_spender, _value));
272     }
273 }
274 
275 
276 contract Token is CappedToken, BurnableToken, Withdrawable {
277     constructor() CappedToken(100000000 * 1e18) StandardToken("Cryptics ERC20 Token", "QRP", 18) public {
278         
279     }
280 }