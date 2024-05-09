1 pragma solidity ^0.4.13;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) constant returns (uint256);
16   function transferFrom(address from, address to, uint256 value) returns (bool);
17   function approve(address spender, uint256 value) returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46   
47 }
48 
49 contract BasicToken is ERC20Basic {
50     
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   function transfer(address _to, uint256 _value) returns (bool) {
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(address _owner) constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 contract StandardToken is ERC20, BasicToken {
69 
70   mapping (address => mapping (address => uint256)) allowed;
71 
72   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
73     var _allowance = allowed[_from][msg.sender];
74 
75 
76     balances[_to] = balances[_to].add(_value);
77     balances[_from] = balances[_from].sub(_value);
78     allowed[_from][msg.sender] = _allowance.sub(_value);
79     Transfer(_from, _to, _value);
80     return true;
81   }
82 
83   function approve(address _spender, uint256 _value) returns (bool) {
84 
85     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86 
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92 
93   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94     return allowed[_owner][_spender];
95   }
96 
97 }
98 
99 
100 contract Ownable {
101     
102   address public owner;
103 
104 
105   function Ownable() {
106     owner = msg.sender;
107   }
108 
109 
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115 
116   function transferOwnership(address newOwner) onlyOwner {
117     require(newOwner != address(0));      
118     owner = newOwner;
119   }
120 
121 
122 }
123 contract BurnableToken is StandardToken, Ownable {
124 
125 
126   function burn(uint _value) public {
127     require(_value > 0);
128     address burner = msg.sender;
129     balances[burner] = balances[burner].sub(_value);
130     totalSupply = totalSupply.sub(_value);
131     Burn(burner, _value);
132   }
133 
134   event Burn(address indexed burner, uint indexed value);
135 
136 }
137 
138 contract NOCTAToken is BurnableToken {
139     
140   string public constant name = "NOCTA token";
141    
142   string public constant symbol = "NOCTA";
143     
144   uint32 public constant decimals = 6;
145 
146   uint256 public INITIAL_SUPPLY = 300000000 * 1000000 wei;
147 
148      
149   function NOCTAToken() {
150     totalSupply = INITIAL_SUPPLY;
151     balances[msg.sender] = INITIAL_SUPPLY;
152   }
153   
154 
155 }
156 
157 contract Presale is Ownable {
158     
159   using SafeMath for uint;
160     
161   address multisig;
162 
163   uint start;
164     
165   uint period;
166 
167   uint rate;
168 
169   token public tokenReward;
170            
171   function Presale(address addressOfTokenUsedAsReward) {
172     multisig = 0xA5F80ffd6496DDd9Ab390c74ADB34aEe66f08F56;
173     rate = 10000000000;
174     start = 1505577600;
175     period = 44;
176     tokenReward = token(addressOfTokenUsedAsReward);
177   }
178 
179   modifier saleIsOn() {
180     require(now > start && now < start + period * 1 days);
181     _;
182   }
183 
184   modifier saleIsfinished() {
185     require(now > start && now > start + period * 1 days);
186     _;
187   }
188   
189   function createTokens() saleIsOn payable {
190     multisig.transfer(msg.value);
191     uint tokens = rate.mul(msg.value).div(1 ether);
192     tokenReward.transfer(msg.sender, tokens);
193   }
194 
195   function() external payable {
196     createTokens();
197   }
198 
199   function getBack(uint _value) onlyOwner saleIsfinished {
200     require(_value > 0);
201     tokenReward.transfer(owner, _value);
202   }
203  }