1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) public onlyOwner {
19     require(newOwner != address(0));
20     OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 }
24 
25 
26 contract ERC20 {
27 
28   function totalSupply() public view returns (uint256);
29   function allowance(address owner, address spender) public view returns (uint256);
30   function transferFrom(address from, address to, uint256 value) public returns (bool);
31   function approve(address spender, uint256 value) public returns (bool);
32 
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 
40 
41 contract SafeMath {
42 
43   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
44     uint256 z = x + y;
45     assert((z >= x) && (z >= y));
46     return z;
47   }
48 
49   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
50     assert(x >= y);
51     uint256 z = x - y;
52     return z;
53   }
54 
55   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
56     uint256 z = x * y;
57     assert((x == 0)||(z/x == y));
58     return z;
59   }
60 
61   function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 z = x / y;
64     return z;
65   }
66 }
67 
68 
69 contract StandardToken is ERC20, SafeMath {
70   /**
71   * @dev Fix for the ERC20 short address attack.
72    */
73   modifier onlyPayloadSize(uint size) {
74     require(msg.data.length >= size + 4) ;
75     _;
76   }
77 
78   mapping(address => uint256) balances;
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
81   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool){
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
86     balances[_to] = safeAdd(balances[_to], _value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     uint _allowance = allowed[_from][msg.sender];
97 
98     balances[_to] = safeAdd(balances[_to], _value);
99     balances[_from] = safeSubtract(balances[_from], _value);
100     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function balanceOf(address _owner) public view returns (uint) {
106     return balances[_owner];
107   }
108 
109   function approve(address _spender, uint _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   function allowance(address _owner, address _spender) public view returns (uint) {
116     return allowed[_owner][_spender];
117   }
118 
119 }
120 
121 contract pank15 is StandardToken {
122   string public constant name = "pank15";
123   string public constant symbol = "p15";
124   uint256 public constant decimals = 18;
125   string public version = "1.0";
126 
127   uint256 public constant total = 20 * (10**7) * 10**decimals;   // 20 *10^7 HNC total
128 
129   function pank15() public {
130     balances[msg.sender] = total;
131     Transfer(0x0, msg.sender, total);
132   }
133 
134   function totalSupply() public view returns (uint256) {
135     return total;
136   }
137 
138   function transfer(address _to, uint _value) public returns (bool) {
139     return super.transfer(_to,_value);
140   }
141 
142   function approve(address _spender, uint _value) public returns (bool) {
143     return super.approve(_spender,_value);
144   }
145 
146   function airdropToAddresses(address[] addrs, uint256 amount) public {
147     for (uint256 i = 0; i < addrs.length; i++) {
148       transfer(addrs[i], amount);
149     }
150   }
151 }