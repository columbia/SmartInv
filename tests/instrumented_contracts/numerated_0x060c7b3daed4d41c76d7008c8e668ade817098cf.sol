1 pragma solidity ^0.4.24;
2 
3 /*
4 
5     Copyright 2018, Angelo A. M. & Vicent Nos & Mireia Puig
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
81 //:            ESSENTIA Public Engagement            ://
82 //:               https://essentia.one               ://
83 //:..................................................://
84 ////////////////////////////////////////////////////////
85 
86 
87 
88 
89 contract TokenCHK {
90 
91 
92   function balanceOf(address _owner) public pure returns (uint256 balance) {}
93 
94 
95 }
96 
97 
98 
99 
100 contract ESSENTIA_PE is Ownable {
101 
102     using SafeMath for uint256;
103 
104     string public name = "ESSENTIA Public Engagement";      // Extended name of this contract
105     uint256 public tokenPrice = 0;        // Set the fixed ESS token price
106     uint256 public maxCap = 0;            // Set the target maximum cap in ETH
107     address public FWDaddrETH;            // Set the address to forward the received ETH to
108     address public ESSgenesis;            // Set the ESSENTIA Genesis contract address
109     uint256 public totalSold;             // Keep track of the contributions total
110     uint256 public decimals = 18;         // The decimals to consider
111 
112     mapping (address => uint256) public sold;       // Map the ESS token allcations
113 
114     uint256 public pubEnd = 0;                      // Set the unixtime END for the public engagement
115     address contractAddr=this;                      // Better way to point to this from this
116 
117     // Constant to simplify the conversion of token amounts into integer form
118     uint256 public tokenUnit = uint256(10)**decimals;
119 
120 
121 
122     //
123     // "toETHaddr" is the address to which the ETH contributions are forwarded to, aka FWDaddrETH
124     // "addrESSgenesis" is the address of the Essentia ERC20 token contract, aka ESSgenesis
125     //
126     // NOTE: this contract will sell only its token balance on the ERC20 specified in addrESSgenesis
127     //       the maxCap in ETH and the tokenPrice will indirectly set the ESS token amount on sale
128     //
129     // NOTE: this contract should have sufficient ESS token balance to be > maxCap / tokenPrice
130     //
131     // NOTE: this contract will stop REGARDLESS of the above (maxCap) when its token balance is all sold 
132     //
133     // The Owner of this contract can set: Price, End, MaxCap, ESS Genesis and ETH Forward address
134     //
135     // The received ETH are directly forwarded to the external FWDaddrETH address
136     // The ESS tokens are transferred to the contributing addresses once withdrawPUB is executed
137     //
138 
139 
140     constructor
141         (
142         address toETHaddr,
143         address addrESSgenesis
144         ) public {
145         FWDaddrETH = toETHaddr;
146         ESSgenesis = addrESSgenesis;
147         
148     }
149 
150 
151 
152     function () public payable {
153         buy();               // Allow to buy tokens sending ETH directly to the contract, fallback
154     }
155 
156 
157 
158 
159     function setFWDaddrETH(address _value) public onlyOwner{
160       FWDaddrETH=_value;     // Set the forward address default toETHaddr
161 
162     }
163 
164 
165     function setGenesis(address _value) public onlyOwner{
166       ESSgenesis=_value;     // Set the ESS erc20 genesis contract address default ESSgenesis
167 
168     }
169 
170 
171     function setMaxCap(uint256 _value) public onlyOwner{
172       maxCap=_value;         // Set the max cap in ETH default 0
173 
174     }
175 
176 
177     function setPrice(uint256 _value) public onlyOwner{
178       tokenPrice=_value;     // Set the token price default 0
179 
180     }
181 
182 
183     function setPubEnd(uint256 _value) public onlyOwner{
184       pubEnd=_value;         // Set the END of the public engagement unixtime default 0
185 
186     }
187 
188 
189 
190 
191     function buy() public payable {
192 
193         require(block.timestamp < pubEnd);          // Require the current unixtime to be lower than the END unixtime
194         require(msg.value > 0);                     // Require the sender to send an ETH tx higher than 0
195         require(msg.value <= msg.sender.balance);   // Require the sender to have sufficient ETH balance for the tx
196 
197         // Requiring this to avoid going out of tokens, aka we are getting just true/false from the transfer call
198         require(msg.value + totalSold <= maxCap);
199 
200         // Calculate the amount of tokens per contribution
201         uint256 tokenAmount = (msg.value * tokenUnit) / tokenPrice;
202 
203         // Requiring sufficient token balance on this contract to accept the tx
204         require(tokenAmount<=TokenCHK(ESSgenesis).balanceOf(contractAddr));
205 
206         transferBuy(msg.sender, tokenAmount);       // Instruct the accounting function
207         totalSold = totalSold.add(msg.value);       // Account for the total contributed/sold
208         FWDaddrETH.transfer(msg.value);             // Forward the ETH received to the external address
209 
210     }
211 
212 
213 
214 
215     function withdrawPUB() public returns(bool){
216 
217         require(block.timestamp > pubEnd);          // Require the PE to be over - actual time higher than end unixtime
218         require(sold[msg.sender] > 0);              // Require the ESS token balance to be sent to be higher than 0
219 
220         // Send ESS tokens to the contributors proportionally to their contribution/s
221         if(!ESSgenesis.call(bytes4(keccak256("transfer(address,uint256)")), msg.sender, sold[msg.sender])){revert();}
222 
223         delete sold[msg.sender];
224         return true;
225 
226     }
227 
228 
229 
230 
231     function transferBuy(address _to, uint256 _value) internal returns (bool) {
232 
233         require(_to != address(0));                 // Require the destination address being non-zero
234 
235         sold[_to]=sold[_to].add(_value);            // Account for multiple txs from the same address
236 
237         return true;
238 
239     }
240 
241 
242 
243         //
244         // Probably the sky would fall down first but, in case skynet feels funny..
245         // ..we try to make sure anyway that no ETH would get stuck in this contract
246         //
247     function EMGwithdraw(uint256 weiValue) external onlyOwner {
248         require(block.timestamp > pubEnd);          // Require the public engagement to be over
249         require(weiValue > 0);                      // Require a non-zero value
250 
251         FWDaddrETH.transfer(weiValue);              // Transfer to the external ETH forward address
252     }
253 
254 }