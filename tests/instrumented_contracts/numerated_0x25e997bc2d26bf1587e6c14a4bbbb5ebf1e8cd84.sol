1 contract SafeMath {
2   function mul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14 
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 
26   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a >= b ? a : b;
28   }
29 
30   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a < b ? a : b;
32   }
33 
34   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a >= b ? a : b;
36   }
37 
38   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a < b ? a : b;
40   }
41 
42   function assert(bool assertion) internal {
43     if (!assertion) {
44       throw;
45     }
46   }
47 }
48 
49 contract Arithmetic {
50     function mul256By256(uint a, uint b)
51         constant
52         returns (uint ab32, uint ab1, uint ab0)
53     {
54         uint ahi = a >> 128;
55         uint alo = a & 2**128-1;
56         uint bhi = b >> 128;
57         uint blo = b & 2**128-1;
58         ab0 = alo * blo;
59         ab1 = (ab0 >> 128) + (ahi * blo & 2**128-1) + (alo * bhi & 2**128-1);
60         ab32 = (ab1 >> 128) + ahi * bhi + (ahi * blo >> 128) + (alo * bhi >> 128);
61         ab1 &= 2**128-1;
62         ab0 &= 2**128-1;
63     }
64 
65     // I adapted this from Fast Division of Large Integers by Karl Hasselström
66     // Algorithm 3.4: Divide-and-conquer division (3 by 2)
67     // Karl got it from Burnikel and Ziegler and the GMP lib implementation
68     function div256_128By256(uint a21, uint a0, uint b)
69         constant
70         returns (uint q, uint r)
71     {
72         uint qhi = (a21 / b) << 128;
73         a21 %= b;
74 
75         uint shift = 0;
76         while(b >> shift > 0) shift++;
77         shift = 256 - shift;
78         a21 = (a21 << shift) + (shift > 128 ? a0 << (shift - 128) : a0 >> (128 - shift));
79         a0 = (a0 << shift) & 2**128-1;
80         b <<= shift;
81         var (b1, b0) = (b >> 128, b & 2**128-1);
82 
83         uint rhi;
84         q = a21 / b1;
85         rhi = a21 % b1;
86 
87         uint rsub0 = (q & 2**128-1) * b0;
88         uint rsub21 = (q >> 128) * b0 + (rsub0 >> 128);
89         rsub0 &= 2**128-1;
90 
91         while(rsub21 > rhi || rsub21 == rhi && rsub0 > a0) {
92             q--;
93             a0 += b0;
94             rhi += b1 + (a0 >> 128);
95             a0 &= 2**128-1;
96         }
97 
98         q += qhi;
99         r = (((rhi - rsub21) << 128) + a0 - rsub0) >> shift;
100     }
101 
102     function overflowResistantFraction(uint a, uint b, uint divisor)
103         returns (uint)
104     {
105         uint ab32_q1; uint ab1_r1; uint ab0;
106         if(b <= 1 || b != 0 && a * b / b == a) {
107             return a * b / divisor;
108         } else {
109             (ab32_q1, ab1_r1, ab0) = mul256By256(a, b);
110             (ab32_q1, ab1_r1) = div256_128By256(ab32_q1, ab1_r1, divisor);
111             (a, b) = div256_128By256(ab1_r1, ab0, divisor);
112             return (ab32_q1 << 128) + a;
113         }
114     }
115 }
116 
117 contract Ownable {
118   address public owner;
119 
120   function Ownable() {
121     owner = msg.sender;
122   }
123 
124   modifier onlyOwner() {
125     if (msg.sender != owner) {
126       throw;
127     }
128     _;
129   }
130 
131   function transferOwnership(address newOwner) onlyOwner {
132     if (newOwner != address(0)) {
133       owner = newOwner;
134     }
135   }
136 
137 }
138 
139 contract ERC20Basic {
140   uint public totalSupply;
141   function balanceOf(address who) constant returns (uint);
142   function transfer(address to, uint value) returns (bool);
143   event Transfer(address indexed from, address indexed to, uint value);
144 }
145 
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) constant returns (uint);
148   function transferFrom(address from, address to, uint value);
149   function approve(address spender, uint value);
150   event Approval(address indexed owner, address indexed spender, uint value);
151 }
152 
153 
154 
155 
156 contract Presale is Ownable, SafeMath, Arithmetic  {
157     uint public minInvest = 10 ether;
158     uint public maxcap = 490 ether;   // 100k euro based on kraken rates on 27/06/2017 at 13h20
159     address public ledgerWallet = "0xa4dbbF474a6f026Cf0a2d3e45aB192Fbd98D3a5f";
160     uint public count = 0;
161     uint public totalFunding;
162     bool public saleOn;
163     bool public distributed;
164     address public crowdsaleContract;
165     uint public balanceToken;
166     address[] public listBackers;
167     mapping (address => uint) public backers;
168     ERC20 public DTR;                       // wait to be instantiate when ERC20 will be created
169     event ReceivedETH(address addr, uint value);
170     event Logs(address addr, uint value1, uint value2);
171     event Logs2(uint value1, uint value2,uint value3, uint value4,uint value5, uint value6);
172     function Presale () {
173         saleOn = true;
174         distributed = false;
175     }
176     function() payable {
177         require(saleOn);
178         require(msg.value > minInvest);
179         require( SafeMath.add(totalFunding, msg.value) <= maxcap);
180         if (backers[msg.sender] == 0)
181           listBackers.push(msg.sender);
182         backers[msg.sender] =  SafeMath.add(backers[msg.sender], msg.value);
183         totalFunding = SafeMath.add(totalFunding, msg.value);
184         ledgerWallet.transfer(this.balance);
185         ReceivedETH(msg.sender, msg.value);
186     }
187     function balanceOf(address _owner) constant returns (uint balance) {
188       return backers[_owner];
189     }
190     function setDTR (address dtrAddress) onlyOwner {
191         DTR = ERC20(dtrAddress);
192         balanceToken = DTR.balanceOf(this);
193         Logs(dtrAddress, balanceToken, this.balance);
194     }
195 
196     function withdraw() onlyOwner {
197         ledgerWallet.transfer(this.balance);
198     }
199 
200     function closeSale() onlyOwner {
201         saleOn = false;
202     }
203 
204     // when closing ICO, token will be send to this contract, then this function will be called and token will be distribute among early investor
205     function distributes(uint max) onlyOwner {
206         require(!saleOn);
207         while(count < max) {
208             uint toSend = Arithmetic.overflowResistantFraction(balanceToken, backers[listBackers[count]], totalFunding);
209             require(DTR.transfer(listBackers[count], toSend));
210             count++;
211             if (count == listBackers.length) {
212                 distributed = true;
213                 break ;
214             }
215         }
216     }
217 }