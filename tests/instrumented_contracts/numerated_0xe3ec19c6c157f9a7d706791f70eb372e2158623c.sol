1 pragma solidity ^0.4.18;
2 // адрес теста https://ropsten.etherscan.io/token/0x1fcbe22ce0c2d211c51866966152a70490dd8045?a=0x1fcbe22ce0c2d211c51866966152a70490dd8045
3 contract owned {
4 
5     address public owner;
6     address public candidat;
7    event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function owned() public payable {
10         owner = msg.sender;
11     }
12     
13     function changeOwner(address _owner) public {
14         require(owner == msg.sender);
15         candidat = _owner;
16     }
17     function confirmOwner() public {
18         require(candidat == msg.sender);
19         emit OwnershipTransferred(owner,candidat);
20         owner = candidat;
21         candidat = address(0);
22     }
23 }
24  
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66  
67 contract ERC20Interface {
68     //function totalSupply() public constant returns (uint);
69     //function balanceOf(address tokenOwner) public constant returns (uint balance);
70     //function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
71     uint256 public totalSupply;
72     mapping (address => uint256) public balanceOf;
73     mapping (address => mapping (address => uint)) public allowance;
74     function transfer(address to, uint tokens) public returns (bool success);
75     function approve(address spender, uint tokens) public returns (bool success);
76     function transferFrom(address from, address to, uint tokens) public returns (bool success);
77 
78 
79     event Transfer(address indexed from, address indexed to, uint tokens);
80     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
81 }
82 
83 contract Cryptoloans is ERC20Interface, owned {
84     using SafeMath for uint256;
85     //uint256 public totalSupply;
86     //mapping (address => uint256) public balanceOf;
87     //mapping (address => mapping (address => uint)) public allowance;
88 
89     //function allowance(address _owner, address _spender) public constant returns (uint remaining) {
90     //    require(state != State.Disabled);
91     //    return allowance[_owner][_spender];
92     //}
93 
94     //string  public standard    = 'Token 0.1';
95     string  public name        = 'Cryptoloans';
96     string  public symbol      = "LCN";
97     uint8   public decimals    = 18;
98     uint256 public tokensPerOneEther = 300;
99     uint    public min_tokens = 30;
100 
101     // Fix for the ERC20 short address attack
102     modifier onlyPayloadSize(uint size) {
103         require(msg.data.length >= size + 4);
104         _;
105     }
106     
107     enum State { Disabled, TokenSale, Failed, Enabled }
108     State   public state = State.Disabled;
109     
110     modifier inState(State _state) {
111         require(state == _state);
112         _;
113     }    
114 
115     event NewState(State state);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed owner, address indexed spender, uint value);
118 
119     function Cryptoloans() public payable owned() {
120         totalSupply = 10000000 * 10**uint(decimals);
121         balanceOf[this] = 540000 * 10**uint(decimals);
122         balanceOf[owner] = totalSupply - balanceOf[this];
123         emit Transfer(address(0), this, totalSupply);
124         emit Transfer(this, owner, balanceOf[owner]);
125     }
126 
127     function () public payable {
128         require(state==State.TokenSale);
129         require(balanceOf[this] > 0);
130         uint256 tokens = tokensPerOneEther.mul(msg.value);//.div(1 ether);
131         require(min_tokens.mul(10**uint(decimals))<=tokens || tokens > balanceOf[this]);
132         if (tokens > balanceOf[this]) {
133             tokens = balanceOf[this];
134             uint256 valueWei = tokens.div(tokensPerOneEther);
135             msg.sender.transfer(msg.value - valueWei);
136         }
137         require(tokens > 0);
138         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
139         balanceOf[this] = balanceOf[this].sub(tokens);
140         emit Transfer(this, msg.sender, tokens);
141     }
142 
143 	function _transfer(address _from, address _to, uint _value) internal
144 	{
145         require(state != State.Disabled);
146         require(balanceOf[_from] >= _value);
147         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
148         balanceOf[_from] -= _value;
149         balanceOf[_to] += _value;
150         emit Transfer(_from, _to, _value);
151 	}
152 	
153 	
154     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool success){
155 		_transfer(msg.sender,_to,_value);
156         return true;
157     }
158 
159     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32)  returns(bool success){
160         require(state != State.Disabled);
161 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
162         allowance[_from][msg.sender] -= _value;
163         _transfer(_from, _to, _value);
164         return true;
165     }
166 
167     function approve(address _spender, uint _value) public  returns(bool success){
168         require(state != State.Disabled);
169         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
170         allowance[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175 
176 
177     function withdrawBack() public { // failed tokensale
178         require(state == State.Failed);
179         require(balanceOf[msg.sender]>0);
180         uint256 amount = balanceOf[msg.sender].div(tokensPerOneEther);// ethers wei
181         uint256 balance_sender = balanceOf[msg.sender];
182         
183         require(address(this).balance>=amount && amount > 0);
184         balanceOf[this] = balanceOf[this].add(balance_sender);
185         balanceOf[msg.sender] = 0;
186         emit Transfer(msg.sender, this,  balance_sender);
187         msg.sender.transfer(amount);
188     }
189     
190     // ------------------------------------------------------------------------
191     // Owner can transfer out any accidentally sent ERC20 tokens
192     // ------------------------------------------------------------------------
193     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
194         require(msg.sender==owner);
195         return ERC20Interface(tokenAddress).transfer(owner, tokens);
196     }
197 
198     
199     function killMe() public {
200         require(owner == msg.sender);
201         selfdestruct(owner);
202     }
203     
204     function startTokensSale(uint _volume_tokens, uint token_by_ether, uint min_in_token) public {
205         require(owner == msg.sender);
206         //require(state == State.Disabled);
207         require((_volume_tokens * 10**uint(decimals))<(balanceOf[owner]+balanceOf[this]));
208         tokensPerOneEther = token_by_ether;
209         min_tokens = min_in_token;
210         
211         //if(balanceOf[this]>0)
212         if(balanceOf[this]>(_volume_tokens * 10**uint(decimals)))
213             emit Transfer(this, owner, balanceOf[this]-(_volume_tokens * 10**uint(decimals)));
214         else if(balanceOf[this]<(_volume_tokens * 10**uint(decimals)))
215             emit Transfer(owner, this, (_volume_tokens * 10**uint(decimals)) - balanceOf[this]);
216 
217         balanceOf[owner] = balanceOf[owner].add(balanceOf[this]).sub(_volume_tokens * 10**uint(decimals));
218         balanceOf[this] = _volume_tokens * 10**uint(decimals);
219         
220         if (state != State.TokenSale)
221         {
222             state = State.TokenSale;
223             emit NewState(state);
224         }
225     }
226     
227 
228     function SetState(uint _state) public 
229     {
230         require(owner == msg.sender);
231         State old = state;
232         //require(state!=_state);
233         if(_state==0)
234             state = State.Disabled;
235         else if(_state==1) 
236             state = State.TokenSale;
237         else if(_state==2) 
238             state = State.Failed;
239         else if(_state==3) 
240             state = State.Enabled;
241         if(old!=state)
242             emit NewState(state);
243     }
244     
245 
246     function withdraw() public {
247         require(owner == msg.sender);
248         owner.transfer(address(this).balance);
249     }
250 
251 }