1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
25 
26 contract AzbitToken is Ownable {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     uint256 public constant MIN_RELEASE_DATE = 1554076800; // Monday, 01-Apr-19 00:00:00 UTC in RFC 2822
35     uint256 public constant MAX_RELEASE_DATE = 1567296000; // Sunday, 01-Sep-19 00:00:00 UTC in RFC 2822
36     uint256 public releaseDate = MIN_RELEASE_DATE;
37 
38     // This creates an array with all balances
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41     mapping (address => bool) public whiteList;
42 
43     // This generates a public event on the blockchain that will notify clients
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     // This generates a public event on the blockchain that will notify clients
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 
49     // This notifies clients about the amount burnt
50     event Burn(address indexed from, uint256 value);
51 
52     // Emit special events in methods that change the state of the contract
53     event WhiteListAdded(address indexed _address);
54     event WhiteListRemoved(address indexed _address);
55     event ReleaseChanged(uint256 _date);
56 
57     /**
58      * Constructor function
59      *
60      * Initializes contract with initial supply tokens to the creator of the contract
61      */
62     constructor(
63         uint256 initialSupply,
64         string tokenName,
65         string tokenSymbol
66     ) public {
67         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
68         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
69         name = tokenName;                                   // Set the name for display purposes
70         symbol = tokenSymbol;                               // Set the symbol for display purposes
71         emit Transfer(address(0), msg.sender, totalSupply); // Minting event notification
72     }
73 
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal canTransfer {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != address(0x0));
80         // Check if the sender has enough
81         require(balanceOf[_from] >= _value);
82         // Check for overflows
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         // Save this for an assertion in the future
85         uint previousBalances = balanceOf[_from] + balanceOf[_to];
86         // Subtract from the sender
87         balanceOf[_from] -= _value;
88         // Add the same to the recipient
89         balanceOf[_to] += _value;
90         emit Transfer(_from, _to, _value);
91         // Asserts are used to use static analysis to find bugs in your code. They should never fail
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 
95     /**
96      * Transfer tokens
97      *
98      * Send `_value` tokens to `_to` from your account
99      *
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         _transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Transfer tokens from other address
110      *
111      * Send `_value` tokens to `_to` on behalf of `_from`
112      *
113      * @param _from The address of the sender
114      * @param _to The address of the recipient
115      * @param _value the amount to send
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         require(_value <= allowance[_from][msg.sender]);     // Check allowance
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address
126      *
127      * Beware that changing an allowance with this method brings the risk that someone may use both the old
128      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public returns (bool success) {
138         allowance[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address and notify
145      *
146      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      * @param _extraData some extra information to send to the approved contract
151      */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
153         tokenRecipient spender = tokenRecipient(_spender);
154         if (approve(_spender, _value)) {
155             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
156             return true;
157         }
158     }
159 
160     /**
161      * Destroy tokens
162      *
163      * Remove `_value` tokens from the system irreversibly
164      *
165      * @param _value the amount of money to burn
166      */
167     function burn(uint256 _value) public returns (bool success) {
168         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
169         balanceOf[msg.sender] -= _value;            // Subtract from the sender
170         totalSupply -= _value;                      // Updates totalSupply
171         emit Burn(msg.sender, _value);
172         return true;
173     }
174 
175     /**
176      * Destroy tokens from other account
177      *
178      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
179      *
180      * @param _from the address of the sender
181      * @param _value the amount of money to burn
182      */
183     function burnFrom(address _from, uint256 _value) public returns (bool success) {
184         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
185         require(_value <= allowance[_from][msg.sender]);    // Check allowance
186         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
187         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
188         totalSupply -= _value;                              // Update totalSupply
189         emit Burn(_from, _value);
190         return true;
191     }
192 
193     function addToWhiteList(address _address) public onlyOwner {
194         whiteList[_address] = true;
195         emit WhiteListAdded(_address);
196     }
197 
198     function removeFromWhiteList(address _address) public onlyOwner {
199         delete whiteList[_address];
200         emit WhiteListRemoved(_address);
201     }
202 
203     function changeRelease(uint256 _date) public onlyOwner {
204         require(_date > now && releaseDate > now && _date > MIN_RELEASE_DATE && _date < MAX_RELEASE_DATE);
205         releaseDate = _date;
206         emit ReleaseChanged(_date);
207     }
208 
209     modifier canTransfer() {
210         require(now >= releaseDate || whiteList[msg.sender]);
211         _;
212     }
213 }