1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract DailyCoinToken {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 8;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function DailyCoinToken(
29     ) public {
30         totalSupply = 300000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32         name = "Daily Coin";                                   // Set the name for display purposes
33         symbol = "DLC";                               // Set the symbol for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // Prevent transfer to 0x0 address. Use burn() instead
41         require(_to != 0x0);
42         // Check if the sender has enough
43         require(balanceOf[_from] >= _value);
44         // Check for overflows
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         // Save this for an assertion in the future
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         // Subtract from the sender
49         balanceOf[_from] -= _value;
50         // Add the same to the recipient
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         // Asserts are used to use static analysis to find bugs in your code. They should never fail
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     /**
58      * Transfer tokens
59      *
60      * Send `_value` tokens to `_to` from your account
61      *
62      * @param _to The address of the recipient
63      * @param _value the amount to send
64      */
65     function transfer(address _to, uint256 _value) public {
66         _transfer(msg.sender, _to, _value);
67     }
68 
69     /**
70      * Transfer tokens from other address
71      *
72      * Send `_value` tokens to `_to` in behalf of `_from`
73      *
74      * @param _from The address of the sender
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);     // Check allowance
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 
85     /**
86      * Set allowance for other address
87      *
88      * Allows `_spender` to spend no more than `_value` tokens in your behalf
89      *
90      * @param _spender The address authorized to spend
91      * @param _value the max amount they can spend
92      */
93     function approve(address _spender, uint256 _value) public
94         returns (bool success) {
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address and notify
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      * @param _extraData some extra information to send to the approved contract
107      */
108     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
109         public
110         returns (bool success) {
111         tokenRecipient spender = tokenRecipient(_spender);
112         if (approve(_spender, _value)) {
113             spender.receiveApproval(msg.sender, _value, this, _extraData);
114             return true;
115         }
116     }
117 
118     /**
119      * Destroy tokens
120      *
121      * Remove `_value` tokens from the system irreversibly
122      *
123      * @param _value the amount of money to burn
124      */
125     function burn(uint256 _value) public returns (bool success) {
126         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
127         balanceOf[msg.sender] -= _value;            // Subtract from the sender
128         totalSupply -= _value;                      // Updates totalSupply
129         Burn(msg.sender, _value);
130         return true;
131     }
132 
133     /**
134      * Destroy tokens from other account
135      *
136      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
137      *
138      * @param _from the address of the sender
139      * @param _value the amount of money to burn
140      */
141     function burnFrom(address _from, uint256 _value) public returns (bool success) {
142         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
143         require(_value <= allowance[_from][msg.sender]);    // Check allowance
144         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
145         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
146         totalSupply -= _value;                              // Update totalSupply
147         Burn(_from, _value);
148         return true;
149     }
150 }
151 
152 ///////////////////////////CROWDSALE///////////////////////////////
153 contract DailycoinCrowdsale {
154     uint256 public amountRaised = 0;
155 	uint256 public tokensSold = 0;
156     uint256 public totalToSale = 150 * (10**6) * (10**8);
157 	bool crowdsaleClosed = false;
158 	
159     uint public deadline;
160     address public beneficiary;
161     DailyCoinToken public tokenReward;
162 
163     event SaleEnded(address recipient, uint256 totalAmountRaised);
164     event FundTransfer(address backer, uint256 amount, uint256 numOfTokens);
165 
166     /**
167      * Constrctor function
168      *
169      * Setup the owner
170      */
171     function DailycoinCrowdsale() public {
172         beneficiary = 0x17Cb4341eF4d9132f9c86b335f6Dd6010F6AeA9a;
173         tokenReward = DailyCoinToken(0xaA33983Acfc48bE1D76e0f8Fe377FFe956ad84AD);
174         deadline = 1512997200 + 45 days; // start on 2017-Dec-11 8.00PM, last 45 days
175     }
176 
177     /**
178      * Fallback function
179      *
180      * The function without name is the default function that is called whenever anyone sends funds to a contract
181      */
182     function () payable public {
183 		require(!crowdsaleClosed);
184         uint256 amount = msg.value;
185 		uint256 numOfTokens = getNumTokens(amount);
186         amountRaised += amount;
187 		tokensSold += numOfTokens;
188         tokenReward.transfer(msg.sender, numOfTokens);
189         FundTransfer(msg.sender, amount, numOfTokens);
190     }
191 	
192 	function getNumTokens(uint256 _value) internal returns (uint256 numTokens) {
193 		uint256 multiple = 5000;
194         if (_value >= 10 * 10**18) {
195             if (now <= deadline - 35 days) { // first 10 days
196 				multiple = multiple * 130 / 100;
197 			} else if (now <= deadline - 20 days) { // next 15 days
198 				multiple = multiple * 120 / 100;
199 			} else { // 20 last days
200 				multiple = multiple * 115 / 100;
201 			}
202         } else {
203 			if (now <= deadline - 35 days) { // first 10 days
204 				multiple = multiple * 120 / 100;
205 			} else if (now <= deadline - 20 days) {  // next 15 days
206 				multiple = multiple * 110 / 100;
207 			} else { // 20 last days
208 				multiple = multiple * 105 / 100;
209 			}
210 		}
211 		return multiple * 10**8 * _value / 10**18;
212 	}
213 
214     modifier afterDeadline() { if (now >= deadline) _; }
215 
216     /**
217      * Withdraw the funds
218      *
219      * Checks to see if goal or time limit has been reached, and if so, give raised value to beneficiary and burn left tokens in crowdsale.
220      */
221     function endFunding() afterDeadline public {
222 		require(beneficiary == msg.sender);
223 		require(!crowdsaleClosed);
224 		if (beneficiary.send(amountRaised)) {
225 			if (totalToSale > tokensSold) {
226 				tokenReward.burn(totalToSale - tokensSold);
227 			}
228 			crowdsaleClosed = true;
229 			SaleEnded(beneficiary, amountRaised);
230 		}
231     }
232 	
233 	function withdraw(uint256 amount) afterDeadline public {
234 		require(beneficiary == msg.sender);
235 		amount = amount * 1 ether;
236 		beneficiary.transfer(amount);
237     }
238 }