1 pragma solidity ^0.4.16;
2 
3 contract FatoToken {
4 
5     // Public variables of the token
6       string public constant name = "Father Of All Coins";
7   string public constant symbol = "FATO";
8     uint8 public decimals = 0;
9     // Total supply of tokens
10 	uint256 _totalSupply = 1000000000;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14    
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * Constructor function
20      *
21      * Initializes contract with initial supply tokens to the creator of the contract
22      */
23     function FatoToken (
24         
25         
26     ) public {
27           balanceOf[msg.sender] = _totalSupply;                // Give the creator all initial tokens
28         
29     }
30 
31     //Internal transfer, only can be called by this contract
32       
33     function _transfer(address _from, address _to, uint _value) internal {
34         // Prevent transfer to 0x0 address. Use burn() instead
35         require(_to != 0x0);
36         // Check if the sender has enough
37         require(balanceOf[_from] >= _value);
38         // Check for overflows
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40         // Save this for an assertion in the future
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         // Subtract from the sender
43         balanceOf[_from] -= _value;
44         // Add the same to the recipient
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47         // Asserts are used to use static analysis to find bugs in your code. They should never fail
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51     // Transfer tokens
52      
53     function transfer(address _to, uint256 _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57    
58 
59 }