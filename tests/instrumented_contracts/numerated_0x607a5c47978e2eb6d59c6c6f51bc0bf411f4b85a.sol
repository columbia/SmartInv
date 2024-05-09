1 pragma solidity ^0.4.18;
2 
3 
4 contract Utils {
5     /**
6         constructor
7     */
8     function Utils() public {
9     }
10 
11     // verifies that an amount is greater than zero
12     modifier greaterThanZero(uint256 _amount) {
13         require(_amount > 0);
14         _;
15     }
16 
17     // validates an address - currently only checks that it isn't null
18     modifier validAddress(address _address) {
19         require(_address != address(0));
20         _;
21     }
22 
23     // verifies that the address is different than this contract address
24     modifier notThis(address _address) {
25         require(_address != address(this));
26         _;
27     }
28 
29     // Overflow protected math functions
30 
31     /**
32         @dev returns the sum of _x and _y, asserts if the calculation overflows
33 
34         @param _x   value 1
35         @param _y   value 2
36 
37         @return sum
38     */
39     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
40         uint256 z = _x + _y;
41         assert(z >= _x);
42         return z;
43     }
44 
45     /**
46         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
47 
48         @param _x   minuend
49         @param _y   subtrahend
50 
51         @return difference
52     */
53     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
54         assert(_x >= _y);
55         return _x - _y;
56     }
57 
58     /**
59         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
60 
61         @param _x   factor 1
62         @param _y   factor 2
63 
64         @return product
65     */
66     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
67         uint256 z = _x * _y;
68         assert(_x == 0 || z / _x == _y);
69         return z;
70     }
71 }
72 
73 contract IOwned {
74     // this function isn't abstract since the compiler emits automatically generated getter functions as external
75     function owner() public view returns (address) {}
76 
77     function transferOwnership(address _newOwner) public;
78     function acceptOwnership() public;
79 }
80 
81 contract Owned is IOwned {
82     address public owner;
83     address public newOwner;
84 
85     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
86 
87     /**
88         @dev constructor
89     */
90     function Owned() public {
91         owner = msg.sender;
92     }
93 
94     // allows execution by the owner only
95     modifier ownerOnly {
96         assert(msg.sender == owner);
97         _;
98     }
99 
100     /**
101         @dev allows transferring the contract ownership
102         the new owner still needs to accept the transfer
103         can only be called by the contract owner
104 
105         @param _newOwner    new contract owner
106     */
107     function transferOwnership(address _newOwner) public ownerOnly {
108         require(_newOwner != owner);
109         newOwner = _newOwner;
110     }
111 
112     /**
113         @dev used by a new owner to accept an ownership transfer
114     */
115     function acceptOwnership() public {
116         require(msg.sender == newOwner);
117         OwnerUpdate(owner, newOwner);
118         owner = newOwner;
119         newOwner = address(0);
120     }
121 }
122 
123 
124 
125 contract IBancorGasPriceLimit {
126     function gasPrice() public view returns (uint256) {}
127     function validateGasPrice(uint256) public view;
128 }
129 
130 
131 contract BancorGasPriceLimit is IBancorGasPriceLimit, Owned, Utils {
132     uint256 public gasPrice = 0 wei;    // maximum gas price for bancor transactions
133     
134     /**
135         @dev constructor
136 
137         @param _gasPrice    gas price limit
138     */
139     function BancorGasPriceLimit(uint256 _gasPrice)
140         public
141         greaterThanZero(_gasPrice)
142     {
143         gasPrice = _gasPrice;
144     }
145 
146     /*
147         @dev gas price getter
148 
149         @return the current gas price
150     */
151     function gasPrice() public view returns (uint256) {
152         return gasPrice;
153     }
154 
155     /*
156         @dev allows the owner to update the gas price limit
157 
158         @param _gasPrice    new gas price limit
159     */
160     function setGasPrice(uint256 _gasPrice)
161         public
162         ownerOnly
163         greaterThanZero(_gasPrice)
164     {
165         gasPrice = _gasPrice;
166     }
167 
168     /*
169         @dev validate that the given gas price is equal to the current network gas price
170 
171         @param _gasPrice    tested gas price
172     */
173     function validateGasPrice(uint256 _gasPrice)
174         public
175         view
176         greaterThanZero(_gasPrice)
177     {
178         require(_gasPrice <= gasPrice);
179     }
180 }