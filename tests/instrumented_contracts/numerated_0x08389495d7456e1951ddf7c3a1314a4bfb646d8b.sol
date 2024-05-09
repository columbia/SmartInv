1 pragma solidity ^0.4.16;
2 
3 /**
4  * The previous smart contract was submitted on 2017-11-07
5 */
6 
7 contract Ownable {
8     
9     address public owner;
10 
11     function Ownable() public {
12         owner = msg.sender;
13     }
14     
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19     
20     function transferOwnership(address newOwner) onlyOwner public {
21         require(newOwner != address(0));      
22         owner = newOwner;
23     }
24 
25 }
26 
27 contract CRPT is Ownable {
28     
29     uint256 public totalSupply;
30     mapping(address => uint256) balances;
31     mapping(address => mapping(address => uint256)) allowed;
32     
33     string public constant name = "CRPT";
34     string public constant symbol = "CRPT";
35     uint32 public constant decimals = 18;
36 
37     uint constant restrictedPercent = 30;
38     address constant restricted = 0xe5cF86fC6420A4404Ee96535ae2367897C94D831;
39     uint constant start = 1601200042;
40     uint constant period = 3;
41     uint256 public constant hardcap = 100000000 * 1 ether;
42     
43     bool public transferAllowed = false;
44     bool public mintingFinished = false;
45     
46     modifier whenTransferAllowed() {
47         if(msg.sender != owner){
48             require(transferAllowed);
49         }
50         _;
51     }
52 
53     modifier saleIsOn() {
54         require(now > start && now < start + period * 1 days);
55         _;
56     }
57     
58     modifier canMint() {
59         require(!mintingFinished);
60         _;
61     }
62   
63     function transfer(address _to, uint256 _value) whenTransferAllowed public returns (bool) {
64         require(_to != address(0));
65         require(_value <= balances[msg.sender]);
66         
67         balances[msg.sender] = balances[msg.sender] - _value;
68         balances[_to] = balances[_to] + _value;
69         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) constant public returns (uint256 balance) {
75         return balances[_owner];
76     }
77     
78     function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed public returns (bool) {
79         require(_to != address(0));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82         
83         balances[_from] = balances[_from] - _value;
84         balances[_to] = balances[_to] + _value;
85         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
86         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool) {
92         //NOTE: To prevent attack vectors like the one discussed here:
93         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
94         //clients SHOULD make sure to create user interfaces in such a way
95         //that they set the allowance first to 0 before setting it to another
96         //value for the same spender.
97     
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
104         return allowed[_owner][_spender];
105     }
106    
107     function allowTransfer() onlyOwner public {
108         transferAllowed = true;
109     }
110     
111     function mint(address _to, uint256 _value) onlyOwner saleIsOn canMint public returns (bool) {
112         require(_to != address(0));
113         
114         uint restrictedTokens = _value * restrictedPercent / (100 - restrictedPercent);
115         uint _amount = _value + restrictedTokens;
116         assert(_amount >= _value);
117         
118         if(_amount + totalSupply <= hardcap){
119         
120             totalSupply = totalSupply + _amount;
121             
122             assert(totalSupply >= _amount);
123             
124             balances[msg.sender] = balances[msg.sender] + _amount;
125             assert(balances[msg.sender] >= _amount);
126             Mint(msg.sender, _amount);
127         
128             transfer(_to, _value);
129             transfer(restricted, restrictedTokens);
130         }
131         return true;
132     }
133 
134     function finishMinting() onlyOwner public returns (bool) {
135         mintingFinished = true;
136         MintFinished();
137         return true;
138     }
139     
140     /**
141      * @dev Burns a specific amount of tokens.
142      * @param _value The amount of token to be burned.
143     */
144     function burn(uint256 _value) public returns (bool) {
145         require(_value <= balances[msg.sender]);
146         // no need to require value <= totalSupply, since that would imply the
147         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
148         balances[msg.sender] = balances[msg.sender] - _value;
149         totalSupply = totalSupply - _value;
150         Burn(msg.sender, _value);
151         return true;
152     }
153     
154     function burnFrom(address _from, uint256 _value) public returns (bool success) {
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157         balances[_from] = balances[_from] - _value;
158         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
159         totalSupply = totalSupply - _value;
160         Burn(_from, _value);
161         return true;
162     }
163 
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 
168     event Mint(address indexed to, uint256 amount);
169 
170     event MintFinished();
171 
172     event Burn(address indexed burner, uint256 value);
173 
174 }