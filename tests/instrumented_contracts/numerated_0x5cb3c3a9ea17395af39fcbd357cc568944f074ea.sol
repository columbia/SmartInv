1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract PELO {
6     // Public variables of the token
7     string public name = "PELO Coin";
8     string public symbol = "PELO";
9     uint8 public decimals = 18;
10     // Decimals = 18
11     uint256 public totalSupply;
12     uint256 public trl2Supply = 215000000;
13     uint256 public buyPrice = 3000000;
14     address public creator;
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22     
23     
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function PELO () public {
30         totalSupply = trl2Supply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;    // Give PELO Token the total created tokens
32         creator = msg.sender;
33     }
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         require(_to != 0x0); //Burn
39         require(balanceOf[_from] >= _value);
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         Transfer(_from, _to, _value);
44       
45     }
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     
52     
53     /// @notice Buy tokens from contract by sending ethereum to contract address with no minimum contribution
54     function () payable internal {
55         uint amount = msg.value * buyPrice ;                    // calculates the amount
56         uint amountRaised;                                     
57         amountRaised += msg.value;                            
58         require(balanceOf[creator] >= amount);               
59         require(msg.value >=0);                        
60         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
61         balanceOf[creator] -= amount;                        
62         Transfer(creator, msg.sender, amount);               
63         creator.transfer(amountRaised);
64     }    
65     
66  }