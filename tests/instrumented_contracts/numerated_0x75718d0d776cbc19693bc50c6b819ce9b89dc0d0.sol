1 pragma solidity ^0.4.24;
2 
3 // 'AELEUS TOKEN' CROWDSALE token contract
4 //
5 // Symbol      : AEL
6 // Name        : AELEUS TOKEN
7 // Total supply: 200,000,000
8 // Decimals    : 18
9 
10 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
11 
12 contract AEL {
13     // Public variables of the token
14     string public name = "AELEUS";
15     string public symbol = "AEL";
16     uint8 public decimals = 18;
17     // 18 decimals is the strongly suggested default
18     uint256 public totalSupply;
19     uint256 public tokenSupply = 200000000;
20     uint public presale;
21     uint public coresale;
22     
23     address public creator;
24     // This creates an array with all balances
25     mapping (address => uint256) public balanceOf;
26     mapping (address => mapping (address => uint256)) public allowance;
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event FundTransfer(address backer, uint amount, bool isContribution);
30     
31     
32     /**
33      * Constrctor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function AEL() public {
38         totalSupply = tokenSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens
40         creator = msg.sender;
41         presale = now + 21 days;
42         coresale = now + 41 days;
43     }
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != 0x0);
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         // Subtract from the sender
55         balanceOf[_from] -= _value;
56         // Add the same to the recipient
57         balanceOf[_to] += _value;
58         Transfer(_from, _to, _value);
59       
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     
71     
72    function transfer(address[] _to, uint256[] _value) public {
73     for (uint256 i = 0; i < _to.length; i++)  {
74         _transfer(msg.sender, _to[i], _value[i]);
75         }
76     }
77 
78 
79     /// @notice Buy tokens from contract by sending ether
80     function () payable internal {
81         uint amount;                   
82         uint amountRaised;
83 
84         if (now <= presale) {
85             amount = msg.value * 15000;
86         } else if (now > presale && now <= coresale) {
87             amount = msg.value * 13000;
88         } else if (now > coresale) {
89             amount = msg.value * 10000;
90         }
91         
92 
93                                              
94         amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl
95         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
96         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
97         balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint
98         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
99         creator.transfer(amountRaised);
100     }
101 
102  }