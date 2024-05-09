1 pragma solidity ^0.4.24;
2 
3 contract PoriniDoGoodToken {
4 
5     // Public variables of the token
6     string public name = 'PoriniFoundationDoGoodToken';
7     string public symbol = 'PORDGT';
8     uint8 public decimals = 18;
9     // 18 decimals is the strongly suggested default, avoid changing it
10     uint256 public totalSupply;
11     uint256 public initSupply = 888888;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15    
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * Constructor function
21      *
22      * Initializes contract with initial supply tokens to the creator of the contract
23      */
24     function PoriniDoGoodToken() public {
25         
26         totalSupply = initSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
27         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
28     }
29 
30     /**
31      * Internal transfer, only can be called by this contract
32      */
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
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` in behalf of `_from`
67      *
68      * @param _from The address of the sender
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 }