1 pragma solidity ^0.4.16;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 
21 
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
23 
24 contract VixcoreToken2 is Owned {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;   
34  
35     uint public totalTokenSold; 
36     uint public totalWeiReceived;  
37     uint public weiBalance;  
38 
39     //EVENTS
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     
44     // This generates a public event on the blockchain that will notify clients
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     // This notifies clients about the amount burnt
48     event Burn(address indexed from, uint256 value);
49     
50     //ETH Withdrawn
51     event Withdrawal(address receiver, uint amount);
52 
53     //Token is purchased using Selfdrop
54     event Selfdrop(address backer, uint weiAmount, uint token);
55 
56     //Over softcap set for Selfdrop
57     event OverSoftCap(address receiver, uint weiAmount);
58 
59 
60 
61 
62 
63     /**
64      * Constructor function
65      *
66      * Initializes contract with initial supply tokens to the creator of the contract
67      */
68     function VixcoreToken2(
69         uint256 initialSupply,
70         string tokenName,
71         string tokenSymbol
72     ) public {
73         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
74         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
75         name = tokenName;                                   // Set the name for display purposes
76         symbol = tokenSymbol;                               // Set the symbol for display purposes
77         owner = msg.sender; 
78     }
79 
80 
81 
82     /**
83      * Internal transfer, only can be called by this contract
84      */
85     function _transfer(address _from, address _to, uint _value) internal {
86         // Prevent transfer to 0x0 address. Use burn() instead
87         require(_to != 0x0);
88         // Check if the sender has enough
89         require(balanceOf[_from] >= _value);
90         // Check for overflows
91         require(balanceOf[_to] + _value >= balanceOf[_to]);
92         // Save this for an assertion in the future
93         uint previousBalances = balanceOf[_from] + balanceOf[_to];
94         // Subtract from the sender
95         balanceOf[_from] -= _value;
96         // Add the same to the recipient
97         balanceOf[_to] += _value;
98         emit Transfer(_from, _to, _value);
99         // Asserts are used to use static analysis to find bugs in your code. They should never fail
100         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
101     } 
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public returns (bool success) {
112         _transfer(msg.sender, _to, _value);
113         return true;
114     } 
115 
116     /**
117      * Default function when someone's transferring to this contract 
118      * The next 3 functions are the same
119      */  
120     function () payable public {
121         _pay();
122     }
123 
124     function pay() payable public {  
125         _pay();
126     }  
127 
128     function _pay() internal { 
129         uint weiValue = msg.value; 
130         uint phase1 = 2500000000000000000000000000;
131         uint phase2 = phase1 + 1500000000000000000000000000;
132         uint phase3 = phase2 + 1000000000000000000000000000; //phase 3 should be less than supply
133 
134         if(totalTokenSold <= phase1){
135             _exchange(weiValue, 5000000);
136         }else if(totalTokenSold <= phase2){
137             _exchange(weiValue, 4000000);
138         }else if(totalTokenSold <= phase3){
139             _exchange(weiValue, 3500000);
140         }else{
141             emit OverSoftCap(msg.sender, weiValue);
142         } 
143     }
144 
145     function _exchange(uint weiValue, uint rate) internal {
146         uint tokenEquiv = tokenEquivalent(weiValue, rate);  
147         _transfer(owner, msg.sender, tokenEquiv); 
148         totalWeiReceived += weiValue;
149         weiBalance += weiValue;
150         totalTokenSold += tokenEquiv;
151         emit Selfdrop(msg.sender, weiValue, tokenEquiv); 
152     }
153 
154     function tokenEquivalent(uint weiValue, uint rate) public returns (uint) {
155         return weiValue * rate;
156     } 
157 
158 
159     /**
160      * Withdraw the funds
161      *
162      * Send the benefeciary some Wei
163      * This function will emit the Withdrawal event if send it successful
164      * Only owner can call this function 
165      */
166     function withdraw(uint _amount) onlyOwner public {
167         require(_amount > 0);
168         require(_amount <= weiBalance);     // Amount withdraw should be less or equal to balance
169         if (owner.send(_amount)) {
170             weiBalance -= _amount;
171             emit Withdrawal(owner, _amount);
172         }else{
173             throw;
174         }
175     }
176 
177 
178 }