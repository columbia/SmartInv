1 pragma solidity ^ 0.4.24;
2 library SafeMath {
3 
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30   
31 }
32 
33 contract ERC20Interface {
34 	function totalSupply() public constant returns(uint);
35 
36 	function balanceOf(address tokenOwner) public constant returns(uint balance);
37 
38 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
39 
40 	function transfer(address to, uint tokens) public returns(bool success);
41 
42 	function approve(address spender, uint tokens) public returns(bool success);
43 
44 	function transferFrom(address from, address to, uint tokens) public returns(bool success);
45 
46 	event Transfer(address indexed from, address indexed to, uint tokens);
47 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 contract Owned {
51 	address public owner;
52 	address public newOwner;
53 
54 	event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56 	constructor() public {
57 		owner = msg.sender;
58 	}
59 
60 	modifier onlyOwner {
61 		require(msg.sender == owner);
62 		_;
63 	}
64 
65 	function transferOwnership(address _newOwner) public onlyOwner {
66 	    require(_newOwner!=address(0)&&_newOwner!=owner);
67 		newOwner = _newOwner;
68 	}
69 
70 	function acceptOwnership() public {
71 		require(msg.sender == newOwner);
72 		emit OwnershipTransferred(owner, newOwner);
73 		owner = newOwner;
74 		newOwner = address(0);
75 	}
76 }
77 
78 
79 contract StandardToken is ERC20Interface,Owned {
80 	
81 	using SafeMath for uint256;
82 	mapping(address => bool) public registered;
83 	mapping(address => uint) public credit;
84 	mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     
87     uint256 public totalSupply;
88     
89 		modifier  onlyRegistered {
90 			require(registered[msg.sender]);
91 			_;
92 		}
93 	
94     function totalSupply() public view returns(uint) {
95 		return totalSupply;
96 	}
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         if (balances[msg.sender] >= _value && _value > 0) {
99             balances[msg.sender] -= _value;
100             balances[_to] += _value;
101             emit Transfer(msg.sender, _to, _value);
102             return true;
103         } else { return false; }
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107 
108         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
109             balances[_to] += _value;
110             balances[_from] -= _value;
111             allowed[_from][msg.sender] -= _value;
112             emit Transfer(_from, _to, _value);
113             return true;
114         } else { return false; }
115     }
116 
117     function balanceOf(address _owner) constant public returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
128       return allowed[_owner][_spender];
129     }
130 
131 
132     /*
133     *注册合约
134     */
135     function registerToken(address _token,uint _tokens) public onlyOwner returns(bool){
136     	require(!registered[_token] && _tokens<totalSupply);
137     	require(balances[this] > _tokens);
138 			registered[_token] = true;
139 			credit[_token] = _tokens;
140 			balances[this] = balances[this].sub(_tokens);
141 			emit Transfer(this,_token,_tokens);
142 			return(true);
143 		}
144 		/*
145 		*注销合约
146 		*/
147 		function unregister(address _token) public onlyOwner returns(uint){
148 			require(registered[_token]);
149 			uint amount = credit[_token];
150 			registered[_token] = false;
151 			if(amount>0){
152     			balances[this] = balances[this].add(amount);
153     			credit[_token] = uint(0);
154     			emit Transfer(_token,this,amount);
155 			}
156 			return(amount);
157 		}
158 	
159 		/*
160 		*申请转币
161 		*/
162 		function tokenAdd(address _user,uint _tokens) public onlyRegistered returns(bool){
163 			require(_tokens>0 && credit[msg.sender]>= _tokens);
164 			balances[_user] = balances[_user].add(_tokens);
165 			credit[msg.sender] = credit[msg.sender].sub(_tokens);
166 			emit Transfer(msg.sender,_user,_tokens);	
167 			return(true);
168 		}
169 		/*
170 		*申请减币
171 		*/
172 		function tokenSub(address _user,uint _tokens) public onlyRegistered returns(bool){
173 			require(_tokens>0);
174 			require(balances[_user] >= _tokens);
175 			credit[msg.sender] = credit[msg.sender].add(_tokens);
176 			balances[_user] =  balances[_user].sub(_tokens);
177 			emit Transfer(_user,msg.sender,_tokens);
178 			return(true);
179 		}
180 		
181 		/*
182 		*增加额度
183 		*/
184 		function add_credit(address _token,uint _tokens) public onlyOwner returns(bool){
185 			require(_tokens>0 && registered[_token] && _tokens < totalSupply);
186 			require(balances[this] > _tokens);
187 			credit[_token] = credit[_token].add(_tokens);
188 			balances[this] = balances[this].sub(_tokens);
189 			emit Transfer(this,_token,_tokens);
190 			return(true);
191 		}
192 }
193 
194 
195 
196 contract ETTTOKEN is StandardToken {
197 
198     function () public{
199         revert();
200     }
201 
202     string public name;                   
203     uint8 public decimals;                
204     string public symbol;                 
205     string public version = 'E0.1';       
206 
207     constructor(
208         uint256 _initialAmount,
209         string _tokenName,
210         uint8 _decimalUnits,
211         string _tokenSymbol
212         ) public {              
213         totalSupply = _initialAmount;                        
214         name = _tokenName;                                   
215         decimals = _decimalUnits;                            
216         symbol = _tokenSymbol;    
217         balances[this] = _initialAmount;
218         emit Transfer(address(0), owner, totalSupply);
219     }
220     /*
221     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
222         allowed[msg.sender][_spender] = _value;
223         emit Approval(msg.sender, _spender, _value);
224 
225         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
226         return true;
227     }
228     */
229 }