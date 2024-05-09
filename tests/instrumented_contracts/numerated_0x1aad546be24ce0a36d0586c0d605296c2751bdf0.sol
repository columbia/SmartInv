1 pragma solidity ^0.4.23;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract HammerChainBeta {
6     address  owner;   
7     
8     // Public variables of the token
9     string  name;
10     string  symbol;
11     uint8  decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256  totalSupply;
14 
15     address INCENTIVE_POOL_ADDR = 0x0;
16     address FOUNDATION_POOL_ADDR = 0x0;
17     address COMMUNITY_POOL_ADDR = 0x0;
18     address FOUNDERS_POOL_ADDR = 0x0;
19 
20     bool releasedFoundation = false;
21     bool releasedCommunity = false;
22     uint256  timeIncentive = 0x0;
23     uint256 limitIncentive=0x0;
24     uint256 timeFounders= 0x0;
25     uint256 limitFounders=0x0;
26 
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37  
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     constructor() public {
49         owner = msg.sender;
50         totalSupply = 512000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = "HammerChain(alpha)";                        // Set the name for display purposes
53         symbol = "HRC";                                     // Set the symbol for display purposes
54     }
55 
56     function sendIncentive() onlyOwner public{
57         require(limitIncentive < totalSupply/2);
58         if (timeIncentive < now){
59             if (timeIncentive == 0x0){
60                 _transfer(owner,INCENTIVE_POOL_ADDR,totalSupply/10);
61                 limitIncentive += totalSupply/10;
62             }
63             else{
64                 _transfer(owner,INCENTIVE_POOL_ADDR,totalSupply/20);
65                 limitIncentive += totalSupply/20;
66             }
67             timeIncentive = now + 365 days;
68         }
69     }
70 
71     function sendFounders() onlyOwner public{
72         require(limitFounders < totalSupply/20);
73         if (timeFounders== 0x0 || timeFounders < now){
74             _transfer(owner,FOUNDERS_POOL_ADDR,totalSupply/100);
75             timeFounders = now + 365 days;
76             limitFounders += totalSupply/100;
77         }
78     }
79 
80     function sendFoundation() onlyOwner public{
81         require(releasedFoundation == false);
82         _transfer(owner,FOUNDATION_POOL_ADDR,totalSupply/4);
83         releasedFoundation = true;
84     }
85 
86 
87     function sendCommunity() onlyOwner public{
88         require(releasedCommunity == false);
89         _transfer(owner,COMMUNITY_POOL_ADDR,totalSupply/5);
90         releasedCommunity = true;
91     }
92 
93     function setINCENTIVE_POOL_ADDR(address addr) onlyOwner public{
94         INCENTIVE_POOL_ADDR = addr;
95     }
96 
97     function setFOUNDATION_POOL_ADDR(address addr) onlyOwner public{
98         FOUNDATION_POOL_ADDR = addr;
99     }
100     
101     function setCOMMUNITY_POOL_ADDR(address addr) onlyOwner public{
102         COMMUNITY_POOL_ADDR = addr;
103     }
104 
105     function setFOUNDERS_POOL_ADDR(address addr) onlyOwner public{
106         FOUNDERS_POOL_ADDR = addr;
107     }
108 
109 
110     function transferOwnership(address newOwner) onlyOwner public {
111         owner = newOwner;
112     }
113 
114     /**
115      * Internal transfer, only can be called by this contract
116      */
117     function _transfer(address _from, address _to, uint _value) internal {
118         // Prevent transfer to 0x0 address. Use burn() instead
119         require(_to != 0x0);
120         // Check if the sender has enough
121         require(balanceOf[_from] >= _value);
122         // Check for overflows
123         require(balanceOf[_to] + _value > balanceOf[_to]);
124         // Save this for an assertion in the future
125         uint previousBalances = balanceOf[_from] + balanceOf[_to];
126         // Subtract from the sender
127         balanceOf[_from] -= _value;
128         // Add the same to the recipient
129         balanceOf[_to] += _value;
130         emit Transfer(_from, _to, _value);
131         // Asserts are used to use static analysis to find bugs in your code. They should never fail
132         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
133     }
134 
135     /**
136      * Transfer tokens
137      *
138      * Send `_value` tokens to `_to` from your account
139      *
140      * @param _to The address of the recipient
141      * @param _value the amount to send
142      */
143     function transfer(address _to, uint256 _value) public {
144         require(msg.sender != owner);
145         _transfer(msg.sender, _to, _value);
146     }
147 
148     /**
149      * Transfer tokens from other address
150      *
151      * Send `_value` tokens to `_to` in behalf of `_from`
152      *
153      * @param _from The address of the sender
154      * @param _to The address of the recipient
155      * @param _value the amount to send
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158         require(msg.sender != owner);
159         require(_value <= allowance[_from][msg.sender]);     // Check allowance
160         allowance[_from][msg.sender] -= _value;
161         _transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * Set allowance for other address
167      *
168      * Allows `_spender` to spend no more than `_value` tokens in your behalf
169      *
170      * @param _spender The address authorized to spend
171      * @param _value the max amount they can spend
172      */
173     function approve(address _spender, uint256 _value) public
174         returns (bool success) {
175         allowance[msg.sender][_spender] = _value;
176         return true;
177     }
178 
179     /**
180      * Set allowance for other address and notify
181      *
182      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
183      *
184      * @param _spender The address authorized to spend
185      * @param _value the max amount they can spend
186      * @param _extraData some extra information to send to the approved contract
187      */
188     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
189         public
190         returns (bool success) {
191         tokenRecipient spender = tokenRecipient(_spender);
192         if (approve(_spender, _value)) {
193             spender.receiveApproval(msg.sender, _value, this, _extraData);
194             return true;
195         }
196     }
197 
198     /**
199      * Destroy tokens
200      *
201      * Remove `_value` tokens from the system irreversibly
202      *
203      * @param _value the amount of money to burn
204      */
205     function burn(uint256 _value) public returns (bool success) {
206         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
207         balanceOf[msg.sender] -= _value;            // Subtract from the sender
208         totalSupply -= _value;                      // Updates totalSupply
209         emit Burn(msg.sender, _value);
210         return true;
211     }
212 
213     /**
214      * Destroy tokens from other account
215      *
216      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
217      *
218      * @param _from the address of the sender
219      * @param _value the amount of money to burn
220      */
221     function burnFrom(address _from, uint256 _value) public returns (bool success) {
222         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
223         require(_value <= allowance[_from][msg.sender]);    // Check allowance
224         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
225         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
226         totalSupply -= _value;                              // Update totalSupply
227         emit Burn(_from, _value);
228         return true;
229     }
230 }