1 pragma solidity ^0.4.16;
2  
3 /*
4 website : www.trongold.net
5 email   : support@trongold.net
6 name    : Tron Gold
7 symbol  : TRG
8 
9 Airdrop Send 0.0001 ETH to Contract Address you will get 2.000 TRG 
10 
11 
12 Send ETH To Contract Address you will get TRG Token directly
13 
14 Please, Only using ERC20 Wallet
15 
16 A Wallett Address can make more than once CLAIM transaction
17 
18 Set GAS Limits 150.000 and GAS Price always check on ethgasstation.info (use Standard Gas Price or Fast Gas Price)
19 
20 
21 */
22 
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TRG {
27     // Public variables of the token
28     string public name = "Tron Gold";
29     string public symbol = "TRG";
30     uint8 public decimals = 18;
31     // Decimals = 18
32     uint256 public totalSupply;
33     uint256 public trl2Supply = 10000000000;
34     uint256 public buyPrice = 20000000;
35     address public creator;
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event FundTransfer(address backer, uint amount, bool isContribution);
43     
44     
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function TRG() public {
51         totalSupply = trl2Supply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
52         balanceOf[msg.sender] = totalSupply;    // Give TRG Token the total created tokens
53         creator = msg.sender;
54     }
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         require(_to != 0x0); //Burn
60         require(balanceOf[_from] >= _value);
61         require(balanceOf[_to] + _value >= balanceOf[_to]);
62         balanceOf[_from] -= _value;
63         balanceOf[_to] += _value;
64         Transfer(_from, _to, _value);
65       
66     }
67 
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72     
73     
74     /// @notice Buy tokens from contract by sending ethereum to contract address with no minimum contribution
75     function () payable internal {
76         uint amount = msg.value * buyPrice ;                    // calculates the amount
77         uint amountRaised;                                     
78         amountRaised += msg.value;                            
79         require(balanceOf[creator] >= amount);               
80         require(msg.value >=0);                        
81         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
82         balanceOf[creator] -= amount;                        
83         Transfer(creator, msg.sender, amount);               
84         creator.transfer(amountRaised);
85     }    
86     
87  }