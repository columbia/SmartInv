1 pragma solidity  ^0.4.21;
2 
3 
4 contract DSMath {
5     uint constant DENOMINATOR = 10000;
6     uint constant DECIMALS = 18;
7     uint constant WAD = 10**DECIMALS;
8 
9     modifier condition(bool _condition) {
10         require(_condition);
11         _;
12     }
13 
14     function add(uint x, uint y) internal pure returns (uint z) {
15         require((z = x + y) >= x);
16     }
17 	
18     function sub(uint x, uint y) internal pure returns (uint z) {
19         require((z = x - y) <= x);
20     }
21 	
22     function mul(uint x, uint y) internal pure returns (uint z) {
23         require(y == 0 || (z = x * y) / y == x);
24     }
25 }
26 
27 
28 contract Token is DSMath {
29     string  public symbol;
30     uint256 public decimals;
31     string  public name;
32     address public owner;
33 
34     uint256 internal _supply;
35     mapping (address => uint256) internal _balances;
36     mapping (address => mapping (address => uint256)) private _approvals;
37 
38     event LogSetOwner(address indexed owner_);
39     event Transfer( address indexed from, address indexed to, uint value);
40     event Approval( address indexed owner_, address indexed spender, uint value);
41 
42     modifier auth {
43         require(isAuthorized(msg.sender));
44         _;
45     }
46 
47     function Token() internal {
48         owner = msg.sender;
49     }
50 
51     function totalSupply() public constant returns (uint256) {
52         return _supply;
53     }
54 
55     function balanceOf(address src) public constant returns (uint256) {
56         return _balances[src];
57     }
58 
59     function allowance(address src, address guy) public constant returns (uint256) {
60         return _approvals[src][guy];
61     }
62 
63     function transfer(address dst, uint wad) public returns (bool) {
64         require(_balances[msg.sender] >= wad);
65 
66         _balances[msg.sender] = sub(_balances[msg.sender], wad);
67         _balances[dst] = add(_balances[dst], wad);
68 
69         emit Transfer(msg.sender, dst, wad);
70 
71         return true;
72     }
73 
74     function transferFrom(address src, address dst, uint wad) public returns (bool) {
75         require(_balances[src] >= wad);
76         require(_approvals[src][msg.sender] >= wad);
77 
78         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
79         _balances[src] = sub(_balances[src], wad);
80         _balances[dst] = add(_balances[dst], wad);
81 
82         emit Transfer(src, dst, wad);
83 
84         return true;
85     }
86 
87     function approve(address guy, uint256 wad) public returns (bool) {
88         _approvals[msg.sender][guy] = wad;
89         emit Approval(msg.sender, guy, wad);
90         return true;
91     }
92 
93     function mint(uint wad)
94     public
95     auth
96     {
97         _balances[msg.sender] = add(_balances[msg.sender], wad);
98         _supply = add(_supply, wad);
99     }
100 
101     function setOwner(address owner_)
102         public
103         auth
104     {
105         owner = owner_;
106         emit LogSetOwner(owner);
107     }
108 
109     function isAuthorized(address src) internal constant returns (bool) {
110         if (src == address(this)) {
111             return true;
112         } else if (src == owner) {
113             return true;
114         } else {
115             return false;
116         }
117     }
118 }
119 
120 
121 // Universal Token
122 contract UniversalToken is Token {
123     uint public xactionFeeNumerator;
124     uint public xactionFeeShare;
125 
126     function UniversalToken( 
127         uint initialSupply,
128         uint feeMult,
129         uint feeShare ) public
130         condition(initialSupply > 1000)
131         condition(feeMult > 0)
132     {
133         symbol = "PMT";
134         name = "Universal Evangelist Token - by Pure Money Tech";
135         decimals = DECIMALS;
136 		_supply = mul(initialSupply, WAD);
137 		owner = msg.sender;
138         xactionFeeNumerator = feeMult;
139         xactionFeeShare = feeShare;
140 		_balances[owner] = _supply;
141     }
142 
143     function modifyTransFee(uint _xactionFeeMult) public
144         auth
145         condition(_xactionFeeMult >= 0)
146         condition(DENOMINATOR > 4 * _xactionFeeMult)
147     {
148         xactionFeeNumerator = _xactionFeeMult;
149     }
150 
151     function modifyFeeShare(uint _share) public
152         auth
153         condition(_share >= 0)
154         condition(DENOMINATOR > 3 * _share)
155     {
156         xactionFeeShare = _share;
157     }
158 }
159 
160 
161 // Local Token
162 contract LocalToken is Token {
163 
164     string  public localityCode;
165     uint    public taxRateNumerator = 0;
166     address public govtAccount = 0;
167     address public pmtAccount = 0;
168     UniversalToken public universalToken;
169 
170     function LocalToken(
171             uint _maxTokens,
172             uint _taxRateMult,
173 			string _tokenSymbol,
174 			string _tokenName,
175             string _localityCode,
176             address _govt,
177             address _pmt,
178             address _universalToken
179             ) public
180             condition(_maxTokens > 10)
181             condition(DENOMINATOR > mul(_taxRateMult, 2))
182             condition((_taxRateMult > 0 && _govt != 0) || _taxRateMult == 0)
183             condition(_universalToken != 0)
184     {
185         universalToken = UniversalToken(_universalToken);
186         require(msg.sender == universalToken.owner());
187 		decimals = DECIMALS;
188 		symbol = _tokenSymbol;
189 		name = _tokenName;
190         localityCode = _localityCode;
191         _supply = mul(_maxTokens, WAD);
192         govtAccount = _govt;
193         pmtAccount = _pmt;
194 		owner = msg.sender;
195         if (_taxRateMult > 0) {
196             taxRateNumerator = _taxRateMult;
197         }
198 		_balances[owner] = _supply;
199     }
200 
201     function modifyLocality(string newLocality) public
202         auth
203     {
204         localityCode = newLocality;
205     }
206 
207 	function modifyTaxRate(uint _taxMult) public
208         auth
209 		condition(DENOMINATOR > 2 * _taxMult)
210     {
211 		taxRateNumerator = _taxMult;
212 	}
213 
214     // To reset gvtAccount when taxRateNumerator is not zero, 
215     // must reset taxRateNumerator first.
216     // To set govtAccount when taxRateNumerator is zero,
217     // must set taxRateNumerator first to non-zero value.
218     function modifyGovtAccount(address govt) public
219         auth
220         condition((taxRateNumerator > 0 && govt != 0) ||
221                 (taxRateNumerator == 0 && govt == 0))
222     {
223         govtAccount = govt;
224     }
225 
226     function modifyPMTAccount(address _pmt) public
227         auth
228     {
229         pmtAccount = _pmt;
230     }
231 }