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
39 contract CRTTToken is Ownable {
40     
41     uint256 public totalSupply;
42     mapping(address => uint256) balances;
43     mapping(address => mapping(address => uint256)) allowed;
44     
45     string public constant name = "CRTT Token";
46     string public constant symbol = "CRTT";
47     uint8 public constant decimals = 18;
48 
49     uint256 constant restrictedPercent = 25; //should never be set above 100
50     address constant restrictedAddress = 0xDFfc94eb3e4cA1fef33a2aF22ECd66c724707388;
51     uint256 constant mintFinishTime = 1551448800;
52     uint256 constant transferAllowTime = 1552140000;
53     uint256 public constant hardcap = 299000000 * 1 ether;
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
116     function allowTransfer() onlyOwner public {
117         transferAllowed = true;
118     }
119     
120     function batchMint(address[] _to, uint256[] _value) onlyOwner saleIsOn canMint public returns (bool) {
121         require(_to.length == _value.length);
122         
123         uint256 valueSum = 0;
124         
125         for (uint256 i = 0; i < _to.length; i++) {
126             require(_to[i] != address(0));
127             require(_value[i] > 0);
128             
129             balances[_to[i]] = balances[_to[i]] + _value[i];
130             assert(balances[_to[i]] >= _value[i]);
131             Transfer(address(0), _to[i], _value[i]);
132             
133             valueSum = valueSum + _value[i];
134             assert(valueSum >= _value[i]);
135         }
136         
137         uint256 restrictedSum = valueSum * restrictedPercent;
138         assert(restrictedSum / valueSum == restrictedPercent);
139         restrictedSum = restrictedSum / (100 - restrictedPercent);
140         
141         balances[restrictedAddress] = balances[restrictedAddress] + restrictedSum;
142         assert(balances[restrictedAddress] >= restrictedSum);
143         Transfer(address(0), restrictedAddress, restrictedSum);
144         
145         uint256 totalSupplyNew = totalSupply + valueSum;
146         assert(totalSupplyNew >= valueSum);
147         totalSupplyNew = totalSupplyNew + restrictedSum;
148         assert(totalSupplyNew >= restrictedSum);
149         
150         require(totalSupplyNew <= hardcap);
151         totalSupply = totalSupplyNew;
152         
153         return true;
154     }
155     
156     function finishMinting() onlyOwner public returns (bool) {
157         mintingFinished = true;
158         MintFinished();
159         return true;
160     }
161     
162     /**
163      * @dev Burns a specific amount of tokens.
164      * @param _value The amount of token to be burned.
165      */
166     function burn(uint256 _value) public returns (bool) {
167         require(_value <= balances[msg.sender]);
168         // no need to require value <= totalSupply, since that would imply the
169         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
170         balances[msg.sender] = balances[msg.sender] - _value;
171         totalSupply = totalSupply - _value;
172         Burn(msg.sender, _value);
173         return true;
174     }
175     
176     function burnFrom(address _from, uint256 _value) public returns (bool success) {
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179         balances[_from] = balances[_from] - _value;
180         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
181         totalSupply = totalSupply - _value;
182         Burn(_from, _value);
183         return true;
184     }
185 
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 
190     event MintFinished();
191 
192     event Burn(address indexed burner, uint256 value);
193 
194 }