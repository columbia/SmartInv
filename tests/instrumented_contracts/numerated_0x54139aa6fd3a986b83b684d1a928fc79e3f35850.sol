1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BubbleCoin {
6     // Public variables of the token
7     string public name;
8     string  public symbol;
9     uint8 public decimals = 3;
10     uint256 public totalSupply;
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     // This generates a public event on the blockchain that will notify clients
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     function BubbleCoin() public {
17         totalSupply = 100000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
18         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
19         name = "BubbleCoin";                                   // Set the name for display purposes
20         symbol = "BBL";                               // Set the symbol for display purposes
21     }
22     function _transfer(address _from, address _to, uint _value) internal {
23         // Prevent transfer to 0x0 address. Use burn() instead
24         require(_to != 0x0);
25         // Check if the sender has enough
26         require(balanceOf[_from] >= _value);
27         // Check for overflows
28         require(balanceOf[_to] + _value > balanceOf[_to]);
29         // Save this for an assertion in the future
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         // Subtract from the sender
32         balanceOf[_from] -= _value;
33         // Add the same to the recipient
34         balanceOf[_to] += _value;
35         Transfer(_from, _to, _value);
36         // Asserts are used to use static analysis to find bugs in your code. They should never fail
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39     function transfer(address _to, uint256 _value) public {
40         _transfer(msg.sender, _to, _value);
41     }
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(_value <= allowance[_from][msg.sender]);     // Check allowance
44         allowance[_from][msg.sender] -= _value;
45         _transfer(_from, _to, _value);
46         return true;
47     }
48     function approve(address _spender, uint256 _value) public returns (bool success) {
49         allowance[msg.sender][_spender] = _value;
50         return true;
51     }
52     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
53         tokenRecipient spender = tokenRecipient(_spender);
54         if (approve(_spender, _value)) {
55             spender.receiveApproval(msg.sender, _value, this, _extraData);
56             return true;
57         }
58     }
59 }