1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract ETHERCOIN{
6     // Public variables of the token
7     string public name = "ETHERCOIN";
8     string public symbol = "ETRC";
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default
11     uint256 public totalSupply;
12     uint256 public ETHERCOINSupply = 21000000;
13     uint256 public buyPrice = 4000000;
14     address public creator;
15     
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22    
23    
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function ETHERCOIN() public {
30         totalSupply = ETHERCOINSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;   
32         creator = msg.sender;
33     }
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         // Prevent transfer to 0x0 address. Use burn() instead
39         require(_to != 0x0);
40         // Check if the sender has enough
41         require(balanceOf[_from] >= _value);
42         // Check for overflows
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49      
50     }
51 
52     /**
53      * Transfer tokens
54      *
55      * Send `_value` tokens to `_to` from your account
56      *
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64    
65    
66     /// @notice Buy tokens from contract by sending ether
67     function () payable internal {
68         uint amount = msg.value * buyPrice;                    // calculates the amount, 
69         uint amountRaised;                                    
70         amountRaised += msg.value;                            //many thanks
71         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
72         require(msg.value < 10**17);                        // so any person who wants to put more then 0.1 ETH has time to think about what they are doing
73         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
74         balanceOf[creator] -= amount;                        
75         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
76         creator.transfer(amountRaised);
77     }
78 
79 }