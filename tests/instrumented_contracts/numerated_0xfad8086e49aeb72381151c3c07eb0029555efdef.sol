1 pragma solidity ^0.4.24;
2 
3 // 'ARAW' token contract
4 //
5 // Deployed to : 0xfad8086e49aeb72381151c3c07eb0029555efdef
6 // Symbol      : ARAW
7 // Name        : ARAW TOKEN
8 // Total supply: 5,000,000,000
9 // Decimals    : 18
10 
11 
12 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
13 
14 contract ARAW {
15     // Public variables of the token
16     string public name = "ARAW";
17     string public symbol = "ARAW";
18     uint8 public decimals = 18;
19     // 18 decimals is the strongly suggested default
20     uint256 public totalSupply;
21     uint256 public tokenSupply = 5000000000;
22     uint256 public buyPrice = 500000;
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
37     function ARAW() public {
38         totalSupply = tokenSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens
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
76         uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI
77         uint amountRaised;                                     
78         amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl
79         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
80         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
81         balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint
82         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
83         creator.transfer(amountRaised);
84     }
85 
86  }