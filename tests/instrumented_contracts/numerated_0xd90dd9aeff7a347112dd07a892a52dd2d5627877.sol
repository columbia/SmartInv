1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10 
11     uint256 c = a * b;
12     require(c / a == b);
13 
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b > 0); 
19     uint256 c = a / b;
20 
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b <= a);
26     uint256 c = a - b;
27 
28     return c;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     require(c >= a);
34 
35     return c;
36   }
37 
38   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b != 0);
40     return a % b;
41   }
42 }
43 
44 
45 contract IERC20 {
46   function totalSupply() public view returns (uint256);
47 
48   function balanceOf(address who) public view returns (uint256);
49 
50   function allowance(address owner, address spender)
51     public view returns (uint256);
52 
53   function transfer(address to, uint256 value) public returns (bool);
54 
55   function approve(address spender, uint256 value)
56     public returns (bool);
57 
58   function transferFrom(address from, address to, uint256 value)
59     public returns (bool);
60 
61   event Transfer(
62     address indexed from,
63     address indexed to,
64     uint256 value
65   );
66 
67   event Approval(
68     address indexed owner,
69     address indexed spender,
70     uint256 value
71   );
72 }
73 
74 contract Ownable {
75   address public _owner;
76     
77   event OwnershipTransferred( 
78       address indexed previousOwner, address indexed newOwner
79   );
80     
81   constructor() public {
82     _owner = msg.sender;
83     emit OwnershipTransferred(address(0), _owner);
84   }
85   
86   function owner() public view returns(address) {
87     return _owner;
88   }
89 
90   modifier onlyOwner() {
91     require(isOwner());
92     _;
93   }
94 
95   function isOwner() public view returns(bool) {
96     return msg.sender == _owner;
97   }
98   
99   function transferOwnership(address newOwner) public onlyOwner {
100     _transferOwnership(newOwner);
101   }
102   
103   function _transferOwnership(address newOwner) internal {
104     require(newOwner != address(0));
105     emit OwnershipTransferred(_owner, newOwner);
106     _owner = newOwner;
107   }
108 }
109 
110 contract BasicStandartToken is IERC20 {
111     using SafeMath for uint256;
112     
113     mapping (address => uint256) private _balances;
114     
115     mapping (address => mapping (address => uint256)) private _allowed;
116     
117     uint256 private _totalSupply;
118     
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122     
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126     
127     function transfer(address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129         require(_value <= _balances[msg.sender]);
130     
131         _balances[msg.sender] = _balances[msg.sender].sub(_value);
132         _balances[_to] = _balances[_to].add(_value);
133         emit Transfer(msg.sender, _to, _value);
134         return true;
135     }
136     
137     function transferFrom(
138         address from,
139         address to,
140         uint256 value
141       )
142         public
143         returns (bool)
144       {
145         require(to != address(0));
146         require(value <= _balances[from]);
147         require(value <= _allowed[from][msg.sender]);
148     
149         _balances[from] = _balances[from].sub(value);
150         _balances[to] = _balances[to].add(value);
151         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
152         emit Transfer(from, to, value);
153         return true;
154     }
155     
156     function allowance(
157         address owner,
158         address spender
159        )
160         public
161         view
162         returns (uint256)
163       {
164         return _allowed[owner][spender];
165     }
166     
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169     
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174     
175     function increaseAllowance(
176         address spender,
177         uint256 addedValue
178       )
179         public
180         returns (bool)
181       {
182         require(spender != address(0));
183     
184         _allowed[msg.sender][spender] = (
185           _allowed[msg.sender][spender].add(addedValue));
186         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
187         return true;
188       }
189     
190       function decreaseAllowance(
191         address spender,
192         uint256 subtractedValue
193       )
194         public
195         returns (bool)
196       {
197         require(spender != address(0));
198         uint oldValue = _allowed[msg.sender][spender];
199     
200         if (subtractedValue > oldValue) {
201             _allowed[msg.sender][spender] = 0;
202         } else {
203             _allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
204         }
205 
206     
207         _allowed[msg.sender][spender] = (
208           _allowed[msg.sender][spender].sub(subtractedValue));
209         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
210         return true;
211     }
212     
213     function _mint(address account, uint256 value) internal {
214         require(account != 0);
215         _totalSupply = _totalSupply.add(value);
216         _balances[account] = _balances[account].add(value);
217         emit Transfer(address(0), account, value);
218     }
219 }
220 
221 contract SONTToken is BasicStandartToken, Ownable  {
222     using SafeMath for uint;
223 
224 
225     string constant public symbol = "SONT";
226     string constant public name = "Sonata Coin";
227     uint8 constant public decimals = 18;
228     
229     uint constant unlockTime = 1570492800; // Tuesday, October 8, 2019 12:00:00 AM   
230     
231     uint256 INITIAL_SUPPLY = 500000000e18;
232 
233     uint constant companyTokens = 225000000e18;
234     uint constant crowdsaleTokens = 275000000e18;
235 
236     address crowdsale = 0x495dfc0eb9BD76cbed420a95485dA0F46081B6BF;
237     address company = 0x2Fb67e6697c98cE5F96167A3980020abB24d3bf4;
238 
239     constructor() public {
240         _mint(crowdsale, crowdsaleTokens);
241         _mint(company, companyTokens);
242     }
243     
244 
245     function checkPermissions(address from) internal constant returns (bool) {
246 
247         if (from == company && now < unlockTime) {
248             return false;
249         }
250 
251         if (from == crowdsale) {
252             return true;
253         }
254         
255         return true;
256     }
257     
258     function transfer(address to, uint256 value) public returns (bool) {
259         require(checkPermissions(msg.sender));
260         return super.transfer(to, value);
261     }
262 
263     function transferFrom(address from, address to, uint256 value) public returns (bool) {
264         require(checkPermissions(from));
265         return super.transferFrom(from, to, value);
266     }
267     
268 }