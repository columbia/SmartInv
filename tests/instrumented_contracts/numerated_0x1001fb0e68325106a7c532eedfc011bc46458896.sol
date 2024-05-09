1 pragma solidity ^0.4.18;
2 
3 
4 contract MeridianStandard {
5     
6     string public name = "Meridian";
7     string public symbol = "MDN";
8     uint8 public decimals = 8;
9     
10     uint256 public totalSupply = 125000000;
11     uint256 public initialSupply = 125000000;
12 
13     
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     
21 
22     /**
23      * Constructor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function MeridianStandard
28     (string tokenName, string tokenSymbol) 
29         public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  
31         balanceOf[msg.sender] = totalSupply;                
32         name = tokenName ="Meridian";                                   
33         symbol = tokenSymbol ="MDN";                               
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // Prevent transfer to 0x0 address. Use burn() instead
41         require(_to != 0x0);
42         require(balanceOf[_from] >= _value);
43         require(balanceOf[_to] + _value > balanceOf[_to]);
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47      
48     }
49 
50     /**
51      * Transfer tokens
52      *
53      * Send `_value` tokens to `_to` from your account
54      *
55      * @param _to The address of the recipient
56      * @param _value the amount to send
57      */
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     
63 }