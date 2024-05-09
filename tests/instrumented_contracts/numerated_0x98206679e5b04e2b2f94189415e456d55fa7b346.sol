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
79 //////////////////////////////////////////////////////////////
80 //                                                          //
81 //                ESSENTIA Public Engagement                //
82 //                   https://essentia.one                   //
83 //                                                          //
84 //////////////////////////////////////////////////////////////
85 
86 
87 
88 contract ESSENTIA_PE is Ownable {
89 
90     // Contract variables and constants
91     using SafeMath for uint256;
92 
93     uint256 public tokenPrice=0;
94     address public addrFWD;
95     address public token;
96     uint256 public decimals=18;
97     string public name="ESSENTIA Public Engagement";
98 
99     mapping (address => uint256) public sold;
100 
101     uint256 public pubEnd=0;
102     // constant to simplify conversion of token amounts into integer form
103     uint256 public tokenUnit = uint256(10)**decimals;
104 
105 
106 
107     // destAddr is the address to which the contributions are forwarded
108     // mastTokCon is the address of the main token contract corresponding to the erc20 to be sold
109     // NOTE the contract will sell only its token balance on the erc20 specified in mastTokCon
110 
111 
112     constructor
113         (
114         address destAddr,
115         address mastTokCon
116         ) public {
117         addrFWD = destAddr;
118         token = mastTokCon;
119     }
120 
121 
122 
123     function () public payable {
124         buy();   // Allow to buy tokens sending ether directly to the contract
125     }
126 
127 
128 
129     function setPrice(uint256 _value) public onlyOwner{
130       tokenPrice=_value;   // Set the price token default 0
131 
132     }
133 
134     function setaddrFWD(address _value) public onlyOwner{
135       addrFWD=_value;   // Set the forward address default destAddr
136 
137     }
138 
139     function setPubEnd(uint256 _value) public onlyOwner{
140       pubEnd=_value;   // Set the END of engagement unixtime default 0
141 
142     }
143 
144 
145 
146     function buy()  public payable {
147         require(block.timestamp<pubEnd);
148         require(msg.value>0);
149         uint256 tokenAmount = (msg.value * tokenUnit) / tokenPrice;   // Calculate the amount of tokens
150 
151         transferBuy(msg.sender, tokenAmount);
152         addrFWD.transfer(msg.value);
153     }
154 
155 
156 
157     function withdrawPUB() public returns(bool){
158         require(block.timestamp>pubEnd);   // Finalize and transfer
159         require(sold[msg.sender]>0);
160 
161 
162         bool result=token.call(bytes4(keccak256("transfer(address,uint256)")), msg.sender, sold[msg.sender]);
163         delete sold[msg.sender];
164         return result;
165     }
166 
167 
168 
169     function transferBuy(address _to, uint256 _value) internal returns (bool) {
170         require(_to != address(0));
171 
172         sold[_to]=sold[_to].add(_value);   // Account for multiple txs from the same address
173 
174         return true;
175 
176     }
177 }