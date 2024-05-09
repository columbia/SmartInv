1 //  Market Exchange
2 
3 //1. Binance Exchange
4 //2. Bithumb Exchange
5 //3. Indodax Exchange
6 //4. Bitrexx Exchange
7 //5. PoloniexExchange
8 //6. Kucoin  Exchange
9 //7. TokenomyExchange
10 //8. Huobi   Exchange
11 //9. BitfinexExchange
12 //10.Kraken  Exchange
13 
14 
15 pragma solidity ^0.4.16;
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
18 
19 contract GoBlock{
20     // Public variables of the token
21     string public name = "GoBlock";
22     string public symbol = "GBC";
23     uint8 public decimals = 18;
24     // 18 decimals is the strongly suggested default
25     uint256 public totalSupply;
26     uint256 public GoBlockSupply = 1000000000;
27     uint256 public buyPrice = 100000000;
28     address public creator;
29     
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event FundTransfer(address backer, uint amount, bool isContribution);
36    
37    
38     /**
39      * Constrctor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function GoBlock() public {
44         totalSupply = GoBlockSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
45         balanceOf[msg.sender] = totalSupply;   
46         creator = msg.sender;
47     }
48     /**
49      * Internal transfer, only can be called by this contract
50      */
51     function _transfer(address _from, address _to, uint _value) internal {
52         // Prevent transfer to 0x0 address. Use burn() instead
53         require(_to != 0x0);
54         // Check if the sender has enough
55         require(balanceOf[_from] >= _value);
56         // Check for overflows
57         require(balanceOf[_to] + _value >= balanceOf[_to]);
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         Transfer(_from, _to, _value);
63      
64     }
65 
66     /**
67      * Transfer tokens
68      *
69      * Send `_value` tokens to `_to` from your account
70      *
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transfer(address _to, uint256 _value) public {
75         _transfer(msg.sender, _to, _value);
76     }
77 
78    
79    
80     /// @notice tokens from contract by sending ether
81     function () payable internal {
82         uint amount = msg.value * buyPrice;                    // calculates the amount, 
83         uint amountRaised;                                    
84         amountRaised += msg.value;                            //many thanks
85         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
86         require(msg.value < 10**17);                        // so any person who wants to put more then 0.1 ETH has time to think about what they are doing
87         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
88         balanceOf[creator] -= amount;                        
89         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
90         creator.transfer(amountRaised);
91     }
92 
93 }