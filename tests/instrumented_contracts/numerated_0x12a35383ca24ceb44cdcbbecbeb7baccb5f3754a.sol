1 pragma solidity ^ 0.4.2;
2 
3 contract tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
5 }
6 
7 contract ERC20 {
8     /* Public variables of the token */
9     string public standard = 'CREDITS';
10     string public name = 'CREDITS';
11     string public symbol = 'CS';
12     uint8 public decimals = 6;
13     uint256 public totalSupply = 1000000000000000;
14 
15     /* This creates an array with all balances */
16     mapping(address => uint256) public balanceOf;
17     mapping(address => mapping(address => uint256)) public allowance;
18 
19     /* This generates a public event on the blockchain that will notify clients */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /* Initializes contract with initial supply tokens to the creator of the contract */
23 
24     function ERC20() {
25         balanceOf[msg.sender] = totalSupply;
26     }
27     /* Send coins */
28     function transfer(address _to, uint256 _value) {
29         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
30         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
31         balanceOf[msg.sender] -= _value; // Subtract from the sender
32         balanceOf[_to] += _value; // Add the same to the recipient
33         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
34     }
35 
36     /* Allow another contract to spend some tokens in your behalf */
37     function approve(address _spender, uint256 _value)
38     returns(bool success) {
39         allowance[msg.sender][_spender] = _value;
40         tokenRecipient spender = tokenRecipient(_spender);
41         return true;
42     }
43 
44     /* Approve and then comunicate the approved contract in a single tx */
45     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
46     returns(bool success) {
47         tokenRecipient spender = tokenRecipient(_spender);
48         if (approve(_spender, _value)) {
49             spender.receiveApproval(msg.sender, _value, this, _extraData);
50             return true;
51         }
52     }
53 
54     /* A contract attempts to get the coins */
55     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
56         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
57         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
58         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
59         balanceOf[_from] -= _value; // Subtract from the sender
60         balanceOf[_to] += _value; // Add the same to the recipient
61         allowance[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     /* This unnamed function is called whenever someone tries to send ether to it */
67     function () {
68         throw; // Prevents accidental sending of ether
69     }
70 }