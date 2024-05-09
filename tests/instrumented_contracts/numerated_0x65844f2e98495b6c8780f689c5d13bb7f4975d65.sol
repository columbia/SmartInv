1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29     function mint(address _to,uint256 _amount) public returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33     event Mint(address indexed to, uint256 amount);
34 }
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44   
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 interface Estate{
68     function newContracts(uint _index) external view returns(address);
69     function box_contract_amount()external view returns(uint);
70 }
71 
72 
73 interface Test{
74   function mint(address _to,uint256 _amount) external;
75   function burn(address _to,uint256 _amount) external;
76   function setName(string _name, string _symbol) external;
77   function balanceOf(address tokenOwner) external view returns (uint);
78 } 
79 
80 contract Factory is Owned{
81     
82     mapping(uint8 => mapping(uint8 => address)) public MaterialTokens;
83     address mix_address;
84     address boxFactory_address;
85     
86     function control(uint8 boxIndex, uint8 materialIndex, address _addr, uint _value) public{  
87         require(checkBox());
88         Test test = Test(MaterialTokens[boxIndex][materialIndex]); 
89         test.mint(_addr, _value); 
90     }
91     
92     function control_burn(uint8 boxIndex, uint8 materialIndex, address _addr, uint _value) public{ 
93         require(msg.sender == mix_address);
94         Test test = Test(MaterialTokens[boxIndex][materialIndex]); 
95         test.burn(_addr, _value); 
96     }
97       
98     function createContract(uint8 boxIndex, uint8 materialIndex, string _name, string _symbol) public onlyOwner{
99         address newContract = new MaterialToken(_name, _symbol);
100         
101         MaterialTokens[boxIndex][materialIndex] = newContract;
102     }  
103     
104     function controlSetName(uint8 boxIndex, uint8 materialIndex, string _name, string _symbol) public onlyOwner{
105         Test test = Test(MaterialTokens[boxIndex][materialIndex]);
106         test.setName(_name,_symbol);
107     }
108     
109     function controlSearchCount(uint8 boxIndex, uint8 materialIndex,address target)public view returns (uint) {
110          Test test = Test(MaterialTokens[boxIndex][materialIndex]);
111          return test.balanceOf(target);
112     }
113     
114     function set_mix_contract(address _mix_address) public onlyOwner{
115         mix_address = _mix_address;
116     }
117     
118     function checkBox() public view returns(bool){
119         uint length = Estate(boxFactory_address).box_contract_amount();
120         for(uint i=0;i<length;i++){
121              address box_address = Estate(boxFactory_address).newContracts(i);
122              if(msg.sender == box_address){
123                  return true;
124              }
125         }
126         return false;
127          
128     }
129     
130     function set_boxFactory_addressl(address _boxFactory_address) public onlyOwner {
131         boxFactory_address = _boxFactory_address;
132     }
133     
134 
135 }
136 
137 contract MaterialToken is ERC20Interface, Owned {
138     using SafeMath for uint;
139 
140     string public symbol;
141     string public  name;
142     uint _totalSupply;
143 
144     mapping(address => uint) balances;
145     mapping(address => mapping(address => uint)) allowed;
146     
147 
148     constructor(string _name, string _symbol) public {
149         symbol = _symbol;
150         name = _name;
151         _totalSupply = 0;
152         balances[owner] = _totalSupply;
153 
154         emit Transfer(address(0), owner, _totalSupply);
155     }
156     
157     
158     modifier onlyOwner {
159         require(msg.sender == owner);
160         _;
161     }
162     
163     function mint(address _to,uint256 _amount)public onlyOwner returns (bool) {
164         
165         _totalSupply = _totalSupply.add(_amount);
166         
167         balances[_to] = balances[_to].add(_amount);
168         
169         emit Mint(_to, _amount);
170         
171         emit Transfer(address(0), _to, _amount);
172         return true;
173     }
174     
175     function burn(address _to,uint256 _amount)public onlyOwner returns (bool)  {
176         require(balances[_to] >= _amount);
177         
178         _totalSupply = _totalSupply.sub(_amount);
179         
180         balances[_to] = balances[_to].sub(_amount);
181         
182         emit Mint(_to, _amount);
183         
184         emit Transfer(_to, address(0), _amount);
185         return true;
186     }
187    
188     
189     function setName(string _name, string _symbol)public onlyOwner{
190         symbol = _symbol;
191         name = _name;
192     }
193 
194 
195     function totalSupply() public view returns (uint) {
196         return _totalSupply.sub(balances[address(0)]);
197     }
198 
199 
200     function balanceOf(address tokenOwner) public view returns (uint balance) {
201         return balances[tokenOwner];
202     }
203 
204 
205     function transfer(address to, uint tokens) public returns (bool success) {
206         balances[msg.sender] = balances[msg.sender].sub(tokens);
207         balances[to] = balances[to].add(tokens);
208         emit Transfer(msg.sender, to, tokens);
209         return true;
210     }
211 
212 
213     function approve(address spender, uint tokens) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         emit Approval(msg.sender, spender, tokens);
216         return true;
217     }
218 
219 
220     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
221         balances[from] = balances[from].sub(tokens);
222         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
223         balances[to] = balances[to].add(tokens);
224         emit Transfer(from, to, tokens);
225         return true;
226     }
227 
228 
229     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
230         return allowed[tokenOwner][spender];
231     }
232 
233 
234     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
235         allowed[msg.sender][spender] = tokens;
236         emit Approval(msg.sender, spender, tokens);
237         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
238         return true;
239     }
240 
241 
242     function () public payable {
243         revert();
244     }
245 
246 
247     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
248         return ERC20Interface(tokenAddress).transfer(owner, tokens);
249     }
250 }