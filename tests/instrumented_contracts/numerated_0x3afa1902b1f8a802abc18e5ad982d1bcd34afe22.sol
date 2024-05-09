1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
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
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a / b;
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   uint256 totalSupply_;
48 
49   function totalSupply() public view returns (uint256) {
50     return totalSupply_;
51   }
52 
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     emit Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   function balanceOf(address _owner) public view returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74 
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79 
80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     emit Transfer(_from, _to, _value);
84     return true;
85   }
86 
87  
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     allowed[msg.sender][_spender] = _value;
90     emit Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94  
95   function allowance(address _owner, address _spender) public view returns (uint256) {
96     return allowed[_owner][_spender];
97   }
98 
99  
100   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
101     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
102     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 
106 
107   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118 }
119 
120 contract Ownable {
121   address public owner;
122 
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124   constructor() public {
125     owner = msg.sender;
126   }
127 
128   modifier onlyOwner() {
129     require(msg.sender == owner);
130     _;
131   }
132 
133   function transferOwnership(address newOwner) public onlyOwner {
134     require(newOwner != address(0));
135     emit OwnershipTransferred(owner, newOwner);
136     owner = newOwner;
137   }
138 
139 }
140 
141 contract Pausable is Ownable {
142   event Pause();
143   event Unpause();
144 
145   bool public paused = false;
146 
147   modifier whenNotPaused() {
148     require(!paused);
149     _;
150   }
151   modifier whenPaused() {
152     require(paused);
153     _;
154   }
155 
156   function pause() public onlyOwner whenNotPaused returns (bool) {
157     paused = true;
158     emit Pause();
159     return true;
160   }
161 
162   function unpause() public onlyOwner whenPaused returns (bool) {
163     paused = false;
164     emit Unpause();
165     return true;
166   }
167 }
168 
169 contract PausableToken is StandardToken, Pausable {
170 
171   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
172     return super.transfer(_to, _value);
173   }
174 
175   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
176     return super.transferFrom(_from, _to, _value);
177   }
178 
179   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
180     return super.approve(_spender, _value);
181   }
182 
183   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
184     return super.increaseApproval(_spender, _addedValue);
185   }
186 
187   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
188     return super.decreaseApproval(_spender, _subtractedValue);
189   }
190 }
191 
192 contract GSToken is PausableToken {
193 
194     string  public name = "GrEARN's Token";
195     string  public symbol = "GST";
196     uint    public decimals = 18;
197 
198     mapping (address => bool) public frozenAccount;
199     mapping (address => uint256) public frozenAccountTokens;
200     
201     event FrozenFunds(address target, bool frozen);
202     event Burn(address indexed burner, uint256 value);
203     event Freeze(address indexed from, uint256 value);
204     event Unfreeze(address indexed from, uint256 value);
205 
206     constructor() public
207     {
208         totalSupply_ = 60 * 10 ** (uint256(decimals) + 8);
209         balances[msg.sender] = totalSupply_;
210     }
211 
212     function burn(uint256 _value) public onlyOwner returns (bool success) {
213         require(balances[msg.sender] >= _value);
214         require(_value > 0);
215         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);   
216         totalSupply_ = SafeMath.sub(totalSupply_,_value);
217         emit Burn(msg.sender, _value);
218         return true;
219     }
220 
221     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222         require(!frozenAccount[_from]);
223         require(SafeMath.add(frozenAccountTokens[_from], _value) <= balances[_from]);
224 
225         return super.transferFrom(_from, _to, _value);
226     }
227 
228     function transfer(address _to, uint256 _value) public returns (bool) {
229         require(!frozenAccount[msg.sender]);
230         require(SafeMath.add(frozenAccountTokens[msg.sender], _value) <= balances[msg.sender]);
231         return super.transfer(_to, _value);
232     }
233 
234     function transferAndFreezeTokens(address _to, uint256 _value) public onlyOwner returns (bool) {
235         transfer(_to, _value);
236         freezeAccountWithToken(_to, _value);
237         return true;
238     }
239 
240     function freezeAccount(address target, bool freeze) public onlyOwner {
241         frozenAccount[target] = freeze;
242         emit FrozenFunds(target, freeze);
243     }
244 
245     function freezeAccountWithToken(address wallet, uint256 _value) public onlyOwner returns (bool success) {
246         require(balances[wallet] >= _value);
247         require(_value > 0); 
248         frozenAccountTokens[wallet] = SafeMath.add(frozenAccountTokens[wallet], _value);
249         emit Freeze(wallet, _value);
250         return true;
251     }
252     
253     function unfreezeAccountWithToken(address wallet, uint256 _value) public onlyOwner returns (bool success) {
254         require(balances[wallet] >= _value);
255         require(_value > 0); 
256         frozenAccountTokens[wallet] = SafeMath.sub(frozenAccountTokens[wallet], _value);         
257         emit Unfreeze(wallet, _value);
258         return true;
259     }
260 
261     function multisend(address[] dests, uint256[] values) public onlyOwner returns (uint256) {
262         uint256 i = 0;
263         while (i < dests.length) {
264             transferAndFreezeTokens(dests[i], values[i] * 10 ** 18);
265             i += 1;
266         }
267         return(i);
268     }
269 }