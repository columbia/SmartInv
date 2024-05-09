1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 contract HouseICO {
7     
8     function name() constant returns (string) { return "House"; }
9     function symbol() constant returns (string) { return "HSE"; }
10     function decimals() constant returns (uint8) { return 0; }
11 	
12 
13     uint256 public INITIAL_SUPPLY;
14 	uint256 public totalSupply;
15 	
16 	uint256 public totalContrib;
17     
18     uint256 public rate;
19   
20     address public owner;						    //init owner address
21 	
22 	uint256 public amount;
23 	
24 	
25 	function HouseICO() {
26         INITIAL_SUPPLY = 30000000;                  //Starting coin supply
27 		totalSupply = 0;
28 		
29 		totalContrib = 0;
30         
31         rate = 5000;                                //How many tokens per ETH given
32 		
33 		owner = msg.sender;			                //Make owner of contract the creator
34 		
35 		balances[msg.sender] = INITIAL_SUPPLY;		//Send owner of contract all starting tokens
36 	}
37 	
38 	
39 	//This function is called when Ether is sent to the contract address
40 	//Even if 0 ether is sent.
41 	function () payable {
42 	    
43 	    uint256 tryAmount = div((mul(msg.value, rate)), 1 ether);                   //Don't let people buy more tokens than there are.
44 	    
45 		if (msg.value == 0 || msg.value < 0 || balanceOf(owner) < tryAmount) {		//If zero ether is sent, kill. Do nothing. 
46 			revert();
47 		}
48 		
49 	    amount = 0;									                //set the 'amount' var back to zero
50 		amount = div((mul(msg.value, rate)), 1 ether);				//take sent ether, multiply it by the rate then divide by 1 ether.
51 		transferFrom(owner, msg.sender, amount);                    //Send tokens to buyer
52 		totalSupply += amount;										//Keep track of how many have been sold.
53 		totalContrib = (totalContrib + msg.value);
54 		amount = 0;									                //set the 'amount' var back to zero
55 		
56 		
57 		owner.transfer(msg.value);					                //Send the ETH to contract owner.
58 
59 	}	
60 	
61 	
62 	
63   
64   event Transfer(address indexed _from, address indexed _to, uint256 _value);
65   
66   mapping(address => uint256) balances;
67 
68 
69     function transfer(address _to, uint256 _value) returns (bool success) {
70 
71         if (_value == 0) { return false; }
72 
73         uint256 fromBalance = balances[msg.sender];
74 
75         bool sufficientFunds = fromBalance >= _value;
76         bool overflowed = balances[_to] + _value < balances[_to];
77         
78         if (sufficientFunds && !overflowed) {
79             balances[msg.sender] -= _value;
80             balances[_to] += _value;
81             
82             Transfer(msg.sender, _to, _value);
83             return true;
84         } else { return false; }
85     }
86 
87 
88 
89     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
90 
91 
92 
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94 
95         if (_value == 0) { return false; }
96         
97         uint256 fromBalance = balances[owner];
98 
99         bool sufficientFunds = fromBalance >= _value;
100 
101         if (sufficientFunds) {
102             balances[_to] += _value;
103             balances[_from] -= _value;
104             
105             Transfer(_from, _to, _value);
106             return true;
107         } else { return false; }
108     }
109 
110 	
111     function getStats() constant returns (uint256, uint256) {
112         return (totalSupply, totalContrib);
113     }
114 
115 	
116 	
117   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
118     uint256 c = a * b;
119     assert(a == 0 || c / a == b);
120     return c;
121   }
122 
123   function div(uint256 a, uint256 b) internal constant returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   function add(uint256 a, uint256 b) internal constant returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 	
141 	
142 	
143 }