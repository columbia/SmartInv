1 pragma solidity ^0.4.16;
2 
3 /*
4 MOSBIN is a Modern Marketplace Based on Blockchain - You can Sell and Buy goods with Fiat Money and Cryptocurrency
5 
6 MOSBIN Token details :
7 
8 Name            : MOSBIN 
9 Symbol          : MOS 
10 Total Supply    : 2.000.000.000 MOS
11 Decimals        : 18 
12 Telegram Group  : https://t.me/mosbin
13 
14 Tokensale Details    :
15 
16 Total for Tokensale         : 1.200.000.000 MOS 
17 
18 Tokensale (+airdrop) Tier 1 : 200.000.000 MOS
19 *Price   : 600.000 MOS/ETH 
20 No minimum Contribution but if contribute 0.1 ETH or more will get 50% Bonus
21 
22 Tokensale (+airdrop) Tier 2 : 400.000.000 MOS
23 *Price   : 600.000 MOS/ETH 
24 No minimum Contribution but if contribute 0.1 ETH or more will get 25% Bonus
25 
26 Tokensale (+airdrop) Tier 3 : 600.000.000 MOS
27 *Price   : 600.000 MOS/ETH 
28 No minimum Contribution but if contribute 0.1 ETH or more will get 10% Bonus
29 
30 
31 Future Development   :   500.000.000 MOS 
32 Team and Foundation  :   300.000.000 MOS // Lock for 1 years
33 
34 Softcap              :           400 ETH
35 Hardcap              :         1.400 ETH
36 
37 *No Minimum contribution on MOS Tokensale
38 Send ETH To Contract Address you will get MOSBIN Token directly set gas limit 150.000
39 
40 *Airdrop - If you don't have enough ETH , you can send 0 ETH to Contract Address and you will get "70 MOS" / Transaction 
41 A Wallett Address can make more than once transaction on tokensale and airdrop 
42 
43 Set GAS Limits 150.000 and GAS Price always check on ethgasstation.info (use Standard Gas Price or Fast Gas Price)
44 Each contribution on Tokensale will get 70 MOS Extra  
45 Unsold token will Burned 
46 
47 Add Custom Token on Myetherwallet and Metamask
48 
49 Contract : 0x64599d1707d4ec6adcf7bd194af4b42a1ddc0c07
50 Symbol   : MOS 
51 Decimals : 18 
52 
53 */
54 
55 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
56 
57 contract MOS {
58     // Public variables of the token
59     string public name = "MOSBIN";
60     string public symbol = "MOS";
61     uint8 public decimals = 18;
62     // Decimals = 18
63     uint256 public totalSupply;
64     uint256 public btnSupply = 2000000000;
65     uint256 public buyPrice = 600000;
66     address public creator;
67     // This creates an array with all balances
68     mapping (address => uint256) public balanceOf;
69     mapping (address => mapping (address => uint256)) public allowance;
70 
71     // This generates a public event on the blockchain
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event FundTransfer(address backer, uint amount, bool isContribution);
74     
75     
76     /**
77      * Constrctor function
78      *
79      * Initializes contract with initial supply tokens to the creator of the contract
80      */
81     function MOS() public {
82         totalSupply = btnSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
83         balanceOf[msg.sender] = totalSupply;    // Give MOS Token the total created tokens
84         creator = msg.sender;
85     }
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         require(_to != 0x0); //Burn
91         require(balanceOf[_from] >= _value);
92         require(balanceOf[_to] + _value >= balanceOf[_to]);
93         balanceOf[_from] -= _value;
94         balanceOf[_to] += _value;
95         Transfer(_from, _to, _value);
96       
97     }
98 
99     function transfer(address _to, uint256 _value) public {
100         _transfer(msg.sender, _to, _value);
101     }
102 
103     
104     
105     /// @notice Buy tokens from contract by sending ethereum to contract address with no minimum contribution
106     function () payable internal {
107         uint amount = msg.value * buyPrice +70e18 ;                    // calculates the amount
108         uint amountRaised;                                     
109         amountRaised += msg.value;                            
110         require(balanceOf[creator] >= amount);               
111         require(msg.value >=0);                        
112         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
113         balanceOf[creator] -= amount;                        
114         Transfer(creator, msg.sender, amount);               
115         creator.transfer(amountRaised);
116     }    
117     
118  }