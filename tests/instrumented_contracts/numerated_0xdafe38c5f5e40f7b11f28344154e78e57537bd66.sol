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
39 contract CREXToken is Ownable {
40     
41     uint256 public totalSupply;
42     mapping(address => uint256) balances;
43     mapping(address => mapping(address => uint256)) allowed;
44     
45     string public constant name = "CREX Token";
46     string public constant symbol = "CRXT";
47     uint8 public constant decimals = 18;
48 
49     uint256 constant restrictedPercent = 35; //should never be set above 100
50     address constant restrictedAddress = 0x237c494b5B0164593898Fb95703c532A5340f12E;
51     uint256 constant mintFinishTime = 1551448800;
52     uint256 constant transferAllowTime = 1552140000;
53     uint256 public constant hardcap = 399000000 * 1 ether;
54     
55     bool public transferAllowed = false;
56     bool public mintingFinished = false;
57     
58     modifier whenTransferAllowed() {
59         require(transferAllowed || now > transferAllowTime);
60         _;
61     }
62 
63     modifier saleIsOn() {
64         require(now < mintFinishTime);
65         _;
66     }
67     
68     modifier canMint() {
69         require(!mintingFinished);
70         _;
71     }
72   
73     function transfer(address _to, uint256 _value) whenTransferAllowed public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[msg.sender]);
76         
77         balances[msg.sender] = balances[msg.sender] - _value;
78         balances[_to] = balances[_to] + _value;
79         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) constant public returns (uint256 balance) {
85         return balances[_owner];
86     }
87     
88     function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[_from]);
91         require(_value <= allowed[_from][msg.sender]);
92         
93         balances[_from] = balances[_from] - _value;
94         balances[_to] = balances[_to] + _value;
95         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
96         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool) {
102         //NOTE: To prevent attack vectors like the one discussed here: 
103         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
104         //clients SHOULD make sure to create user interfaces in such a way 
105         //that they set the allowance first to 0 before setting it to another value for the same spender. 
106     
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115    
116     function allowTransfer() onlyOwner public returns (bool) {
117         transferAllowed = true;
118         return true;
119     }
120     
121     function batchMint(address[] _to, uint256[] _value) onlyOwner saleIsOn canMint public returns (bool) {
122         require(_to.length == _value.length);
123         
124         uint256 valueSum = 0;
125         
126         for (uint256 i = 0; i < _to.length; i++) {
127             require(_to[i] != address(0));
128             require(_value[i] > 0);
129             
130             balances[_to[i]] = balances[_to[i]] + _value[i];
131             assert(balances[_to[i]] >= _value[i]);
132             Transfer(address(0), _to[i], _value[i]);
133             
134             valueSum = valueSum + _value[i];
135             assert(valueSum >= _value[i]);
136         }
137         
138         uint256 restrictedSum = valueSum * restrictedPercent;
139         assert(restrictedSum / valueSum == restrictedPercent);
140         restrictedSum = restrictedSum / (100 - restrictedPercent);
141         
142         balances[restrictedAddress] = balances[restrictedAddress] + restrictedSum;
143         assert(balances[restrictedAddress] >= restrictedSum);
144         Transfer(address(0), restrictedAddress, restrictedSum);
145         
146         uint256 totalSupplyNew = totalSupply + valueSum;
147         assert(totalSupplyNew >= valueSum);
148         totalSupplyNew = totalSupplyNew + restrictedSum;
149         assert(totalSupplyNew >= restrictedSum);
150         
151         require(totalSupplyNew <= hardcap);
152         totalSupply = totalSupplyNew;
153         
154         return true;
155     }
156     
157     function finishMinting() onlyOwner public returns (bool) {
158         mintingFinished = true;
159         MintFinished();
160         return true;
161     }
162     
163     /**
164      * @dev Burns a specific amount of tokens.
165      * @param _value The amount of token to be burned.
166      */
167     function burn(uint256 _value) public returns (bool) {
168         require(_value <= balances[msg.sender]);
169         // no need to require value <= totalSupply, since that would imply the
170         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
171         balances[msg.sender] = balances[msg.sender] - _value;
172         totalSupply = totalSupply - _value;
173         Burn(msg.sender, _value);
174         return true;
175     }
176     
177     function burnFrom(address _from, uint256 _value) public returns (bool success) {
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180         balances[_from] = balances[_from] - _value;
181         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
182         totalSupply = totalSupply - _value;
183         Burn(_from, _value);
184         return true;
185     }
186 
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 
191     event MintFinished();
192 
193     event Burn(address indexed burner, uint256 value);
194 
195 }