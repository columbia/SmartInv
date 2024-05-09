1 pragma solidity ^0.4.11;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant returns (address owner) { owner; }
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     Provides support and utilities for contract ownership
16 */
17 contract Owned is IOwned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnerUpdate(address _prevOwner, address _newOwner);
22 
23     /**
24         @dev constructor
25     */
26     function Owned() {
27         owner = msg.sender;
28     }
29 
30     // allows execution by the owner only
31     modifier ownerOnly {
32         assert(msg.sender == owner);
33         _;
34     }
35 
36     /**
37         @dev allows transferring the contract ownership
38         the new owner still needs to accept the transfer
39         can only be called by the contract owner
40 
41         @param _newOwner    new contract owner
42     */
43     function transferOwnership(address _newOwner) public ownerOnly {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     /**
49         @dev used by a new owner to accept an ownership transfer
50     */
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = 0x0;
56     }
57 }
58 
59 /*
60     Utilities & Common Modifiers
61 */
62 contract Utils {
63     /**
64         constructor
65     */
66     function Utils() {
67     }
68 
69     // verifies that an amount is greater than zero
70     modifier greaterThanZero(uint256 _amount) {
71         require(_amount > 0);
72         _;
73     }
74 
75     // validates an address - currently only checks that it isn't null
76     modifier validAddress(address _address) {
77         require(_address != 0x0);
78         _;
79     }
80 
81     // verifies that the address is different than this contract address
82     modifier notThis(address _address) {
83         require(_address != address(this));
84         _;
85     }
86 
87     // Overflow protected math functions
88 
89     /**
90         @dev returns the sum of _x and _y, asserts if the calculation overflows
91 
92         @param _x   value 1
93         @param _y   value 2
94 
95         @return sum
96     */
97     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
98         uint256 z = _x + _y;
99         assert(z >= _x);
100         return z;
101     }
102 
103     /**
104         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
105 
106         @param _x   minuend
107         @param _y   subtrahend
108 
109         @return difference
110     */
111     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
112         assert(_x >= _y);
113         return _x - _y;
114     }
115 
116     /**
117         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
118 
119         @param _x   factor 1
120         @param _y   factor 2
121 
122         @return product
123     */
124     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
125         uint256 z = _x * _y;
126         assert(_x == 0 || z / _x == _y);
127         return z;
128     }
129 }
130 
131 /*
132     Bancor Formula interface
133 */
134 contract IBancorFormula {
135     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
136     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
137 }
138 
139 /**
140     @dev the BancorFormulaProxy is an owned contract that serves as a single point of access
141     to the BancorFormula contract from all BancorChanger contract instances.
142     it allows upgrading the BancorFormula contract without the need to update each and every
143     BancorChanger contract instance individually.
144 */
145 contract BancorFormulaProxy is IBancorFormula, Owned, Utils {
146     IBancorFormula public formula;  // bancor calculation formula contract
147 
148     /**
149         @dev constructor
150 
151         @param _formula address of a bancor formula contract
152     */
153     function BancorFormulaProxy(IBancorFormula _formula)
154         validAddress(_formula)
155     {
156         formula = _formula;
157     }
158 
159     /*
160         @dev allows the owner to update the formula contract address
161 
162         @param _formula    address of a bancor formula contract
163     */
164     function setFormula(IBancorFormula _formula)
165         public
166         ownerOnly
167         validAddress(_formula)
168         notThis(_formula)
169     {
170         formula = _formula;
171     }
172 
173     /**
174         @dev proxy for the bancor formula purchase return calculation
175 
176         @param _supply             token total supply
177         @param _reserveBalance     total reserve
178         @param _reserveRatio       constant reserve ratio, 1-1000000
179         @param _depositAmount      deposit amount, in reserve token
180 
181         @return purchase return amount
182     */
183     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256) {
184         return formula.calculatePurchaseReturn(_supply, _reserveBalance, _reserveRatio, _depositAmount);
185      }
186 
187     /**
188         @dev proxy for the bancor formula sale return calculation
189 
190         @param _supply             token total supply
191         @param _reserveBalance     total reserve
192         @param _reserveRatio       constant reserve ratio, 1-1000000
193         @param _sellAmount         sell amount, in the token itself
194 
195         @return sale return amount
196     */
197     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256) {
198         return formula.calculateSaleReturn(_supply, _reserveBalance, _reserveRatio, _sellAmount);
199     }
200 }