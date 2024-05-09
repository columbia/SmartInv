1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 contract kkICOTest80 {
7     
8     string public name;
9     string public symbol;
10     
11     uint256 public decimals;
12     uint256 public INITIAL_SUPPLY;
13     
14     uint256 public rate;
15   
16     address public owner;						    //init owner address
17 	
18 	uint256 public amount;
19 	
20 	
21 	function kkICOTest80() {
22         name = "kkTEST80";
23         symbol = "kkTST80";
24         
25         decimals = 0;
26         INITIAL_SUPPLY = 30000000;                  //Starting coin supply
27         
28         rate = 5000;                                //How many tokens per ETH given
29 		
30 		owner = msg.sender;			                //Make owner of contract the creator
31 		
32 		balances[msg.sender] = INITIAL_SUPPLY;		//Send owner of contract all starting tokens
33 	}
34 	
35 	
36 	//This function is called when Ether is sent to the contract address
37 	//Even if 0 ether is sent.
38 	function () payable {
39 	    
40 	    uint256 tryAmount = div((mul(msg.value, rate)), 1 ether);                   //Don't let people buy more tokens than there are.
41 	    
42 		if (msg.value == 0 || msg.value < 0 || balanceOf(owner) < tryAmount) {		//If zero ether is sent, kill. Do nothing. 
43 			throw;
44 		}
45 		
46 	    amount = 0;									                //set the 'amount' var back to zero
47 		amount = div((mul(msg.value, rate)), 1 ether);				//take sent ether, multiply it by the rate then divide by 1 ether.
48 		transferFrom(owner, msg.sender, amount);                    //Send tokens to buyer
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
59   event Transfer(address indexed from, address indexed to, uint256 value);
60   
61   
62   mapping(address => uint256) balances;
63 
64 
65   function transfer(address _to, uint256 _value) returns (bool) {
66     balances[msg.sender] = sub(balances[msg.sender], _value);
67     balances[_to] = add(balances[_to], _value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72 
73 
74   function balanceOf(address _owner) constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 
79 
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
81     balances[_to] = add(balances[_to], _value);
82     balances[_from] = sub(balances[_from], _value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87 	
88 	
89 
90 	
91 	
92   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
93     uint256 c = a * b;
94     assert(a == 0 || c / a == b);
95     return c;
96   }
97 
98   function div(uint256 a, uint256 b) internal constant returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   function add(uint256 a, uint256 b) internal constant returns (uint256) {
111     uint256 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 	
116 	
117 	
118 }