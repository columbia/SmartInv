1 pragma solidity ^0.4.13;
2 contract owned { 
3     
4  address public owner;
5 
6   function owned() {
7       owner = msg.sender;
8   }
9 
10   modifier onlyOwner {
11       require(msg.sender == owner);
12       _;
13   }
14 
15   function transferOwnership(address newOwner) onlyOwner {
16       owner = newOwner;
17   }
18 }
19 
20 contract SafeMath{
21   function safeMul(uint a, uint b) internal returns (uint) {
22     uint c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function safeDiv(uint a, uint b) internal returns (uint) {
28     assert(b > 0);
29     uint c = a / b;
30     assert(a == b * c + a % b);
31     return c;
32   }
33 	
34 	function safeSub(uint a, uint b) internal returns (uint) {
35     	assert(b <= a);
36     	return a - b;
37   }
38 
39 	function safeAdd(uint a, uint b) internal returns (uint) {
40     	uint c = a + b;
41     	assert(c >= a);
42     	return c;
43   }
44 	function assert(bool assertion) internal {
45 	    if (!assertion) {
46 	      revert();
47 	    }
48 	}
49 }
50 
51 
52 contract ERC20{
53 
54  	function totalSupply() constant returns (uint256 totalSupply) {}
55 	function balanceOf(address _owner) constant returns (uint256 balance) {}
56 	function transfer(address _recipient, uint256 _value) returns (bool success) {}
57 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
58 	function approve(address _spender, uint256 _value) returns (bool success) {}
59 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
60 
61 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
62 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64 
65 }
66 contract PotatoCoin is ERC20, SafeMath, owned{
67 	
68 	mapping(address => uint256) balances;
69 
70 	uint256 public totalSupply;
71     uint256 public mulFactor;
72 
73 	function balanceOf(address _owner) constant returns (uint256 balance) {
74 	    return balances[_owner];
75 	}
76 
77 	function transfer(address _to, uint256 _value) returns (bool success){
78 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
79 	    balances[_to] = safeAdd(balances[_to], _value);
80 	    Transfer(msg.sender, _to, _value);
81 	    return true;
82 	}
83 
84 	mapping (address => mapping (address => uint256)) allowed;
85 
86 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
87 	    var _allowance = allowed[_from][msg.sender];
88 	
89 	    balances[_from] = safeSub(balances[_from], _value);
90 	    balances[_to] = safeAdd(balances[_to], _value);
91 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
92 	    Transfer(_from, _to, _value);
93 	    return true;
94 	}
95 
96 	function approve(address _spender, uint256 _value) returns (bool success) {
97 	    allowed[msg.sender][_spender] = _value;
98 	    Approval(msg.sender, _spender, _value);
99 	    return true;
100 	}
101 
102 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103 	    return allowed[_owner][_spender];
104 	}
105 	
106 	
107     function buy() payable { // makes the transfers
108         uint amount=safeDiv(safeMul(msg.value,mulFactor),1 ether);
109         allowed[this][msg.sender] = amount;
110         transferFrom(this,msg.sender,amount);
111 	    
112    
113     }
114     
115     function setMulFactor(uint256 newMulFactor) onlyOwner {
116         mulFactor = newMulFactor;
117     }
118     function addNewPotatoCoinsForSale (uint newTokens) onlyOwner {
119         balances[owner] -= newTokens;
120         balances[this] += newTokens;
121     }
122     function destroy() onlyOwner { // so funds not locked in contract forever
123       suicide(owner);
124     }
125     function transferFunds(address _beneficiary, uint amount) onlyOwner {
126          transfer(_beneficiary,amount);
127     }
128     function () payable {
129         uint amount=safeDiv(safeMul(msg.value,mulFactor),1 ether);
130         allowed[this][msg.sender] = amount;
131         transferFrom(this,msg.sender,amount);
132     }
133 
134 	
135 	string 	public name = "Potato Coin";
136 	string 	public symbol = "PTCN";
137 	uint 	public decimals = 0;
138 	uint 	public INITIAL_SUPPLY = 50000000;
139 	uint    public INITIAL_mulFactor=280;
140 
141 	function PotatoCoin() {
142 	  totalSupply = INITIAL_SUPPLY;
143 	  mulFactor = INITIAL_mulFactor;
144 	  balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
145 	  addNewPotatoCoinsForSale (50000);
146 	    
147 	}
148 }