1 pragma solidity >= 0.5.4 ;
2 
3 library SafeMath {
4     
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17   
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19        
20         require(b > 0);
21         uint256 c = a / b;
22 
23         return c;
24     }
25 
26     
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a);
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38 
39         return c;
40     }
41 
42     
43     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b != 0);
45         return a % b;
46     }
47 }
48 
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
51 
52 
53 contract Ownable {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     
59     constructor () internal {
60         _owner = msg.sender;
61         emit OwnershipTransferred(address(0), _owner);
62     }
63 
64     
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     
70     modifier onlyOwner() {
71         require(isOwner());
72         _;
73     }
74 
75     
76     function isOwner() public view returns (bool) {
77         return msg.sender == _owner;
78     }
79 
80    
81     function renounceOwnership() public onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86    
87     function transferOwnership(address newOwner) public onlyOwner {
88         _transferOwnership(newOwner);
89     }
90 
91    
92     function _transferOwnership(address newOwner) internal {
93         require(newOwner != address(0));
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 
101 contract Pausable is Ownable{
102     event Paused(address account);
103     event Unpaused(address account);
104 
105     bool private _paused;
106 
107     constructor () internal {
108         _paused = false;
109     }
110 
111     
112     function paused() public view returns (bool) {
113         return _paused;
114     }
115 
116     
117     modifier whenNotPaused() {
118         require(!_paused);
119         _;
120     }
121 
122    
123     modifier whenPaused() {
124         require(_paused);
125         _;
126     }
127 
128     
129     function pause() public onlyOwner whenNotPaused {
130         _paused = true;
131         emit Paused(msg.sender);
132     }
133 
134     
135     function unpause() public onlyOwner whenPaused {
136         _paused = false;
137         emit Unpaused(msg.sender);
138     }
139 }
140 
141 
142 contract TokenERC20{
143     using SafeMath for uint256;
144 
145     string public name;
146     string public symbol;
147     uint8 public decimals = 18;
148     uint256 public totalSupply;
149 
150     mapping (address => uint256) public balanceOf;
151     mapping (address => mapping (address => uint256)) public allowance;
152 
153     event Transfer(address indexed from, address indexed to, uint256 value);
154     
155     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
156 
157     event Burn(address indexed from, uint256 value);
158 
159     
160     constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
161         totalSupply = initialSupply * 10 ** uint256(decimals);  
162         balanceOf[msg.sender] = totalSupply;                
163         name = tokenName;                                  
164         symbol = tokenSymbol;                              
165     }
166 
167     
168     function _transfer(address _from, address _to, uint _value) internal {
169         require(_to != address(0x0));
170 
171         balanceOf[_from] = balanceOf[_from].sub(_value);
172         balanceOf[_to] = balanceOf[_to].add(_value);
173 
174         emit Transfer(_from, _to, _value);
175     }
176 
177     
178     function transfer(address _to, uint256 _value) public returns (bool success) {
179         _transfer(msg.sender, _to, _value);
180         return true;
181     }
182 
183    
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
185         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
186         _transfer(_from, _to, _value);
187         return true;
188     }
189 
190    
191     function approve(address _spender, uint256 _value) public
192         returns (bool success) {
193         allowance[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 
198    
199     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
200         public
201         returns (bool success) {
202         tokenRecipient spender = tokenRecipient(_spender);
203         if (approve(_spender, _value)) {
204             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
205             return true;
206         }
207     }
208 
209    
210     function burn(uint256 _value) public returns (bool success) {
211         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);             
212         totalSupply = totalSupply.sub(_value);                                 
213         emit Burn(msg.sender, _value);
214         return true;
215     }
216 
217     
218     function burnFrom(address _from, uint256 _value) public returns (bool success) {
219         balanceOf[_from] = balanceOf[_from].sub(_value);                                        
220         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);                
221         totalSupply = totalSupply.sub(_value);                                                  
222         emit Burn(_from, _value);
223         return true;
224     }
225 
226 }
227 
228 
229 contract DOCToken is TokenERC20, Ownable,Pausable{
230 
231     mapping (address => bool) public frozenAccount;
232 
233     event FrozenFunds(address target, bool frozen);
234 
235     constructor() TokenERC20(200000000,"DOCToken","DOC") public {
236     }
237 
238     function freezeAccount(address account, bool freeze) onlyOwner public {
239         frozenAccount[account] = freeze;
240         emit FrozenFunds(account, freeze);
241     }
242 
243     function changeName(string memory newName) public onlyOwner {
244         name = newName;
245     }
246 
247     function changeSymbol(string memory newSymbol) public onlyOwner{
248         symbol = newSymbol;
249     }
250 
251     
252     function _transfer(address _from, address _to, uint _value) internal whenNotPaused {
253         require(_to != address(0x0));
254 
255         require(!frozenAccount[_from]);
256         require(!frozenAccount[_to]);
257 
258         balanceOf[_from] = balanceOf[_from].sub(_value);
259         balanceOf[_to] = balanceOf[_to].add(_value);
260 
261         emit Transfer(_from, _to, _value);
262     }
263 }