1 pragma solidity 0.4.24;
2 
3 /**
4  * SafeMath
5  * */
6 library SafeMath {
7 
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17    
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19        
20         uint256 c = a / b;
21        
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30    
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 /**
39  *ERC20Basic
40  */
41 contract ERC20Basic {
42     function totalSupply() public view returns (uint256);
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 /**
50  ERC20 interface
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 /**
61  * Basic token
62  *
63  */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68 
69     uint256 public totalSupply_;
70 
71   
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76   
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(msg.data.length>=(2*32)+4);
79         require(_to != address(0));
80         require(_value <= balances[msg.sender]);
81 
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         emit Transfer (msg.sender, _to, _value);
85         return true;
86     }
87 
88    
89     function balanceOf(address _owner) public view returns (uint256 balance) {
90         return balances[_owner];
91     }
92 }
93 
94 /**
95  Standard ERC20 token
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99     mapping (address => mapping (address => uint256)) internal allowed;
100 
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102         require(_to != address(0));
103         require(_value <= balances[_from]);
104         require(_value <= allowed[_from][msg.sender]);
105 
106         balances[_from] = balances[_from].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109         emit Transfer(_from, _to, _value);
110         return true;
111     }
112 
113    
114     function approve(address _spender, uint256 _value) public returns (bool) {
115         require(_value==0||allowed[msg.sender][_spender]==0);
116         require(msg.data.length>=(2*32)+4);
117         allowed[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     
123     function allowance(address _owner, address _spender) public view returns (uint256) {
124         return allowed[_owner][_spender];
125     }
126 
127   
128     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131         return true;
132     }
133 
134    
135     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136         uint oldValue = allowed[msg.sender][_spender];
137         if (_subtractedValue > oldValue) {
138             allowed[msg.sender][_spender] = 0;
139         } else {
140             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141         }
142         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145 }
146 
147 contract OpenDAOToken is StandardToken {
148     string public name;
149     string public symbol;
150     uint8 public decimals;
151     uint256 public precentDecimal=2;
152     
153     // miner and developer percent
154     uint256 public minerAndDeveloperPercent=70;
155     
156     //open dao fund percent
157     uint256 public openDaoFundPercent=10;
158     
159     //codecoin core team percent
160     uint256 public codeCoinCoreTeamPercent=10;
161     
162     //cloudmine precent
163     uint256 public mineralcloudFundPercent=10;
164      
165     
166     // miner and developer Account
167     address public minerAndDeveloperFundAccount;
168     
169     //open dao fund Account
170     address public openDaoFundAccount;
171     
172     //codecoin core team Account
173     address public codeCoinCoreTeamAccount;
174     
175     //cloudmine Account
176     address public mineralcloudFundAccount;
177     
178     
179     // miner and developer fund Balnace
180     uint256 public minerAndDeveloperFundBalnace;
181     
182     //open dao fund Balnace
183     uint256 public openDaoFundBalnace;
184     
185     //codecoin core team Balnace
186     uint256 public codeCoinCoreTeamBalnace;
187     
188     //cloudmine Balnace
189     uint256 public mineralcloudFundBalnace;
190 
191 
192     //OpenDAOToken constructor
193     constructor(string _name,string _symbol, uint8 _decimals, uint256 _initialSupply,
194         address _minerAndDeveloperFundAccount,address _openDaoFundAccount,address _codeCoinCoreTeamAccount,address _mineralcloudFundAccount) public {
195         //init name,symbol,decimal,totalSupply
196         name = _name;
197         symbol = _symbol;
198         decimals = _decimals;
199         totalSupply_ = _initialSupply*10**uint256(_decimals);
200         
201         //init account
202         minerAndDeveloperFundAccount=_minerAndDeveloperFundAccount;
203         openDaoFundAccount=_openDaoFundAccount;
204         codeCoinCoreTeamAccount=_codeCoinCoreTeamAccount;
205         mineralcloudFundAccount=_mineralcloudFundAccount;
206         
207 
208         //compute balance
209         minerAndDeveloperFundBalnace=totalSupply_.mul(minerAndDeveloperPercent).div(10 ** precentDecimal);
210         openDaoFundBalnace=totalSupply_.mul(openDaoFundPercent).div(10 ** precentDecimal);
211         codeCoinCoreTeamBalnace=totalSupply_.mul(codeCoinCoreTeamPercent).div(10 ** precentDecimal);
212         mineralcloudFundBalnace=totalSupply_.mul(mineralcloudFundPercent).div(10 ** precentDecimal);
213     
214     
215         //evaluate balanace for account
216         balances[_minerAndDeveloperFundAccount]=minerAndDeveloperFundBalnace;
217         balances[_openDaoFundAccount]=openDaoFundBalnace;
218         balances[_codeCoinCoreTeamAccount]=codeCoinCoreTeamBalnace;
219         balances[_mineralcloudFundAccount]=mineralcloudFundBalnace;
220         
221     }
222     
223     
224     function transfer(address _to, uint256 _value) public returns (bool) {
225        return super.transfer(_to, _value);
226     } 
227     
228    
229     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230         return super.transferFrom(_from, _to, _value);
231     }
232      
233      function() public payable{
234          revert();
235      }
236 }