1 pragma solidity ^0.4.18;
2 
3 contract LSC {
4     string public name;
5     string public symbol;
6     uint8  public decimals = 6;
7     uint256 public totalSupply;
8 
9     // Balances
10     mapping (address => uint256) balances;
11     // Allowances
12     mapping (address => mapping (address => uint256)) allowances;
13 
14     // ----- Events -----
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18 
19     /**
20      * Constructor function
21      */
22     function LSC(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
23         name = _tokenName;                                   // Set the name for display purposes
24         symbol = _tokenSymbol;                               // Set the symbol for display purposes
25         decimals = _decimals;
26 
27         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
28         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
29     }
30 
31     function balanceOf(address _owner) public view returns(uint256) {
32         return balances[_owner];
33     }
34 
35     function allowance(address _owner, address _spender) public view returns (uint256) {
36         return allowances[_owner][_spender];
37     }
38 
39     /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(_to != 0x0);
45         // Check if the sender has enough
46         require(balances[_from] >= _value);
47         // Check for overflows
48         require(balances[_to] + _value > balances[_to]);
49         // Save this for an assertion in the future
50         uint previousBalances = balances[_from] + balances[_to];
51         // Subtract from the sender
52         balances[_from] -= _value;
53         // Add the same to the recipient
54         balances[_to] += _value;
55          Transfer(_from, _to, _value);
56         // Asserts are used to use static analysis to find bugs in your code. They should never fail
57         assert(balances[_from] + balances[_to] == previousBalances);
58 
59         return true;
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transfer(address _to, uint256 _value) public returns(bool) {
71         return _transfer(msg.sender, _to, _value);
72     }
73 
74     /**
75      * Transfer tokens from other address
76      *
77      * Send `_value` tokens to `_to` in behalf of `_from`
78      *
79      * @param _from The address of the sender
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
84         require(_value <= allowances[_from][msg.sender]);     // Check allowance
85         allowances[_from][msg.sender] -= _value;
86         return _transfer(_from, _to, _value);
87     }
88 
89     /**
90      * Set allowance for other address
91      *
92      * Allows `_spender` to spend no more than `_value` tokens in your behalf
93      *
94      * @param _spender The address authorized to spend
95      * @param _value the max amount they can spend
96      */
97     function approve(address _spender, uint256 _value) public returns(bool) {
98         allowances[msg.sender][_spender] = _value;
99          Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
104         // Check for overflows
105         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
106 
107         allowances[msg.sender][_spender] += _addedValue;
108          Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
109         return true;
110     }
111 
112     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
113         uint oldValue = allowances[msg.sender][_spender];
114         if (_subtractedValue > oldValue) {
115             allowances[msg.sender][_spender] = 0;
116         } else {
117             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
118         }
119          Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
120         return true;
121     }
122 }