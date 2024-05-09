1 pragma solidity ^0.4.21;
2 
3 contract SafeMath {
4      function safeMul(uint a, uint b) internal pure returns (uint) {
5           uint c = a * b;
6           assert(a == 0 || c / a == b);
7           return c;
8      }
9 
10      function safeSub(uint a, uint b) internal pure returns (uint) {
11           assert(b <= a);
12           return a - b;
13      }
14 
15      function safeAdd(uint a, uint b) internal pure returns (uint) {
16           uint c = a + b;
17           assert(c>=a && c>=b);
18           return c;
19      }
20 }
21 
22 
23 contract Token is SafeMath {
24 
25      
26      function transfer(address _to, uint256 _value) public;
27      function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
28      function approve(address _spender, uint256 _amount) public returns (bool success);
29 
30      event Transfer(address indexed _from, address indexed _to, uint256 _value);
31      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 }
33 
34 contract Crowdsale is Token {
35 
36     // Public and other variables of the token
37     address public owner;
38     string public name = "crowdsalenetworkplatform";
39     string public symbol = "CSNP";
40     uint8 public decimals = 18;
41     uint256 public totalSupply = 50000000 * 10 ** uint256(decimals);
42     
43     address internal foundersAddress;
44     address internal bonusAddress;
45     uint internal dayStart = now;
46 
47 
48     // This creates an array with all balances
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52 
53     // This generates a public event on the blockchain that will notify clients
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56 
57     /**
58      * Constrctor function
59      *
60      * Initializes contract with initial supply tokens to the creator of the contract
61      */
62     function Crowdsale(address enterFoundersAddress, address enterBonusAddress) public {
63         foundersAddress = enterFoundersAddress;
64         bonusAddress = enterBonusAddress;
65         balanceOf[foundersAddress] = 12500000 * 10 ** uint256(decimals);
66         balanceOf[bonusAddress] = 18750000 * 10 ** uint256(decimals);
67         balanceOf[msg.sender] = totalSupply - (12500000 * 10 ** uint256(decimals)) - (18750000 * 10 ** uint256(decimals));                
68         owner = msg.sender;
69 
70     }
71 
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78 
79     function transferOwnership(address newOwner) onlyOwner public {
80         owner = newOwner;
81     }
82 
83     /**
84      * Internal transfer, only can be called by this contract
85      */
86     function _transfer(address _from, address _to, uint _value) internal {
87         // Prevent transfer to 0x0 address. Use burn() instead
88         require(_to != 0x0);
89         // Check if the sender has enough
90         require(balanceOf[_from] >= _value);
91         // Check for overflows
92         require(balanceOf[_to] + _value > balanceOf[_to]);
93         // Subtract from the sender
94         balanceOf[_from] = safeSub(balanceOf[_from],_value);
95         // Add the same to the recipient
96         balanceOf[_to] = safeAdd(balanceOf[_to],_value);
97         emit Transfer(_from, _to, _value);
98 
99     }
100 
101     /**
102      * Transfer tokens
103      *
104      * Send `_value` tokens to `_to` from your account
105      *
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transfer(address _to, uint256 _value) public  {
110         if(now < (dayStart + 365 days)){
111             require(msg.sender != foundersAddress && tx.origin != foundersAddress);
112         }
113         
114         if(now < (dayStart + 180 days)){
115             require(msg.sender != bonusAddress && tx.origin != bonusAddress);
116         }
117         
118 
119         _transfer(msg.sender, _to, _value);
120     }
121 
122 
123 
124 
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126         require(_value <= allowance[_from][msg.sender]);     // Check allowance
127         
128         if(now < (dayStart + 365 days)){
129             require(_from != foundersAddress);
130         }
131         
132         if(now < (dayStart + 180 days)){
133             require(_from != bonusAddress);
134         }
135 
136         allowance[_from][msg.sender] -= _value;
137         _transfer(_from, _to, _value);
138         return true;
139     }
140 
141 
142     
143     /**
144     *   Set allowance for other address
145     *
146     *   also, to minimize the risk of the approve/transferFrom attack vector
147     *   approve has to be called twice in 2 separate transactions - once to
148     *   change the allowance to 0 and secondly to change it to the new allowance
149     *   value
150     *
151     *   @param _spender      approved address
152     *   @param _amount       allowance amount
153     *
154     *   @return true if the approval was successful
155     */
156     function approve(address _spender, uint256 _amount) public returns(bool success) {
157         require((_amount == 0) || (allowance[msg.sender][_spender] == 0));
158         
159         if(now < (dayStart + 365 days)){
160             require(msg.sender != foundersAddress && tx.origin != foundersAddress);
161         }
162         
163         if(now < (dayStart + 180 days)){
164             require(msg.sender != bonusAddress && tx.origin != bonusAddress);
165         }
166         
167         
168         allowance[msg.sender][_spender] = _amount;
169         return true;
170     }
171     
172         
173      
174 
175 }