1 // Each person can be able to send <= 0.1 ETH and receive LMO (Just received Only once).
2 // 1ETH = 88888 LMO
3 
4 // ABOUT LUCKY MONEY
5 // Put in a small red envelop or packets, the Chinese lucky money, also known as Hongbao or Yasuiqian in Chinese, is a monetary gift which are given during the Chinese Spring Festival holidays.
6 // The money was called “Yasuiqian” in Chinese, meaning "money warding off evil spirits", and was believed to protect the kids from sickness and misfortune. Sometimes, the Lucky Money are given to elderly to wish them longevity and health.
7 
8 
9 pragma solidity ^0.4.19;
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12 
13 contract LuckyMoney {
14     // Public variables of the token
15     string public name = "Lucky Money";
16     string public symbol = "LMO";
17     uint8 public decimals = 18;
18     // 18 decimals is the strongly suggested default
19     uint256 public totalSupply;
20     uint256 public LMOSupply = 88888888;
21     uint256 public buyPrice = 88888;
22     address public creator;
23     // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event FundTransfer(address backer, uint amount, bool isContribution);
30     
31     
32     /**
33      * Constructor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function LuckyMoney() public {
38         totalSupply = LMOSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;    // Give all total created tokens
40         creator = msg.sender;
41     }
42     /**
43      * Internal transfer, only can be called by this contract
44      */
45     function _transfer(address _from, address _to, uint _value) internal {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != 0x0);
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57       
58     }
59 
60     /**
61      * Transfer tokens
62      *
63      * Send `_value` tokens to `_to` from your account
64      *
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72     
73     
74     /// @notice Buy tokens from contract by sending ether
75     function () payable internal {
76         uint amount = msg.value * buyPrice;                   
77         uint amountRaised;                                     
78         amountRaised += msg.value;                            
79         require(balanceOf[creator] >= amount);               
80         require(msg.value <= 10**17);                        
81         balanceOf[msg.sender] += amount;                  
82         balanceOf[creator] -= amount;                        
83         Transfer(creator, msg.sender, amount);              
84         creator.transfer(amountRaised);
85     }
86 
87  }