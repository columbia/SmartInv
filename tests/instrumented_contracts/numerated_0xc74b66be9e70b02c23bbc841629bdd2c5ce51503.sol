1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     struct freezeAccountInfo{
35         uint256 freezeStartTime;
36         uint256 freezePeriod;
37         uint256 freezeAmount;
38     }
39 
40     mapping (address => freezeAccountInfo) public freezeAccount;
41 
42     // This generates a public event on the blockchain that will notify clients
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     constructor(
51         uint256 initialSupply,
52         string tokenName,
53         string tokenSymbol
54     ) public {
55         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol;                               // Set the symbol for display purposes
59     }
60 
61     function issueAndFreeze(address _to, uint _value, uint _freezePeriod) onlyOwner public {
62         _transfer(msg.sender, _to, _value);
63 
64         freezeAccount[_to] = freezeAccountInfo({
65             freezeStartTime : now,
66             freezePeriod : _freezePeriod,
67             freezeAmount : _value
68         });
69     }
70 
71     function getFreezeInfo(address _target) view 
72         public returns(
73             uint _freezeStartTime,
74             uint _freezePeriod, 
75             uint _freezeAmount, 
76             uint _freezeDeadline) {
77         freezeAccountInfo storage targetFreezeInfo = freezeAccount[_target];
78         return (targetFreezeInfo.freezeStartTime, 
79         targetFreezeInfo.freezePeriod,
80         targetFreezeInfo.freezeAmount,
81         targetFreezeInfo.freezeStartTime + targetFreezeInfo.freezePeriod * 1 minutes);
82     }
83 
84     /**
85      * Internal transfer, only can be called by this contract
86      */
87     function _transfer(address _from, address _to, uint _value) internal {
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != 0x0);
90 
91         // Check if the sender has enough
92         require(balanceOf[_from] >= _value);
93         // Check for overflows
94         require(balanceOf[_to] + _value > balanceOf[_to]);
95 
96         // _from freeze Information
97         uint256 freezeStartTime;
98         uint256 freezePeriod;
99         uint256 freezeAmount;
100         uint256 freezeDeadline;
101 
102         (freezeStartTime,freezePeriod,freezeAmount,freezeDeadline) = getFreezeInfo(_from);
103         // The free amount of _from
104         uint256 freeAmountFrom = balanceOf[_from] - freezeAmount;
105 
106         require(freezeStartTime == 0 || //Check if it is a freeze account
107         freezeDeadline < now || //Check if in Lock-up Period
108         (freeAmountFrom >= _value)); //Check if the transfer amount > free amount
109 
110         // Save this for an assertion in the future
111         uint previousBalances = balanceOf[_from] + balanceOf[_to];
112         // Subtract from the sender
113         balanceOf[_from] -= _value;
114         // Add the same to the recipient
115         balanceOf[_to] += _value;
116         emit Transfer(_from, _to, _value);
117         // Asserts are used to use static analysis to find bugs in your code. They should never fail
118         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
119     }
120 
121     /**
122      * Transfer tokens
123      *
124      * Send `_value` tokens to `_to` from your account
125      *
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transfer(address _to, uint256 _value) public {
130         _transfer(msg.sender, _to, _value);
131     }
132 
133     /**
134      * Transfer tokens from other address
135      *
136      * Send `_value` tokens to `_to` in behalf of `_from`
137      *
138      * @param _from The address of the sender
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
143         require(_value <= allowance[_from][msg.sender]);     // Check allowance
144         allowance[_from][msg.sender] -= _value;
145         _transfer(_from, _to, _value);
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address
151      *
152      * Allows `_spender` to spend no more than `_value` tokens in your behalf
153      *
154      * @param _spender The address authorized to spend
155      * @param _value the max amount they can spend
156      */
157     function approve(address _spender, uint256 _value) public
158         returns (bool success) {
159         allowance[msg.sender][_spender] = _value;
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address and notify
165      *
166      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      * @param _extraData some extra information to send to the approved contract
171      */
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
173         public
174         returns (bool success) {
175         tokenRecipient spender = tokenRecipient(_spender);
176         if (approve(_spender, _value)) {
177             spender.receiveApproval(msg.sender, _value, this, _extraData);
178             return true;
179         }
180     }
181 }