1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-25
3  */
4 
5 pragma solidity ^0.4.19;
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a / b;
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract Ownable {
35     address public owner;
36     event OwnershipTransferred(
37         address indexed previousOwner,
38         address indexed newOwner
39     );
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
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 }
56 
57 contract ERC20Interface {
58     function totalSupply() public constant returns (uint256);
59 
60     function balanceOf(address tokenOwner)
61         public
62         constant
63         returns (uint256 balance);
64 
65     function allowance(address tokenOwner, address spender)
66         public
67         constant
68         returns (uint256 remaining);
69 
70     function transfer(address to, uint256 tokens) public returns (bool success);
71 
72     function approve(address spender, uint256 tokens)
73         public
74         returns (bool success);
75 
76     function transferFrom(
77         address from,
78         address to,
79         uint256 tokens
80     ) public returns (bool success);
81 
82     event Transfer(address indexed from, address indexed to, uint256 tokens);
83     event Approval(
84         address indexed tokenOwner,
85         address indexed spender,
86         uint256 tokens
87     );
88 }
89 
90 contract ERC827 {
91     function approve(
92         address _spender,
93         uint256 _value,
94         bytes _data
95     ) public returns (bool);
96 
97     function transfer(
98         address _to,
99         uint256 _value,
100         bytes _data
101     ) public returns (bool);
102 
103     function transferFrom(
104         address _from,
105         address _to,
106         uint256 _value,
107         bytes _data
108     ) public returns (bool);
109 }
110 
111 contract TEFoodsToken is Ownable, ERC20Interface {
112     using SafeMath for uint256;
113 
114     string public constant name = "TE-FOOD/TustChain";
115     string public constant symbol = "TONE";
116     uint8 public constant decimals = 18;
117     uint256 constant _totalSupply = 1000000000 * 1 ether;
118     uint256 public transferrableTime = 9999999999;
119     uint256 _vestedSupply;
120     uint256 _circulatingSupply;
121     mapping(address => uint256) balances;
122     mapping(address => mapping(address => uint256)) allowed;
123 
124     struct vestedBalance {
125         address addr;
126         uint256 balance;
127     }
128     mapping(uint256 => vestedBalance[]) vestingMap;
129 
130     function TEFoodsToken() public {
131         owner = msg.sender;
132         balances[0x00] = _totalSupply;
133     }
134 
135     event VestedTokensReleased(address to, uint256 amount);
136 
137     function allocateTokens(address addr, uint256 amount)
138         public
139         onlyOwner
140         returns (bool)
141     {
142         require(addr != 0x00);
143         require(amount > 0);
144         balances[0x00] = balances[0x00].sub(amount);
145         balances[addr] = balances[addr].add(amount);
146         _circulatingSupply = _circulatingSupply.add(amount);
147         assert(
148             _vestedSupply.add(_circulatingSupply).add(balances[0x00]) ==
149                 _totalSupply
150         );
151         Transfer(0x00, addr, amount);
152         return true;
153     }
154 
155     function allocateVestedTokens(
156         address addr,
157         uint256 amount,
158         uint256 vestingPeriod
159     ) public onlyOwner returns (bool) {
160         require(addr != 0x00);
161         require(amount > 0);
162         require(vestingPeriod > 0);
163         balances[0x00] = balances[0x00].sub(amount);
164         vestingMap[vestingPeriod].push(vestedBalance(addr, amount));
165         _vestedSupply = _vestedSupply.add(amount);
166         assert(
167             _vestedSupply.add(_circulatingSupply).add(balances[0x00]) ==
168                 _totalSupply
169         );
170         return true;
171     }
172 
173     function releaseVestedTokens(uint256 vestingPeriod) public {
174         require(now >= transferrableTime.add(vestingPeriod));
175         require(vestingMap[vestingPeriod].length > 0);
176         require(vestingMap[vestingPeriod][0].balance > 0);
177         var v = vestingMap[vestingPeriod];
178         for (uint8 i = 0; i < v.length; i++) {
179             balances[v[i].addr] = balances[v[i].addr].add(v[i].balance);
180             _circulatingSupply = _circulatingSupply.add(v[i].balance);
181             _vestedSupply = _vestedSupply.sub(v[i].balance);
182             VestedTokensReleased(v[i].addr, v[i].balance);
183             Transfer(0x00, v[i].addr, v[i].balance);
184             v[i].balance = 0;
185         }
186     }
187 
188     function enableTransfers() public onlyOwner returns (bool) {
189         transferrableTime = now.add(0);
190         owner = 0x00;
191         return true;
192     }
193 
194     function() public payable {
195         revert();
196     }
197 
198     function totalSupply() public constant returns (uint256) {
199         return _circulatingSupply;
200     }
201 
202     function balanceOf(address tokenOwner)
203         public
204         constant
205         returns (uint256 balance)
206     {
207         return balances[tokenOwner];
208     }
209 
210     function vestedBalanceOf(address tokenOwner, uint256 vestingPeriod)
211         public
212         constant
213         returns (uint256 balance)
214     {
215         var v = vestingMap[vestingPeriod];
216         for (uint8 i = 0; i < v.length; i++) {
217             if (v[i].addr == tokenOwner) return v[i].balance;
218         }
219         return 0;
220     }
221 
222     function allowance(address tokenOwner, address spender)
223         public
224         constant
225         returns (uint256 remaining)
226     {
227         return allowed[tokenOwner][spender];
228     }
229 
230     function transfer(address to, uint256 tokens)
231         public
232         returns (bool success)
233     {
234         require(now >= transferrableTime);
235         require(to != address(this));
236         require(balances[msg.sender] >= tokens);
237         balances[msg.sender] = balances[msg.sender].sub(tokens);
238         balances[to] = balances[to].add(tokens);
239         Transfer(msg.sender, to, tokens);
240         return true;
241     }
242 
243     function approve(address spender, uint256 tokens)
244         public
245         returns (bool success)
246     {
247         require(now >= transferrableTime);
248         require(spender != address(this));
249         allowed[msg.sender][spender] = tokens;
250         Approval(msg.sender, spender, tokens);
251         return true;
252     }
253 
254     function transferFrom(
255         address from,
256         address to,
257         uint256 tokens
258     ) public returns (bool success) {
259         require(now >= transferrableTime);
260         require(to != address(this));
261         require(allowed[from][msg.sender] >= tokens);
262         balances[from] = balances[from].sub(tokens);
263         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
264         balances[to] = balances[to].add(tokens);
265         Transfer(from, to, tokens);
266         return true;
267     }
268 }
269 
270 contract TEFoods827Token is TEFoodsToken, ERC827 {
271     function approve(
272         address _spender,
273         uint256 _value,
274         bytes _data
275     ) public returns (bool) {
276         super.approve(_spender, _value);
277         require(_spender.call(_data));
278         return true;
279     }
280 
281     function transfer(
282         address _to,
283         uint256 _value,
284         bytes _data
285     ) public returns (bool) {
286         super.transfer(_to, _value);
287         require(_to.call(_data));
288         return true;
289     }
290 
291     function transferFrom(
292         address _from,
293         address _to,
294         uint256 _value,
295         bytes _data
296     ) public returns (bool) {
297         super.transferFrom(_from, _to, _value);
298         require(_to.call(_data));
299         return true;
300     }
301 }