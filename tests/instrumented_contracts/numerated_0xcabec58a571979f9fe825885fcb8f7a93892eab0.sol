1 pragma solidity 0.5.7;
2 
3 
4 library SafeMath {
5     
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         
8         if (a == 0) {
9             return 0;
10         }
11 
12         uint256 c = a * b;
13         require(c / a == b);
14 
15         return c;
16     }
17 
18     
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Solidity only automatically asserts when dividing by 0
21         require(b > 0);
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 
25         return c;
26     }
27 
28     
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a);
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a);
40 
41         return c;
42     }
43 
44     
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b != 0);
47         return a % b;
48     }
49 }
50 
51 
52 
53 contract Ownable {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     
59     constructor () internal {
60         _owner;
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
100 interface IERC20 {
101     function transfer(address to, uint256 value) external returns (bool);
102 
103     function approve(address spender, uint256 value) external returns (bool);
104 
105     function transferFrom(address from, address to, uint256 value) external returns (bool);
106 
107     function totalSupply() external view returns (uint256);
108 
109     function balanceOf(address who) external view returns (uint256);
110 
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 contract ERC20 is IERC20, Ownable {
120     using SafeMath for uint256;
121 
122     mapping (address => uint256) private _balances;
123 
124     mapping (address => mapping (address => uint256)) private _allowed;
125 
126     uint256 private _totalSupply;
127     
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply;
130     }
131 
132     
133     function balanceOf(address owner) public view returns (uint256) {
134         return _balances[owner];
135     }
136 
137     
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     
149     function approve(address spender, uint256 value) public returns (bool) {
150         _approve(msg.sender, spender, value);
151         return true;
152     }
153 
154     
155     function transferFrom(address from, address to, uint256 value) public returns (bool) {
156         _transfer(from, to, value);
157         _approve(from, msg.sender, _allowed[from][msg.sender]-value);
158         return true;
159     }
160 
161     
162     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
163         _approve(msg.sender, spender, _allowed[msg.sender][spender]+addedValue);
164         return true;
165     }
166 
167     
168     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
169         _approve(msg.sender, spender, _allowed[msg.sender][spender]-subtractedValue);
170         return true;
171     }
172 
173     
174     function _transfer(address from, address to, uint256 value) internal {
175         require(to != address(0));
176 
177         _balances[from] = _balances[from]-value;
178         _balances[to] = _balances[to]+value;
179         emit Transfer(from, to, value);
180     }
181 
182     
183     function _mint(address account, uint256 value) internal {
184         require(account != address(0));
185 
186         _totalSupply = _totalSupply+value;
187         _balances[account] = _balances[account]+value;
188         emit Transfer(address(0), account, value);
189     }
190 
191    
192     function _burn(address account, uint256 value) internal {
193         require(account != address(0));
194 
195         _totalSupply = _totalSupply-value;
196         _balances[account] = _balances[account]-value;
197         emit Transfer(account, address(0), value);
198     }
199 
200    
201     function _approve(address owner, address spender, uint256 value) internal {
202         require(spender != address(0));
203         require(owner != address(0));
204 
205         _allowed[owner][spender] = value;
206         emit Approval(owner, spender, value);
207     }
208 
209    
210     function _burnFrom(address account, uint256 value) internal {
211         _burn(account, value);
212         _approve(account, msg.sender, _allowed[account][msg.sender]-value);
213     }
214 }
215 
216 /**
217  * @title Burnable Token
218  * @dev Token that can be irreversibly burned (destroyed).
219  */
220 contract ERC20Burnable is ERC20 {
221     /**
222      * @dev Burns a specific amount of tokens.
223      * @param value The amount of token to be burned.
224      */
225     function burn(uint256 value) public {
226         _burn(msg.sender, value);
227     }
228 
229     
230     function burnFrom(address from, uint256 value) public {
231         _burnFrom(from, value);
232     }
233 }
234 
235 
236 contract ERC20Mintable is ERC20 {
237     
238     function mint(address to, uint256 value) public onlyOwner returns (bool) {
239         _mint(to, value);
240         return true;
241     }
242 }
243 
244 interface tokenRecipient {
245     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
246 }
247 
248 contract UNB is ERC20Mintable, ERC20Burnable {
249     string public constant name = "United Bull Traders";
250     string public constant symbol = "UNB";
251     uint256 public constant decimals = 18;
252 
253    
254     uint256 public initialSupply = 1000000000* (10 ** decimals);
255 
256     constructor () public {
257         _mint(msg.sender, initialSupply);
258     }
259 
260     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
261         external
262         returns (bool success)
263     {
264         tokenRecipient spender = tokenRecipient(_spender);
265         if (approve(_spender, _value)) {
266             spender.receiveApproval(msg.sender, _value, _extraData);
267             return true;
268         }
269     }
270 }