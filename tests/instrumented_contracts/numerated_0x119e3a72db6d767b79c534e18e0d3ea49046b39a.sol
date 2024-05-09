1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17  
18 
19 }
20 
21 contract Pausable is Ownable {
22   event Pause();
23   event Unpause();
24 
25   bool public paused = false;
26 
27   function Pausable() public {}
28 
29   
30   modifier whenNotPaused() {
31     require(!paused);
32     _;
33   }
34 
35   
36   modifier whenPaused {
37     require(paused);
38     _;
39   }
40 
41   
42   function pause() public onlyOwner whenNotPaused returns (bool) {
43     paused = true;
44     Pause();
45     return true;
46   }
47 
48  
49   function unpause() public onlyOwner whenPaused returns (bool) {
50     paused = false;
51     Unpause();
52     return true;
53   }
54 }
55 
56 contract SafeMath {
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a / b;
65     return c;
66   }
67 
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract Bankroi is Pausable, SafeMath {
81 
82   uint256 public totalSupply;
83 
84   mapping(address => uint) public balances;
85   mapping (address => mapping (address => uint)) public allowed;
86 
87   
88   
89   string public constant name = "BankRoi";
90   string public constant symbol = "BROI";
91   uint8 public constant decimals = 8;
92   
93   // custom properties
94   bool public mintingFinished = false;
95   uint256 public constant MINTING_LIMIT = 100000000 * 100000000;
96 
97   event Transfer(address indexed from, address indexed to, uint256 value);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 
100   event Mint(address indexed to, uint256 amount);
101   event MintFinished();
102 
103   function Bankroi() public {}
104 
105   function() public payable {
106     revert();
107   }
108 
109   function balanceOf(address _owner) public constant returns (uint256) {
110     return balances[_owner];
111   }
112 
113   function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
114 
115     balances[msg.sender] = sub(balances[msg.sender], _value);
116     balances[_to] = add(balances[_to], _value);
117 
118     Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
123     var _allowance = allowed[_from][msg.sender];
124 
125     balances[_to] = add(balances[_to], _value);
126     balances[_from] = sub(balances[_from], _value);
127     allowed[_from][msg.sender] = sub(_allowance, _value);
128 
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
134     
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136     
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   function allowance(address _owner, address _spender) public constant returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   modifier canMint() {
147     require(!mintingFinished);
148     _;
149   }
150 
151   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
152     totalSupply = add(totalSupply, _amount);
153     require(totalSupply <= MINTING_LIMIT);
154     
155     balances[_to] = add(balances[_to], _amount);
156     Mint(_to, _amount);
157     return true;
158   }
159 
160   function finishMinting() public onlyOwner returns (bool) {
161     mintingFinished = true;
162     MintFinished();
163     return true;
164   }
165 
166 
167 }