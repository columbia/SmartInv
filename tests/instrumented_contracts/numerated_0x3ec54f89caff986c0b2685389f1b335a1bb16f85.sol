1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Interface
5  * @dev Standard version of ERC20 interface
6  */
7 contract ERC20Interface {
8     uint256 public totalSupply;
9 
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26     address public owner;
27 
28     /**
29      * @dev The Ownable constructor sets the original `owner`
30      * of the contract to the sender account.
31      */
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the current owner
38      */
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45      * @dev Allows the current owner to transfer control of the contract to a newOwner
46      * @param newOwner The address to transfer ownership to
47      */
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         owner = newOwner;
51     }
52 }
53 
54 /**
55  * @title RHEM
56  * @dev Implemantation of the RHEM token
57  */
58 contract RHEM is Ownable, ERC20Interface {
59     string public constant symbol = "RHEM";
60     string public constant name = "RHEM";
61     uint8 public constant decimals = 18;
62     uint256 public _unmintedTokens = 3000000000000*uint(10)**decimals;
63     mapping(address => uint256) balances;
64     mapping(address => mapping (address => uint256)) internal allowed;
65 
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Burn(address indexed sender, uint256 value);
69     event Mint(address indexed sender, uint256 value);
70 
71     /**
72      * @dev Gets the balance of the specified address
73      * @param _owner The address to query the the balance of
74      * @return An uint256 representing the amount owned by the passed address
75      */
76     function balanceOf(address _owner) public view returns (uint256 balance) {
77         return (balances[_owner]);
78     }
79 
80     /**
81      * @dev Transfer token to a specified address
82      * @param _to The address to transfer to
83      * @param _value The amount to be transferred
84      */
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         require(_to != address(0));
87         require(balances[msg.sender] >= _value);
88         assert(balances[_to] + _value >= balances[_to]);
89 
90         balances[msg.sender] -= _value;
91         balances[_to] += _value;
92         emit Transfer(msg.sender, _to, _value);
93 
94         return true;
95     }
96 
97     /**
98      * @dev Transfer tokens from one address to another
99      * @param _from The address which you want to send tokens from
100      * @param _to The address which you want to transfer to
101      * @param _value The amout of tokens to be transfered
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_to != address(0));
105         require(_value <= balances[_from]);
106         require(_value <= allowed[_from][msg.sender]);
107         assert(balances[_to] + _value >= balances[_to]);
108 
109         balances[_from] = balances[_from] - _value;
110         balances[_to] = balances[_to] + _value;
111         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
112         emit Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender
118      * @param _spender The address which will spend the funds
119      * @param _value The amount of tokens to be spent
120      */
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens than an owner allowed to a spender
129      * @param _owner The address which owns the funds
130      * @param _spender The address which will spend the funds
131      * @return A uint specifing the amount of tokens still avaible for the spender
132      */
133     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
134         return allowed[_owner][_spender];
135     }
136 
137     /**
138      * @dev Mint RHEM tokens. No more than 3,000,000,000,000 RHEM can be minted
139      * @param _target The address to which new tokens will be minted
140      * @param _mintedAmount The amout of tokens to be minted
141      */
142     function mint(address _target, uint256 _mintedAmount) public onlyOwner returns (bool success) {
143         require(_mintedAmount <= _unmintedTokens);
144         balances[_target] += _mintedAmount;
145         _unmintedTokens -= _mintedAmount;
146         totalSupply += _mintedAmount;
147         emit Mint(_target, _mintedAmount);
148 
149         return true;
150     }
151 
152     /**
153      * @dev Mint RHEM tokens and aproves the passed address to spend the minted amount of tokens
154      * No more than 3,000,000,000,000 RHEM can be minted
155      * @param _target The address to which new tokens will be minted
156      * @param _mintedAmount The amout of tokens to be minted
157      * @param _spender The address which will spend minted funds
158      */
159     function mintWithApproval(address _target, uint256 _mintedAmount, address _spender) public onlyOwner returns (bool success) {
160         require(_mintedAmount <= _unmintedTokens);
161         balances[_target] += _mintedAmount;
162         _unmintedTokens -= _mintedAmount;
163         totalSupply += _mintedAmount;
164         allowed[_target][_spender] += _mintedAmount;
165         emit Mint(_target, _mintedAmount);
166         emit Approval(_target, _spender, _mintedAmount);
167 
168         return true;
169     }
170 
171     /**
172      * @dev function that burns an amount of the token of the sender
173      * @param _amount The amount that will be burnt.
174      */
175     function burn(uint256 _amount) public returns (uint256 balance) {
176         require(msg.sender != address(0));
177         require(_amount <= balances[msg.sender]);
178         totalSupply = totalSupply - _amount;
179         balances[msg.sender] = balances[msg.sender] - _amount;
180 
181         emit Burn(msg.sender, _amount);
182 
183         return balances[msg.sender];
184     }
185 
186     /**
187      * @dev Decrease amount of RHEM tokens that can be minted
188      * @param _burnedAmount The amount of unminted tokens to be burned
189      */
190     function deductFromUnminted(uint256 _burnedAmount) public onlyOwner returns (bool success) {
191         require(_burnedAmount <= _unmintedTokens);
192         _unmintedTokens -= _burnedAmount;
193 
194         return true;
195     }
196 
197     /**
198      * @dev Add to unminted
199      * @param _value The amount to be add
200      */
201     function addToUnminted(uint256 _value) public onlyOwner returns (uint256 unmintedTokens) {
202         require(_unmintedTokens + _value > _unmintedTokens);
203         _unmintedTokens += _value;
204 
205         return _unmintedTokens;
206     }
207 }