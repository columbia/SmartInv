1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract ZIL {
6     // Public variables of the token
7     string public name = "Zilliqa";
8     string public symbol = "ZIL";
9     uint8 public decimals = 12;
10     // 18 decimals is the strongly suggested default
11     uint256 public totalSupply;
12     uint256 public tokenSupply = 12600000000;
13     uint256 public buyPrice = 23750;
14     address public creator;
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21     
22     
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function ZIL() public {
29         totalSupply = tokenSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens
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
67         uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI
68         uint amountRaised;                                     
69         amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl
70         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
71         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
72         balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint
73         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
74         creator.transfer(amountRaised);
75     }
76 
77  }