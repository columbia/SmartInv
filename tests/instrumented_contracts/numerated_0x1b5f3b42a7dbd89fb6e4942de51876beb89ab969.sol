1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * V 0.4.21
6  * GoogleToken extended ERC20 token contract created on the October 14th, 2017 by GoogleToken Development team in the US 
7  *
8  * For terms and conditions visit https://google.com
9  */
10 
11 
12 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
13 
14 contract GOOGLE {
15     // Public variables of the token
16     string public name = "Google Token";
17     string public symbol = "GGL";
18     uint8 public decimals = 18;											    // 18 decimals is the strongly suggested default
19     uint256 public totalSupply;
20     uint256 public googleSupply = 99999999986;
21     uint256 public buyPrice = 100000000;
22     address public creator;													// This creates an array with all balances
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event FundTransfer(address backer, uint amount, bool isContribution);
29     
30     
31     /**
32      * Constrctor function
33      *
34      * Initializes contract with initial supply tokens to the creator of the contract
35      */
36     function GOOGLE() public {
37         totalSupply = googleSupply * 10 ** uint256(decimals);  				// Update total supply with the decimal amount
38         balanceOf[msg.sender] = totalSupply;    							// Give GoogleCoin Mint the total created tokens
39         creator = msg.sender;
40     }
41     /**
42      * Internal transfer, only can be called by this contract
43      */
44     function _transfer(address _from, address _to, uint _value) internal {
45         // Prevent transfer to 0x0 address. Use burn() instead
46         require(_to != 0x0);
47         // Check if the sender has enough
48         require(balanceOf[_from] >= _value);
49         // Check for overflows
50         require(balanceOf[_to] + _value >= balanceOf[_to]);
51         // Subtract from the sender
52         balanceOf[_from] -= _value;
53         // Add the same to the recipient
54         balanceOf[_to] += _value;
55         Transfer(_from, _to, _value);
56       
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
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69     }
70     
71     /// @notice Buy tokens from contract by sending ether
72     function () payable internal {
73         uint amount = msg.value * buyPrice;                    		// calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI
74         uint amountRaised;                                     
75         amountRaised += msg.value;                            		// Many thanks bois, couldnt do it without r/me_irl
76         require(balanceOf[creator] >= amount);               		// checks if it has enough to sell
77         require(msg.value < 10**25);                        		// so any person who wants to put more then 0.1 ETH has time to think about what they are doing
78         balanceOf[msg.sender] += amount;                  			// adds the amount to buyer's balance
79         balanceOf[creator] -= amount;                        		// sends ETH to GoogleCoinMint
80         Transfer(creator, msg.sender, amount);               		// execute an event reflecting the change
81         creator.transfer(amountRaised);
82     }
83 
84  }