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
98     /* Contract Functions */
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
112         emit Transfer(0x0, _for, tokenCount);
113         return true;
114     }
115 
116     // Withdraws tokens for msg.sender.
117     function withdrawTokens(uint tokenCount)
118         public
119         returns (bool)
120     {
121         uint balance = balances[msg.sender];
122         if (balance < tokenCount) {
123             revert();
124             return false;
125         }
126         balances[msg.sender] -= tokenCount;
127         totalSupply -= tokenCount;
128         emit Transfer(msg.sender, 0x0, tokenCount);
129         return true;
130     }
131 
132     // Function to change address that is allowed to do emission.
133     function changeEmissionContractAddress(address newAddress)
134         external
135         onlyOwner
136     {
137         emissionContractAddress = newAddress;
138     }
139 
140     // Function that enables/disables transfers of token, value is true/false
141     function enableTransfers(bool value)
142         external
143         onlyOwner
144     {
145         transfersEnabled = value;
146     }
147 
148     // Function that enables/disables token emission.
149     function enableEmission(bool value)
150         external
151         onlyOwner
152     {
153         emissionEnabled = value;
154     }
155 
156     /* Overriding ERC20 standard token functions to support transfer lock */
157     function transfer(address _to, uint256 _value) public returns (bool success) {
158         if (transfersEnabled == true) {
159             return super.transfer(_to, _value);
160         }
161         return false;
162     }
163 
164     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
165         if (transfersEnabled == true) {
166             return super.transferFrom(_from, _to, _value);
167         }
168         return false;
169     }
170 
171 
172     // Contract constructor function sets initial token balances. _owner Address of the owner of AltTokenFund.
173     constructor (address _owner) public
174     {
175         totalSupply = 0;
176         owner = _owner;
177     }
178 
179     function transferOwnership(address newOwner) public onlyOwner {
180         owner = newOwner;
181     }
182 }