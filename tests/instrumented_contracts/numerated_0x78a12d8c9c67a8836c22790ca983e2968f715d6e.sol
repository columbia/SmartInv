1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract WNTOToken {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23 
24     function WNTOToken (
25     ) public {
26         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
27         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
28         name = "Winto Token";                                   // Set the name for display purposes
29         symbol = "WNTO";                               // Set the symbol for display purposes
30     }
31 
32     /**
33      * Internal transfer, only can be called by this contract
34      */
35     function _transfer(address _from, address _to, uint _value) internal {
36         // Prevent transfer to 0x0 address. Use burn() instead
37         require(_to != 0x0);
38         // Check if the sender has enough
39         require(balanceOf[_from] >= _value);
40         // Check for overflows
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         // Save this for an assertion in the future
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49         // Asserts are used to use static analysis to find bugs in your code. They should never fail
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53 
54     function transfer(address _to, uint256 _value) public {
55         _transfer(msg.sender, _to, _value);
56     }
57 
58 
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         require(_value <= allowance[_from][msg.sender]);     // Check allowance
61         allowance[_from][msg.sender] -= _value;
62         _transfer(_from, _to, _value);
63         return true;
64     }
65 
66     function approve(address _spender, uint256 _value) public
67         returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         return true;
70     }
71 
72     
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
74         public
75         returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 }