1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
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
23 }
24 
25 
26 contract Admin is Ownable {
27   mapping(address => bool) public adminlist;
28 
29   event AdminAddressAdded(address addr);
30   event AdminAddressRemoved(address addr);
31 
32   function isAdmin() public view returns(bool) {
33     if (owner == msg.sender) {
34       return true;
35     }
36     return adminlist[msg.sender];
37   }
38 
39   function isAdminAddress(address addr) view public returns(bool) {
40     return adminlist[addr];
41   }
42 
43   function addAddressToAdminlist(address addr) onlyOwner public returns(bool success) {
44     if (!adminlist[addr]) {
45       adminlist[addr] = true;
46       AdminAddressAdded(addr);
47       success = true;
48     }
49   }
50 
51   function removeAddressFromAdminlist(address addr) onlyOwner public returns(bool success) {
52     if (adminlist[addr]) {
53       adminlist[addr] = false;
54       AdminAddressRemoved(addr);
55       success = true;
56     }
57   }
58 
59 }
60 
61 
62 contract Pausable is Ownable, Admin {
63   event Pause();
64   event Unpause();
65 
66   bool public paused = true;
67 
68   modifier whenNotPaused() {
69     require(!paused || isAdmin());
70     _;
71   }
72 
73   modifier whenPaused() {
74     require(paused || isAdmin());
75     _;
76   }
77 
78   function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     Pause();
81   }
82 
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 
90 
91 contract ERC20 {
92 
93   function totalSupply() public view returns (uint256);
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97 
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 
106 contract SafeMath {
107 
108   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
109     uint256 z = x + y;
110     assert((z >= x) && (z >= y));
111     return z;
112   }
113 
114   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
115     assert(x >= y);
116     uint256 z = x - y;
117     return z;
118   }
119 
120   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
121     uint256 z = x * y;
122     assert((x == 0)||(z/x == y));
123     return z;
124   }
125 
126   function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
127     // assert(b > 0); // Solidity automatically throws when dividing by 0
128     uint256 z = x / y;
129     return z;
130   }
131 }
132 
133 
134 contract StandardToken is ERC20, SafeMath {
135   /**
136   * @dev Fix for the ERC20 short address attack.
137    */
138   modifier onlyPayloadSize(uint size) {
139     require(msg.data.length >= size + 4) ;
140     _;
141   }
142 
143   mapping(address => uint256) balances;
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool){
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
151     balances[_to] = safeAdd(balances[_to], _value);
152     Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     uint _allowance = allowed[_from][msg.sender];
162 
163     balances[_to] = safeAdd(balances[_to], _value);
164     balances[_from] = safeSubtract(balances[_from], _value);
165     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
166     Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   function balanceOf(address _owner) public view returns (uint) {
171     return balances[_owner];
172   }
173 
174   function approve(address _spender, uint _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   function allowance(address _owner, address _spender) public view returns (uint) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 contract HeroNodeToken is StandardToken, Pausable {
187   string public constant name = "HeroNodeToken";
188   string public constant symbol = "HNC";
189   uint256 public constant decimals = 18;
190   string public version = "1.0";
191 
192   uint256 public constant total = 20 * (10**8) * 10**decimals;   // 20 *10^8 HNC total
193 
194   function HeroNodeToken() public {
195     balances[msg.sender] = total;
196     Transfer(0x0, msg.sender, total);
197   }
198 
199   function totalSupply() public view returns (uint256) {
200     return total;
201   }
202 
203   function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
204     return super.transfer(_to,_value);
205   }
206 
207   function approve(address _spender, uint _value) whenNotPaused public returns (bool) {
208     return super.approve(_spender,_value);
209   }
210 
211   function airdropToAddresses(address[] addrs, uint256 amount) whenNotPaused public {
212     for (uint256 i = 0; i < addrs.length; i++) {
213       transfer(addrs[i], amount);
214     }
215   }
216 }