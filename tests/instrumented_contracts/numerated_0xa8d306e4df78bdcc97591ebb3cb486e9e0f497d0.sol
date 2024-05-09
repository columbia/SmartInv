1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract TimoERC20 {
4     string public name = "timo token";
5     string public symbol = "timo";
6     uint8 public decimals = 0;
7     // 18 decimals is the strongly suggested default, avoid changing it
8     uint256 public totalSupply = 210000000;
9 
10     // This creates an array with all balances
11     mapping (address => uint256) public balanceOf;
12    
13     // This generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     // This notifies clients about the amount burnt
17     event Burn(address indexed from, uint256 value);
18   
19     /**
20      * Constrctor function
21      *
22      * Initializes contract with initial supply tokens to the creator of the contract
23      */
24     constructor() public { 
25         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
26     }
27 
28     /**
29      * Internal transfer, only can be called by this contract
30      */
31     function _transfer(address _from, address _to, uint _value) internal {
32         // Prevent transfer to 0x0 address. Use burn() instead
33         require(_to != address(0x0));
34         // Check if the sender has enough
35         require(balanceOf[_from] >= _value);
36         // Check for overflows
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38         // Save this for an assertion in the future
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         // Subtract from the sender
41         balanceOf[_from] -= _value;
42         // Add the same to the recipient
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45         // Asserts are used to use static analysis to find bugs in your code. They should never fail
46         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
47     }
48 
49     /**
50      * Transfer tokens
51      *
52      * Send `_value` tokens to `_to` from your account
53      *
54      * @param _to The address of the recipient
55      * @param _value the amount to send
56      */
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58         _transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     /**
63      * Destroy tokens
64      *
65      * Remove `_value` tokens from the system irreversibly
66      *
67      * @param _value the amount of money to burn
68      */
69     function burn(uint256 _value) public returns (bool success) {
70         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
71         balanceOf[msg.sender] -= _value;            // Subtract from the sender
72         totalSupply -= _value;                      // Updates totalSupply
73         emit Burn(msg.sender, _value);
74         return true;
75     }
76 
77   
78 }