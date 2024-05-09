1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender)
13         public view returns (uint256);
14 
15     function transferFrom(address from, address to, uint256 value)
16         public returns (bool);
17 
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(
20     address indexed owner,
21     address indexed spender,
22     uint256 value
23     );
24 }
25 
26 
27 
28 library SafeMath {
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         if (a == 0) {
32             return 0;
33         }
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a / b;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 
56 
57 contract BasicToken is ERC20Basic {
58     using SafeMath for uint256;
59 
60     mapping(address => uint256) balances;
61 
62     uint256 totalSupply_;
63 
64     function totalSupply() public view returns (uint256) {
65         return totalSupply_;
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         require(_to != address(0));
70         require(_value <= balances[msg.sender]);
71 
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         emit Transfer(msg.sender, _to, _value);
75         return true;
76     }
77   
78     function balanceOf(address _owner) public view returns (uint256) {
79         return balances[_owner];
80     }
81 
82 }
83 
84 contract BurnableToken is BasicToken {
85 
86     event Burn(address indexed burner, uint256 value);
87 
88   /**
89    * @dev Burns a specific amount of tokens.
90    * @param _value The amount of token to be burned.
91    */
92     function burn(uint256 _value) public {
93         _burn(msg.sender, _value);
94     }
95 
96     function _burn(address _who, uint256 _value) internal {
97         require(_value <= balances[_who]);
98 
99         balances[_who] = balances[_who].sub(_value);
100         totalSupply_ = totalSupply_.sub(_value);
101         emit Burn(_who, _value);
102         emit Transfer(_who, address(0), _value);
103     }
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     function transferFrom(
111         address _from,
112         address _to,
113         uint256 _value
114     )
115         public
116         returns (bool)
117     {
118         require(_to != address(0));
119         require(_value <= balances[_from]);
120         require(_value <= allowed[_from][msg.sender]);
121 
122         balances[_from] = balances[_from].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125         emit Transfer(_from, _to, _value);
126         return true;
127     }
128 
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136 
137     function allowance(
138         address _owner,
139         address _spender
140     )
141     public
142     view
143     returns (uint256)
144     {
145         return allowed[_owner][_spender];
146     }
147 
148 
149     function increaseApproval(
150         address _spender,
151         uint _addedValue
152     )
153     public
154     returns (bool)
155     {
156         allowed[msg.sender][_spender] = (
157         allowed[msg.sender][_spender].add(_addedValue));
158         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162 
163     function decreaseApproval(
164         address _spender,
165         uint _subtractedValue
166     )
167         public
168         returns (bool)
169     {
170         uint oldValue = allowed[msg.sender][_spender];
171         if (_subtractedValue > oldValue) {
172             allowed[msg.sender][_spender] = 0;
173         } else {
174             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175         }
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179 
180 }
181 
182 
183 contract NRXtoken is StandardToken, BurnableToken {
184     string public constant name = "Neironix";
185     string public constant symbol = "NRX";
186     uint32 public constant decimals = 18;
187     uint256 public INITIAL_SUPPLY = 140000000 * 1 ether;
188     address public CrowdsaleAddress;
189     bool public lockTransfers = false;
190 
191     event AcceptToken(address indexed from, uint256 value);
192 
193     constructor(address _CrowdsaleAddress) public {
194         CrowdsaleAddress = _CrowdsaleAddress;
195         totalSupply_ = INITIAL_SUPPLY;
196         balances[msg.sender] = INITIAL_SUPPLY;      
197     }
198   
199     modifier onlyOwner() {
200         // only Crowdsale contract
201         require(msg.sender == CrowdsaleAddress);
202         _;
203     }
204 
205      // Override
206     function transfer(address _to, uint256 _value) public returns(bool){
207         if (msg.sender != CrowdsaleAddress){
208             require(!lockTransfers, "Transfers are prohibited in Crowdsale period");
209         }
210         return super.transfer(_to,_value);
211     }
212 
213      // Override
214     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
215         if (msg.sender != CrowdsaleAddress){
216             require(!lockTransfers, "Transfers are prohibited in Crowdsale period");
217         }
218         return super.transferFrom(_from,_to,_value);
219     }
220 
221     /**
222      * @dev function accept tokens from users as a payment for servises and burn their
223      * @dev can run only from crowdsale contract
224     */
225     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
226         require (balances[_from] >= _value);
227         balances[_from] = balances[_from].sub(_value);
228         totalSupply_ = totalSupply_.sub(_value);
229         emit AcceptToken(_from, _value);
230         return true;
231     }
232 
233     /**
234      * @dev function transfer tokens from special address to users
235      * @dev can run only from crowdsale contract
236     */
237     function transferTokensFromSpecialAddress(address _from, address _to, uint256 _value) public onlyOwner returns (bool){
238         require (balances[_from] >= _value);
239         balances[_from] = balances[_from].sub(_value);
240         balances[_to] = balances[_to].add(_value);
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244 
245 
246     function lockTransfer(bool _lock) public onlyOwner {
247         lockTransfers = _lock;
248     }
249 
250 
251 
252     function() external payable {
253         revert("The token contract don`t receive ether");
254     }  
255 }