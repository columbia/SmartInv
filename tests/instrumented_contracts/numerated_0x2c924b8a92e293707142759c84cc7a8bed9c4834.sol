1 pragma solidity 0.4.25;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6     returns (uint256)
7     {
8         uint256 c = a * b;
9 
10         assert(a == 0 || c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure
16     returns (uint256)
17     {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure
25     returns (uint256)
26     {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure
33     returns (uint256)
34     {
35         uint256 c = a + b;
36 
37         assert(c >= a);
38 
39         return c;
40     }
41 }
42 
43 interface ERC20
44 {
45     function totalSupply() view external returns (uint _totalSupply);
46     function balanceOf(address _owner) view external returns (uint balance);
47     function transfer(address _to, uint _value) external returns (bool success);
48     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
49     function approve(address _spender, uint _value) external returns (bool success);
50     function allowance(address _owner, address _spender) view external returns (uint remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint _value);
53     event Approval(address indexed _owner, address indexed _spender, uint _value);
54 }
55 
56 contract LynchpinToken is ERC20
57 {
58     using SafeMath for uint256;
59 
60     string  public name        = "Lynchpin";
61     string  public symbol      = "LYN";
62     uint8   public decimals    = 18;
63     uint    public totalSupply = 5000000 * (10 ** uint(decimals));
64     address public owner       = 0xAc983022185b95eF2B2C7219143483BD0C65Ecda;
65 
66     mapping (address => uint) public balanceOf;
67     mapping (address => mapping (address => uint)) public allowance;
68 
69     constructor() public
70     {
71         balanceOf[owner] = totalSupply;
72     }
73 
74     function totalSupply() view external returns (uint _totalSupply)
75     {
76         return totalSupply;
77     }
78 
79     function balanceOf(address _owner) view external returns (uint balance)
80     {
81         return balanceOf[_owner];
82     }
83 
84     function allowance(address _owner, address _spender) view external returns (uint remaining)
85     {
86         return allowance[_owner][_spender];
87     }
88     function _transfer(address _from, address _to, uint _value) internal
89     {
90         require(_to != 0x0);
91 
92         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
93         balanceOf[_from] = balanceOf[_from].sub(_value);
94         balanceOf[_to] = balanceOf[_to].add(_value);
95 
96         emit Transfer(_from, _to, _value);
97         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
98     }
99 
100     function transfer(address _to, uint _value) public returns (bool success)
101     {
102         _transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function transferFrom(address _from, address _to, uint _value) public returns (bool success)
107     {
108         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function approve(address _spender, uint _value) public returns (bool success)
114     {
115         allowance[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     // disallow incoming ether to this contract
121     function () public
122     {
123         revert();
124     }
125 }
126 
127 contract Ownable
128 {
129     address public owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     constructor(address _owner) public
134     {
135         owner = _owner;
136     }
137 
138     modifier onlyOwner()
139     {
140         require(msg.sender == owner);
141         _;
142     }
143 
144     function transferOwnership(address newOwner) public onlyOwner
145     {
146         require(newOwner != address(0));
147         emit OwnershipTransferred(owner, newOwner);
148         owner = newOwner;
149     }
150 }
151 
152 contract LynchpinPrivateICO is Ownable(0xAc983022185b95eF2B2C7219143483BD0C65Ecda)
153 {
154     using SafeMath for uint256;
155 
156     LynchpinToken public lynT = LynchpinToken(0xB0B1685f55843D03739c7D9b0A230F1B7DcF03D5);
157 
158     uint256 public tokeninOneEther;
159     uint256 public maxTokensToSell = 2000000 * 10**18;
160     uint256 public tokenSold;
161     bool crowdsaleClosed = false;
162 
163     uint256 LOCK_PERIOD_START    = 1556668800;    // Wednesday, May 1, 2019 12:00:00 AM         start time
164     uint256 LOCK_PERIOD_9_MONTH  = 1580515200;    // Saturday, February 1, 2020 12:00:00 AM     9th month done
165     uint256 LOCK_PERIOD_10_MONTH = 1583020800;    // Sunday, March 1, 2020 12:00:00 AM          10th  month done
166     uint256 LOCK_PERIOD_11_MONTH = 1585699200;    // Wednesday, April 1, 2020 12:00:00 AM       11th month done
167     uint256 LOCK_PERIOD_END      = 1588291200;    // Friday, May 1, 2020 12:00:00 AM            12th month done - lock-in period ends
168 
169     mapping(address => uint256) public tokensOwed;
170     mapping(address => uint256) public ethContribution;
171     mapping(address => bool) public isWhitelisted;
172 
173     event LogAddedToWhitelist(address indexed _contributor);
174     event LogTokenRateUpdated(uint256 _newRate);
175     event LogSaleClosed();
176 
177     constructor(uint256 _tokeninOneEther) public
178     {
179         require (_tokeninOneEther > 0);
180         isWhitelisted[owner] = true;
181         tokeninOneEther = _tokeninOneEther;
182         emit LogTokenRateUpdated(_tokeninOneEther);
183     }
184 
185     function () public payable
186     {
187         require(!crowdsaleClosed);
188         require(isWhitelisted[msg.sender]);
189 
190         uint256 amountToSend = msg.value * tokeninOneEther;
191 
192         require (tokenSold.add(amountToSend) <= maxTokensToSell);
193 
194         tokensOwed[msg.sender] += amountToSend;
195         tokenSold += amountToSend;
196         ethContribution[msg.sender] += msg.value;
197         owner.transfer(address(this).balance);
198     }
199 
200     function addContributor(address _contributor) external onlyOwner
201     {
202         require(_contributor != address(0));
203         require(!isWhitelisted[_contributor]);
204         isWhitelisted[_contributor] = true;
205         emit LogAddedToWhitelist(_contributor);
206     }
207 
208     function updateTokenRate(uint256 _tokeninOneEther ) external onlyOwner
209     {
210         require (_tokeninOneEther > 0);
211         tokeninOneEther = _tokeninOneEther;
212         emit LogTokenRateUpdated(_tokeninOneEther);
213     }
214 
215     function closeSale() external onlyOwner
216     {
217         require (now > LOCK_PERIOD_START);
218         lynT.transfer(msg.sender, lynT.balanceOf(address(this)));
219         owner.transfer(address(this).balance);
220         crowdsaleClosed = true;
221         emit LogSaleClosed();
222     }
223 
224     function withdrawMyTokens () external
225     {
226         require (crowdsaleClosed);
227         require (tokensOwed[msg.sender] > 0);
228         require (now > LOCK_PERIOD_9_MONTH);
229 
230         uint256 penalty = 0;
231         if(now > LOCK_PERIOD_END)
232             penalty = 0;
233         else if(now > LOCK_PERIOD_11_MONTH)
234             penalty = 20;
235         else if(now > LOCK_PERIOD_10_MONTH)
236             penalty = 30;
237         else
238             penalty = 40;
239 
240         uint256 tokenBought = tokensOwed[msg.sender];
241         uint256 toSend = tokenBought.sub(tokenBought.mul(penalty).div(100));
242         tokensOwed[msg.sender] = 0;
243         lynT.transfer(msg.sender, toSend);
244     }
245 
246     function withdrawPenaltyTokens() external onlyOwner
247     {
248         require (now > LOCK_PERIOD_END);
249         lynT.transfer(msg.sender, lynT.balanceOf(address(this)));
250         owner.transfer(address(this).balance);
251     }
252 }