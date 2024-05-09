1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public constant returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 contract Ownable {
13   address public owner;
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   function transferOwnership(address newOwner) onlyOwner public {
26     require(newOwner != address(0));
27     OwnershipTransferred(owner, newOwner);
28     owner = newOwner;
29   }
30 
31 }
32 
33 
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 
59 }
60 
61 
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69 
70     // SafeMath.sub will throw if there is not enough balance.
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   function balanceOf(address _owner) public constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) allowed;
95 
96   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98 
99     uint256 _allowance = allowed[_from][msg.sender];
100 
101     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102     // require (_value <= _allowance);
103 
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121   function increaseApproval (address _spender, uint _addedValue)
122     returns (bool success) {
123     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128   function decreaseApproval (address _spender, uint _subtractedValue)
129     returns (bool success) {
130     uint oldValue = allowed[msg.sender][_spender];
131     if (_subtractedValue > oldValue) {
132       allowed[msg.sender][_spender] = 0;
133     } else {
134       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
135     }
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140 }
141 
142 
143 contract Pausable is Ownable {
144   event Pause();
145   event Unpause();
146 
147   bool public paused = false;
148 
149   modifier whenNotPaused() {
150     require(!paused);
151     _;
152   }
153 
154   modifier whenPaused() {
155     require(paused);
156     _;
157   }
158 
159   function pause() onlyOwner whenNotPaused public {
160     paused = true;
161     Pause();
162   }
163 
164   function unpause() onlyOwner whenPaused public {
165     paused = false;
166     Unpause();
167   }
168 
169 }
170 
171 
172 contract MyToken is StandardToken, Pausable {
173 
174   string public constant name = 'MyToken';
175   string public constant symbol = 'MYT';
176   uint8 public constant decimals = 8;
177   uint256 public constant INITIAL_SUPPLY = 10e8 * 10**uint256(decimals);
178 
179   modifier rejectTokensToContract(address _to) {
180     require(_to != address(this));
181     _;
182   }
183 
184   function MyToken() {
185     totalSupply = INITIAL_SUPPLY;
186     balances[msg.sender] = INITIAL_SUPPLY;
187     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
188   }
189 
190   function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
191     return super.transfer(_to, _value);
192   }
193 
194   function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
195     return super.transferFrom(_from, _to, _value);
196   }
197 
198   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
199     return super.approve(_spender, _value);
200   }
201 
202   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
203     return super.increaseApproval(_spender, _addedValue);
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
207     return super.decreaseApproval(_spender, _subtractedValue);
208   }
209 
210 }