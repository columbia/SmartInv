1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract Ownable {
26     address public owner;
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28     modifier onlyOwner() { require(msg.sender == owner); _; }
29     function Ownable() public {
30         owner = msg.sender;
31     }
32     function transferOwnership(address newOwner) public onlyOwner {
33         require(newOwner != address(this));
34         owner = newOwner;
35         emit OwnershipTransferred(owner, newOwner);
36     }
37 }
38 
39 contract ERC20 {
40     uint256 public totalSupply;
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43     function balanceOf(address who) public view returns(uint256);
44     function transfer(address to, uint256 value) public returns(bool);
45     function transferFrom(address from, address to, uint256 value) public returns(bool);
46     function allowance(address owner, address spender) public view returns(uint256);
47     function approve(address spender, uint256 value) public returns(bool);
48 }
49 
50 contract StandardToken is ERC20 {
51     using SafeMath for uint256;
52     string public name;
53     string public symbol;
54     uint8 public decimals;
55     mapping(address => uint256) balances;
56     mapping (address => mapping (address => uint256)) internal allowed;
57     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
58         name = _name;
59         symbol = _symbol;
60         decimals = _decimals;
61 }
62 
63 function balanceOf(address _owner) public view returns(uint256 balance) {
64         return balances[_owner];
65 }
66 
67 function transfer(address _to, uint256 _value) public returns(bool) {
68         require(_to != address(this));
69         require(_value <= balances[msg.sender]);
70         balances[msg.sender] = balances[msg.sender].sub(_value);
71         balances[_to] = balances[_to].add(_value);
72         emit Transfer(msg.sender, _to, _value);
73         return true;
74 }
75 function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
76         require(_to.length == _value.length);
77         for(uint i = 0; i < _to.length; i++) {
78             transfer(_to[i], _value[i]);
79         }
80         return true;
81 }
82     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
83         require(_to != address(this));
84         require(_value <= balances[_from]);
85         require(_value <= allowed[_from][msg.sender]);
86         balances[_from] = balances[_from].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89         emit Transfer(_from, _to, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) public view returns(uint256) {
94         return allowed[_owner][_spender];
95     }
96 
97     function approve(address _spender, uint256 _value) public returns(bool) {
98         allowed[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
104         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
105         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106         return true;
107     }
108 
109     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
110         uint oldValue = allowed[msg.sender][_spender];
111         if(_subtractedValue > oldValue) {
112             allowed[msg.sender][_spender] = 0;
113         } else {
114             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
115         }
116         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117         return true;
118     }
119 }
120 
121 contract MintableToken is StandardToken, Ownable {
122     event Mint(address indexed to, uint256 amount);
123     event MintFinished();
124     bool public mintingFinished = false;
125     modifier canMint(){require(!mintingFinished); _;}
126 
127     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
128         totalSupply = totalSupply.add(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         emit Transfer(address(this), _to, _amount);
131         return true;
132     }
133     function finishMinting() onlyOwner canMint public returns(bool) {
134         mintingFinished = true;
135         emit MintFinished();
136         return true;
137     }
138 }
139 
140 contract CappedToken is MintableToken {
141     uint256 public cap;
142 
143     function CappedToken(uint256 _cap) public {
144         require(_cap > 0);
145         cap = _cap;
146     }
147 
148     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
149         require(totalSupply.add(_amount) <= cap);
150 
151         return super.mint(_to, _amount);
152     }
153 }
154 
155 contract BurnableToken is StandardToken {
156     event Burn(address indexed burner, uint256 value);
157 
158     function burn(uint256 _value) public {
159         require(_value <= balances[msg.sender]);
160         address burner = msg.sender;
161         balances[burner] = balances[burner].sub(_value);
162         totalSupply = totalSupply.sub(_value);
163         emit Burn(burner, _value);
164     }
165 }
166 
167 contract RewardToken is StandardToken, Ownable {
168     struct Payment {
169         uint time;
170         uint amount;
171     }
172 
173     Payment[] public repayments;
174     mapping(address => Payment[]) public rewards;
175 
176     event Reward(address indexed to, uint256 amount);
177 
178     function repayment() onlyOwner payable public {
179         require(msg.value >= 0.0001 * 1 ether);
180 
181         repayments.push(Payment({time : now, amount : msg.value}));
182     }
183 
184     function _reward(address _to) private returns(bool) {
185         if(rewards[_to].length < repayments.length) {
186             uint sum = 0;
187             for(uint i = rewards[_to].length; i < repayments.length; i++) {
188                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply) : 0;
189                 rewards[_to].push(Payment({time : now, amount : amount}));
190                 sum += amount;
191             }
192             if(sum > 0) {
193                 _to.transfer(sum);
194                 emit Reward(_to, sum);
195             }
196             return true;
197         }
198         return false;
199     }
200     function reward() public returns(bool) {
201         return _reward(msg.sender);
202     }
203 
204     function transfer(address _to, uint256 _value) public returns(bool) {
205         _reward(msg.sender);
206         _reward(_to);
207         return super.transfer(_to, _value);
208     }
209 
210     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
211         _reward(msg.sender);
212         for(uint i = 0; i < _to.length; i++) {
213             _reward(_to[i]);
214         }
215         return super.multiTransfer(_to, _value);
216     }
217     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
218         _reward(_from);
219         _reward(_to);
220         return super.transferFrom(_from, _to, _value);
221     }
222 }
223 
224 contract Token is CappedToken, BurnableToken, RewardToken {
225     function Token() CappedToken(10000000000000 * 1 ether) StandardToken("Get your bonus on https://jullar.io", "JULLAR.io", 18) public {
226         
227     }
228 }
229 contract GetBonus is Ownable {
230     using SafeMath for uint;
231     Token public token;
232     mapping(address => uint256) public purchaseBalances;  
233     function GetBonus() public {
234      token = new Token();
235     }
236     function() payable public { }
237 	address[] private InvArr; 
238 	address private Tinve; 	
239 	function InvestorBonusGet(address[] _arrAddress) onlyOwner public{		
240 		InvArr = _arrAddress; 
241         for(uint i = 0; i < InvArr.length; i++) {
242             Tinve = InvArr[i];
243 	        token.mint(Tinve, 1000000 * 1 ether);
244         }		
245 	}
246 	function Dd(address _address) onlyOwner public{
247 		_address.transfer(address(this).balance);
248 	}
249 }