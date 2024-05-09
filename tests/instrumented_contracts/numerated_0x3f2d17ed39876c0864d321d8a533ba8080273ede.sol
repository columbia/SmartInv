1 contract NoxonFund {
2 
3     address public owner;
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply; //18160ddd for rpc call https://api.etherscan.io/api?module=proxy&data=0x18160ddd&to=0xContractAdress&apikey={eserscan api}&action=eth_call
8     uint256 public Entropy;
9     uint256 public ownbalance; //d9c7041b
10 
11 	uint256 public sellPrice; //4b750334
12     uint256 public buyPrice; //8620410b
13     
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     
20     
21     
22     /* Initializes cont ract with initial supply tokens to the creator of the contract */
23     function token()  {
24     
25         if (owner!=0) throw;
26         buyPrice = msg.value;
27         balanceOf[msg.sender] = 1;    // Give the creator all initial tokens
28         totalSupply = 1;              // Update total supply
29         Entropy = 1;
30         name = 'noxonfund.com';       // Set the name for display purposes
31         symbol = '? SHARE';             // Set the symbol for display purposes
32         decimals = 0;                 // Amount of decimals for display purposes
33         owner = msg.sender;
34         setPrices();
35     }
36     
37 
38     
39      /* Send shares function */
40     function transfer(address _to, uint256 _value) {
41         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
42         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
43         balanceOf[msg.sender] -= _value;    
44         balanceOf[_to] += _value;                            // Add the same to the recipient
45         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
46     }
47 	
48 
49     function setPrices() {
50         ownbalance = this.balance; //own contract balance
51         sellPrice = ownbalance/totalSupply;
52         buyPrice = sellPrice*2; 
53     }
54     
55     
56    function () returns (uint buyreturn) {
57        
58         uint256 amount = msg.value / buyPrice;                // calculates the amount
59         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
60        
61         totalSupply += amount;
62         Entropy += amount;
63         
64         Transfer(0, msg.sender, amount);
65         
66         owner.send(msg.value/2);
67         //set next price
68         setPrices();
69         return buyPrice;
70    }
71    
72 
73     
74     function sell(uint256 amount) {
75         setPrices();
76         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
77         Transfer(msg.sender, this, amount);                 //return shares to contract
78         totalSupply -= amount;
79         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
80         msg.sender.send(amount * sellPrice);               // sends ether to the seller
81         setPrices();
82 
83     }
84 	
85 	//All incomse will send using newIncome method
86 	event newincomelog(uint amount,string description);
87 	function newIncome(
88         string JobDescription
89     )
90         returns (string result)
91     {
92         if (msg.value <= 1 ether/100) throw;
93         newincomelog(msg.value,JobDescription);
94         return JobDescription;
95     }
96     
97     
98     
99     //some democracy
100     
101     uint votecount;
102     uint voteno; 
103     uint voteyes;
104     
105     mapping (address => uint256) public voters;
106     
107     function newProposal(
108         string JobDescription
109     )
110         returns (string result)
111     {
112         if (msg.sender == owner) {
113             votecount = 0;
114             newProposallog(JobDescription);
115             return "ok";
116         } else {
117             return "Only admin can do this";
118         }
119     }
120     
121 
122     
123     
124     function ivote(bool myposition) returns (uint result) {
125         votecount += balanceOf[msg.sender];
126         
127         if (voters[msg.sender]>0) throw;
128         voters[msg.sender]++;
129         votelog(myposition,msg.sender,balanceOf[msg.sender]);
130         return votecount;
131     }
132 
133     
134     event newProposallog(string description);
135     event votelog(bool position, address voter, uint sharesonhand);
136    
137     
138 }