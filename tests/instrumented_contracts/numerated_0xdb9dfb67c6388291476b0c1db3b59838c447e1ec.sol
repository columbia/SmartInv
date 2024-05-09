1 pragma solidity ^0.4.15;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10 uint256 c = a * b;
11 assert(a == 0 || c / a == b);
12 return c;
13 }
14 
15 function div(uint256 a, uint256 b) internal constant returns (uint256) {
16 // assert(b > 0); // Solidity automatically throws when dividing by 0
17 uint256 c = a / b;
18 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19 return c;
20 }
21 
22 function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23 assert(b <= a);
24 return a - b;
25 }
26 
27 function add(uint256 a, uint256 b) internal constant returns (uint256) {
28 uint256 c = a + b;
29 assert(c >= a);
30 return c;
31 }
32 }
33 
34 contract ERC20 {
35 uint256 public totalSupply;
36 function balanceOf(address who) constant returns (uint256);
37 function transfer(address to, uint256 value) returns (bool);
38 event Transfer(address indexed from, address indexed to, uint256 value);
39 function allowance(address owner, address spender) constant returns (uint256);
40 function transferFrom(address from, address to, uint256 value) returns (bool);
41 function approve(address spender, uint256 value) returns (bool);
42 event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20 {
46 using SafeMath for uint256;
47 
48 mapping(address => uint256) balances;
49 mapping (address => mapping (address => uint256)) allowed;
50 modifier nonZeroEth(uint _value) {
51 require(_value > 0);
52 _;
53 }
54 
55 modifier onlyPayloadSize() {
56 require(msg.data.length >= 68);
57 _;
58 }
59 /**
60 * @dev transfer token for a specified address
61 * @param _to The address to transfer to.
62 * @param _value The amount to be transferred.
63 */
64 
65 function transfer(address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
66 if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]){
67 balances[msg.sender] = balances[msg.sender].sub(_value);
68 balances[_to] = balances[_to].add(_value);
69 Transfer(msg.sender, _to, _value);
70 return true;
71 }else{
72 return false;
73 }
74 }
75 
76 /**
77 * @dev Transfer tokens from one address to another
78 * @param _from address The address which you want to send tokens from
79 * @param _to address The address which you want to transfer to
80 * @param _value uint256 the amout of tokens to be transfered
81 */
82 
83 function transferFrom(address _from, address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
84 if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]){
85 uint256 _allowance = allowed[_from][msg.sender];
86 allowed[_from][msg.sender] = _allowance.sub(_value);
87 balances[_to] = balances[_to].add(_value);
88 balances[_from] = balances[_from].sub(_value);
89 Transfer(_from, _to, _value);
90 return true;
91 }else{
92 return false;
93 }
94 }
95 
96 
97 /**
98 * @dev Gets the balance of the specified address.
99 * @param _owner The address to query the the balance of.
100 * @return An uint256 representing the amount owned by the passed address.
101 */
102 
103 function balanceOf(address _owner) constant returns (uint256 balance) {
104 return balances[_owner];
105 }
106 
107 function approve(address _spender, uint256 _value) returns (bool) {
108 
109 // To change the approve amount you first have to reduce the addresses`
110 // allowance to zero by calling `approve(_spender, 0)` if it is not
111 // already 0 to mitigate the race condition described here:
112 // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113 require((_value == 0) || (allowed[msg.sender][_spender] == 0));
114 
115 allowed[msg.sender][_spender] = _value;
116 Approval(msg.sender, _spender, _value);
117 return true;
118 }
119 
120 /**
121 * @dev Function to check the amount of tokens that an owner allowed to a spender.
122 * @param _owner address The address which owns the funds.
123 * @param _spender address The address which will spend the funds.
124 * @return A uint256 specifing the amount of tokens still avaible for the spender.
125 */
126 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127 return allowed[_owner][_spender];
128 }
129 
130 }
131 
132 
133 contract RPTToken is BasicToken {
134 
135 using SafeMath for uint256;
136 
137 string public name = "RPT Token"; //name of the token
138 string public symbol = "RPT"; // symbol of the token
139 uint8 public decimals = 18; // decimals
140 uint256 public totalSupply = 100000000 * 10**18; // total supply of RPT Tokens
141 
142 // variables
143 uint256 public keyEmployeeAllocation; // fund allocated to key employee
144 uint256 public totalAllocatedTokens; // variable to regulate the funds allocation
145 uint256 public tokensAllocatedToCrowdFund; // funds allocated to crowdfund
146 
147 // addresses
148 address public founderMultiSigAddress = 0xf96E905091d38ca25e06C014fE67b5CA939eE83D; // multi sign address of founders which hold
149 address public crowdFundAddress; // address of crowdfund contract
150 
151 //events
152 event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
153 event TransferPreAllocatedFunds(uint256 _blockTimeStamp , address _to , uint256 _value);
154 
155 //modifiers
156 modifier onlyCrowdFundAddress() {
157 require(msg.sender == crowdFundAddress);
158 _;
159 }
160 
161 modifier nonZeroAddress(address _to) {
162 require(_to != 0x0);
163 _;
164 }
165 
166 modifier onlyFounders() {
167 require(msg.sender == founderMultiSigAddress);
168 _;
169 }
170 
171 // creation of the token contract
172 function RPTToken (address _crowdFundAddress) {
173 crowdFundAddress = _crowdFundAddress;
174 
175 // Token Distribution
176 tokensAllocatedToCrowdFund = 70 * 10 ** 24; // 70 % allocation of totalSupply
177 keyEmployeeAllocation = 30 * 10 ** 24; // 30 % allocation of totalSupply
178 
179 // Assigned balances to respective stakeholders
180 balances[founderMultiSigAddress] = keyEmployeeAllocation;
181 balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
182 
183 totalAllocatedTokens = balances[founderMultiSigAddress];
184 }
185 
186 // function to keep track of the total token allocation
187 function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
188 totalAllocatedTokens = totalAllocatedTokens.add(_amount);
189 }
190 
191 // function to change founder multisig wallet address
192 function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
193 founderMultiSigAddress = _newFounderMultiSigAddress;
194 ChangeFoundersWalletAddress(now, founderMultiSigAddress);
195 }
196 
197 }