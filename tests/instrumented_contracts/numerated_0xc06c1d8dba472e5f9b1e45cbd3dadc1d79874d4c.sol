1 //
2 //  Congratulations!! 
3 //  
4 //  You won a bonus token!
5 //  This token gives an additional 5% discount. 
6 //  Hurry up to participate in the tokensale prover.io    
7 //  
8 //  PROVER.IO
9 //  
10 //  ProofToken: 0x6f3a995E904c9be5279e375e79F3c30105eFa618
11 
12 
13 pragma solidity 0.4.18;
14 
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
17         if(a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a / b;
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns(uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40 }
41 
42 contract Ownable {
43     address public owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     modifier onlyOwner() { require(msg.sender == owner); _; }
48 
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != address(0));
55         owner = newOwner;
56         OwnershipTransferred(owner, newOwner);
57     }
58 }
59 
60 contract Pausable is Ownable {
61     bool public paused = false;
62 
63     event Pause();
64     event Unpause();
65 
66     modifier whenNotPaused() { require(!paused); _; }
67     modifier whenPaused() { require(paused); _; }
68 
69     function pause() onlyOwner whenNotPaused public {
70         paused = true;
71         Pause();
72     }
73 
74     function unpause() onlyOwner whenPaused public {
75         paused = false;
76         Unpause();
77     }
78 }
79 
80 contract ERC20 {
81     uint256 public totalSupply;
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 
86     function balanceOf(address who) public view returns(uint256);
87     function transfer(address to, uint256 value) public returns(bool);
88     function transferFrom(address from, address to, uint256 value) public returns(bool);
89     function allowance(address owner, address spender) public view returns(uint256);
90     function approve(address spender, uint256 value) public returns(bool);
91 }
92 
93 contract StandardToken is ERC20 {
94     using SafeMath for uint256;
95 
96     string public name;
97     string public symbol;
98     uint8 public decimals;
99 
100     mapping(address => uint256) balances;
101     mapping (address => mapping (address => uint256)) internal allowed;
102 
103     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
104         name = _name;
105         symbol = _symbol;
106         decimals = _decimals;
107     }
108 
109     function balanceOf(address _owner) public view returns(uint256 balance) {
110         return balances[_owner];
111     }
112 
113     function transfer(address _to, uint256 _value) public returns(bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116 
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119 
120         Transfer(msg.sender, _to, _value);
121 
122         return true;
123     }
124     
125     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
126         require(_to.length == _value.length);
127 
128         for(uint i = 0; i < _to.length; i++) {
129             transfer(_to[i], _value[i]);
130         }
131 
132         return true;
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
136         require(_to != address(0));
137         require(_value <= balances[_from]);
138         require(_value <= allowed[_from][msg.sender]);
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143 
144         Transfer(_from, _to, _value);
145 
146         return true;
147     }
148 
149     function allowance(address _owner, address _spender) public view returns(uint256) {
150         return allowed[_owner][_spender];
151     }
152 
153     function approve(address _spender, uint256 _value) public returns(bool) {
154         allowed[msg.sender][_spender] = _value;
155 
156         Approval(msg.sender, _spender, _value);
157 
158         return true;
159     }
160 
161     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
162         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163 
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165 
166         return true;
167     }
168 
169     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
170         uint oldValue = allowed[msg.sender][_spender];
171 
172         if(_subtractedValue > oldValue) {
173             allowed[msg.sender][_spender] = 0;
174         } else {
175             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176         }
177 
178         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179 
180         return true;
181     }
182 }
183 
184 contract MintableToken is StandardToken, Ownable {
185     event Mint(address indexed to, uint256 amount);
186     event MintFinished();
187 
188     bool public mintingFinished = false;
189 
190     modifier canMint() { require(!mintingFinished); _; }
191     modifier notMint() { require(mintingFinished); _; }
192 
193     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
194         totalSupply = totalSupply.add(_amount);
195         balances[_to] = balances[_to].add(_amount);
196 
197         Mint(_to, _amount);
198         Transfer(address(0), _to, _amount);
199 
200         return true;
201     }
202 
203     function finishMinting() onlyOwner canMint public returns(bool) {
204         mintingFinished = true;
205 
206         MintFinished();
207 
208         return true;
209     }
210 }
211 
212 contract CappedToken is MintableToken {
213     uint256 public cap;
214 
215     function CappedToken(uint256 _cap) public {
216         require(_cap > 0);
217         cap = _cap;
218     }
219 
220     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
221         require(totalSupply.add(_amount) <= cap);
222 
223         return super.mint(_to, _amount);
224     }
225 }
226 
227 contract BurnableToken is StandardToken {
228     event Burn(address indexed burner, uint256 value);
229 
230     function burn(uint256 _value) public {
231         require(_value <= balances[msg.sender]);
232 
233         address burner = msg.sender;
234 
235         balances[burner] = balances[burner].sub(_value);
236         totalSupply = totalSupply.sub(_value);
237 
238         Burn(burner, _value);
239     }
240 }
241 
242 
243 
244 contract Token is CappedToken, BurnableToken {
245 
246     string public URL = "https://prover.io";
247 
248     function Token() CappedToken(100000000 * 1 ether) StandardToken("PROVER.IO additional 5% discount", "BONUS", 18) public {
249         
250     }
251     
252     function transfer(address _to, uint256 _value) public returns(bool) {
253         return super.transfer(_to, _value);
254     }
255     
256     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
257         return super.multiTransfer(_to, _value);
258     }
259 
260     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
261         return super.transferFrom(_from, _to, _value);
262     }
263 }