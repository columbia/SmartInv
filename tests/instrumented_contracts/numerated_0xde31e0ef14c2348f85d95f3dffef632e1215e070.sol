1 pragma solidity ^0.4.24;
2 ///////////////////////////////////////////////////
3 //  
4 //  `iCashweb` ICW Token Contract
5 //
6 //  Total Tokens: 300,000,000.000000000000000000
7 //  Name: iCashweb
8 //  Symbol: ICWeb
9 //  Decimal Scheme: 18
10 //  
11 //  by Nishad Vadgama
12 ///////////////////////////////////////////////////
13 
14 library iMath {
15     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23     function div(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a / b;
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31     function add(uint256 a, uint256 b) internal pure returns(uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract iCashwebToken {
39     
40     address public iOwner;
41     mapping(address => bool) iOperable;
42     bool _mintingStarted;
43     bool _minted;
44 
45     modifier notMinted() {
46         require(_minted == false);
47         _;
48     }
49 
50     modifier mintingStarted() {
51         require(_mintingStarted == true);
52         _;
53     }
54     
55     modifier iOnlyOwner() {
56         require(msg.sender == iOwner || iOperable[msg.sender] == true);
57         _;
58     }
59     
60     function manageOperable(address _from, bool _value) public returns(bool) {
61         require(msg.sender == iOwner);
62         iOperable[_from] = _value;
63         emit Operable(msg.sender, _from, _value);
64         return true;
65     }
66 
67     function isOperable(address _addr) public view returns(bool) {
68         return iOperable[_addr];
69     }
70 
71     function manageMinting(bool _val) public {
72         require(msg.sender == iOwner);
73         _mintingStarted = _val;
74         emit Minting(_val);
75     }
76 
77     function destroyContract() public {
78         require(msg.sender == iOwner);
79         selfdestruct(iOwner);
80     }
81     
82     event Operable(address _owner, address _from, bool _value);
83     event Minting(bool _value);
84     event OwnerTransferred(address _from, address _to);
85 }
86 
87 contract iCashweb is iCashwebToken {
88     using iMath for uint256;
89     
90     string public constant name = "iCashweb";
91     string public constant symbol = "ICWs";
92     uint8 public constant decimals = 18;
93     uint256 _totalSupply;
94     uint256 _rate;
95     uint256 _totalMintSupply;
96     uint256 _maxMintable;
97     mapping (address => uint256) _balances;
98     mapping (address => mapping (address => uint256)) _approvals;
99     
100     constructor (uint256 _price, uint256 _val) public {
101         iOwner = msg.sender;
102         _mintingStarted = true;
103         _minted = false;
104         _rate = _price;
105         uint256 tokenVal = _val.mul(10 ** uint256(decimals));
106         _totalSupply = tokenVal.mul(2);
107         _maxMintable = tokenVal;
108         _balances[msg.sender] = tokenVal;
109         emit Transfer(0x0, msg.sender, tokenVal);
110     }
111 
112     function getMinted() public view returns(bool) {
113         return _minted;
114     }
115 
116     function isOwner(address _addr) public view returns(bool) {
117         return _addr == iOwner;
118     }
119 
120     function getMintingStatus() public view returns(bool) {
121         return _mintingStarted;
122     }
123 
124     function getRate() public view returns(uint256) {
125         return _rate;
126     }
127 
128     function totalMintSupply() public view returns(uint256) {
129         return _totalMintSupply;
130     }
131     
132     function totalSupply() public view returns (uint256) {
133         return _totalSupply;
134     }
135     
136     function balanceOf(address _addr) public view returns (uint256) {
137         return _balances[_addr];
138     }
139     
140     function allowance(address _from, address _to) public view returns (uint256) {
141         return _approvals[_from][_to];
142     }
143     
144     function transfer(address _to, uint _val) public returns (bool) {
145         assert(_balances[msg.sender] >= _val && msg.sender != _to);
146         _balances[msg.sender] = _balances[msg.sender].sub(_val);
147         _balances[_to] = _balances[_to].add(_val);
148         emit Transfer(msg.sender, _to, _val);
149         return true;
150     }
151     
152     function transferFrom(address _from, address _to, uint _val) public returns (bool) {
153         assert(_balances[_from] >= _val);
154         assert(_approvals[_from][msg.sender] >= _val);
155         _approvals[_from][msg.sender] = _approvals[_from][msg.sender].sub(_val);
156         _balances[_from] = _balances[_from].sub(_val);
157         _balances[_to] = _balances[_to].add(_val);
158         emit Transfer(_from, _to, _val);
159         return true;
160     }
161     
162     function approve(address _to, uint256 _val) public returns (bool) {
163         _approvals[msg.sender][_to] = _val;
164         emit Approval(msg.sender, _to, _val);
165         return true;
166     }
167     
168     function () public mintingStarted payable {
169         assert(msg.value > 0);
170         uint tokens = msg.value.mul(_rate);
171         uint totalToken = _totalMintSupply.add(tokens);
172         assert(_maxMintable >= totalToken);
173         _balances[msg.sender] = _balances[msg.sender].add(tokens);
174         _totalMintSupply = _totalMintSupply.add(tokens);
175         iOwner.transfer(msg.value);
176         emit Transfer(0x0, msg.sender, tokens);
177     }
178     
179     function moveMintTokens(address _from, address _to, uint256 _value) public iOnlyOwner returns(bool) {
180         require(_to != _from);
181         require(_balances[_from] >= _value);
182         _balances[_from] = _balances[_from].sub(_value);
183         _balances[_to] = _balances[_to].add(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187     
188     function transferMintTokens(address _to, uint256 _value) public iOnlyOwner returns(bool) {
189         uint totalToken = _totalMintSupply.add(_value);
190         require(_maxMintable >= totalToken);
191         _balances[_to] = _balances[_to].add(_value);
192         _totalMintSupply = _totalMintSupply.add(_value);
193         emit Transfer(0x0, _to, _value);
194         return true;
195     }
196 
197     function releaseMintTokens() public notMinted returns(bool) {
198         require(msg.sender == iOwner);
199         uint256 releaseAmount = _maxMintable.sub(_totalMintSupply);
200         uint256 totalReleased = _totalMintSupply.add(releaseAmount);
201         require(_maxMintable >= totalReleased);
202         _totalMintSupply = _totalMintSupply.add(releaseAmount);
203         _balances[msg.sender] = _balances[msg.sender].add(releaseAmount);
204         _minted = true;
205         emit Transfer(0x0, msg.sender, releaseAmount);
206         emit Release(msg.sender, releaseAmount);
207         return true;
208     }
209 
210     function changeRate(uint256 _value) public returns (bool) {
211         require(msg.sender == iOwner && _value > 0);
212         _rate = _value;
213         return true;
214     }
215 
216     function transferOwnership(address _to) public {
217         require(msg.sender == iOwner && _to != msg.sender);  
218         address oldOwner = iOwner;
219         uint256 balAmount = _balances[oldOwner];
220         _balances[_to] = _balances[_to].add(balAmount);
221         _balances[oldOwner] = 0;
222         iOwner = _to;
223         emit Transfer(oldOwner, _to, balAmount);
224         emit OwnerTransferred(oldOwner, _to);
225     }
226     
227     event Release(address _addr, uint256 _val);
228     event Transfer(address indexed _from, address indexed _to, uint256 _value);
229     event Approval(address indexed _from, address indexed _to, uint256 _value);
230 }