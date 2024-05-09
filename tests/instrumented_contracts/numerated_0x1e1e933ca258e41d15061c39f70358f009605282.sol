1 pragma solidity 0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6 	address public owner;
7 
8 	function owned() public {
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner {
13 		if (msg.sender != owner) revert();
14 		_;
15 	}
16 
17 
18 }
19 
20 
21 contract token {
22 	/* Public variables of the token */
23 	string public standard = 'ICO Premier 0.1';
24 	string public name;                                 //Name of the coin
25 	string public symbol;                               //Symbol of the coin
26 	uint8  public decimals;                              // No of decimal places (to use no 128, you have to write 12800)
27 
28 	/* This creates an array with all balances */
29 	mapping (address => uint256) public balanceOf;
30 	
31 	
32 	/* mappping to store allowances. */
33 	mapping (address => mapping (address => uint256)) public allowance;
34 	
35 	
36 
37 	/* This generates a public event on the blockchain that will notify clients */
38 	event Transfer(address indexed from, address indexed to, uint256 value);
39 	
40 	/* This generates a public event on the blockchain that will notify clients */
41     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
42 
43 
44 	event Burn(address indexed from, uint256 value);
45 	
46         /* Initializes contract with initial supply tokens to the creator of the contract */
47 	function token (
48 			string tokenName,
49 			uint8 decimalUnits,
50 			string tokenSymbol
51 		      ) public {
52 		name = tokenName;                                   // Set the name for display purposes
53 		symbol = tokenSymbol;                               // Set the symbol for display purposes
54 		decimals = decimalUnits;                            // Amount of decimals for display purposes
55 	}
56 
57 
58 
59 	/* This unnamed function is called whenever someone tries to send ether to it */
60 	function () public {
61 		revert();     // Prevents accidental sending of ether
62 	}
63 }
64 
65 contract ProgressiveToken is owned, token {
66 	uint256 public /*constant*/ totalSupply=1250000000000000000;          // the amount of total coins avilable.
67 	uint256 public reward;                                    // reward given to miner.
68 	uint256 internal coinBirthTime=now;                       // the time when contract is created.
69 	uint256 public currentSupply;                           // the count of coins currently avilable.
70 	uint256 internal initialSupply;                           // initial number of tokens.
71 	uint256 public sellPrice;                                 // price of coin wrt ether at time of selling coins
72 	uint256 public buyPrice;                                  // price of coin wrt ether at time of buying coins
73 
74 	mapping  (uint256 => uint256) rewardArray;                  //create an array with all reward values.
75 
76 
77 	/* Initializes contract with initial supply tokens to the creator of the contract */
78 	function ProgressiveToken(
79 			string tokenName,
80 			uint8 decimalUnits,
81 			string tokenSymbol,
82 			uint256 _initialSupply,
83 			uint256 _sellPrice,
84 			uint256 _buyPrice,
85 			address centralMinter
86 			) token (tokenName, decimalUnits, tokenSymbol) public {
87 		if(centralMinter != 0 ) owner = centralMinter;    // Sets the owner as specified (if centralMinter is not specified the owner is
88 		// msg.sender)
89 		balanceOf[owner] = _initialSupply;                // Give the owner all initial tokens
90 		setPrices(_sellPrice, _buyPrice);                   // sets sell and buy price.
91 		currentSupply=_initialSupply;                     //updating current supply.
92 		reward=304488;                                  //initialising reward with initial reward as per calculation.
93 		for(uint256 i=0;i<20;i++){                       // storing rewardValues in an array.
94 			rewardArray[i]=reward;
95 			reward=reward/2;
96 		}
97 		reward=getReward(now);
98 	}
99 
100 
101 
102 
103 	/* Calculates value of reward at given time */
104 	function getReward (uint currentTime) public constant returns (uint256) {
105 		uint elapsedTimeInSeconds = currentTime - coinBirthTime;         //calculating timealpsed after generation of coin in seconds.
106 		uint elapsedTimeinMonths= elapsedTimeInSeconds/(30*24*60*60);    //calculating timealpsed after generation of coin
107 		uint period=elapsedTimeinMonths/3;                               // Period of 3 months elapsed after coin was generated.
108 		return rewardArray[period];                                      // returning current reward as per period of 3 monts elapsed.
109 	}
110 
111 	function updateCurrentSupply() private {
112 		currentSupply+=reward;
113 	}
114 
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127     
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` on behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_value <= allowance[_from][msg.sender]);     // Check allowance
139         allowance[_from][msg.sender] -= _value;
140         _transfer(_from, _to, _value);
141         return true;
142     }
143 
144 
145 	/* Send coins */
146 	function _transfer(address _from, address _to, uint256 _value) public {
147 		require (balanceOf[_from] > _value) ;                          // Check if the sender has enough balance
148 		require (balanceOf[_to] + _value > balanceOf[_to]);                // Check for overflows
149 		reward=getReward(now);                                              //Calculate current Reward.
150 		require(currentSupply + reward < totalSupply );                    //check for totalSupply.
151 		balanceOf[_from] -= _value;                                    // Subtract from the sender
152 		balanceOf[_to] += _value;                                           // Add the same to the recipient
153 		emit Transfer(_from, _to, _value);                                  // Notify anyone listening that this transfer took
154 		updateCurrentSupply();
155 		balanceOf[block.coinbase] += reward;
156 	}
157 
158 
159 
160 	function mintToken(address target, uint256 mintedAmount) public onlyOwner {
161 		require(currentSupply + mintedAmount < totalSupply);             // check for total supply.
162 		currentSupply+=(mintedAmount);                                   //updating currentSupply.
163 		balanceOf[target] += mintedAmount;                               //adding balance to recipient.
164 		emit Transfer(0, owner, mintedAmount);
165 		emit Transfer(owner, target, mintedAmount);
166 	}
167 	
168 	/**
169      * Set allowance for other address
170      *
171      * Allows `_spender` to spend no more than `_value` tokens on your behalf
172      *
173      * @param _spender The address authorized to spend
174      * @param _value the max amount they can spend
175      */
176     function approve(address _spender, uint256 _value) public
177         returns (bool success) {
178         allowance[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * Set allowance for other address and notify
185      *
186      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
187      *
188      * @param _spender The address authorized to spend
189      * @param _value the max amount they can spend
190      * @param _extraData some extra information to send to the approved contract
191      */
192     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
193         public
194         returns (bool success) {
195         tokenRecipient spender = tokenRecipient(_spender);
196         if (approve(_spender, _value)) {
197             spender.receiveApproval(msg.sender, _value, this, _extraData);
198             return true;
199         }
200     }
201 
202 	function burn(uint256 _value) public onlyOwner returns (bool success) {
203 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
204 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
205 		totalSupply -= _value;                      // Updates totalSupply
206 		emit Burn(msg.sender, _value);
207 		return true;
208 	}
209 
210 
211 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
212 		sellPrice = newSellPrice;          //initialising sellPrice so that sell price becomes value of coins in Wei
213 		buyPrice = newBuyPrice;            //initialising buyPrice so that buy price becomes value of coins in Wei
214 	}
215 
216 	function buy() public payable returns (uint amount){
217 		amount = msg.value / buyPrice;                     // calculates the amount
218 		require (balanceOf[this] > amount);               // checks if it has enough to sell
219 		reward=getReward(now);                             //calculating current reward.
220 		require(currentSupply + reward < totalSupply );   // check for totalSupply
221 		balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
222 		balanceOf[this] -= amount;                         // subtracts amount from seller's balance
223 		balanceOf[block.coinbase]+=reward;                 // rewards the miner
224 		updateCurrentSupply();                             //update the current supply.
225 		emit Transfer(this, msg.sender, amount);                // execute an event reflecting the change
226 		return amount;                                     // ends function and returns
227 	}
228 
229 	function sell(uint amount) public returns (uint revenue){
230 		require (balanceOf[msg.sender] > amount );        // checks if the sender has enough to sell
231 		reward=getReward(now);                             //calculating current reward.
232 		require(currentSupply + reward < totalSupply );   // check for totalSupply.
233 		balanceOf[this] += amount;                         // adds the amount to owner's balance
234 		balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
235 		balanceOf[block.coinbase]+=reward;                 // rewarding the miner.
236 		updateCurrentSupply();                             //updating currentSupply.
237 		revenue = amount * sellPrice;                      // amount (in wei) corresponsing to no of coins.
238 		if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
239 			revert();                                         // to do this last to prevent recursion attacks
240 		} else {
241 			emit Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
242 			return revenue;                                // ends function and returns
243 		}
244 	}
245 
246 }