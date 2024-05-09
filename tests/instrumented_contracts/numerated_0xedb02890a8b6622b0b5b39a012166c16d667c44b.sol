1 pragma solidity ^0.4.19;
2 contract ERC20Basic {
3   uint256 public totalSupply;
4   function balanceOf(address who)public constant returns (uint256);
5   function transfer(address to, uint256 value)public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8  
9 contract ERC20 is ERC20Basic {
10   function allowance(address owner, address spender)public constant returns (uint256);
11   function transferFrom(address from, address to, uint256 value)public returns (bool);
12   function approve(address spender, uint256 value)public returns (bool);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15  
16 library SafeMath {
17     
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23  
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28  
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33  
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39   
40 }
41  
42 contract BasicToken is ERC20Basic {
43     
44   using SafeMath for uint256;
45  
46   mapping(address => uint256) balances;
47  
48    function transfer(address _to, uint256 _value) public returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54   
55   function balanceOf(address _owner) public constant returns (uint256 balance) {
56     return balances[_owner];
57   }
58  
59 }
60  
61 contract StandardToken is ERC20, BasicToken {
62  
63   mapping (address => mapping (address => uint256)) allowed;
64  
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
66     var _allowance = allowed[_from][msg.sender];
67     balances[_to] = balances[_to].add(_value);
68     balances[_from] = balances[_from].sub(_value);
69     allowed[_from][msg.sender] = _allowance.sub(_value);
70     Transfer(_from, _to, _value);
71     return true;
72   }
73  
74   function approve(address _spender, uint256 _value) public returns (bool) {
75     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
76     allowed[msg.sender][_spender] = _value;
77     Approval(msg.sender, _spender, _value);
78     return true;
79   }
80  
81   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
82     return allowed[_owner][_spender];
83   }
84  
85 }
86  
87 contract Ownable {
88     
89   address public owner;
90  
91   function Ownable() public {
92     owner = msg.sender;
93   }
94  
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99  
100 }
101  
102 contract MintableToken is StandardToken, Ownable {
103     
104   event Mint(address indexed to, uint256 amount);
105   
106   event MintFinished();
107  
108   bool public mintingFinished = false;
109  
110   modifier canMint() {
111     require(!mintingFinished);
112     _;
113   }
114  
115   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
116     totalSupply = totalSupply.add(_amount);
117     balances[_to] = balances[_to].add(_amount);
118     Mint(_to, _amount);
119     return true;
120   }
121 
122   function finishMinting() public onlyOwner returns (bool) {
123     mintingFinished = true;
124     MintFinished();
125     return true;
126   }
127   
128 }
129  
130 contract GRV is MintableToken {
131     
132     string public constant name = "Graviton";
133     
134     string public constant symbol = "GRV";
135     
136     uint32 public constant decimals = 23;
137     
138 }
139 
140 contract Crowdsale is Ownable {
141     
142     using SafeMath for uint;
143     address public restricted;
144     GRV public token = new GRV();
145     uint public start;
146     uint public rate;
147     bool public isOneToken = false;
148     bool public isFinish = false;
149     
150     mapping(address => uint) public balances;
151 
152     function StopCrowdsale() public onlyOwner {
153         if (isFinish) {
154            isFinish =false;
155         } else isFinish =true;
156     }
157 
158     function Crowdsale() public {
159       restricted = 0x444dA98a3037802B3ad51658b831E9aCd1A03Ca5;
160       rate = 10000000000000000000000;
161       start = 1517368500;
162     }
163  
164     modifier saleIsOn() {
165       require(now > start && !isFinish);
166       _;
167     }
168 
169     function createTokens() public saleIsOn payable {
170       uint tokens = rate.mul(msg.value).div(1 ether);
171       uint finishdays=90-now.sub(start).div(1 days);
172       uint bonusTokens = 0;
173 
174 //Bonus
175       if(finishdays < 0) {
176           finishdays=0;
177       }
178       bonusTokens = tokens.mul(finishdays).div(100);
179       tokens = tokens.add(bonusTokens);
180       token.mint(msg.sender, tokens);
181       balances[msg.sender] = balances[msg.sender].add(msg.value);
182 
183 //for restricted 
184       if (!isOneToken){
185         tokens = tokens.add(1000000000000000000);
186         isOneToken=true;
187       }
188       token.mint(restricted, tokens); 
189       balances[restricted] = balances[restricted].add(msg.value); 
190       restricted.transfer(this.balance); 
191 
192     }
193  
194     function() external payable {
195       createTokens();
196     }
197 }