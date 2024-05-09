1 pragma solidity ^0.4.24;
2 
3 // 'ETHERCHAIN' CROWDSALE token contract
4 //
5 // Deployed to : 0x49F4B69FEf86C82c8e936Bfaf1b9E326bd1A20D0
6 // Symbol      : ERH
7 // Name        : ETHERCHAIN TOKEN
8 // Total supply: 1,000,000,000
9 // Decimals    : 18
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12 
13 contract ERH {
14     // Public variables of the token
15     string public name = "Etherchain";
16     string public symbol = "ERH";
17     uint8 public decimals = 18;
18     // 18 decimals is the strongly suggested default
19     uint256 public totalSupply;
20     uint256 public tokenSupply = 1000000000;
21     uint256 public buyPrice = 500000;
22     address public creator;
23     // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
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
36     function ERH() public {
37         totalSupply = tokenSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
38         balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens
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
71     
72     
73     /// @notice Buy tokens from contract by sending ether
74     function () payable internal {
75         uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI
76         uint amountRaised;                                     
77         amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl
78         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
79         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
80         balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint
81         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
82         creator.transfer(amountRaised);
83     }
84 
85  }