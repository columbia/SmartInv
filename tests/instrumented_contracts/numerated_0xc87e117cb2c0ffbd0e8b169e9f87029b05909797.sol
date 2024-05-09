1 pragma solidity 0.6.4;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11 
12     /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     /**
21     * @dev Throws if called by any account other than the owner.
22     */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     /**
29     * @dev Allows the current owner to transfer control of the contract to a newOwner.
30     * @param newOwner The address to transfer ownership to.
31     */
32     function transferOwnership(address newOwner) onlyOwner public {
33         require(newOwner != address(0));
34         owner = newOwner;
35     }
36 
37 }
38 
39 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external; }
40 
41 contract CTNToken is Ownable {
42 
43     uint256 public totalSupply;
44     mapping(address => uint256) balances;
45     mapping(address => mapping(address => uint256)) allowed;
46 
47     string public constant name = "CETAN";
48     string public constant symbol = "CTN";
49     uint32 public constant decimals = 18;
50 
51     uint constant restrictedPercent = 40; //should never be set above 100
52  
53     bool public mintingFinished = false;
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     event Mint(address indexed to, uint256 amount);
58     event MintFinished();
59     event Burn(address indexed burner, uint256 value);
60 
61 
62     modifier canMint() {
63         require(!mintingFinished);
64         _;
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69         require(_value <= balances[msg.sender]);
70 
71         balances[msg.sender] = balances[msg.sender] - _value;
72         balances[_to] = balances[_to] + _value;
73         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
74         emit Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function balanceOf(address _owner) public view returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83         require(_to != address(0));
84         require(_value <= balances[_from]);
85         require(_value <= allowed[_from][msg.sender]);
86 
87         balances[_from] = balances[_from] - _value;
88         balances[_to] = balances[_to] + _value;
89         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
90         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
91         emit Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool) {
96         //NOTE: To prevent attack vectors like the one discussed here:
97         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
98         //clients SHOULD make sure to create user interfaces in such a way
99         //that they set the allowance first to 0 before setting it to another value for the same spender.
100 
101         allowed[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)  public returns (bool) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
110             return true;
111         }
112     }
113 
114     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118 
119     function mint(address _to, uint256 _value) onlyOwner canMint public returns (bool) {
120         require(_to != address(0));
121 
122         uint restrictedTokens = _value * restrictedPercent / 100;
123         uint _amount = _value + restrictedTokens;
124         assert(_amount >= _value);
125 
126         totalSupply = totalSupply + _amount;
127 
128         assert(totalSupply >= _amount);
129 
130         balances[msg.sender] = balances[msg.sender] + _amount;
131         assert(balances[msg.sender] >= _amount);
132         emit Mint(msg.sender, _amount);
133 
134         transfer(_to, _value);
135         transfer(owner, restrictedTokens);
136         return true;
137     }
138 
139     function finishMinting() onlyOwner public returns (bool) {
140         mintingFinished = true;
141         emit MintFinished();
142         return true;
143     }
144 
145     /**
146      * @dev Burns a specific amount of tokens.
147      * @param _value The amount of token to be burned.
148      */
149     function burn(uint256 _value) public returns (bool) {
150         require(_value <= balances[msg.sender]);
151         // no need to require value <= totalSupply, since that would imply the
152         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
153         balances[msg.sender] = balances[msg.sender] - _value;
154         totalSupply = totalSupply - _value;
155         emit Burn(msg.sender, _value);
156         return true;
157     }
158 
159     function burnFrom(address _from, uint256 _value) public returns (bool success) {
160         require(_value <= balances[_from]);
161         require(_value <= allowed[_from][msg.sender]);
162         balances[_from] = balances[_from] - _value;
163         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
164         totalSupply = totalSupply - _value;
165         emit Burn(_from, _value);
166         return true;
167     }
168 }