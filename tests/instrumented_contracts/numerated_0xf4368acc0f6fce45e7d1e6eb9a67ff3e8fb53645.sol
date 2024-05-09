1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  */
37 contract Ownable {
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   constructor () public {
43     owner = msg.sender;
44   }
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 }
57 
58 /**
59  * @title Pausable
60  */
61 contract Pausable is Ownable {
62   event Pause();
63   event Unpause();
64 
65   bool public paused = false;
66 
67   modifier whenNotPaused() {
68     require(!paused);
69     _;
70   }
71 
72   modifier whenPaused() {
73     require(paused);
74     _;
75   }
76 
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     emit Unpause();
85   }
86 }
87 
88 /**
89  * @title ERC20Basic
90  */
91 contract ERC20Basic {
92   function totalSupply() public view returns (uint256);
93   function balanceOf(address who) public view returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 /**
99  * @title ERC20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @title BasicToken
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   uint256 totalSupply_;
117 
118   function totalSupply() public view returns (uint256) {
119     return totalSupply_;
120   }
121 
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     emit Transfer(msg.sender, _to, _value);
130     return true;
131   }
132   
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 }
137 
138 /**
139  * @title StandardToken
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   function allowance(address _owner, address _spender) public view returns (uint256) {
164     return allowed[_owner][_spender];
165   }
166 
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
174     uint oldValue = allowed[msg.sender][_spender];
175     if (_subtractedValue > oldValue) {
176       allowed[msg.sender][_spender] = 0;
177     } else {
178       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179     }
180     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 }
184 
185 /**
186  * @title Pausable token
187  **/
188 contract PausableToken is StandardToken, Pausable {
189 
190   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
191     return super.transfer(_to, _value);
192   }
193 
194   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
195     return super.transferFrom(_from, _to, _value);
196   }
197 
198   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
199     return super.approve(_spender, _value);
200   }
201 
202   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
203     return super.increaseApproval(_spender, _addedValue);
204   }
205 
206   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
207     return super.decreaseApproval(_spender, _subtractedValue);
208   }
209 }
210 
211 /**
212  * @title Toponet token 
213  */
214 contract ToponetToken is PausableToken {
215 
216   // token detail
217   string public name;
218   string public symbol;
219   uint256 public decimals;
220 
221   constructor (
222     string _name, 
223     string _symbol, 
224     uint256 _decimals,
225     uint256 _initSupply)
226     public
227   {
228     name = _name;
229     symbol = _symbol;
230     decimals = _decimals;
231     owner = msg.sender;
232 
233     totalSupply_ = _initSupply * 10 ** decimals;
234     balances[owner] = totalSupply_;
235   }
236 }