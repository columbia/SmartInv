1 pragma solidity ^0.4.15;
2 
3 contract Utils {
4     /**
5         constructor
6     */
7     function Utils() internal {
8     }
9 
10     // validates an address - currently only checks that it isn't null
11     modifier validAddress(address _address) {
12         require(_address != 0x0);
13         _;
14     }
15 
16     // verifies that the address is different than this contract address
17     modifier notThis(address _address) {
18         require(_address != address(this));
19         _;
20     }
21 
22     // Overflow protected math functions
23 
24     /**
25         @dev returns the sum of _x and _y, asserts if the calculation overflows
26 
27         @param _x   value 1
28         @param _y   value 2
29 
30         @return sum
31     */
32     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
33         uint256 z = _x + _y;
34         assert(z >= _x);
35         return z;
36     }
37 
38     /**
39         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
40 
41         @param _x   minuend
42         @param _y   subtrahend
43 
44         @return difference
45     */
46     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
47         assert(_x >= _y);
48         return _x - _y;
49     }
50 
51     /**
52         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
53 
54         @param _x   factor 1
55         @param _y   factor 2
56 
57         @return product
58     */
59     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
60         uint256 z = _x * _y;
61         assert(_x == 0 || z / _x == _y);
62         return z;
63     }
64 }
65 
66 /*
67     ERC20 Standard Token interface
68 */
69 contract IERC20Token {
70     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
71     function name() public constant returns (string) { name; }
72     function symbol() public constant returns (string) { symbol; }
73     function decimals() public constant returns (uint8) { decimals; }
74     function totalSupply() public constant returns (uint256) { totalSupply; }
75     function balanceOf(address _owner) public constant returns (uint256 balance);
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
77 
78     function transfer(address _to, uint256 _value) public returns (bool success);
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
80     function approve(address _spender, uint256 _value) public returns (bool success);
81 }
82 
83 
84 /*
85     Owned contract interface
86 */
87 contract IOwned {
88     // this function isn't abstract since the compiler emits automatically generated getter functions as external
89     function owner() public constant returns (address) { owner; }
90 
91     function transferOwnership(address _newOwner) public;
92     function acceptOwnership() public;
93 }
94 
95 /*
96     Provides support and utilities for contract ownership
97 */
98 contract Owned is IOwned {
99     address public owner;
100     address public newOwner;
101 
102     event OwnerUpdate(address _prevOwner, address _newOwner);
103 
104     /**
105         @dev constructor
106     */
107     function Owned() public {
108         owner = msg.sender;
109     }
110 
111     // allows execution by the owner only
112     modifier ownerOnly {
113         assert(msg.sender == owner);
114         _;
115     }
116 
117     /**
118         @dev allows transferring the contract ownership
119         the new owner still needs to accept the transfer
120         can only be called by the contract owner
121 
122         @param _newOwner    new contract owner
123     */
124     function transferOwnership(address _newOwner) public ownerOnly {
125         require(_newOwner != owner);
126         newOwner = _newOwner;
127     }
128 
129     /**
130         @dev used by a new owner to accept an ownership transfer
131     */
132     function acceptOwnership() public {
133         require(msg.sender == newOwner);
134         OwnerUpdate(owner, newOwner);
135         owner = newOwner;
136         newOwner = 0x0;
137     }
138 }
139 
140 contract YooStop is Owned{
141 
142     bool public stopped = false;
143 
144     modifier stoppable {
145         assert (!stopped);
146         _;
147     }
148     function stop() public ownerOnly{
149         stopped = true;
150     }
151     function start() public ownerOnly{
152         stopped = false;
153     }
154 
155 }
156 
157 
158 contract YoobaEarlyInvest is  Owned,YooStop,Utils {
159     IERC20Token public yoobaTokenAddress;
160 
161 
162     /**
163         @dev constructor
164         
165     */
166     function YoobaEarlyInvest(IERC20Token _yoobaTokenAddress) public{
167         yoobaTokenAddress = _yoobaTokenAddress;
168     }
169     
170 
171     
172     function withdrawTo(address _to, uint256 _amount)
173         public ownerOnly stoppable
174         notThis(_to)
175     {   
176         require(_amount <= this.balance);
177         _to.transfer(_amount); // send the amount to the target account
178     }
179     
180     function withdrawERC20TokenTo(IERC20Token _token, address _to, uint256 _amount)
181         public
182         ownerOnly
183         validAddress(_token)
184         validAddress(_to)
185         notThis(_to)
186     {
187         assert(_token.transfer(_to, _amount));
188 
189     }
190     
191     function buyToken() internal
192     {
193         require(!stopped && msg.value >= 0.1 ether);
194         uint256  amount = msg.value * 350000;
195         assert(yoobaTokenAddress.transfer(msg.sender, amount));
196     }
197 
198     function() public payable stoppable {
199         buyToken();
200     }
201 }