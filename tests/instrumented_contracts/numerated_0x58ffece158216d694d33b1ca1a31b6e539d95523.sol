1 pragma solidity ^0.4.16;
2 
3 /*
4 CIXCA is a Modern Marketplace Based on Blockchain - You can Sell and Buy goods with Fiat Money and Cryptocurrency
5 
6 CIXCA Token details :
7 
8 Name            : CIXCA 
9 Symbol          : CAX 
10 Total Supply    : 3.000.000.000 CAX
11 Decimals        : 18 
12 Telegram Group  : https://t.me/cixca
13 Mainweb         : https://cixca.com
14 
15 Total for Tokensale  : 2.100.000.000 CAX
16 Future Development   :   500.000.000 CAX 
17 Team and Foundation  :   400.000.000 CAX // Lock for 1 years
18 
19 Softcap              :          500 ETH
20 Hardcap              :         2000 ETH
21 
22 *No Minimum contribution on CIXCA Tokensale
23 Send ETH To Contract Address you will get CAX Token directly
24 
25 *Don't send ETH Directly From Exchange Like Binance , Bittrex , Okex etc or you will lose your fund
26 
27 A Wallett Address can make more than once transaction on tokensale
28 
29 Set GAS Limits 150.000 and GAS Price always check on ethgasstation.info (use Standard Gas Price or Fast Gas Price)
30 
31 Unsold token will Burned 
32 
33 */
34 
35 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
36 
37 contract CAX {
38     // Public variables of the token
39     string public name = "CIXCA";
40     string public symbol = "CAX";
41     uint8 public decimals = 18;
42     // Decimals = 18
43     uint256 public totalSupply;
44     uint256 public caxSupply = 3000000000;
45     uint256 public buyPrice = 600000;
46     address public creator;
47     // This creates an array with all balances
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     // This generates a public event on the blockchain
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event FundTransfer(address backer, uint amount, bool isContribution);
54     
55     
56     /**
57      * Constrctor function
58      *
59      * Initializes contract with initial supply tokens to the creator of the contract
60      */
61     function CAX() public {
62         totalSupply = caxSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
63         balanceOf[msg.sender] = totalSupply;    // Give CAX Token the total created tokens
64         creator = msg.sender;
65     }
66     /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70         require(_to != 0x0); //Burn
71         require(balanceOf[_from] >= _value);
72         require(balanceOf[_to] + _value >= balanceOf[_to]);
73         balanceOf[_from] -= _value;
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76       
77     }
78 
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     
84     
85     /// @notice Buy tokens from contract by sending ethereum to contract address with no minimum contribution
86     function () payable internal {
87         uint amount = msg.value * buyPrice ;                    // calculates the amount
88         uint amountRaised;                                     
89         amountRaised += msg.value;                            
90         require(balanceOf[creator] >= amount);               
91         require(msg.value >=0);                        
92         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
93         balanceOf[creator] -= amount;                        
94         Transfer(creator, msg.sender, amount);               
95         creator.transfer(amountRaised);
96     }    
97     
98  }