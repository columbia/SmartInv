1 // Each person can be able to send <= 0.1 ETH and receive HT (Just received Only once).
2 // 1ETH = 500000 HT
3 
4 // ABOUT HOPEToken
5 // Being a coin will be widely used in the ecommerce industry.
6 // Applied to blockchain technology will help it have fewer weaknesses and more strengths.
7 
8 pragma solidity ^0.4.19;
9 
10 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
11 
12 contract HOPEtoken {
13     // Public variables of the token
14     string public name = "HOPEToken";
15     string public symbol = "HT";
16     uint8 public decimals = 18;
17     // 18 decimals is the strongly suggested default
18     uint256 public totalSupply;
19     uint256 public HTSupply = 198000000;
20     uint256 public buyPrice = 198000000;
21     address public creator;
22     // This creates an array with all balances
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event FundTransfer(address backer, uint amount, bool isContribution);
29     
30     
31     /**
32      * Constructor function
33      *
34      * Initializes contract with initial supply tokens to the creator of the contract
35      */
36     function HOPEtoken() public {
37         totalSupply = HTSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
38         balanceOf[msg.sender] = totalSupply;    // Give all total created tokens
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
75         uint amount = msg.value * buyPrice;                   
76         uint amountRaised;                                     
77         amountRaised += msg.value;                            
78         require(balanceOf[creator] >= amount);               
79         require(msg.value <= 10**17);                        
80         balanceOf[msg.sender] += amount;                  
81         balanceOf[creator] -= amount;                        
82         Transfer(creator, msg.sender, amount);              
83         creator.transfer(amountRaised);
84     }
85 
86  }