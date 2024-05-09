1 contract ERC20 {
2 
3   function totalSupply() public view returns (uint256);
4   function allowance(address owner, address spender) public view returns (uint256);
5   function transferFrom(address from, address to, uint256 value) public returns (bool);
6   function approve(address spender, uint256 value) public returns (bool);
7 
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract SafeMath {
15 
16   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
17     uint256 z = x + y;
18     assert((z >= x) && (z >= y));
19     return z;
20   }
21 
22   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
23     assert(x >= y);
24     uint256 z = x - y;
25     return z;
26   }
27 
28   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
29     uint256 z = x * y;
30     assert((x == 0)||(z/x == y));
31     return z;
32   }
33 
34   function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 z = x / y;
37     return z;
38   }
39 }
40 
41 
42 contract StandardToken is ERC20, SafeMath {
43   /**
44   * @dev Fix for the ERC20 short address attack.
45    */
46   modifier onlyPayloadSize(uint size) {
47     require(msg.data.length >= size + 4) ;
48     _;
49   }
50 
51   mapping(address => uint256) balances;
52   mapping (address => mapping (address => uint256)) internal allowed;
53 
54   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool){
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57 
58     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
59     balances[_to] = safeAdd(balances[_to], _value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[_from]);
67     require(_value <= allowed[_from][msg.sender]);
68 
69     uint _allowance = allowed[_from][msg.sender];
70 
71     balances[_to] = safeAdd(balances[_to], _value);
72     balances[_from] = safeSubtract(balances[_from], _value);
73     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
74     Transfer(_from, _to, _value);
75     return true;
76   }
77 
78   function balanceOf(address _owner) public view returns (uint) {
79     return balances[_owner];
80   }
81 
82   function approve(address _spender, uint _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   function allowance(address _owner, address _spender) public view returns (uint) {
89     return allowed[_owner][_spender];
90   }
91 
92 }
93 
94 contract BlockchainFUN is StandardToken {
95   string public name;
96   string public symbol;
97   uint256 public constant decimals = 18;
98   string public constant version = "1.0";
99   uint256 public total;   // 20 *10^8 HNC total
100 
101   function BlockchainFUN(
102         uint256 initialSupply,
103         string tokenName,
104         string tokenSymbol
105     ) public {
106         total = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
107         balances[msg.sender] = total; // Give the creator all initial tokens
108         name = tokenName;                                   // Set the name for display purposes
109         symbol = tokenSymbol;                               // Set the symbol for display purposes
110         Transfer(0x0, msg.sender, total);   
111     }
112 
113   function totalSupply() public view returns (uint256) {
114     return total;
115   }
116 
117   function transfer(address _to, uint _value) public returns (bool) {
118     return super.transfer(_to,_value);
119   }
120 
121   function approve(address _spender, uint _value) public returns (bool) {
122     return super.approve(_spender,_value);
123   }
124 
125   function airdropToAddresses(address[] addrs, uint256 amount) public {
126     for (uint256 i = 0; i < addrs.length; i++) {
127       transfer(addrs[i], amount);
128     }
129   }
130 }