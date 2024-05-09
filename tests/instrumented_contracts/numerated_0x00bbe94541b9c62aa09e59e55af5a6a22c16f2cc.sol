1 /*! sptc.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.18;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _; }
38 
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 }
49 
50 contract Pausable is Ownable {
51     bool public paused = false;
52 
53     event Pause();
54     event Unpause();
55 
56     modifier whenNotPaused() { require(!paused); _; }
57     modifier whenPaused() { require(paused); _; }
58 
59     function pause() onlyOwner whenNotPaused public {
60         paused = true;
61         Pause();
62     }
63 
64     function unpause() onlyOwner whenPaused public {
65         paused = false;
66         Unpause();
67     }
68 }
69 
70 contract ERC20 {
71     uint256 public totalSupply;
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 
76     function balanceOf(address who) public view returns(uint256);
77     function transfer(address to, uint256 value) public returns(bool);
78     function transferFrom(address from, address to, uint256 value) public returns(bool);
79     function allowance(address owner, address spender) public view returns(uint256);
80     function approve(address spender, uint256 value) public returns(bool);
81 }
82 
83 contract StandardToken is ERC20 {
84     using SafeMath for uint256;
85 
86     mapping(address => uint256) balances;
87     mapping (address => mapping (address => uint256)) internal allowed;
88 
89     function balanceOf(address _owner) public view returns(uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function transfer(address _to, uint256 _value) public returns(bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99 
100         Transfer(msg.sender, _to, _value);
101 
102         return true;
103     }
104     
105     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
106         require(_to.length == _value.length);
107 
108         for(uint i = 0; i < _to.length; i++) {
109             transfer(_to[i], _value[i]);
110         }
111 
112         return true;
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
116         require(_to != address(0));
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123 
124         Transfer(_from, _to, _value);
125 
126         return true;
127     }
128 
129     function allowance(address _owner, address _spender) public view returns(uint256) {
130         return allowed[_owner][_spender];
131     }
132 
133     function approve(address _spender, uint256 _value) public returns(bool) {
134         allowed[msg.sender][_spender] = _value;
135 
136         Approval(msg.sender, _spender, _value);
137 
138         return true;
139     }
140 
141     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143 
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145 
146         return true;
147     }
148 
149     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
150         uint oldValue = allowed[msg.sender][_spender];
151 
152         if(_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         } else {
155             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156         }
157 
158         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159 
160         return true;
161     }
162 }
163 
164 contract MintableToken is StandardToken, Ownable {
165     event Mint(address indexed to, uint256 amount);
166     event MintFinished();
167 
168     bool public mintingFinished = false;
169 
170     modifier canMint() { require(!mintingFinished); _; }
171 
172     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
173         totalSupply = totalSupply.add(_amount);
174         balances[_to] = balances[_to].add(_amount);
175 
176         Mint(_to, _amount);
177         Transfer(address(0), _to, _amount);
178 
179         return true;
180     }
181 
182     function finishMinting() onlyOwner canMint public returns(bool) {
183         mintingFinished = true;
184 
185         MintFinished();
186 
187         return true;
188     }
189 }
190 
191 contract CappedToken is MintableToken {
192     uint256 public cap;
193 
194     function CappedToken(uint256 _cap) public {
195         require(_cap > 0);
196         cap = _cap;
197     }
198 
199     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
200         require(totalSupply.add(_amount) <= cap);
201 
202         return super.mint(_to, _amount);
203     }
204 }
205 
206 /*
207     ICO Sportcy
208 */
209 contract Token is CappedToken {
210     string public name = "SPORTCY";
211     string public symbol = "SPTC";
212     uint256 public decimals = 18;
213 
214     function Token() CappedToken(3000000000 * 1 ether) public {
215     
216     }
217 }
218 
219 contract PreICO is Pausable {
220     using SafeMath for uint;
221 
222     Token public token;
223     address public beneficiary = 0xd2F04a987C17EEd55e8AFF25CADccF3D2D2CE845;
224 
225     uint public collectedWei;
226     uint public tokensSold;
227 
228     uint public tokensForSale = 108000000 * 1 ether;
229     uint public priceTokenWei = 1 ether;
230 
231     bool public preicoClosed = false;
232 
233     event NewRate(uint256 rate);
234     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
235     event PreicoClose();
236 
237     function PreICO() public {
238         token = new Token();
239         setTokenRate(8400);
240     }
241 
242     function() payable public {
243         purchase();
244     }
245 
246     function setTokenRate(uint _value) onlyOwner public {
247         require(!preicoClosed);
248         
249         priceTokenWei = 1 ether / _value;
250 
251         NewRate(priceTokenWei);
252     }
253     
254     function purchase() whenNotPaused payable public {
255         require(!preicoClosed);
256         require(tokensSold < tokensForSale);
257         require(msg.value >= 0.001 ether);
258 
259         uint sum = msg.value;
260         uint amount = sum.mul(1 ether).div(priceTokenWei);
261         uint retSum = 0;
262         
263         if(tokensSold.add(amount) > tokensForSale) {
264             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
265             retSum = retAmount.mul(priceTokenWei).div(1 ether);
266 
267             amount = amount.sub(retAmount);
268             sum = sum.sub(retSum);
269         }
270 
271         tokensSold = tokensSold.add(amount);
272         collectedWei = collectedWei.add(sum);
273 
274         beneficiary.transfer(sum);
275         token.mint(msg.sender, amount);
276 
277         if(retSum > 0) {
278             msg.sender.transfer(retSum);
279         }
280 
281         Purchase(msg.sender, amount, sum);
282     }
283 
284     function closePreICO() onlyOwner public {
285         require(!preicoClosed);
286         
287         token.transferOwnership(beneficiary);
288 
289         preicoClosed = true;
290 
291         PreicoClose();
292     }
293 }