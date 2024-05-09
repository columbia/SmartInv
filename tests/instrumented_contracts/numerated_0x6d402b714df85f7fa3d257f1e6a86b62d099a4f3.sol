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
38 contract BWCToken is Ownable{
39 
40     uint256 public totalSupply;
41     mapping(address => uint256) balances;
42     mapping(address => mapping(address => uint256)) allowed;
43 
44     string public constant name = "BWCOIN";
45     string public constant symbol = "BWC";
46     uint32 public constant decimals = 4;
47 
48     uint constant start = 1517418000000;
49     uint constant period = 87;
50     uint256 public constant hardcap = 25 * 1000000 * (10 ** uint256(decimals));
51 
52     bool public transferAllowed = true;
53     bool public mintingFinished = false;
54 
55     modifier whenTransferAllowed() {
56         if(msg.sender != owner){
57             require(transferAllowed);
58         }
59         _;
60     }
61 
62     modifier saleIsOn() {
63         require(now > start && now < start + period * 1 days);
64         _;
65     }
66 
67     modifier canMint() {
68         require(!mintingFinished);
69         _;
70     }
71 
72     function transfer(address _to, uint256 _value) whenTransferAllowed public returns (bool) {
73         require(_to != address(0));
74         require(_value <= balances[msg.sender]);
75 
76         balances[msg.sender] = balances[msg.sender] - _value;
77         balances[_to] = balances[_to] + _value;
78         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
79         Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function balanceOf(address _owner) constant public returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed public returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[_from]);
90         require(_value <= allowed[_from][msg.sender]);
91 
92         balances[_from] = balances[_from] - _value;
93         balances[_to] = balances[_to] + _value;
94         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
95         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool) {
101         //NOTE: To prevent attack vectors like the one discussed here:
102         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
103         //clients SHOULD make sure to create user interfaces in such a way
104         //that they set the allowance first to 0 before setting it to another value for the same spender.
105 
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
112         return allowed[_owner][_spender];
113     }
114 
115     function allowTransfer() onlyOwner public {
116         transferAllowed = true;
117     }
118 
119     function mint(address _to, uint256 _value) onlyOwner saleIsOn canMint public returns (bool) {
120         require(_to != address(0));
121 
122         if(_value + totalSupply <= hardcap){
123 
124             totalSupply = totalSupply + _value;
125 
126             assert(totalSupply >= _value);
127 
128             balances[msg.sender] = balances[msg.sender] + _value;
129             assert(balances[msg.sender] >= _value);
130             Mint(msg.sender, _value);
131 
132             transfer(_to, _value);
133         }
134         return true;
135     }
136 
137     function finishMinting() onlyOwner public returns (bool) {
138         mintingFinished = true;
139         MintFinished();
140         return true;
141     }
142 
143     /**
144      * @dev Burns a specific amount of tokens.
145      * @param _value The amount of token to be burned.
146      */
147     function burn(uint256 _value) public returns (bool) {
148         require(_value <= balances[msg.sender]);
149         // no need to require value <= totalSupply, since that would imply the
150         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
151         balances[msg.sender] = balances[msg.sender] - _value;
152         totalSupply = totalSupply - _value;
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     function burnFrom(address _from, uint256 _value) public returns (bool success) {
158         require(_value <= balances[_from]);
159         require(_value <= allowed[_from][msg.sender]);
160         balances[_from] = balances[_from] - _value;
161         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
162         totalSupply = totalSupply - _value;
163         Burn(_from, _value);
164         return true;
165     }
166 
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 
171     event Mint(address indexed to, uint256 amount);
172 
173     event MintFinished();
174 
175     event Burn(address indexed burner, uint256 value);
176 
177 }