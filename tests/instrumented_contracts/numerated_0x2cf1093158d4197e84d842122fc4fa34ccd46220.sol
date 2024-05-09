1 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
2 
3 contract ShareToken {
4     /* Public variables of the token */
5     string public standard = 'Token 0.1';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11     address public corporationContract;
12     mapping (address => bool) public identityApproved;
13     mapping (address => bool) public voteLock; // user must keep at least 1 share if they are involved in voting  True=locked
14 
15     /* This creates an array with all balances */
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18     /* This generates a public event on the blockchain that will notify clients */
19     //event Transfer(address indexed from, address indexed to, uint256 beforesender, uint256 beforereceiver, uint256 value, uint256 time);
20 
21     uint256 public transferCount = 0;
22 
23 
24     struct pasttransfer {
25       address  from;
26       address  to;
27       uint256 beforesender;
28       uint256 beforereceiver;
29       uint256 value;
30       uint256 time;
31     }
32 
33     pasttransfer[] transfers;
34 
35     modifier onlyCorp() {
36         require(msg.sender == corporationContract);
37         _;
38     }
39     // Sender: Corporation  --->
40     function ShareToken() {
41 
42     }
43 
44     function init(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol, address _owner) {
45       corporationContract = msg.sender;
46       balanceOf[_owner] = initialSupply;                     // Give the creator all initial tokens
47       identityApproved[_owner] = true;
48       totalSupply = initialSupply;                        // Update total supply
49       allowance[_owner][corporationContract] = (totalSupply - 1);   // Allow corporation to sell shares to new members if approved
50       name = tokenName;                                   // Set the name for display purposes
51       symbol = tokenSymbol;                               // Set the symbol for display purposes
52       decimals = decimalUnits;                            // Amount of decimals for display purposes
53     }
54 
55     function approveMember(address _newMember) public  returns (bool) {
56         identityApproved[_newMember] = true;
57         return true;
58     }
59 
60     function Transfer(address from, address to, uint256 beforesender, uint256 beforereceiver, uint256 value, uint256 time) {
61       transferCount++;
62       pasttransfer memory t;
63       t.from = from;
64       t.to = to;
65       t.beforesender = beforesender;
66       t.beforereceiver = beforereceiver;
67       t.value = value;
68       t.time = time;
69       transfers.push(t);
70     }
71 
72     // /* Send coins */
73     //  must have identityApproved + can't sell last token using transfer
74     function transfer(address _to, uint256 _value) public {
75         if (balanceOf[msg.sender] < (_value + 1)) revert();           // Check if the sender has enough
76         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
77         require(identityApproved[_to]);
78         uint256 receiver = balanceOf[_to];
79         uint256 sender = balanceOf[msg.sender];
80         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
81         balanceOf[_to] += _value;                            // Add the same to the recipient
82         Transfer(msg.sender, _to, sender, receiver, _value, now);                   // Notify anyone listening that this transfer took place
83     }
84     /* Allow another contract to spend some tokens in your behalf */
85     function approve(address _spender, uint256 _value) public returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89     /* Approve and then comunicate the approved contract in a single tx */
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
91         tokenRecipient spender = tokenRecipient(_spender);
92         if (approve(_spender, _value)) {
93             spender.receiveApproval(msg.sender, _value, this, _extraData);
94             return true;
95         }
96     }
97     /* A contract attempts to get the coins */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         if (balanceOf[_from] < (_value + 1)) revert();                 // Check if the sender has enough
100         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
101         if (_value > allowance[_from][msg.sender]) revert();   // Check allowance
102         require(identityApproved[_to]);
103         uint256 receiver = balanceOf[_to];
104         uint256 sender = balanceOf[_from];
105         balanceOf[_from] -= _value;
106         balanceOf[_to] += _value;                            // Add the same to the recipient
107         allowance[_from][msg.sender] -= _value;
108         Transfer(_from, _to,sender, receiver, _value, now);
109         return true;
110     }
111     /* This unnamed function is called whenever someone tries to send ether to it */
112     function () {
113         revert();     // Prevents accidental sending of ether
114     }
115 
116     function isApproved(address _user) constant returns (bool) {
117         return identityApproved[_user];
118     }
119 
120     function getTransferCount() public view returns (uint256 count) {
121       return transferCount;
122     }
123 
124     function getTransfer(uint256 i) public view returns (address from, address to, uint256 beforesender, uint256 beforereceiver, uint256 value, uint256 time) {
125       pasttransfer memory t = transfers[i];
126       return (t.from, t.to, t.beforesender, t.beforereceiver, t.value, t.time);
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param _owner The address to query the the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function getBalance(address _owner) public view returns (uint256 balance) {
135       return balanceOf[_owner];
136     }
137 }