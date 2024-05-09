1 pragma solidity ^0.4.24;
2 
3  /* @title My advance Token ERC20
4  */
5 
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, reverts on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b);
19 
20     return c;
21   }
22     /**
23   * @dev Integer
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); 
27     uint256 c = a / b;
28 
29     return c;
30   }
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b <= a);
33     uint256 c = a - b;
34 
35     return c;
36   }
37   
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     require(c >= a);
41 
42     return c;
43   }
44 
45     /**
46   * reverts when dividing by zero.
47   */
48   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b != 0);
50     return a % b;
51   }
52 }
53 
54 
55 contract owned {
56     address public owner;
57 
58     constructor() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address newOwner) onlyOwner public {
68         owner = newOwner;
69     }
70 }
71     /**
72      * Constrctor function
73      */
74 
75 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
76 
77 contract TokenERC20 is owned{
78     using SafeMath for uint256;
79 
80     string public name = "WooZooMusic";
81     string public symbol = "WZM";
82     uint8 public decimals = 18;
83     uint256 public totalSupply = 500000000000000000000000000;
84     bool public released = true;
85 
86     mapping (address => uint256) public balanceOf;
87     mapping (address => mapping (address => uint256)) public allowance;
88     event Transfer(address indexed from, address indexed to, uint256 value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90     event Burn(address indexed from, uint256 value);
91 
92     
93     constructor(
94         uint256 initialSupply,
95         string tokenName,
96         string tokenSymbol
97     ) public {
98         totalSupply = initialSupply * 10 ** uint256(decimals);  
99         balanceOf[msg.sender] = 0;                
100         name = "WooZooMusic";                                  
101         symbol = "WZM";                              
102     }
103 
104 
105     function release() public onlyOwner{
106       require (owner == msg.sender);
107       released = !released;
108     }
109 
110 
111     modifier onlyReleased() {
112       require(released);
113       _;
114     }
115 
116     /**
117      * Transfer tokens
118      */
119 
120     function _transfer(address _from, address _to, uint _value) internal onlyReleased {
121         require(_to != 0x0);
122         require(balanceOf[_from] >= _value);
123         require(balanceOf[_to] + _value > balanceOf[_to]);
124         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
125         balanceOf[_from] = balanceOf[_from].sub(_value);
126         balanceOf[_to] = balanceOf[_to].add(_value);
127         emit Transfer(_from, _to, _value);
128         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
129     }
130 
131 
132 
133     function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {
134         _transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138         /**
139      * Transfer tokens from other address
140      */
141 
142     function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {
143         require(_value <= allowance[_from][msg.sender]);    
144 
145         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
146         _transfer(_from, _to, _value);
147         return true;
148     }
149 
150     function approve(address _spender, uint256 _value) public onlyReleased
151         returns (bool success) {
152         require(_spender != address(0));
153 
154         allowance[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159 
160 
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public onlyReleased
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      */
174 
175 
176     function burn(uint256 _value) public onlyReleased returns (bool success) {
177         require(balanceOf[msg.sender] >= _value);   
178         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);           
179         totalSupply = totalSupply.sub(_value);                     
180         emit Burn(msg.sender, _value);
181         return true;
182     }
183 
184      /**
185      * Destroy tokens from other account
186      */
187 
188 
189     function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {
190         require(balanceOf[_from] >= _value);               
191         require(_value <= allowance[_from][msg.sender]);   
192         balanceOf[_from] = balanceOf[_from].sub(_value);                         
193         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);           
194         totalSupply = totalSupply.sub(_value);                              
195         emit Burn(_from, _value);
196         return true;
197     }
198 }
199 contract WooZooMusic is owned, TokenERC20 {
200 
201     mapping (address => bool) public frozenAccount;
202     event FrozenFunds(address target, bool frozen);
203     constructor(
204         uint256 initialSupply,
205         string tokenName,
206         string tokenSymbol
207     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
208     }
209 
210       function _transfer(address _from, address _to, uint _value) internal onlyReleased {
211         require (_to != 0x0);                               
212         require (balanceOf[_from] >= _value);               
213         require (balanceOf[_to] + _value >= balanceOf[_to]); 
214         require(!frozenAccount[_from]);                  
215         require(!frozenAccount[_to]);  
216         balanceOf[_from] = balanceOf[_from].sub(_value);                        
217         balanceOf[_to] = balanceOf[_to].add(_value);   
218         emit Transfer(_from, _to, _value);
219     }
220 
221     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
222         require (mintedAmount > 0);
223         totalSupply = totalSupply.add(mintedAmount);
224         balanceOf[target] = balanceOf[target].add(mintedAmount);
225         emit Transfer(0, this, mintedAmount);
226         emit Transfer(this, target, mintedAmount);
227     }
228 
229     function freezeAccount(address target, bool freeze) onlyOwner public {
230         frozenAccount[target] = freeze;
231         emit FrozenFunds(target, freeze);
232     }
233 
234 }