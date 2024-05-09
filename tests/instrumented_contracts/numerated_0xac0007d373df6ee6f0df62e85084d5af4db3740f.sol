1 pragma solidity ^0.4.18;
2 
3 /*
4 
5 Official ANN thread https://bitcointalk.org/index.php?topic=2785585.0
6 Official Website https://uptoken.online
7 
8 IMAGINE a token that can only increase in price. 
9 A really truly cannot-go-down upToken.
10 This is an ERC20 token, an Ethereum based emulation of the Bitcoin ecosystem but with investor protection functions.
11 The purpose of this token is to show how Bitcoin works and provide an even better investment opportunity than Ethereum other than by simply holding on to the coin itself.
12 
13 BUY: When you buy upTokens, your funds are stored in a contract and only you can retrieve them by sending upToken tokens back to the contract.
14 SEND: You can send tokens to another Ethereum address.
15 SELL: You can cash-out at any time and receive back the VALUE of the token, which is simply the exact share of all funds in the contract, less 10% discount. However, if there were no incoming transactions in the contract for the last 5,000 blocks (about 1 day) then you will receive your funds without a 10% discount.
16 
17 There are no pre mined supplies and upToken tokens are  ONLY created in exchange for the ETH received.
18 There is No chance to cheat on the system, No admin rights to the contract - No holes.
19 The code is transparent and can be checked by everyone for validity and fairness.
20 The price of the upToken is set in ETH and CANNOT GO DOWN!
21 
22 Every subsequent purchase transaction has a price that is slightly higher than the previous one.
23 It is  as SAFE as Ethereum, SECURE as Blockchain and as PROFITABLE as Bitcoin but with a LOWER RISK!
24 The most you can loose is 10% which is the premium paid at the purchase, and even with a "panic sale" you can NEVER lose more than the 10% discount.
25 If you wait, the VALUE of the upToken will grow with EVERY transaction.
26 Whenever there is a purchase of upTokens, 10% from this is divided between ALL token owners, including you.
27 When upTokens are sold early, the 10% discount is divided between ALL the remaining token owners.
28 Every time someone sells upTokens for the true value, the value of the remained token stays the same! No rush to go out.
29 
30 As it is a valid ERC20 token, it can be traded and transferred without limitations. It can be listed on the exchanges. After the deployment, its future is in your hands - nobody can control the contract, except for all the token holders with their transactions. There are no administrators, no owners, no support and no possibility to be cheat on, it is a truly a decentralized autonomous system.
31 
32 The longer you stay, the BIGGER your share. 
33 You cannot be late to cash-out.
34 Send ETH to this contract and upTokens will be sent in return with the same transaction to the wallet you sent ETH from. You should send only from your own wallet, not from an exchange's account.
35 
36 */
37 
38 contract upToken{
39 	// This is ERC20 Token	
40     string public name;
41     string public symbol;
42     uint8 public decimals;
43     string public standard = 'Token 0.1';
44     uint256 public totalSupply;
45     
46     /*
47     	The price at which tokens are sold
48     	
49     	tokenPrice is multiplied on 10^9 for precision
50 		
51 		tokenPrice 100000000 = 1 ETH per 10000 PNS
52     */
53     uint256 public tokenPrice;
54 
55 	/*
56 		The price at which the contract redeems tokens
57 		
58 		redeemPrice is multiplied on 10^9 for precision				
59 	*/
60     uint256 public redeemPrice;
61     
62 	/*
63 		Last transaction block number
64 	*/
65     uint256 public lastTxBlockNum;
66     
67     mapping(address => uint256) public balanceOf;
68     mapping(address => mapping(address => uint256)) public allowance;
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Burn(address indexed from, uint256 value);
71 
72     /* 
73     	Contract constructor, this token with decimal = 18 and init price = 1 ETH
74     */
75     function upToken() public {        
76         name = "upToken";
77         symbol = "UPT";
78         decimals = 15;
79         totalSupply = 0;
80 
81 		// Initial pons price is 1 ETH per 10000 PNS
82         tokenPrice = 100000000;
83     }
84     
85 	/*
86 		Transfer tokens and redeem
87 		
88 		When you transfer tokens to the contract it redeem it by current redeemPrice
89 	*/
90     function transfer(address _to, uint256 _value) public {
91     	if (balanceOf[msg.sender] < _value) revert();
92         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
93         
94         uint256 avp = 0;
95         uint256 amount = 0;
96         
97         // Redeem tokens
98         if ( _to == address(this) ) {
99         	/*
100 				Calc amount of ETH, divide on 10^9 because reedemPrice is multiplied for precision
101 				
102 				If the block number after 5000 from the last transaction to the contract, then redeem price is average price
103         	*/
104         	if ( lastTxBlockNum < (block.number-5000) ) {
105         		avp = this.balance * 1000000000 / totalSupply;
106         		amount = ( _value * avp ) / 1000000000;
107         	} else {
108 	        	amount = ( _value * redeemPrice ) / 1000000000;
109 	        }
110         	balanceOf[msg.sender] -= _value;
111         	totalSupply -= _value;
112         	        	
113         	/*
114     			Calc new prices
115 	    	*/
116 	    	if ( totalSupply != 0 ) {
117 	    		avp = (this.balance-amount) * 1000000000 / totalSupply;
118     			redeemPrice = ( avp * 900 ) / 1000;  // -10%
119 	    		tokenPrice = ( avp * 1100 ) / 1000;  // +10%
120 	    	} else {
121 				redeemPrice = 0;
122 	    		tokenPrice = 100000000;
123         	}
124         	if (!msg.sender.send(amount)) revert();
125         	Transfer(msg.sender, 0x0, _value);
126         } else {
127         	balanceOf[msg.sender] -= _value;
128 	        balanceOf[_to] += _value;
129         	Transfer(msg.sender, _to, _value);
130         }        
131     }
132 
133     function approve(address _spender, uint256 _value) public returns(bool success) {
134         allowance[msg.sender][_spender] = _value;
135         return true;
136     }
137 
138     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
139         if (balanceOf[_from] < _value) revert();
140         if ((balanceOf[_to] + _value) < balanceOf[_to]) revert();
141         if (_value > allowance[_from][msg.sender]) revert();
142 
143         balanceOf[_from] -= _value;
144         balanceOf[_to] += _value;
145         allowance[_from][msg.sender] -= _value;
146 
147         Transfer(_from, _to, _value);
148         return true;
149     }
150     
151     /*
152     	Payable function, calls when send ETHs to the contract
153     */
154     function() internal payable {
155     	// If sent ETH value of transaction less than 10 Gwei then revert tran
156     	if ( msg.value < 10000000000 ) revert();
157     	
158     	lastTxBlockNum = block.number;
159     	
160     	uint256 amount = ( msg.value / tokenPrice ) * 1000000000;
161     	balanceOf[msg.sender] += amount;
162     	totalSupply += amount;
163     	
164     	/*
165     		Calc new prices
166     	*/
167     	uint256 avp = this.balance * 1000000000 / totalSupply;
168     	redeemPrice = avp * 900 / 1000;  // -10%
169     	tokenPrice = avp * 1100 / 1000;  // +10%
170     	
171         Transfer(0x0, msg.sender, amount);
172     }
173 }