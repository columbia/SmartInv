1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ForeignToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract Quest is ERC20 {
68     
69     using SafeMath for uint256;
70     address public owner;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public claimer;
75 
76     string public constant name = "Quest";
77     string public constant symbol = "QST";
78     uint public constant decimals = 8;
79     
80     uint256 public maxSupply = 10000000000e8;
81     uint256 public QSTPerEth = 30000000e8;
82     uint256 public claimable = 20000e8;
83     uint256 public constant minContrib = 1 ether / 100;
84     uint256 public maxClaim = 0;
85     
86     
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     event TransferEther(address indexed _from, address indexed _to, uint256 _value);
90     event Burn(address indexed burner, uint256 value);
91     
92     
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97     
98     //mitigates the ERC20 short address attack
99     //suggested by izqui9 @ http://bit.ly/2NMMCNv
100     modifier onlyPayloadSize(uint size) {
101         assert(msg.data.length >= size + 4);
102         _;
103     }
104     
105     modifier onlyAllowedClaimer() {
106         require(claimer[msg.sender] == false);
107         _;
108     }
109     
110     constructor () public {
111         totalSupply = maxSupply;
112         owner = msg.sender;
113         balances[owner] = maxSupply;
114     }
115     
116     function transferOwnership(address _newOwner) onlyOwner public {
117         if (_newOwner != address(0)) {
118             owner = _newOwner;
119         }
120     }
121     
122     function updateTokensPerEth(uint _QSTPerEth) public onlyOwner {        
123         QSTPerEth = _QSTPerEth;
124     }
125            
126     function () public payable {
127         getQST();
128      }
129     
130     function dividend(uint256 _amount) internal view returns (uint256){
131         if(_amount >= QSTPerEth) return ((7*_amount).div(100)).add(_amount);
132         return _amount;
133     }
134     
135     function getQST() payable public {
136         if(msg.value >= minContrib){
137             address investor = msg.sender;
138             uint256 tokenAmt =  (QSTPerEth.mul(msg.value)).div(1 ether);
139             tokenAmt = dividend(tokenAmt);
140             require(balances[owner] >= tokenAmt);
141             balances[owner] = balances[owner].sub(tokenAmt);
142             balances[investor] = balances[investor].add(tokenAmt);
143             emit Transfer(this, investor, tokenAmt);    
144         }else{
145             freeClaim();
146         }
147         
148     }
149     function freeClaim() payable onlyAllowedClaimer public{
150         address investor = msg.sender;
151         require(balances[owner] >= claimable && maxClaim <= 4999);
152         claimer[investor] = true;
153         maxClaim = maxClaim.add(1);
154         balances[owner] = balances[owner].sub(claimable);
155         balances[investor] = balances[investor].add(claimable);
156         emit Transfer(this, investor, claimable);
157     }
158 
159     function balanceOf(address _owner) constant public returns (uint256) {
160         return balances[_owner];
161     }
162     
163     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
164         require(_to != address(0));
165         require(_amount <= balances[msg.sender]);
166         balances[msg.sender] = balances[msg.sender].sub(_amount);
167         balances[_to] = balances[_to].add(_amount);
168         emit Transfer(msg.sender, _to, _amount);
169         return true;
170     }
171     
172     function doDistro(address[] _addresses, uint256 _amount) public onlyOwner {        
173         for (uint i = 0; i < _addresses.length; i++) {transfer(_addresses[i], _amount);}
174     }
175     
176     function doDistroAmount(address[] addresses, uint256[] amounts) onlyOwner public {
177         require(addresses.length == amounts.length);
178         for (uint i = 0; i < addresses.length; i++) {transfer(addresses[i], amounts[i]);}
179     }
180     
181     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
182         require(_to != address(0));
183         require(_amount <= balances[_from]);
184         require(_amount <= allowed[_from][msg.sender]);
185         balances[_from] = balances[_from].sub(_amount);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
187         balances[_to] = balances[_to].add(_amount);
188         emit Transfer(_from, _to, _amount);
189         return true;
190     }
191     
192     function approve(address _spender, uint256 _value) public returns (bool success) {
193         // mitigates the ERC20 spend/approval race condition
194         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199     
200     function allowance(address _owner, address _spender) constant public returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203     
204     function transferEther(address _receiver, uint256 _amount) public onlyOwner {
205         require(_amount <= address(this).balance);
206         emit TransferEther(this, _receiver, _amount);
207         _receiver.transfer(_amount);
208     }
209     
210     function doEthDistro(address[] addresses, uint256 amount) public onlyOwner {        
211         for (uint i = 0; i < addresses.length; i++) { transferEther(addresses[i], amount);}
212     }
213     
214     function withdrawFund() onlyOwner public {
215         address thisCont = this;
216         uint256 ethBal = thisCont.balance;
217         owner.transfer(ethBal);
218     }
219     
220     function burn(uint256 _value) onlyOwner public {
221         require(_value <= balances[msg.sender]);
222         address burner = msg.sender;
223         balances[burner] = balances[burner].sub(_value);
224         totalSupply = totalSupply.sub(_value);
225         emit Burn(burner, _value);
226     }
227     
228     function getForeignTokenBalance(address tokenAddress, address who) constant public returns (uint){
229         ForeignToken t = ForeignToken(tokenAddress);
230         uint bal = t.balanceOf(who);
231         return bal;
232     }
233     
234     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
235         ForeignToken token = ForeignToken(_tokenContract);
236         uint256 amount = token.balanceOf(address(this));
237         return token.transfer(owner, amount);
238     }
239     
240      function disallowClaimer(address[] addresses) onlyOwner public {
241         for (uint i = 0; i < addresses.length; i++) {
242             claimer[addresses[i]] = true;
243         }
244     }
245 
246     function allowClaimer(address[] addresses) onlyOwner public {
247         for (uint i = 0; i < addresses.length; i++) {
248             claimer[addresses[i]] = false;
249         }
250     }
251 
252 }