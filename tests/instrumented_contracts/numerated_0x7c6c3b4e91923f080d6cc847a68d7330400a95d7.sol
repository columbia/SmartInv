1 pragma solidity ^0.5.5;
2 /*Math operations with safety checks */
3 contract SafeMath { 
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;  
8     }
9   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {	
10     return a/b;  
11     }
12   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;  
15     }
16   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c>=a && c>=b);
19     return c;  
20     }  
21   function safePower(uint a, uint b) internal pure returns (uint256) {
22       uint256 c = a**b;
23       return c;  
24     }
25 }
26 
27 contract Token {  
28     function transfer(address _to, uint256 _value) public returns (bool success) {}
29     mapping (uint256 => address) public accountsToAddress;
30  }
31 
32 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
33 
34 contract UniondaoDollarToken is SafeMath{
35     string public name;    string public symbol;    uint8 public decimals;    uint256 public totalSupply;  address payable public owner;
36     mapping (address => uint256) public balanceOf;/* This creates an array with all balances */
37     mapping (address => mapping (address => uint256)) public allowance;
38     mapping (address => address) public gather;
39     address public issueContract;/*issue Contract*/    
40     address public uniondaoTokenContract;  
41     address public manager;
42     uint256 public totalSupplyLimit;
43     bool    public pauseMint;
44     event Transfer(address indexed from, address indexed to, uint256 value);/* This generates a public event on the blockchain that will notify clients */
45     event Burn(address indexed from, uint256 value);  /* This notifies clients about the amount burnt */
46     event TransferAndSendMsg(address indexed _from, address indexed _to, uint256 _value, string _msg);
47     event Approval(address indexed owner, address indexed spender, uint256 value);  
48     event SetPauseMint(bool pause);
49     event SetManager(address add);
50     event SetOwner(address add);
51     event SetIssueContract(address add);
52     event SetUniondaoTokenContract(address add);
53     event SetTotalSupplyLimit(uint amount);
54     
55     constructor (/* Initializes contract with initial supply tokens to the creator of the contract */
56         uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public{
57         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
58         totalSupply = initialSupply;                        // Update total supply
59         name = tokenName;                                   // Set the name for display purposes
60         symbol = tokenSymbol;                               // Set the symbol for display purposes
61         decimals = 18;                                      // Amount of decimals for display purposes
62         owner = msg.sender;
63         manager = msg.sender;
64         totalSupplyLimit = 100000000 * (10 ** uint256(decimals));			
65     }
66     
67     function transfer(address _to, uint256 _value) public  returns (bool success){/* Send coins */
68         require (_to != address(0x0));                        // Prevent transfer to 0x0 address. 
69         require (_value >= 0) ;																	
70         require (balanceOf[msg.sender] >= _value) ;           // Check if the sender has enough
71         require (safeAdd(balanceOf[_to] , _value) >= balanceOf[_to]) ; // Check for overflows
72         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
73         balanceOf[_to] = safeAdd(balanceOf[_to], _value);               // Add the same to the recipient
74         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
75         if(gather[_to] != address(0x0) && gather[_to] != _to){
76           balanceOf[_to] = safeSub(balanceOf[_to], _value); // Subtract from the sender
77           balanceOf[gather[_to]] = safeAdd(balanceOf[gather[_to]], _value); // Add the same to the recipient
78           emit Transfer( _to,gather[_to], _value);}                    // Notify anyone listening that this transfer took place
79         return true;
80     }
81     
82     function transferAndSendMsg(address _to, uint256 _value, string memory _msg) public returns (bool success){/* Send coins */		
83         emit TransferAndSendMsg(msg.sender, _to, _value,_msg);
84         return transfer( _to,  _value);    
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool success) {/* Allow another contract to spend some tokens in your behalf */
88         allowance[msg.sender][_spender] = _value;	
89         emit Approval(msg.sender, _spender, _value);
90         return true;    
91     }
92     
93     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {/* A contract attempts to get the coins */
94         require (_to != address(0x0)) ;                                // Prevent transfer to 0x0 address. Use burn() instead
95         require (_value >= 0) ;													
96         require (balanceOf[_from] >= _value) ;                 // Check if the sender has enough
97         require (safeAdd(balanceOf[_to] , _value) >= balanceOf[_to]) ;  // Check for overflows
98         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
99         balanceOf[_from] = safeSub(balanceOf[_from], _value);                           // Subtract from the sender
100         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
101         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
102         emit Transfer(_from, _to, _value);
103         if(gather[_to] != address(0x0) && gather[_to] != _to)        {
104           balanceOf[_to] = safeSub(balanceOf[_to], _value);                     // Subtract from the sender
105           balanceOf[gather[_to]] = safeAdd(balanceOf[gather[_to]], _value);     // Add the same to the recipient
106           emit Transfer( _to,gather[_to], _value);   }                  // Notify anyone listening that this transfer took place
107           return true; 
108       }
109       
110     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
111         tokenRecipient spender = tokenRecipient(_spender);
112         if (approve(_spender, _value)) {
113             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
114             return true;}
115     }
116 
117     function burn(uint256 _value) public returns (bool success) {
118         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
119         require (_value > 0) ; 
120         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
121         totalSupply = safeSub(totalSupply,_value);                                // Updates totalSupply
122         emit Burn(msg.sender, _value);			
123         emit Transfer(msg.sender, address(0), _value);
124         return true;
125     } 
126 
127     function mintToken(address _target, uint256 _mintedAmount) public returns (bool success) {
128         require(msg.sender == issueContract && !pauseMint && safeAdd(totalSupply,_mintedAmount) <= totalSupplyLimit);
129         balanceOf[_target] = safeAdd(balanceOf[_target],_mintedAmount);
130         totalSupply = safeAdd(totalSupply,_mintedAmount);
131         emit Transfer(address(0x0), _target, _mintedAmount);
132         return true;
133     }  
134     
135     function setSymbol(string memory _symbol)public   {        
136         require (msg.sender == owner) ; 
137         symbol = _symbol;    
138     } 
139 
140     function setName(string memory _name)public {        
141         require (msg.sender == owner) ; 
142         name = _name;    
143     } 
144     
145     function setGather(address _add)public{  /*Set summary address to facilitate exchange summary balance*/      
146         require (_add != address(0x0) && isContract(_add) == false) ;		
147         gather[msg.sender] = _add;    } 
148     
149     function isContract(address _addr) private view returns (bool is_contract) {//Assemble the address bytecode. If there is a bytecode, then _addr is a contract.
150       uint length;
151       assembly { length := extcodesize(_addr) }    
152       return (length>0);
153     }  
154 
155     function setPauseMint(bool _pause)public{   
156         require (msg.sender == manager) ; 
157         pauseMint = _pause;					
158         emit SetPauseMint(_pause);
159     } 
160 
161     function setManager(address _add)public{
162         require (msg.sender == owner && _add != address(0x0)) ;
163         manager = _add ;					 
164         emit SetManager(_add);
165     }
166 
167     function setOwner(address payable _add)public{
168         require (msg.sender == owner && _add != address(0x0)) ;
169         owner = _add ;						 
170         emit SetOwner(_add);
171     }
172 
173     function setIssueContract(address _add)public{
174         require (msg.sender == owner) ;
175         issueContract = _add ;				
176         emit SetIssueContract(_add);
177     }
178 
179     function setUniondaoTokenContract(address _add)public{
180         require (msg.sender == owner) ;
181         uniondaoTokenContract = _add ;		  
182         emit SetUniondaoTokenContract(_add);
183     }
184 
185     function setTotalSupplyLimit(uint _amount)public{
186         require (msg.sender == manager && _amount > 0) ;
187         totalSupplyLimit = _amount ;  
188         emit SetTotalSupplyLimit(_amount);  
189     }
190     
191     function() external payable  {}/* can accept ether */
192     
193     function withdrawToken(address token, uint amount) public{// transfer balance to owner
194       require(msg.sender == owner);
195       if (token == address(0x0)) owner.transfer(amount); 
196       else require (Token(token).transfer(owner, amount));
197     }
198 
199     function transferAndSendMsgByAccount(uint256 _to, uint256 _value, string memory _msg) public returns (bool success){/* Send coins */
200         address _tmp = Token(uniondaoTokenContract).accountsToAddress(_to);
201         require(_tmp != address(0x0));
202         emit TransferAndSendMsg(msg.sender, _tmp, _value,_msg);
203         return transfer( _tmp,  _value);    
204     }
205 }