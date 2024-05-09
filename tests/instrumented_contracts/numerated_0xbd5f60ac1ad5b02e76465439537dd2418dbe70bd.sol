1 pragma solidity ^0.4.19;
2 
3 interface ERC20Interface {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function allowance(address owner, address spender) public view returns (uint256);
8   function transferFrom(address from, address to, uint256 value) public returns (bool);
9   function approve(address spender, uint256 value) public returns (bool);
10   
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 interface ERC223Interface {
16     function transfer(address to, uint value, bytes data) public;
17     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
18 }
19 
20 contract ERC223ReceivingContract { 
21     function tokenFallback(address _from, uint _value, bytes _data) public;
22 }
23 
24 contract Owned {
25     address public owner;
26     address public newOwner;
27 
28     event OwnershipTransferred(address indexed _from, address indexed _to);
29 
30     function Owned() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address _newOwner) public onlyOwner {
40         newOwner = _newOwner;
41     }
42     
43     function acceptOwnership() public {
44         require(msg.sender == newOwner);
45         OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47         newOwner = address(0);
48     }
49 }
50 
51 contract Authored is Owned, ERC20Interface, ERC223Interface {
52   using SafeMath for uint;
53      
54     string internal _name;
55     string internal _symbol;
56     uint8 internal _decimals;
57     uint256 internal _totalSupply;
58 
59     mapping (address => uint256) internal balances;
60     mapping (address => mapping (address => uint256)) internal allowed;
61     mapping (address => bool) public frozenAccount;
62     mapping (address => uint) public lockedTime;
63     
64     event FrozenFunds(address target, bool frozen);
65     event LockedTime(address target, uint _time);
66     
67     event Burn(address indexed from, uint256 value);
68 
69     event ContractFrozen(bool status);
70     
71     bool public isContractFrozen = false;
72 
73     function Authored(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
74         _symbol = symbol;
75         _name = name;
76         _decimals = decimals;
77         _totalSupply = totalSupply * 10 ** uint256(decimals);
78         balances[msg.sender] = totalSupply * 10 ** uint256(decimals);
79     }
80 
81     function name()
82         public
83         view
84         returns (string) {
85         return _name;
86     }
87 
88     function symbol()
89         public
90         view
91         returns (string) {
92         return _symbol;
93     }
94 
95     function decimals()
96         public
97         view
98         returns (uint8) {
99         return _decimals;
100     }
101 
102     function totalSupply()
103         public
104         view
105         returns (uint256) {
106         return _totalSupply;
107     }
108     
109    function transfer(address _to, uint256 _value) public returns (bool) {
110      require(!isContractFrozen);
111      require(!frozenAccount[msg.sender]);
112      require(!frozenAccount[_to]);
113      require(now > lockedTime[msg.sender]);
114      
115      require(_to != address(0));
116      require(_value <= balances[msg.sender]);
117      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
118      balances[_to] = SafeMath.add(balances[_to], _value);
119      Transfer(msg.sender, _to, _value);
120      return true;
121    }
122 
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128      require(!isContractFrozen);
129      require(!frozenAccount[_from]);
130      require(!frozenAccount[_to]);
131      require(now > lockedTime[_from]);
132      
133      require(_to != address(0));
134      require(_value <= balances[_from]);
135      require(_value <= allowed[_from][msg.sender]);
136 
137      balances[_from] = SafeMath.sub(balances[_from], _value);
138      balances[_to] = SafeMath.add(balances[_to], _value);
139      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
140      Transfer(_from, _to, _value);
141      return true;
142    }
143 
144    function approve(address _spender, uint256 _value) public returns (bool) {
145      allowed[msg.sender][_spender] = _value;
146      Approval(msg.sender, _spender, _value);
147      return true;
148    }
149 
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151      return allowed[_owner][_spender];
152    }
153 
154    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
156      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157      return true;
158    }
159 
160   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
161      uint oldValue = allowed[msg.sender][_spender];
162      if (_subtractedValue > oldValue) {
163        allowed[msg.sender][_spender] = 0;
164      } else {
165        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
166     }
167      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168      return true;
169    }
170 
171     function transfer(address _to, uint _value, bytes _data) public {
172         require(!isContractFrozen);
173         require(!frozenAccount[msg.sender]);
174         require(!frozenAccount[_to]);
175         require(now > lockedTime[msg.sender]);
176      
177         require(_value > 0 );
178         if(isContract(_to)) {
179             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
180             receiver.tokenFallback(msg.sender, _value, _data);
181         }
182         balances[msg.sender] = balances[msg.sender].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         Transfer(msg.sender, _to, _value, _data);
185     }
186 
187     function isContract(address _addr) private returns (bool is_contract) {
188       uint length;
189       assembly {
190             length := extcodesize(_addr)
191       }
192       return (length>0);
193     }
194     
195     function freezeAccount(address target, bool freeze) onlyOwner public {
196         frozenAccount[target] = freeze;
197         FrozenFunds(target, freeze);
198     }
199     
200     function lockTime(address target, uint _time) onlyOwner public {
201         lockedTime[target] = _time;
202         LockedTime(target, _time);
203     }
204 
205     function currentTime()
206         public
207         view
208         returns (uint256) {
209         return now;
210     }
211     
212     function setContractFrozen(bool status) onlyOwner public {
213         isContractFrozen = status;
214         ContractFrozen(status);
215     }
216     
217     function generate(uint256 _value) onlyOwner public {
218         _totalSupply = SafeMath.add(_totalSupply, _value * 10 ** uint256(_decimals));
219         balances[msg.sender] = SafeMath.add(balances[msg.sender], _value * 10 ** uint256(_decimals));
220     }
221     
222     function burn(uint256 _value) public returns (bool success) {
223         require(balances[msg.sender] >= _value);
224         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
225         _totalSupply = SafeMath.sub(_totalSupply, _value);
226         Burn(msg.sender, _value);
227         return true;
228     }
229 
230     function burnFrom(address _from, uint256 _value) public returns (bool success) {
231         require(balances[_from] >= _value);
232         require(_value <= allowed[_from][msg.sender]);
233         balances[_from] = SafeMath.sub(balances[_from], _value);
234         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
235         _totalSupply = SafeMath.sub(_totalSupply, _value);
236         Burn(_from, _value);
237         return true;
238     }
239 }
240 
241 library SafeMath {
242   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243     if (a == 0) {
244       return 0;
245     }
246     uint256 c = a * b;
247     assert(c / a == b);
248     return c;
249   }
250 
251   function div(uint256 a, uint256 b) internal pure returns (uint256) {
252     // assert(b > 0); // Solidity automatically throws when dividing by 0
253     uint256 c = a / b;
254     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255     return c;
256   }
257 
258   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259     assert(b <= a);
260     return a - b;
261   }
262 
263   function add(uint256 a, uint256 b) internal pure returns (uint256) {
264     uint256 c = a + b;
265     assert(c >= a);
266     return c;
267   }
268 }