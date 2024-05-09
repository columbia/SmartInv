1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) constant returns (uint256);
33   function transfer(address to, uint256 value) returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) returns (bool);
41   function approve(address spender, uint256 value) returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   function transfer(address _to, uint256 _value) returns (bool) {
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 }
62 
63 
64 contract StandardToken is ERC20, BasicToken {
65   mapping (address => mapping (address => uint256)) allowed;
66 
67   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
68     var _allowance = allowed[_from][msg.sender];
69 
70     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
71     // require (_value <= _allowance);
72 
73     balances[_from] = balances[_from].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     allowed[_from][msg.sender] = _allowance.sub(_value);
76     Transfer(_from, _to, _value);
77     return true;
78   }
79 
80   function approve(address _spender, uint256 _value) returns (bool) {
81     // To change the approve amount you first have to reduce the addresses`
82     //  allowance to zero by calling `approve(_spender, 0)` if it is not
83     //  already 0 to mitigate the race condition described here:
84     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86 
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93     return allowed[_owner][_spender];
94   }
95 
96     /*
97    * approve should be called when allowed[_spender] == 0. To increment
98    * allowed value is better to use this function to avoid 2 calls (and wait until
99    * the first transaction is mined)
100    * From MonolithDAO Token.sol
101    */
102   function increaseApproval (address _spender, uint _addedValue)
103     returns (bool success) {
104     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 
109   function decreaseApproval (address _spender, uint _subtractedValue)
110     returns (bool success) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 }
121 
122 
123 contract Ownable {
124   address public owner;
125 
126   function Ownable() {
127     owner = msg.sender;
128   }
129 
130   modifier onlyOwner() {
131     require(msg.sender == owner);
132     _;
133   }
134 
135   function transferOwnership(address newOwner) onlyOwner {
136     require(newOwner != address(0));
137     owner = newOwner;
138   }
139 }
140 
141 
142 contract MintableToken is StandardToken, Ownable {
143   event Mint(address indexed to, uint256 amount);
144   event MintFinished();
145 
146   bool public mintingFinished = false;
147 
148   modifier canMint() {
149     require(!mintingFinished);
150     _;
151   }
152 
153   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
154     totalSupply = totalSupply.add(_amount);
155     balances[_to] = balances[_to].add(_amount);
156     Mint(_to, _amount);
157     Transfer(0x0, _to, _amount);
158     return true;
159   }
160 
161   function finishMinting() onlyOwner returns (bool) {
162     mintingFinished = true;
163     MintFinished();
164     return true;
165   }
166 }
167 
168 
169 contract CBTSToken is MintableToken {
170   string public name = "Stormium";
171   string public symbol = "CBTS";
172   uint8 public decimals = 8;
173 
174   function CBTSToken() {
175       totalSupply = 100000 * 1e8;
176       balances[msg.sender] = totalSupply;
177   }
178 
179   event Burn(address indexed burner, uint indexed value);
180 
181   function burn(uint _value) onlyOwner {
182     require(_value > 0);
183 
184     address burner = msg.sender;
185     balances[burner] = balances[burner].sub(_value);
186     totalSupply = totalSupply.sub(_value);
187     Burn(burner, _value);
188   }
189 }