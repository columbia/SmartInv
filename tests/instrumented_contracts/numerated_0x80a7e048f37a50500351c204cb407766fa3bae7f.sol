1 pragma solidity ^0.4.16;
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
16     function Ownable() public {
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
39 contract CrypteriumToken is Ownable {
40     
41     uint256 public totalSupply;
42     mapping(address => uint256) balances;
43     mapping(address => mapping(address => uint256)) allowed;
44     
45     string public constant name = "CrypteriumToken";
46     string public constant symbol = "CRPT";
47     uint32 public constant decimals = 18;
48 
49     uint constant restrictedPercent = 30; //should never be set above 100
50     address constant restricted = 0x1d907C982B0B093b5173574FAbe7965181522c7B;
51     uint constant start = 1509458400;
52     uint constant period = 87;
53     uint256 public constant hardcap = 300000000 * 1 ether;
54     
55     bool public transferAllowed = false;
56     bool public mintingFinished = false;
57     
58     modifier whenTransferAllowed() {
59         if(msg.sender != owner){
60             require(transferAllowed);
61         }
62         _;
63     }
64 
65     modifier saleIsOn() {
66         require(now > start && now < start + period * 1 days);
67         _;
68     }
69     
70     modifier canMint() {
71         require(!mintingFinished);
72         _;
73     }
74   
75     function transfer(address _to, uint256 _value) whenTransferAllowed public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[msg.sender]);
78         
79         balances[msg.sender] = balances[msg.sender] - _value;
80         balances[_to] = balances[_to] + _value;
81         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) constant public returns (uint256 balance) {
87         return balances[_owner];
88     }
89     
90     function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[_from]);
93         require(_value <= allowed[_from][msg.sender]);
94         
95         balances[_from] = balances[_from] - _value;
96         balances[_to] = balances[_to] + _value;
97         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
98         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
99         Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool) {
104         //NOTE: To prevent attack vectors like the one discussed here: 
105         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
106         //clients SHOULD make sure to create user interfaces in such a way 
107         //that they set the allowance first to 0 before setting it to another value for the same spender. 
108     
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117    
118     function allowTransfer() onlyOwner public {
119         transferAllowed = true;
120     }
121     
122     function mint(address _to, uint256 _value) onlyOwner saleIsOn canMint public returns (bool) {
123         require(_to != address(0));
124         
125         uint restrictedTokens = _value * restrictedPercent / (100 - restrictedPercent);
126         uint _amount = _value + restrictedTokens;
127         assert(_amount >= _value);
128         
129         if(_amount + totalSupply <= hardcap){
130         
131             totalSupply = totalSupply + _amount;
132             
133             assert(totalSupply >= _amount);
134             
135             balances[msg.sender] = balances[msg.sender] + _amount;
136             assert(balances[msg.sender] >= _amount);
137             Mint(msg.sender, _amount);
138         
139             transfer(_to, _value);
140             transfer(restricted, restrictedTokens);
141         }
142         return true;
143     }
144 
145     function finishMinting() onlyOwner public returns (bool) {
146         mintingFinished = true;
147         MintFinished();
148         return true;
149     }
150     
151     /**
152      * @dev Burns a specific amount of tokens.
153      * @param _value The amount of token to be burned.
154      */
155     function burn(uint256 _value) public returns (bool) {
156         require(_value <= balances[msg.sender]);
157         // no need to require value <= totalSupply, since that would imply the
158         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
159         balances[msg.sender] = balances[msg.sender] - _value;
160         totalSupply = totalSupply - _value;
161         Burn(msg.sender, _value);
162         return true;
163     }
164     
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(_value <= balances[_from]);
167         require(_value <= allowed[_from][msg.sender]);
168         balances[_from] = balances[_from] - _value;
169         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
170         totalSupply = totalSupply - _value;
171         Burn(_from, _value);
172         return true;
173     }
174 
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 
179     event Mint(address indexed to, uint256 amount);
180 
181     event MintFinished();
182 
183     event Burn(address indexed burner, uint256 value);
184 
185 }