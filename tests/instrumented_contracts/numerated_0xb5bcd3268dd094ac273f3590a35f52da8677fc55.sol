1 pragma solidity ^0.4.16;
2 
3 contract ERC20Basic 
4 {
5 	uint256 public totalSupply;
6 	function balanceOf(address who) constant public returns (uint256);
7 	function transfer(address to, uint256 value) public returns (bool);
8 	event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic
12 {
13 	function allowance(address owner, address spender) constant  public returns (uint256);
14 	function transferFrom(address from, address to, uint256 value)  public returns (bool);
15 	function approve(address spender, uint256 value)  public returns (bool);
16 	event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath 
20 {
21     
22 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a * b;
24 		assert(a == 0 || c / a == b);
25 		return c;
26 	}
27 
28 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
29 		// assert(b > 0); // Solidity automatically throws when dividing by 0
30 		uint256 c = a / b;
31 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 		return c;
33 	}
34 
35 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
41 		uint256 c = a + b;
42 		assert(c >= a);
43 		return c;
44 	}
45   
46 }
47 
48 contract BasicToken is ERC20Basic 
49 {
50     
51 	using SafeMath for uint256;
52 
53 	mapping(address => uint256) balances;
54 
55 	function transfer(address _to, uint256 _value) public returns (bool) {
56 		require(msg.data.length >= (2*32) + 4);     // доп. проверка на атаку с коротких адресов
57 		balances[msg.sender] = balances[msg.sender].sub(_value);
58 		balances[_to] = balances[_to].add(_value);
59 		Transfer(msg.sender, _to, _value);
60 		return true;
61 	}
62 
63 	function balanceOf(address _owner) constant public returns (uint256 balance) {
64 		return balances[_owner];
65 	}
66 }
67 
68 contract StandardToken is ERC20, BasicToken 
69 {
70 
71 	mapping (address => mapping (address => uint256)) allowed;
72 
73 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
74 	{
75 		require(msg.data.length >= (3*32) + 4);     // Fix for the ERC20 short address attack
76 		var _allowance = allowed[_from][msg.sender];
77 		
78 		balances[_to] = balances[_to].add(_value);
79 		balances[_from] = balances[_from].sub(_value);
80 		allowed[_from][msg.sender] = _allowance.sub(_value);
81 		Transfer(_from, _to, _value);
82     return true;
83 	}
84 
85     function approve(address _spender, uint256 _value) public returns (bool)
86 	{
87 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88 		allowed[msg.sender][_spender] = _value;
89 		Approval(msg.sender, _spender, _value);
90 		return true;
91 	}
92 
93 	function allowance(address _owner, address _spender) constant public returns (uint256 remaining) 
94 	{
95 		return allowed[_owner][_spender];
96 	}
97 
98 }
99 
100 contract Ownable 
101 {
102     address public owner;
103 
104 	function Ownable()  public
105 	{
106 		owner = msg.sender;
107 	}
108 
109 	modifier onlyOwner() 
110 	{
111 		require(msg.sender == owner);
112 		_;
113 	}
114 
115 	function transferOwnership(address newOwner)  public onlyOwner
116 	{
117 		require(newOwner != address(0));      
118 		owner = newOwner;
119 	}
120 }
121 
122 contract BurnableToken is StandardToken, Ownable 
123 {
124     uint256 endIco = 1527854400; // 1 июня
125 
126     modifier BurnAll() 
127     { 
128 		require(now > endIco && balances[owner] > 0);  
129 		_;
130 	}
131     
132 	function burn()  public BurnAll 
133 	{
134 		uint256 surplus = balances[owner];
135 		totalSupply = totalSupply.sub(1000);
136 		balances[owner] = 0;
137 		Burn(owner, surplus);
138 	}
139 	event Burn(address indexed burner, uint indexed value);
140 }
141 
142 contract OSCoinToken is BurnableToken 
143 {
144 	string public constant name = "OSCoin";   
145 	string public constant symbol = "OSC";    
146 	uint32 public constant decimals = 18;
147 
148 	uint256 public INITIAL_SUPPLY = 2000000 * 1 ether;
149 
150 	function OSCoinToken()  public
151 	{
152 		totalSupply = INITIAL_SUPPLY;
153 		balances[msg.sender] = INITIAL_SUPPLY;
154 		
155 		allowed[owner][0x740F7A070C283edc1cAd9351A67aD3b513f3136a] = (totalSupply).div(100).mul(11);     // запись о передаче права забрать 11% from to надо установить нужный адрес для пересылки OSCoin
156 		Approval(owner,0x740F7A070C283edc1cAd9351A67aD3b513f3136a, (totalSupply).div(100).mul(11));     // передаче права забрать 11% from to          надо установить нужный адрес для пересылки OSCoin
157 	}
158 }
159 
160 contract Crowdsale is Ownable
161 {   
162     // текущее время http://i-leon.ru/tools/time   
163         
164     uint256 startPreIco = 1522065600; // 26 марта
165     uint256 startIco = 1525089600; // 30 апреля
166     uint256 endIco = 1527854400; // 1 июня
167     
168 	using SafeMath for uint;    
169 	address multisig;
170 	uint restrictedPercent;
171 	address restricted;
172 	OSCoinToken public token = new OSCoinToken();
173 	
174 	uint period;
175 	uint rate;
176 	
177 	function Crowdsale() public {
178 		multisig = 0x83dd3A421C98ea8fd59798bC57B4e2C75Caf9935;      // адрес куда будут перечисляться вырученные Ethereum
179 		restricted = 0x83dd3A421C98ea8fd59798bC57B4e2C75Caf9935;    // адрес куда будут перечисляться 23% с продаж надо установить нужный адрес для пересылки OSCoin
180 		restrictedPercent = 23;
181 		rate = 1000000000000000000000;
182 	}
183 
184 	modifier saleIsOn() 
185 	{
186 		require(now < endIco);
187 		_;
188 	}
189 
190 	function createTokens() saleIsOn  public payable {
191 		multisig.transfer(msg.value);
192 		uint tokens = rate.mul(msg.value).div(1 ether);
193 		uint bonusTokens = 0;
194 		
195 		if((now < startPreIco)) 
196 		{ 
197 			bonusTokens = tokens.div(2);
198 		} else if(now >= startPreIco && now < startIco) {
199 			bonusTokens = tokens.div(4);
200 		}
201 		
202 		uint tokensWithBonus = tokens.add(bonusTokens);
203 		token.transfer(msg.sender, tokensWithBonus);
204 		uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);
205 		token.transfer(restricted, restrictedTokens);
206 	}
207 
208 	function() external payable 
209 	{
210 		createTokens();
211 	}
212 }