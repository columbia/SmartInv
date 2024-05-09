1 pragma solidity ^0.4.18;
2 
3 /************************************************** */
4 /* ICO Review Token Smart Contract		            */
5 /* ICRT Created by Dev Team Find and Review ICO     */
6 /* https://www.findingico.review/		            */
7 /* Copyright (c) 2018 			                    */
8 /************************************************** */
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a / b;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract AltcoinToken {
34     function balanceOf(address _owner) constant public returns (uint256);
35     function transfer(address _to, uint256 _value) public returns (bool);
36 }
37 
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46     function allowance(address owner, address spender) public constant returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 contract ICRT is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;    
59 
60 	/********************************************************************************************/
61     /*                             	ICRT Token Information                     	                */
62     /********************************************************************************************/	
63     string public constant name = "ICO Review";							//Token Name ICO Review
64     string public constant symbol = "ICRT";								//Token Symbol ICRT (ICo Review Token)
65     uint public constant decimals = 8;    								//Decimals 8
66     uint256 public totalSupply = 30000000000e8;							//Total Suplay 30B
67 	string public logoPng = "https://github.com/ICRToken/ICRT/blob/master/image/ICRT.png";
68 	
69     uint256 public totalDistributed = 0;        
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73     
74     event Distr(address indexed to, uint256 amount);
75     event DistrFinished();
76     
77     event Burn(address indexed burner, uint256 value);
78 
79     bool public distributionFinished = false;
80     
81     modifier canDistr() {
82         require(!distributionFinished);
83         _;
84     }
85     
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90     
91     function ICRT () public {
92         owner = msg.sender;
93         distr(owner, totalSupply);
94     }
95     
96     function transferOwnership(address newOwner) onlyOwner public {
97         if (newOwner != address(0)) {
98             owner = newOwner;
99         }
100     }
101 
102     function finishDistribution() onlyOwner canDistr public returns (bool) {
103         distributionFinished = true;
104         emit DistrFinished();
105         return true;
106     }
107     
108     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
109         totalDistributed = totalDistributed.add(_amount);        
110         balances[_to] = balances[_to].add(_amount);
111         emit Distr(_to, _amount);
112         emit Transfer(address(0), _to, _amount);
113 
114         return true;
115     }
116            
117     function () external payable {}
118     
119     function balanceOf(address _owner) constant public returns (uint256) {
120         return balances[_owner];
121     }
122 
123     modifier onlyPayloadSize(uint size) {
124         assert(msg.data.length >= size + 4);
125         _;
126     }
127     
128     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
129 
130         require(_to != address(0));
131         require(_amount <= balances[msg.sender]);
132         
133         balances[msg.sender] = balances[msg.sender].sub(_amount);
134         balances[_to] = balances[_to].add(_amount);
135         emit Transfer(msg.sender, _to, _amount);
136         return true;
137     }
138     
139     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
140 
141         require(_to != address(0));
142         require(_amount <= balances[_from]);
143         require(_amount <= allowed[_from][msg.sender]);
144         
145         balances[_from] = balances[_from].sub(_amount);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
147         balances[_to] = balances[_to].add(_amount);
148         emit Transfer(_from, _to, _amount);
149         return true;
150     }
151     
152     function approve(address _spender, uint256 _value) public returns (bool success) {
153         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
154         allowed[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158     
159     function allowance(address _owner, address _spender) constant public returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162     
163     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
164         AltcoinToken t = AltcoinToken(tokenAddress);
165         uint bal = t.balanceOf(who);
166         return bal;
167     }
168     
169     function withdraw() onlyOwner public {
170         address myAddress = this;
171         uint256 etherBalance = myAddress.balance;
172         owner.transfer(etherBalance);
173     }
174     
175     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
176         AltcoinToken token = AltcoinToken(_tokenContract);
177         uint256 amount = token.balanceOf(address(this));
178         return token.transfer(owner, amount);
179     }
180 	
181 	/********************************************************************************************/
182     /*                             	Burn Token Function                     	                */
183     /********************************************************************************************/	
184 	
185 	function burn(uint256 _value) onlyOwner public {
186         require(_value <= balances[msg.sender]);
187         
188         address burner = msg.sender;
189         balances[burner] = balances[burner].sub(_value);
190         totalSupply = totalSupply.sub(_value);
191         totalDistributed = totalDistributed.sub(_value);
192         emit Burn(burner, _value);
193     }
194 	
195 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
196         require(_value <= balances[_burner]);
197         
198         balances[_burner] = balances[_burner].sub(_value);
199         totalSupply = totalSupply.sub(_value);
200         totalDistributed = totalDistributed.sub(_value);
201         emit Burn(_burner, _value);
202     }
203 }