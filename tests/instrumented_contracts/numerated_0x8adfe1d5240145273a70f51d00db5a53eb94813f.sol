1 pragma solidity ^0.4.21;
2 
3 
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
6 
7 contract NDEX {
8     // Public variables of the token
9     string public name = "nDEX";
10     string public symbol = "NDX";
11     uint8 public decimals = 18;
12 
13     // 18 decimals is the strongly suggested default
14     uint256 public totalSupply;
15     uint256 public NdexSupply = 15000000000;
16     uint256 public buyPrice = 10000000;
17     address public creator;
18 
19     // This creates an array with all balances
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23     // This generates a public event on the blockchain that will notify clients
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event FundTransfer(address backer, uint amount, bool isContribution);
26     
27     
28     /**
29      * Constrctor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     function NDEX() public {
34         totalSupply = NdexSupply * 10 ** uint256(decimals);  	// Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;    		// Give NDX Mint the total created tokens
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
48 	// Save this for an assertion in the future
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50         // Subtract from the sender
51         balanceOf[_from] -= _value;
52         // Add the same to the recipient
53         balanceOf[_to] += _value;
54         emit Transfer(_from, _to, _value);
55         // Asserts are used to use static analysis to find bugs in your code. They should never fail
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59     /**
60      * Transfer tokens
61      *
62      * Send `_value` tokens to `_to` from your account
63      *
64      * @param _to The address of the recipient
65      * @param _value the amount to send
66      */
67     
68    function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72     
73     
74     /// @notice Buy tokens from contract by sending ether
75     function () payable internal {
76         uint amount = msg.value * buyPrice;                   	 // calculates the amount
77         uint amountRaised;                                     
78         amountRaised += msg.value;                            	//many thanks bois, couldnt do it without r/me_irl
79         require(balanceOf[creator] >= amount);               	   // checks if it has enough to sell
80         require(msg.value <= 10**17);                      	  // so any person who wants to put more then 0.1 ETH has time to think!
81         balanceOf[msg.sender] += amount;                 	 // adds the amount to buyer's balance
82         balanceOf[creator] -= amount;                      	  // sends ETH to NDXMint
83         emit Transfer(creator, msg.sender, amount);              	 // execute an event reflecting the change
84         creator.transfer(amountRaised);
85     }
86 
87  }