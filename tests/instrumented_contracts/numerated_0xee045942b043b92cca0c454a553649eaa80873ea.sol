1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 contract SafeM {
5     function safeAdd(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract TokenERC20 is SafeM{
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29     
30     uint256 public totalSupply;
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40 
41     /**
42      * Constructor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function TokenERC20() public {
47         totalSupply = 90000000* 10 ** uint256(decimals);  // Updating total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Giving the creator all initial tokens
49         name = "Lehman Brothers Coin";                                   // Setting the name for display purposes
50         symbol = "LBC";   
51             }
52     
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value >= balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         emit Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70     
71     function Airdrop(address[] recipients, uint[] amount){
72         
73         for( uint i = 0 ; i < recipients.length ; i++ ) {
74           transfer( recipients[i], amount[i] );
75       }
76     }
77 
78     
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value*10**18);
81     }
82     
83     
84     function destroycontract(address _to) {
85 
86         selfdestruct(_to);
87 
88     }
89 
90     
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     
99     function approve(address _spender, uint256 _value) public
100         returns (bool success) {
101         allowance[msg.sender][_spender] = _value;
102         return true;
103     }
104 
105     
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
107         public
108         returns (bool success) {
109         tokenRecipient spender = tokenRecipient(_spender);
110         if (approve(_spender, _value)) {
111             spender.receiveApproval(msg.sender, _value, this, _extraData);
112             return true;
113         }
114     }
115 
116     function burn(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
118         balanceOf[msg.sender] -= _value;            // Subtract from the sender
119         totalSupply -= _value;                      // Updates totalSupply
120         emit Burn(msg.sender, _value*10**18);
121         return true;
122     }
123 
124     
125     function burnFrom(address _from, uint256 _value) public returns (bool success) {
126         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
127         require(_value <= allowance[_from][msg.sender]);    // Check allowance
128         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
129         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
130         totalSupply -= _value;                              // Update totalSupply
131         emit Burn(_from, _value*10**18);
132         return true;
133     }
134     function () public payable {
135         uint tokens;
136         tokens = msg.value * 300000;       // 1 ETHER = 300000MGT
137         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], tokens);  
138         totalSupply = safeAdd(totalSupply, tokens);
139         emit Transfer(address(0), msg.sender, tokens); // transfer the token to the donator
140         msg.sender.transfer(msg.value);           // send the ether to owner
141     }
142 
143 }