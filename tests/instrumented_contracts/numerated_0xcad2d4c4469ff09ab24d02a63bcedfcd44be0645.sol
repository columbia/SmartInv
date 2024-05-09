1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.7.1;
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8 
9     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15 
16     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b <= a, "SafeMath: subtraction overflow");
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b > 0, "SafeMath: division by zero");
36         uint256 c = a / b;
37 
38         return c;
39     }
40 
41     function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b != 0, "SafeMath: modulo by zero");
43         return a % b;
44     }
45 }
46 
47 /**
48  * Crypto Accept Contract
49  */
50 contract CryptoAccept {
51     using SafeMath for uint256;
52     string public name;
53     string public symbol;
54     uint8 public decimals;
55     uint256 public totalSupply;
56     address public owner;
57 
58     mapping (address => uint256) public balanceOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor(
66         uint256 initialSupply,
67         string memory tokenName,
68         uint8 decimalUnits,
69         string memory tokenSymbol
70         ) {
71             balanceOf[msg.sender] = initialSupply;
72             totalSupply = initialSupply;
73             name = tokenName;
74             symbol = tokenSymbol;
75             decimals = decimalUnits;
76             owner = msg.sender;
77         }
78 
79     /**
80      * Transfer functions
81      */
82     function transfer(address _to, uint256 _value) public {
83         require(_to != address(this));
84         require(_to != address(0), "Cannot use zero address");
85         require(_value > 0, "Cannot use zero value");
86 
87         require (balanceOf[msg.sender] >= _value, "Balance not enough");         // Check if the sender has enough
88         require (balanceOf[_to] + _value >= balanceOf[_to], "Overflow" );        // Check for overflows
89         
90         uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];          
91         
92         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);               // Add the same to the recipient
94         
95         emit Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took place
96         
97         assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         require (_value > 0, "Cannot use zero");
102         
103         allowance[msg.sender][_spender] = _value;
104         
105         emit Approval(msg.sender, _spender, _value);
106         
107         return true;
108     }
109 
110     function multiTransfer(address[] memory _receivers, uint256[] memory _values) public returns (bool success) {
111         require(_receivers.length <= 200, "Too many recipients");
112 
113         for(uint256 i = 0; i < _receivers.length; i++) {
114             transfer(_receivers[i], _values[i]);
115         }
116 
117         return true;
118     }
119 
120     function multiTransferSingleValue(address[] memory _receivers, uint256 _value) public returns (bool success) {
121         uint256 toSend = _value * 10**18;
122 
123         require(_receivers.length <= 200, "Too many recipients");
124 
125         for(uint256 i = 0; i < _receivers.length; i++) {
126             transfer(_receivers[i], toSend);
127         }
128 
129         return true;
130     }
131 
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_to != address(0), "Cannot use zero address");
134         require(_value > 0, "Cannot use zero value");
135         
136         require( balanceOf[_from] >= _value, "Balance not enough" );
137         require( balanceOf[_to] + _value > balanceOf[_to], "Cannot overflow" );
138         
139         require( _value <= allowance[_from][msg.sender], "Cannot over allowance" );
140         
141         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
142         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
143         
144         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
145         
146         emit Transfer(_from, _to, _value);
147         
148         return true;
149     }
150 
151     /**
152      * Ownership functions
153      */
154     modifier onlyOwner() {
155         require(msg.sender == owner, "Ownable: caller is not the owner");
156         _;
157     }
158 
159     function transferOwnership(address _newOwner) public onlyOwner {
160         require(_newOwner != address(0));
161         emit OwnershipTransferred(owner, _newOwner);
162         owner = _newOwner;
163     }
164 
165     /**
166      * Burn functions
167      */
168     function burn(uint256 _value) external {
169         _burn(msg.sender, _value);
170     }
171 
172     function _burn(address _from, uint256 _value) internal {
173         require(_from != address(0), "ERC20: burn from the zero address");
174 
175         require(_value != 0);
176         require(_value <= balanceOf[_from]);
177 
178         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
179         totalSupply = SafeMath.safeSub(totalSupply, _value);
180 
181         emit Transfer(_from, address(0), _value);
182     }
183 }