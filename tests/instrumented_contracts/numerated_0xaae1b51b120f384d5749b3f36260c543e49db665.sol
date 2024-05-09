1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         require(c / a == b);
15         return c;
16     }
17     
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         require(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24     
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b <= a);
27         return a - b;
28     }
29     
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33         return c;
34     }
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44     uint256 public totalSupply;
45     function balanceOf(address who) public view returns (uint256);
46     function transfer(address to, uint256 value) public returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56     using SafeMath for uint256;
57     
58     mapping(address => uint256) balances;
59     
60     /**
61     * @dev Fix for the ERC20 short address attack.
62     */
63     modifier onlyPayloadSize(uint size) {
64         require(msg.data.length >= size + 4);
65         _;
66     }
67     
68     /**
69      * @dev transfer token for a specified address
70      * @param _to The address to transfer to.
71      * @param _value The amount to be transferred.
72      */
73     function transfer(address _to, uint256 _value) public onlyPayloadSize(32*2) returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[msg.sender]);
76         
77         // SafeMath.sub will throw if there is not enough balance.
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83     
84     /**
85      * @dev Gets the balance of the specified address.
86      * @param _owner The address to query the the balance of.
87      * @return An uint256 representing the amount owned by the passed address.
88      */
89     function balanceOf(address _owner) public view returns (uint256) {
90         return balances[_owner];
91     }
92 
93 }
94 
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101     function allowance(address owner, address spender) public view returns (uint256);
102     function transferFrom(address from, address to, uint256 value) public returns (bool);
103     function approve(address spender, uint256 value) public returns (bool);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 /**
109  * @title BurnableCADVToken interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract BurnableCADVToken is ERC20 {
113 
114     uint8 public decimals = 18;
115     string public name;
116     string public symbol;
117     
118     /**
119      * @dev set the amount of tokens that an owner allowed to a spender.
120      *  
121      * This function is disabled because using it is risky, so a revert()
122      * is always called as the first line of code.
123      * Instead of this function, use increaseApproval or decreaseApproval.
124      * 
125      * @param spender The address which will spend the funds.
126      * @param value The amount of tokens to increase the allowance by.
127      */
128     function approve(address spender, uint256 value) public returns (bool) {
129         revert();
130         spender = spender;
131         value = value;
132         return false;
133     }
134     
135     function increaseApproval(address _spender, uint _addedValue) public returns (bool);
136     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool);
137     function multipleTransfer(address[] _tos, uint256 _value) public returns (bool);
138     function burn(uint256 _value) public;
139     event Burn(address indexed burner, uint256 value);
140     
141 }
142 
143 
144 /**
145  * @title CADV
146  *
147  * @dev Implementation of the BurnableCADVToken.
148  * @dev https://github.com/oste19/CA/tokens/CADV.sol
149  */
150 contract CADV is BurnableCADVToken, BasicToken {
151 
152     mapping (address => mapping (address => uint256)) internal allowed;
153     
154     
155     function CADV (string _name, string _symbol, uint256 _totalSupply) public {
156         name = _name;
157         symbol = _symbol;
158         totalSupply = _totalSupply * 10 ** uint256(decimals);
159         balances[msg.sender] = totalSupply;
160     }   
161     
162     
163     /**
164      * @dev Transfer tokens from one address to another
165      * @param _from address The address which you want to send tokens from
166      * @param _to address The address which you want to transfer to
167      * @param _value uint256 the amount of tokens to be transferred
168      */
169     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
170         require(_to != address(0));
171         require(_value <= balances[_from]);
172         require(_value <= allowed[_from][msg.sender]);
173         
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175         balances[_from] = balances[_from].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         
178         Transfer(_from, _to, _value);
179         return true;
180     }
181 
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address _owner, address _spender) public view returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      *
197      * approve should be called when allowed[_spender] == 0. To increment
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * 
202      * @param _spender The address which will spend the funds.
203      * @param _addedValue The amount of tokens to increase the allowance by.
204      */
205     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211 
212     /**
213      * @dev Decrease the amount of tokens that an owner allowed to a spender.
214      *
215      * approve should be called when allowed[_spender] == 0. To decrement
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * @param _spender The address which will spend the funds.
220      * @param _subtractedValue The amount of tokens to decrease the allowance by.
221      */
222     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
223         uint oldValue = allowed[msg.sender][_spender];
224         if (_subtractedValue > oldValue) {
225             allowed[msg.sender][_spender] = 0;
226         } else {
227             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228         }
229         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233   
234     /**
235      * @dev Burns a specific amount of tokens.
236      * @param _value The amount of token to be burned.
237      */
238     function burn(uint256 _value) public {
239         address burner = msg.sender;
240         if (_value > balances[burner]) {
241             _value = balances[burner];
242         }
243         balances[burner] = balances[burner].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         Burn(burner, _value);
246     }
247   
248   
249     /**
250      * @dev transfer the same amount of tokens to each address of a list.
251      * 
252      * @param _tos The addresses list to transfer to.
253      * @param _value The amount to be transferred to each address.
254      * @return true is all the tranfers were successful, false otherwise.
255      */
256     function multipleTransfer(address[] _tos, uint256 _value) public returns (bool) {
257         require(_tos.length * _value <= balances[msg.sender]);
258         for (uint256 i=0; i<_tos.length; i++) {
259             if(!transfer(_tos[i], _value)) {
260                 revert();
261             }
262         }
263         return true;
264     }
265 
266 }