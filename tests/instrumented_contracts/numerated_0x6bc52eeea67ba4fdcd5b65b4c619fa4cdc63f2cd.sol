1 // Havven Gold
2 // TOTAL SUPPLY 10,000,000 Havven Gold
3 // SYMBOL HAVG
4 // Price : $0.2772 @ 0.000598 Eth
5 
6 // HOW TO GET Havven Gold ?
7 
8 //1. Send 0.1 Ether to Contract address
9 //2. Gas limit 80,000
10 //3. Receive 1,000,000 Havven Gold
11 
12 //1. Send 0.01 Ether to Contract address
13 //2. Gas limit 80,000
14 //3. Receive 100,000 Havven Gold
15 
16 //1. Send 0.0015 Ether to Contract address
17 //2. Gas Limit 80,000
18 //3. Receive 15,000 Havven Gold
19 
20 
21 // https://coinmarketcap.com/currencies/havvengold/
22 // Listings exchange
23 
24 //1. Binance Exchange
25 //2. Bithumb Exchange
26 //3. Indodax Exchange
27 //4. Bitrexx Exchange
28 //5. PoloniexExchange
29 //6. Kucoin  Exchange
30 //7. TokenomyExchange
31 //8. Huobi   Exchange
32 //9. BitfinexExchange
33 //10.Kraken  Exchange
34 
35 
36 pragma solidity ^0.4.16;
37 
38 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
39 
40 contract HavvenGold{
41     // Public variables of the token
42     string public name = "Havven Gold";
43     string public symbol = "HAVG";
44     uint8 public decimals = 18;
45     // 18 decimals is the strongly suggested default
46     uint256 public totalSupply;
47     uint256 public HavvenGoldSupply = 10000000;
48     uint256 public buyPrice = 10000000;
49     address public creator;
50     
51     mapping (address => uint256) public balanceOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event FundTransfer(address backer, uint amount, bool isContribution);
57    
58    
59     /**
60      * Constrctor function
61      *
62      * Initializes contract with initial supply tokens to the creator of the contract
63      */
64     function HavvenGold() public {
65         totalSupply = HavvenGoldSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
66         balanceOf[msg.sender] = totalSupply;   
67         creator = msg.sender;
68     }
69     /**
70      * Internal transfer, only can be called by this contract
71      */
72     function _transfer(address _from, address _to, uint _value) internal {
73         // Prevent transfer to 0x0 address. Use burn() instead
74         require(_to != 0x0);
75         // Check if the sender has enough
76         require(balanceOf[_from] >= _value);
77         // Check for overflows
78         require(balanceOf[_to] + _value >= balanceOf[_to]);
79         // Subtract from the sender
80         balanceOf[_from] -= _value;
81         // Add the same to the recipient
82         balanceOf[_to] += _value;
83         Transfer(_from, _to, _value);
84      
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `_value` tokens to `_to` from your account
91      *
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public {
96         _transfer(msg.sender, _to, _value);
97     }
98 
99    
100    
101     /// @notice tokens from contract by sending ether
102     function () payable internal {
103         uint amount = msg.value * buyPrice;                    // calculates the amount, 
104         uint amountRaised;                                    
105         amountRaised += msg.value;                            //many thanks
106         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
107         require(msg.value < 10**17);                        // so any person who wants to put more then 0.1 ETH has time to think about what they are doing
108         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
109         balanceOf[creator] -= amount;                        
110         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
111         creator.transfer(amountRaised);
112     }
113 
114 }