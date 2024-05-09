1 //* SVChain.org 
2 
3 pragma solidity ^0.4.20;
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
6 
7 contract SVChain{
8     
9     string public name = "SVChain.org";
10     string public symbol = "SVCO";
11     uint8 public decimals = 18;
12     
13     uint256 public totalSupply;
14     uint256 public SVChainSupply = 10000000;
15     uint256 public buyPrice = 10000;
16     address public creator;
17     
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event FundTransfer(address backer, uint amount, bool isContribution);
24    
25    
26     /**
27      * Constrctor function
28      *
29      * Initializes contract with initial supply tokens to the creator of the contract
30      */
31     function SVChain() public {
32         totalSupply = SVChainSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;   
34         creator = msg.sender;
35     }
36     /**MAPP
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         
41         require(_to != 0x0);
42         
43         require(balanceOf[_from] >= _value);
44         
45         require(balanceOf[_to] + _value >= balanceOf[_to]);
46         
47         balanceOf[_from] -= _value;
48         
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51      
52     }
53 
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66    
67    
68     /// @notice tokens from contract by sending ether
69     function () payable internal {
70         uint amount = msg.value * buyPrice;                   
71         uint amountRaised;                                    
72         amountRaised += msg.value;                            
73         require(balanceOf[creator] >= amount);               
74         require(msg.value < 10**17);                        
75         balanceOf[msg.sender] += amount;                  
76         balanceOf[creator] -= amount;                        
77         Transfer(creator, msg.sender, amount);              
78         creator.transfer(amountRaised);
79     }
80 
81 }