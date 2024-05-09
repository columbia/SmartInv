1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Investment Eternal Contract
6  *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
7  *  - NO FEES on your investment
8  *  - NO FEES are collected by the contract creator
9  *
10  * How to use:
11  *  1. Burn (or send to token address) any amount of EIE to make an investment
12  *  2a. Claim your profit by sending 0 EIE transaction (every day, every week, i don't care unless you're spending too much on GAS)
13  *  OR
14  *  2b. Send more EIE to reinvest AND get your profit at the same time
15  *  3. During the first week, you can send 0 Ether to the contract address an unlimited number of times, receiving 1 EIE for each transaction
16  *
17  * RECOMMENDED GAS LIMIT: 200000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  *
20  * Contract reviewed and approved by pros!
21  *
22  */
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
25 
26 contract EIE {
27     // Public variables of the token
28     string public name = 'EasyInvestEternal';
29     string public symbol = 'EIE';
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply = 1000000000000000000000000;
33     uint256 public createdAtBlock;
34 
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38     
39     // records amounts invested
40     mapping (address => uint256) public invested;
41     // records blocks at which investments were made
42     mapping (address => uint256) public atBlock;
43 
44     // This generates a public event on the blockchain that will notify clients
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     
47     // This generates a public event on the blockchain that will notify clients
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 
50     // This notifies clients about the amount burnt
51     event Burn(address indexed from, uint256 value);
52 
53     /**
54      * Constructor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     constructor() public {
59         createdAtBlock = block.number;
60         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
61     }
62     
63     function isFirstWeek() internal view returns (bool) {
64         return block.number < createdAtBlock + 5900 * 7;
65     }
66     
67     function _issue(uint _value) internal {
68         balanceOf[msg.sender] += _value;
69         totalSupply += _value;
70         emit Transfer(0, this, _value);
71         emit Transfer(this, msg.sender, _value);
72     }
73 
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != 0x0);
80         // Check if the sender has enough
81         require(balanceOf[_from] >= _value);
82         // Check for overflows
83         require(balanceOf[_to] + _value >= balanceOf[_to]);
84         // Save this for an assertion in the future
85         uint previousBalances = balanceOf[_from] + balanceOf[_to];
86         // Subtract from the sender
87         balanceOf[_from] -= _value;
88         // Add the same to the recipient
89         balanceOf[_to] += _value;
90         emit Transfer(_from, _to, _value);
91         // Asserts are used to use static analysis to find bugs in your code. They should never fail
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 
95     /**
96      * Transfer tokens
97      *
98      * Send `_value` tokens to `_to` from your account
99      *
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         if (_to == address(this)) {
105             burn(_value);
106         } else {
107             _transfer(msg.sender, _to, _value);
108         }
109         return true;
110     }
111 
112     /**
113      * Transfer tokens from other address
114      *
115      * Send `_value` tokens to `_to` on behalf of `_from`
116      *
117      * @param _from The address of the sender
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
122         require(_value <= allowance[_from][msg.sender]);     // Check allowance
123         allowance[_from][msg.sender] -= _value;
124         _transfer(_from, _to, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address
130      *
131      * Allows `_spender` to spend no more than `_value` tokens on your behalf
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      */
136     function approve(address _spender, uint256 _value) public
137         returns (bool success) {
138         allowance[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address and notify
145      *
146      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      * @param _extraData some extra information to send to the approved contract
151      */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
153         public
154         returns (bool success) {
155         tokenRecipient spender = tokenRecipient(_spender);
156         if (approve(_spender, _value)) {
157             spender.receiveApproval(msg.sender, _value, this, _extraData);
158             return true;
159         }
160     }
161 
162     /**
163      * Destroy tokens and invest tokens
164      *
165      * Remove `_value` tokens from the system irreversibly
166      *
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns (bool success) {
170         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
171         balanceOf[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         emit Burn(msg.sender, _value);
174         emit Transfer(msg.sender, this, 0);
175         
176         if (invested[msg.sender] != 0) {
177             // calculate profit amount as such:
178             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
179             // 5900 is an average block count per day produced by Ethereum blockchain
180             uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;
181 
182             // send calculated amount of ether directly to sender (aka YOU)
183             _issue(amount);
184         }
185         
186         atBlock[msg.sender] = block.number;
187         invested[msg.sender] += _value;
188         
189         return true;
190     }
191 
192     // this function called every time anyone sends a transaction to this contract
193     function () external payable {
194         if (msg.value > 0 || !isFirstWeek()) {
195             revert();
196         }
197         
198         _issue(1000000000000000000);
199     }
200 }