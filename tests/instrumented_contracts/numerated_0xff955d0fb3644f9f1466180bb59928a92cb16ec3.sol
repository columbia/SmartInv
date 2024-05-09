1 pragma solidity ^0.4.24;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
3 contract BeeAppToken {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply = 1500000000000000000000000000;
10     // This creates an array with all balances
11     mapping (address => uint256) public balanceOf;
12     //mapping (address => mapping (address => uint256)) public allowance;
13     // This generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     // This generates a public event on the blockchain that will notify clients
17     //event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18     // This notifies clients about the amount burnt
19     //event Burn(address indexed from, uint256 value);
20     /**
21      * Constructor function
22      *
23      * Initializes contract with initial supply tokens to the creator of the contract
24      */
25     constructor(
26        // uint256 initialSupply,
27        // string tokenName,
28        // string tokenSymbol
29     ) public {
30         //totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32         name = "Bee App Token";                                   // Set the name for display purposes
33         symbol = "BTO";                               // Set the symbol for display purposes
34     }
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55     /**
56      * Transfer tokens
57      *
58      * Send `_value` tokens to `_to` from your account
59      *
60      * @param _to The address of the recipient
61      * @param _value the amount to send
62      */
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         _transfer(msg.sender, _to, _value);
65         return true;
66     }
67     /**
68      * Transfer tokens from other address
69      *
70      * Send `_value` tokens to `_to` on behalf of `_from`
71      *
72      * @param _from The address of the sender
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77      //   require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         require(_value <= balanceOf[_from]);
79        // balanceOf[_from] -= _value;
80         //allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 }