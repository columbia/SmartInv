1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40   
41 }
42 
43 contract BasicToken is ERC20Basic {
44     
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   function transfer(address _to, uint256 _value) returns (bool) {
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 contract StandardToken is ERC20, BasicToken {
63 
64   mapping (address => mapping (address => uint256)) allowed;
65 
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67     var _allowance = allowed[_from][msg.sender];
68 
69 
70     balances[_to] = balances[_to].add(_value);
71     balances[_from] = balances[_from].sub(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77   function approve(address _spender, uint256 _value) returns (bool) {
78 
79     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
80 
81     allowed[msg.sender][_spender] = _value;
82     Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87     return allowed[_owner][_spender];
88   }
89 
90 }
91 
92 contract Ownable {
93     
94   address public owner;
95 
96   function Ownable() {
97     owner = msg.sender;
98   }
99 
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   function transferOwnership(address newOwner) onlyOwner {
106     require(newOwner != address(0));      
107     owner = newOwner;
108   }
109 
110 }
111 
112 
113 contract MintableToken is StandardToken, Ownable {
114     
115   event Mint(address indexed to, uint256 amount);
116   
117   event MintFinished();
118 
119   bool public mintingFinished = false;
120 
121   modifier canMint() {
122     require(!mintingFinished);
123     _;
124   }
125 
126   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
127     totalSupply = totalSupply.add(_amount);
128     balances[_to] = balances[_to].add(_amount);
129     Mint(_to, _amount);
130     return true;
131   }
132 
133   function finishMinting() onlyOwner returns (bool) {
134     mintingFinished = true;
135     MintFinished();
136     return true;
137   }
138   
139 }
140 
141 contract TtestaryToken is MintableToken {
142     
143     string public constant name = "Ttestary";
144     string public constant symbol = "TTARY";
145     uint32 public constant decimals = 18;
146     
147 }
148 
149 
150 contract Ttestary is Ownable {
151     
152     using SafeMath for uint;
153     
154     TtestaryToken public token = new TtestaryToken();
155     
156     address eth_addr;
157     uint devs_percent;
158     uint start;
159     uint period;
160     uint hardcap;
161     uint rate;
162 
163     function Crowdsale() {
164         eth_addr = 0x785862CEBCEcE601c6E1f79315c9320A6721Ea92;
165         devs_percent = 3;
166         rate = 5000e18;
167         start = 1524060501;
168         period = 30;
169         hardcap = 500 ether;
170     }
171 
172     modifier saleIsOn() {
173     	require(now > start && now < start + period * 1 days);
174     	_;
175     }
176 	
177     modifier isUnderHardCap() {
178         require(eth_addr.balance <= hardcap);
179         _;
180     }
181  
182     function finishMinting() public onlyOwner {
183 	uint issuedTokenSupply = token.totalSupply();
184 	uint restrictedTokens = issuedTokenSupply.mul(devs_percent).div(100 - devs_percent);
185 	token.mint(eth_addr, restrictedTokens);
186         token.finishMinting();
187     }
188  
189    function createTokens() isUnderHardCap saleIsOn payable {
190         eth_addr.transfer(msg.value);
191         uint tokens = rate.mul(msg.value).div(1 ether);
192         uint bonusTokens = 0;
193         if(now < start + (period * 1 days).div(5)) {
194           bonusTokens = tokens.div(5);
195         } else {
196           bonusTokens = 0;
197         } 
198         tokens += bonusTokens;
199         token.mint(msg.sender, tokens);
200     }
201  
202     function() payable {
203         createTokens();
204     }
205     
206 }