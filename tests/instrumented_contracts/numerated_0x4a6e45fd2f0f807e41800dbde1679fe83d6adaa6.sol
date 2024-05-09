1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Owned - Ownership model with 2 phase transfers
5 // Enuma Blockchain Platform
6 //
7 // Copyright (c) 2017 Enuma Technologies.
8 // https://www.enuma.io/
9 // ----------------------------------------------------------------------------
10 
11 
12 // Implements a simple ownership model with 2-phase transfer.
13 contract Owned {
14 
15    address public owner;
16    address public proposedOwner;
17 
18    event OwnershipTransferInitiated(address indexed _proposedOwner);
19    event OwnershipTransferCompleted(address indexed _newOwner);
20 
21 
22    function Owned() public
23    {
24       owner = msg.sender;
25    }
26 
27 
28    modifier onlyOwner() {
29       require(isOwner(msg.sender) == true);
30       _;
31    }
32 
33 
34    function isOwner(address _address) public view returns (bool) {
35       return (_address == owner);
36    }
37 
38 
39    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
40       require(_proposedOwner != address(0));
41       require(_proposedOwner != address(this));
42       require(_proposedOwner != owner);
43 
44       proposedOwner = _proposedOwner;
45 
46       OwnershipTransferInitiated(proposedOwner);
47 
48       return true;
49    }
50 
51 
52    function completeOwnershipTransfer() public returns (bool) {
53       require(msg.sender == proposedOwner);
54 
55       owner = msg.sender;
56       proposedOwner = address(0);
57 
58       OwnershipTransferCompleted(owner);
59 
60       return true;
61    }
62 }
63 
64 // ----------------------------------------------------------------------------
65 // Math - General Math Utility Library
66 // Enuma Blockchain Platform
67 //
68 // Copyright (c) 2017 Enuma Technologies.
69 // https://www.enuma.io/
70 // ----------------------------------------------------------------------------
71 
72 
73 library Math {
74 
75    function add(uint256 a, uint256 b) internal pure returns (uint256) {
76       uint256 r = a + b;
77 
78       require(r >= a);
79 
80       return r;
81    }
82 
83 
84    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85       require(a >= b);
86 
87       return a - b;
88    }
89 
90 
91    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92       if (a == 0) {
93          return 0;
94       }
95 
96       uint256 r = a * b;
97 
98       require(r / a == b);
99 
100       return r;
101    }
102 
103 
104    function div(uint256 a, uint256 b) internal pure returns (uint256) {
105       return a / b;
106    }
107 }
108 
109 // ----------------------------------------------------------------------------
110 // ERC20Interface - Standard ERC20 Interface Definition
111 // Enuma Blockchain Platform
112 //
113 // Copyright (c) 2017 Enuma Technologies.
114 // https://www.enuma.io/
115 // ----------------------------------------------------------------------------
116 
117 // ----------------------------------------------------------------------------
118 // Based on the final ERC20 specification at:
119 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
120 // ----------------------------------------------------------------------------
121 contract ERC20Interface {
122 
123    event Transfer(address indexed _from, address indexed _to, uint256 _value);
124    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
125 
126    function name() public view returns (string);
127    function symbol() public view returns (string);
128    function decimals() public view returns (uint8);
129    function totalSupply() public view returns (uint256);
130 
131    function balanceOf(address _owner) public view returns (uint256 balance);
132    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
133 
134    function transfer(address _to, uint256 _value) public returns (bool success);
135    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
136    function approve(address _spender, uint256 _value) public returns (bool success);
137 }
138 
139 // ----------------------------------------------------------------------------
140 // ERC20Batch - Contract to help batching ERC20 operations.
141 // Enuma Blockchain Platform
142 //
143 // Copyright (c) 2017 Enuma Technologies.
144 // https://www.enuma.io/
145 // ----------------------------------------------------------------------------
146 
147 
148 contract ERC20Batch is Owned {
149 
150    using Math for uint256;
151 
152    ERC20Interface public token;
153    address public tokenHolder;
154 
155 
156    event TransferFromBatchCompleted(uint256 _batchSize);
157 
158 
159    function ERC20Batch(address _token, address _tokenHolder) public
160       Owned()
161    {
162       require(_token != address(0));
163       require(_tokenHolder != address(0));
164 
165       token = ERC20Interface(_token);
166       tokenHolder = _tokenHolder;
167    }
168 
169 
170    function transferFromBatch(address[] _toArray, uint256[] _valueArray) public onlyOwner returns (bool success) {
171       require(_toArray.length == _valueArray.length);
172       require(_toArray.length > 0);
173 
174       for (uint256 i = 0; i < _toArray.length; i++) {
175          require(token.transferFrom(tokenHolder, _toArray[i], _valueArray[i]));
176       }
177 
178       TransferFromBatchCompleted(_toArray.length);
179 
180       return true;
181    }
182 }