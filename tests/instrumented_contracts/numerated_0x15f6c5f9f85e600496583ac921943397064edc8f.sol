1 /*
2 ****************************
3 ****************************
4 Quest token contract
5 ****************************
6 ****************************
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title SafeMath
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract ForeignToken {
57     function balanceOf(address _owner) constant public returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract Quest is ERC20 {
76     
77     using SafeMath for uint256;
78     address public owner;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;    
82 
83     string public constant name = "QUEST";
84     string public constant symbol = "QST";
85     uint public constant decimals = 8;
86     
87     uint256 public maxSupply = 10000000000e8;
88     uint256 public constant minContrib = 1 ether / 100;
89     uint256 public QSTPerEth = 30000000e8;
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93     event Burn(address indexed burner, uint256 value);
94     constructor () public {
95         totalSupply = maxSupply;
96         balances[msg.sender] = maxSupply;
97         owner = msg.sender;
98     }
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103     
104     function transferOwnership(address _newOwner) onlyOwner public {
105         if (_newOwner != address(0)) {
106             owner = _newOwner;
107         }
108     }
109     
110     function updateTokensPerEth(uint _QSTPerEth) public onlyOwner {        
111         QSTPerEth = _QSTPerEth;
112     }
113            
114     function () public payable {
115         buyQST();
116      }
117     
118     function dividend(uint256 _amount) internal view returns (uint256){
119         if(_amount >= QSTPerEth) return ((7*_amount).div(100)).add(_amount);
120         return _amount;
121     }
122     
123     function buyQST() payable public {
124         address investor = msg.sender;
125         uint256 tokenAmt =  QSTPerEth.mul(msg.value) / 1 ether;
126         require(msg.value >= minContrib && msg.value > 0);
127         tokenAmt = dividend(tokenAmt);
128         require(balances[owner] >= tokenAmt);
129         balances[owner] -= tokenAmt;
130         balances[investor] += tokenAmt;
131         emit Transfer(this, investor, tokenAmt);   
132     }
133 
134     function balanceOf(address _owner) constant public returns (uint256) {
135         return balances[_owner];
136     }
137 
138     //mitigates the ERC20 short address attack
139     //suggested by izqui9 @ http://bit.ly/2NMMCNv
140     modifier onlyPayloadSize(uint size) {
141         assert(msg.data.length >= size + 4);
142         _;
143     }
144     
145     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
146         require(_to != address(0));
147         require(_amount <= balances[msg.sender]);
148         balances[msg.sender] = balances[msg.sender].sub(_amount);
149         balances[_to] = balances[_to].add(_amount);
150         emit Transfer(msg.sender, _to, _amount);
151         return true;
152     }
153     
154     function doDistro(address[] _addresses, uint256 _amount) public onlyOwner {        
155         for (uint i = 0; i < _addresses.length; i++) {transfer(_addresses[i], _amount);}
156     }
157     
158     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
159         require(_to != address(0));
160         require(_amount <= balances[_from]);
161         require(_amount <= allowed[_from][msg.sender]);
162         balances[_from] = balances[_from].sub(_amount);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         emit Transfer(_from, _to, _amount);
166         return true;
167     }
168     
169     function approve(address _spender, uint256 _value) public returns (bool success) {
170         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
171         allowed[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175     
176     function allowance(address _owner, address _spender) constant public returns (uint256) {
177         return allowed[_owner][_spender];
178     }
179     
180     function getForeignTokenBalance(address tokenAddress, address who) constant public returns (uint){
181         ForeignToken t = ForeignToken(tokenAddress);
182         uint bal = t.balanceOf(who);
183         return bal;
184     }
185     
186     function withdrawFund() onlyOwner public {
187         address thisCont = this;
188         uint256 ethBal = thisCont.balance;
189         owner.transfer(ethBal);
190     }
191     
192     function burn(uint256 _value) onlyOwner public {
193         require(_value <= balances[msg.sender]);
194         address burner = msg.sender;
195         balances[burner] = balances[burner].sub(_value);
196         totalSupply = totalSupply.sub(_value);
197         emit Burn(burner, _value);
198     }
199     
200     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
201         ForeignToken token = ForeignToken(_tokenContract);
202         uint256 amount = token.balanceOf(address(this));
203         return token.transfer(owner, amount);
204     }
205 }