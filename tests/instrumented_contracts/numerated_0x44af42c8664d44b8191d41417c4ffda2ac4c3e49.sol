1 /*
2     
3     Implements the the VSU Payments contract using MilitaryToken™, the
4     true cryptocurrency token for www.MilitaryToken.io "Blockchain 
5     for a better world". Copyright 2017, 2018 by MilitaryToken, LLC.
6     
7     All of the following might at times be used to refer to this coin: "MILS", 
8     "MILs", "MIL$", "$MILS", "$MILs", "$MIL$", "MilitaryToken". In social 
9     settings we prefer the text "MILs" but in formal listings "MILS" and "$MILS" 
10     are the best symbols. In the Solidity code, the official symbol can be found 
11     below which is "MILS". 
12   
13     Portions of this code fall under the following license where noted as from
14     "OpenZepplin":
15 
16     The MIT License (MIT)
17 
18     Copyright (c) 2016 Smart Contract Solutions, Inc.
19 
20     Permission is hereby granted, free of charge, to any person obtaining
21     a copy of this software and associated documentation files (the
22     "Software"), to deal in the Software without restriction, including
23     without limitation the rights to use, copy, modify, merge, publish,
24     distribute, sublicense, and/or sell copies of the Software, and to
25     permit persons to whom the Software is furnished to do so, subject to
26     the following conditions:
27 
28     The above copyright notice and this permission notice shall be included
29     in all copies or substantial portions of the Software.
30 
31     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
32     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
33     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
34     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
35     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
36     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
37     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
38 
39 */
40 
41 pragma solidity 0.4.24;
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
48  */
49 library SafeMath {
50 
51     /**
52     * @dev Multiplies two numbers, throws on overflow.
53     */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55         if (a == 0) {
56         return 0;
57         }
58         c = a * b;
59         assert(c / a == b);
60         return c;
61     }
62 
63     /**
64     * @dev Integer division of two numbers, truncating the quotient.
65     */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a / b;
68     }
69 
70     /**
71     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     /**
79     * @dev Adds two numbers, throws on overflow.
80     */
81     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
82         c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 }
87 
88 contract Token {
89     function balanceOf(address _owner) public view returns (uint256 balance);
90     function transfer(address _to, uint256 _value) public returns (bool success);
91 }
92 
93     
94 /**
95     @title VSUpayments
96     @author Stanford K. Easley
97 
98 */
99 contract VSUpayments {
100 
101     using SafeMath for uint256;
102 
103     Token public militaryToken;
104     address public owner;
105     uint public lockUpEnd;
106     uint public awardsEnd;
107     mapping (address => uint256) public award;
108     mapping (address => uint256) public withdrawn;
109     uint256 public totalAwards = 0;
110     uint256 public currentAwards = 0;
111 
112     /**
113         @param _militaryToken The address of the MilitaryToken contract.
114     */
115     constructor(address _militaryToken) public {
116         militaryToken = Token(_militaryToken);
117         owner = msg.sender;
118         lockUpEnd = now + (365 days);
119         awardsEnd = now + (730 days);
120     }
121 
122     /**
123         @dev Restricts privileged functions to the contract owner.
124     */
125     modifier onlyOwner() {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     /**
131         @dev Functions that can only be called before the end of the lock-up period.
132     */
133     modifier preEnd() {
134         require(now < lockUpEnd);
135         _;
136     }
137 
138     /**
139         @dev Functions that can only be called after the end of the lock-up period.
140     */
141     modifier postEnd() {
142         require(lockUpEnd <= now);
143         _;
144     }
145 
146     /**
147         @dev Functions that can only be called if the awards are fully funded.
148      */
149     modifier funded() {
150         require(currentAwards <= militaryToken.balanceOf(address(this)));
151         _;
152     }
153 
154     modifier awardsAllowed() {
155         require(now < awardsEnd);
156         _;
157     }
158 
159     /**
160         @notice Changes contract ownership.
161         @param  newOwner The address of the new owner.
162     */
163     function transferOwnership(address newOwner) public onlyOwner {
164         if(newOwner != address(0)) {
165             owner = newOwner;
166         }
167     }
168 
169     /**
170         @notice Award MILs to people that will become available after lock-up period (if funded).
171         @param _to The address that the MILs are being awarded to.  After lock-up period awardee will be able to acquire awarded tokens.
172         @param _MILs The number of MILS being awarded.
173     */
174     function awardMILsTo(address _to, uint256 _MILs) public onlyOwner awardsAllowed {
175         
176         award[_to] = award[_to].add(_MILs);
177         totalAwards = totalAwards.add(_MILs);
178         currentAwards = currentAwards.add(_MILs);
179     }
180 
181     /**
182         @notice Transfers awarded MILs to the caller's account.
183     */
184     function withdrawMILs(uint256 _MILs) public postEnd funded {
185         uint256 daysSinceEnd = (now - lockUpEnd) / 1 days;
186         uint256 maxPct = min(((daysSinceEnd / 30 + 1) * 25), 100);
187         uint256 allowed = award[msg.sender];
188         allowed = allowed * maxPct / 100;
189         allowed -= withdrawn[msg.sender];
190         require(_MILs <= allowed);
191         militaryToken.transfer(msg.sender, _MILs);
192         withdrawn[msg.sender] += _MILs;
193         currentAwards -= _MILs;
194     }
195 
196     /**
197         @notice Transfers any un-awarded MILs to the contract owner.
198     */
199     function recoverUnawardedMILs() public  {
200         uint256 MILs = militaryToken.balanceOf(address(this));
201         if(totalAwards < MILs) {
202             militaryToken.transfer(owner, MILs - totalAwards);
203         }
204     }
205 
206     function min(uint a, uint b) private pure returns (uint) {
207         return a < b ? a : b;
208     }
209 }