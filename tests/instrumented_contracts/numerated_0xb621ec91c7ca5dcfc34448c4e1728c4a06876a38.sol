1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 
16         uint256 c = a / b;
17 
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36 
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41     function Ownable() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50 
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 
57 }
58 
59 contract ArnaCrowdsale is Ownable {
60     function burnUnsold() public onlyOwner returns (uint256);
61 
62     function price() public constant returns (uint256);
63 
64     function priceWithBonus() public constant returns (uint256);
65 
66     function sendTokens(address beneficiary, uint256 amount) public;
67 
68     function tokensToSale() public view returns (uint256);
69 
70     uint256 public totalRise;
71 
72     function withdraw() public onlyOwner returns (bool);
73 }
74 
75 //===========================================
76 
77 contract ERC20Basic {
78     uint256 public totalSupply;
79 
80     function balanceOf(address who) public view returns (uint256);
81 
82     function transfer(address to, uint256 value) public returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) public view returns (uint256);
90 
91     function transferFrom(address from, address to, uint256 value) public returns (bool);
92 
93     function approve(address spender, uint256 value) public returns (bool);
94 
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 contract BasicToken is ERC20Basic, Ownable {
100     using SafeMath for uint256;
101 
102     bool public transferable = false;
103 
104     mapping(address => uint256) balances;
105 
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109         require(isTransferable(msg.sender));
110 
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117 
118     function balanceOf(address _owner) public view returns (uint256 balance) {
119         return balances[_owner];
120     }
121 
122     ArnaCrowdsale public  crowdsale;
123 
124     function setCrowdsale(ArnaCrowdsale _crowdsale) public onlyOwner {
125         crowdsale = _crowdsale;
126     }
127 
128     function setTransferable(bool _transferable) public onlyOwner {
129         transferable = _transferable;
130     }
131 
132     function isTransferable(address _sender) internal view returns (bool){
133         return transferable || _sender == owner || _sender == address(crowdsale);
134     }
135 }
136 
137 
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping(address => mapping(address => uint256)) internal allowed;
141 
142 
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);
147         require(isTransferable(msg.sender));
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156 
157     function approve(address _spender, uint256 _value) public returns (bool) {
158         require(isTransferable(msg.sender));
159         allowed[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164 
165     function allowance(address _owner, address _spender) public view returns (uint256) {
166         require(isTransferable(msg.sender));
167         return allowed[_owner][_spender];
168     }
169 
170 
171     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
172         require(isTransferable(msg.sender));
173         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 
178     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
179         require(isTransferable(msg.sender));
180         uint oldValue = allowed[msg.sender][_spender];
181         if (_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         }
184         else {
185             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186         }
187         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190 
191 }
192 
193 
194 contract BurnableToken is StandardToken {
195 
196     event Burn(address indexed burner, uint256 value);
197 
198 
199     function burn(uint256 _value) public {
200         require(_value > 0);
201         require(_value <= balances[msg.sender]);
202 
203         address burner = msg.sender;
204         balances[burner] = balances[burner].sub(_value);
205         totalSupply = totalSupply.sub(_value);
206         Burn(burner, _value);
207     }
208 }
209 
210 
211 contract ArnaToken is BurnableToken {
212 
213     string public constant name = "ArnaToken";
214 
215     string public constant symbol = "ARNA";
216 
217     uint8 public constant decimals = 18;
218 
219     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
220 
221     function init() public onlyOwner {
222         assert(totalSupply == 0);
223         totalSupply = INITIAL_SUPPLY;
224         balances[msg.sender] = INITIAL_SUPPLY;
225     }
226 
227 }