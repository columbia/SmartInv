1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5  
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract CandyCoin is owned {
23     // Public variables of the token
24     string public name = "Unicorn Candy Coin";
25     string public symbol = "Candy";
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply = 12000000000000000000000000;
29     address public crowdsaleContract;
30 
31     uint sendingBanPeriod = 1519776000;           // 28.02.2018
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42     
43     modifier canSend() {
44         require ( msg.sender == owner ||  now > sendingBanPeriod || msg.sender == crowdsaleContract);
45         _;
46     }
47     
48     /**
49      * Constrctor function
50      */
51     function CandyCoin(
52     ) public {
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54     }
55     
56     function setCrowdsaleContract(address contractAddress) onlyOwner {
57         crowdsaleContract = contractAddress;
58     }
59      
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public canSend {
90         _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public canSend returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from the address of the sender
163      * @param _value the amount of money to burn
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 
177 contract CandySale is owned {
178     
179     address public teamWallet = address(0x7Bd19c5Fa45c5631Aa7EFE2Bf8Aa6c220272694F);
180 
181     uint public amountRaised;
182     // sale periods
183     uint public beginTime = now;
184     uint public endTime = 1520640000;           // 10.03.2018
185     uint public tokenPrice = 1750 szabo;
186 
187     CandyCoin public tokenReward;
188 
189     event FundTransfer(address backer, uint amount, bool isContribution);
190 
191     /**
192      * Constrctor function
193      *
194      * Setup the owner
195      */
196     function CandySale(
197         CandyCoin addressOfTokenUsedAsReward
198     ) {
199         tokenReward = addressOfTokenUsedAsReward;
200     }
201     
202     // withdraw tokens from contract
203     function withdrawTokens() onlyOwner {
204         tokenReward.transfer(msg.sender, tokenReward.balanceOf(this));
205         FundTransfer(msg.sender, tokenReward.balanceOf(this), false);
206     }
207 
208     // low level token purchase function
209     function buyTokens(address beneficiary) payable {
210         require(msg.value > 0);
211         uint amount = msg.value;
212         amountRaised += amount;
213         tokenReward.transfer(beneficiary, amount*1000000000000000000/tokenPrice);
214         FundTransfer(beneficiary, amount, true);
215         teamWallet.transfer(msg.value);
216 
217     }
218 
219     /**
220      * Fallback function
221      *
222      * The function without name is the default function that is called whenever anyone sends funds to a contract
223      */
224     function () payable onlyCrowdsalePeriod {
225         buyTokens(msg.sender);
226     }
227 
228     modifier onlyCrowdsalePeriod() { 
229         require ( now >= beginTime && now <= endTime ) ;
230         _; 
231     }
232 
233     
234 
235 }