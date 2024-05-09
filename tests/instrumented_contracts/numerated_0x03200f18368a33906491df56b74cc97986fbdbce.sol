1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract XueBiToken {
6     // This declares a new complex type which will
7     // be used for variables later.
8     // It will represent a single voter.
9     uint256 public totalSupply;
10     string public name;
11     string public symbol;
12     uint8 public decimals = 8;
13     
14     // This declares a state variable that
15     // stores a `Voter` struct for each possible address.
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     event Burn(address indexed from, uint256 value);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23     function XueBiToken(
24         uint256 initialSupply,
25         string tokenName,
26         string tokenSymbol
27     ) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);
29         balanceOf[msg.sender] = totalSupply;
30         name = tokenName;                   
31         symbol = tokenSymbol;
32     }
33     
34     // If the first argument of `require` evaluates
35     // to `false`, execution terminates and all
36     // changes to the state and to Ether balances
37     // are reverted.
38     // This used to consume all gas in old EVM versions, but
39     // not anymore.
40     // It is often a good idea to use `require` to check if
41     // functions are called correctly.
42     // As a second argument, you can also provide an
43     // explanation about what went wrong.
44     function burn(uint256 _value) public returns (bool success) {
45         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
46         balanceOf[msg.sender] -= _value;            // Subtract from the sender
47         totalSupply -= _value;                      // Updates totalSupply
48         emit Burn(msg.sender, _value);
49         return true;
50     }
51     
52     
53     // The following is a so-called natspec comment,
54     // recognizable by the three slashes.
55     // It will be shown when the user is asked to
56     // confirm a transaction.
57 
58     /// Create a simple auction with `_biddingTime`
59     /// seconds bidding time on behalf of the
60     /// beneficiary address `_beneficiary`.
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value >= balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         emit Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     function transfer(address _to, uint256 _value) public returns (bool success) {
80         _transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     // It is a good guideline to structure functions that interact
85     // with other contracts (i.e. they call functions or send Ether)
86     // into three phases:
87     // 1. checking conditions
88     // 2. performing actions (potentially changing conditions)
89     // 3. interacting with other contracts
90     // If these phases are mixed up, the other contract could call
91     // back into the current contract and modify the state or cause
92     // effects (ether payout) to be performed multiple times.
93     // If functions called internally include interaction with external
94     // contracts, they also have to be considered interaction with
95     // external contracts.
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_value <= allowance[_from][msg.sender]); 
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     /// Place a blinded bid with `_blindedBid` =
111     /// keccak256(abi.encodePacked(value, fake, secret)).
112     /// The sent ether is only refunded if the bid is correctly
113     /// revealed in the revealing phase. The bid is valid if the
114     /// ether sent together with the bid is at least "value" and
115     /// "fake" is not true. Setting "fake" to true and sending
116     /// not the exact amount are ways to hide the real bid but
117     /// still make the required deposit. The same address can
118     /// place multiple bids.
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 }