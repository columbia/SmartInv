1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath v0.1.9
4  * @dev Math operations with safety checks that throw on error
5  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
6  * - added sqrt
7  * - added sq
8  * - added pwr 
9  * - changed asserts to requires with error log outputs
10  * - removed div, its useless
11  */
12  
13 library SafeMath {
14     
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) 
19         internal 
20         pure 
21         returns (uint256 c) 
22     {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         require(c / a == b, "SafeMath mul failed");
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40     
41     /**
42     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b)
45         internal
46         pure
47         returns (uint256) 
48     {
49         require(b <= a, "SafeMath sub failed");
50         return a - b;
51     }
52 
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     function add(uint256 a, uint256 b)
57         internal
58         pure
59         returns (uint256 c) 
60     {
61         c = a + b;
62         require(c >= a, "SafeMath add failed");
63         return c;
64     }
65     
66     /**
67      * @dev gives square root of given x.
68      */
69     function sqrt(uint256 x)
70         internal
71         pure
72         returns (uint256 y) 
73     {
74         uint256 z = ((add(x,1)) / 2);
75         y = x;
76         while (z < y) 
77         {
78             y = z;
79             z = ((add((x / z),z)) / 2);
80         }
81     }
82     
83     /**
84      * @dev gives square. multiplies x by x
85      */
86     function sq(uint256 x)
87         internal
88         pure
89         returns (uint256)
90     {
91         return (mul(x,x));
92     }
93     
94     /**
95      * @dev x to the power of y 
96      */
97     function pwr(uint256 x, uint256 y)
98         internal 
99         pure 
100         returns (uint256)
101     {
102         if (x==0)
103             return (0);
104         else if (y==0)
105             return (1);
106         else 
107         {
108             uint256 z = x;
109             for (uint256 i=1; i < y; i++)
110                 z = mul(z,x);
111             return (z);
112         }
113     }
114 }
115 
116 /*
117  * ERC20 interface
118  * see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 {
121     function totalSupply() public view returns (uint supply);
122     function balanceOf( address who ) public view returns (uint value);
123     function allowance( address owner, address spender ) public view returns (uint _allowance);
124 
125     function transfer( address to, uint value) public returns (bool ok);
126     function transferFrom( address from, address to, uint value) public returns (bool ok);
127     function approve( address spender, uint value ) public returns (bool ok);
128 
129     event Transfer( address indexed from, address indexed to, uint value);
130     event Approval( address indexed owner, address indexed spender, uint value);
131 }
132 /*
133  * contract : Ownable
134  */
135  contract Ownable {
136     address public owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     constructor() public {
141         owner = msg.sender;
142     }
143 
144     modifier onlyOwner {
145         require(msg.sender == owner);
146         _;
147     }
148 
149     function transferOwnership(address newOwner) onlyOwner public {
150         if (newOwner != address(0)) {
151             emit OwnershipTransferred(owner, newOwner);
152             owner = newOwner;
153         }
154     }
155 }
156 /*
157  * Pausable contract
158  */
159 
160 contract Pausable is Ownable {
161     event Pause();
162     event Unpause();
163 
164     bool public paused = false;
165 
166     modifier whenNotPaused() {
167         require(!paused);
168         _;
169     }
170 
171     modifier whenPaused {
172         require(paused);
173         _;
174     }
175 
176     function pause() onlyOwner whenNotPaused public returns (bool) {
177         paused = true;
178         emit Pause();
179         return true;
180     }
181 
182     function unpause() onlyOwner whenPaused public returns (bool) {
183         paused = false;
184         emit Unpause();
185         return true;
186     }
187 }
188 /**
189  contract : NTechToken
190  */
191 contract NTechToken is ERC20, Ownable, Pausable{
192     /**
193      代币基本信息
194      */
195     string public                   name = "NTech";
196     string public                   symbol = "NT";
197     uint8 constant public           decimals = 18;
198     uint256                         supply;
199 
200     mapping (address => uint256)                        balances;
201     mapping (address => mapping (address => uint256))   approvals;
202     uint256 public constant initSupply = 10000000000;       // 10,000,000,000
203 
204     constructor() public {
205         supply = SafeMath.mul(uint256(initSupply),uint256(10)**uint256(decimals));
206         balances[msg.sender] = supply; 
207     }
208     // ERC 20
209     function totalSupply() public view returns (uint256){
210         return supply ;
211     }
212 
213     function balanceOf(address src) public view returns (uint256) {
214         return balances[src];
215     }
216 
217     function allowance(address src, address guy) public view returns (uint256) {
218         return approvals[src][guy];
219     }
220     
221     function transfer(address dst, uint wad) whenNotPaused public returns (bool) {
222         require(balances[msg.sender] >= wad);                   // 要有足够余额
223         require(dst != 0x0);                                    // 不能送到无效地址
224 
225         balances[msg.sender] = SafeMath.sub(balances[msg.sender], wad);  // -    
226         balances[dst] = SafeMath.add(balances[dst], wad);                // +
227         
228         emit Transfer(msg.sender, dst, wad);                    // 记录事件
229         
230         return true;
231     }
232 
233     function transferFrom(address src, address dst, uint wad) whenNotPaused public returns (bool) {
234         require(balances[src] >= wad);                          // 要有足够余额
235         require(approvals[src][msg.sender] >= wad);
236         
237         approvals[src][msg.sender] = SafeMath.sub(approvals[src][msg.sender], wad);
238         balances[src] = SafeMath.sub(balances[src], wad);
239         balances[dst] = SafeMath.add(balances[dst], wad);
240         
241         emit Transfer(src, dst, wad);
242         
243         return true;
244     }
245     
246     function approve(address guy, uint256 wad) whenNotPaused public returns (bool) {
247         require(wad != 0);
248         approvals[msg.sender][guy] = wad;
249         emit Approval(msg.sender, guy, wad);
250         return true;
251     }
252 
253     
254 }