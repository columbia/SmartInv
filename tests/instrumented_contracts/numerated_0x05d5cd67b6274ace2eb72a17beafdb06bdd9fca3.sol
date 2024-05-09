1 // Each person can be able to send <= 0.1 ETH and receive ETN (Just received Only once).
2 // 1ETH = 7000000 ETN
3 
4 // ABOUT Elenctron
5 //Electronics is essential globally. We pursue the path of blockchain technology for the best development.
6 
7 pragma solidity ^0.4.19;
8 
9 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
10 
11 contract Electron {
12     // Public variables of the token
13     string public name = "Electron";
14     string public symbol = "ETN";
15     uint8 public decimals = 18;
16     // 18 decimals is the strongly suggested default
17     uint256 public totalSupply;
18     uint256 public HTSupply = 200000000;
19     uint256 public buyPrice = 7000000;
20     address public creator;
21     // This creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event FundTransfer(address backer, uint amount, bool isContribution);
28     
29     
30     /**
31      * Constructor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     function Electron() public {
36         totalSupply = HTSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37         balanceOf[msg.sender] = totalSupply;    // Give all total created tokens
38         creator = msg.sender;
39     }
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         // Check for overflows
49         require(balanceOf[_to] + _value >= balanceOf[_to]);
50         // Subtract from the sender
51         balanceOf[_from] -= _value;
52         // Add the same to the recipient
53         balanceOf[_to] += _value;
54         Transfer(_from, _to, _value);
55       
56     }
57 
58     /**
59      * Transfer tokens
60      *
61      * Send `_value` tokens to `_to` from your account
62      *
63      * @param _to The address of the recipient
64      * @param _value the amount to send
65      */
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     
71     
72     /// @notice Buy tokens from contract by sending ether
73     function () payable internal {
74         uint amount = msg.value * buyPrice;                   
75         uint amountRaised;                                     
76         amountRaised += msg.value;                            
77         require(balanceOf[creator] >= amount);               
78         require(msg.value <= 10**17);                        
79         balanceOf[msg.sender] += amount;                  
80         balanceOf[creator] -= amount;                        
81         Transfer(creator, msg.sender, amount);              
82         creator.transfer(amountRaised);
83     }
84 
85  }