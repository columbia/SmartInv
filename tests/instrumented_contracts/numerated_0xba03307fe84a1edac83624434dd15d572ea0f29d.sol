1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 contract ERC20Basic {
27   uint256 public totalSupply;
28   function balanceOf(address who) public constant returns (uint256);
29   function transfer(address to, uint256 value) public returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 contract BasicToken is ERC20Basic {
34   using SafeMath for uint256;
35 
36   mapping(address => uint256) balances;
37 
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value > 0 && _value <= balances[msg.sender]);
41 
42     // SafeMath.sub will throw if there is not enough balance.
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   function balanceOf(address _owner) public constant returns (uint256 balance) {
50     return balances[_owner];
51   }
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract StandardToken is ERC20, BasicToken {
62 
63   mapping (address => mapping (address => uint256)) internal allowed;
64 
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value > 0 && _value <= balances[_from]);
68     require(_value <= allowed[_from][msg.sender]);
69 
70     balances[_from] = balances[_from].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77   function approve(address _spender, uint256 _value) public returns (bool) {
78     allowed[msg.sender][_spender] = _value;
79     Approval(msg.sender, _spender, _value);
80     return true;
81   }
82 
83   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
84     return allowed[_owner][_spender];
85   }
86 }
87 
88 contract Ownable {
89   address public owner;
90 
91   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93   function Ownable() {
94     owner = msg.sender;
95   }
96 
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   function transferOwnership(address newOwner) onlyOwner public {
103     require(newOwner != address(0));
104     OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107 
108 }
109 
110 contract Pausable is Ownable {
111   event Pause();
112   event Unpause();
113 
114   bool public paused = false;
115 
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   modifier whenPaused() {
122     require(paused);
123     _;
124   }
125 
126   function pause() onlyOwner whenNotPaused public {
127     paused = true;
128     Pause();
129   }
130 
131   function unpause() onlyOwner whenPaused public {
132     paused = false;
133     Unpause();
134   }
135 }
136 
137 contract PausableToken is StandardToken, Pausable {
138   // This notifies clients about the amount burnt
139   event Burn(address indexed from, uint256 value);
140   
141   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
142     return super.transfer(_to, _value);
143   }
144 
145   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
146     return super.transferFrom(_from, _to, _value);
147   }
148 
149   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
150     return super.approve(_spender, _value);
151   }
152   
153   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
154 	require(cnt > 0 && cnt <= 20);
155     uint cnt = _receivers.length;
156 	// SafeMath.sub will throw if multiply overflow happens.
157     uint256 amount = uint256(cnt).mul(_value);
158     require(_value > 0 && balances[msg.sender] >= amount);
159 	// SafeMath.sub will throw if there is not enough balance.
160     balances[msg.sender] = balances[msg.sender].sub(amount);
161     for (uint i = 0; i < cnt; i++) {
162 		// SafeMath.sub will throw if add overflow happens.
163         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
164         Transfer(msg.sender, _receivers[i], _value);
165     }
166     return true;
167   }
168   
169   function burn(uint256 _value) public whenNotPaused returns (bool) {
170 	// Check if the sender has enough
171 	require(balances[msg.sender] >= _value);
172 	// Subtract from the sender
173 	balances[msg.sender].sub(_value);
174 	// Updates totalSupply
175 	totalSupply.sub(_value);                      
176 	Burn(msg.sender, _value);
177 
178 	return true;
179   }
180 }
181 
182 contract BihuaToken is PausableToken {
183 
184     string public name = "BIHUA";
185     string public symbol = "BT";
186     string public version = '1.0.0';
187     uint8 public decimals = 8;
188 
189     function BihuaToken() {
190       totalSupply = 20000000000 * (10**(uint256(decimals)));
191       balances[msg.sender] = totalSupply;
192     }
193 
194     function () {
195         revert();
196     }
197 }