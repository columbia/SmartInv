1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     owner = newOwner;
47   }
48 }
49 
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56   modifier whenNotPaused() {
57     require(!paused);
58     _;
59   }
60 
61   modifier whenPaused() {
62     require(paused);
63     _;
64   }
65 
66   function pause() onlyOwner whenNotPaused public {
67     paused = true;
68     Pause();
69   }
70 
71   function unpause() onlyOwner whenPaused public {
72     paused = false;
73     Unpause();
74   }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 contract RINGCASINO is ERC20, Ownable, Pausable {
94 
95   using SafeMath for uint256;
96 
97   string public name;
98   string public symbol;
99   uint8 public decimals;
100   uint256 initialSupply;
101   uint256 totalSupply_;
102 
103   mapping(address => uint256) balances;
104   mapping(address => bool) internal locks;
105   mapping(address => mapping(address => uint256)) internal allowed;
106 
107   function RINGCASINO() public {
108     name = "RINGCASINO";
109     symbol = "RCC";
110     decimals = 18;
111     initialSupply = 3000000000;
112     totalSupply_ = initialSupply * 10 ** uint(decimals);
113     balances[owner] = totalSupply_;
114     Transfer(address(0), owner, totalSupply_);
115   }
116 
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[msg.sender]);
124     require(locks[msg.sender] == false);
125     
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141     require(locks[_from] == false);
142     
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
151     require(_value > 0);
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   function burn(uint256 _value) public onlyOwner returns (bool success) {
162     require(_value <= balances[msg.sender]);
163     address burner = msg.sender;
164     balances[burner] = balances[burner].sub(_value);
165     totalSupply_ = totalSupply_.sub(_value);
166     return true;
167   }
168   
169   function lock(address _owner) public onlyOwner returns (bool) {
170     require(locks[_owner] == false);
171     locks[_owner] = true;
172     return true;
173   }
174 
175   function unlock(address _owner) public onlyOwner returns (bool) {
176     require(locks[_owner] == true);
177     locks[_owner] = false;
178     return true;
179   }
180 
181   function showLockState(address _owner) public view returns (bool) {
182     return locks[_owner];
183   }
184 
185   function () public payable {
186     revert();
187   }
188 
189   function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[owner]);
192 
193     balances[owner] = balances[owner].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     Transfer(owner, _to, _value);
196     return true;
197   }
198 }