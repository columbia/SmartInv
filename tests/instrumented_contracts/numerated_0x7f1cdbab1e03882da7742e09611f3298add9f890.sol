1 /**
2      *-------------------------------------
3      *        --EARTHBI--
4      *-------------------------------------
5      * --ERC20 COMPATIBLE TOKEN
6      * --ETHEREUM BLOCKCHAIN
7      * --Name: ERA
8      * --Symbol: ERA
9      * --Total Supply: 955 MLN (max supply)
10      * --Decimal: 18
11      * ------------------------------------
12      * --Created by CRYPTODIAMOND SRL
13      * --Property of Bio Valore World S.p.A - Società Benefit
14      */
15 
16 pragma solidity ^0.4.25;
17 
18 /**
19  * @title SafeMath
20  * @dev Unsigned math operations with safety checks that revert on error
21  */
22 library SafeMath {
23     /**
24      * @dev Multiplies two unsigned integers, reverts on overflow.
25      */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38     /**
39      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
40      */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     /**
51      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b <= a);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     /**
61      * @dev Adds two unsigned integers, reverts on overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a);
66 
67         return c;
68     }
69 
70     /**
71      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
72      * reverts when dividing by zero.
73      */
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b != 0);
76         return a % b;
77     }
78 }
79 
80 contract owned {
81     address public owner;
82 
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address newOwner) onlyOwner public {
93         require(newOwner != 0x0); //s
94         owner = newOwner;
95     }
96 }
97 
98 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
99 
100 contract BioValue is owned{
101     
102     using SafeMath for uint; //SafeMath library
103     
104     uint private nReceivers;
105     
106     string public name;
107     string public symbol;
108     uint8 public decimals = 18;
109     uint256 public totalSupply;
110     uint256 public burned;
111     uint public percentage = 25; //x100 | 25(default) it can be change
112     
113     mapping (address => bool) public receiversBioValueAddr;
114     mapping (address => uint256) public balanceOf;
115     mapping (address => mapping (address => uint256)) public allowance;
116 
117     event Transfer(address indexed from, address indexed to, uint256 value);
118     event Burn(address indexed from, uint256 value);
119     event NewPercentageSetted(address indexed from, uint newPercentage);
120     event NewReceiver(address indexed from, address indexed _ricevente); //s
121     
122     /**
123      * Costruttore
124      *
125      * Inizializzo nel costruttore i dati del token.
126      */
127     constructor(
128         uint256 initialSupply,
129         string tokenName,
130         string tokenSymbol,
131         address _ricevente
132     ) public {
133         require(_ricevente != 0x0); //s
134         totalSupply = initialSupply * 10 ** uint256(decimals);
135         balanceOf[msg.sender] = totalSupply;  
136         name = tokenName;
137         symbol = tokenSymbol;
138         nReceivers=1; //s
139         receiversBioValueAddr[_ricevente] = true;
140         burned = 0;
141         emit Transfer(address(0), msg.sender, totalSupply);
142     }
143     
144     function setNewReceiverAddr(address _ricevente) onlyOwner public{
145         require(_ricevente != 0x0);
146         require(existReceiver(_ricevente) != true);
147         
148         receiversBioValueAddr[_ricevente] = true;
149         nReceivers++;
150         emit NewReceiver(msg.sender, _ricevente); //notifico su blockchain che è stato settato un nuovo ricevente
151     }
152     
153     function removeReceiverAddr(address _ricevente) onlyOwner public{
154         require(_ricevente != 0x0);
155         require(existReceiver(_ricevente) != false); //l'indirizzo deve esistere per essere rimosso
156         receiversBioValueAddr[_ricevente] = false;
157     }
158     
159     function setNewPercentage(uint _newPercentage) onlyOwner public{ //solo il proprietario
160         require(_newPercentage <= 100);
161         require(_newPercentage >= 0);
162         percentage = _newPercentage;
163         emit NewPercentageSetted(msg.sender, _newPercentage); //notifico su blockchain l'avvenuta modifica della percentuale
164     }
165 
166 
167     function _transfer(address _from, address _to, uint _value) internal {
168         require(_to != 0x0);
169         require(balanceOf[_from] >= _value);
170         require(balanceOf[_to] + _value > balanceOf[_to]);
171         uint previousBalances = balanceOf[_from] + balanceOf[_to];
172         balanceOf[_from] -= _value;
173         balanceOf[_to] += _value;
174         emit Transfer(_from, _to, _value);
175         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
176     }
177 
178     function _calcPercentage(uint _value, uint _percentage) internal constant returns(uint){
179         return (_value.mul(_percentage)).div(100); //s
180     }
181     
182     function _burnPercentageAndTransfer(uint _value, address _sender, address _to) internal {
183         uint toBurn = _calcPercentage(_value, percentage);
184         approve(_sender, toBurn);
185         burnFrom(_sender, toBurn);
186         _transfer(_sender, _to, _value.sub(toBurn));
187     }
188     
189     function existReceiver(address _ricevente) public constant returns(bool){
190         return receiversBioValueAddr[_ricevente];
191     }
192     
193     function getReceiversNumber() public constant returns(uint){
194         return nReceivers;
195     }
196     
197     function transfer(address _to, uint256 _value) public {
198         require(_to != address(this)); //s
199         if (existReceiver(_to)){
200             _burnPercentageAndTransfer(_value, msg.sender, _to);
201         }
202         else{
203             _transfer(msg.sender, _to, _value);
204         }
205     }
206 
207     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
208         require(_value <= allowance[_from][msg.sender]);     // Check allowance
209         allowance[_from][msg.sender] -= _value;
210         _transfer(_from, _to, _value);
211         return true;
212     }
213 
214     function approve(address _spender, uint256 _value) public
215         returns (bool success) {
216         allowance[msg.sender][_spender] = _value;
217         return true;
218     }
219 
220     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
221         public
222         returns (bool success) {
223         tokenRecipient spender = tokenRecipient(_spender);
224         if (approve(_spender, _value)) {
225             spender.receiveApproval(msg.sender, _value, this, _extraData);
226             return true;
227         }
228     }
229 
230     function burn(uint256 _value) public returns (bool success) {
231         require(balanceOf[msg.sender] >= _value);  
232         balanceOf[msg.sender] -= _value; 
233         totalSupply -= _value;
234         burned += _value; //contenitore dei token bruciati;
235         emit Burn(msg.sender, _value);
236         return true;
237     }
238 
239     function burnFrom(address _from, uint256 _value) public returns (bool success) {
240         require(balanceOf[_from] >= _value);                
241         require(_value <= allowance[_from][msg.sender]);    
242         balanceOf[_from] -= _value;                         
243         allowance[_from][msg.sender] -= _value;             
244         totalSupply -= _value;
245         burned += _value;
246         emit Burn(_from, _value);
247         return true;
248     }
249 }
250 
251 contract BioValueToken is owned, BioValue {
252 
253     mapping (address => bool) public frozenAccount;
254 
255     event FrozenFunds(address target, bool frozen); //notifico il "congelamento"
256 
257     constructor(
258         uint256 initialSupply,
259         string tokenName,
260         string tokenSymbol,
261         address _ricevente
262     ) BioValue(initialSupply, tokenName, tokenSymbol, _ricevente) public {}
263 
264     function _transfer(address _from, address _to, uint _value) internal {
265         require (_to != 0x0);                               
266         require (balanceOf[_from] >= _value);               
267         require (balanceOf[_to] + _value > balanceOf[_to]); 
268         require(!frozenAccount[_from]);                     
269         require(!frozenAccount[_to]);                       
270         balanceOf[_from] -= _value;                         
271         balanceOf[_to] += _value;                           
272         emit Transfer(_from, _to, _value);
273     }
274 
275     function freezeAccount(address target, bool freeze) onlyOwner public {
276         frozenAccount[target] = freeze;
277         emit FrozenFunds(target, freeze);
278     }
279 
280 }