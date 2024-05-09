1 pragma solidity 0.4.24;
2 
3 /*
4 
5     Copyright 2018, Vicent Nos & Mireia Puig
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19 
20 */
21 
22 
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 
55 contract Ownable {
56 
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() internal {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 }
76 
77 
78 
79 ////////////////////////////////////////////////////////
80 //:                                                  ://
81 //:          SpaceImpulse Public Engagement          ://
82 //:..................................................://
83 ////////////////////////////////////////////////////////
84 
85 
86 
87 
88 contract TokenCHK {
89 
90   function balanceOf(address _owner) public pure returns (uint256 balance) {}
91   function transfer(address to, uint256 value) public returns (bool);
92 }
93 
94 
95 
96 
97 contract SpaceImpulse is Ownable {
98 
99     using SafeMath for uint256;
100 
101     string public name = "Space Impulse Public Engagement";      // Extended name of this contract
102     uint256 public tokenPrice;            // Set the fixed SpaceImpulse token price
103     uint256 public maxCap = 0;            // Set the target maximum cap in ETH
104     address public FWDaddrETH;            // Set the address to forward the received ETH to
105     address public SpaceImpulseERC20;     // Set the SpaceImpulse ERC20 contract address
106     uint256 public totalSold;             // Keep track of the contributions total
107     uint256 public minPersonalCap;        // Set the minimal cap in ETH
108     uint256 public decimals = 18;         // The decimals to consider
109 
110     mapping (address => uint256) public sold;         // Map the SpaceImpulse token allcations
111 
112     uint256 public pubEnd;                            // Set the unixtime END for the public engagement
113     address contractAddr = this;                      // Better way to point to this from this
114 
115     // Constant to simplify the conversion of token amounts into integer form
116     uint256 public tokenUnit = uint256(10)**decimals;
117 
118 
119 
120     //
121     // "toETHaddr" is the address to which the ETH contributions are forwarded to, aka FWDaddrETH
122     // "SpaceImpulseERC20" is the address of the SpaceImpulseERC20 token contract.
123     //
124     // NOTE: this contract will sell only its token balance on the ERC20 specified in SpaceImpulseERC20
125     //       the maxCap in ETH and the tokenPrice will indirectly set the SpaceImpulse token amount on sale
126     //
127     // NOTE: this contract should have sufficient SpaceImpulse token balance to be > maxCap / tokenPrice
128     //
129     // NOTE: this contract will stop REGARDLESS of the above (maxCap) when its token balance is all sold
130     //
131     // The Owner of this contract can set: Price, End, MaxCap, SpaceImpulseERC20 and ETH Forward address
132     //
133     // The received ETH are directly forwarded to the external FWDaddrETH address
134     // The SpaceImpulse tokens are transferred to the contributing addresses once withdrawPUB is executed
135     //
136 
137 
138     constructor
139         (
140         address SpaceImpulse_ERC20
141         ) public {
142         FWDaddrETH = 0xD9614b3FaC2B523504AbC18104e4B32EE0605855;
143         SpaceImpulseERC20 = SpaceImpulse_ERC20;
144         tokenPrice = 150000000000000;
145         minPersonalCap = 150000000000000000;
146         pubEnd = 1540987140;
147 
148     }
149 
150     function () public payable {
151         buy();               // Allow to buy tokens sending ETH directly to the contract, fallback
152     }
153 
154     function setFWDaddrETH(address _value) public onlyOwner {
155       FWDaddrETH = _value;     // Set the forward address default toETHaddr
156 
157     }
158 
159 
160     function setSpaceImpulse(address _value) public onlyOwner {
161       SpaceImpulseERC20 = _value;     // Set the SpaceImpulseERC20 contract address
162 
163     }
164 
165 
166     function setMaxCap(uint256 _value) public onlyOwner {
167       maxCap = _value;         // Set the max cap in ETH default 0
168 
169     }
170 
171 
172     function setPrice(uint256 _value) public onlyOwner {
173       tokenPrice = _value;     // Set the token price default 0
174 
175     }
176 
177 
178     function setPubEnd(uint256 _value) public onlyOwner {
179       pubEnd = _value;         // Set the END of the public engagement unixtime default 0
180 
181     }
182 
183     function setMinPersonalCap(uint256 _value) public onlyOwner {
184       minPersonalCap = _value;  // Set min amount to buy
185     }
186 
187 
188 
189     function buy() public payable {
190 
191         require(block.timestamp < pubEnd);          // Require the current unixtime to be lower than the END unixtime
192         require(msg.value > 0);                     // Require the sender to send an ETH tx higher than 0
193         require(msg.value <= msg.sender.balance + msg.value);   // Require the sender to have sufficient ETH balance for the tx
194         require(msg.value >= minPersonalCap);        // Require sender eth amount be higher than minPersonalCap
195 
196         // Requiring this to avoid going out of tokens, aka we are getting just true/false from the transfer call
197         require(msg.value + totalSold <= maxCap);
198 
199         // Calculate the amount of tokens per contribution
200         uint256 tokenAmount = (msg.value * tokenUnit) / tokenPrice;
201 
202         // Requiring sufficient token balance on this contract to accept the tx
203         require(tokenAmount + ((totalSold * tokenUnit) / tokenPrice)<=TokenCHK(SpaceImpulseERC20).balanceOf(contractAddr));
204 
205         transferBuy(msg.sender, tokenAmount);       // Instruct the accounting function
206         totalSold = totalSold.add(msg.value);       // Account for the total contributed/sold
207         FWDaddrETH.transfer(msg.value);             // Forward the ETH received to the external address
208 
209     }
210 
211 
212 
213 
214     function withdrawPUB() public returns(bool){
215 
216         require(block.timestamp > pubEnd);          // Require the SpaceImpulse to be over - actual time higher than end unixtime
217         require(sold[msg.sender] > 0);              // Require the SpaceImpulseERC20 token balance to be sent to be higher than 0
218 
219         // Send SpaceImpulseERC20 tokens to the contributors proportionally to their contribution/s
220         if(!SpaceImpulseERC20.call(bytes4(keccak256("transfer(address,uint256)")), msg.sender, sold[msg.sender])){revert();}
221 
222         delete sold[msg.sender];
223         return true;
224 
225     }
226 
227 
228 
229 
230     function transferBuy(address _to, uint256 _value) internal returns (bool) {
231 
232         require(_to != address(0));                 // Require the destination address being non-zero
233 
234         sold[_to] = sold[_to].add(_value);            // Account for multiple txs from the same address
235 
236         return true;
237 
238     }
239 
240 
241 
242         //
243         // Probably the sky would fall down first but, in case skynet feels funny..
244         // ..we try to make sure anyway that no ETH would get stuck in this contract
245         //
246     function EMGwithdraw(uint256 weiValue) external onlyOwner {
247         require(block.timestamp > pubEnd);          // Require the public engagement to be over
248         require(weiValue > 0);                      // Require a non-zero value
249 
250         FWDaddrETH.transfer(weiValue);              // Transfer to the external ETH forward address
251     }
252 
253     function sweep(address _token, uint256 _amount) public onlyOwner {
254         TokenCHK token = TokenCHK(_token);
255 
256         if(!token.transfer(owner, _amount)) {
257             revert();
258         }
259     }
260 
261 }