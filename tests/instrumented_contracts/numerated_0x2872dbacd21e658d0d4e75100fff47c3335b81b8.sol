1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6           return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22     
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 // ERC20 Interface
31 contract ERC20 {
32     function totalSupply() public view returns (uint _totalSupply);
33     function balanceOf(address _owner) public view returns (uint balance);
34     function transfer(address _to, uint _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
36     function approve(address _spender, uint _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public view returns (uint remaining);
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 }
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45     modifier onlyOwner { require(msg.sender == owner); _; }
46     event OwnerUpdate(address _prevOwner, address _newOwner);
47 
48     function Owned() public {
49         owner = msg.sender;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         require(owner==msg.sender);
54         require(_newOwner != owner);
55         newOwner = _newOwner;
56     }
57 
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         OwnerUpdate(owner, newOwner);
61         owner = newOwner;
62         newOwner = 0x0;
63     }
64 }
65 
66 // ERC20Token
67 contract ERC20Token is ERC20 {
68     using SafeMath for uint256;
69     mapping(address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     mapping (address => mapping (address => uint256)) remainallowed;
72     mapping(address => uint256) distBalances;  
73     uint256 public totalToken; 
74      uint256 public baseStartTime; //
75      //debug value 
76      uint256 debug_totalallower;
77      uint256 debug_mondiff;
78      uint256 debug_now;
79      
80      
81 
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         if (balances[msg.sender] >= _value && _value > 0) {
84             balances[msg.sender] = balances[msg.sender].sub(_value);
85             balances[_to] = balances[_to].add(_value);
86             Transfer(msg.sender, _to, _value);
87             distBalances[_to] = distBalances[_to].add(_value);
88             return true;
89         } else {
90             return false;
91         }
92     }
93     
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96        
97         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
98             balances[_from] = balances[_from].sub(_value);
99             balances[_to] = balances[_to].add(_value);
100             //allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101   
102             
103             Transfer(_from, _to, _value);
104             return true;
105         } else {
106             return false;
107         }
108     }
109 
110     function totalSupply() public view returns (uint256) {
111         return totalToken;
112     }
113 
114     function balanceOf(address _owner) public view returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118     function approve(address _spender, uint256 _value) public returns (bool success) {
119         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
120         allowed[msg.sender][_spender] = _value;
121         remainallowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 //总的额度
126     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
127         return allowed[_owner][_spender];
128     }
129     // 剩余的额度
130 
131   function remainallowance(address _owner, address _spender) public view returns (uint256 remaining) {
132         return remainallowed[_owner][_spender];
133     }
134 }
135 
136 
137 
138 
139 
140 contract FGTToken is ERC20Token, Owned {
141 
142     string  public  name = "Food&GoodsChain";
143     string  public  symbol = "FGT";
144     uint256 public  decimals = 18;
145     uint256 public tokenDestroyed;
146       //list of distributed balance of each address to calculate restricted amount
147 
148     event Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);
149 
150     function FGTToken(string tokenName, string tokenSymbol,uint256 initialSupply) public {
151     name=tokenName;
152     symbol=tokenSymbol;
153     totalToken = initialSupply * 10 ** uint256(decimals);
154     
155     balances[msg.sender] = totalToken;
156     }
157    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158    //计算本期释放额度
159    uint256 calfreeamount=freeAmount(_from,msg.sender);
160     if(calfreeamount<_value){
161         _value=calfreeamount;
162     }
163         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
164             balances[_from] = balances[_from].sub(_value);
165             balances[_to] = balances[_to].add(_value);
166             //allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167             remainallowed[_from][msg.sender] = remainallowed[_from][msg.sender].sub(_value);
168             Transfer(_from, _to, _value);
169             return true;
170         } else {
171             return false;
172         }
173     }
174 
175     function transferAnyERC20Token(address _tokenAddress, address _recipient, uint256 _amount) public onlyOwner returns (bool success) {
176         return ERC20(_tokenAddress).transfer(_recipient, _amount);
177     }
178 
179     function burn (uint256 _burntAmount) public returns (bool success) {
180         require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
181         balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
182         totalToken = totalToken.sub(_burntAmount);
183         tokenDestroyed = tokenDestroyed.add(_burntAmount);
184         require (tokenDestroyed <= totalToken);
185         Transfer(address(this), 0x0, _burntAmount);
186         Burn(msg.sender, _burntAmount, block.timestamp);
187         return true;
188     }
189     
190    
191         
192          function setStartTime(uint _startTime) public onlyOwner {
193             require (msg.sender==owner);
194             baseStartTime = _startTime;
195         }
196          /* 增发增发代币 */
197         function  addToken(address target, uint256 mintedAmount)  public onlyOwner {
198         require(target==owner);//仅仅对账户创建者增发
199         balances[target] += mintedAmount;
200         totalToken += mintedAmount;
201         emit Transfer(0, msg.sender, mintedAmount);
202         emit Transfer(msg.sender, target, mintedAmount);
203     }
204     
205      function freeAmount(address _from,address user) public returns (uint256 amount) {
206         uint256 totalallower= allowed[_from][user] ;
207         debug_totalallower=totalallower;
208         uint256 releseamount=0;
209             //0) no restriction for founder
210             if (user == owner) {
211                 return balances[user];
212             }
213         debug_now=now;
214             //1) no free amount before base start time;
215             if (now < baseStartTime) {
216                 return 0;
217             }
218  
219             //2) calculate number of months passed since base start time;
220             uint256 monthDiff =  now.sub(baseStartTime) / (30 days);
221          debug_mondiff=monthDiff;
222             //3) 大于50个月，所有剩余额度一次释放
223             if (monthDiff > 50) {
224               releseamount=remainallowed[_from][user];
225                 return releseamount;
226             }
227  
228             //4) 到本期为止，总共允许释放额度
229             uint256 unrestricted =totalallower.div( 50).add( (totalallower.div(50)).mul( monthDiff));
230         
231             //5) 总释放额度 -已经释放额度  (已经释放额度=（总额度 - 剩余额度）)
232             if (unrestricted >remainallowed[_from][user]) {
233                 releseamount =remainallowed[_from][user];
234             } else {
235                 //本期为止总释放额度 减去 已经释放额度（总额度 - 剩余额度）
236                 releseamount = unrestricted.sub(totalallower.sub(remainallowed[_from][user]));
237             
238             }
239             if(releseamount>balanceOf(_from)){
240                 releseamount=balanceOf(_from);
241             }
242             return releseamount;
243         }
244        
245 }