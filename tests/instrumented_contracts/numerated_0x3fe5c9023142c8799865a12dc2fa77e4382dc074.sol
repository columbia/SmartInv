1 pragma solidity ^0.4.18;
2 /** ----------------------------------------------------------------------------------------------
3  * Power_Token by Power Limited.
4  */
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 contract ERC20 {
37 
38     uint256 public totalSupply;
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45 
46     function allowance(address owner, address spender) public view returns (uint256);
47     function approve(address spender, uint256 value) public returns (bool);
48     function transferFrom(address from, address to, uint256 value) public returns (bool);
49 
50 }
51 
52 contract Ownable {
53   address public owner;
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 interface TokenRecipient {
76     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
77 }
78 
79 
80 
81 contract TokenERC20 is ERC20, Ownable{
82     // Public variables of the token
83     string public name;
84     string public symbol;
85     uint8  public decimals = 18;
86     // 18 decimals is the strongly suggested default, avoid changing it
87     using SafeMath for uint256;
88     // Balances
89     mapping (address => uint256) balances;
90     // Allowances
91     mapping (address => mapping (address => uint256)) allowances;
92 
93 
94     // ----- Events -----
95     event Burn(address indexed from, uint256 value);
96 
97     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
98         name = _tokenName;                                   // Set the name for display purposes
99         symbol = _tokenSymbol;                               // Set the symbol for display purposes
100         decimals = _decimals;
101 
102         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
103         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
104     }
105 
106     modifier onlyPayloadSize(uint size) {
107       if(msg.data.length < size + 4) {
108         revert();
109       }
110       _;
111     }
112     
113 
114     function balanceOf(address _owner) public view returns(uint256) {
115         return balances[_owner];
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256) {
119         return allowances[_owner][_spender];
120     }
121 
122     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
123         // Prevent transfer to 0x0 address. Use burn() instead
124         require(_to != 0x0);
125         // Check if the sender has enough
126         require(balances[_from] >= _value);
127         // Check for overflows
128         require(balances[_to] + _value > balances[_to]);
129 
130         require(_value >= 0);
131         // Save this for an assertion in the future
132         uint previousBalances = balances[_from].add(balances[_to]);
133          // SafeMath.sub will throw if there is not enough balance.
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         Transfer(_from, _to, _value);
137         // Asserts are used to use static analysis to find bugs in your code. They should never fail
138         assert(balances[_from] + balances[_to] == previousBalances);
139 
140         return true;
141     }
142 
143 
144     function transfer(address _to, uint256 _value) public returns(bool) {
145         return _transfer(msg.sender, _to, _value);
146     }
147 
148     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value > 0);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     function approve(address _spender, uint256 _value) public returns(bool) {
161         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
162         allowances[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
168         if (approve(_spender, _value)) {
169             TokenRecipient spender = TokenRecipient(_spender);
170             spender.receiveApproval(msg.sender, _value, this, _extraData);
171             return true;
172         }
173         return false;
174     }
175 
176   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
177     for (uint256 i = 0; i < _addresses.length; i++) {
178       require(_addresses[i] != address(0));
179       require(_amounts[i] <= balances[msg.sender]);
180       require(_amounts[i] > 0);
181 
182       // SafeMath.sub will throw if there is not enough balance.
183       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
184       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
185       Transfer(msg.sender, _addresses[i], _amounts[i]);
186     }
187     return true;
188   }
189 
190     /**
191      * Destroy tokens
192      *
193      * Remove `_value` tokens from the system irreversibly
194      *
195      * @param _value the amount of money to burn
196      */
197     function burn(uint256 _value) public returns(bool) {
198         require(balances[msg.sender] >= _value);   // Check if the sender has enough
199         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
200         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
201         Burn(msg.sender, _value);
202         return true;
203     }
204 
205         /**
206      * Destroy tokens from other account
207      *
208      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
209      *
210      * @param _from the address of the sender
211      * @param _value the amount of money to burn
212      */
213     function burnFrom(address _from, uint256 _value) public returns(bool) {
214         require(balances[_from] >= _value);                // Check if the targeted balance is enough
215         require(_value <= allowances[_from][msg.sender]);    // Check allowance
216         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
217         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
218         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
219         Burn(_from, _value);
220         return true;
221     }
222 
223 
224     /**
225      * approve should be called when allowances[_spender] == 0. To increment
226      * allowances value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      */
230     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231         // Check for overflows
232         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
233 
234         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
235         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
236         return true;
237     }
238 
239     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240         uint oldValue = allowances[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowances[msg.sender][_spender] = 0;
243         } else {
244             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245         }
246         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
247         return true;
248     }
249 
250 
251 }
252 
253 
254 contract PowerToken is TokenERC20 {
255 
256     function PowerToken() TokenERC20(100000000, "ZhouLei Token", "ZLT", 18) public {
257 
258     }
259 }