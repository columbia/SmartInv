1 pragma solidity ^0.4.18;
2 
3 /* Owner setter */
4 contract OwnableToken
5 {
6     address owner;
7 
8     modifier onlyOwner() {
9         require(owner == msg.sender);
10         _;
11     }
12 
13     function OwnableToken() public payable {
14         owner = msg.sender;
15     }
16 
17     function changeOwner(address _new_owner) payable public onlyOwner {
18         require(_new_owner != address(0));
19         owner = _new_owner;
20     }
21 }
22 
23 /**
24  * Abstract contract for the full ERC 20 Token standard
25  * https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20I
28 {
29     uint256 public totalSupply;
30 
31     function balanceOf(address _owner) public view returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 /* ERC 20 Token implementation */
42 contract ERC20 is ERC20I {
43 
44     uint256 constant MAX_UINT256 = 2**256 - 1;
45 
46     mapping (address => uint256) balances;
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     function transfer(address _to, uint256 _value) public
50         returns (bool success)
51     {
52         require(balances[msg.sender] >= _value);
53         balances[msg.sender] -= _value;
54         balances[_to] += _value;
55         Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) public
60         returns (bool success)
61     {
62         uint256 allowance = allowed[_from][msg.sender];
63         require(balances[_from] >= _value && allowance >= _value);
64         balances[_to] += _value;
65         balances[_from] -= _value;
66         if (allowance < MAX_UINT256) {
67             allowed[_from][msg.sender] -= _value;
68         }
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) view public
74         returns (uint256 balance)
75     {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) public
80         returns (bool success)
81     {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) view public
88         returns (uint256 remaining)
89     {
90         return allowed[_owner][_spender];
91     }
92 }
93 
94 /* airdopable promo smart contract */
95 contract ANtokContractAirdrop is ERC20, OwnableToken
96 {
97     event Wasted(address to, uint256 value, uint256 date);  // Wasted(_to, _amount, now);
98 
99     string public version = '1.2'; //Just an arbitrary versioning scheme.
100 
101     uint8  public decimals;
102     string public name;
103     string public symbol;  //An identifier: eg SBX length 6 symbols max
104 
105     uint256 public paySize = 1 * 10 ** 18;  // show size of payment in mass transfer
106     uint256 public holdersCount;
107     uint256 public tokensSpent;
108 
109     mapping (address => bool) bounty; // show who got bounty
110 
111     /* Autoconstructor */
112     function ANtokContractAirdrop() public payable {
113         decimals = 18;  // Amount of decimals for display purposes
114         name = "ALFA NTOK";  // Set the name for display purposes
115         symbol = "аNTOK";  // Set the symbol for display purposes
116         balances[msg.sender] = 20180000 * 10 ** uint(decimals); // Give the creator promo tokens (100000 for example)
117         balances[this] = 50000 * 10 ** uint(decimals); // Stay some tokens for bounty from contract
118         totalSupply = balances[msg.sender] + balances[this]; // Update total supply (100000 for example)
119     }
120 
121     /**
122      * @dev notify owners about their balances was in promo action.
123      * @param _holders addresses of the owners to be notified
124      */
125     function massTransfer(address [] _holders) public onlyOwner {
126 
127         uint256 count = _holders.length;
128         assert(paySize * count <= balanceOf(msg.sender));
129         for (uint256 i = 0; i < count; i++) {
130             transfer(_holders [i], paySize);
131         }
132         Wasted(owner, tokensSpent, now);
133     }
134 
135     /**
136     * @dev withdraw tokens from the contract.
137     */
138     function withdrawTo(address _recipient, uint256 _amount) public onlyOwner {
139         this.transfer(_recipient, _amount);
140     }
141 
142     /**
143     * @dev withdraw tokens from the contract.
144     */
145     function setPaySize(uint256 _value) public onlyOwner
146         returns (uint256)
147     {
148         paySize = _value;
149         return paySize;
150     }
151 
152     /**
153     * @dev withdraw tokens as bounty.
154     */
155     function withdrawBounty(address _recipient, uint256 _amount) internal {
156         this.transfer(_recipient, _amount);
157     }
158 
159     /**
160     * @dev get bounty for the people.
161     */
162     function getBounty() public payable {
163         require(bounty[msg.sender] != true); // 1 address = 1 token
164         require(balances[this] != 0);
165         bounty[msg.sender] = true;
166         withdrawBounty(msg.sender, 1 * 10 ** uint(decimals));
167     }
168 
169     /**
170     * @dev is bounty address.
171     */
172     function bountyOf(address _bountist) view public
173         returns (bool thanked)
174     {
175         return bounty[_bountist];
176     }
177 
178     function() public {
179         revert(); // revert all incoming transactions
180     }
181 }