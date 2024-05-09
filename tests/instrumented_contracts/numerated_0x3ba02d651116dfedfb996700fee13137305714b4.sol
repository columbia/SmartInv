1 contract EtherDOGEICO {
2     
3     function name() constant returns (string) { return "EtherDOGE"; }
4     function symbol() constant returns (string) { return "eDOGE"; }
5     function decimals() constant returns (uint8) { return 4; }
6 	
7 
8     uint256 public INITIAL_SUPPLY;
9 	uint256 public totalSupply;
10 	
11 	uint256 public totalContrib;
12     
13     uint256 public rate;
14   
15     address public owner;						    //init owner address
16 	
17 	uint256 public amount;
18 	
19 	
20 	function EtherDOGEICO() {
21         INITIAL_SUPPLY = 210000000000;              //Starting EtherDOGE supply
22 		totalSupply = 0;
23 		
24 		totalContrib = 0;
25         
26         rate = 210000000;                           //How many EtherDOGE tokens per ETH given
27 		
28 		owner = msg.sender;			                //Make owner of contract the creator
29 		
30 		balances[msg.sender] = INITIAL_SUPPLY;		//Send owner of contract all starting tokens
31 	}
32 	
33 	
34 	//This function is called when Ether is sent to the contract address
35 	//Even if 0 ether is sent.
36 	function () payable {
37 	    
38 	    uint256 tryAmount = div((mul(msg.value, rate)), 1 ether);                   //Don't let people buy more tokens than there are.
39 	    
40 		if (msg.value == 0 || msg.value < 0 || balanceOf(owner) < tryAmount) {		//If zero ether is sent, kill. Do nothing. 
41 			revert();
42 		}
43 		
44 	    amount = 0;									                //set the 'amount' var back to zero
45 		amount = div((mul(msg.value, rate)), 1 ether);				//take sent ether, multiply it by the rate then divide by 1 ether.
46 		transferFrom(owner, msg.sender, amount);                    //Send tokens to buyer
47 		totalSupply += amount;										//Keep track of how many have been sold.
48 		totalContrib = (totalContrib + msg.value);
49 		amount = 0;									                //set the 'amount' var back to zero
50 		
51 		
52 		owner.transfer(msg.value);					                //Send the ETH to contract owner.
53 
54 	}	
55 	
56 	
57 	
58   
59   event Transfer(address indexed _from, address indexed _to, uint256 _value);
60   
61   mapping(address => uint256) balances;
62 
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65 
66         if (_value == 0) { return false; }
67 
68         uint256 fromBalance = balances[msg.sender];
69 
70         bool sufficientFunds = fromBalance >= _value;
71         bool overflowed = balances[_to] + _value < balances[_to];
72         
73         if (sufficientFunds && !overflowed) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             
77             Transfer(msg.sender, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82 
83 
84     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
85 
86 
87 
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89 
90         if (_value == 0) { return false; }
91         
92         uint256 fromBalance = balances[owner];
93 
94         bool sufficientFunds = fromBalance >= _value;
95 
96         if (sufficientFunds) {
97             balances[_to] += _value;
98             balances[_from] -= _value;
99             
100             Transfer(_from, _to, _value);
101             return true;
102         } else { return false; }
103     }
104 
105 	
106     function getStats() constant returns (uint256, uint256) {
107         return (totalSupply, totalContrib);
108     }
109 
110 	
111 	
112   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a * b;
114     assert(a == 0 || c / a == b);
115     return c;
116   }
117 
118   function div(uint256 a, uint256 b) internal constant returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return c;
123   }
124 
125   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   function add(uint256 a, uint256 b) internal constant returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 	
136 	
137 	
138 }