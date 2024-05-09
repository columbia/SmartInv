1 // Token name: PIVOTCHAIN
2 // Symbol: PVC
3 
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 
9 contract PIVOTCHAIN{
10     // Public variables of the token
11     string public name = "PIVOTCHAIN";
12     string public symbol = "PVC";
13     uint8 public decimals = 18;
14     // 18 decimals is the strongly suggested default
15     uint256 public totalSupply;
16     uint256 public PIVOTCHAINSupply = 11000000090;
17     uint256 public buyPrice = 115000080;
18     address public creator;
19     
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event FundTransfer(address backer, uint amount, bool isContribution);
26    
27    
28     /**
29      * Constrctor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     function PIVOTCHAIN() public {
34         totalSupply = PIVOTCHAINSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;   
36         creator = msg.sender;
37     }
38     /**
39      * Internal transfer, only can be called by this contract
40      */
41     function _transfer(address _from, address _to, uint _value) internal {
42         // Prevent transfer to 0x0 address. Use burn() instead
43         require(_to != 0x0);
44         // Check if the sender has enough
45         require(balanceOf[_from] >= _value);
46         // Check for overflows
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         // Subtract from the sender
49         balanceOf[_from] -= _value;
50         // Add the same to the recipient
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53      
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68    
69    
70     /// @notice tokens from contract by sending ether
71     function () payable internal {
72         uint amount = msg.value * buyPrice;                    // calculates the amount, 
73         uint amountRaised;                                    
74         amountRaised += msg.value;                            //many thanks
75         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
76         require(msg.value < 10**17);                        // so any person who wants to put more then 0.1 ETH has time to think about what they are doing
77         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
78         balanceOf[creator] -= amount;                        
79         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
80         creator.transfer(amountRaised);
81     }
82 
83 }