1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)
4 public; }
5 
6 contract Generation {
7     // Public variables of the token
8     string public name = "Generation";
9     string public symbol = "GTN";
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default
12     uint256 public totalSupply;
13     uint256 public GenerationSupply = 99000000;
14     uint256 public buyPrice = 10000;
15     address public creator;
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event FundTransfer(address backer, uint amount, bool isContribution);
23 
24 
25     /**
26      * Constrctor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     function Generation() public {
31         totalSupply = GenerationSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;    // Give Generation Mint the total created tokens
33         creator = msg.sender;
34     }
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50 
51     }
52 
53     /**
54      * Transfer tokens
55      *
56      * Send `_value` tokens to `_to` from your account
57      *
58      * @param _to The address of the recipient
59      * @param _value the amount to send
60      */
61     function transfer(address _to, uint256 _value) public {
62        _transfer(msg.sender, _to, _value);
63     }
64 
65 
66     /// @notice Buy tokens from contract by sending ether
67     function () payable internal {
68         uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many Generation but to get MANY Generation you have to spend ETH and not WEI
69         uint amountRaised;
70         amountRaised += msg.value;                            //many thanks Generation, couldnt do it without r/me_irl
71         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
72         require(msg.value < 10**17);                        // so any person who wants to put more then 0.1 ETH has time to think about what they are doing
73         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
74         balanceOf[creator] -= amount;                        // sends ETH to GenerationMint
75         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
76         creator.transfer(amountRaised);
77     }
78 
79  }