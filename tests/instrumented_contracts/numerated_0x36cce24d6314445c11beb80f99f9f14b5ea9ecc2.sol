1 pragma solidity ^0.4.24;
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
152 contract LynchpinPrivateICO is Ownable(0x1788A2Fe89a3Bfa58DB57aabbf1Ffa08ADED6cba)
153 {
154     using SafeMath for uint256;
155 
156     LynchpinToken public lynT = LynchpinToken(0xB0B1685f55843D03739c7D9b0A230F1B7DcF03D5);
157     address public beneficiary = 0x1788A2Fe89a3Bfa58DB57aabbf1Ffa08ADED6cba;
158 
159     uint256 public tokeninOneEther;
160     uint256 public maxTokensToSell = 2000000 * 10**18;
161     uint256 public tokenSold;
162     bool crowdsaleClosed = false;
163 
164     uint256 LOCK_PERIOD_START    = 1556668800;    // Wednesday, May 1, 2019 12:00:00 AM         start time
165     uint256 LOCK_PERIOD_9_MONTH  = 1580515200;    // Saturday, February 1, 2020 12:00:00 AM     9th month done
166     uint256 LOCK_PERIOD_10_MONTH = 1583020800;    // Sunday, March 1, 2020 12:00:00 AM          10th  month done
167     uint256 LOCK_PERIOD_11_MONTH = 1585699200;    // Wednesday, April 1, 2020 12:00:00 AM       11th month done
168     uint256 LOCK_PERIOD_END      = 1588291200;    // Friday, May 1, 2020 12:00:00 AM            12th month done - lock-in period ends
169 
170     mapping(address => uint256) public tokensOwed;
171     mapping(address => uint256) public ethContribution;
172     mapping(address => bool) public isWhitelisted;
173 
174     event LogAddedToWhitelist(address indexed _contributor);
175     event LogTokenRateUpdated(uint256 _newRate);
176     event LogSaleClosed();
177 
178     constructor(uint256 _tokeninOneEther) public
179     {
180         require (_tokeninOneEther > 0);
181         isWhitelisted[owner] = true;
182         tokeninOneEther = _tokeninOneEther;
183         emit LogTokenRateUpdated(_tokeninOneEther);
184     }
185 
186     function () public payable
187     {
188         require(!crowdsaleClosed);
189         require(isWhitelisted[msg.sender]);
190 
191         uint256 amountToSend = msg.value * tokeninOneEther;
192 
193         require (tokenSold.add(amountToSend) <= maxTokensToSell);
194 
195         tokensOwed[msg.sender] += amountToSend;
196         tokenSold += amountToSend;
197         ethContribution[msg.sender] += msg.value;
198         beneficiary.transfer(address(this).balance);
199     }
200 
201     function addContributor(address _contributor) external onlyOwner
202     {
203         require(_contributor != address(0));
204         require(!isWhitelisted[_contributor]);
205         isWhitelisted[_contributor] = true;
206         emit LogAddedToWhitelist(_contributor);
207     }
208 
209     function updateTokenRate(uint256 _tokeninOneEther ) external onlyOwner
210     {
211         require (_tokeninOneEther > 0);
212         tokeninOneEther = _tokeninOneEther;
213         emit LogTokenRateUpdated(_tokeninOneEther);
214     }
215 
216     function closeSale() external onlyOwner
217     {
218         require (now > LOCK_PERIOD_START);
219         lynT.transfer(msg.sender, lynT.balanceOf(address(this)));
220         beneficiary.transfer(address(this).balance);
221         crowdsaleClosed = true;
222         emit LogSaleClosed();
223     }
224 
225     function withdrawMyTokens () external
226     {
227         require (crowdsaleClosed);
228         require (tokensOwed[msg.sender] > 0);
229         require (now > LOCK_PERIOD_9_MONTH);
230 
231         uint256 penalty = 0;
232         if(now > LOCK_PERIOD_END)
233             penalty = 0;
234         else if(now > LOCK_PERIOD_11_MONTH)
235             penalty = 20;
236         else if(now > LOCK_PERIOD_10_MONTH)
237             penalty = 30;
238         else
239             penalty = 40;
240 
241         uint256 tokenBought = tokensOwed[msg.sender];
242         uint256 toSend = tokenBought.sub(tokenBought.mul(penalty).div(100));
243         tokensOwed[msg.sender] = 0;
244         lynT.transfer(msg.sender, toSend);
245     }
246 
247     function withdrawPenaltyTokens() external onlyOwner
248     {
249         require (now > LOCK_PERIOD_END);
250         lynT.transfer(msg.sender, lynT.balanceOf(address(this)));
251         beneficiary.transfer(address(this).balance);
252     }
253 }