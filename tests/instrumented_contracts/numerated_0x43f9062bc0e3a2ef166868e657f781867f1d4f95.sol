1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   constructor() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52   function renounceOwnership() public onlyOwner {
53     emit OwnershipRenounced(owner);
54     owner = address(0);
55   }
56 }
57 
58 contract Pausable is Ownable {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64   modifier whenNotPaused() {
65     require(!paused);
66     _;
67   }
68 
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     emit Pause();
77   }
78 
79   function unpause() onlyOwner whenPaused public {
80     paused = false;
81     emit Unpause();
82   }
83 }
84 
85 contract ERC20Basic {
86   function totalSupply() public view returns (uint256);
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   uint256 totalSupply_;
105 
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 }
124 
125 contract BurnableToken is BasicToken, Ownable {
126     event Burn(uint256 value);
127 
128     function burn(uint256 _value) onlyOwner public {
129         require(_value <= balances[owner]);
130 
131         balances[owner] = balances[owner].sub(_value);
132         totalSupply_ = totalSupply_.sub(_value);
133         emit Burn(_value);
134     }
135 }
136 
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     emit Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     emit Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   function allowance(address _owner, address _spender) public view returns (uint256) {
160     return allowed[_owner][_spender];
161   }
162 
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 }
180 
181 contract PausableToken is StandardToken, Pausable {
182 
183   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
184     return super.transfer(_to, _value);
185   }
186 
187   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
188     return super.transferFrom(_from, _to, _value);
189   }
190 
191   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
192     return super.approve(_spender, _value);
193   }
194 
195   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
196     return super.increaseApproval(_spender, _addedValue);
197   }
198 
199   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
200     return super.decreaseApproval(_spender, _subtractedValue);
201   }
202 }
203 
204 contract SantaCoin is PausableToken, BurnableToken {
205     string public constant name = "Santa Coin";
206     string public constant symbol = "SANTA";
207     uint8 public constant decimals = 18;
208 
209     constructor(uint256 _amount) public
210         Ownable()
211     {
212         totalSupply_ = _amount * 1 ether;
213         balances[owner] = totalSupply_;
214     }
215 }