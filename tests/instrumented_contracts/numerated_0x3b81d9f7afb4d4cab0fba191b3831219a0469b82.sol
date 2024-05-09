1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6         return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a / b;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 interface tokenRecipient { 
27     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
28 }
29 
30 contract Base {
31     using SafeMath for uint256;
32 
33     uint public createDay;
34     
35     address public owner;
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function setOwner(address _newOwner)  external  onlyOwner {
43         require(_newOwner != address(0x0));
44         owner = _newOwner;
45     }
46 
47     address public admin;
48 
49     modifier onlyAdmin {
50         require(msg.sender == admin);
51         _;
52     }
53 
54     function setAdmin(address _newAdmin)  external  onlyAdmin {
55         require(_newAdmin != address(0x0));
56         admin = _newAdmin;
57     }
58     
59     mapping(address => bool) public blacklistOf;   
60 
61     function addBlacklist(address _Addr) external onlyAdmin {
62         require (_Addr != address(0x0));  
63         blacklistOf[_Addr] = true;
64     }  
65 
66     function delBlacklist(address _Addr) external onlyAdmin {
67         require (_Addr != address(0x0));  
68         blacklistOf[_Addr] = false;
69     }
70     
71     function isBlacklist(address _Addr) public view returns(bool _result) {  
72         require (_Addr != address(0x0));  
73         _result = (now <  (createDay + 90 days) * (1 days)) && blacklistOf[_Addr];
74     }
75 
76 }
77 
78 contract TokenERC20 is Base {
79     string public name;
80     string public symbol;
81     uint8 public decimals = 18;
82     uint256 public totalSupply;
83 
84     mapping (address => uint256) public balanceOf;
85     mapping (address => mapping (address => uint256)) public allowance;
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     event Burn(address indexed from, uint256 value);
90 
91 
92     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
93         require(_to != address(0x0));
94         require(!isBlacklist(_from));
95         require(!isBlacklist(_to));
96         require(balanceOf[_from] >= _value);
97         balanceOf[_from] = balanceOf[_from].sub(_value);
98         balanceOf[_to] = balanceOf[_to].add(_value);
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         _transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);                    // Check allowance
110         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     function approve(address _spender, uint256 _value) public returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) 
122     {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
126             return true;
127         }
128     }
129 
130     function burn(uint256 _value) public returns (bool success) {
131         require(balanceOf[msg.sender] >= _value);                          
132         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);         
133         totalSupply = totalSupply.sub(_value);                             
134         emit Burn(msg.sender, _value);
135         return true;
136     }
137 
138     function burnFrom(address _from, uint256 _value) public returns (bool success) {
139         require(1 == 2);
140         emit Burn(_from, _value);
141         return true;
142     }
143 }
144 
145 
146 contract TokenBNH is TokenERC20 {
147     
148     function TokenBNH(address _owner, address _admin) public {
149  
150         require(_owner != address(0x0));
151         require(_admin != address(0x0));
152         owner = _owner;
153         admin = _admin;
154 
155         totalSupply = 1000000000 * 10 ** uint256(decimals);    
156         uint toOwner =  47500000 * 10 ** uint256(decimals);
157         uint toAdmin =   2500000 * 10 ** uint256(decimals);        
158         balanceOf[address(this)] = totalSupply - toOwner - toAdmin;               
159         balanceOf[owner] = toOwner;                            
160         balanceOf[admin] = toAdmin;                        
161         name = "BBB";                                    
162         symbol = "BBB";                                     
163         createDay = now / (1 days);
164     }
165 
166 
167     function batchTransfer1(address[] _tos, uint256 _amount) external  {
168         require(_batchTransfer1(msg.sender, _tos, _amount));
169     }
170 
171     function _batchTransfer1(address _from, address[] memory _tos, uint256 _amount) internal returns (bool _result) {
172         require(_amount > 0);
173         require(_tos.length > 0);
174         for(uint i = 0; i < _tos.length; i++){
175             address to = _tos[i];
176             require(to != address(0x0));
177             require(_transfer(_from, to, _amount));
178         }
179         _result = true;
180     }
181 
182     function batchTransfer2(address[] _tos, uint256[] _amounts) external  {
183         require(_batchTransfer2(msg.sender, _tos, _amounts));
184     }
185 
186     function _batchTransfer2(address _from, address[] memory _tos, uint256[] memory _amounts) internal returns (bool _result)  {
187         require(_amounts.length > 0);
188         require(_tos.length > 0);
189         require(_amounts.length == _tos.length );
190         for(uint i = 0; i < _tos.length; i++){
191             require(_tos[i] != address(0x0) && _amounts[i] > 0);
192             require(_transfer(_from, _tos[i], _amounts[i]));
193         }
194         _result = true;
195     }
196 
197     mapping(uint => uint) dayFillOf;    
198 
199     function getDay(uint _time) public pure returns (uint _day)
200     {
201         _day = _time.div(1 days);
202     }
203 
204     function getDayMaxAmount(uint _day) public view returns (uint _amount)
205     {
206         require(_day >= createDay);
207         uint AddDays = _day - createDay;
208         uint Power = AddDays / 200;
209         
210         _amount = 400000;
211         _amount = _amount.mul(10 ** uint(decimals));      
212         for(uint i = 0; i < Power; i++)
213         {
214             require(_amount > 0);
215             _amount = _amount * 9 / 10;
216         }
217     }
218 
219     function getDayIssueAvaAmount(uint _day) public view returns (uint _toUserAmount)
220     {
221         uint max = getDayMaxAmount(_day);
222         uint fill = dayFillOf[_day];
223         require(max >= fill);
224         _toUserAmount = (max - fill).mul(95) / 100;
225     }
226     
227     event OnIssue1(uint indexed _day, address[]  _tos, uint256 _amount, address _sender);
228 
229     function issue1(uint _day, address[] _tos, uint256 _amount) external onlyOwner 
230     {      
231         require(_day * (1 days) <= now);
232         require(_amount > 0);
233         uint toAdminAmountAll = 0;
234         for(uint i = 0; i < _tos.length; i++){
235             address to = _tos[i];
236             require(to != address(0x0));
237 
238             uint toAdminAmount = _amount.mul(5) / 95;
239             dayFillOf[_day] = dayFillOf[_day].add(_amount).add(toAdminAmount);
240             uint DayMaxAmount = getDayMaxAmount(_day);
241             require( dayFillOf[_day] <= DayMaxAmount);
242 
243             require(_transfer(address(this), to, _amount));
244             toAdminAmountAll = toAdminAmountAll .add(toAdminAmount);
245         }
246         require(_transfer(address(this), admin, toAdminAmountAll));
247         emit OnIssue1(_day, _tos, _amount, msg.sender);
248     }
249 
250     event OnIssue2(uint indexed _day, address[]  _tos, uint256[]  _amounts, address _sender);
251 
252     function issue2(uint _day, address[] _tos, uint256[] _amounts) external onlyOwner 
253     {
254       
255         require(_day * (1 days) <= now);
256         require(_tos.length == _amounts.length);
257         uint toAdminAmountAll = 0;
258         for(uint i = 0; i < _tos.length; i++){
259             address to = _tos[i];
260             require(to != address(0x0));
261             require(_amounts[i] > 0);
262 
263             uint toAdminAmount = _amounts[i].mul(5) / 95;
264             dayFillOf[_day] = dayFillOf[_day].add(_amounts[i]).add(toAdminAmount);
265             uint DayMaxAmount = getDayMaxAmount(_day);
266             require(dayFillOf[_day] <= DayMaxAmount);
267 
268             require(_transfer(address(this), to,  _amounts[i]));
269             toAdminAmountAll = toAdminAmountAll.add(toAdminAmount);
270         }
271         require(_transfer(address(this), admin, toAdminAmountAll));
272         emit OnIssue2(_day, _tos, _amounts, msg.sender);
273     }
274     
275     function() payable external {
276        
277     }
278 
279 }