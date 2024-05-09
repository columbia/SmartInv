1 contract SafeMath{
2   function safeMul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function safeDiv(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14 	
15 	function safeSub(uint a, uint b) internal returns (uint) {
16     	assert(b <= a);
17     	return a - b;
18   }
19 
20 	function safeAdd(uint a, uint b) internal returns (uint) {
21     	uint c = a + b;
22     	assert(c >= a);
23     	return c;
24   }
25 	function assert(bool assertion) internal {
26 	    if (!assertion) {
27 	      throw;
28 	    }
29 	}
30 }
31 
32 
33 contract ERC20{
34 
35  	function totalSupply() constant returns (uint256 totalSupply) {}
36 	function balanceOf(address _owner) constant returns (uint256 balance) {}
37 	function transfer(address _recipient, uint256 _value) returns (bool success) {}
38 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
39 	function approve(address _spender, uint256 _value) returns (bool success) {}
40 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
43 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44     event Burn(address indexed _owner,  uint256 _value);
45 
46 }
47 
48 contract GSD is ERC20, SafeMath{
49 	
50 	mapping(address => uint256) balances;
51 	address public owner = msg.sender;
52 
53 	uint256 public totalSupply;
54 
55 
56 	function balanceOf(address _owner) constant returns (uint256 balance) {
57 	    return balances[_owner];
58 	}
59 
60 	function transfer(address _to, uint256 _value) returns (bool success){
61 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
62 	    balances[_to] = safeAdd(balances[_to], _value);
63 	    Transfer(msg.sender, _to, _value);
64 	    return true;
65 	}
66 
67 	mapping (address => mapping (address => uint256)) allowed;
68 
69 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
70 	    var _allowance = allowed[_from][msg.sender];
71 	    
72 	    balances[_to] = safeAdd(balances[_to], _value);
73 	    balances[_from] = safeSub(balances[_from], _value);
74 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
75 	    Transfer(_from, _to, _value);
76 	    return true;
77 	}
78 
79 	function approve(address _spender, uint256 _value) returns (bool success) {
80 	    allowed[msg.sender][_spender] = _value;
81 	    Approval(msg.sender, _spender, _value);
82 	    return true;
83 	}
84 
85 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86 	    return allowed[_owner][_spender];
87 	}
88 	
89 	function burn(uint256 _value) public {
90     require(_value <= balances[msg.sender]);
91     address burner = msg.sender;
92     balances[burner] = safeSub(balances[burner],_value);
93     totalSupply=safeSub(totalSupply,_value);
94     Burn(burner, _value);
95   }
96 	
97 	function recycle (uint256 _value) returns (bool success){
98 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
99 	    balances[address(this)] = safeAdd(balances[address(this)], _value);
100 	    Transfer(msg.sender, address(this), _value);
101 	    return true;
102 	}
103 	
104 	function harvest () returns (bool success) {
105 	    require(msg.sender == owner);
106 	  
107 	  uint256[] times;
108 	  times[0]=1516746600; //10:30 1516747200
109 	  times[1]=1516748400; //11:00
110 	  
111 	  bool itsTime=false;
112 	  //uint256 starttime = 1518566400; //2018
113 	  
114 	  for (uint i=0; i<times.length;i++){
115 	      if ( now >= times[i] && now <=(times[i]+600) ) 
116 	      {itsTime=true; break;}
117 	  }
118 	  
119 	 
120 	 require(itsTime);
121 	 
122 	 uint256 Bal=balances[address(this)];
123 	 balances[owner] = safeAdd(Bal, balances[owner]);
124 	 balances[address(this)]=0;
125 	 Transfer(address(this),owner,Bal);
126 	 return true;
127 	  
128 	}
129 	
130 	string 	public name = "GSD";
131 	string 	public symbol = "GSD";
132 	uint 	public decimals = 18;
133 	uint 	public INITIAL_SUPPLY = 20000000000;
134 
135 	function GSD() {
136 	  totalSupply = INITIAL_SUPPLY;
137 	  balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
138 	}
139 }