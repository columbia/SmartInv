1 /*! Smartcontract Token | (c) 2018 BelovITLab LLC | License: MIT */
2 //
3 //                                     _
4 //                                _.-~~.)              SMARTCONTRACT.RU
5 //          _.--~~~~~---....__  .' . .,'          
6 //        ,'. . . . . . . . . .~- ._ (                 Development smart-contracts
7 //       ( .. .g. . . . . . . . . . .~-._              Investor's office for ICO
8 //    .~__.-~    ~`. . . . . . . . . . . -.
9 //    `----..._      ~-=~~-. . . . . . . . ~-.         Telegram: https://goo.gl/FRP4nz    
10 //              ~-._   `-._ ~=_~~--. . . . . .~.
11 //               | .~-.._  ~--._-.    ~-. . . . ~-.
12 //                \ .(   ~~--.._~'       `. . . . .~-.                ,
13 //                 `._\         ~~--.._    `. . . . . ~-.    .- .   ,'/
14 // _  . _ . -~\        _ ..  _          ~~--.`_. . . . . ~-_     ,-','`  .
15 //              ` ._           ~                ~--. . . . .~=.-'. /. `
16 //        - . -~            -. _ . - ~ - _   - ~     ~--..__~ _,. /   \  - ~
17 //               . __ ..                   ~-               ~~_. (  `
18 // )`. _ _               `-       ..  - .    . - ~ ~ .    \    ~-` ` `  `. _
19 //                                                     - .  `  .   \  \ `.
20 
21 
22 pragma solidity 0.4.18;
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
26         if(a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns(uint256) {
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns(uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract Ownable {
52     address public owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     modifier onlyOwner() { require(msg.sender == owner); _; }
57 
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     function transferOwnership(address newOwner) public onlyOwner {
63         require(newOwner != address(0));
64         owner = newOwner;
65         OwnershipTransferred(owner, newOwner);
66     }
67 }
68 
69 contract Pausable is Ownable {
70     bool public paused = false;
71 
72     event Pause();
73     event Unpause();
74 
75     modifier whenNotPaused() { require(!paused); _; }
76     modifier whenPaused() { require(paused); _; }
77 
78     function pause() onlyOwner whenNotPaused public {
79         paused = true;
80         Pause();
81     }
82 
83     function unpause() onlyOwner whenPaused public {
84         paused = false;
85         Unpause();
86     }
87 }
88 
89 contract ERC20 {
90     uint256 public totalSupply;
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 
95     function balanceOf(address who) public view returns(uint256);
96     function transfer(address to, uint256 value) public returns(bool);
97     function transferFrom(address from, address to, uint256 value) public returns(bool);
98     function allowance(address owner, address spender) public view returns(uint256);
99     function approve(address spender, uint256 value) public returns(bool);
100 }
101 
102 contract StandardToken is ERC20 {
103     using SafeMath for uint256;
104 
105     string public name;
106     string public symbol;
107     uint8 public decimals;
108 
109     mapping(address => uint256) balances;
110     mapping (address => mapping (address => uint256)) internal allowed;
111 
112     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
113         name = _name;
114         symbol = _symbol;
115         decimals = _decimals;
116     }
117 
118     function balanceOf(address _owner) public view returns(uint256 balance) {
119         return balances[_owner];
120     }
121 
122     function transfer(address _to, uint256 _value) public returns(bool) {
123         require(_to != address(0));
124         require(_value <= balances[msg.sender]);
125 
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128 
129         Transfer(msg.sender, _to, _value);
130 
131         return true;
132     }
133     
134     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
135         require(_to.length == _value.length);
136 
137         for(uint i = 0; i < _to.length; i++) {
138             transfer(_to[i], _value[i]);
139         }
140 
141         return true;
142     }
143 
144     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
145         require(_to != address(0));
146         require(_value <= balances[_from]);
147         require(_value <= allowed[_from][msg.sender]);
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152 
153         Transfer(_from, _to, _value);
154 
155         return true;
156     }
157 
158     function allowance(address _owner, address _spender) public view returns(uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     function approve(address _spender, uint256 _value) public returns(bool) {
163         allowed[msg.sender][_spender] = _value;
164 
165         Approval(msg.sender, _spender, _value);
166 
167         return true;
168     }
169 
170     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
171         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172 
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174 
175         return true;
176     }
177 
178     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
179         uint oldValue = allowed[msg.sender][_spender];
180 
181         if(_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         } else {
184             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185         }
186 
187         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188 
189         return true;
190     }
191 }
192 
193 contract MintableToken is StandardToken, Ownable {
194     event Mint(address indexed to, uint256 amount);
195     event MintFinished();
196 
197     bool public mintingFinished = false;
198 
199     modifier canMint() { require(!mintingFinished); _; }
200     modifier notMint() { require(mintingFinished); _; }
201 
202     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
203         totalSupply = totalSupply.add(_amount);
204         balances[_to] = balances[_to].add(_amount);
205 
206         Mint(_to, _amount);
207         Transfer(address(0), _to, _amount);
208 
209         return true;
210     }
211 
212     function finishMinting() onlyOwner canMint public returns(bool) {
213         mintingFinished = true;
214 
215         MintFinished();
216 
217         return true;
218     }
219 }
220 
221 contract CappedToken is MintableToken {
222     uint256 public cap;
223 
224     function CappedToken(uint256 _cap) public {
225         require(_cap > 0);
226         cap = _cap;
227     }
228 
229     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
230         require(totalSupply.add(_amount) <= cap);
231 
232         return super.mint(_to, _amount);
233     }
234 }
235 
236 contract BurnableToken is StandardToken {
237     event Burn(address indexed burner, uint256 value);
238 
239     function burn(uint256 _value) public {
240         require(_value <= balances[msg.sender]);
241 
242         address burner = msg.sender;
243 
244         balances[burner] = balances[burner].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246 
247         Burn(burner, _value);
248     }
249 }
250 
251 /* This is your discount for development smartcontract 5% */
252 /* For order smart-contract please contact at Telegram: https://t.me/joinchat/Bft2vxACXWjuxw8jH15G6w */
253 
254 /* We develop inverstor's office for ICO, operator's dashboard for ICO, Token Air Drop  */
255 /* info@smartcontract.ru */
256 
257 contract Token is CappedToken, BurnableToken {
258 
259     string public URL = "http://smartcontract.ru";
260 
261     function Token() CappedToken(100000000 * 1 ether) StandardToken("SMARTCONTRACT.RU", "SMART", 18) public {
262         
263     }
264     
265     function transfer(address _to, uint256 _value) public returns(bool) {
266         return super.transfer(_to, _value);
267     }
268     
269     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
270         return super.multiTransfer(_to, _value);
271     }
272 
273     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
274         return super.transferFrom(_from, _to, _value);
275     }
276 }