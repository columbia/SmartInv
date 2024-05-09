1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Future Token Sale Lock Box
5 //
6 // Copyright (c) 2017 OpenST Ltd.
7 // https://simpletoken.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // SafeMath Library Implementation
14 //
15 // Copyright (c) 2017 OpenST Ltd.
16 // https://simpletoken.org/
17 //
18 // The MIT Licence.
19 //
20 // Based on the SafeMath library by the OpenZeppelin team.
21 // Copyright (c) 2016 Smart Contract Solutions, Inc.
22 // https://github.com/OpenZeppelin/zeppelin-solidity
23 // The MIT License.
24 // ----------------------------------------------------------------------------
25 
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a * b;
31 
32         assert(a == 0 || c / a == b);
33 
34         return c;
35     }
36 
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Solidity automatically throws when dividing by 0
40         uint256 c = a / b;
41 
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49 
50         return a - b;
51     }
52 
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56 
57         assert(c >= a);
58 
59         return c;
60     }
61 }
62 
63 //
64 // Implements basic ownership with 2-step transfers.
65 //
66 contract Owned {
67 
68     address public owner;
69     address public proposedOwner;
70 
71     event OwnershipTransferInitiated(address indexed _proposedOwner);
72     event OwnershipTransferCompleted(address indexed _newOwner);
73 
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79 
80     modifier onlyOwner() {
81         require(isOwner(msg.sender));
82         _;
83     }
84 
85 
86     function isOwner(address _address) internal view returns (bool) {
87         return (_address == owner);
88     }
89 
90 
91     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
92         proposedOwner = _proposedOwner;
93 
94         OwnershipTransferInitiated(_proposedOwner);
95 
96         return true;
97     }
98 
99 
100     function completeOwnershipTransfer() public returns (bool) {
101         require(msg.sender == proposedOwner);
102 
103         owner = proposedOwner;
104         proposedOwner = address(0);
105 
106         OwnershipTransferCompleted(owner);
107 
108         return true;
109     }
110 }
111 
112 contract ERC20Interface {
113 
114     event Transfer(address indexed _from, address indexed _to, uint256 _value);
115     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116 
117     function name() public view returns (string);
118     function symbol() public view returns (string);
119     function decimals() public view returns (uint8);
120     function totalSupply() public view returns (uint256);
121 
122     function balanceOf(address _owner) public view returns (uint256 balance);
123     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
124 
125     function transfer(address _to, uint256 _value) public returns (bool success);
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
127     function approve(address _spender, uint256 _value) public returns (bool success);
128 }
129 
130 /**
131    @title TokenSaleInterface
132    @dev Provides interface for calling TokenSale.endTime
133 */
134 contract TokenSaleInterface {
135     function endTime() public view returns (uint256);
136 }
137 
138 /**
139    @title FutureTokenSaleLockBox
140    @notice Holds tokens reserved for future token sales. Tokens cannot be transferred for at least six months.
141 */
142 contract FutureTokenSaleLockBox is Owned {
143     using SafeMath for uint256;
144 
145     // To enable transfers of tokens held by this contract
146     ERC20Interface public simpleToken;
147 
148     // To determine earliest unlock date after which tokens held by this contract can be transferred
149     TokenSaleInterface public tokenSale;
150 
151     // The unlock date is initially 26 weeks after tokenSale.endTime, but may be extended
152     uint256 public unlockDate;
153 
154     event UnlockDateExtended(uint256 _newDate);
155     event TokensTransferred(address indexed _to, uint256 _value);
156 
157     /**
158        @dev Constructor
159        @param _simpleToken SimpleToken contract
160        @param _tokenSale TokenSale contract
161     */
162     function FutureTokenSaleLockBox(ERC20Interface _simpleToken, TokenSaleInterface _tokenSale)
163              Owned()
164              public
165     {
166         require(address(_simpleToken) != address(0));
167         require(address(_tokenSale)   != address(0));
168 
169         simpleToken = _simpleToken;
170         tokenSale   = _tokenSale;
171         uint256 endTime = tokenSale.endTime();
172 
173         require(endTime > 0);
174 
175         unlockDate  = endTime.add(26 weeks);
176     }
177 
178     /**
179        @dev Limits execution to after unlock date
180     */
181     modifier onlyAfterUnlockDate() {
182         require(hasUnlockDatePassed());
183         _;
184     }
185 
186     /**
187        @dev Provides current time
188     */
189     function currentTime() public view returns (uint256) {
190         return now;
191     }
192 
193     /**
194        @dev Determines whether unlock date has passed
195     */
196     function hasUnlockDatePassed() public view returns (bool) {
197         return currentTime() >= unlockDate;
198     }
199 
200     /**
201        @dev Extends unlock date
202        @param _newDate new unlock date
203     */
204     function extendUnlockDate(uint256 _newDate) public onlyOwner returns (bool) {
205         require(_newDate > unlockDate);
206 
207         unlockDate = _newDate;
208         UnlockDateExtended(_newDate);
209 
210         return true;
211     }
212 
213     /**
214        @dev Transfers tokens held by this contract
215        @param _to account to which to transfer tokens
216        @param _value value of tokens to transfer
217     */
218     function transfer(address _to, uint256 _value) public onlyOwner onlyAfterUnlockDate returns (bool) {
219         require(simpleToken.transfer(_to, _value));
220 
221         TokensTransferred(_to, _value);
222 
223         return true;
224     }
225 }