1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) public onlyOwner {
19     require(newOwner != address(0));
20     OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 
24 }
25 
26 contract Pausable is Ownable {
27   event Pause();
28   event Unpause();
29 
30   bool public paused = false;
31 
32   modifier whenNotPaused() {
33     require(!paused);
34     _;
35   }
36 
37   modifier whenPaused() {
38     require(paused);
39     _;
40   }
41 
42   function pause() onlyOwner whenNotPaused public {
43     paused = true;
44     Pause();
45   }
46 
47   function unpause() onlyOwner whenPaused public {
48     paused = false;
49     Unpause();
50   }
51 }
52 
53 library SafeMath {
54   function mul(uint a, uint b) internal pure returns (uint) {
55     if (a == 0) {
56       return 0;
57     }
58     uint c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint a, uint b) internal pure returns (uint) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint a, uint b) internal pure returns (uint) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint a, uint b) internal pure returns (uint) {
76     uint c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 contract ERC20 {
83   string public name;
84   string public symbol;
85   uint8 public decimals;
86   uint public totalSupply;  
87   function ERC20(string _name, string _symbol, uint8 _decimals) public {
88     name = _name;
89     symbol = _symbol;
90     decimals = _decimals;
91   }
92   function balanceOf(address who) public view returns (uint);
93   function transfer(address to, uint value) public returns (bool);
94   function allowance(address owner, address spender) public view returns (uint);
95   function transferFrom(address from, address to, uint value) public returns (bool);
96   function approve(address spender, uint value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint value);
98   event Approval(address indexed owner, address indexed spender, uint value);
99 }
100 contract Token is Pausable, ERC20 {
101   using SafeMath for uint;
102 
103   mapping(address => uint) balances;
104   mapping (address => mapping (address => uint)) internal allowed;
105   mapping(address => uint) public balanceOfLocked;
106 
107   uint public unlocktime;
108   bool manualUnlock;
109   address public crowdsaleAddress = 0;
110 
111   function Token() ERC20("SphereCoin", "SPH", 18) public {
112     manualUnlock = false;
113     unlocktime = 1525017600;
114     totalSupply = 10000000000 * 10 ** uint(decimals);
115     balances[msg.sender] = totalSupply;
116   }
117 
118   function allowCrowdsaleAddress(address crowdsale) onlyOwner public {
119     crowdsaleAddress = crowdsale;
120   }
121 
122   function isLocked() view public returns (bool) {
123     return (now < unlocktime && !manualUnlock);
124   }
125 
126   modifier lockCheck(address from, uint value) { 
127     if (isLocked()) {
128       require(value <= balances[from] - balanceOfLocked[from]);
129     } else {
130       balanceOfLocked[from] = 0;
131     }
132     _;
133   }
134 
135   function unlock() onlyOwner public {
136     require(!manualUnlock);
137     manualUnlock = true;
138   }
139 
140   function transfer(address _to, uint _value) lockCheck(msg.sender, _value) whenNotPaused public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   function transferLockedPart(address _to, uint _value) whenNotPaused public returns (bool) {
151     require(msg.sender == crowdsaleAddress);
152     if (transfer(_to, _value)) {
153       balanceOfLocked[_to] = balanceOfLocked[_to].add(_value);
154       return true;
155     }
156   }
157 
158   function balanceOf(address _owner) public view returns (uint balance) {
159     return balances[_owner];
160   }
161 
162   function transferFrom(address _from, address _to, uint _value) public lockCheck(_from, _value) whenNotPaused returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   function allowance(address _owner, address _spender) public view returns (uint) {
181     return allowed[_owner][_spender];
182   }
183 
184   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 }