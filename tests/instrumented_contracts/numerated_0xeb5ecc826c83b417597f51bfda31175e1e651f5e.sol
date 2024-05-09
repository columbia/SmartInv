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
37  
38 }
39 
40 
41 
42 contract SafeMath {
43 
44   function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
45     uint256 z = x + y;
46     assert((z >= x) && (z >= y));
47     return z;
48   }
49 
50   function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
51     assert(x >= y);
52     uint256 z = x - y;
53     return z;
54   }
55 
56   function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
57     uint256 z = x * y;
58     assert((x == 0)||(z/x == y));
59     return z;
60   }
61 
62   function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 z = x / y;
65     return z;
66   }
67 }
68 
69 
70 contract StandardToken is ERC20, SafeMath {
71   /**
72   * @dev Fix for the ERC20 short address attack.
73    */
74   modifier onlyPayloadSize(uint size) {
75     require(msg.data.length >= size + 4) ;
76     _;
77   }
78 
79   mapping(address => uint256) balances;
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool){
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
87     balances[_to] = safeAdd(balances[_to], _value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[_from]);
95     require(_value <= allowed[_from][msg.sender]);
96 
97     uint _allowance = allowed[_from][msg.sender];
98 
99     balances[_to] = safeAdd(balances[_to], _value);
100     balances[_from] = safeSubtract(balances[_from], _value);
101     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
102     Transfer(_from, _to, _value);
103     return true;
104   }
105 
106   function balanceOf(address _owner) public view returns (uint) {
107     return balances[_owner];
108   }
109 
110   function approve(address _spender, uint _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   function allowance(address _owner, address _spender) public view returns (uint) {
117     return allowed[_owner][_spender];
118   }
119 
120 }
121 
122 contract Mohi is StandardToken {
123   string public constant name = "Mohi";
124   string public constant symbol = "MH";
125   uint256 public constant decimals = 18;
126   string public version = "1.0";
127 
128   uint256 public constant total = 50 * (10**7) * 10**decimals;   // 20 *10^7 MH total
129 
130   function Mohi() public {
131     balances[msg.sender] = total * 50/100;
132     Transfer(0x0, msg.sender, total);
133 	
134 	
135         balances[0x7ae3AB28486B245A7Eae3A9e15c334B61690D4B9] = total * 5 / 100;
136         balances[0xBd9E735e84695A825FB0051B02514BA36C57112E] = total * 5 / 100;
137         balances[0x6a5C43220cE62A6A5D11e2D11Cc9Ee9660893407] = total * 5 / 100;
138       
139 	
140 	
141   }
142 
143   function totalSupply() public view returns (uint256) {
144     return total;
145   }
146 
147   function transfer(address _to, uint _value) public returns (bool) {
148     return super.transfer(_to,_value);
149   }
150 
151   function approve(address _spender, uint _value) public returns (bool) {
152     return super.approve(_spender,_value);
153   }
154 
155   function airdropToAddresses(address[] addrs, uint256 amount) public {
156     for (uint256 i = 0; i < addrs.length; i++) {
157       transfer(addrs[i], amount);
158     }
159   }
160   
161   
162 }