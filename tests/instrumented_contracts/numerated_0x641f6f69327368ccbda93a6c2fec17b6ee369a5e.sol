1 pragma solidity ^0.4.8;
2 contract ERC20 {
3 
4   function totalSupply() public view returns (uint256);
5   function allowance(address owner, address spender) public view returns (uint256);
6   function transferFrom(address from, address to, uint256 value) public returns (bool);
7   function approve(address spender, uint256 value) public returns (bool);
8 
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 
16 
17 contract SafeMath {
18 
19   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
20     uint256 z = x + y;
21     assert((z >= x) && (z >= y));
22     return z;
23   }
24 
25   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
26     assert(x >= y);
27     uint256 z = x - y;
28     return z;
29   }
30 
31   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
32     uint256 z = x * y;
33     assert((x == 0)||(z/x == y));
34     return z;
35   }
36 
37   function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 z = x / y;
40     return z;
41   }
42 }
43 
44 
45 contract StandardToken is ERC20, SafeMath {
46   /**
47   * @dev Fix for the ERC20 short address attack.
48    */
49   modifier onlyPayloadSize(uint size) {
50     require(msg.data.length >= size + 4) ;
51     _;
52   }
53 
54   mapping(address => uint256) balances;
55   mapping (address => mapping (address => uint256)) internal allowed;
56 
57   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool){
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60 
61     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
62     balances[_to] = safeAdd(balances[_to], _value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[_from]);
70     require(_value <= allowed[_from][msg.sender]);
71 
72     uint _allowance = allowed[_from][msg.sender];
73 
74     balances[_to] = safeAdd(balances[_to], _value);
75     balances[_from] = safeSubtract(balances[_from], _value);
76     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint) {
82     return balances[_owner];
83   }
84 
85   function approve(address _spender, uint _value) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) public view returns (uint) {
92     return allowed[_owner][_spender];
93   }
94 
95 }
96 
97 contract DPSToken is StandardToken {
98   string public name;
99   string public symbol;
100   uint256 public constant decimals = 18;
101   string public constant version = "1.0";
102   uint256 public total;   // 20 *10^8 HNC total
103 
104   function DPSToken(
105         uint256 initialSupply,
106         string tokenName,
107         string tokenSymbol
108     ) public {
109         total = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
110         balances[msg.sender] = total; // Give the creator all initial tokens
111         name = tokenName;                                   // Set the name for display purposes
112         symbol = tokenSymbol;                               // Set the symbol for display purposes
113         Transfer(0x0, msg.sender, total);   
114     }
115 
116   function totalSupply() public view returns (uint256) {
117     return total;
118   }
119 
120   function transfer(address _to, uint _value) public returns (bool) {
121     return super.transfer(_to,_value);
122   }
123 
124   function approve(address _spender, uint _value) public returns (bool) {
125     return super.approve(_spender,_value);
126   }
127 
128   function airdropToAddresses(address[] addrs, uint256 amount) public {
129     for (uint256 i = 0; i < addrs.length; i++) {
130       transfer(addrs[i], amount);
131     }
132   }
133 }