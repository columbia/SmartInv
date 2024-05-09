1 pragma solidity ^0.4.16;
2 
3 
4 contract Token3CC {
5     /* This creates an array with all balances */
6 
7     mapping (address => uint256) public balanceOf;
8 
9     /* This generates a public event on the blockchain that will notify clients */
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 
12     /* Public variables of the token */
13     string public name = "3CC";
14 
15     string public symbol = "3CC";
16 
17     uint8 public decimals = 8;
18 
19     uint256 public initialSupply = 2200000000 * (10 ** uint256(decimals));
20 
21     address public owner;
22 
23     /* Initializes contract with initial supply tokens to the creator of the contract */
24     function Token3CC() public {
25         owner = msg.sender;
26         balanceOf[msg.sender] = initialSupply;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function transferOwnership(address newOwner) public onlyOwner {
35         owner = newOwner;
36     }
37 
38 
39 
40     /* Internal transfer, only can be called by this contract */
41     function _transfer(address _from, address _to, uint256 _value) internal {
42         require(_to != 0x0);
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(balanceOf[_from] >= _value);
45         // Check if the sender has enough
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47         // Check for overflows
48         balanceOf[_from] -= _value;
49         // Subtract from the sender
50         balanceOf[_to] += _value;
51         // Add the same to the recipient
52         Transfer(_from, _to, _value);
53     }
54 
55     /// @notice Send `_value` tokens to `_to` from your account
56     /// @param _to The address of the recipient
57     /// @param _value the amount to send
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62 }