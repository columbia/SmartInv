1 pragma solidity ^0.4.16;

2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

3 contract MICE {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;

10     // This creates an array with all balances
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;

13     // This generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);

15     // This notifies clients about the amount burnt
16     event Burn(address indexed from, uint256 value);

  
17     function MICE(
18         uint256 initialSupply,
19         string tokenName,
20         string tokenSymbol
21     ) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
23         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
24         name = tokenName;                                   // Set the name for display purposes
25         symbol = tokenSymbol;                               // Set the symbol for display purposes
26     }

27     function _transfer(address _from, address _to, uint _value) internal {
28         // Prevent transfer to 0x0 address. Use burn() instead
29         require(_to != 0x0);
30         // Check if the sender has enough
31         require(balanceOf[_from] >= _value);
32         // Check for overflows
33         require(balanceOf[_to] + _value >= balanceOf[_to]);
34         // Save this for an assertion in the future
35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
36         // Subtract from the sender
37         balanceOf[_from] -= _value;
38         // Add the same to the recipient
39         balanceOf[_to] += _value;
40         emit Transfer(_from, _to, _value);
41         // Asserts are used to use static analysis to find bugs in your code. They should never fail
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43     }


44     function transfer(address _to, uint256 _value) public {
45         _transfer(msg.sender, _to, _value);
46     }


47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48         require(_value <= allowance[_from][msg.sender]);     // Check allowance
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }

53     function approve(address _spender, uint256 _value) public
54         returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }

  
58     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
59         public
60         returns (bool success) {
61         tokenRecipient spender = tokenRecipient(_spender);
62         if (approve(_spender, _value)) {
63             spender.receiveApproval(msg.sender, _value, this, _extraData);
64             return true;
65         }
66     }


67     function burn(uint256 _value) public returns (bool success) {
68         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
69         balanceOf[msg.sender] -= _value;            // Subtract from the sender
70         totalSupply -= _value;                      // Updates totalSupply
71         emit Burn(msg.sender, _value);
72         return true;
73     }

74     function burnFrom(address _from, uint256 _value) public returns (bool success) {
75         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
76         require(_value <= allowance[_from][msg.sender]);    // Check allowance
77         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
78         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
79         totalSupply -= _value;                              // Update totalSupply
80         emit Burn(_from, _value);
81         return true;
82     }
83 }