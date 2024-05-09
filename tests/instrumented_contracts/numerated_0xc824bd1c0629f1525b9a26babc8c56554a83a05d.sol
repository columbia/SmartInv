1 /**
2  *Submitted for verification at Etherscan.io on 2020-03-25
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 interface tokenRecipient { 
8     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
9 }
10 
11 
12 contract Owned {
13   address public owner;
14   mapping (address => bool) public isBlackListed;
15   
16   event TransferOwnership(address indexed _from, address indexed _to);
17   event AddBlacklist(address _Addr);
18   event RemoveBlacklist(address _Addr);
19   
20   constructor() public {
21     owner = msg.sender;
22   }
23   modifier onlyOwner {
24     require(msg.sender == owner);
25     _;
26   }
27   function transferOwnership(address newOwner) public onlyOwner {
28     require (newOwner != address(0x0));  
29     owner = newOwner;
30     emit TransferOwnership(owner, newOwner);
31   }
32   
33   function addBlacklist(address _evilAddr) external onlyOwner {
34         require (_evilAddr != address(0x0));  
35         isBlackListed[_evilAddr] = true;
36         emit AddBlacklist(_evilAddr);
37     }  
38 
39     function removeBlacklist(address _clearedAddr) external onlyOwner {
40         require (_clearedAddr != address(0x0));  
41         isBlackListed[_clearedAddr] = false;
42         emit RemoveBlacklist(_clearedAddr);
43     }
44 }
45 
46 
47 contract EasyMobileERC20  is Owned {
48     // Public variables of the token
49     string public name;
50     string public symbol;
51     uint8 public decimals = 8;
52     // 18 decimals is the strongly suggested default, avoid changing it
53     uint256 public totalSupply;
54 
55     // This creates an array with all balances
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     // This generates a public event on the blockchain that will notify clients
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     
62     // This generates a public event on the blockchain that will notify clients
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 
65     //Fix for short address attack against ERC20
66 	modifier onlyPayloadSize(uint size) {
67 		require(msg.data.length == size + 4);
68 		_;
69 	}
70     /**
71      * Constructor function
72      *
73      * Initializes contract with initial supply tokens to the creator of the contract
74      */
75     constructor(
76         uint256 initialSupply,
77         string memory tokenName,
78         string memory tokenSymbol
79     ) public {
80         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
81         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
82         name = tokenName;                                   // Set the name for display purposes
83         symbol = tokenSymbol;                               // Set the symbol for display purposes
84     }
85 
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         // Prevent transfer to 0x0 address. Use burn() instead
91         require(_to != address(0x0));
92         
93         //Check address in blacklist
94         require(!isBlackListed[_from]);
95         require(!isBlackListed[_to]);
96         
97         // Check if the sender has enough
98         require(balanceOf[_from] >= _value);
99         // Check for overflows
100         require(balanceOf[_to] + _value >= balanceOf[_to]);
101         // Save this for an assertion in the future
102         uint previousBalances = balanceOf[_from] + balanceOf[_to];
103         // Subtract from the sender
104         balanceOf[_from] -= _value;
105         // Add the same to the recipient
106         balanceOf[_to] += _value;
107         emit Transfer(_from, _to, _value);
108         // Asserts are used to use static analysis to find bugs in your code. They should never fail
109         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
110     }
111 
112     /**
113      * Transfer tokens
114      *
115      * Send `_value` tokens to `_to` from your account
116      *
117      * @param _to The address of the recipient
118      * @param _value the amount to send
119      */
120     function transfer(address _to, uint256 _value)  public onlyPayloadSize(2*32) returns (bool success) {
121         _transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     /**
126      * Transfer tokens from other address
127      *
128      * Send `_value` tokens to `_to` on behalf of `_from`
129      *
130      * @param _from The address of the sender
131      * @param _to The address of the recipient
132      * @param _value the amount to send
133      */
134     function transferFrom(address _from, address _to, uint256 _value)  public onlyPayloadSize(3 * 32) returns (bool success) {
135         require(_value <= allowance[_from][msg.sender]);     // Check allowance
136         allowance[_from][msg.sender] -= _value;
137         _transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * Set allowance for other address
143      *
144      * Allows `_spender` to spend no more than `_value` tokens on your behalf
145      *
146      * @param _spender The address authorized to spend
147      * @param _value the max amount they can spend
148      */
149     function approve(address _spender, uint256 _value)  public onlyPayloadSize(2*32) returns (bool success) {
150         require(!((_value != 0) && (allowance[msg.sender][_spender] != 0)));    
151         allowance[msg.sender][_spender] = _value;
152         emit Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     /**
157      * Set allowance for other address and notify
158      *
159      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
160      *
161      * @param _spender The address authorized to spend
162      * @param _value the max amount they can spend
163      * @param _extraData some extra information to send to the approved contract
164      */
165     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
166         public
167         returns (bool success) {
168         tokenRecipient spender = tokenRecipient(_spender);
169         if (approve(_spender, _value)) {
170             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
171             return true;
172         }
173     }
174 
175 
176 }