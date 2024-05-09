1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract DecentralizedCryptoToken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17     /**
18      * Constructor function
19      *
20      * Initializes contract with initial supply tokens to the creator of the contract
21      */
22     constructor (
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);
28         balanceOf[msg.sender] = totalSupply;
29         name = tokenName;
30         symbol = tokenSymbol;
31         emit Transfer(address(0), msg.sender, totalSupply);
32     }
33 
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         require(_to != 0x0);
39         require(balanceOf[_from] >= _value);
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         balanceOf[_from] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         _transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     /**
62      * Transfer tokens from other address
63      *
64      * Send `_value` tokens to `_to` on behalf of `_from`
65      *
66      * @param _from The address of the sender
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= balanceOf[_from]);
72         require(_value <= allowance[_from][msg.sender]);
73         allowance[_from][msg.sender] -= _value;
74         _transfer(_from, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Set allowance for other address
80      *
81      * Allows `_spender` to spend no more than `_value` tokens on your behalf
82      *
83      * @param _spender The address authorized to spend
84      * @param _value the max amount they can spend
85      */
86     function approve(address _spender, uint256 _value) public
87         returns (bool success) {
88         allowance[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     /**
94      * Set allowance for other address and notify
95      *
96      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
97      *
98      * @param _spender The address authorized to spend
99      * @param _value the max amount they can spend
100      * @param _extraData some extra information to send to the approved contract
101      */
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
103         public
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 }