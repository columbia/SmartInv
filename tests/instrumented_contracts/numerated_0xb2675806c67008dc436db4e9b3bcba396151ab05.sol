1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7         return c;
8     }
9     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12         return c;
13     }
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         require(c / a == b);
20         return c;
21     }
22     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         require(b != 0);
24         c = a / b;
25         return c;
26     }
27 }
28 
29 
30 contract owned {
31     address public owner;
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner public {
43         owner = newOwner;
44     }
45 }
46 
47 contract FSCToken is owned {
48     
49     using SafeMath for uint256;
50     
51     string public name;
52     string public symbol;
53     uint8 public decimals = 6; 
54     uint256 public totalSupply;
55     
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) allowance;
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61     event Burn(address indexed from, uint256 value);
62 
63     //Token Basic
64     constructor() public {
65         totalSupply = 1e8 * 10 ** uint256(decimals);  
66         balanceOf[msg.sender] = totalSupply;                   
67         name = "Four S Coin";                                      
68         symbol = "FSC";
69     }
70 
71     function balanceOfcheck(address _owner) public view returns (uint256 balance) {
72         return balanceOf[_owner];
73     }
74 
75     //Transfer
76     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
77         require(_to != address(0x0));
78         require(balanceOf[_from] >= _value);
79         require(balanceOf[_to] + _value > balanceOf[_to]);
80         uint previousBalances = balanceOf[_from] + balanceOf[_to];
81         balanceOf[_from] -= _value;
82         balanceOf[_to] += _value;
83         emit Transfer(_from, _to, _value);
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 
87     function transfer(address _to, uint256 _value) public returns (bool) {
88         _transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     //approve&check
100     function approve(address _spender, uint256 _value) public
101         returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106     
107     function allowancecheck(address _owner, address _spender) public view returns (uint256 remaining) {
108         return allowance[_owner][_spender];
109     }
110     
111     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
112         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
113         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
114         return true;
115     }
116     
117     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
118         uint oldValue = allowance[msg.sender][_spender];
119         if (_subtractedValue > oldValue) {
120           allowance[msg.sender][_spender] = 0;
121         } else {
122           allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123         }
124         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
125         return true;
126       }
127 
128     //Mint&Burn Token
129     function mintToken(uint256 mintedAmount) onlyOwner public {
130         uint mint=mintedAmount.mul(1e6);
131         balanceOf[owner] += mint;
132         totalSupply += mint;
133         emit Transfer(address(this), owner, mint);
134     }
135 
136     function burnToken(uint256 burnAmount)onlyOwner public returns (bool success) {
137         require(balanceOf[msg.sender] >= burnAmount);   
138         uint burn=burnAmount.mul(1e6);
139         balanceOf[owner] -= burn;            
140         totalSupply -= burn;                      
141         emit Burn(owner, burnAmount);
142         return true;
143     }
144     
145     mapping(bytes => bool) signatures;
146     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
147     
148     //transferPreSigned
149     function transferPreSigned(
150     bytes memory _signature,
151     address _to,
152     uint256 _value,
153     uint256 _fee,
154     uint _nonc)public returns (bool)
155     
156     {
157         require(_to != address(0));
158         require(signatures[_signature] == false);
159         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee,_nonc);
160         address from = recover(hashedTx, _signature);
161         require(from != address(0));
162         balanceOf[from] = balanceOf[from].sub(_value).sub(_fee);
163         balanceOf[_to] = balanceOf[_to].add(_value);
164         balanceOf[msg.sender] = balanceOf[msg.sender].add(_fee);
165         signatures[_signature] = true;
166         emit Transfer(from, _to, _value);
167         emit Transfer(from, msg.sender, _fee);
168         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
169         return true;
170     }
171     
172     function transferPreSignedHashing(
173         address _token,
174         address _to,
175         uint256 _value,
176         uint256 _fee,
177         uint _nonc
178     )
179         public
180         pure
181         returns (bytes32)
182     {
183         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
184         return (keccak256(abi.encodePacked(bytes4(0x48664c16), _token, _to, _value, _fee,_nonc)));
185     }
186     
187     function recover(bytes32 hash, bytes memory sig) public pure returns (address) {
188       bytes32  r;
189       bytes32  s;
190       uint8 v;
191        //Check the signature length
192       if (sig.length != 65) {
193         return (address(0));
194       }
195        // Divide the signature in r, s and v variables
196       assembly {
197         r := mload(add(sig, 32))
198         s := mload(add(sig, 64))
199         v := byte(0, mload(add(sig, 96)))
200       }
201        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
202       if (v < 27) {
203         v += 27;
204       }
205        // If the version is correct return the signer address
206       if (v != 27 && v != 28) {
207         return (address(0));
208       } else {
209         return ecrecover(hash, v, r, s);
210       }
211     }
212 }