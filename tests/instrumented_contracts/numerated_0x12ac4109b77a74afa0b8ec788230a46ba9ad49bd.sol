1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant public returns (uint);
6   function allowance(address owner, address spender) constant public returns (uint);
7   function transfer(address to, uint value) public returns (bool ok);
8   function transferFrom(address from, address to, uint value) public returns (bool ok);
9   function approve(address spender, uint value) public returns (bool ok);
10   event Transfer(address indexed from, address indexed to, uint value);
11   event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 contract Ownable {
15   address public owner;
16 
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   modifier onlyOwner() {
22     if (msg.sender == owner)
23       _;
24   }
25 
26   function transferOwnership(address newOwner) onlyOwner public {
27     if (newOwner != address(0)) owner = newOwner;
28   }
29 
30 }
31 
32 contract TokenSpender {
33     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 contract SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   /**
65   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 contract InternationalFarmersToken is ERC20, SafeMath, Ownable {
83 
84   string public name;
85   string public symbol;
86   uint8 public decimals = 6;
87   string public version = 'v0.1'; 
88   uint public initialSupply;
89   uint public totalSupply;
90 
91   mapping(address => uint) balances;
92   mapping (address => mapping (address => uint)) allowed;
93 
94   function InternationalFarmersToken() public {
95     initialSupply = 90000000 * 10 ** uint256(decimals);
96     totalSupply = initialSupply;
97     balances[msg.sender] = totalSupply;
98     name = 'InternationalFarmersToken';   
99     symbol = 'IFT';
100   }
101 
102   function burn(uint256 _value) public returns (bool){
103     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
104     totalSupply = safeSub(totalSupply, _value);
105     Transfer(msg.sender, 0x0, _value);
106     return true;
107   }
108   
109     function _transfer(address _from, address _to, uint _value) internal {
110         // Prevent transfer to 0x0 address. Use burn() instead
111         require(_to != 0x0);
112         // Check if the sender has enough
113         require(balances[_from] >= _value);
114         // Check for overflows
115         require(balances[_to] + _value > balances[_to]);
116         // Save this for an assertion in the future
117         uint previousBalances = balances[_from] + balances[_to];
118         // Subtract from the sender
119         balances[_from] -= _value;
120         // Add the same to the recipient
121         balances[_to] += _value;
122         Transfer(_from, _to, _value);
123         // Asserts are used to use static analysis to find bugs in your code. They should never fail
124         assert(balances[_from] + balances[_to] == previousBalances);
125     }
126 
127   function transfer(address _to, uint _value) public returns (bool) {
128     balances[msg.sender] = safeSub(balances[msg.sender], _value);
129     balances[_to] = safeAdd(balances[_to], _value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
135     var _allowance = allowed[_from][msg.sender];
136     
137     balances[_to] = safeAdd(balances[_to], _value);
138     balances[_from] = safeSub(balances[_from], _value);
139     allowed[_from][msg.sender] = safeSub(_allowance, _value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   function balanceOf(address _owner) constant public returns (uint balance) {
145     return balances[_owner];
146   }
147 
148   function approve(address _spender, uint _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public{    
155       TokenSpender spender = TokenSpender(_spender);
156       if (approve(_spender, _value)) {
157           spender.receiveApproval(msg.sender, _value, this, _extraData);
158       }
159   }
160 
161   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
162     return allowed[_owner][_spender];
163   }
164   
165 }