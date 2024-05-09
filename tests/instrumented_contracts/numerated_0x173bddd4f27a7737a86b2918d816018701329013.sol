1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 contract kkICOTest77 {
7     
8     string public name;
9     string public symbol;
10     
11     uint256 public decimals;
12     uint256 public INITIAL_SUPPLY;
13     uint256 public totalSupply;
14     
15     uint256 public rate;
16   
17     address public owner;						    //init owner address?
18 	uint256 public tokens;							//init the coin supply var
19 	
20 	uint256 public amount;
21 	
22 	
23 	function kkICOTest77() {			//This function gives the total supply to the contract
24         name = "kkTEST77";
25         symbol = "kkTST77";
26         
27         decimals = 0;
28         INITIAL_SUPPLY = 30000000;
29         
30         rate = 5000;
31 		
32 		owner = msg.sender;			    //Make owner of contract the creator
33 		tokens = INITIAL_SUPPLY;
34 		totalSupply = INITIAL_SUPPLY;
35 	}
36 	
37 	
38 	//This function is called when Ether is sent to the contract address
39 	//Even if 0 ether is sent.
40 	function () payable {
41 	    
42 	    uint256 tryAmount = div((mul(msg.value, rate)), 1 ether);           //Don't let people buy more tokens than there are.
43 	    
44 		if (msg.value == 0 || msg.value < 0 || tokens < tryAmount) {		//If zero ether is sent, kill. Do nothing. 
45 			throw;
46 		}
47 		
48 		buyTokens(msg.value);		//call buyTokens with the ether sent amount as an arg
49 
50 	}
51 	
52 	
53 	//This function takes the amount of ether sent and buys tokens
54 	//Then sends the tokens to buyer
55 	function buyTokens(uint256 etherSent) payable {	                //Take the etherSent var and do stuff
56 	    amount = 0;									                //set the 'amount' var back to zero
57 		amount = div((mul(etherSent, rate)), 1 ether);		//take sent ether, multiply it by the rate then divide by 1 ether.
58 		balances[msg.sender] += amount;                             //Send tokens to buyer
59 		tokens -= amount;		  					                //Subtract bought tokens from supply
60 		amount = 0;									                //set the 'amount' var back to zero
61 		
62 		
63 		owner.transfer(msg.value);					//Send the ETH to contract owner.
64 
65 	}
66 	
67 	
68 	
69 	
70 	
71 	
72 	
73   
74   event Transfer(address indexed from, address indexed to, uint256 value);
75   
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77   
78   
79   mapping(address => uint256) balances;
80 
81 
82   function transfer(address _to, uint256 _value) returns (bool) {
83     balances[msg.sender] = sub(balances[msg.sender], _value);
84     balances[_to] = add(balances[_to], _value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89 
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93   
94   mapping (address => mapping (address => uint256)) allowed;
95 
96 
97 
98   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
99     var _allowance = allowed[_from][msg.sender];
100 
101 
102     balances[_to] = add(balances[_to], _value);
103     balances[_from] = sub(balances[_from], _value);
104     allowed[_from][msg.sender] = sub(_allowance, _value);
105     Transfer(_from, _to, _value);
106     return true;
107   }
108 
109 
110   function approve(address _spender, uint256 _value) returns (bool) {
111 
112     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
113 
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119 
120   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }	
123 	
124 	
125 	
126 	
127 	
128   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
129     uint256 c = a * b;
130     assert(a == 0 || c / a == b);
131     return c;
132   }
133 
134   function div(uint256 a, uint256 b) internal constant returns (uint256) {
135     // assert(b > 0); // Solidity automatically throws when dividing by 0
136     uint256 c = a / b;
137     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138     return c;
139   }
140 
141   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
142     assert(b <= a);
143     return a - b;
144   }
145 
146   function add(uint256 a, uint256 b) internal constant returns (uint256) {
147     uint256 c = a + b;
148     assert(c >= a);
149     return c;
150   }
151 	
152 	
153 	
154 	
155 	
156 }