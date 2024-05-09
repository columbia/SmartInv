1 pragma solidity 0.4.25;
2 
3 contract StandardToken {
4 
5     /* Data structures */
6     mapping (address => uint256) balances;
7     mapping (address => mapping (address => uint256)) allowed;
8     uint256 public totalSupply;
9 
10     /* Events */
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 
14     /* Read and write storage functions */
15 
16     // Transfers sender's tokens to a given address. Returns success.
17     function transfer(address _to, uint256 _value) public returns (bool success) {
18         if (balances[msg.sender] >= _value && _value > 0) {
19             balances[msg.sender] -= _value;
20             balances[_to] += _value;
21             emit Transfer(msg.sender, _to, _value);
22             return true;
23         }
24         else {
25             return false;
26         }
27     }
28 
29     // Allows allowed third party to transfer tokens from one address to another. Returns success. _value Number of tokens to transfer.
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
32             balances[_to] += _value;
33             balances[_from] -= _value;
34             allowed[_from][msg.sender] -= _value;
35             emit Transfer(_from, _to, _value);
36             return true;
37         }
38         else {
39             return false;
40         }
41     }
42 
43     // Returns number of tokens owned by given address.
44     function balanceOf(address _owner) public view returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     // Sets approved amount of tokens for spender. Returns success. _value Number of approved tokens.
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         emit Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     /* Read storage functions */
56 
57     //Returns number of allowed tokens for given address. _owner Address of token owner. _spender Address of token spender.
58     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
59       return allowed[_owner][_spender];
60     }
61 
62 }
63 
64 contract AltTokenFund is StandardToken {
65 
66     /* External contracts */
67 
68     address public emissionContractAddress = 0x0;
69 
70     //Token meta data
71     string constant public name = "Alt Token Fund";
72     string constant public symbol = "ATF";
73     uint8 constant public decimals = 8;
74 
75     /* Storage */
76     address public owner = 0x0;
77     bool public emissionEnabled = true;
78     bool transfersEnabled = true;
79 
80     /* Modifiers */
81 
82     modifier isCrowdfundingContract() {
83         // Only emission address to do this action
84         if (msg.sender != emissionContractAddress) {
85             revert();
86         }
87         _;
88     }
89 
90     modifier onlyOwner() {
91         // Only owner is allowed to do this action.
92         if (msg.sender != owner) {
93             revert();
94         }
95         _;
96     }
97 
98     /* Contract functions */
99 
100     // TokenFund emission function. _for is Address of receiver, tokenCount is Number of tokens to issue.
101     function issueTokens(address _for, uint tokenCount)
102         external
103         isCrowdfundingContract
104         returns (bool)
105     {
106         if (emissionEnabled == false) {
107             revert();
108         }
109 
110         balances[_for] += tokenCount;
111         totalSupply += tokenCount;
112         return true;
113     }
114 
115     // Withdraws tokens for msg.sender.
116     function withdrawTokens(uint tokenCount)
117         public
118         returns (bool)
119     {
120         uint balance = balances[msg.sender];
121         if (balance < tokenCount) {
122             return false;
123         }
124         balances[msg.sender] -= tokenCount;
125         totalSupply -= tokenCount;
126         return true;
127     }
128 
129     // Function to change address that is allowed to do emission.
130     function changeEmissionContractAddress(address newAddress)
131         external
132         onlyOwner
133         returns (bool)
134     {
135         emissionContractAddress = newAddress;
136     }
137 
138     // Function that enables/disables transfers of token, value is true/false
139     function enableTransfers(bool value)
140         external
141         onlyOwner
142     {
143         transfersEnabled = value;
144     }
145 
146     // Function that enables/disables token emission.
147     function enableEmission(bool value)
148         external
149         onlyOwner
150     {
151         emissionEnabled = value;
152     }
153 
154     /* Overriding ERC20 standard token functions to support transfer lock */
155     function transfer(address _to, uint256 _value) public returns (bool success) {
156         if (transfersEnabled == true) {
157             return super.transfer(_to, _value);
158         }
159         return false;
160     }
161 
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
163         if (transfersEnabled == true) {
164             return super.transferFrom(_from, _to, _value);
165         }
166         return false;
167     }
168 
169 
170     // Contract constructor function sets initial token balances. _owner Address of the owner of AltTokenFund.
171     constructor (address _owner) public
172     {
173         totalSupply = 0;
174         owner = _owner;
175     }
176 
177     function transferOwnership(address newOwner) public onlyOwner {
178         owner = newOwner;
179     }
180 }