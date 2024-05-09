1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract PapaBearToken {
6     // Public variables of the token
7     string public name = "PapaBearToken";
8     string public symbol = "PBEAR";
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11     uint256 public supplyMultiplier = 1000000000;
12     uint256 public buyPrice = 10000000;
13     address public creator;
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21     
22     
23     /**
24      * Constructor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function PapaBearToken() public {
29         totalSupply = supplyMultiplier * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;    // assign total created tokens
31         creator = msg.sender;
32     }
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48       
49     }
50 
51     /**
52      * Transfer tokens
53      *
54      * Send `_value` tokens to `_to` from your account
55      *
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     
64     
65     /// @notice Buy tokens from contract by sending ether
66     function () payable internal {
67         uint amount = msg.value * buyPrice;                    
68         uint amountRaised;                                     
69         amountRaised += msg.value;                           
70         require(balanceOf[creator] >= amount);                      
71         balanceOf[msg.sender] += amount;                 
72         balanceOf[creator] -= amount;                       
73         Transfer(creator, msg.sender, amount);             
74         creator.transfer(amountRaised);
75     }
76 
77  }