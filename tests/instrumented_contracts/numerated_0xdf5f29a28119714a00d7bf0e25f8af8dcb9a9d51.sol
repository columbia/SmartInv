1 pragma solidity ^0.4.15;
2 
3 //interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract DealerRights {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20  
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function DealerRights() public {
27         totalSupply = 21000000 ether;                        // Update total supply
28         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
29         name = "Dealer Rights";                                   // Set the name for display purposes
30         symbol = "DRS";                               // Set the symbol for display purposes
31         decimals = 18;                            // Amount of decimals for display purposes
32     }
33 
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
39         require(balanceOf[_from] >= _value);                // Check if the sender has enough
40         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];  //Save this for an assertion in the future
42         balanceOf[_from] -= _value;                         // Subtract from the sender
43         balanceOf[_to] += _value;                           // Add the same to the recipient
44         Transfer(_from, _to, _value);
45         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  //Asserts are used to use static analysis to find bugs in your code. They should never fail.
46     }
47 
48     /**
49      * Transfer tokens
50      *
51      * Send `_value` tokens to `_to` from your account
52      *
53      * @param _to The address of the recipient
54      * @param _value the amount to send
55      */
56     function transfer(address _to, uint256 _value) public {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60     /**
61      * Transfer tokens from other address
62      *
63      * Send `_value` tokens to `_to` in behalf of `_from`
64      *
65      * @param _from The address of the sender
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     /**
77      * Set allowance for other address
78      *
79      * Allows `_spender` to spend no more than `_value` tokens in your behalf
80      *
81      * @param _spender The address authorized to spend
82      * @param _value the max amount they can spend
83      */
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     /**
91      * Set allowance for other address and notify
92      *
93      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      * @param _extraData some extra information to send to the approved contract
98      */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
100        if (approve(_spender, _value)) {
101            //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
102            //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
103            //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
104            require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
105            return true;
106        }
107     }
108 }