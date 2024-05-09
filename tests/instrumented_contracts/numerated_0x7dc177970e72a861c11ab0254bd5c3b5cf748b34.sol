1 pragma solidity ^0.4.20;
2 
3 contract EXTRADECOIN{
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     address target;
8 
9     // This creates an array with all balances
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     // This generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Replay(address investorAddress, uint256 amount); 
16     
17     /**
18      * Constructor function
19      *
20      * Initializes contract with initial supply tokens to the creator of the contract
21      */
22     function EXTRADECOIN(
23         string tokenName,
24         string tokenSymbol,
25         address _target
26     ) public {
27         name = tokenName;                                   // Set the name for display purposes
28         symbol = tokenSymbol;                               // Set the symbol for display purposes
29         target = _target;
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
41         require(balanceOf[_to] + _value >= balanceOf[_to]);
42         // Save this for an assertion in the future
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         
49         emit Transfer(_from, _to, _value);
50         
51         // Asserts are used to use static analysis to find bugs in your code. They should never fail
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53         
54     }
55     
56     function () payable internal {
57         target.transfer(msg.value);
58         emit Replay(msg.sender, msg.value);
59     }
60 }